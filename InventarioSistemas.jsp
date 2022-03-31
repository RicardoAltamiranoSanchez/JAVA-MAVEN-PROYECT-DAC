<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/InventarioSistemasServlet';
var servlet='InventarioSistemasServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='InventarioSistemasEmp.jsp'; var archivo1='InventarioSistemasRep.jsp';var modoSubforma=true;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var Serie = 'Serie';
var Folio = 'Folio';
var Empleado = 'Empleado';
var EstatusEmpleado = 'Estatus Empleado';
var FechaAsignacion = 'Fecha Asignacion';
var Responsable = 'Responsable';
var Localizacion = 'Localizacion';
var Division = 'Division';
var Marca = 'Marca';
var NumeroSerie = 'Numero Serie';
var SistemaOperativo = 'Sistema Operativo';
var LicenciaSO = 'Licencia SO';
var Office = 'Office';
var Procesador = 'Procesador';
var Ram = 'Ram';
var DiscoDuro = 'Disco Duro';
var Lcd = 'Lcd';
var FechaCompra = 'Fecha Compra';
var Factura = 'Factura';
var Proveedor = 'Proveedor';
var MacAdressLan = 'Mac Adress Lan';
var MacAdressWifi = 'Mac Adress Wifi';
var NombreEquipo = 'Nombre Equipo';
var Estatus = 'Estatus';
var Reparaciones = 'Reparaciones';
var MotivoBaja = 'Motivo Baja';

