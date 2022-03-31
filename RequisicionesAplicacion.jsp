<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
var nada='';var valoresBusqueda='';var idGenerado='';var campo='IdRequisiciones';
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:campo,valor:'" + request.getParameter("IdGenerado") + "'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var IdRequisiciones = 'IdRequisiciones';
var IdCentroCostos = 'Centro Costos'.toUpperCase();
var IdCuentas = 'Cuenta'.toUpperCase();
var Importe = 'Importe'.toUpperCase();

var forma={view:'form',id:'Forma',elements:[
	{view:'text',id:'IdRequisiciones',name:'IdRequisiciones',value:'',placeholder:IdRequisiciones,label:IdRequisiciones,labelWidth:100,labelPosition:'left',hidden:true},
	{rows:[
		{cols:[
		{view:'combo',id:'IdCentroCostos',name:'IdCentroCostos',value:'',placeholder:IdCentroCostos,label:IdCentroCostos,labelWidth:100,labelPosition:'top',options:[],yCount:'3',required:true},
		
		{view:'text',id:'Importe',name:'Importe',value:'',placeholder:Importe,label:Importe,labelWidth:100,labelPosition:'top',required:true},
		]},
		{view:'combo',id:'IdCuentas',name:'IdCuentas',value:'',placeholder:IdCuentas,label:IdCuentas,labelWidth:100,labelPosition:'top',options:[],yCount:'3',required:true},
	 ]
	},
{view:'toolbar', cols:[{view:'button',id:'BotonBorrar',value:etiquetaBotonBorrar,width:85,click:'borrar'},{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'CentroCostos',header:IdCentroCostos,fillspace:true,sort:'string',minWidth:150},
	{id:'Cuentas',header:IdCuentas,sort:'string',width:200},
	{id:'Importe',header:Importe,sort:'string',width:150,format:webix.i18n.numberFormat,css:{"text-align":"right"}}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'accordion',type:'wide',multi:true,height:'100%',rows:[{body:forma},{body:tabla}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function ultimosCapturados(mensaje){valoresBusqueda={Accion:'Buscar',Campo:''};enviar(mensaje,'Buscar');}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('BotonBorrar').show();$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function guardar(){$$('Forma').setValues({Accion:'Guardar'},true);if($$('Forma').validate()){enviar(datosGuardados,'Guardar');}}
function guardarFinal(){$$('Forma').clear();inicial();buscar();}
function borrar(){webix.confirm({title:tituloEliminar,ok:si,cancel:no,type:'confirm-error',text:seguroQueDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(datosEliminados,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();$$('BotonGuardar').show();$$('BotonModificar').hide();inicial();buscar();}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(datosModificados,'Modificar');}}
function modificarFinal(){$$('Forma').clear();$$('BotonGuardar').show();$$('BotonModificar').hide();inicial();buscar();}
function buscar(){valoresBusqueda={Accion:'Buscar',Campo:$$(campo).getValue()};enviar(resultadosEncontrados,'Buscar');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post('RequisicionesAplicacionServlet.jsp',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	IdRequisiciones: $$('Tabla').getItem(id).IdRequisiciones,
	IdCentroCostos: $$('Tabla').getItem(id).IdCentroCostos,
	IdCuentas: $$('Tabla').getItem(id).IdCuentas,
	Importe: $$('Tabla').getItem(id).Importe,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

var servletIdCentroCostos='RequisicionesCentroCostosServlet.jsp';var listaIdCentroCostos=$$('IdCentroCostos').getPopup().getList();listaIdCentroCostos.clearAll();listaIdCentroCostos.load(servletIdCentroCostos + '?Accion=getRequisicionesCentroCostosId&filter[value]=');
var servletIdCuentas='PresupuestoCuentasServlet.jsp';var listaIdCuentas=$$('IdCuentas').getPopup().getList();listaIdCuentas.clearAll();listaIdCuentas.load(servletIdCuentas + '?Accion=getPresupuestoCuentasEgresos&filter[value]=');

inicial();buscar();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//RequisicionesAplicacion.jsp
%>
