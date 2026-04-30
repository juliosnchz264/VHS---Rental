"""
Aplicación Flask para el Videoclub.
Ejecutar con:  flask run --host=0.0.0.0
O directamente: python app.py
"""
from datetime import date
from flask import Flask, render_template, request, redirect, url_for, flash
from conexion import ejecutar_consulta

app = Flask(__name__)
app.secret_key = 'cambia-esta-clave-secreta-en-produccion'


# ============================================
# HELPERS DE BASE DE DATOS
# ============================================

def listar_socios():
    return ejecutar_consulta(
        "SELECT id_socio, nombre, telefono, direccion FROM socio ORDER BY nombre",
        fetch=True
    ) or []


def listar_peliculas():
    query = """
        SELECT p.id_pelicula, p.titulo, p.numCopia, p.copiasDisp,
               g.tipo AS genero, d.nombre AS director
        FROM pelicula p
        LEFT JOIN genero g ON p.id_genero = g.id_genero
        LEFT JOIN director d ON p.id_director = d.id_director
        ORDER BY p.titulo
    """
    return ejecutar_consulta(query, fetch=True) or []


def listar_generos():
    return ejecutar_consulta(
        "SELECT id_genero, tipo FROM genero ORDER BY tipo", fetch=True
    ) or []


def listar_actores():
    return ejecutar_consulta(
        "SELECT id_actor, nombre FROM actor ORDER BY nombre", fetch=True
    ) or []


def listar_directores():
    return ejecutar_consulta(
        "SELECT id_director, nombre FROM director ORDER BY nombre", fetch=True
    ) or []


def obtener_o_crear(tabla, campo, valor):
    """Devuelve el id de un registro, creándolo si no existe."""
    id_field = f"id_{tabla}"
    res = ejecutar_consulta(
        f"SELECT {id_field} FROM {tabla} WHERE {campo} = %s",
        (valor,), fetch=True
    )
    if res:
        return res[0][id_field]
    return ejecutar_consulta(
        f"INSERT INTO {tabla} ({campo}) VALUES (%s)", (valor,)
    )


# ============================================
# RUTA PRINCIPAL (MENÚ)
# ============================================

@app.route('/')
def index():
    """Página principal con estadísticas."""
    stats = {
        'socios': len(listar_socios()),
        'peliculas': len(listar_peliculas()),
        'cintas': ejecutar_consulta("SELECT COUNT(*) AS c FROM cinta", fetch=True)[0]['c'],
        'prestamos': ejecutar_consulta("SELECT COUNT(*) AS c FROM rel_PrestActual", fetch=True)[0]['c'],
    }
    return render_template('index.html', stats=stats)


# ============================================
# A) SOCIOS
# ============================================

@app.route('/socios', methods=['GET', 'POST'])
def socios():
    if request.method == 'POST':
        nombre = request.form.get('nombre', '').strip()
        telefono = request.form.get('telefono', '').strip() or None
        direccion = request.form.get('direccion', '').strip() or None
        if not nombre:
            flash('El nombre es obligatorio', 'error')
        else:
            ejecutar_consulta(
                "INSERT INTO socio (nombre, telefono, direccion) VALUES (%s, %s, %s)",
                (nombre, telefono, direccion)
            )
            flash(f'Socio "{nombre}" añadido correctamente', 'success')
            return redirect(url_for('socios'))
    return render_template('socios.html', socios=listar_socios())


# ============================================
# B) PELÍCULAS
# ============================================

@app.route('/peliculas', methods=['GET', 'POST'])
def peliculas():
    if request.method == 'POST':
        titulo = request.form.get('titulo', '').strip()
        nombre_director = request.form.get('director', '').strip()
        id_genero = request.form.get('id_genero')
        num_copias = int(request.form.get('num_copias', 1))
        actores_str = request.form.get('actores', '').strip()

        if not titulo or not nombre_director or not id_genero:
            flash('Título, director y género son obligatorios', 'error')
            return redirect(url_for('peliculas'))

        # Obtener/crear director
        id_director = obtener_o_crear('director', 'nombre', nombre_director)

        # Insertar película
        id_pelicula = ejecutar_consulta(
            """INSERT INTO pelicula (titulo, numCopia, copiasDisp, id_genero, id_director)
               VALUES (%s, %s, %s, %s, %s)""",
            (titulo, num_copias, num_copias, id_genero, id_director)
        )

        # Crear cintas
        for i in range(1, num_copias + 1):
            codigo = f"P{id_pelicula:04d}-C{i:03d}"
            ejecutar_consulta(
                "INSERT INTO cinta (codigo, id_pelicula) VALUES (%s, %s)",
                (codigo, id_pelicula)
            )

        # Procesar actores (separados por comas)
        if actores_str:
            for nombre_actor in actores_str.split(','):
                nombre_actor = nombre_actor.strip()
                if nombre_actor:
                    id_actor = obtener_o_crear('actor', 'nombre', nombre_actor)
                    ejecutar_consulta(
                        "INSERT IGNORE INTO rel_Reparto (id_actor, id_pelicula) VALUES (%s, %s)",
                        (id_actor, id_pelicula)
                    )

        flash(f'Película "{titulo}" añadida con {num_copias} cinta(s)', 'success')
        return redirect(url_for('peliculas'))

    return render_template(
        'peliculas.html',
        peliculas=listar_peliculas(),
        generos=listar_generos()
    )


