<%@ page import="Configuraciones.Generales"%><%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Vector"%><%@ page import="java.util.Properties"%><%@ page import="Utilerias.Fechas"%><%@ include file="valida.jsp" %><%
	Generales generales = new Generales();
	Propiedades propiedades = new Propiedades();
	out.println(EncabezadoPie.getEncabezado(propiedades.getTitulo()));
	Fechas eFechas = new Fechas();
	Properties relacionIdModulos = new Properties();
%>
<script>

var menu = webix.ui({view:"accordion",multi:false, borderless:true, collapsed:true, type:"clean", width:180, height:'100%', rows:[ 
<%
try {
	Vector<Vector<String>> menu = (Vector<Vector<String>>) session.getAttribute("Menu");
	String seccion, seccionAnterior, modulo, link, titulo, idModulos;
	StringBuffer menuPrincipal = new StringBuffer();
	seccionAnterior = "";
	boolean coma = false;
	boolean segundaVez = false;
	
	for (int i = 0; i < menu.size(); i++) {
		seccion = (String) ((Vector<String>) menu.get(i)).get(0);
		modulo = (String) ((Vector<String>) menu.get(i)).get(1);
		link = (String) ((Vector<String>) menu.get(i)).get(2);
		titulo = (String) ((Vector<String>) menu.get(i)).get(3);
		idModulos = (String) ((Vector<String>) menu.get(i)).get(4);
			
			
		relacionIdModulos.setProperty(link,idModulos);
			
		if (!seccion.equals(seccionAnterior)) {
			coma = false;
			if(segundaVez) {
				out.print("], on:{ onAfterSelect:function(id){ var elementos = id.split('|'); nuevoFrame('servlet/InfoModulo?Modulo=' + elementos[1] + '&IdModulos=' + elementos[0] + '&Seccion=' + elementos[3] + '&Link=' + elementos[2],elementos[2],elementos[1]); $$('" + seccionAnterior + "').unselectAll(); } }");
				out.println("} },");
			}
			out.print("{ header:\"" + seccion + "\", body: { view: \"list\", id:\"" + seccion + "\", template: \"<img src=\\\"imagenes/arrow2.png\\\"> #nombre#\", select:true, data: [");
			segundaVez = true;
		}
		if(coma) {
			out.print(",{ id:'" + idModulos + "|" + titulo + "|" + link + "|" + seccion + "', nombre: \"" + titulo + "\" }");
		} else {
			out.print("{ id:'" + idModulos + "|" + titulo + "|" + link + "|" + seccion + "', nombre: \"" + titulo + "\" }");
			coma = true;
		}
			seccionAnterior = seccion;
			session.setAttribute("RelacionIdModulos",relacionIdModulos);
	}
	out.print("], on:{ onAfterSelect:function(id){ var elementos = id.split('|');  nuevoFrame('servlet/InfoModulo?Modulo=' + elementos[1] + '&IdModulos=' + elementos[0] + '&Seccion=' + elementos[3] + '&Link=' + elementos[2],elementos[2],elementos[1]); $$('" + seccionAnterior + "').unselectAll(); } }");
	out.println("} }");
	out.println("]});");
} catch(NullPointerException e) {
}		
%>

function getKey() {var hora=new Date();var ao=hora.getFullYear(); var mes=hora.getMonth(); var dia=hora.getDay(); var horas=hora.getHours(); var minutos=hora.getMinutes();var segundos=hora.getSeconds();var milisegundos=hora.getMilliseconds();return ""+horas+minutos+segundos+milisegundos;};

function nuevoFrame(url,archivo,titulo) {
	var nombre = getKey();
	parent.nuevoFrameEscritorio("Desktop" + nombre, url + "?Key=Desktop" + nombre, archivo, titulo);
}
</script>
<%=EncabezadoPie.getPie()%>