<%@ page import="Html.EncabezadoPie" %>
<%@ include file="valida.jsp" %>
<%=EncabezadoPie.getEncabezadoPrototype("Cloud-Cargo") %>
<script>

var cantidadA = 0;
var nombres = [""];
var frameActivo = 0;

function getCantidadVentanas() {
	return cantidadA;
}

function getFrameActivo() {
	return frameActivo;
}

function nuevoFrameEscritorio(nombre,url) {
  cantidadA += 1;
  nombres.push(nombre);
  var contenedor = $('Desktop');
  var nuevoFrame = document.createElement("frame");
  nuevoFrame.id = nombre;
  nuevoFrame.name = nombre;
  nuevoFrame.frameborder = 0;
  nuevoFrame.scrolling = 'yes';
  contenedor.appendChild(nuevoFrame);
  setUrlFrame(nombre,url);
  verFrameEscritorioSinActMenu(cantidadA);
}

function quitarFrameEscritorio(fila) {
	nombre = nombres[fila];
	nombres.splice(fila,1);
	cantidadA -= 1;
	var contenedor = $('Desktop');
	var frame = $(nombre);
	contenedor.removeChild(frame);
}

function setUrlFrame(nombre,url) {
  $(nombre).src = url;
}

function verFrameEscritorioSinActMenu(fila) {
	frameActivo = fila;
	var filas = "";
	for(var i = 1; i <= cantidadA; i++) {
		if(fila == i) {
			filas += ",*";
		} else {
			filas += ",0";
		}
	}
	$('Desktop').rows = "0" + filas;
}

function verFrameEscritorio(fila) {
	frameActivo = fila;
	var filas = "";
	for(var i = 1; i <= cantidadA; i++) {
		if(fila == i) {
			filas += ",*";
		} else {
			filas += ",0";
		}
	}
	$('Desktop').rows = "0" + filas;
	
	parent.verFrameEscritorioInformativo(fila);
	
}

// funciones para el reporteador

function reporteador() {
	parent.reporteador();
}

function reporteadorFrames(key) {
	parent.reporteadorFrames(key);
}

function ampliarEscritorio() {
	parent.ampliarPrivadoB();
}

function nuevoFrameDesdeDesktop(url,archivo,titulo) {
	var nombre = getKey();
	parent.nuevoFrameEscritorio("Desktop" + nombre, url + "?Key=Desktop" + nombre, archivo, titulo);
}

function goReporteador(id) {
	parent.setReporteador(id);
}

function ampliarResultados() {
	parent.ampliarB();
}

function mandarAccion1(Accion,id) {
	parent.mandarAccion2(Accion,id);
}

function cerrarEnDesktop() {
	parent.cerrarEnSistema();
}

function getTitulosFrames() {
	return parent.titulosFrames;
}

function setTitulosFrames(titulo){
	var getTitulo = getTitulosFrames();
	var setTitulo = "";
	var activo = getFrameActivo();
	for(var cont = 1;cont <= getTitulo.size(); cont++){
		if(activo == cont){
			parent.titulosFrames[cont] = titulo;
			setTitulo = parent.titulosFrames[cont];
			break;
		}
	}
	return setTitulo;
}

function ampliar() {
	parent.ampliar();
}

function ampliarReporteador() {
	parent.ampliarReporteador();
}

function getKey() {var hora=new Date();var ao=hora.getFullYear(); var mes=hora.getMonth(); var dia=hora.getDay(); var horas=hora.getHours(); var minutos=hora.getMinutes();var segundos=hora.getSeconds();var milisegundos=hora.getMilliseconds();return ""+horas+minutos+segundos+milisegundos;}

var idReservacion = 0;
function setIdReservacion(valor) { idReservacion = valor; }
function getIdReservacion() { return idReservacion; }

function nuevoFrame(url,archivo,titulo) {
	parent.nuevoFrame(url,archivo,titulo);
}

</script>
<frameset id="Desktop" rows="*" border="0">
	<frame name="Espacio0" src="Pizarron.jsp" marginwidth="0" marginheight="0" scrolling="yes" frameborder="0"/>
</frameset>