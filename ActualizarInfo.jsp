<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
//falta crear su modulo y ponerle el numero que le corresponde
String moduloIdioma = "139";
Properties idioma = (Properties)session.getAttribute("IdiomaGeneral");
Properties idiomaModulo = (Properties)session.getAttribute(moduloIdioma);%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<script>
var errorComunicacion='<%=idioma.getProperty("errorComunicacion") %>';
var errorEjecutarAccion='<%=idioma.getProperty("errorEjecutarAccion") %>';
var registroGuardado='<%=idioma.getProperty("registroGuardado") %>';
var registroModificado='<%=idioma.getProperty("registroModificado") %>';
var tituloEliminado='<%=idioma.getProperty("tituloEliminado") %>';
var tituloCredencial = '<%=idioma.getProperty("tituloCredencial") %>';
var registroEliminado='<%=idioma.getProperty("registroEliminado") %>';
var seguroDeseaEliminar='<%=idioma.getProperty("seguroDeseaEliminar") %>';
var seguroDeseaCrearCredencial='<%=idioma.getProperty("seguroDeseaCrearCredencial") %>';
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
var etiquetaCredencial = '<%=idiomaModulo.getProperty("etiquetaCredencial") %>';

var forma={view:'form',id:'Forma',width:950,scroll:'y',height:'100%',enctype:"multipart/form-data",elements:[
	{view:'text',id:'NombreCompleto',name:'NombreCompleto',value:'',placeholder:'<%=idiomaModulo.getProperty("NombreCompleto")%>',label:'<%=idiomaModulo.getProperty("NombreCompleto")%>',required:true},
	{view:'text',id:'Puesto',name:'Puesto',value:'',placeholder:'<%=idiomaModulo.getProperty("Puesto")%>',label:'<%=idiomaModulo.getProperty("Puesto")%>',required:true},
	{view:'text',id:'Empresa',name:'Empresa',value:'',placeholder:'<%=idiomaModulo.getProperty("Empresa")%>',label:'<%=idiomaModulo.getProperty("Empresa")%>',required:true},
	{view:'combo',id:'Estacion',name:'Estacion',value:'',placeholder:'<%=idiomaModulo.getProperty("Estacion") %>',label:'<%=idiomaModulo.getProperty("Estacion")%>',required:true,yCount:'5',options:["GDL","MEX","HMO","MXL","CUL","MTY","CUN"]},
	{view:'text',id:'IMSS',name:'IMSS',value:'',placeholder:'<%=idiomaModulo.getProperty("IMSS")%>',label:'<%=idiomaModulo.getProperty("IMSS")%>',required:true},
	{view:'text',id:'CURP',name:'CURP',value:'',placeholder:'<%=idiomaModulo.getProperty("CURP")%>',label:'<%=idiomaModulo.getProperty("CURP")%>',required:true},
	{view:'text',id:'Antiguedad',name:'Antiguedad',value:'',placeholder:'<%=idiomaModulo.getProperty("Antiguedad")%>',label:'<%=idiomaModulo.getProperty("Antiguedad")%>',required:true},
	{view:'combo',id:'Division',name:'Division',value:'',placeholder:'<%=idiomaModulo.getProperty("Division") %>',label:'<%=idiomaModulo.getProperty("Division")%>',disabled:true,required:true,yCount:'5',options:["DLV","DAC","MWS","JMF","NET","MCS","MAM","SEG","OLG"]},
	{view:'text',id:'Nivel',name:'Nivel',value:'',placeholder:'<%=idiomaModulo.getProperty("Nivel")%>',label:'<%=idiomaModulo.getProperty("Nivel")%>'},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'NombreCompleto',header:'<%=idiomaModulo.getProperty("NombreCompleto")%>',fillspace:true,sort:'string'},
	{id:'Puesto',header:'<%=idiomaModulo.getProperty("Puesto")%>',sort:'string'},
	{id:'Empresa',header:'<%=idiomaModulo.getProperty("Empresa")%>',sort:'string'},
	{id:'Estacion',header:'<%=idiomaModulo.getProperty("Estacion")%>',sort:'string'},
	{id:'IMSS',header:'<%=idiomaModulo.getProperty("IMSS")%>',sort:'string'},
	{id:'CURP',header:'<%=idiomaModulo.getProperty("CURP")%>',sort:'string'},
	{id:'Antiguedad',header:'<%=idiomaModulo.getProperty("Antiguedad")%>',sort:'string'},
	{id:'Division',header:'<%=idiomaModulo.getProperty("Division")%>',sort:'string'},
	{id:'Nivel',header:'<%=idiomaModulo.getProperty("Nivel")%>',sort:'string'}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'FORMATOS'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});
$$('Forma').setValues({Accion:'Actualizar'},true);enviar(busquedaFinalizada,'Actualizar');	
function nuevo(){$$('BotonGuardar').show();$$('Forma').clear();$$('Confirmacion').clearAll(); $$('Tabla').clearAll();$$('Mensaje').setValue(nada); $$('Vacio').show();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'ModificarInfo'},true); if($$('Forma').validate()) { enviar(registroGuardado,'ModificarInfo'); webix.message(registroGuardado);$$('Mensaje').setValue('<font color="green"><strong>'+registroGuardado+'</strong></font>');}}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/CredencialesServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='ActualizarInfo'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Actualizar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('NombreCompleto').setValue(info.NombreCompleto);
	$$('Puesto').setValue(info.Puesto);
	$$('Empresa').setValue(info.Empresa);
	$$('Estacion').setValue(info.Estacion);
	$$('IMSS').setValue(info.IMSS);
	$$('CURP').setValue(info.CURP);
	$$('Antiguedad').setValue(info.Antiguedad);
	$$('Division').setValue(info.Division);
	$$('Nivel').setValue(info.Nivel);
}

$$('NombreCompleto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NombreCompleto').setValue(nuevo); });
$$('Puesto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Puesto').setValue(nuevo); });
$$('Empresa').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Empresa').setValue(nuevo); });
$$('Estacion').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Estacion').setValue(nuevo); });
$$('IMSS').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IMSS').setValue(nuevo); });
$$('CURP').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('CURP').setValue(nuevo); });
$$('Division').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Division').setValue(nuevo); });
$$('Nivel').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Nivel').setValue(nuevo); });
</script>
<%=EncabezadoPie.getPie()%>