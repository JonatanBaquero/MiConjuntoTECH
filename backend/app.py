from flask import Flask, jsonify, render_template
from anuncios.routes import anuncios_bp
from flask_cors import CORS




app = Flask(__name__)

CORS(
    app,
    resources={
        r"/api/*": {
            "origins": [
                "http://127.0.0.1:5500",
                "http://localhost:5500"
            ]
        }
    }
)

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