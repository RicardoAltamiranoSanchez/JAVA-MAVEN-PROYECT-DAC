<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%><%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<script>
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
var etiquetaGuardar = 'GUARDAR';
var etiquetaModificar = 'MODIFICAR';
var etiquetaBuscar = 'BUSCAR';
var etiquetaBorrar = 'BORRAR';
<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
%>

var Fecha = 'Fecha';
var IdEmpresasGrupo = 'Aplicar a Empresa';
var IdProveedores = 'Proveedor';
var FechaEntrega = 'Fecha de Entrega';
var FechaPago = 'Fecha de Pago';
var IdUsuarios = 'Solicita';
var FechaAutorizacion = 'Fecha Autorizacion';
var FechaFinanzas = 'Fecha Aut.Finanzas';
var Subtotal = 'Subtotal';
var Iva = 'IVA';
var IvaRetenido = 'IVA Retenido';
var IsrRetenido = 'ISR Retenido';
var Total = 'Total';
var Llave = 'Llave';
var Factura = 'Factura';
var XmlFactura = 'XmlFactura';

var Articulo = 'Articulo';
var Cantidad = 'Cantidad';
var Unidad = 'Unidad';
var Precio = 'Precio';
var Importe = 'Importe';
var PorIva = 'PorIva';

var tablaOrdenesCompraConceptos={id:'PanelTablaOrdenesCompraConceptos',height:'100%',rows:[{view:'toolbar',id:'TablaToolsOrdenesCompraConceptos',rows:[{view:'datatable',id:'TablaOrdenesCompraConceptos',width:'100%',select:'row',multiselect:true,
	columns:[
		{id:'Articulo',header:Articulo,width:350,sort:'string'},
		{id:'Cantidad',header:Cantidad,width:50,sort:'string'},
		{id:'Unidad',header:Unidad,width:50,sort:'string'},
		{id:'Precio',header:Precio,width:100,sort:'string'},
		{id:'Importe',header:Importe,width:100,sort:'string'},
		{id:'Iva',header:Iva,width:100,sort:'string'},
		{id:'IvaRetenido',header:IvaRetenido,width:75,sort:'string'},
		{id:'IsrRetenido',header:IsrRetenido,width:75,sort:'string'},
		{id:'Total',header:Total,width:100,sort:'string'}]}]}]};

