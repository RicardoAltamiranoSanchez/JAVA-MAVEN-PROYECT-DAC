<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/RequisicionesServlet';
var servlet='RequisicionesServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='vacio.jsp';var archivo1='vacio.jsp';var archivo2='vacio.jsp';var modoSubforma=true;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:'Importe',valor:'0'}");
out.print(",{campo:'Iva',valor:'0'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var Fecha = 'Fecha'.toUpperCase();
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
var Moneda = 'Moneda'.toUpperCase();

var forma={view:'tabview',cells:[
	{header:"GENERAL",body:{view:'form',id:'Forma',width:700,height:150,elements:[
		{cols:[
			{view:'datepicker',id:'Fecha',name:'Fecha',value: new Date(),placeholder:Fecha,width:210,label:Fecha,labelWidth:100,labelPosition:'left',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:true,hidden:true},//*
			{view:'combo',id:'IdProveedores',name:'IdProveedores',value:'',placeholder:IdProveedores,label:IdProveedores,labelWidth:100,labelPosition:'left',labelAlign:'center',options:[],yCount:'3',required:true,hidden:true},//*
		]},
		{cols:[
			{view:'combo',id:'IdEmpresas',name:'IdEmpresas',value:'',placeholder:IdEmpresas,label:IdEmpresas,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true},
			{view:'combo',id:'IdPara',name:'IdPara',value:'',placeholder:IdPara,label:IdPara,labelWidth:100,labelPosition:'left',options:[],yCount:'3',labelAlign:'right',required:true,hidden:true},//*
		]},
		{view:'text',id:'Descripcion',name:'Descripcion',value:'',placeholder:Descripcion,label:Descripcion,labelWidth:100,labelPosition:'left',required:true,hidden:true},//*
		{cols:[
			{rows:[
				{view:'combo',id:'FormaPago',name:'FormaPago',value:'',placeholder:FormaPago,label:FormaPago,labelWidth:130,labelPosition:'left',required:true,options:["DEPOSITO","CHEQUE","EFECTIVO","TRANSFERENCIA"],yCount:'3',hidden:true},//*
				{view:'textarea',id:'InstruccionesPago',name:'InstruccionesPago',value:'',placeholder:InstruccionesPago,label:InstruccionesPago,height:100,labelWidth:150,labelPosition:'left',labelWidth:150,hidden:true},//*
			]},
			{rows:[
				{view:'text',id:'Importe',name:'Importe',value:'',placeholder:Importe,label:Importe,labelWidth:100,labelPosition:'left',labelAlign:'right',hidden:true},
				{view:'text',id:'Iva',name:'Iva',value:'',placeholder:Iva,label:Iva,labelWidth:100,labelPosition:'left',labelAlign:'right',hidden:true},
				{view:'text',id:'Total',name:'Total',value:'',placeholder:Total,label:Total,labelWidth:100,labelPosition:'left',labelAlign:'right',required:true,hidden:true},//*
				{view:'combo',id:'Moneda',name:'Moneda',value:'',placeholder:Moneda,label:Moneda,labelWidth:100,labelPosition:'left',labelAlign:'right',required:true,options:[],yCount:'3',hidden:true},//*
			]}
		]},
		{view:'text',id:'Estatus',name:'Estatus',value:'',placeholder:Estatus,label:Estatus,labelWidth:100,labelPosition:'left',hidden:true},
		{view:'text',id:'MotivoRechazo',name:'MotivoRechazo',value:'',placeholder:MotivoRechazo,label:MotivoRechazo,labelWidth:100,labelPosition:'left',hidden:true},
		{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]}
		]}
	},
	{header:"APLICACION",body:{view:'scrollview',scroll:"y",body:{view:'iframe',id:'FrameSubforma',width:700,src:'vacio.jsp',hidden:true}}},
	{header:"ARCHIVOS",body:{view:'scrollview',scroll:"y",body:{view:'iframe',id:'FrameArchivos',width:700,src:'vacio.jsp',hidden:true}}},
	{header:"DATOS FACTURA",body:{view:'scrollview',scroll:"y",body:{view:'iframe',id:'FrameDatosFactura',width:700,src:'vacio.jsp',hidden:true}}}
]};

	;
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Fecha',header:Fecha,width:75},
	{id:'Total',header:Total,sort:'string',width:75,format:webix.i18n.numberFormat,css:{"text-align":"right"}},
	{id:'Moneda',header:Moneda,sort:'string',width:150},
	{id:'Proveedores',header:IdProveedores,sort:'string',fillspace:true,sort:'string',minWidth:150},
	{id:'Para',header:IdPara,sort:'string',width:150},
	{id:'Empresas',header:'EMPRESA',sort:'string',width:150},
	{id:'Estatus',header:Estatus,sort:'string',width:75},
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'toolbar',cols:[{},{view:'button',id:'BotonBorrar',value:etiquetaBotonBorrar,width:85,click:'borrar'},{view:'text',id:'CampoBuscar',name:'CampoBuscar',value:'',placeholder:etiquetaBotonBuscar,width:300},{view:'button',id:'BotonBuscar',value:etiquetaBotonBuscar,width:85,click:'buscar'}]},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{body:forma},{body:tabla}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){$$('FrameSubforma').hide();clearSubforma();}$$('Fecha').setValue(new Date());}
function ultimosCapturados(mensaje){valoresBusqueda={Accion:'BuscarFolio',Campo:''};enviar(mensaje,'Buscar');}
function nuevo(){/* $$('BotonGuardar').show();*/$$('BotonModificar').hide();/* $$('BotonBorrar').show(); */$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function guardar(){$$('Forma').setValues({Accion:'Guardar'},true);if($$('Forma').validate()){enviar(datosGuardados,'Guardar');}}
function guardarFinal(){if(modoSubforma){$$('BotonGuardar').hide();ultimosCapturados(datosGuardados);setSubforma();}else{$$('Forma').clear();inicial();ultimosCapturados(datosGuardados);}}
function borrar(){webix.confirm({title:tituloEliminar,ok:si,cancel:no,type:'confirm-error',text:seguroQueDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(datosEliminados,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();enviar(datosEliminados,'Buscar');/* $$('BotonGuardar').show(); */$$('BotonModificar').hide();if(modoSubforma){$$('FrameSubforma').hide();}}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(datosModificados,'Modificar');}}
function modificarFinal(){if(modoSubforma){enviar(datosModificados,'BuscarFolio');}else{$$('Forma').clear();enviar(datosModificados,'BuscarFolio');/* $$('BotonGuardar').show(); */$$('BotonModificar').hide();}}
function buscar(){if($$('CampoBuscar').getValue()==''){$$('CampoBuscar').setValue('%');}valoresBusqueda={Accion:'BuscarFolio',Campo:$$('CampoBuscar').getValue()};enviar(resultadosEncontrados,'BuscarFolio');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='BuscarFolio'){valores=valoresBusqueda;}webix.ajax().post(servlet,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='BuscarFolio'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	Fecha: $$('Tabla').getItem(id).Fecha,
	IdProveedores: $$('Tabla').getItem(id).IdProveedores,
	IdEmpresas: $$('Tabla').getItem(id).IdEmpresas,
	IdPara: $$('Tabla').getItem(id).IdPara,
	FormaPago: $$('Tabla').getItem(id).FormaPago,
	InstruccionesPago: $$('Tabla').getItem(id).InstruccionesPago,
	Descripcion: $$('Tabla').getItem(id).Descripcion,
	Importe: $$('Tabla').getItem(id).Importe,
	Iva: $$('Tabla').getItem(id).Iva,
	Total: $$('Tabla').getItem(id).Total,
	Estatus: $$('Tabla').getItem(id).Estatus,
	Moneda: $$('Tabla').getItem(id).Moneda,
	MotivoRechazo: $$('Tabla').getItem(id).MotivoRechazo,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if(modoSubforma){setSubforma();}if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});


var servletIdProveedores='ProveedoresServlet.jsp';var listaIdProveedores=$$('IdProveedores').getPopup().getList();listaIdProveedores.clearAll();listaIdProveedores.load(servletIdProveedores + '?Accion=getProveedores&filter[value]=');
var servletIdEmpresas='RequisicionesEmpresasServlet.jsp';var listaIdEmpresas=$$('IdEmpresas').getPopup().getList();listaIdEmpresas.clearAll();listaIdEmpresas.load(servletIdEmpresas + '?Accion=getRequisicionesEmpresas&filter[value]=');
var servletIdPara='RequisicionesParaServlet.jsp';var listaIdPara=$$('IdPara').getPopup().getList();listaIdPara.clearAll();listaIdPara.load(servletIdPara + '?Accion=getRequisicionesPara&filter[value]=');

$$('InstruccionesPago').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('InstruccionesPago').setValue(nuevo);});
$$('Descripcion').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Descripcion').setValue(nuevo);});

$$('Estatus').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Estatus').setValue(nuevo);});
$$('MotivoRechazo').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('MotivoRechazo').setValue(nuevo);});

function suma() {
	var importe = parseFloat($$('Importe').getValue());
	var iva = parseFloat($$('Iva').getValue());
	var total = importe + iva;
	$$('Total').setValue(total);
}

function setSubforma(){
	$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);
	$$('FrameArchivos').show();$$('FrameArchivos').load(archivo1+'?IdGenerado='+idGenerado);
	$$('FrameArchivos').show();$$('FrameDatosFactura').load(archivo2+'?IdGenerado='+idGenerado);
}

function clearSubforma(){
	$$('FrameSubforma').show();$$('FrameSubforma').load('vacio.jsp');
	$$('FrameArchivos').show();$$('FrameArchivos').load('vacio.jsp');
	$$('FrameDatosFactura').show();$$('FrameDatosFactura').load('vacio.jsp');
}

var listaMoneda = $$("Moneda").getPopup().getList();listaMoneda.clearAll();listaMoneda.load("MonedasServlet.jsp?Accion=getMonedasClave&filter[value]=");

inicial();/* ultimosCapturados(ultimos5); */ $$('BotonGuardar').hide();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//Requisiciones.jsp
%>
