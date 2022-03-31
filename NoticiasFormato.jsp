<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "97";
Properties idioma = (Properties)session.getAttribute("IdiomaGeneral");
Properties idiomaModulo = (Properties)session.getAttribute(moduloIdioma);
boolean debug = false;
String varId = request.getParameter("Id");
String varAccion = request.getParameter("Accion"); %>

<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>

<style type="text/css">
		.titulo {
			font-family: Arial, Helvetica, sans-serif;
			font-size: 40px;		
			font-weight: bold;
			color: black;
		}
		.resumen {
			font-family: Arial, Helvetica, sans-serif;
			font-size: 18px;
		}
		.noticia {
			font-family: Arial, Helvetica, sans-serif;
			font-size: 18px;		
		}
</style>
<table width="100%">
	<tr><td class="titulo" align="center"><span id="Titulo"></span></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center">
		<table width="700" border=0>
			<tr><td class="resumen"><span id="Resumen"></span></td><td align="right"><span id="Fecha"></span></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td class="noticia" colspan=2><span id="Noticia"></span></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2"><div id="reg"></div></td></tr>
		</table>
	</td></tr>
</table>
<script>
var archivo = "";

webix.ajax().post("servlet/NoticiasServlet?Accion:'Consultar'",{Accion:"Consultar",id:<%=varId%>},{
	 error:function(text, data, XmlHttpRequest){webix.message("Error");},
	 success:function(text, data, XmlHttpRequest){setConfirmacion(data.json());}
});
	        
function setConfirmacion(info){
		archivo = 'noticias/' + info.Archivo;
		document.getElementById('Titulo').innerHTML = info.Titulo;
		document.getElementById('Fecha').innerHTML = info.Fecha;
		document.getElementById('Resumen').innerHTML = info.Resumen;
		document.getElementById('Noticia').innerHTML = info.Noticia;
}

webix.ui({container:"reg",id:"mylayout",type:"space",
		cols:[
			  {view:'button',id:'Descargar',label:"Descargar",inputWidth:100,click:Descargar},
		      {view:'button',id:'Regresar',label:"Regresar",inputWidth:100,type:"prev",click:Regresar}
		]}
	);

function Regresar(){
	document.location = "Pizarron.jsp";
}

function Descargar() {
	document.location = archivo;
}
</script>

		
<%=EncabezadoPie.getPie()%>