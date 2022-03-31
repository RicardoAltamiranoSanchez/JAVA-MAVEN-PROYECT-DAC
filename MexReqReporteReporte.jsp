<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
var servlet='MexReqReporteServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var IdReq = '#Req'.toUpperCase();
var Fecha = 'Fecha'.toUpperCase();
var Alias = 'Proveedor'.toUpperCase();
var Nombre = 'Gerente'.toUpperCase();
var Empresa = 'Empresa'.toUpperCase();
var Area = 'Area'.toUpperCase();
var Unidad = 'SubArea'.toUpperCase();
var Principal = 'Principal'.toUpperCase();
var Soporte1 = 'Soporte 1'.toUpperCase();
var Soporte2 = 'Soporte 2'.toUpperCase();

var forma={view:'form',id:'Forma',width:400,height:'100%',elements:[
	{view:'combo',id:'Nombre',name:'Nombre',value:'',placeholder:Nombre,label:Nombre,labelWidth:100,labelPosition:'left',options:[],yCount:'3'},
	{view:'combo',id:'Area',name:'Area',value:'',placeholder:Area,label:Area,labelWidth:100,labelPosition:'left',options:[],yCount:'3'},
{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonBuscar',value:etiquetaBotonBuscar,width:85,click:'buscar'}]},
//{view:'iframe',id:'FrameSubforma',width:'80%',src:archivo},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[
{view:'toolbar',cols:[{view:'button',id:'BotonExcel2',value:'EXCEL',width:85, click:'excel'},{},
	{view:'button',id:'BotonRequisicion',value:'REQUISICION',width:85, click:'requisicion'},
	{view:'button',id:'BotonVistoBueno',value:'VISTO BUENO',width:85, click:'vistoBueno'},
	{view:'button',id:'BotonPreAutorizar',value:'PRE-AUTORIZAR',width:85, click:'preAutorizar'},
	{view:'button',id:'BotonAutorizar',value:'AUTORIZAR',width:85, click:'autorizar'},
	{view:'button',id:'BotonCompras',value:'COMPRAS',width:85, click:'compras'},
	{view:'button',id:'BotonFacturacion',value:'FACTURACION',width:85, click:'facturacion'},
	{view:'button',id:'BotonParteContable',value:'PARTE CONTABLE',width:85, click:'parteContable'}
]},
{view:'label',id:'nota',label:'Doble click sobre el registro para ver detalles.',align:'center'},
{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'id',header:IdReq,width:50},
	{id:'Fecha',header:Fecha,width:75},
	{id:'log',header:'ESTATUS',width:75},
	{id:'Alias',header:Alias,sort:'string',fillspace:true,sort:'string',minWidth:150},
	{id:'Nombre',header:Nombre,sort:'string',width:150},
	{id:'Empresa',header:Empresa,sort:'string',width:150},
	{id:'Area',header:Area,sort:'string',width:75},
	{id:'Unidad',header:Unidad,sort:'string',width:75},
	{id:'Principal',header:Principal,sort:'string',width:150,template:'<a href="cotizacionesMex/#Principal#" target="Documento#id#">#Principal#</a>'}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{body:tabla},{header:'FILTRO DE BUSQUEDA',body:forma}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){$$('FrameSubforma').hide();}}
function nuevo(){$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(resultadosEncontrados,'Buscar');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post(servlet,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());}}});}

function requisicion() {
	webix.confirm({title:'REQUISICION',ok:si,cancel:no,type:'confirm-error',text:'COLOCAR EN REQUISICION',callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{
		$$('Forma').setValues({Accion:'Requisicion',Ids:ids},true);enviar('Requisicion','Requisicion');}}else{$$('Tabla').clearSelection();}}});
}
function vistoBueno() {
	webix.confirm({title:'VISTO BUENO',ok:si,cancel:no,type:'confirm-error',text:'COLOCAR EN VISTO BUENO',callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{
		$$('Forma').setValues({Accion:'VistoBueno',Ids:ids},true);enviar('VistoBueno','VistoBueno');}}else{$$('Tabla').clearSelection();}}});
}
function preAutorizar() {
	webix.confirm({title:'PRE-AUTORIZAR',ok:si,cancel:no,type:'confirm-error',text:'COLOCAR EN PRE-AUTORIZAR',callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{
		$$('Forma').setValues({Accion:'PreAutorizar',Ids:ids},true);enviar('PreAutorizar','PreAutorizar');}}else{$$('Tabla').clearSelection();}}});
}
function autorizar() {
	webix.confirm({title:'AUTORIZAR',ok:si,cancel:no,type:'confirm-error',text:'COLOCAR EN AUTORIZAR',callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{
		$$('Forma').setValues({Accion:'Autorizar',Ids:ids},true);enviar('Autorizar','Autorizar');}}else{$$('Tabla').clearSelection();}}});
}
function compras() {
	webix.confirm({title:'ORDEN COMPRA',ok:si,cancel:no,type:'confirm-error',text:'COLOCAR EN ORDE DE COMPRA',callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{
		$$('Forma').setValues({Accion:'Compras',Ids:ids},true);enviar('Compras','Compras');}}else{$$('Tabla').clearSelection();}}});
}
function facturacion() {
	webix.confirm({title:'FACTURACION',ok:si,cancel:no,type:'confirm-error',text:'COLOCAR EN FACTURACION',callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{
		$$('Forma').setValues({Accion:'Facturacion',Ids:ids},true);enviar('Facturacion','Facturacion');}}else{$$('Tabla').clearSelection();}}});
}
function parteContable() {
	webix.confirm({title:'PARTE CONTABLE',ok:si,cancel:no,type:'confirm-error',text:'COLOCAR EN PARTE CONTABLE',callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{
		$$('Forma').setValues({Accion:'ParteContable',Ids:ids},true);enviar('ParteContable','ParteContable');}}else{$$('Tabla').clearSelection();}}});
}

function excel() {
	webix.toExcel($$("Tabla"));
}

$$('Tabla').attachEvent('onItemDblClick',function(id){
	webix.ui({view:"window",id:'VentanaBuscadorMexReqVoBo',width:1000,height:450,position:'center',modal:true,head:{cols:[{},{view:'button', label:'X', width:50, click:("$$('VentanaBuscadorMexReqVoBo').close();")}]},body:{view:'iframe',id:'Ventana',src:'MexRequerimientosLectura.jsp?Id=' + id}}).show();
});

var listaIdPara=$$('Nombre').getPopup().getList();listaIdPara.clearAll();listaIdPara.load("MexParaServlet.jsp?Accion=getMexParaNombre&filter[value]=");
var servletIdAreas='MexEmpresasAreasServlet.jsp';var listaIdAreas=$$('Area').getPopup().getList();listaIdAreas.clearAll();listaIdAreas.load(servletIdAreas + '?Accion=getMexEmpresasAreasNombre&filter[value]=');

function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();
buscar();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//MexReqVoBoReporte.jsp
%>