var forma={view:'form',id:'Forma',width:800,elements:[
{view:'tabview',type:'clean',cells:[
{header:'PRINCIPAL',body:{rows:[	
	{cols:[
		{view:'combo',id:'Serie',name:'Serie',value:'',placeholder:Serie,label:Serie,labelWidth:100,labelPosition:'left',required:true,options:[{id:'MCS-S',value:'MCS-S'},{id:'MCS-S-OGDL',value:'MCS-S-OGDL (NO USAR)'},{id:'MCS-S-SGDL',value:'MCS-S-SGDL (NO USAR)'},{id:'MCS-S-GDL',value:'MCS-S-GDL (NO USAR)'},{id:'MCS-S-CDMX',value:'MCS-S-CDMX (NO USAR)'}],yCount:'3'},
		{view:'text',id:'Folio',name:'Folio',value:'',placeholder:Folio,label:Folio,labelWidth:100,labelPosition:'left',labelAlign:'center'},
		{view:'combo',id:'Estatus',name:'Estatus',value:'',placeholder:Estatus,label:Estatus,labelWidth:100,labelPosition:'left',required:true,options:['Disponible','En uso','Descompuesto','Obsoleto','Proceso Baja','Baja'],yCount:'3'},
	]},
	{view:"template",template:'EQUIPO', type:'section'},
	{cols:[
		{view:'text',id:'Marca',name:'Marca',value:'',placeholder:Marca,label:Marca,labelWidth:100,labelPosition:'left',required:true},
		{view:'text',id:'NumeroSerie',name:'NumeroSerie',value:'',placeholder:NumeroSerie,label:NumeroSerie,labelWidth:100,labelPosition:'left',labelAlign:'center'},
	]},
	{view:"template",template:'CARACTERISTICAS', type:'section'},
	{cols:[
		{view:'text',id:'SistemaOperativo',name:'SistemaOperativo',value:'',placeholder:SistemaOperativo,label:SistemaOperativo,labelWidth:100,labelPosition:'left'},
		{view:'text',id:'LicenciaSO',name:'LicenciaSO',value:'',placeholder:LicenciaSO,label:LicenciaSO,labelWidth:100,labelPosition:'left',labelAlign:'center'},
		{view:'text',id:'Office',name:'Office',value:'',placeholder:Office,label:Office,labelWidth:100,labelPosition:'left',labelAlign:'center'},
	]},
	{cols:[
		{view:'text',id:'Procesador',name:'Procesador',value:'',placeholder:Procesador,label:Procesador,labelWidth:100,labelPosition:'left'},
		{view:'text',id:'Ram',name:'Ram',value:'',placeholder:Ram,label:Ram,labelWidth:100,labelPosition:'left',labelAlign:'center'},
		{view:'text',id:'DiscoDuro',name:'DiscoDuro',value:'',placeholder:DiscoDuro,label:DiscoDuro,labelWidth:100,labelPosition:'left',labelAlign:'center'},
		{view:'text',id:'Lcd',name:'Lcd',value:'',placeholder:Lcd,label:Lcd,labelWidth:100,labelPosition:'left',labelAlign:'center'},
	]},
	{cols:[
		{view:'text',id:'MacAdressLan',name:'MacAdressLan',value:'',placeholder:MacAdressLan,label:MacAdressLan,labelWidth:100,labelPosition:'left'},
		{view:'text',id:'MacAdressWifi',name:'MacAdressWifi',value:'',placeholder:MacAdressWifi,label:MacAdressWifi,labelWidth:100,labelPosition:'left',labelAlign:'center'},
		{view:'text',id:'NombreEquipo',name:'NombreEquipo',value:'',placeholder:NombreEquipo,label:NombreEquipo,labelWidth:100,labelPosition:'left',labelAlign:'center'},
	]},
	{view:"template",template:'INFO COMPRA', type:'section'},
	{cols:[
		{view:'datepicker',id:'FechaCompra',name:'FechaCompra',value:'',placeholder:FechaCompra,label:FechaCompra,labelWidth:100,labelPosition:'left',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:true},
		{view:'text',id:'Factura',name:'Factura',value:'',placeholder:Factura,label:Factura,labelWidth:100,labelPosition:'left',labelAlign:'center'},
		{view:'text',id:'Proveedor',name:'Proveedor',value:'',placeholder:Proveedor,label:Proveedor,labelWidth:100,labelPosition:'left',labelAlign:'center'},
	]},
	{view:"template",template:'COMENTARIOS', type:'section'},
	{view:'text',id:'MotivoBaja',name:'MotivoBaja',value:'',placeholder:MotivoBaja,label:MotivoBaja,labelWidth:100,labelPosition:'left'},
	{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
	//
]}},
{header:'ASIGNACIONES',body:{rows:[
	  {view:'iframe',id:'FrameSubforma',src:archivo},
]}},
{header:'REPARACIONES',body:{rows:[
	  {view:'iframe',id:'FrameSubforma1',src:archivo1},
]}}
]}
]};
var tabla={id:'PanelTabla',rows:[{view:'datatable',id:'Tabla',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Serie',header:Serie,width:75},
	{id:'Folio',header:Folio,sort:'string',width:50},
	{id:'Estatus',header:Estatus,sort:'string',width:75},
	{id:'Empleado',header:Empleado,sort:'string',width:150},
	{id:'EstatusEmpleado',header:EstatusEmpleado,sort:'string',width:150},
	{id:'FechaAsignacion',header:FechaAsignacion,sort:'string',width:150},
	{id:'Responsable',header:Responsable,sort:'string',width:150},
	{id:'Localizacion',header:Localizacion,sort:'string',width:150},
	{id:'Division',header:Division,sort:'string',width:150},
	{id:'Marca',header:Marca,sort:'string',width:150},
	{id:'NumeroSerie',header:NumeroSerie,sort:'string',width:150},
	{id:'SistemaOperativo',header:SistemaOperativo,sort:'string',width:75},
	{id:'LicenciaSO',header:LicenciaSO,sort:'string',width:75},
	{id:'Office',header:Office,sort:'string',width:75},
	{id:'Procesador',header:Procesador,sort:'string',width:75},
	{id:'Ram',header:Ram,sort:'string',width:75},
	{id:'DiscoDuro',header:DiscoDuro,sort:'string',width:75},
	{id:'Lcd',header:Lcd,sort:'string',width:75},
	{id:'FechaCompra',header:FechaCompra,sort:'string',width:75},
	{id:'Factura',header:Factura,sort:'string',width:75},
	{id:'Proveedor',header:Proveedor,sort:'string',width:75},
	{id:'MacAdressLan',header:MacAdressLan,sort:'string',width:75},
	{id:'MacAdressWifi',header:MacAdressWifi,sort:'string',width:75},
	{id:'NombreEquipo',header:NombreEquipo,sort:'string',width:75},
	{id:'Reparaciones',header:Reparaciones,sort:'string',width:150},
	{id:'MotivoBaja',header:MotivoBaja,sort:'string',width:250}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'toolbar',cols:[{view:'button',id:'BotonExcel',value:'Excel',width:85,click:'excel'},{},{view:'button',id:'BotonBorrar',value:etiquetaBotonBorrar,width:85,click:'borrar'},{view:'text',id:'CampoBuscar',name:'CampoBuscar',value:'',placeholder:etiquetaBotonBuscar,width:300},{view:'button',id:'BotonBuscar',value:etiquetaBotonBuscar,width:85,click:'buscar'}]},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{body:tabla},{header:' ',body:forma}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){
	$$('FrameSubforma').hide();
	$$('FrameSubforma1').hide();
}}
function ultimosCapturados(mensaje){valoresBusqueda={Accion:'Buscar',Campo:''};enviar(mensaje,'Buscar');}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('BotonBorrar').show();$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function guardar(){$$('Forma').setValues({Accion:'Guardar'},true);if($$('Forma').validate()){enviar(datosGuardados,'Guardar');}}
function guardarFinal(){if(modoSubforma){$$('BotonGuardar').hide();ultimosCapturados(datosGuardados);setSubforma();}else{$$('Forma').clear();inicial();ultimosCapturados(datosGuardados);}}
function borrar(){webix.confirm({title:tituloEliminar,ok:si,cancel:no,type:'confirm-error',text:seguroQueDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(datosEliminados,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();enviar(datosEliminados,'Buscar');$$('BotonGuardar').show();$$('BotonModificar').hide();if(modoSubforma){$$('FrameSubforma').hide();}}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(datosModificados,'Modificar');}}
function modificarFinal(){if(modoSubforma){enviar(datosModificados,'Buscar');}else{$$('Forma').clear();enviar(datosModificados,'Buscar');$$('BotonGuardar').show();$$('BotonModificar').hide();}}
function buscar(){if($$('CampoBuscar').getValue()==''){$$('CampoBuscar').setValue('%');}valoresBusqueda={Accion:'Buscar',Campo:$$('CampoBuscar').getValue()};enviar(resultadosEncontrados,'Buscar');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post(servlet,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());}}}});}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	Serie: $$('Tabla').getItem(id).Serie,
	Folio: $$('Tabla').getItem(id).Folio,
	Marca: $$('Tabla').getItem(id).Marca,
	NumeroSerie: $$('Tabla').getItem(id).NumeroSerie,
	SistemaOperativo: $$('Tabla').getItem(id).SistemaOperativo,
	LicenciaSO: $$('Tabla').getItem(id).LicenciaSO,
	Office: $$('Tabla').getItem(id).Office,
	Procesador: $$('Tabla').getItem(id).Procesador,
	Ram: $$('Tabla').getItem(id).Ram,
	DiscoDuro: $$('Tabla').getItem(id).DiscoDuro,
	Lcd: $$('Tabla').getItem(id).Lcd,
	FechaCompra: $$('Tabla').getItem(id).FechaCompra,
	Factura: $$('Tabla').getItem(id).Factura,
	Proveedor: $$('Tabla').getItem(id).Proveedor,
	MacAdressLan: $$('Tabla').getItem(id).MacAdressLan,
	MacAdressWifi: $$('Tabla').getItem(id).MacAdressWifi,
	NombreEquipo: $$('Tabla').getItem(id).NombreEquipo,
	Estatus: $$('Tabla').getItem(id).Estatus,
	MotivoBaja: $$('Tabla').getItem(id).MotivoBaja,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if(modoSubforma){setSubforma();}if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

