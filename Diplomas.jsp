<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "184";
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

var forma={view:'form',id:'Forma',width:400,height:'100%',scroll:'y',elements:[
	{view:'text',id:'Tipo',name:'Tipo',value:'',placeholder:'<%=idiomaModulo.getProperty("Tipo")%>',label:'<%=idiomaModulo.getProperty("Tipo")%>',labelPosition:"Top",required:true},
	{view:'text',id:'NombreAlumno',name:'NombreAlumno',value:'',placeholder:'<%=idiomaModulo.getProperty("NombreAlumno")%>',label:'<%=idiomaModulo.getProperty("NombreAlumno")%>',labelPosition:"Top",required:true},
	{view:'text',id:'NombreCurso',name:'NombreCurso',value:'',placeholder:'<%=idiomaModulo.getProperty("NombreCurso")%>',label:'<%=idiomaModulo.getProperty("NombreCurso")%>',labelPosition:"Top",required:true},
	{view:'text',id:'DescripcionCurso',name:'DescripcionCurso',value:'',placeholder:'<%=idiomaModulo.getProperty("DescripcionCurso")%>',label:'<%=idiomaModulo.getProperty("DescripcionCurso")%>',labelPosition:"Top",required:true},
	{view:'text',id:'NombreEmpresa',name:'NombreEmpresa',value:'',placeholder:'<%=idiomaModulo.getProperty("NombreEmpresa")%>',label:'<%=idiomaModulo.getProperty("NombreEmpresa")%>',labelPosition:"Top",required:true},
	{view:'text',id:'Imparticion',name:'Imparticion',value:'',placeholder:'<%=idiomaModulo.getProperty("Imparticion")%>',label:'<%=idiomaModulo.getProperty("Imparticion")%>',labelPosition:"Top",required:true},
	{view:'text',id:'Certificado',name:'Certificado',value:'',placeholder:'<%=idiomaModulo.getProperty("Certificado")%>',label:'<%=idiomaModulo.getProperty("Certificado")%>',labelPosition:"Top",required:true},
	{view:'text',id:'ResponsableUno',name:'ResponsableUno',value:'',placeholder:'<%=idiomaModulo.getProperty("ResponsableUno")%>',label:'<%=idiomaModulo.getProperty("ResponsableUno")%>',labelPosition:"Top",required:true},
	{view:'text',id:'PuestoResponsableUno',name:'PuestoResponsableUno',value:'',placeholder:'<%=idiomaModulo.getProperty("PuestoResponsableUno")%>',label:'<%=idiomaModulo.getProperty("PuestoResponsableUno")%>',labelPosition:"Top",required:true},
	{view:'text',id:'ResponsableDos',name:'ResponsableDos',value:'',placeholder:'<%=idiomaModulo.getProperty("ResponsableDos")%>',label:'<%=idiomaModulo.getProperty("ResponsableDos")%>',labelPosition:"Top",required:true},
	{view:'text',id:'PuestoResponsableDos',name:'PuestoResponsableDos',value:'',placeholder:'<%=idiomaModulo.getProperty("PuestoResponsableDos")%>',label:'<%=idiomaModulo.getProperty("PuestoResponsableDos")%>',labelPosition:"Top",required:true},
	{view:'textarea',id:'Titulo',name:'Titulo',value:'',placeholder:'<%=idiomaModulo.getProperty("Titulo")%>',label:'<%=idiomaModulo.getProperty("Titulo")%>',labelPosition:"Top",required:true},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:'<%=idiomaModulo.getProperty("GeneraDiploma") %>',width:120,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar',hidden:true},{view:'button',value:etiquetaModificar,width:85,click:'consultar',hidden:true},{view:'button',value:'<%=idiomaModulo.getProperty("GeneraDiploma") %>',width:120,click:'diploma("")'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'NombreAlumno',header:'<%=idiomaModulo.getProperty("NombreAlumno")%>',fillspace:true,sort:'string'},
	{id:'NombreCurso',header:'<%=idiomaModulo.getProperty("NombreCurso")%>',fillspace:true,sort:'string'}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'DIPLOMAS'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('Confirmacion').clearAll();$$('Tabla').clearAll();$$('Mensaje').setValue(nada);$$('Vacio').show();iniciales();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar('DIPLOMA GENERADO','Guardar');}}
function guardarDespues(idDiploma){$$('Forma').clear();diploma(idDiploma);inicial();}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function modificarDespues(){}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/DiplomasServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();if(accion=='Guardar'){guardarDespues(data.json().id);}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NombreAlumno")%>',value: info.NombreAlumno});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NombreCurso")%>',value: info.NombreCurso});
}
function diploma(idDiploma){ 
	if(idDiploma == ""){
		var ids=$$('Tabla').getSelectedId();
		document.location = 'servlet/GeneraDiplomaServlet?Id='+ids;
	}else{
		document.location = 'servlet/GeneraDiplomaServlet?Id='+idDiploma;
	}	
}
$$('Tipo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Tipo').setValue(nuevo); });
$$('NombreAlumno').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NombreAlumno').setValue(nuevo); });
$$('NombreCurso').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NombreCurso').setValue(nuevo); });
$$('DescripcionCurso').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('DescripcionCurso').setValue(nuevo); });
$$('NombreEmpresa').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NombreEmpresa').setValue(nuevo); });
$$('Imparticion').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Imparticion').setValue(nuevo); });
$$('Certificado').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Certificado').setValue(nuevo); });
$$('ResponsableUno').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('ResponsableUno').setValue(nuevo); });
$$('PuestoResponsableUno').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('PuestoResponsableUno').setValue(nuevo); });
$$('ResponsableDos').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('ResponsableDos').setValue(nuevo); });
$$('PuestoResponsableDos').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('PuestoResponsableDos').setValue(nuevo); });
$$('Titulo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Titulo').setValue(nuevo); });
inicial();
</script>
<%=EncabezadoPie.getPie()%>
<% //Diplomas.jsp %>
