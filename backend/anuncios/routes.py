
from flask import Blueprint, jsonify
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
