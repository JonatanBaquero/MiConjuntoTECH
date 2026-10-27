from flask import Flask, jsonify, render_template
from anuncios.routes import anuncios_bp


app = Flask(__name__)
#Registro de endponits

app.register_blueprint(anuncios_bp)

@app.route("/")
def inicio():
    return jsonify({
        "mensaje": "Backend de MiConjuntoTECH funcionando correctamente",
        "modulo": "Anuncios"
    })


if __name__ == "__main__":
    app.run(debug=True)