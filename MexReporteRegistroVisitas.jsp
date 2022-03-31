<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%=EncabezadoPie.getEncabezado("Reporte Registro Visitas")%>
<script src="js/1.js"></script>
<script>
var busquedaFinalizada = 'BUSQUEDA FINALIZADA';
var errorEjecutarAccion = 'ERROR';
<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
String urlExcel = "servlet/ReporteExcel";
%>

var forma={view:'form',id:'Forma',width:400,height:'100%',elements:[
	{view:'datepicker',id:'Fecha',name:'Fecha',value:'',placeholder:'Fecha Inicio',label:'Fecha Inicio',stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:false},
	{view:'datepicker',id:'FechaA',name:'FechaA',value:'',placeholder:'Fecha Fin',label:'Fecha Fin',stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:false},
	{view:'text',id:'AuxFecha',value:'',hidden:true},
{view:'label',id:'Mensaje',label:'',align:'center'},
{view:'toolbar', cols:[
	{},
	{view:'button',value:etiquetaBotonNuevo,width:85, click:'nuevo'},
	{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar',hidden:true},
	{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true},
	{view:'button',value:etiquetaBotonBuscar,width:85,click:'buscar'}
]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[
{view:'toolbar',id:'TablaTools',cols:[
	{},
	{view:'button',value:etiquetaBotonBorrar,width:85,click:'borrar',hidden:true},
	{view:'button',value:'EXCEL',width:85,click:'excel'}
]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'Nombre',header:'Visitante',fillspace:true,sort:'string'},
	{id:'Gafete',header:'Gafete',sort:'string'},
	{id:'FechaHoraEntrada',header:'Entrada',sort:'string'},
	{id:'Recibo',header:'Recibo',sort:'string'},
	{id:'Documentacion',header:'Documentacion',sort:'string'},
	{id:'Fila',header:'Fila',sort:'string'},
	{id:'Prefijo',header:'Prefijo',sort:'string'},
	{id:'Awb',header:'Awb',sort:'string'},
	{id:'Observaciones',header:'Observaciones',sort:'string'},
	{id:'FechaHoraSalida',header:'Salida',sort:'string'},
	{id:'TiempoAlmacen',header:'Duración en Almacén',sort:'string'}
]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'REPORTE VISITAS'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
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
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('MexReporteRegistroVisitasServlet.jsp',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'Fecha',value: info.Fecha});
	$$('Confirmacion').add({campo:'Id',value: info.IdRegistroEntradasAlmacenGdl});
}

$$('Fecha').attachEvent('onChange',function(){
	$$('AuxFecha').setValue($$('Fecha').getValue());
});

function excel(){
	var FechaInicio = $$('Fecha').getValue();
	//alert(FechaInicio);
	if (FechaInicio == null){
		//alert(FechaInicio);
		$$('AuxFecha').setValue('vacio');
	}
	
		document.location = 'MexReporteRegistroVisitasExcel.jsp?Accion=Guardar' +
				'&AuxFecha=' + $$('AuxFecha').getValue() + 
				'&Fecha=' + $$('Fecha').getValue() + 
				'&FechaA=' + $$('FechaA').getValue();
	
}

inicial();
</script>
<%=EncabezadoPie.getPie()%>
<% //ReporteFacturacion.jsp %>