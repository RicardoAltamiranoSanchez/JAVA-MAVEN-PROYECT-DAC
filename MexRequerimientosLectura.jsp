<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/MexRequerimientosServlet';
var servlet='MexRequerimientosServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='<%=request.getParameter("Id")%>';var archivo='MexReqProductosLectura.jsp';var archivo1='MexReqArchivosLectura.jsp';
var archivo2='MexReqFacturasLectura.jsp';var archivo3='MexReqPagosLectura.jsp';
var modoSubforma=true;


var Fecha = 'Fecha'.toUpperCase();
var IdPara = 'Gerente:'.toUpperCase();
var IdProveedores = 'Proveedor elegido'.toUpperCase();
var Justificacion = 'Justificacion'.toUpperCase();
var siguiente = 'Siguiente'.toUpperCase();
var IdEmpresas = 'Facturar A:'.toUpperCase();
var IdAreas = 'Area:'.toUpperCase();
var IdUnidades = 'SubArea:'.toUpperCase();
var Estatus = 'Estatus'.toUpperCase();
var FormaPago = 'Metodo Pago'.toUpperCase();
var MetodoPago = 'Forma Pago'.toUpperCase();
var InstruccionesPago = 'Instrucciones Pago'.toUpperCase();

var forma={view:'form',id:'Forma',width:1000,height:'100%',elements:[
 {cols:[
  {view:"fieldset", label:"REQUERIMIENTO",width:400,body:{rows:[
	{cols:[
		{view:'datepicker',id:'Fecha',name:'Fecha',value: new Date(),placeholder:Fecha,label:Fecha,width:110,labelPosition:'top',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:true},
		{view:'combo',id:'IdProveedores',name:'IdProveedores',value:'',placeholder:IdProveedores,label:IdProveedores,labelWidth:130,labelPosition:'top',options:[],yCount:'3',required:true},	
	]},
	
	{view:'text',id:'Justificacion',name:'Justificacion',value:'',placeholder:Justificacion,label:Justificacion,labelWidth:100,labelPosition:'left',required:true},
	{cols:[
		{view:'combo',id:'IdEmpresas',name:'IdEmpresas',value:'',placeholder:IdEmpresas,label:IdEmpresas,labelPosition:'top',options:[],yCount:'3',required:true},
		{view:'combo',id:'IdPara',name:'IdPara',value:'',placeholder:IdPara,label:IdPara,labelPosition:'top',options:[],yCount:'3'},
	]},
	{cols:[
		{view:'combo',id:'IdAreas',name:'IdAreas',value:'',placeholder:IdAreas,label:IdAreas,labelWidth:100,labelPosition:'top',options:[],yCount:'3',required:true},
		{view:'combo',id:'IdUnidades',name:'IdUnidades',value:'',placeholder:IdUnidades,label:IdUnidades,labelWidth:100,labelPosition:'top',options:[],yCount:'3'},
	]},
	{view:'label',id:'Mensaje',label:'',align:'center'},
	{view:"fieldset", label:"ARCHIVOS DE SOPORTE / COTIZACIONES",width:400,body:{rows:[
			{view:'iframe',id:'FrameSubforma1',width:'100%',borderless:true,src:'vacio.jsp'}
	   ]}}
  ]}},
  {rows:[
	{view:"fieldset", label:"PAGO",width:600,body:{rows:[
			{view:'combo',id:'FormaPago',name:'FormaPago',value:'',placeholder:FormaPago,label:FormaPago,labelWidth:100,labelPosition:'left',required:true,options:["EFECTIVO","TRANSFERENCIA","ANTICIPO"],yCount:'3'},
			{view:'combo',id:'MetodoPago',name:'MetodoPago',value:'',placeholder:MetodoPago,label:MetodoPago,labelWidth:100,labelPosition:'left',required:true,options:["CONTADO","CREDITO"],yCount:'3'},
			{view:'textarea',id:'InstruccionesPago',name:'InstruccionesPago',value:'',placeholder:InstruccionesPago,label:InstruccionesPago,height:50,labelWidth:100,labelPosition:'left'}
		]}}, 
  	{view:"fieldset", label:"PRODUCTOS",width:600,body:{rows:[
			{view:'iframe',id:'FrameSubforma',width:'100%',borderless:true,src:'vacio.jsp'},
  	]}},
  ]},
  {rows:[
  	{view:"fieldset", label:"FACTURAS",width:600,body:{rows:[
  		{view:'iframe',id:'FrameSubforma2',width:'100%',borderless:true,src:'vacio.jsp'},
  	]}},
	{view:"fieldset", label:"PAGOS",width:600,body:{rows:[
		{view:'iframe',id:'FrameSubforma3',width:'100%',borderless:true,src:'vacio.jsp'},
  	]}}
  ]}
  
  ]}
]};

