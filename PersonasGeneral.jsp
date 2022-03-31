<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "206";
Properties idioma = (Properties)session.getAttribute("IdiomaGeneral");
Properties idiomaModulo = (Properties)session.getAttribute(moduloIdioma);%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<script>
var errorComunicacion='<%=idioma.getProperty("errorComunicacion") %>';
var errorEjecutarAccion='<%=idioma.getProperty("errorEjecutarAccion") %>';
var registroGuardado='<%=idioma.getProperty("registroGuardado") %>';
var registroModificado='<%=idioma.getProperty("registroModificado") %>';
var tituloEliminado='<%=idioma.getProperty("tituloEliminado") %>';
var registroEliminado='<%=idioma.getProperty("registroEliminado") %>';
var seguroDeseaEliminar='<%=idioma.getProperty("seguroDeseaEliminar") %>';
var busquedaFinalizada='<%=idioma.getProperty("busquedaFinalizada") %>';
var unRegistro='<%=idioma.getProperty("unRegistro") %>';
var soloUnRegistro='<%=idioma.getProperty("soloUnRegistro") %>';
var id='';
var si='<%=idioma.getProperty("si") %>';
var no='<%=idioma.getProperty("no") %>';
var nada='';
var guardado='<%=idioma.getProperty("guardado") %>';
var modificado='<%=idioma.getProperty("modificado") %>';
var etiquetaNuevo = '<%=idioma.getProperty("etiquetaNuevo") %>';
var etiquetaGuardar = '<%=idioma.getProperty("etiquetaGuardar") %>';
var etiquetaModificar = '<%=idioma.getProperty("etiquetaModificar") %>';
var etiquetaBuscar = '<%=idioma.getProperty("etiquetaBuscar") %>';
var etiquetaBorrar = '<%=idioma.getProperty("etiquetaBorrar") %>';

// VALIDA NÚMEROS se agregan estas variables para agregar la etiqueta que indica que un campo solo captura números
// se asigna el texto de la etiqueta para que sea obtenido desde su equivalente en idioma
var obligNumeros = '<%=idiomaModulo.getProperty("soloNumeros") %>';
var alertaNumeros='<font color="red"><strong>'+obligNumeros+'</strong></font>';
<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
%>

