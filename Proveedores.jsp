<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/ProveedoresServlet';
var servlet='ProveedoresServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='ProveedoresDoc.jsp';var modoSubforma=true;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:'Estatus',valor:'Activo'}");
out.println("];");%>

var Fecha = 'Fecha'.toUpperCase();
var Alias = 'Alias'.toUpperCase();
var Nombre = 'Nombre'.toUpperCase();
var Rfc = 'Rfc'.toUpperCase();
var Direccion = 'Direccion'.toUpperCase();
var NumeroExterior = 'Num.Ext.'.toUpperCase();
var NumeroInterior = 'Num.Int.'.toUpperCase();
var Colonia = 'Colonia'.toUpperCase();
var CodigoPostal = 'C.P.'.toUpperCase();
var Telefono = 'Telefono'.toUpperCase();
var Ciudad = 'Ciudad'.toUpperCase();
var Estado = 'Estado'.toUpperCase();
var Pais = 'Pais'.toUpperCase();
var GiroEmpresa = 'Giro Empresa'.toUpperCase();
var SitioInternet = 'Sitio Internet'.toUpperCase();
var Contacto = 'Contacto'.toUpperCase();
var Extension = 'Extension'.toUpperCase();
var Celular = 'Celular'.toUpperCase();
var Email = 'Email'.toUpperCase();
var DaCredito = 'Credito'.toUpperCase();
var DiasCredito = 'Dias de Credito'.toUpperCase();
var Banco1 = 'Banco'.toUpperCase();
var CuentaBancaria1 = 'Cuenta Bancaria'.toUpperCase();
var Clabe1 = 'Clabe Interbancaria'.toUpperCase();
var Moneda1 = 'Moneda'.toUpperCase();
var Banco2 = 'Banco 2'.toUpperCase();
var CuentaBancaria2 = 'Cuenta Bancaria 2'.toUpperCase();
var Clabe2 = 'Clabe 2'.toUpperCase();
var Moneda2 = 'Moneda 2'.toUpperCase();
var Estatus = 'Estatus'.toUpperCase();
var Comentarios = 'Comentarios'.toUpperCase();