# ============================================
# C) GESTIÓN DE PELÍCULAS (PRÉSTAMOS)
# ============================================

@app.route('/prestamos')
def prestamos():
    """Vista de préstamos activos."""
    query = """
        SELECT pa.id, pa.fechaPrestamo, s.nombre AS socio,
               c.codigo AS cinta, p.titulo
        FROM rel_PrestActual pa
        JOIN socio s ON pa.id_socio = s.id_socio
        JOIN cinta c ON pa.id_cinta = c.id_cinta
        JOIN pelicula p ON c.id_pelicula = p.id_pelicula
        ORDER BY pa.fechaPrestamo DESC
    """
    activos = ejecutar_consulta(query, fetch=True) or []
    return render_template(
        'prestamos.html',
        activos=activos,
        socios=listar_socios(),
        peliculas=listar_peliculas()
    )


@app.route('/prestamos/nuevo', methods=['POST'])
def prestar():
    """Prestar una película a un socio."""
    id_socio = request.form.get('id_socio')
    id_pelicula = request.form.get('id_pelicula')

    if not id_socio or not id_pelicula:
        flash('Debes seleccionar socio y película', 'error')
        return redirect(url_for('prestamos'))

    # Buscar cinta disponible
    cintas = ejecutar_consulta(
        """SELECT c.id_cinta, c.codigo FROM cinta c
           WHERE c.id_pelicula = %s
             AND c.id_cinta NOT IN (SELECT id_cinta FROM rel_PrestActual)
           LIMIT 1""",
        (id_pelicula,), fetch=True
    )

    if not cintas:
        flash('No hay cintas disponibles de esa película', 'error')
        return redirect(url_for('prestamos'))

    cinta = cintas[0]
    ejecutar_consulta(
        """INSERT INTO rel_PrestActual (fechaPrestamo, id_socio, id_cinta)
           VALUES (%s, %s, %s)""",
        (date.today(), id_socio, cinta['id_cinta'])
    )
    ejecutar_consulta(
        "UPDATE pelicula SET copiasDisp = copiasDisp - 1 WHERE id_pelicula = %s",
        (id_pelicula,)
    )
    flash(f'Cinta "{cinta["codigo"]}" prestada correctamente', 'success')
    return redirect(url_for('prestamos'))


@app.route('/prestamos/<int:id_prestamo>/devolver')
def devolver_form(id_prestamo):
    """Formulario de devolución con preguntas de gustos."""
    query = """
        SELECT pa.id, pa.id_socio, s.nombre AS socio_nombre,
               c.id_cinta, c.codigo AS cinta_codigo,
               p.id_pelicula, p.titulo, p.id_genero, p.id_director,
               g.tipo AS genero_tipo, d.nombre AS director_nombre
        FROM rel_PrestActual pa
        JOIN socio s ON pa.id_socio = s.id_socio
        JOIN cinta c ON pa.id_cinta = c.id_cinta
        JOIN pelicula p ON c.id_pelicula = p.id_pelicula
        LEFT JOIN genero g ON p.id_genero = g.id_genero
        LEFT JOIN director d ON p.id_director = d.id_director
        WHERE pa.id = %s
    """
    res = ejecutar_consulta(query, (id_prestamo,), fetch=True)
    if not res:
        flash('Préstamo no encontrado', 'error')
        return redirect(url_for('prestamos'))

    prestamo = res[0]
    actores = ejecutar_consulta(
        """SELECT a.id_actor, a.nombre FROM actor a
           JOIN rel_Reparto r ON a.id_actor = r.id_actor
           WHERE r.id_pelicula = %s""",
        (prestamo['id_pelicula'],), fetch=True
    ) or []

    return render_template('devolver.html', prestamo=prestamo, actores=actores)


