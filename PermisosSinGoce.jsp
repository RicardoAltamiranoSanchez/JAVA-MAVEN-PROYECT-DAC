<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%><%@ page import="Utilerias.Fechas"%><%@ page import="Html.Idioma"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "194";
try{session.getAttribute(moduloIdioma).equals("");}catch(NullPointerException e1){Idioma idiomaHtml=new Idioma();session.setAttribute(moduloIdioma,idiomaHtml.getLenguaje(moduloIdioma,session.getAttribute("Idioma").toString()));}
Properties idioma = (Properties)session.getAttribute("IdiomaGeneral");
Properties idiomaModulo = (Properties)session.getAttribute(moduloIdioma);%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>

<script>
var errorComunicacion='<%=idioma.getProperty("errorComunicacion") %>';
var errorEjecutarAccion='<%=idioma.getProperty("errorEjecutarAccion") %>';
var registroGuardado='<%=idioma.getProperty("registroGuardado") %>';
var registroModificado='<%=idioma.getProperty("registroModificado") %>';
var tituloEliminado='VACACIONES AUTORIZADAS';
var registroEliminado='<%=idioma.getProperty("registroEliminado") %>';
var seguroDeseaEliminar='DESEA AUTORIZAR';
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
//variable key
final Fechas fechas;
fechas = new Fechas();
String key = session.getAttribute("IdUsuario") + fechas.getKey();
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
%>
var entroDia = false;
var diasTabla = 0;
var forma={view:'form',id:'Forma',scroll:'y',width:600,height:'100%',elements:[
	{view:'datepicker',readonly:true,value:new Date(),stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),id:'FechaSolicitud',name:'FechaSolicitud',placeholder:'<%=idiomaModulo.getProperty("FechaSolicitud")%>',label: '<%=idiomaModulo.getProperty("FechaSolicitud")%>', labelPosition:'top'},
	{cols:[
	{view:'combo',id:'Gerente',name:'Gerente',value:'',placeholder:'<%=idiomaModulo.getProperty("IdGerente") %>',label:'<%=idiomaModulo.getProperty("IdGerente")%>',labelPosition:'top',yCount:'3',options:[]},
	{view:'label',id:'O',label:'O',align:'center'},
	{view:'combo',id:'Jefe',name:'Jefe',value:'',placeholder:'<%=idiomaModulo.getProperty("Jefe") %>',label:'<%=idiomaModulo.getProperty("Jefe") %>',labelPosition:'top',options:[],yCount:'3'},
	]},
	{rows:[
		{view:"fieldset", label:"DIAS QUE SOLICITARA SIN GOCE DE SUELDO", body:{rows:[
			{view:'form',id:'FormaVacacionesDias',elements:[{cols:[
			    {view:'datepicker',required:true,value:'',stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),id:'Dias',name:'Dias',placeholder:'DIAS',label:'DIAS'},
			    {view:'button',id:'BotonGuardarDiasVacaciones',value:'AGREGAR',width:85,click:'guardarDiasVacaciones'}
			]}]},
			{id:'PanelTablaDiasVacaciones',rows:[{view:'toolbar',height:25,id:'TablaToolsDiasVacaciones',cols:[{},{view:'button',value:etiquetaBorrar,width:85,click:'borrarDiasVacaciones'}]},{view:'datatable',id:'TablaDiasVacaciones',width:'100%',height:140,select:'row',multiselect:true,columns:[
				{id:'Dias',header:'DIAS',fillspace:true,sort:'string'}
			]}]}
		]}}
	]},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{},{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{},{view:'button',value:etiquetaBorrar,width:85,click:'borrar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
		{id:'FechaSolicitud',header:'<%=idiomaModulo.getProperty("FechaSolicitud")%>',width:100,sort:'string'},
		{id:'Llave',header:'DIAS',fillspace:true,sort:'string'},
		{id:'Estatus',header:'<%=idiomaModulo.getProperty("Estatus")%>',width:100,sort:'string'},
	]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'DIAS SIN GOCE DE SUELDO'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}

