<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
var nada='';var valoresBusqueda='';var idGenerado='';var campo='Id';
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:campo,valor:'" + request.getParameter("IdGenerado") + "'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var Id = 'Id';
var FacturaFolio = 'Folio de Factura'.toUpperCase();
var FacturaMontoTotal = 'Monto Total de la Factura'.toUpperCase();
var FacturaFechaIdealPago = 'Fecha Sugerida de Pago'.toUpperCase();
var FacturaObservaciones = 'Observaciones'.toUpperCase();
var busquedaFinalizada='<div style="color:#33ff3c";>Datos Cargados</div>'.toUpperCase();


var forma={view:'form',id:'Forma',elements:[
	{view:'text',id:'Id',name:'Id',value:'',placeholder:Id,label:Id,labelWidth:100,labelPosition:'left',hidden:true},
	{cols:[
		{rows:[
		{view:'text',id:'FacturaFolio',name:'FacturaFolio',value:'',placeholder:FacturaFolio,label:FacturaFolio,labelWidth:100,labelPosition:'top',required:true},		
		{view:'text',id:'FacturaMontoTotal',name:'FacturaMontoTotal',value:'',placeholder:FacturaMontoTotal,label:FacturaMontoTotal,labelWidth:100,labelPosition:'top',required:true},
		{view:'datepicker',id:'FacturaFechaIdealPago',name:'FacturaFechaIdealPago',value: new Date(),placeholder:FacturaFechaIdealPago,width:210,label:FacturaFechaIdealPago,labelWidth:100,labelPosition:'top',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:false},
		]},
		{view:'textarea',id:'FacturaObservaciones',name:'FacturaObservaciones',value:'',placeholder:FacturaObservaciones,label:FacturaObservaciones,height:100,labelWidth:150,labelPosition:'top',labelWidth:150},
	 ]
	},
{view:'toolbar', cols:[{view:'button',id:'BotonBorrar',value:etiquetaBotonBorrar,width:85,click:'borrar'},{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'FacturaFolio',header:FacturaFolio,fillspace:true,sort:'string',minWidth:150},
	{id:'FacturaMontoTotal',header:FacturaMontoTotal,fillspace:true,sort:'string',minWidth:150},
	{id:'FacturaFechaIdealPago',header:FacturaFechaIdealPago,fillspace:true,sort:'string',minWidth:150},
	{id:'FacturaObservaciones',header:FacturaObservaciones,fillspace:true,sort:'string',minWidth:150}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'accordion',type:'wide',multi:true,height:'100%',rows:[{body:forma},{body:tabla}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function ultimosCapturados(mensaje){valoresBusqueda={Accion:'Buscar',Campo:''};enviar(mensaje,'Buscar');}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('BotonBorrar').show();$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Guardar'},true);if($$('Forma').validate()){enviar(datosGuardados,'Guardar');$$('Confirmacion').show();}}
function guardarFinal(){$$('Forma').clear();inicial();buscar();}
function borrar(){webix.confirm({title:tituloEliminar,ok:si,cancel:no,type:'confirm-error',text:seguroQueDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(datosEliminados,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();$$('BotonGuardar').show();$$('BotonModificar').hide();inicial();buscar();}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(datosModificados,'Modificar');}}
function modificarFinal(){$$('Forma').clear();$$('BotonGuardar').show();$$('BotonModificar').hide();inicial();buscar();llenarValores();}
function buscar(){valoresBusqueda={Accion:'Buscar',Campo:$$(campo).getValue()};enviar(resultadosEncontrados,'Buscar');}
function llenarValores(){$$('Forma').setValues({Accion:'LlenarValores'},true);enviar(busquedaFinalizada,'LlenarValores');$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();$$('BotonNuevo').hide();$$('BotonModificar').show();}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post('RequisicionesDatosFacturaServlet.jsp',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){setConfirmacion(data.json());idGenerado=data.json().id;if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarFinal();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='LlenarValores'){
	$$('Forma').parse(data.json());
}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}
function setConfirmacion(info){
	$$('FolioFactura').setValue(info.FacturaFolio);
	$$('FacturaMontoTotal').setValue(info.FacturaMontoTotal);
	$$('FacturaFechaIdealPago').setValue(info.FacturaFechaIdealPago);
	$$('FacturaObservaciones').setValue(info.FacturaObservaciones);
}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	Id: $$('Tabla').getItem(id).Id,
	FacturaFolio: $$('Tabla').getItem(id).FacturaFolio,
	FacturaMontoTotal: $$('Tabla').getItem(id).FacturaMontoTotal,
	FacturaFechaIdealPago: $$('Tabla').getItem(id).FacturaFechaIdealPago,
	FacturaObservaciones: $$('Tabla').getItem(id).FacturaObservaciones,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

//var servletIdCentroCostos='RequisicionesCentroCostosServlet.jsp';var listaIdCentroCostos=$$('IdCentroCostos').getPopup().getList();listaIdCentroCostos.clearAll();listaIdCentroCostos.load(servletIdCentroCostos + '?Accion=getRequisicionesCentroCostosId&filter[value]=');
//var servletIdCuentas='PresupuestoCuentasServlet.jsp';var listaIdCuentas=$$('IdCuentas').getPopup().getList();listaIdCuentas.clearAll();listaIdCuentas.load(servletIdCuentas + '?Accion=getPresupuestoCuentasEgresos&filter[value]=');

inicial();llenarValores();$$('Tabla').hide();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//RequisicionesAplicacion.jsp
%>
