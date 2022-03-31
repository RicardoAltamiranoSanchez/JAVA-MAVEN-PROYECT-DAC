<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%><%@ page import="Utilerias.Fechas"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "276";
Properties idioma = (Properties)session.getAttribute("IdiomaGeneral");
Properties idiomaModulo = (Properties)session.getAttribute(moduloIdioma);
Fechas fechas = new Fechas();
String llave = session.getAttribute("IdUsuario") +"_" + fechas.getKey();
%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<script>
var errorComunicacion='<%=idioma.getProperty("errorComunicacion") %>';
var errorEjecutarAccion='<%=idioma.getProperty("errorEjecutarAccion") %>';
var registroGuardado='<%=idioma.getProperty("registroGuardado") %>';
var registroModificado='<%=idioma.getProperty("registroModificado") %>';
var tituloEliminado='<%=idioma.getProperty("tituloEliminado") %>';
var registroEliminado='<%=idioma.getProperty("registroEliminado") %>';
var seguroDeseaEliminar='<%=idioma.getProperty("seguroDeseaEliminar") %>';
var busquedaFinalizada='<%=idioma.getProperty("busquedaFinalizada") %>';
var unRegistro='<%=idioma.getProperty("unRegistro") %>';
var soloUnRegistro='<%=idioma.getProperty("soloUnRegistro") %>';
var id='';
var si='<%=idioma.getProperty("si") %>';
var no='<%=idioma.getProperty("no") %>';
var nada='';
var guardado='<%=idioma.getProperty("guardado") %>';
var modificado='<%=idioma.getProperty("modificado") %>';
var etiquetaNuevo = '<%=idioma.getProperty("etiquetaNuevo") %>';
var etiquetaGuardar = '<%=idioma.getProperty("etiquetaGuardar") %>';
var etiquetaModificar = '<%=idioma.getProperty("etiquetaModificar") %>';
var etiquetaBuscar = '<%=idioma.getProperty("etiquetaBuscar") %>';
var etiquetaBorrar = '<%=idioma.getProperty("etiquetaBorrar") %>'; 
var etiquetaExcel = 'EXCEL';
<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
%>
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'REPORTE VACACIONES GERENTE'},
	{
			    view:"form", 
			    id:"Forma",
			    elements:[ {cols:[
			    	{},
			    	{view:'datepicker',readonly:true,value:new Date(),stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),id:'FechaInicio',name:'FechaInicio',placeholder:'<%=idiomaModulo.getProperty("FechaInicio")%>',label: '<%=idiomaModulo.getProperty("FechaInicio")%>', labelPosition:'top'},
	            	{view:'datepicker',readonly:true,value:new Date(),stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),id:'FechaFin',name:'FechaFin',placeholder:'<%=idiomaModulo.getProperty("FechaFin")%>',label: '<%=idiomaModulo.getProperty("FechaFin")%>', labelPosition:'top'},
	            	{}
	            	]},
	            	{view:'toolbar',cols:[{}, {view:'button',id:'BotonBuscar',value:etiquetaBuscar,width:125,click:'buscar'}]} 
	           ]},
	{view:'accordion',type:'wide',multi:true,height:'100%',cols:[
	{id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaExcel,width:120,click:'excel'}]},
	{view:'datatable',scroll:'y',id:'Tabla',width:'100%',select:'row',scroll:"x",multiselect:true,columns:[
	{id:'Nombre',header:'<%=idiomaModulo.getProperty("Nombre")%>',fillspace:true,sort:'string'},
	{id:'DiasSolicitados',header:'<%=idiomaModulo.getProperty("DiasSolicitados")%>',sort:'string'},
	{id:'FechasVacaciones',header:'<%=idiomaModulo.getProperty("FechasVacaciones")%>',fillspace:true,sort:'string'}
	]}]}
]}
]});	

function buscar(){enviar(busquedaFinalizada,{Accion:'ReporteVacacionesGerente',FechaInicio:$$('FechaInicio').getValue(),FechaFin:$$('FechaFin').getValue()});}
function enviar(mensaje,accion){var valores= accion;webix.ajax().post('servlet/VacacionesServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);},success:function(text,data,XmlHttpRequest){$$('PanelTabla').show();var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();$$('Tabla').clearAll();$$('Tabla').parse(data.json());}});} 
///////////
function excel(){$$('Tabla').exportToExcel("servlet/ReporteExcel",{id:false});}
</script>
<%=EncabezadoPie.getPie()%>
<% //Entradas.jsp %>