function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('Confirmacion').clearAll();$$('Tabla').clearAll();$$('Mensaje').setValue(nada);$$('Vacio').show();iniciales();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'GuardarDias',Llave:'<%=key%>'},true); if($$('Forma').validate()) {if(validarDatos()) {enviar(registroGuardado,'GuardarDias'); $$('Confirmacion').show();}}}
function guardarDespues(){$$('Forma').clear();$$('TablaDiasVacaciones').clearAll();inicial();}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function modificarDespues(){}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/PermisosServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='GuardarDias'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='GuardarDias'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechaSolicitud")%>',value: info.FechaSolicitud});
}

//funciones forma dias vacaciones
function nuevoDiasVacaciones(){$$('FormaVacacionesDias').clear();}
function borrarDiasVacacionesDespues(){$$('FormaVacacionesDias').setValues({Accion:'Buscar'},true);enviarDiasVacaciones(registroEliminado,'Buscar');}
function borrarDiasVacaciones(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('TablaDiasVacaciones').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('FormaVacacionesDias').setValues({Accion:'Borrar',Ids:ids},true);enviarDiasVacaciones(registroEliminado,'Borrar');diasTabla = diasTabla - 1;}}else{$$('TablaDiasVacaciones').clearSelection();}}});}
function guardarDiasVacaciones(){$$('Confirmacion').clearAll();$$('FormaVacacionesDias').setValues({Accion:'GuardarSinGoce'},true);$$('FormaVacacionesDias').setValues({Llave:'<%=key %>'},true);if($$('FormaVacacionesDias').validate()){enviarDiasVacaciones(registroGuardado,'GuardarSinGoce');$$('Confirmacion').show();}}
function guardarDiasVacacionesDespues(){$$('FormaVacacionesDias').setValues({Accion:'Buscar'},true);enviarDiasVacaciones(registroGuardado,'Buscar');}
function cancelarDiasVacaciones(){$$('FormaVacacionesDias').clear();}
function buscarDiasVacaciones(){$$('FormaVacacionesDias').setValues({Accion:'Buscar'},true);$$('FormaVacacionesDias').setValues({Llave:'<%=key %>'},true);enviarDiasVacaciones(busquedaFinalizada,'Buscar');}
function enviarDiasVacaciones(mensaje,accion){var valores=$$('FormaVacacionesDias').getValues();webix.ajax().post('servlet/VacacionesDiasServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('FormaVacacionesDias').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='GuardarSinGoce'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacionDiasVacaciones(data.json());if(accion=='GuardarSinGoce'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});cancelarDiasVacaciones();$$('FormaVacacionesDias').setValues({Llave:'<%=key %>'},true);guardarDiasVacacionesDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});cancelarDiasVacaciones();$$('FormaVacacionesDias').setValues({Llave:'<%=key %>'},true);modificarDiasVacacionesDespues();}}else if(accion=='Borrar'){borrarDiasVacacionesDespues();setValoresPiezasPesos(data.json());}else if(accion=='Buscar'){$$('TablaDiasVacaciones').clearAll();$$('TablaDiasVacaciones').parse(data.json());}}}}});}
function setConfirmacionDiasVacaciones(info){
	entroDia = true;
	diasTabla = diasTabla + 1;
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechaVacaciones")%>',value: info.Dias});
}

//funcion validar datos
function validarDatos(){
	var siguiente = true;
	if($$('Gerente').getValue() == '' && $$('Jefe').getValue() == ''){
		webix.message('FAVOR DE INGRESAR UN GERENTE O SUPERVISOR');
		siguiente = false;
	}
	if(!entroDia || diasTabla == 0){
		webix.message('FAVOR DE SELECCIONAR AL MENOS UN DIA');
		siguiente = false;
	}
	return siguiente;
}

var listaIdGerente = $$("Gerente").getPopup().getList();listaIdGerente.clearAll();listaIdGerente.load("servlet/GerentesServlet?Accion=getGerentes&filter[value]=");
var listaJefe = $$("Jefe").getPopup().getList();listaJefe.clearAll();listaJefe.load("servlet/JefesServlet?Accion=getJefes&filter[value]=");
inicial();
</script>
<%=EncabezadoPie.getPie()%>
<% //Vacaciones.jsp %>