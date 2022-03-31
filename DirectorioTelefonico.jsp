<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "240";
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

var forma={view:'form',id:'Forma',width:400,height:'100%',elements:[
	{view:'combo',id:'IdCredenciales',name:'IdCredenciales',value:'',placeholder:'<%=idiomaModulo.getProperty("IdCredenciales") %>',label:'<%=idiomaModulo.getProperty("IdCredenciales") %>',required:true,options:[],yCount:'3'},
	//{view:'text',id:'IdCredenciales',name:'IdCredenciales',value:'',placeholder:'<%=idiomaModulo.getProperty("IdCredenciales")%>',label:'<%=idiomaModulo.getProperty("IdCredenciales")%>',required:true},
	//{view:'text',id:'FechaNacimiento',name:'FechaNacimiento',value:'',placeholder:'<%=idiomaModulo.getProperty("FechaNacimiento")%>',label:'<%=idiomaModulo.getProperty("FechaNacimiento")%>',required:true},
	//{view:'text',id:'NombreCompleto',name:'NombreCompleto',value:'',placeholder:'<%=idiomaModulo.getProperty("NombreCompleto")%>',label:'<%=idiomaModulo.getProperty("NombreCompleto")%>',required:true},
	{view:'text',id:'NextelId',name:'NextelId',value:'',placeholder:'<%=idiomaModulo.getProperty("NextelId")%>',label:'<%=idiomaModulo.getProperty("NextelId")%>',required:true},
	{view:'text',id:'NextelTel',name:'NextelTel',value:'',placeholder:'<%=idiomaModulo.getProperty("NextelTel")%>',label:'<%=idiomaModulo.getProperty("NextelTel")%>',required:true},
	{view:'text',id:'Celular',name:'Celular',value:'',placeholder:'<%=idiomaModulo.getProperty("Celular")%>',label:'<%=idiomaModulo.getProperty("Celular")%>',required:true},
	{view:'text',id:'Email',name:'Email',value:'',placeholder:'<%=idiomaModulo.getProperty("Email")%>',label:'<%=idiomaModulo.getProperty("Email")%>',required:true},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'IdCredenciales',header:'<%=idiomaModulo.getProperty("IdCredenciales")%>',fillspace:true,sort:'string'},
	//{id:'FechaNacimiento',header:'<%=idiomaModulo.getProperty("FechaNacimiento")%>',sort:'string'},
	//{id:'NombreCompleto',header:'<%=idiomaModulo.getProperty("NombreCompleto")%>',sort:'string'},
	{id:'NextelId',header:'<%=idiomaModulo.getProperty("NextelId")%>',sort:'string'},
	{id:'NextelTel',header:'<%=idiomaModulo.getProperty("NextelTel")%>',sort:'string'},
	{id:'Celular',header:'<%=idiomaModulo.getProperty("Celular")%>',sort:'string'},
	{id:'Email',header:'<%=idiomaModulo.getProperty("Email")%>',sort:'string'}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'DIRECTORIOTELEFONICO'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
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
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/DirectorioTelefonicoServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdCredenciales")%>',value: info.IdCredenciales});
	//$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechaNacimiento")%>',value: info.FechaNacimiento});
	//$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NombreCompleto")%>',value: info.NombreCompleto});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NextelId")%>',value: info.NextelId});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NextelTel")%>',value: info.NextelTel});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Celular")%>',value: info.Celular});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Email")%>',value: info.Email});
}
//$$('IdCredenciales').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdCredenciales').setValue(nuevo); });
//$$('FechaNacimiento').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('FechaNacimiento').setValue(nuevo); });
//$$('NombreCompleto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NombreCompleto').setValue(nuevo); });
$$('NextelId').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NextelId').setValue(nuevo); });
$$('NextelTel').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NextelTel').setValue(nuevo); });
$$('Celular').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Celular').setValue(nuevo); });
$$('Email').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Email').setValue(nuevo); });
var listaIdCredenciales = $$("IdCredenciales").getPopup().getList();listaIdCredenciales.clearAll();listaIdCredenciales.load("servlet/DirectorioTelefonicoServlet?Accion=getUsuarios&filter[value]=");
inicial();
</script>
<%=EncabezadoPie.getPie()%>
<% //DirectorioTelefonico.jsp %>