var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',
	rows:[
		{body:forma}
	]
});

function ultimosCapturados(mensaje){valoresBusqueda={Accion:'Buscar',Campo:''};enviar(mensaje,'Buscar');}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('BotonBorrar').show();$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function guardar(){$$('Forma').setValues({Accion:'Guardar'},true);if($$('Forma').validate()){enviar(datosGuardados,'Guardar');}}
function guardarFinal(){if(modoSubforma){$$('BotonGuardar').hide();ultimosCapturados(datosGuardados);setSubforma();}else{$$('Forma').clear();inicial();ultimosCapturados(datosGuardados);}}
function borrar(){webix.confirm({title:tituloEliminar,ok:si,cancel:no,type:'confirm-error',text:seguroQueDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(datosEliminados,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();enviar(datosEliminados,'Buscar');$$('BotonGuardar').show();$$('BotonModificar').hide();if(modoSubforma){$$('FrameSubforma').hide();}}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(datosModificados,'Modificar');}}
function modificarFinal(){if(modoSubforma){enviar(datosModificados,'Buscar');}else{$$('Forma').clear();enviar(datosModificados,'Buscar');$$('BotonGuardar').show();$$('BotonModificar').hide();}}
function buscar(){if($$('CampoBuscar').getValue()==''){$$('CampoBuscar').setValue('%');}valoresBusqueda={Accion:'Buscar',Campo:$$('CampoBuscar').getValue()};enviar(resultadosEncontrados,'Buscar');}
function enviar(mensaje,accion){
	var valores=$$('Forma').getValues();
	if(accion=='Buscar'){valores=valoresBusqueda;}
	webix.ajax().post(servlet,valores,{
		error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},
		success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');
		webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');
		if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}
		else if(accion=='Borrar'){borrarFinal();}
		else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}
		else if(accion=='Consultar'){$$('Forma').setValues(data.json());}
	}}});}

var listaIdPara=$$('IdPara').getPopup().getList();listaIdPara.clearAll();listaIdPara.load("servlet/GerentesServlet?Accion=getGerentes&filter[value]=");
var servletIdProveedores='MexProveedoresServlet.jsp';var listaIdProveedores=$$('IdProveedores').getPopup().getList();listaIdProveedores.clearAll();listaIdProveedores.load(servletIdProveedores + '?Accion=getProveedores&filter[value]=');
$$('Justificacion').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Justificacion').setValue(nuevo);});
var servletIdEmpresas='MexEmpresasServlet.jsp';var listaIdEmpresas=$$('IdEmpresas').getPopup().getList();listaIdEmpresas.clearAll();listaIdEmpresas.load(servletIdEmpresas + '?Accion=getMexEmpresas&filter[value]=');

$$('IdEmpresas').attachEvent('onChange',function(nuevo,anterior){
	if(nuevo !== '') {
		getAreas(nuevo);	
	}
});
function getAreas(nuevo) {
	var servletIdAreas='MexEmpresasAreasServlet.jsp';var listaIdAreas=$$('IdAreas').getPopup().getList();listaIdAreas.clearAll();listaIdAreas.load(servletIdAreas + '?Accion=getMexEmpresasAreas&filter[value]=' + nuevo);
}

$$('IdAreas').attachEvent('onChange',function(nuevo,anterior){
	if(nuevo !== '') {
		getUnidades(nuevo);
	}
});
function getUnidades(nuevo) {
	var servletIdUnidades='MexEmpresasUnidadesServlet.jsp';var listaIdUnidades=$$('IdUnidades').getPopup().getList();listaIdUnidades.clearAll();listaIdUnidades.load(servletIdUnidades + '?Accion=getMexEmpresasUnidades&filter[value]=' + nuevo);
}

function setSubforma(){
	$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);
	$$('FrameSubforma1').show();$$('FrameSubforma1').load(archivo1+'?IdGenerado='+idGenerado);
	$$('FrameSubforma2').show();$$('FrameSubforma2').load(archivo2+'?IdGenerado='+idGenerado);
	$$('FrameSubforma3').show();$$('FrameSubforma3').load(archivo3+'?IdGenerado='+idGenerado);
}

function setVacio(){
	$$('FrameSubforma').show();$$('FrameSubforma').load('vacio.jsp');
	$$('FrameSubforma1').show();$$('FrameSubforma1').load('vacio.jsp');
	$$('FrameSubforma2').show();$$('FrameSubforma2').load('vacio.jsp');
	$$('FrameSubforma3').show();$$('FrameSubforma3').load('vacio.jsp');
}

function consulta() {
	$$('Forma').setValues({Accion:'Consultar',Id:idGenerado},true);
	enviar("","Consultar");
}
setSubforma();
consulta();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//MexRequerimientos.jsp
%>
