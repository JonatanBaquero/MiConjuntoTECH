
const API_ANUNCIOS = "http://127.0.0.1:5000/api/anuncios/";

const cuerpoTabla = document.getElementById("anuncios-body");
const mensaje = document.getElementById("mensaje-anuncios");
const buscador = document.getElementById("anuncio-search");
const formularioBusqueda = document.getElementById("form-busqueda");

let anuncios = [];

// Formatea la fecha recibida desde la API.
function formatearFecha(fecha) {
    if (!fecha) {
        return "Sin fecha";
    }

    const partes = fecha.split("-");

    if (partes.length !== 3) {
        return fecha;
    }

    return `${partes[2]}/${partes[1]}/${partes[0]}`;
}

// Crea una celda de tabla usando texto seguro.
function crearCelda(texto) {
    const celda = document.createElement("td");
    celda.textContent = texto ?? "";
    return celda;
}

// Construye las filas de la tabla.
function mostrarAnuncios(lista) {
    cuerpoTabla.replaceChildren();

    if (lista.length === 0) {
        mensaje.textContent = "No se encontraron anuncios.";
        return;
    }

    mensaje.textContent = `Anuncios encontrados: ${lista.length}`;

    lista.forEach((anuncio) => {
        const fila = document.createElement("tr");

        fila.appendChild(
            crearCelda(anuncio.id_anuncio)
        );

        fila.appendChild(
            crearCelda(anuncio.titulo)
        );

        fila.appendChild(
            crearCelda(formatearFecha(anuncio.fecha_publicacion))
        );

        fila.appendChild(
            crearCelda(anuncio.estado)
        );

        cuerpoTabla.appendChild(fila);
    });
}

// Consulta la API de Flask.
async function cargarAnuncios() {
    mensaje.textContent = "Cargando anuncios...";

    try {
        const respuesta = await fetch(API_ANUNCIOS);

        if (!respuesta.ok) {
            throw new Error(`Error HTTP: ${respuesta.status}`);
        }

        anuncios = await respuesta.json();

        mostrarAnuncios(anuncios);
    } catch (error) {
        console.error("Error al cargar los anuncios:", error);

        mensaje.textContent =
            "No fue posible cargar los anuncios. Verifica que Flask esté funcionando.";
    }
}

// Filtra los anuncios por código, título o contenido.
function buscarAnuncios() {
    const termino = buscador.value.trim().toLowerCase();

    const resultados = anuncios.filter((anuncio) => {
        const codigo = String(anuncio.id_anuncio ?? "");
        const titulo = String(anuncio.titulo ?? "").toLowerCase();
        const contenido = String(anuncio.contenido ?? "").toLowerCase();

        return (
            codigo.includes(termino) ||
            titulo.includes(termino) ||
            contenido.includes(termino)
        );
    });

    mostrarAnuncios(resultados);
}

formularioBusqueda.addEventListener("submit", (evento) => {
    evento.preventDefault();
    buscarAnuncios();
});

buscador.addEventListener("input", buscarAnuncios);

// Carga inicial.
cargarAnuncios();
