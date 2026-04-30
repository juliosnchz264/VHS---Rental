"""
Copia este archivo a conexion.py y rellena tus datos de conexión.
"""
import mysql.connector
from mysql.connector import Error

CONFIG = {
    'host': 'localhost',
    'user': 'TU_USUARIO',
    'password': 'TU_PASSWORD',
    'database': 'videoclub',
    'charset': 'utf8mb4'
}


def conectar():
    try:
        return mysql.connector.connect(**CONFIG)
    except Error as e:
        print(f"❌ Error de conexión: {e}")
        return None


def ejecutar_consulta(query, params=None, fetch=False):
    """
    Ejecuta una consulta SQL.
    - fetch=True para SELECT (devuelve lista de dicts)
    - fetch=False para INSERT/UPDATE/DELETE (devuelve lastrowid)
    """
    conn = conectar()
    if conn is None:
        return None
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query, params or ())
        if fetch:
            resultado = cursor.fetchall()
        else:
            conn.commit()
            resultado = cursor.lastrowid
        cursor.close()
        return resultado
    except Error as e:
        print(f"❌ Error en consulta: {e}")
        conn.rollback()
        return None
    finally:
        conn.close()
