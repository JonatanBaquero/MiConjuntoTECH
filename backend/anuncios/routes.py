
from flask import Blueprint, jsonify, request
from datetime import datetime
from database.conexion import obtener_conexion

anuncios_bp = Blueprint("anuncios", __name__, url_prefix="/api/anuncios")


@anuncios_bp.route("/", methods=["GET"])
def listar_anuncios():
    conexion = None
    cursor = None

    try:
        conexion = obtener_conexion()
        cursor = conexion.cursor(dictionary=True)

        consulta = """
            SELECT
                id_anuncio,
                titulo,
                contenido,
                fecha_publicacion,
                estado,
                id_admin
            FROM Anuncio
            WHERE estado = 'ACTIVO'
            ORDER BY fecha_publicacion DESC, id_anuncio DESC
        """

        cursor.execute(consulta)
        anuncios = cursor.fetchall()

        for anuncio in anuncios:
            if anuncio["fecha_publicacion"] is not None:
                anuncio["fecha_publicacion"] = (
                    anuncio["fecha_publicacion"].isoformat()
                )

        return jsonify(anuncios), 200

    except Exception:
        return jsonify({
            "error": "No fue posible consultar los anuncios."
        }), 500

    finally:
        if cursor is not None:
            cursor.close()

        if conexion is not None and conexion.is_connected():
            conexion.close()

@anuncios_bp.route("/<int:id_anuncio>", methods=["DELETE"])
def eliminar_anuncio(id_anuncio):
    conexion = None
    cursor = None

    try:
        conexion = obtener_conexion()
        cursor = conexion.cursor()

        consulta = """
            UPDATE Anuncio
            SET estado = 'ELIMINADO'
            WHERE id_anuncio = %s
              AND estado = 'ACTIVO'
        """

        cursor.execute(consulta, (id_anuncio,))

        if cursor.rowcount == 0:
            conexion.rollback()
            return jsonify({
                "error": "El anuncio no existe o ya fue eliminado."
            }), 404

        conexion.commit()

        return jsonify({
            "mensaje": "Anuncio eliminado correctamente."
        }), 200

    except Exception:
        if conexion is not None:
            conexion.rollback()

        return jsonify({
            "error": "No fue posible eliminar el anuncio."
        }), 500

    finally:
        if cursor is not None:
            cursor.close()

        if conexion is not None and conexion.is_connected():
            conexion.close()


@anuncios_bp.route("/", methods=["POST"])
def crear_anuncio():
    datos = request.get_json(silent=True)

    if not isinstance(datos, dict):
        return jsonify({
            "error": "No se recibieron datos válidos."
        }), 400

    titulo = datos.get("titulo")
    contenido = datos.get("contenido")
    fecha_publicacion = datos.get("fecha_publicacion")
    id_admin = datos.get("id_admin")

    # Validar los campos de texto
    if not isinstance(titulo, str) or not titulo.strip():
        return jsonify({
            "error": "El título es obligatorio."
        }), 400

    titulo = titulo.strip()

    if len(titulo) > 150:
        return jsonify({
            "error": "El título no puede superar los 150 caracteres."
        }), 400

    if not isinstance(contenido, str) or not contenido.strip():
        return jsonify({
            "error": "El contenido es obligatorio."
        }), 400

    contenido = contenido.strip()

    # Validar la fecha
    try:
        datetime.strptime(fecha_publicacion, "%Y-%m-%d")
    except (ValueError, TypeError):
        return jsonify({
            "error": "La fecha de publicación no es válida."
        }), 400

    # Validar el ID del administrador
    try:
        if isinstance(id_admin, bool):
            raise ValueError

        id_admin = int(id_admin)

        if id_admin <= 0:
            raise ValueError

    except (ValueError, TypeError):
        return jsonify({
            "error": "El ID del administrador debe ser un entero positivo."
        }), 400

    conexion = None
    cursor = None

    try:
        conexion = obtener_conexion()
        cursor = conexion.cursor()

        consulta = """
            INSERT INTO Anuncio (
                titulo,
                contenido,
                fecha_publicacion,
                estado,
                id_admin
            )
            VALUES (%s, %s, %s, 'ACTIVO', %s)
        """

        valores = (
            titulo,
            contenido,
            fecha_publicacion,
            id_admin
        )

        cursor.execute(consulta, valores)
        conexion.commit()

        nuevo_id = cursor.lastrowid

        return jsonify({
            "mensaje": "Anuncio creado correctamente.",
            "id_anuncio": nuevo_id
        }), 201

    except Exception:
        if conexion is not None:
            conexion.rollback()

        return jsonify({
            "error": "No fue posible guardar el anuncio. Verifica que el ID del administrador exista en la base de datos."
        }), 500

    finally:
        if cursor is not None:
            cursor.close()

        if conexion is not None and conexion.is_connected():
            conexion.close()
