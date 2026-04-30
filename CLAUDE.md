# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Running the app

```bash
# Development (venv already at ./venv/)
source venv/bin/activate
python app.py
# or
flask run --host=0.0.0.0 --port=5000
```

Production:
```bash
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

App runs at `http://192.168.1.168:5000` (Debian server with bridge adapter).

## Database

MariaDB `videoclub` at `192.168.1.168`. Credentials in `conexion.py` (`CONFIG` dict). Driver: `mysql-connector-python`.

`ejecutar_consulta(query, params, fetch)` in [conexion.py](conexion.py) is the only DB interface — opens and closes a connection per call (no pooling). Returns list of dicts when `fetch=True`, `lastrowid` when `fetch=False`.

## Architecture

Single-file Flask app ([app.py](app.py)) with five sections:

| Section | Routes | Description |
|---------|--------|-------------|
| A | `/socios` | Member management |
| B | `/peliculas` | Movie management — creates `cinta` rows and auto-creates `director`/`actor` records via `obtener_o_crear()` |
| C | `/prestamos`, `/prestamos/nuevo`, `/prestamos/<id>/devolver` | Loan lifecycle — assigns first available `cinta`, moves record from `rel_PrestActual` to `rel_PrestDevuelto` on return, updates `copiasDisp` |
| D | `/preferencias` | Manually add member taste preferences |
| E | `/preferencias/ver/<id_socio>` | View member taste profile |

### Key DB tables

- `pelicula` — has `numCopia` (total) and `copiasDisp` (available); both must stay in sync
- `cinta` — physical copy, code format `P{id_pelicula:04d}-C{copy_num:03d}`
- `rel_PrestActual` — active loans; a `cinta` is "available" when absent from this table
- `rel_PrestDevuelto` — return history
- `gustaGenero`, `gustaActor`, `gustaDirector` — taste preference tables, use `INSERT IGNORE`
- `rel_Reparto` — actor↔movie relationship

### Templates

All extend [templates/base.html](templates/base.html). Flash messages use categories `success`/`error`. Retro 80s VHS aesthetic (neon, scanlines, CRT fonts).
