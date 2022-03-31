<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%><%@ page import="Html.Idioma"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "328";
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
var tituloAutorizado='<%=idiomaModulo.getProperty("tituloAutorizado") %>';
var seguroDeseaAutorizar='<%=idiomaModulo.getProperty("seguroDeseaAutorizar") %>';
var tituloRechazado='<%=idiomaModulo.getProperty("tituloRechazado") %>';
var seguroDeseaRechazar='<%=idiomaModulo.getProperty("seguroDeseaRechazar") %>';
<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
%>
var forma={view:'form',id:'Forma',width:250,height:'100%',elements:[
	
	{view:'datepicker',id:'Fecha',name:'Fecha',value:'',placeholder:'Fecha Inicio',label:'Fecha Inicio',stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:false},
	{view:'datepicker',id:'FechaA',name:'FechaA',value:'',placeholder:'Fecha Fin',label:'Fecha Fin',stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),required:false},
	{view:'combo',id:'IdUsuario',name:'IdUsuario',value:'',placeholder:'<%=idiomaModulo.getProperty("IdUsuario")%>',label:'<%=idiomaModulo.getProperty("IdUsuario")%>',labelPosition:'top',options:[],yCount:'3',required:true},
	{view:'text',id:'Llave',name:'Llave',value:'',placeholder:'',label:'',labelWidth:80,labelPosition:'left',required:false,hidden:true},

{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{},{view:'button',id:'NuevoBoton',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonAnular',value:'ANULAR',width:85,click:'anular'},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',height:15,cols:[
	{view:'button',id:'Autorizado',name:'Autorizado',value:'AUTORIZAR',width:85,click:'Autorizado'},
	{view:'button',id:'Rechazado',name:'Rechazado',value:'RECHAZAR',width:85,click:'Rechazado'},
	/* {view:'button',id:'BotonAnular',value:'ANULAR',width:85,click:'anular'}, */
	{view:'button',id:'Nada',name:'Rechazado',value:' ',width:85,click:'Nada'}]},
	{view:'datatable',id:'Tabla',width:'100%',resizeColumn:true,select:'row',multiselect:false,columns:[
		//{id:'IdUsuario',header:'NOMBRE DEL SOLICITANTE',width:200,sort:'string'},
		{id:'NombreSolicitante',header:'Nombre Solicitante',width:200,sort:'string'},
		{id:'VacacionesFechaSolicitud',header:'<%=idiomaModulo.getProperty("VacacionesFechaSolicitud")%>',sort:'string'},
		<%-- {id:'Solicito1',header:'<%=idiomaModulo.getProperty("Solicito1")%>',width:100,sort:'string'},
		{id:'UsuarioAutorizador1',header:'<%=idiomaModulo.getProperty("UsuarioAutorizador1")%>',sort:'string'},
		{id:'Solicito2',header:'<%=idiomaModulo.getProperty("Solicito2")%>',width:100,sort:'string'},
		{id:'UsuarioAutorizador2',header:'<%=idiomaModulo.getProperty("UsuarioAutorizador2")%>',sort:'string'}, --%>
		{id:'Tipo',header:'<%=idiomaModulo.getProperty("Tipo")%>',width:100,sort:'string'},
		{id:'Estatus',header:'<%=idiomaModulo.getProperty("Estatus")%>',sort:'string'},
		{id:'VacacionesDias',header:'<%=idiomaModulo.getProperty("VacacionesDias")%>',width:2000,sort:'string'},
		{id:'Llave',header:'Llave',width:200,sort:'string'},
	]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'AUTORIZAR VACACIONES / DIAS SIN GOCE'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('Confirmacion').clearAll();$$('Tabla').clearAll();$$('Mensaje').setValue(nada);$$('Vacio').show();iniciales();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'ConsultarVacacionesAutorizadasEmpleados'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
function guardarDespues(){$$('Forma').clear();inicial();}
//function Autorizado(){webix.confirm({title:tituloAutorizado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaAutorizar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids,Tipo:'AutorizadoGerente'},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function Autorizado(){webix.confirm({title:tituloAutorizado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaAutorizar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids,Tipo:'Autorizado'},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function Rechazado(){webix.confirm({title:tituloRechazado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaRechazar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids,Tipo:'Rechazado'},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function anular(){webix.confirm({title:'CONFIRMA ANULAR',ok:si,cancel:no,type:'confirm-error',text:'¿CONFIRMA LA ANULACIÓN DE LAS VACACIONES?',callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Anular',Ids:ids},true);enviar($$('Forma').getValues(),'Anular');}$$('BotonAnular').hide();}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroModificado,'Buscar');}
function buscar(){if($$('Forma').validate()) {
		$$('BotonAnular').hide();
		$$('Llave').setValue('');
		$$('Forma').setValues({Accion:'ConsultarVacacionesAutorizadasEmpleados'},true);enviar(busquedaFinalizada,'Buscar');
	}}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function modificarDespues(){}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/VacacionesServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Anular'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdEmpleadosGrupo")%>',value: info.IdEmpleadosGrupo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechaSolicitud")%>',value: info.FechaSolicitud});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Estatus")%>',value: info.Estatus});
}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	Llave: $$('Tabla').getItem(id).Llave,
	id: $$('Tabla').getItem(id).id,
	Accion:'Anular'
});/* idGenerado=id;if(modoSubforma){setSubforma();}if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();} */
idGenerado=id;if($$('Tabla').getItem(id).bloquear){$$('BotonAnular').show();}else{$$('BotonAnular').show();}
});

$$('IdUsuario').attachEvent('onChange',function(nuevo, anterior){ $$('Confirmacion').clearAll(); });

var IdUsuario = $$("IdUsuario").getPopup().getList();IdUsuario.clearAll();IdUsuario.load("servlet/EmpleadosServlet?Accion=getEmpleados&filter[value]=");

inicial();

$$('Autorizado').hide();
$$('NuevoBoton').hide();
$$('Nada').hide();
$$('Rechazado').hide();

$$('BotonAnular').hide();

</script>
<%=EncabezadoPie.getPie()%>
<% //Vacaciones.jsp %>