// SCROLL agregamos la propiedad scroll:'y' a la forma para que permita ver los botones y contenidos de la misma
var forma={view:'form',id:'Forma',width:400,height:'100%',scroll:'y',elements:[
	//RADIO aplicamos un radio con opciones predefinidas, será condicionado para cambiar el valor hidden del resto de los campos
	{view:'radio',id:'Empleado',name:'Empleado',label:'<%=idiomaModulo.getProperty("Empleado")%>',value:'',options:["SI","NO"],labelPosition:'top',required:true},
	{view:'text',id:'NumEmpleado',name:'NumEmpleado',value:'',placeholder:'<%=idiomaModulo.getProperty("NumEmpleado")%>',label:'<%=idiomaModulo.getProperty("NumEmpleado")%>'+alertaNumeros,hidden:true,labelPosition:'top',attributes:{maxlength:9},validate:"isNumber",required:true},
	{view:'text',id:'NombreCompleto',name:'NombreCompleto',value:'',placeholder:'<%=idiomaModulo.getProperty("NombreCompleto")%>',label:'<%=idiomaModulo.getProperty("NombreCompleto")%>',hidden:true,labelPosition:'top',attributes:{maxlength:255},required:true},
	{cols:[
		{view:'text',id:'NSS',name:'NSS',value:'',placeholder:'<%=idiomaModulo.getProperty("NSS")%>',label:'<%=idiomaModulo.getProperty("NSS")%>'+alertaNumeros,hidden:true,labelPosition:'top',attributes:{maxlength:11},validate:"isNumber",required:true},
		{view:'text',id:'RFC',name:'RFC',value:'',placeholder:'<%=idiomaModulo.getProperty("RFC")%>',label:'<%=idiomaModulo.getProperty("RFC")%>',hidden:true,labelPosition:'top',attributes:{maxlength:13},required:true},
	]},
	{cols:[
		{view:'text',id:'CURP',name:'CURP',value:'',placeholder:'<%=idiomaModulo.getProperty("CURP")%>',label:'<%=idiomaModulo.getProperty("CURP")%>',hidden:true,labelPosition:'top',attributes:{maxlength:18},required:true},
		// COMBO en lugar de text se cambia a combo para mostrar una lista de otra tabla
		{view:'combo',id:'IdUbicacionesGrupo',name:'IdUbicacionesGrupo',value:'',placeholder:'<%=idiomaModulo.getProperty("IdUbicacionesGrupo") %>',label:'<%=idiomaModulo.getProperty("IdUbicacionesGrupo") %>',hidden:true,labelPosition:'top',required:true,options:[],yCount:'5'},
	]},
	// COMBO en lugar de text se cambia a combo para mostrar una lista de otra tabla
	{view:'combo',id:'IdAreasGrupo',name:'IdAreasGrupo',value:'',placeholder:'<%=idiomaModulo.getProperty("IdAreasGrupo") %>',label:'<%=idiomaModulo.getProperty("IdAreasGrupo") %>',hidden:true,labelPosition:'top',required:true,options:[],yCount:'5'},
	// COMBO en lugar de text se cambia a combo para mostrar una lista de otra tabla
	{view:'combo',id:'IdPuestosGrupo',name:'IdPuestosGrupo',value:'',placeholder:'<%=idiomaModulo.getProperty("IdPuestosGrupo") %>',label:'<%=idiomaModulo.getProperty("IdPuestosGrupo") %>',hidden:true,labelPosition:'top',required:true,options:[],yCount:'5'},
	{cols:[
		// COMBO en lugar de text se cambia a combo para mostrar una lista de otra tabla
		{view:'combo',id:'IdEmpleadosGrupo',name:'IdEmpleadosGrupo',value:'',placeholder:'<%=idiomaModulo.getProperty("IdEmpleadosGrupo") %>',label:'<%=idiomaModulo.getProperty("IdEmpleadosGrupo") %>',hidden:true,labelPosition:'top',required:true,options:[],yCount:'5'},
		// COMBO en lugar de text se cambia a combo para mostrar una lista de otra tabla
		{view:'combo',id:'IdEmpresasGrupo',name:'IdEmpresasGrupo',value:'',placeholder:'<%=idiomaModulo.getProperty("IdEmpresasGrupo") %>',label:'<%=idiomaModulo.getProperty("IdEmpresasGrupo") %>',hidden:true,labelPosition:'top',required:true,options:[],yCount:'5'},
	]},
	{view:'text',id:'SueldoBruto',name:'SueldoBruto',value:'',placeholder:'<%=idiomaModulo.getProperty("SueldoBruto")%>',label:'<%=idiomaModulo.getProperty("SueldoBruto")%>'+alertaNumeros,hidden:true,labelPosition:'top',attributes:{maxlength:15},validate:"isNumber",required:true},
	// FECHA en lugar de text se cambia a datepicker para capturar fechas
	{view:'datepicker',date: new Date(),stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),id:'FechIngreso',name: 'FechIngreso',label: '<%=idiomaModulo.getProperty("FechIngreso")%>',timepicker:true,hidden:true,labelPosition:'top',required:true},
	{cols:[
		{rows:[
			{},
			// CAMPO COMPUESTO POR COMBOS se agrega un campo label, que estará mostrándose y se le desactiva el que sea obligatorio, el text siempre se queda oculto
			{view:'label',id:'FechaCumpLab',name:'FechaCumpLab',value:'',placeholder:'<%=idiomaModulo.getProperty("FechaCumpLab")%>',label:'<%=idiomaModulo.getProperty("FechaCumpLab")%>',hidden:true,labelPosition:'top'},
			{view:'text',id:'FechaCump',name:'FechaCump',value:'',placeholder:'<%=idiomaModulo.getProperty("FechaCump")%>',label:'<%=idiomaModulo.getProperty("FechaCump")%>',hidden:true,labelPosition:'top',required:true},
			// CAMPO COMPUESTO POR COMBOS obtendremos un valor unificando dos selecciones independientes
			{view:'combo',id:'MesCumple',name:'MesCumple',value:'',placeholder:'<%=idiomaModulo.getProperty("MesCumple") %>',label:'<%=idiomaModulo.getProperty("MesCumple") %>',hidden:true,labelPosition:'top',required:true,options:["ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"],yCount:'5'},
			{view:'combo',id:'DiaCumple',name:'DiaCumple',value:'',placeholder:'<%=idiomaModulo.getProperty("DiaCumple") %>',label:'<%=idiomaModulo.getProperty("DiaCumple") %>',hidden:true,labelPosition:'top',required:true,options:[],yCount:'5'},
		]},
		{rows:[
			{},
			{},{},
			// COMBO en lugar de text se cambia a combo para mostrar una lista de opciones fijas
			{view:'combo',id:'EstatusEmpGpo',name:'EstatusEmpGpo',value:'',placeholder:'<%=idiomaModulo.getProperty("EstatusEmpGpo") %>',label:'<%=idiomaModulo.getProperty("EstatusEmpGpo") %>',hidden:true,labelPosition:'top',required:true,options:["ACTIVO","INACTIVO"],yCount:'5'},
		]},
	]},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'Empleado',header:'<%=idiomaModulo.getProperty("Empleado")%>',fillspace:true,sort:'string'},
	{id:'NumEmpleado',header:'<%=idiomaModulo.getProperty("NumEmpleado")%>',sort:'string'},
	{id:'NombreCompleto',header:'<%=idiomaModulo.getProperty("NombreCompleto")%>',sort:'string'},
	{id:'NSS',header:'<%=idiomaModulo.getProperty("NSS")%>',sort:'string'},
	{id:'RFC',header:'<%=idiomaModulo.getProperty("RFC")%>',sort:'string'},
	{id:'CURP',header:'<%=idiomaModulo.getProperty("CURP")%>',sort:'string'},
	{id:'IdUbicacionesGrupo',header:'<%=idiomaModulo.getProperty("IdUbicacionesGrupo")%>',sort:'string'},
	{id:'IdAreasGrupo',header:'<%=idiomaModulo.getProperty("IdAreasGrupo")%>',sort:'string'},
	{id:'IdPuestosGrupo',header:'<%=idiomaModulo.getProperty("IdPuestosGrupo")%>',sort:'string'},
	{id:'IdEmpleadosGrupo',header:'<%=idiomaModulo.getProperty("IdEmpleadosGrupo")%>',sort:'string'},
	{id:'IdEmpresasGrupo',header:'<%=idiomaModulo.getProperty("IdEmpresasGrupo")%>',sort:'string'},
	{id:'SueldoBruto',header:'<%=idiomaModulo.getProperty("SueldoBruto")%>',sort:'string'},
	{id:'FechIngreso',header:'<%=idiomaModulo.getProperty("FechIngreso")%>',sort:'string'},
	{id:'FechaCump',header:'<%=idiomaModulo.getProperty("FechaCumpLab")%>',sort:'string'},
	{id:'EstatusEmpGpo',header:'<%=idiomaModulo.getProperty("EstatusEmpGpo")%>',sort:'string'}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'REGISTRO DE PERSONAS'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('Confirmacion').clearAll();$$('Tabla').clearAll();$$('Mensaje').setValue(nada);$$('Vacio').show();iniciales();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
