
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

        const celdaAcciones = document.createElement("td");

        const botonEliminar = document.createElement("button");
        botonEliminar.type = "button";
        botonEliminar.textContent = "Eliminar";
        botonEliminar.className = "btn-eliminar";
        botonEliminar.dataset.id = anuncio.id_anuncio;

        celdaAcciones.appendChild(botonEliminar);
        fila.appendChild(celdaAcciones);


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

const btnMostrarFormulario = document.getElementById("btn-mostrar-formulario");
const btnCancelarAnuncio = document.getElementById("btn-cancelar-anuncio");
const seccionCrearAnuncio = document.getElementById("seccion-crear-anuncio");
const formularioCrearAnuncio = document.getElementById("form-crear-anuncio");
const mensajeFormulario = document.getElementById("mensaje-formulario");

// Mostrar el formulario
btnMostrarFormulario.addEventListener("click", () => {
    seccionCrearAnuncio.hidden = false;
    mensajeFormulario.textContent = "";
});

formularioCrearAnuncio.addEventListener("submit", async (evento) => {
    evento.preventDefault();

    mensajeFormulario.textContent = "Guardando anuncio...";

    const datos = {
        titulo: document.getElementById("titulo").value.trim(),
        contenido: document.getElementById("contenido").value.trim(),
        fecha_publicacion: document.getElementById("fecha_publicacion").value,
        id_admin: Number(document.getElementById("id_admin").value)
    };

    try {
        const respuesta = await fetch(API_ANUNCIOS, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(datos)
        });

        const resultado = await respuesta.json();

        if (!respuesta.ok) {
            throw new Error(
                resultado.error || "No fue posible guardar el anuncio."
            );
        }

        mensajeFormulario.textContent =
            `¡Anuncio creado correctamente! Código: ${resultado.id_anuncio}`;

        formularioCrearAnuncio.reset();

        await cargarAnuncios();

        // Ocultar el formulario después de guardar.
        seccionCrearAnuncio.hidden = true;

    } catch (error) {
        console.error("Error al guardar el anuncio:", error);

        mensajeFormulario.textContent =
            error.message || "Ocurrió un error al guardar el anuncio.";
    }
});


// Cancelar la creación del anuncio
btnCancelarAnuncio.addEventListener("click", () => {
    seccionCrearAnuncio.hidden = true;
    formularioCrearAnuncio.reset();
    mensajeFormulario.textContent = "";
});

cuerpoTabla.addEventListener("click", async (evento) => {
    const boton = evento.target.closest(".btn-eliminar");

    if (!boton) {
        return;
    }

    const id = boton.dataset.id;

    const confirmar = confirm(
        `¿Estás seguro de que deseas eliminar el anuncio ${id}?`
    );

    if (!confirmar) {
        return;
    }

    boton.disabled = true;

    try {
        const respuesta = await fetch(`${API_ANUNCIOS}${id}`, {
            method: "DELETE"
        });

        const resultado = await respuesta.json();

        if (!respuesta.ok) {
            throw new Error(
                resultado.error || "No se pudo eliminar el anuncio."
            );
        }

        await cargarAnuncios();

    } catch (error) {
        console.error("Error al eliminar el anuncio:", error);
        alert(error.message || "Ocurrió un error al eliminar el anuncio.");
        boton.disabled = false;
    }
});