$$('Marca').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Marca').setValue(nuevo);});
$$('NumeroSerie').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('NumeroSerie').setValue(nuevo);});
$$('SistemaOperativo').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('SistemaOperativo').setValue(nuevo);});
$$('LicenciaSO').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('LicenciaSO').setValue(nuevo);});
$$('Office').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Office').setValue(nuevo);});
$$('Procesador').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Procesador').setValue(nuevo);});
$$('Ram').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Ram').setValue(nuevo);});
$$('DiscoDuro').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('DiscoDuro').setValue(nuevo);});
$$('Lcd').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Lcd').setValue(nuevo);});

$$('Factura').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Factura').setValue(nuevo);});
$$('Proveedor').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Proveedor').setValue(nuevo);});
$$('MacAdressLan').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('MacAdressLan').setValue(nuevo);});
$$('MacAdressWifi').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('MacAdressWifi').setValue(nuevo);});
$$('NombreEquipo').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('NombreEquipo').setValue(nuevo);});
$$('MotivoBaja').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('MotivoBaja').setValue(nuevo);});

function setSubforma(){
	$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);
	$$('FrameSubforma1').show();$$('FrameSubforma1').load(archivo1+'?IdGenerado='+idGenerado);
}

function excel() {
	webix.toExcel($$("Tabla"));
}

inicial();buscar();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//InventarioSistemas.jsp
%>
