<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/RequisicionesReporteServlet';
var servlet='RequisicionesServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var Fecha = 'Fecha'.toUpperCase();
var De = 'De'.toUpperCase();
var IdProveedores = 'Proveedor'.toUpperCase();
var IdEmpresas = 'Empresa'.toUpperCase();
var IdPara = 'Para'.toUpperCase();
var FormaPago = 'Forma de Pago'.toUpperCase();
var InstruccionesPago = 'Instrucciones de Pago'.toUpperCase();
var Descripcion = 'Descripcion'.toUpperCase();
var Importe = 'Importe'.toUpperCase();
var Iva = 'Iva'.toUpperCase();
var Total = 'Total'.toUpperCase();
var Estatus = 'Estatus'.toUpperCase();
var MotivoRechazo = 'Motivo de Rechazo'.toUpperCase();
var Motivo = 'Motivo de Rechazo'.toUpperCase();

var forma={view:'form',id:'Forma',width:1,hidden:true,height:'100%',elements:[
	{view:'text',id:'Fecha',name:'Fecha',value:'',placeholder:Fecha,label:Fecha,labelWidth:100,labelPosition:'left',required:true},
	{view:'combo',id:'IdProveedores',name:'IdProveedores',value:'',placeholder:IdProveedores,label:IdProveedores,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true},
	{view:'combo',id:'IdEmpresas',name:'IdEmpresas',value:'',placeholder:IdEmpresas,label:IdEmpresas,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true},
	{view:'combo',id:'IdPara',name:'IdPara',value:'',placeholder:IdPara,label:IdPara,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true},
	{view:'text',id:'FormaPago',name:'FormaPago',value:'',placeholder:FormaPago,label:FormaPago,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'InstruccionesPago',name:'InstruccionesPago',value:'',placeholder:InstruccionesPago,label:InstruccionesPago,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Descripcion',name:'Descripcion',value:'',placeholder:Descripcion,label:Descripcion,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Importe',name:'Importe',value:'',placeholder:Importe,label:Importe,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Iva',name:'Iva',value:'',placeholder:Iva,label:Iva,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Total',name:'Total',value:'',placeholder:Total,label:Total,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Estatus',name:'Estatus',value:'',placeholder:Estatus,label:Estatus,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'MotivoRechazo',name:'MotivoRechazo',value:'',placeholder:MotivoRechazo,label:MotivoRechazo,labelWidth:100,labelPosition:'left',required:true},
{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonBuscar',value:etiquetaBotonBuscar,width:85,click:'buscar'}]},
//{view:'iframe',id:'FrameSubforma',width:'80%',src:archivo},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[
{view:'toolbar',cols:[{},{view:'button',id:'BotonExcel',value:'EXCEL',width:85, click:'excel'},{view:'button',id:'BotonPdf',value:'AUTORIZAR',width:85, click:'autorizar'},{view:'button',id:'BotonRechazar',value:'RECHAZAR',width:85, click:'rechazar'}]},
{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Fecha',header:Fecha,width:75},
	{id:'Proveedores',header:IdProveedores,sort:'string',fillspace:true,sort:'string',minWidth:150},
	{id:'Total',header:Total,sort:'string',width:75,format:webix.i18n.numberFormat,css:{"text-align":"right"}},
	{id:'De',header:De,sort:'string',width:150},
	{id:'Para',header:IdPara,sort:'string',width:150},
	{id:'FormaPago',header:FormaPago,sort:'string',width:150},
	{id:'InstruccionesPago',header:InstruccionesPago,sort:'string',width:150},
	{id:'Descripcion',header:Descripcion,sort:'string',width:150},
	{id:'Estatus',header:Estatus,sort:'string',width:75},
	{id:'MotivoRechazo',header:MotivoRechazo,sort:'string',width:150}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{body:tabla},{body:forma}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){$$('FrameSubforma').hide();}}
function nuevo(){$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function buscar(){$$('Forma').setValues({Accion:'BuscarAutorizar'},true);enviar(resultadosEncontrados,'Buscar');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post(servlet,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());if(accion=='Autorizar'||accion=='Rechazar'){buscar();}}}});}

function excel() {
	webix.toExcel($$("Tabla"));
}
function autorizar() {
	webix.confirm({title:'AUTORIZAR',ok:si,cancel:no,type:'confirm-error',text:'Autorizar a las requisiciones seleccionadas?',callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Autorizar',Ids:ids},true);enviar('Autorizar','Autorizar');}}else{$$('Tabla').clearSelection();}}});
}
function rechazar() {
	webix.ui({view:"window",id:'VentanaRechazar',width:450,height:450,position:'center',modal:true,head:{cols:[{},{view:'button', label:'X', width:50, click:("$$('VentanaRechazar').close();")}]},
		body:{cols:[
			{view:'textarea',id:'Motivo',name:'Motivo',value:'',placeholder:Motivo,label:Motivo,height:100,labelWidth:100,labelPosition:'top'},
			{view:'button',id:'BotonRechazar2',value:'RECHAZAR',width:85, click:'rechazar2'}
		]}}
	).show();
}
function rechazar2(){
	var ids=$$('Tabla').getSelectedId();
	$$('Forma').setValues({Accion:'Rechazar',Ids:ids,MotivoRechazo:$$('Motivo').getValue()},true);
	enviar('Rechazar','Rechazar');
	$$('VentanaRechazar').close();
}

$$('Tabla').attachEvent('onItemDblClick',function(id){
	webix.ui({view:"window",id:'VentanaBuscadorRequisicion',width:720,height:350,position:'center',modal:true,head:{cols:[{},{view:'button', label:'X', width:50, click:("$$('VentanaBuscadorRequisicion').close();")}]},body:{view:'iframe',id:'Ventana',src:'RequisicionesLectura.jsp?Id=' + id}}).show();
});

function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();buscar();</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//RequisicionesReporte.jsp
%>