var forma={view:'form',id:'Forma',width:1024,height:'100%',
elements:[
{cols:[
	{rows:[
		{view:'datepicker',id:'Fecha',name:'Fecha',value: new Date(),placeholder:Fecha,label:Fecha,stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
		{view:'combo',id:'IdEmpresasGrupo',name:'IdEmpresasGrupo',value:'',placeholder:IdEmpresasGrupo,label:IdEmpresasGrupo,required:true,options:[],yCount:'3'},
		{view:'combo',id:'IdProveedores',name:'IdProveedores',value:'',placeholder:IdProveedores,label:IdProveedores,required:true,options:[],yCount:'3'},
		{view:'text',id:'Usuario',name:'Usuario',value:'<%=session.getAttribute("NombreUsuario")%>',placeholder:IdUsuarios,label:IdUsuarios,readonly:true},
		{view:'text',id:'IdUsuarios',name:'IdUsuarios',value:'<%=session.getAttribute("IdUsuario")%>',hidden:true},
	]},
	{rows:[
		{view:'datepicker',id:'FechaAutorizacion',name:'FechaAutorizacion',value:'',placeholder:FechaAutorizacion,label:FechaAutorizacion,stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
		{view:'datepicker',id:'FechaFinanzas',name:'FechaFinanzas',value:'',placeholder:FechaFinanzas,label:FechaFinanzas,stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
		{view:'datepicker',id:'FechaEntrega',name:'FechaEntrega',value:'',placeholder:FechaEntrega,label:FechaEntrega,stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
		{view:'datepicker',id:'FechaPago',name:'FechaPago',value:'',placeholder:FechaPago,label:FechaPago,stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
	]},
]},
{cols:[tablaOrdenesCompraConceptos]},
{cols:[
	{},
	{rows:[
		{view:'text',id:'Subtotal',name:'Subtotal',value:'',placeholder:Subtotal,label:Subtotal,required:true},
		{view:'text',id:'Iva',name:'Iva',value:'',placeholder:Iva,label:Iva,required:true},
		{view:'text',id:'IvaRetenido',name:'IvaRetenido',value:'',placeholder:IvaRetenido,label:IvaRetenido,required:true},
		{view:'text',id:'IsrRetenido',name:'IsrRetenido',value:'',placeholder:IsrRetenido,label:IsrRetenido,required:true},
		{view:'text',id:'Total',name:'Total',value:'',placeholder:Total,label:Total,required:true}       
	]}
]},
{cols:[
	{view:'text',id:'Factura',name:'Factura',value:'',placeholder:Factura,label:Factura,required:true},
	{view:'text',id:'XmlFactura',name:'XmlFactura',value:'',placeholder:XmlFactura,label:XmlFactura,required:true},
]},
{view:'text',id:'Llave',name:'Llave',value:'',hidden:true},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{},{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'Fecha',header:Fecha,fillspace:true,sort:'string'},
	{id:'IdEmpresasGrupo',header:IdEmpresasGrupo,sort:'string'},
	{id:'IdProveedores',header:IdProveedores,sort:'string'},
	{id:'FechaEntrega',header:FechaEntrega,sort:'string'},
	{id:'FechaPago',header:FechaPago,sort:'string'},
	{id:'IdUsuarios',header:IdUsuarios,sort:'string'},
	{id:'FechaAutorizacion',header:FechaAutorizacion,sort:'string'},
	{id:'FechaFinanzas',header:FechaFinanzas,sort:'string'},
	{id:'Subtotal',header:Subtotal,sort:'string'},
	{id:'Iva',header:Iva,sort:'string'},
	{id:'IvaRetenido',header:IvaRetenido,sort:'string'},
	{id:'IsrRetenido',header:IsrRetenido,sort:'string'},
	{id:'Total',header:Total,sort:'string'},
	{id:'Llave',header:Llave,sort:'string'},
	{id:'Factura',header:Factura,sort:'string'},
	{id:'XmlFactura',header:XmlFactura,sort:'string'}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'ORDENESCOMPRA'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('Confirmacion').clearAll();$$('Tabla').clearAll();$$('Mensaje').setValue(nada);$$('Vacio').show();iniciales();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
function guardarDespues(){$$('Forma').clear();inicial();}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function modificarDespues(){}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/OrdenesCompraServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:Fecha,value: info.Fecha});
	$$('Confirmacion').add({campo:IdEmpresasGrupo,value: info.IdEmpresasGrupo});
	$$('Confirmacion').add({campo:IdProveedores,value: info.IdProveedores});
	$$('Confirmacion').add({campo:FechaEntrega,value: info.FechaEntrega});
	$$('Confirmacion').add({campo:FechaPago,value: info.FechaPago});
	$$('Confirmacion').add({campo:IdUsuarios,value: info.IdUsuarios});
	$$('Confirmacion').add({campo:FechaAutorizacion,value: info.FechaAutorizacion});
	$$('Confirmacion').add({campo:FechaFinanzas,value: info.FechaFinanzas});
	$$('Confirmacion').add({campo:Subtotal,value: info.Subtotal});
	$$('Confirmacion').add({campo:Iva,value: info.Iva});
	$$('Confirmacion').add({campo:IvaRetenido,value: info.IvaRetenido});
	$$('Confirmacion').add({campo:IsrRetenido,value: info.IsrRetenido});
	$$('Confirmacion').add({campo:Total,value: info.Total});
	$$('Confirmacion').add({campo:Llave,value: info.Llave});
	$$('Confirmacion').add({campo:Factura,value: info.Factura});
	$$('Confirmacion').add({campo:XmlFactura,value: info.XmlFactura});
}
$$('Fecha').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Fecha').setValue(nuevo); });
$$('IdEmpresasGrupo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdEmpresasGrupo').setValue(nuevo); });
$$('IdProveedores').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdProveedores').setValue(nuevo); });
$$('FechaEntrega').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('FechaEntrega').setValue(nuevo); });
$$('FechaPago').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('FechaPago').setValue(nuevo); });
$$('IdUsuarios').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdUsuarios').setValue(nuevo); });
$$('FechaAutorizacion').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('FechaAutorizacion').setValue(nuevo); });
$$('FechaFinanzas').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('FechaFinanzas').setValue(nuevo); });
$$('Subtotal').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Subtotal').setValue(nuevo); });
$$('Iva').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Iva').setValue(nuevo); });
$$('IvaRetenido').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IvaRetenido').setValue(nuevo); });
$$('IsrRetenido').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IsrRetenido').setValue(nuevo); });
$$('Total').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Total').setValue(nuevo); });
$$('Llave').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Llave').setValue(nuevo); });
$$('Factura').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Factura').setValue(nuevo); });
$$('XmlFactura').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('XmlFactura').setValue(nuevo); });

var listaIdEmpresasGrupo = $$("IdEmpresasGrupo").getPopup().getList();listaIdEmpresasGrupo.clearAll();listaIdEmpresasGrupo.load("servlet/EmpresasGrupoServlet?Accion=getEmpresasGrupo&filter[value]=");
var listaIdProveedores = $$("IdProveedores").getPopup().getList();listaIdProveedores.clearAll();listaIdProveedores.load("servlet/ProveedoresServlet?Accion=getProveedores&filter[value]=");

inicial();
</script>
<%=EncabezadoPie.getPie()%>
<% //OrdenesCompra.jsp %>