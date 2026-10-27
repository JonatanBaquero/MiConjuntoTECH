
from database.conexion import obtener_conexion


try:
    conexion = obtener_conexion()

    if conexion.is_connected():
        print("Conexión exitosa con MySQL.")
        print("Base de datos:", conexion.database)

except Exception as error:
    print("Error al conectar con MySQL:", error)

finally:
    if "conexion" in locals() and conexion.is_connected():
        conexion.close()
        print("Conexión cerrada.")
