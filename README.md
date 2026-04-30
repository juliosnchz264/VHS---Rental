# 🎬 VHS·RENTAL — Aplicación web Flask

Aplicación web para gestionar el videoclub, conectada a la BD MariaDB `videoclub`.

## 📁 Estructura

```
videoclub_flask/
├── app.py                # Aplicación Flask (rutas)
├── conexion.py           # Conexión a MariaDB
├── static/
│   └── style.css         # Estilos retro VHS
└── templates/
    ├── base.html         # Plantilla base
    ├── index.html        # Menú principal
    ├── socios.html       # A) Socios
    ├── peliculas.html    # B) Películas
    ├── prestamos.html    # C) Préstamos activos
    ├── devolver.html     # C) Devolución con preguntas de gustos
    ├── preferencias.html # D) Definir preferencias
    └── ver_preferencias.html  # E) Visualizar preferencias
```

## 🛠️ Instalación en Debian Server

1. **Instala las dependencias** (si no las tienes):
   ```bash
   sudo apt install python3-pip python3-flask
   pip3 install mysql-connector-python
   ```

2. **Edita `conexion.py`** y pon tu contraseña de MariaDB:
   ```python
   CONFIG = {
       'host': 'localhost',
       'user': 'root',
       'password': 'TU_PASSWORD_AQUÍ',
       'database': 'videoclub',
       'charset': 'utf8mb4'
   }
   ```

3. **Asegúrate de tener la BD creada** y los géneros insertados (mínimo).

## 🚀 Ejecución

### Opción A: con `flask run`

```bash
cd videoclub_flask
export FLASK_APP=app.py
export FLASK_ENV=development
flask run --host=0.0.0.0 --port=5000
```

### Opción B: directamente con Python

```bash
cd videoclub_flask
python3 app.py
```

## 🌐 Acceso desde Windows 11

Una vez corriendo en tu Debian Server (con bridge adapter), abre el navegador en Windows:

```
http://192.168.1.168:5000
```

### Si no puedes acceder, comprueba:

- **Firewall del Debian** (ufw): abre el puerto 5000
  ```bash
  sudo ufw allow 5000/tcp
  ```
- **Que estás escuchando en 0.0.0.0** y no en 127.0.0.1 (lo está, por la flag `--host=0.0.0.0`)
- **Que la IP es correcta**: en Debian ejecuta `ip a` para ver la IP del bridge adapter
- **Conectividad de red**: desde Windows haz `ping 192.168.1.168`

## 🎨 Características

- **Estética retro años 80**: neones, scanlines de TV CRT, tipografías VHS
- **A) Socios**: alta y listado con tabla
- **B) Películas**: alta con director (creado al vuelo), género, copias y reparto
- **C) Préstamos**: prestar película (asigna cinta disponible automáticamente), ver activos y devolver
- **C·devolución**: formulario con checkboxes para marcar género, director y actores que le gustaron
- **D) Preferencias**: añadir gustos manualmente por tipo
- **E) Visualizar**: ficha del socio con todos sus gustos por categoría

## 🔧 Modo producción

Para producción NO uses `flask run` (es solo para desarrollo). Usa Gunicorn:

```bash
pip3 install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```