function guardarDespues(){$$('Forma').clear();/* CAMPO COMPUESTO POR DOS COMBOS se reinicia el valor que estaba concatenado */$$('FechaCump').setValue("");inicial();}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function modificarDespues(){}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().get('servlet/PersonasGeneralServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Empleado")%>',value: info.Empleado});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NumEmpleado")%>',value: info.NumEmpleado});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NombreCompleto")%>',value: info.NombreCompleto});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NSS")%>',value: info.NSS});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("RFC")%>',value: info.RFC});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("CURP")%>',value: info.CURP});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdUbicacionesGrupo")%>',value: info.IdUbicacionesGrupo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdAreasGrupo")%>',value: info.IdAreasGrupo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdPuestosGrupo")%>',value: info.IdPuestosGrupo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdEmpleadosGrupo")%>',value: info.IdEmpleadosGrupo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdEmpresasGrupo")%>',value: info.IdEmpresasGrupo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("SueldoBruto")%>',value: info.SueldoBruto});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechIngreso")%>',value: info.FechIngreso});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechaCump")%>',value: info.FechaCump});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("EstatusEmpGpo")%>',value: info.EstatusEmpGpo});
}
$$('Empleado').attachEvent('onChange',function(visualiza){
 	if (visualiza == "SI"){
		//se muestran los campos de empleados y se reinicia su valor de los ocultos por NO
		$$('NumEmpleado').show();
		$$('NumEmpleado').setValue("");
		$$('NombreCompleto').show();
		$$('NSS').show();
		$$('RFC').show();
		$$('CURP').show();
		$$('IdUbicacionesGrupo').show();
		$$('IdUbicacionesGrupo').setValue("");
		$$('IdAreasGrupo').show();
		$$('IdAreasGrupo').setValue("");
		$$('IdPuestosGrupo').show();
		$$('IdPuestosGrupo').setValue("");
		$$('IdEmpleadosGrupo').show();
		$$('IdEmpleadosGrupo').setValue("");
		$$('IdEmpresasGrupo').show();
		$$('IdEmpresasGrupo').setValue("");
		$$('SueldoBruto').show();
		$$('SueldoBruto').setValue("");
		$$('FechIngreso').show();
		$$('FechIngreso').setValue("");
		$$('FechaCumpLab').show();
		$$('MesCumple').show();
		$$('DiaCumple').show();
		$$('EstatusEmpGpo').show();
	} else if (visualiza == "NO"){
		//se muestran los campos de no empleados y a los ocultos se les da un valor fijo
		$$('NumEmpleado').hide();
		$$('NumEmpleado').setValue("0");
		$$('NombreCompleto').show();
		$$('NSS').show();
		$$('RFC').show();
		$$('CURP').show();
		$$('IdUbicacionesGrupo').hide();
		$$('IdUbicacionesGrupo').setValue("0");
		$$('IdAreasGrupo').hide();
		$$('IdAreasGrupo').setValue("0");
		$$('IdPuestosGrupo').hide();
		$$('IdPuestosGrupo').setValue("0");
		$$('IdEmpleadosGrupo').hide();
		$$('IdEmpleadosGrupo').setValue("0");
		$$('IdEmpresasGrupo').hide();
		$$('IdEmpresasGrupo').setValue("0");
		$$('SueldoBruto').hide();
		$$('SueldoBruto').setValue("0");
		$$('FechIngreso').hide();
		$$('FechIngreso').setValue("1951-01-01");
		$$('FechaCumpLab').show();
		$$('MesCumple').show();
		$$('DiaCumple').show();
		$$('EstatusEmpGpo').show(); 
	}
	//alert (visualiza);
	// se le da el valor a Empleado para ser enviado a la base de datos
	$$('Empleado').setValue(visualiza); });
	
