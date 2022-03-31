<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/MexInventarioReporteServlet';
var servlet='MexInventarioReporteServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var IdEntradas = 'IdEntradas';
var Producto = 'Producto';
var Unidad = 'Unidad';
var Cantidad = 'Cantidad';
var Ubicacion = 'Ubicacion';

var forma={view:'form',id:'Forma',width:400,height:'100%',elements:[
	{view:'combo',id:'IdEntradas',name:'IdEntradas',value:'',placeholder:IdEntradas,label:IdEntradas,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true},
	{view:'text',id:'Producto',name:'Producto',value:'',placeholder:Producto,label:Producto,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Unidad',name:'Unidad',value:'',placeholder:Unidad,label:Unidad,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Cantidad',name:'Cantidad',value:'',placeholder:Cantidad,label:Cantidad,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Ubicacion',name:'Ubicacion',value:'',placeholder:Ubicacion,label:Ubicacion,labelWidth:100,labelPosition:'left',required:true},
{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonBuscar',value:etiquetaBotonBuscar,width:85,click:'buscar'}]},
//{view:'iframe',id:'FrameSubforma',width:'80%',src:archivo},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[
{view:'toolbar',cols:[{},{view:'button',id:'BotonPdf',value:'PDF',width:85, click:'pdf'},{view:'button',id:'BotonExcel',value:'EXCEL',width:85, click:'excel'}]},
{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'IdEntradas',header:IdEntradas,fillspace:true,sort:'string',minWidth:150},
	{id:'Producto',header:Producto,sort:'string',width:150},
	{id:'Unidad',header:Unidad,sort:'string',width:150},
	{id:'Cantidad',header:Cantidad,sort:'string',width:150},
	{id:'Ubicacion',header:Ubicacion,sort:'string',width:150}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{body:tabla},{header:' ',body:forma}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){$$('FrameSubforma').hide();}}
function nuevo(){$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(resultadosEncontrados,'Buscar');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post(servlet,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}});}

var servletIdEntradas='EntradasServlet.jsp';var listaIdEntradas=$$('IdEntradas').getPopup().getList();listaIdEntradas.clearAll();listaIdEntradas.load(servletIdEntradas + '?Accion=getEntradas&filter[value]=');
$$('Producto').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Producto').setValue(nuevo);});
$$('Unidad').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Unidad').setValue(nuevo);});
$$('Cantidad').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Cantidad').setValue(nuevo);});
$$('Ubicacion').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Ubicacion').setValue(nuevo);});

function pdf() {
	parent.nuevoFrameDesdeEscritorio(getLlave('Uno'),'PDF','Pdf.jsp?Key=' + getLlave('Uno') +
		'&IdEntradas=' + $$('IdEntradas').getValue() +
		'&Producto=' + $$('Producto').getValue() +
		'&Unidad=' + $$('Unidad').getValue() +
		'&Cantidad=' + $$('Cantidad').getValue() +
		'&Ubicacion=' + $$('Ubicacion').getValue() +
	'');
}

function excel() {
	parent.nuevoFrameDesdeEscritorio(getLlave('Dos'),'EXCEL','Excel.jsp?Key=' + getLlave('Dos') +
		'&IdEntradas=' + $$('IdEntradas').getValue() +
		'&Producto=' + $$('Producto').getValue() +
		'&Unidad=' + $$('Unidad').getValue() +
		'&Cantidad=' + $$('Cantidad').getValue() +
		'&Ubicacion=' + $$('Ubicacion').getValue() +
	'');
}

function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//MexInventarioReporte.jsp
%>