@app.route('/prestamos/<int:id_prestamo>/devolver', methods=['POST'])
def devolver(id_prestamo):
    """Procesar la devolución y registrar gustos."""
    # Recuperar datos del préstamo
    res = ejecutar_consulta(
        """SELECT pa.id_socio, c.id_cinta, p.id_pelicula
           FROM rel_PrestActual pa
           JOIN cinta c ON pa.id_cinta = c.id_cinta
           JOIN pelicula p ON c.id_pelicula = p.id_pelicula
           WHERE pa.id = %s""",
        (id_prestamo,), fetch=True
    )
    if not res:
        flash('Préstamo no encontrado', 'error')
        return redirect(url_for('prestamos'))

    p = res[0]
    id_socio = p['id_socio']
    id_pelicula = p['id_pelicula']

    # Pasar al historial
    ejecutar_consulta(
        """INSERT INTO rel_PrestDevuelto (fechaDev, id_socio, id_cinta)
           VALUES (%s, %s, %s)""",
        (date.today(), id_socio, p['id_cinta'])
    )
    # Quitar de préstamos activos
    ejecutar_consulta("DELETE FROM rel_PrestActual WHERE id = %s", (id_prestamo,))
    # Recuperar copia disponible
    ejecutar_consulta(
        "UPDATE pelicula SET copiasDisp = copiasDisp + 1 WHERE id_pelicula = %s",
        (id_pelicula,)
    )

    # Registrar gustos según los checkboxes
    if request.form.get('gusta_genero'):
        id_g = request.form.get('id_genero')
        if id_g:
            ejecutar_consulta(
                "INSERT IGNORE INTO gustaGenero (id_socio, id_genero) VALUES (%s, %s)",
                (id_socio, id_g)
            )
    if request.form.get('gusta_director'):
        id_d = request.form.get('id_director')
        if id_d:
            ejecutar_consulta(
                "INSERT IGNORE INTO gustaDirector (id_socio, id_director) VALUES (%s, %s)",
                (id_socio, id_d)
            )
    # Actores: vienen como gusta_actor_<id>
    for key in request.form:
        if key.startswith('gusta_actor_'):
            id_actor = key.replace('gusta_actor_', '')
            ejecutar_consulta(
                "INSERT IGNORE INTO gustaActor (id_socio, id_actor) VALUES (%s, %s)",
                (id_socio, id_actor)
            )

    flash('Cinta devuelta y preferencias registradas', 'success')
    return redirect(url_for('prestamos'))


# ============================================
# D) DEFINIR PREFERENCIAS
# ============================================

@app.route('/preferencias', methods=['GET', 'POST'])
def preferencias():
    if request.method == 'POST':
        id_socio = request.form.get('id_socio')
        tipo = request.form.get('tipo')  # genero, actor, director
        id_item = request.form.get('id_item')

        if not (id_socio and tipo and id_item):
            flash('Faltan datos', 'error')
            return redirect(url_for('preferencias'))

        tablas = {
            'genero': ('gustaGenero', 'id_genero'),
            'actor': ('gustaActor', 'id_actor'),
            'director': ('gustaDirector', 'id_director'),
        }
        tabla, campo = tablas[tipo]
        ejecutar_consulta(
            f"INSERT IGNORE INTO {tabla} (id_socio, {campo}) VALUES (%s, %s)",
            (id_socio, id_item)
        )
        flash('Preferencia añadida', 'success')
        return redirect(url_for('preferencias', socio=id_socio))

    id_socio_filtro = request.args.get('socio')
    return render_template(
        'preferencias.html',
        socios=listar_socios(),
        generos=listar_generos(),
        actores=listar_actores(),
        directores=listar_directores(),
        socio_seleccionado=id_socio_filtro
    )


# ============================================
# E) VISUALIZAR PREFERENCIAS
# ============================================

@app.route('/preferencias/ver')
@app.route('/preferencias/ver/<int:id_socio>')
def ver_preferencias(id_socio=None):
    socios = listar_socios()
    datos = None
    socio = None

    if id_socio:
        res = ejecutar_consulta(
            "SELECT * FROM socio WHERE id_socio = %s", (id_socio,), fetch=True
        )
        if res:
            socio = res[0]
            datos = {
                'generos': ejecutar_consulta(
                    """SELECT g.tipo FROM gustaGenero gg
                       JOIN genero g ON gg.id_genero = g.id_genero
                       WHERE gg.id_socio = %s ORDER BY g.tipo""",
                    (id_socio,), fetch=True
                ) or [],
                'actores': ejecutar_consulta(
                    """SELECT a.nombre FROM gustaActor ga
                       JOIN actor a ON ga.id_actor = a.id_actor
                       WHERE ga.id_socio = %s ORDER BY a.nombre""",
                    (id_socio,), fetch=True
                ) or [],
                'directores': ejecutar_consulta(
                    """SELECT d.nombre FROM gustaDirector gd
                       JOIN director d ON gd.id_director = d.id_director
                       WHERE gd.id_socio = %s ORDER BY d.nombre""",
                    (id_socio,), fetch=True
                ) or [],
            }

    return render_template(
        'ver_preferencias.html',
        socios=socios,
        socio=socio,
        datos=datos
    )


# ============================================
# MAIN
# ============================================

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)