$$('NumEmpleado').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NumEmpleado').setValue(nuevo); });
$$('NombreCompleto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NombreCompleto').setValue(nuevo); });
$$('NSS').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NSS').setValue(nuevo); });
$$('RFC').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('RFC').setValue(nuevo); });
$$('CURP').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('CURP').setValue(nuevo); });
//COMBO se bloquea el onChange de sucursal pues no existe funcion validada
//$$('IdUbicacionesGrupo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdUbicacionesGrupo').setValue(nuevo); });
//COMBO CONDICIONADO modifico el onChange para que ejecute la función que limpia el campo puestos y carga su lista
$$('IdAreasGrupo').attachEvent('onChange',function(nuevo, anterior){
	cargaListaPuestos(nuevo);
 });
//COMBO se bloquea el onChange del puesto pues no existe funcion validada
//$$('IdPuestosGrupo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdPuestosGrupo').setValue(nuevo); });
//COMBO SELECTIVO se bloquea el onChange de jefe inmediato pues no existe funcion validada
//$$('IdEmpleadosGrupo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdEmpleadosGrupo').setValue(nuevo); });
//COMBO se bloquea el onChange de empresa pues no existe funcion validada
//$$('IdEmpresasGrupo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdEmpresasGrupo').setValue(nuevo); });
$$('SueldoBruto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('SueldoBruto').setValue(nuevo); });
//COMBO se bloquea el onChange de fecha de ingreso pues no existe funcion validada
//$$('FechIngreso').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('FechIngreso').setValue(nuevo); });
//CAMPO COMPUESTO POR DOS COMBOS dependiendo del mes, llenaremos la cantidad de días disponibles
$$('MesCumple').attachEvent('onChange',function(nuevo, anterior){
	cargaDiasMes(nuevo);
 });
 //CAMPO COMPUESTO POR DOS COMBOS depues de seleccionar el día se concatena en el formato que lo recibirá la base de datos, la función le asigna el valor al campo que se enviará
$$('DiaCumple').attachEvent('onChange',function(nuevo, anterior){
	nuevo=($$('DiaCumple').getValue()+"/"+$$('MesCumple').getValue());
	valorFechaCump(nuevo);
 });
//COMBO FIJO se bloquea el onChange de estatus pues no existe funcion validada
//$$('EstatusEmpGpo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('EstatusEmpGpo').setValue(nuevo); });

		// COMBO llenar lista de estaciones
		var listaIdUbicacionesGrupo = $$("IdUbicacionesGrupo").getPopup().getList();listaIdUbicacionesGrupo.clearAll();listaIdUbicacionesGrupo.load("servlet/UbicacionesGrupoServlet?Accion=getUbicacionesGrupo&filter[value]=");
		// COMBO llenar lista de areas
		var listaIdAreasGrupo = $$("IdAreasGrupo").getPopup().getList();listaIdAreasGrupo.clearAll();listaIdAreasGrupo.load("servlet/AreasGrupoServlet?Accion=getAreasGrupo&filter[value]=");

// COMBO CONDICIONADO se crea una función que será mandada a llamar en el onChange del área
function cargaListaPuestos(area) {
	// COMBO CONDICIONADO llenar lista de puestos equivalentes al área seleccionada
	var listaIdPuestosGrupo = $$("IdPuestosGrupo").getPopup().getList();listaIdPuestosGrupo.clearAll();listaIdPuestosGrupo.load("servlet/PuestosGrupoServlet?Accion=getPuestosGrupoDeArea&filter[value]=" + area);
	// COMBO CONDICIONADO limpia la selección de puestos para que el usuario asigne uno nuevo exclusivo de la nueva lista
	$$('IdPuestosGrupo').setValue("");
}

		// COMBO SELECTIVO llenar lista de jefes inmediatos entre las personas que son empleados y están activos
		var listaIdEmpleadosGrupo = $$("IdEmpleadosGrupo").getPopup().getList();listaIdEmpleadosGrupo.clearAll();listaIdEmpleadosGrupo.load("servlet/PersonasGeneralServlet?Accion=getEmpleadosGrupo&filter[value]=");
		// COMBO llenar lista de empresas
		var listaIdEmpresasGrupo = $$("IdEmpresasGrupo").getPopup().getList();listaIdEmpresasGrupo.clearAll();listaIdEmpresasGrupo.load("servlet/EmpresasGrupoServlet?Accion=getEmpresasGrupo&filter[value]=");

// COMBO CONDICIONADO se crea una función que será mandada a llamar en el onChange del mes
function cargaDiasMes(mes) {
	var combo = $$("DiaCumple");
	if (mes == "ENERO"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"},{id:29, value:"29"},{id:30, value:"30"},
			{id:31, value:"31"}
			]);
	} else if (mes == "FEBRERO"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"}
			]);
	} else if (mes == "MARZO"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"},{id:29, value:"29"},{id:30, value:"30"},
			{id:31, value:"31"}
			]);
	} else if (mes == "ABRIL"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"},{id:29, value:"29"},{id:30, value:"30"}
			]);
	} else if (mes == "MAYO"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"},{id:29, value:"29"},{id:30, value:"30"},
			{id:31, value:"31"}
			]);
	} else if (mes == "JUNIO"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"},{id:29, value:"29"},{id:30, value:"30"}
			]);
	} else if (mes == "JULIO"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"},{id:29, value:"29"},{id:30, value:"30"},
			{id:31, value:"31"}
			]);
	} else if (mes == "AGOSTO"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"},{id:29, value:"29"},{id:30, value:"30"},
			{id:31, value:"31"}
			]);
	} else if (mes == "SEPTIEMBRE"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"},{id:29, value:"29"},{id:30, value:"30"}
			]);
	} else if (mes == "OCTUBRE"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"},{id:29, value:"29"},{id:30, value:"30"},
			{id:31, value:"31"}
			]);
	} else if (mes == "NOVIEMBRE"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"},{id:29, value:"29"},{id:30, value:"30"}
			]);
	} else if (mes == "DICIEMBRE"){
		combo.define("options", [ 
			{id:1, value:"1"},{id:2, value:"2"},{id:3, value:"3"},{id:4, value:"4"},{id:5, value:"5"},{id:6, value:"6"},{id:7, value:"7"},{id:8, value:"8"},{id:9, value:"9"},{id:10, value:"10"},
			{id:11, value:"11"},{id:12, value:"12"},{id:13, value:"13"},{id:14, value:"14"},{id:15, value:"15"},{id:16, value:"16"},{id:17, value:"17"},{id:18, value:"18"},{id:19, value:"19"},{id:20, value:"20"},
			{id:21, value:"21"},{id:22, value:"22"},{id:23, value:"23"},{id:24, value:"24"},{id:25, value:"25"},{id:26, value:"26"},{id:27, value:"27"},{id:28, value:"28"},{id:29, value:"29"},{id:30, value:"30"},
			{id:31, value:"31"}
			]);
	}
	// COMBO CONDICIONADO limpia la selección de dias para que el usuario asigne uno nuevo exclusivo de la nueva lista
	$$('DiaCumple').setValue("");
}

// COMBO CONDICIONADO se crea una función que será mandada a llamar en el onChange del dia
function valorFechaCump(fecha) {
	//alert(fecha);
	// COMBO CONDICIONADO el valor concatenado es asignado al campo que recibirá el servlet
	$$('FechaCump').setValue(fecha);
}

// COMBO CONDICIONADO se ejecuta la función que llena los puestos dependiendo el área seleccionada
cargaListaPuestos('');

// CAMPO COMPUESTO POR DOS COMBOS se ejecuta la función que llena los dias dependiendo el mes seleccionado
cargaDiasMes('');
//valorFechaCump('');
inicial();
</script>
<%=EncabezadoPie.getPie()%>
<% //PersonasGeneral.jsp %>