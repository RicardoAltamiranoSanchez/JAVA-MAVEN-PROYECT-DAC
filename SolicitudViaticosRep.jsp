<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%><%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<% boolean modoForma = false; boolean reporte = true; %>
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
var etiquetaAutorizar = 'AUTORIZAR';
var etiquetaRechazar = 'RECHAZAR';
<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:'Nombre',valor:'" + session.getAttribute("NombreUsuario") + "'}");
out.print(",{campo:'Autorizacion',valor:'Pendiente'}");
out.println("];");
%>

var Fecha = 'Fecha';
var Gerente = 'Gerente';
var Nombre = 'Nombre';
var Puesto = 'Puesto';
var Motivo = 'Motivo del Viaje';
var FacturarA = 'Facturar A';
var ViajeDesde = 'Viaje Desde';
var ViajeHasta = 'Hasta';
var Itinerario = 'Itinerario';
var Estacion = 'Estacion';
var Hospedaje = 'Hospedaje';
var Alimentos = 'Alimentos';
var Taxi = 'Taxi';
var RentaAutomovil = 'Renta de Automovil';
var Avion = 'Avion';
var Transporte = 'Transporte';
var Total = 'Total';
var Autorizacion = 'Autorizacion';

var forma={view:'form',id:'Forma',width:600,height:'100%',scroll:'y',elements:[
	{view:'datepicker',id:'Fecha',name:'Fecha',value: new Date(),placeholder:Fecha,label:Fecha,stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
	{view:'combo',id:'Gerente',name:'Gerente',value:'',placeholder:Gerente,label:Gerente,required:true,options:[],yCount:'3'},
	{view:'text',id:'Nombre',name:'Nombre',value:'',placeholder:Nombre,label:Nombre,required:true,readonly:true},
	{cols:[
	{view:'text',id:'Puesto',name:'Puesto',value:'',placeholder:Puesto,label:Puesto,required:true},
	{view:'text',id:'Estacion',name:'Estacion',value:'',placeholder:Estacion,label:Estacion,labelAlign:'center',required:true},
	]},
	{view:'text',id:'Motivo',name:'Motivo',value:'',placeholder:Motivo,label:Motivo,required:true},
	{view:'combo',id:'FacturarA',name:'FacturarA',value:'',placeholder:FacturarA,label:FacturarA,required:true,options:[],yCount:'3'},
	{cols:[
		{view:'datepicker',id:'ViajeDesde',name:'ViajeDesde',value: new Date(),placeholder:ViajeDesde,label:ViajeDesde,stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
		{view:'datepicker',id:'ViajeHasta',name:'ViajeHasta',value: new Date(),placeholder:ViajeHasta,label:ViajeHasta,labelAlign:'center',stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
	]},
	{view:'text',id:'Itinerario',name:'Itinerario',value:'',placeholder:Itinerario,label:Itinerario,required:true},
	
	{cols:[{},{view:'text',id:'Hospedaje',name:'Hospedaje',value:'',placeholder:Hospedaje,label:Hospedaje,required:true}]},
	{cols:[{},{view:'text',id:'Alimentos',name:'Alimentos',value:'',placeholder:Alimentos,label:Alimentos,required:true}]},
	{cols:[{},{view:'text',id:'Taxi',name:'Taxi',value:'',placeholder:Taxi,label:Taxi,required:true},{}]},
	{cols:[{},{view:'text',id:'RentaAutomovil',name:'RentaAutomovil',value:'',placeholder:RentaAutomovil,label:RentaAutomovil,required:true},{}]},
	{cols:[{},{view:'text',id:'Avion',name:'Avion',value:'',placeholder:Avion,label:Avion,required:true},{}]},
	{cols:[{},{view:'text',id:'Transporte',name:'Transporte',value:'',placeholder:Transporte,label:Transporte,readonly:true}]},
	
	{cols:[{},{view:'text',id:'Total',name:'Total',value:'',placeholder:Total,label:Total,readonly:true}]},
	{view:'text',id:'Autorizacion',name:'Autorizacion',value:'',placeholder:Autorizacion,label:Autorizacion,hidden:true},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{},{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',
	cols:[
<% if(modoForma) {%>
	{view:'button',value:etiquetaBorrar,width:85,click:'borrar',hidden:true},
	{view:'button',value:etiquetaModificar,width:85,click:'consultar'}
<%} else {
	if(reporte) {%>
		{},
		{view:'button',value:'PDF',width:85,click:'pdf'}
<%	} else {%> 
		{view:'button',value:etiquetaAutorizar,width:85,click:'autorizar'},
		{view:'button',value:etiquetaRechazar,width:85,click:'rechazar'}
<%	}
}%>
	      
	      
	]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
		{id:'id',header:'Id',width:30,sort:'string'},
		{id:'Fecha',header:Fecha,width:60,sort:'string'},
		{id:'Nombre',header:Nombre,sort:'string',width:200},
		{id:'Puesto',header:Puesto,sort:'string',width:100},
		{id:'Motivo',header:Motivo,sort:'string',width:200},
		{id:'ViajeDesde',header:ViajeDesde,sort:'string',width:75},
		{id:'ViajeHasta',header:ViajeHasta,sort:'string',width:75},
		{id:'Itinerario',header:Itinerario,sort:'string',width:250},
		{id:'Estacion',header:Estacion,sort:'string',width:35},
		{id:'Hospedaje',header:Hospedaje,sort:'string',width:60},
		{id:'Alimentos',header:Alimentos,sort:'string',width:60},
		{id:'Taxi',header:Taxi,sort:'string',width:60},
		{id:'RentaAutomovil',header:RentaAutomovil,sort:'string',width:60},
		{id:'Avion',header:Avion,sort:'string',width:60},
		{id:'Transporte',header:Transporte,sort:'string',width:60},
		{id:'Total',header:Total,sort:'string',width:60},
		{id:'Autorizacion',header:Autorizacion,sort:'string'}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'SOLICITUD DE VIATICOS NACIONAL E INTERNACIONAL'},{view:'accordion',type:'wide',multi:true,height:'100%'
<%
	if(modoForma) {
		out.println(",cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]");	
	} else {
		out.println(",cols:[{animate:{type:'flip'},cells:[vacio,lista,tabla,forma]}]");
	}
%>
}]});	
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('Confirmacion').clearAll();$$('Tabla').clearAll();$$('Mensaje').setValue(nada);$$('Vacio').show();inicial();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
function guardarDespues(){$$('Forma').clear();inicial();}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');}
function buscarAutorizar(){$$('Forma').setValues({Accion:'BuscarAutorizar'},true);enviar(busquedaFinalizada,'BuscarAutorizar');}
function buscarTodos(){$$('Forma').setValues({Accion:'BuscarTodos'},true);enviar(busquedaFinalizada,'BuscarTodos');}
function consultar(){
	var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{
		if($$('Tabla').getItem(ids).Autorizacion == 'PENDIENTE') {
			$$('BotonGuardar').hide();$$('BotonModificar').show();		
			if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}
			else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}
		} else {
			webix.alert('YA NO PUEDES MODIFICAR ESTE REGISTRO');
		}
}}
		
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function modificarDespues(){}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/SolicitudViaticosServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){
		if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');
			if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());
				if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}
				else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}
			else if(accion=='Borrar'){borrarDespues();}
			else if(accion=='Buscar'||accion=='BuscarAutorizar'||accion=='BuscarTodos'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}
			else if(accion=='Autorizar'||accion=='Rechazar'){buscarAutorizar();
			}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:Fecha,value: info.Fecha});
	$$('Confirmacion').add({campo:Gerente,value: info.Gerente});
	$$('Confirmacion').add({campo:Nombre,value: info.Nombre});
	$$('Confirmacion').add({campo:Puesto,value: info.Puesto});
	$$('Confirmacion').add({campo:ViajeDesde,value: info.ViajeDesde});
	$$('Confirmacion').add({campo:ViajeHasta,value: info.ViajeHasta});
	$$('Confirmacion').add({campo:Itinerario,value: info.Itinerario});
	$$('Confirmacion').add({campo:Estacion,value: info.Estacion});
	$$('Confirmacion').add({campo:Hospedaje,value: info.Hospedaje});
	$$('Confirmacion').add({campo:Alimentos,value: info.Alimentos});
	$$('Confirmacion').add({campo:Taxi,value: info.Taxi});
	$$('Confirmacion').add({campo:RentaAutomovil,value: info.RentaAutomovil});
	$$('Confirmacion').add({campo:Avion,value: info.Avion});
	$$('Confirmacion').add({campo:Transporte,value: info.Transporte});
	$$('Confirmacion').add({campo:Total,value: info.Total});
	$$('Confirmacion').add({campo:Autorizacion,value: info.Autorizacion});
}
function autorizar(){var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Autorizar',id:ids},true);enviar('','Autorizar');}}}
function rechazar(){var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Rechazar',id:ids},true);enviar('','Rechazar');}}}

$$('Nombre').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Nombre').setValue(nuevo); });
$$('Puesto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Puesto').setValue(nuevo); });
$$('Motivo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Motivo').setValue(nuevo); });
$$('Itinerario').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Itinerario').setValue(nuevo); });
$$('Estacion').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Estacion').setValue(nuevo); });
$$('Hospedaje').attachEvent('onChange',function(nuevo, anterior){ suma(); });
$$('Alimentos').attachEvent('onChange',function(nuevo, anterior){ suma(); });
$$('Taxi').attachEvent('onChange',function(nuevo, anterior){ suma(); });
$$('RentaAutomovil').attachEvent('onChange',function(nuevo, anterior){  suma(); });
$$('Avion').attachEvent('onChange',function(nuevo, anterior){  suma(); });
$$('Autorizacion').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Autorizacion').setValue(nuevo); });

