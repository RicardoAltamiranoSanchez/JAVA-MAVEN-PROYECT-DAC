<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%><%@ page import="Html.Idioma"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "248";
try{session.getAttribute(moduloIdioma).equals("");}catch(NullPointerException e1){Idioma idiomaHtml=new Idioma();session.setAttribute(moduloIdioma,idiomaHtml.getLenguaje(moduloIdioma,session.getAttribute("Idioma").toString()));}
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
<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
%>

var forma={view:'form',id:'Forma',width:500,scroll:'y',height:'100%',elements:[
	{view:'combo',id:'IdUsuario',name:'IdUsuario',value:'',placeholder:'<%=idiomaModulo.getProperty("IdUsuario") %>',label:'<%=idiomaModulo.getProperty("IdUsuario") %>',labelPosition:'top',required:true,options:[],yCount:'3'},
	{cols:[
		{view:'text',id:'NumeroEmpleado',name:'NumeroEmpleado',value:'',placeholder:'<%=idiomaModulo.getProperty("NumeroEmpleado")%>',label:'<%=idiomaModulo.getProperty("NumeroEmpleado")%>',labelPosition:'top'},
		{view:'combo',id:'IdJefeDirecto',name:'IdJefeDirecto',value:'',placeholder:'<%=idiomaModulo.getProperty("IdJefeDirecto") %>',label:'<%=idiomaModulo.getProperty("IdJefeDirecto") %>',labelPosition:'top',required:true,options:[],yCount:'3'},
	]},
	{view:'text',id:'NombreCompleto',name:'NombreCompleto',value:'',placeholder:'<%=idiomaModulo.getProperty("NombreCompleto")%>',label:'<%=idiomaModulo.getProperty("NombreCompleto")%>',labelPosition:'top',required:true},
	{view:'combo',id:'IdAreasLaborales',name:'IdAreasLaborales',value:'',placeholder:'?REA LABORAL',label:'?REA LABORAL',required:false,options:[],yCount:'3'},
	{view:'text',id:'Puesto',name:'Puesto',value:'',placeholder:'<%=idiomaModulo.getProperty("Puesto")%>',label:'<%=idiomaModulo.getProperty("Puesto")%>',required:true},
	{view:'combo',id:'Division',name:'Division',value:'',placeholder:'<%=idiomaModulo.getProperty("Division") %>',label:'<%=idiomaModulo.getProperty("Division") %>',required:true,options:[],yCount:'3'},
	{view:'text',id:'Estacion',name:'Estacion',value:'',placeholder:'<%=idiomaModulo.getProperty("Estacion")%>',label:'<%=idiomaModulo.getProperty("Estacion")%>',required:true},
	{cols:[
		{view:'text',id:'NSS',name:'NSS',value:'',placeholder:'<%=idiomaModulo.getProperty("NSS")%>',label:'<%=idiomaModulo.getProperty("NSS")%>',labelPosition:'top'},
		{view:'text',id:'CURP',name:'CURP',value:'',placeholder:'<%=idiomaModulo.getProperty("CURP")%>',label:'<%=idiomaModulo.getProperty("CURP")%>',labelPosition:'top'}
	]},
	{cols:[
		{view:'datepicker',id:'FechaIngreso',name:'FechaIngreso',value: '',placeholder:'<%=idiomaModulo.getProperty("FechaIngreso")%>',label:'<%=idiomaModulo.getProperty("FechaIngreso")%>',stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),labelPosition:'top',required:true},
		{view:'combo',id:'Estatus',name:'Estatus',value:'ACTIVO',placeholder:'<%=idiomaModulo.getProperty("Estatus") %>',label:'<%=idiomaModulo.getProperty("Estatus")%>',labelPosition:'top',required:true,yCount:'5',options:[{id:'ACTIVO',value:'<%=idiomaModulo.getProperty("ACTIVO")%>'},{id:'INACTIVO',value:'<%=idiomaModulo.getProperty("INACTIVO")%>'}]},
	]},
	{view:'textarea',id:'Observaciones',name:'Observaciones',value:'',placeholder:'OBSERVACIONES',label:'OBSERVACIONES',labelWidth:80,labelPosition:'top',height:100},
	{view:'text',id:'Vacaciones',name:'Vacaciones',value:'0',placeholder:'<%=idiomaModulo.getProperty("Vacaciones")%>',label:'<%=idiomaModulo.getProperty("Vacaciones")%>',hidden:true},
	
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'IdUsuario',header:'<%=idiomaModulo.getProperty("IdUsuario")%>',width:250,sort:'string'},
	{id:'NumeroEmpleado',header:'<%=idiomaModulo.getProperty("NumeroEmpleado")%>',width:50,sort:'string'},
	{id:'NombreCompleto',header:'<%=idiomaModulo.getProperty("NombreCompleto")%>',width:250,sort:'string'},
	{id:'IdAreasLaborales',header:'?rea Laboral',width:250,hidden:true,sort:'string'},//
	{id:'Division',header:'<%=idiomaModulo.getProperty("Division")%>',width:250,sort:'string'},
	{id:'FechaIngreso',header:'<%=idiomaModulo.getProperty("FechaIngreso")%>',sort:'string'},
	{id:'Estatus',header:'<%=idiomaModulo.getProperty("Estatus")%>',sort:'string',width:50},
	{id:'IdJefeDirecto',header:'<%=idiomaModulo.getProperty("IdJefeDirecto")%>',width:250,sort:'string'},
	{id:'Observaciones',header:'OBSERVACIONES',width:105,hidden:true,sort:'string'}
]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
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
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/EmpleadosServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdUsuario")%>',value: info.IdUsuario});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NumeroEmpleado")%>',value: info.NumeroEmpleado});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NombreCompleto")%>',value: info.NombreCompleto});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Puesto")%>',value: info.Puesto});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Division")%>',value: info.Division});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Estacion")%>',value: info.Estacion});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NSS")%>',value: info.NSS});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("CURP")%>',value: info.CURP});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechaIngreso")%>',value: info.FechaIngreso});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Estatus")%>',value: info.Estatus});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Vacaciones")%>',value: info.Vacaciones});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdJefeDirecto")%>',value: info.IdJefeDirecto});
}
$$('NombreCompleto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NombreCompleto').setValue(nuevo); });
$$('Puesto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Puesto').setValue(nuevo); });
$$('Estacion').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Estacion').setValue(nuevo); });
$$('NSS').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NSS').setValue(nuevo); });
$$('CURP').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('CURP').setValue(nuevo); });

var listaIdAreasLaborales = $$("IdAreasLaborales").getPopup().getList();listaIdAreasLaborales.clearAll();listaIdAreasLaborales.load("AreasLaboralesServlet.jsp?Accion=getAreasLaborales&filter[value]=");
var listaDivision = $$("Division").getPopup().getList();listaDivision.clearAll();listaDivision.load("servlet/EmpresasGrupoServlet?Accion=getEmpresasGrupo&filter[value]=");
var listaIdUsuario = $$("IdUsuario").getPopup().getList();listaIdUsuario.clearAll();listaIdUsuario.load("servlet/EmpleadosServlet?Accion=getUsuarios&filter[value]=");
var IdJefeDirecto = $$("IdJefeDirecto").getPopup().getList();IdJefeDirecto.clearAll();IdJefeDirecto.load("servlet/GerentesServlet?Accion=getGerentes&filter[value]=");

</script>
<%=EncabezadoPie.getPie()%>
<% //Empleados.jsp %>