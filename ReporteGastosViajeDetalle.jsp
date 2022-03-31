<%@ page import="Configuraciones.Propiedades"%><%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<script>
var modoSubforma=true;
var errorComunicacion='ERROR DE COMUNICACION';
var errorEjecutarAccion='ERROR AL EJECUTAR ACCION';
var registroGuardado='REGISTRO GUARDADO';
var registroModificado='REGISTRO MODIFICADO';
var tituloEliminado='ELIMINACION DE REGISTRO';
var registroEliminado='REGISTRO(S) ELIMINADO(S)';
var seguroDeseaEliminar='SEGURO QUE DESEA ELIMINAR';
var busquedaFinalizada='BUSQUEDA FINALIZADA';
var unRegistro='FAVOR DE SELECCIONAR AL MENOS UN REGISTRO';
var soloUnRegistro='FAVOR DE SELECCIONAR SOLO UN REGISTRO';
var id='';
var si='SI';
var no='NO';
var nada='';
var guardado='GUARDADO';
var modificado='MODIFICADO';
var etiquetaNuevo = 'NUEVO';
var etiquetaGuardar = 'AGREGAR';
var etiquetaModificar = 'MODIFICAR';
var etiquetaBuscar = 'BUSCAR';
var etiquetaBorrar = 'BORRAR';
var nada='';var valoresBusqueda='';var idGenerado='';var campo='IdReporteGastosViaje';
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:campo,valor:'" + request.getParameter("IdGenerado") + "'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var IdReporteGastosViaje = 'IdReporteGastosViaje';
var Fecha = 'Fecha'.toUpperCase();
var Documento = 'Documento'.toUpperCase();
var Proveedor = 'Proveedor'.toUpperCase();
var DetalleGasto = 'Detalle Gasto'.toUpperCase();
var ImporteSinIva = 'Importe Sin Iva'.toUpperCase();
var ImporteConIva = 'Importe Con Iva'.toUpperCase();
var Iva = 'Iva'.toUpperCase();
var GastosComprobados = 'Total'.toUpperCase();
var ArchivoXML = 'ARCHIVOS MEZCLADOS PDF Y XML';
var ArchivoPDF = 'PDF';