var forma={rows:[
  {view:"tabview",id:'tabsForma',cells:[
	{header:"DATOS GENERALES",body:{view:'form',id:'Forma',scroll:'y',width:600,height:'100%',elements:[
	  {view:"fieldset", label:"GENERALES",width:400,body:{rows:[
		{cols:[
		  {view:'datepicker',id:'Fecha',name:'Fecha',value: new Date(),placeholder:Fecha,label:Fecha,labelWidth:80,labelPosition:'left',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:true},
		  {}
		]},
		{cols:[
			{view:'text',id:'Alias',name:'Alias',value:'',placeholder:Alias,label:Alias,labelWidth:80,labelPosition:'left',required:true},
			{view:'text',id:'Rfc',name:'Rfc',value:'',placeholder:Rfc,label:Rfc,labelWidth:80,labelAlign:'center',labelPosition:'left',required:true},
		]},
		{view:'text',id:'Nombre',name:'Nombre',value:'',placeholder:Nombre,label:Nombre,labelWidth:80,labelPosition:'left',required:true},
		{view:'text',id:'Direccion',name:'Direccion',value:'',placeholder:Direccion,label:Direccion,labelWidth:80,labelPosition:'left'},
		{cols:[
			{view:'text',id:'NumeroExterior',name:'NumeroExterior',value:'',placeholder:NumeroExterior,label:NumeroExterior,labelWidth:80,labelPosition:'left'},
			{view:'text',id:'NumeroInterior',name:'NumeroInterior',value:'',placeholder:NumeroInterior,label:NumeroInterior,labelWidth:80,labelAlign:'center',labelPosition:'left'},
		]},
		{cols:[
			{view:'text',id:'Colonia',name:'Colonia',value:'',placeholder:Colonia,label:Colonia,labelWidth:80,labelPosition:'left'},
			{view:'text',id:'CodigoPostal',name:'CodigoPostal',value:'',placeholder:CodigoPostal,label:CodigoPostal,labelWidth:80,labelAlign:'center',labelPosition:'left'},
		]},
		{view:'text',id:'Telefono',name:'Telefono',value:'',placeholder:Telefono,label:Telefono,labelWidth:80,labelPosition:'left',required:true},
		{cols:[
			{view:'text',id:'Ciudad',name:'Ciudad',value:'',placeholder:Ciudad,label:Ciudad,labelWidth:80,labelPosition:'top'},
			{view:'text',id:'Estado',name:'Estado',value:'',placeholder:Estado,label:Estado,labelWidth:80,labelPosition:'top'},
			{view:'text',id:'Pais',name:'Pais',value:'',placeholder:Pais,label:Pais,labelWidth:80,labelPosition:'top'},
		]},
		{view:'text',id:'GiroEmpresa',name:'GiroEmpresa',value:'',placeholder:GiroEmpresa,label:GiroEmpresa,labelWidth:100,labelPosition:'left'},
		{view:'text',id:'SitioInternet',name:'SitioInternet',value:'',placeholder:SitioInternet,label:SitioInternet,labelWidth:100,labelPosition:'left'},
	  ]}},
	  {view:"fieldset", label:"CONTACTO",width:400,body:{rows:[
		{view:'text',id:'Contacto',name:'Contacto',value:'',placeholder:Contacto,label:Contacto,labelWidth:80,labelPosition:'left'},
		{cols:[
			{view:'text',id:'Extension',name:'Extension',value:'',placeholder:Extension,label:Extension,labelWidth:80,labelPosition:'left'},
			{view:'text',id:'Celular',name:'Celular',value:'',placeholder:Celular,label:Celular,labelWidth:70,labelAlign:'center',labelPosition:'left'},
		]},
		{view:'text',id:'Email',name:'Email',value:'',placeholder:Email,label:Email,labelWidth:80,labelPosition:'left'},
	  ]}},	
	  {view:"fieldset", label:"CREDITO Y BANCARIOS",width:400,body:{rows:[
		{cols:[
			{view:'combo',id:'DaCredito',name:'DaCredito',value:'',placeholder:DaCredito,label:DaCredito,labelWidth:80,labelPosition:'left',required:true,yCount:'5',options:[{id:'Si',value:'Si'},{id:'No',value:'No'}]},
			{view:'text',id:'DiasCredito',name:'DiasCredito',value:'',placeholder:DiasCredito,label:DiasCredito,labelWidth:80,labelAlign:'center',labelPosition:'left'},
		]},
		{cols:[
			{view:'text',id:'Banco1',name:'Banco1',value:'',placeholder:Banco1,label:Banco1,labelWidth:80,labelPosition:'top'},
			{view:'text',id:'CuentaBancaria1',name:'CuentaBancaria1',value:'',placeholder:CuentaBancaria1,label:CuentaBancaria1,labelWidth:80,labelPosition:'top'},
			{view:'text',id:'Clabe1',name:'Clabe1',value:'',placeholder:Clabe1,label:Clabe1,labelWidth:80,labelPosition:'top'},
			{view:'text',id:'Moneda1',name:'Moneda1',value:'',placeholder:Moneda1,label:Moneda1,labelWidth:80,labelPosition:'top'},
		]},
		{cols:[
			{view:'text',id:'Banco2',name:'Banco2',value:'',placeholder:Banco2,labelWidth:80,labelPosition:'left'},
			{view:'text',id:'CuentaBancaria2',name:'CuentaBancaria2',value:'',placeholder:CuentaBancaria2,labelWidth:80,labelPosition:'left'},
			{view:'text',id:'Clabe2',name:'Clabe2',value:'',placeholder:Clabe2,labelWidth:80,labelPosition:'left'},
			{view:'text',id:'Moneda2',name:'Moneda2',value:'',placeholder:Moneda2,labelWidth:80,labelPosition:'left'},
		]},
	  ]}},
	  {view:"fieldset", label:"ESTATUS Y COMENTARIOS",width:400,body:{rows:[
		  {view:'combo',id:'Estatus',name:'Estatus',value:'',placeholder:Estatus,label:Estatus,labelWidth:80,labelPosition:'left',required:true,yCount:'5',options:[{id:'Activo',value:'Activo'},{id:'NoActivo',value:'NoActivo'},{id:'Baja',value:'Baja'}]},
		{view:'textarea',id:'Comentarios',name:'Comentarios',value:'',placeholder:Comentarios,label:Comentarios,labelWidth:80,labelPosition:'left',height:100},
	  ]}},
	  ]}
	},
	{header:"DOCS, CONTRATOS",body:{id:'PanelSubForma',scroll:'y',width:600,rows:[
			{view:'iframe',id:'FrameSubforma',height:450,src:archivo},
			{}
		]}
	}
  ]},
  {view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]}	
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Alias',header:Alias,width:80,sort:'string'},
	{id:'Rfc',header:Alias,width:80,sort:'string'},
	{id:'Nombre',header:Nombre,sort:'string',fillspace:true,sort:'string',minWidth:150,sort:'string'},
	{id:'Telefono',header:Telefono,sort:'string',width:100,sort:'string'},
	{id:'Contacto',header:Contacto,sort:'string',width:150,sort:'string'},
	{id:'Email',header:Email,sort:'string',width:150,sort:'string'},
	{id:'Estatus',header:Estatus,sort:'string',width:80,sort:'string'}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'toolbar',cols:[{},{view:'button',id:'BotonBorrar',value:etiquetaBotonBorrar,width:85,click:'borrar'},{view:'text',id:'CampoBuscar',name:'CampoBuscar',value:'',placeholder:etiquetaBotonBuscar,width:300},{view:'button',id:'BotonBuscar',value:etiquetaBotonBuscar,width:85,click:'buscar'}]},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{body:tabla}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){$$('FrameSubforma').hide();}$$('tabsForma').setValue('Forma');}