function suma() {
	transporte = 0;
	transporte = getZero($$('Taxi').getValue()) + getZero($$('Avion').getValue()) + getZero($$('RentaAutomovil').getValue())
	$$('Transporte').setValue(transporte);
	total = 0;
	total = getZero($$('Hospedaje').getValue()) + getZero($$('Alimentos').getValue()) + transporte;
	$$('Total').setValue(total);
}

function getZero(valor) {
	if(valor == '') {
		valor = 0;
	}
	return parseFloat(valor);
}

var listaIdGerente = $$("Gerente").getPopup().getList();listaIdGerente.clearAll();listaIdGerente.load("servlet/GerentesServlet?Accion=getGerentes&filter[value]=");
var listaFacturarA = $$("FacturarA").getPopup().getList();listaFacturarA.clearAll();listaFacturarA.load("servlet/FacturaAServlet?Accion=getFacturaA&filter[value]=");

function pdf() {
	var ids=$$('Tabla').getSelectedId();
	if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}
	else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}
	else{
		document.location = 'SolicitudViaticosAdmonPdf.jsp?Id=' + ids;
	}}	
}

inicial();
<%
	if(modoForma) {
		out.println("buscar();");		
	} else {
		if(reporte) {
			out.println("buscarTodos();");
		} else {
			out.println("buscarAutorizar();");
		}
	}
%>

</script>
<%=EncabezadoPie.getPie()%>
<% //SolicitudViaticos.jsp %>