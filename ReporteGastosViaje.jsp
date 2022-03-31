<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%><%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<script>
var idGenerado='';
var archivo = "ReporteGastosViajeDetalle.jsp";
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
var etiquetaGuardar = 'SIGUIENTE';
var etiquetaModificar = 'MODIFICAR';
var etiquetaBuscar = 'BUSCAR';
var etiquetaBorrar = 'BORRAR';
<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
%>

var Fecha = 'Fecha'.toUpperCase();
var Departamento = 'Departamento'.toUpperCase();
var PeriodoDe = 'Periodo De'.toUpperCase();
var PeriodoA = 'A'.toUpperCase();
var Estacion = 'Estacion'.toUpperCase();
var MotivoViaje = 'Motivo del Viaje'.toUpperCase();
var Partida = 'Partida'.toUpperCase();
var ViaticosEntregados = 'Viaticos Entregados'.toUpperCase();
var FacturadoDirectoEmpresa = 'Facturado Directo Empresa'.toUpperCase();
var NetoCargoFavor = 'Neto Cargo/Favor'.toUpperCase();


var forma={view:'form',id:'Forma',width:500,elements:[
    {cols:[
		{view:'datepicker',id:'Fecha',name:'Fecha',value: new Date(),placeholder:Fecha,label:Fecha,stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
		{view:'text',id:'Departamento',name:'Departamento',value:'',placeholder:Departamento,label:Departamento,labelWidth:110,labelAlign:'right',required:true},
	]},
	{cols:[
		{view:'datepicker',id:'PeriodoDe',name:'PeriodoDe',value: new Date(),placeholder:PeriodoDe,label:PeriodoDe,stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
		{view:'datepicker',id:'PeriodoA',name:'PeriodoA',value: new Date(),placeholder:PeriodoA,label:PeriodoA,labelAlign:'center',stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:true},
	]},
	{cols:[	
		{view:'text',id:'Estacion',name:'Estacion',value:'',placeholder:Estacion,label:Estacion,labelAlign:'center',required:true},
		{view:'text',id:'Partida',name:'Partida',value:'',placeholder:Partida,label:Partida,labelAlign:'center'},
	]},
	{cols:[
		{view:'text',id:'MotivoViaje',name:'MotivoViaje',value:'',placeholder:MotivoViaje,label:MotivoViaje,labelWidth:120,required:true},
	]},
	{cols:[{},{view:'text',id:'ViaticosEntregados',name:'ViaticosEntregados',value:'',placeholder:ViaticosEntregados,label:ViaticosEntregados,labelWidth:180,width:300,required:true}]},
	{cols:[{},{view:'text',id:'FacturadoDirectoEmpresa',name:'FacturadoDirectoEmpresa',value:'',placeholder:FacturadoDirectoEmpresa,label:FacturadoDirectoEmpresa,labelWidth:180,width:300,required:true}]},
	{cols:[{},{view:'text',id:'NetoCargoFavor',name:'NetoCargoFavor',value:'',placeholder:NetoCargoFavor,label:NetoCargoFavor,labelWidth:180,hidden:true}]},
{view:'label',id:'Mensaje',label:'',align:'center'},
{view:'toolbar', cols:[{},{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},
                       {view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},
                       {view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},
                       {view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Fecha',header:Fecha,sort:'string',width:75},
	{id:'Departamento',header:Departamento,sort:'string',width:100},
	{id:'PeriodoDe',header:PeriodoDe,sort:'string',width:75},
	{id:'PeriodoA',header:PeriodoA,sort:'string',width:75},
	{id:'Estacion',header:Estacion,sort:'string',width:50},
	{id:'MotivoViaje',header:MotivoViaje,sort:'string',fillspace:true,minWidth:150},
	{id:'ViaticosEntregados',header:ViaticosEntregados,sort:'string',width:75},
	{id:'FacturadoDirectoEmpresa',header:FacturadoDirectoEmpresa,sort:'string',width:75},
	{id:'NetoCargoFavor',header:NetoCargoFavor,sort:'string'}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'REPORTE DE GASTOS DE VIAJE'},{view:'accordion',type:'wide',multi:true,height:'100%',
	cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});
	
var ventana = webix.ui({view:"window",id:'VentanaReporteGastosViajeDetalle',width:1024,height:350,position:'center',modal:true,
	head:{cols:[{},{view:'button', label:'X', width:50, click:("$$('VentanaReporteGastosViajeDetalle').hide();buscar();")}]},
	body:{rows:[{view:'iframe',id:'FrameSubforma',scroll:'y',src:archivo},]}}).hide();
	
	
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){idGenerado='';
	$$('VentanaReporteGastosViajeDetalle').hide();
}}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('Confirmacion').clearAll();$$('Tabla').clearAll();$$('Mensaje').setValue(nada);$$('Vacio').show();inicial();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
function guardarDespues(){
	setSubforma();
	$$('BotonGuardar').hide();
}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);idGenerado=ids;enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function modificarDespues(){}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/ReporteGastosViajeServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(modoSubforma){setSubforma();}}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	idGenerado = info.id;
	$$('Confirmacion').add({campo:Fecha,value: info.Fecha});
	$$('Confirmacion').add({campo:Departamento,value: info.Departamento});
	$$('Confirmacion').add({campo:PeriodoDe,value: info.PeriodoDe});
	$$('Confirmacion').add({campo:PeriodoA,value: info.PeriodoA});
	$$('Confirmacion').add({campo:Estacion,value: info.Estacion});
	$$('Confirmacion').add({campo:MotivoViaje,value: info.MotivoViaje});
	$$('Confirmacion').add({campo:Partida,value: info.Partida});
	$$('Confirmacion').add({campo:ViaticosEntregados,value: info.ViaticosEntregados});
	$$('Confirmacion').add({campo:FacturadoDirectoEmpresa,value: info.FacturadoDirectoEmpresa});
	$$('Confirmacion').add({campo:NetoCargoFavor,value: info.NetoCargoFavor});
}
$$('Departamento').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Departamento').setValue(nuevo); });
$$('Estacion').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Estacion').setValue(nuevo); });
$$('MotivoViaje').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('MotivoViaje').setValue(nuevo); });
$$('Partida').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Partida').setValue(nuevo); });
function setSubforma(){
	var altura=$$('PanelTabla').$height;
	$$('VentanaReporteGastosViajeDetalle').define('height',altura);
	$$('VentanaReporteGastosViajeDetalle').resize();
	$$('VentanaReporteGastosViajeDetalle').show();
	
	$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);
}
inicial();buscar();
</script>
<%=EncabezadoPie.getPie()%>
<% //ReporteGastosViaje.jsp %>