var forma={view:'form',id:'Forma',elements:[
	{view:'text',id:'IdReporteGastosViaje',name:'IdReporteGastosViaje',value:'',placeholder:IdReporteGastosViaje,label:IdReporteGastosViaje,hidden:true},
	{cols:[
		{rows:[
			{cols:[
				{view:'datepicker',id:'Fecha',name:'Fecha',value: new Date(),placeholder:Fecha,label:Fecha,labelPosition:'top',stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
				{view:'text',id:'Documento',name:'Documento',value:'',placeholder:Documento,label:Documento,required:true,labelPosition:'top'},
				{view:'text',id:'Proveedor',name:'Proveedor',value:'',placeholder:Proveedor,label:Proveedor,required:true,labelPosition:'top'},
				{view:'text',id:'DetalleGasto',name:'DetalleGasto',value:'',placeholder:DetalleGasto,label:DetalleGasto,required:true,labelPosition:'top'},
				{view:'text',id:'ImporteSinIva',name:'ImporteSinIva',value:'',placeholder:ImporteSinIva,label:ImporteSinIva,required:true,labelPosition:'top'},
				{view:'text',id:'ImporteConIva',name:'ImporteConIva',value:'',placeholder:ImporteConIva,label:ImporteConIva,required:true,labelPosition:'top'},
			]},	
			{cols:[{},{view:'text',id:'Iva',name:'Iva',value:'',placeholder:Iva,label:Iva,width:200,required:true}]},
			{cols:[{},{view:'text',id:'GastosComprobados',name:'GastosComprobados',value:'',placeholder:GastosComprobados,label:GastosComprobados,width:200,readonly:true}]},
			   
		]},
		{width:10},
		{width:200,cols:[
				{rows:[
		       		{view:'uploader',id:'ArchivoXML',name:'ArchivoXML',value:'',link:'listaArchivoXML',placeholder:ArchivoXML,label:ArchivoXML,
		       			upload:'servlet/SubirArchivoXMLServlet',formData:{Llave:'<%=request.getParameter("IdGenerado")%>'},autosend:true,multiple:true},
		       		{borderless: false, view:"list", id:"listaArchivoXML", type:"uploader", autoheight:false, height:100},
		       	]},
		]},
	]},
	
	
{view:'toolbar', cols:[{view:'button',id:'BotonBorrar',value:etiquetaBorrar,width:85,click:'borrar'},{view:'label',id:'Mensaje',label:'',align:'center'},{},
	{view:'button',id:'BotonNuevo',value:etiquetaNuevo,width:85, click:'nuevo'},
	{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},
	{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true}]},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Fecha',header:Fecha,sort:'string',width:75},
	{id:'Documento',header:Documento,sort:'string',width:150},
	{id:'Proveedor',header:Proveedor,sort:'string',fillspace:true,minWidth:150},
	{id:'DetalleGasto',header:DetalleGasto,sort:'string',width:200},
	{id:'ImporteSinIva',header:ImporteSinIva,sort:'string',width:75},
	{id:'ImporteConIva',header:ImporteConIva,sort:'string',width:75},
	{id:'Iva',header:Iva,sort:'string',width:75},
	{id:'GastosComprobados',header:GastosComprobados,sort:'string',width:75}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'accordion',type:'wide',multi:true,height:'100%',rows:[{body:forma},{body:tabla}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function ultimosCapturados(mensaje){valoresBusqueda={Accion:'Buscar',Campo:''};enviar(mensaje,'Buscar');}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('BotonBorrar').show();$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function guardar(){$$('Forma').setValues({Accion:'Guardar'},true);if($$('Forma').validate()){enviar(guardado,'Guardar');}}
function guardarFinal(){$$('Forma').clear();inicial();buscar();}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();$$('BotonGuardar').show();$$('BotonModificar').hide();inicial();buscar();}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(modificado,'Modificar');}}
function modificarFinal(){$$('Forma').clear();$$('BotonGuardar').show();$$('BotonModificar').hide();inicial();buscar();}
function buscar(){valoresBusqueda={Accion:'Buscar',Campo:$$(campo).getValue()};enviar(busquedaFinalizada,'Buscar');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post('servlet/ReporteGastosViajeDetalleServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	IdReporteGastosViaje: $$('Tabla').getItem(id).IdReporteGastosViaje,
	Fecha: $$('Tabla').getItem(id).Fecha,
	Documento: $$('Tabla').getItem(id).Documento,
	Proveedor: $$('Tabla').getItem(id).Proveedor,
	DetalleGasto: $$('Tabla').getItem(id).DetalleGasto,
	ImporteSinIva: $$('Tabla').getItem(id).ImporteSinIva,
	ImporteConIva: $$('Tabla').getItem(id).ImporteConIva,
	Iva: $$('Tabla').getItem(id).Iva,
	GastosComprobados: $$('Tabla').getItem(id).GastosComprobados,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

$$("ArchivoXML").attachEvent("onUploadComplete", function(response){
    buscar();
});

$$('Documento').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Documento').setValue(nuevo);});
$$('Proveedor').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Proveedor').setValue(nuevo);});

$$('ImporteSinIva').attachEvent('onChange',function(nuevo,anterior){suma()});
$$('ImporteConIva').attachEvent('onChange',function(nuevo,anterior){suma()});
$$('Iva').attachEvent('onChange',function(nuevo,anterior){suma()});

function suma() {
	var uno = getZero($$('ImporteSinIva').getValue());
	var dos = getZero($$('ImporteConIva').getValue());
	var tres = getZero($$('Iva').getValue());
	var resultado = uno + dos + tres;
	$$('GastosComprobados').setValue(resultado);
}

function getZero(valor) {
	if(valor == '') {
		valor = 0;
	} else {
		valor = parseFloat(valor);
	}
	return valor
}

inicial();buscar();
</script>
<%=EncabezadoPie.getPie()%>