function ultimosCapturados(mensaje){valoresBusqueda={Accion:'Buscar',Campo:''};enviar(mensaje,'Buscar');}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('BotonBorrar').show();$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function guardar(){$$('Forma').setValues({Accion:'Guardar'},true);if($$('Forma').validate()){enviar(datosGuardados,'Guardar');}}
function guardarFinal(){if(modoSubforma){$$('BotonGuardar').hide();ultimosCapturados(datosGuardados);setSubforma();}else{$$('Forma').clear();inicial();ultimosCapturados(datosGuardados);}}
function borrar(){webix.confirm({title:tituloEliminar,ok:si,cancel:no,type:'confirm-error',text:seguroQueDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(datosEliminados,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();enviar(datosEliminados,'Buscar');$$('BotonGuardar').show();$$('BotonModificar').hide();if(modoSubforma){$$('FrameSubforma').hide();}}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(datosModificados,'Modificar');}}
function modificarFinal(){if(modoSubforma){enviar(datosModificados,'Buscar');}else{$$('Forma').clear();enviar(datosModificados,'Buscar');$$('BotonGuardar').show();$$('BotonModificar').hide();}}
function buscar(){if($$('CampoBuscar').getValue()==''){$$('CampoBuscar').setValue('%');}valoresBusqueda={Accion:'Buscar',Campo:$$('CampoBuscar').getValue()};enviar(resultadosEncontrados,'Buscar');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post(servlet,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	Fecha: $$('Tabla').getItem(id).Fecha,
	Alias: $$('Tabla').getItem(id).Alias,
	Nombre: $$('Tabla').getItem(id).Nombre,
	Rfc: $$('Tabla').getItem(id).Rfc,
	Direccion: $$('Tabla').getItem(id).Direccion,
	NumeroExterior: $$('Tabla').getItem(id).NumeroExterior,
	NumeroInterior: $$('Tabla').getItem(id).NumeroInterior,
	Colonia: $$('Tabla').getItem(id).Colonia,
	CodigoPostal: $$('Tabla').getItem(id).CodigoPostal,
	Telefono: $$('Tabla').getItem(id).Telefono,
	Ciudad: $$('Tabla').getItem(id).Ciudad,
	Estado: $$('Tabla').getItem(id).Estado,
	Pais: $$('Tabla').getItem(id).Pais,
	GiroEmpresa: $$('Tabla').getItem(id).GiroEmpresa,
	SitioInternet: $$('Tabla').getItem(id).SitioInternet,
	Contacto: $$('Tabla').getItem(id).Contacto,
	Extension: $$('Tabla').getItem(id).Extension,
	Celular: $$('Tabla').getItem(id).Celular,
	Email: $$('Tabla').getItem(id).Email,
	DaCredito: $$('Tabla').getItem(id).DaCredito,
	DiasCredito: $$('Tabla').getItem(id).DiasCredito,
	Banco1: $$('Tabla').getItem(id).Banco1,
	CuentaBancaria1: $$('Tabla').getItem(id).CuentaBancaria1,
	Clabe1: $$('Tabla').getItem(id).Clabe1,
	Moneda1: $$('Tabla').getItem(id).Moneda1,
	Banco2: $$('Tabla').getItem(id).Banco2,
	CuentaBancaria2: $$('Tabla').getItem(id).CuentaBancaria2,
	Clabe2: $$('Tabla').getItem(id).Clabe2,
	Moneda2: $$('Tabla').getItem(id).Moneda2,
	Estatus: $$('Tabla').getItem(id).Estatus,
	Comentarios: $$('Tabla').getItem(id).Comentarios,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if(modoSubforma){setSubforma();}if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

$$('Alias').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Alias').setValue(nuevo);});
$$('Nombre').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Nombre').setValue(nuevo);});
$$('Rfc').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Rfc').setValue(nuevo);});
$$('Direccion').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Direccion').setValue(nuevo);});
$$('NumeroExterior').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('NumeroExterior').setValue(nuevo);});
$$('NumeroInterior').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('NumeroInterior').setValue(nuevo);});
$$('Colonia').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Colonia').setValue(nuevo);});
$$('CodigoPostal').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('CodigoPostal').setValue(nuevo);});
$$('Telefono').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Telefono').setValue(nuevo);});
$$('Ciudad').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Ciudad').setValue(nuevo);});
$$('Estado').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Estado').setValue(nuevo);});
$$('Pais').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Pais').setValue(nuevo);});
$$('Contacto').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Contacto').setValue(nuevo);});
$$('Email').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Email').setValue(nuevo);});
$$('DiasCredito').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('DiasCredito').setValue(nuevo);});
$$('Banco1').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Banco1').setValue(nuevo);});
$$('CuentaBancaria1').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('CuentaBancaria1').setValue(nuevo);});
$$('Clabe1').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Clabe1').setValue(nuevo);});
$$('Moneda1').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Moneda1').setValue(nuevo);});
$$('Banco2').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Banco2').setValue(nuevo);});
$$('CuentaBancaria2').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('CuentaBancaria2').setValue(nuevo);});
$$('Clabe2').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Clabe2').setValue(nuevo);});
$$('Moneda2').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Moneda2').setValue(nuevo);});
$$('Comentarios').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Comentarios').setValue(nuevo);});

function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();ultimosCapturados(ultimos5);
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//Proveedores.jsp
%>
