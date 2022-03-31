<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%><%@ page import="java.util.Calendar"%><%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
//falta crear su modulo y ponerle el numero que le corresponde
String moduloIdioma = "327";
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

var dateNow = new Date();
var tiempo = dateNow.getTime();

var forma={view:'form',id:'Forma',width:300,scroll:'y',height:'100%',enctype:"multipart/form-data",elements:[
	{view:'combo',id:'Diseno',name:'Diseno',value:'',placeholder:'<%=idiomaModulo.getProperty("Diseno") %>',label:'<%=idiomaModulo.getProperty("Diseno")%>',yCount:'5',options:["BLANCO","CENEFA SUPERIOR MCS"]},
	
	
	//{ view:'label',id:'MostrarDiseno',name:'MostrarDiseno',width:31.17,height:300,value:'<img src="https://www.w3schools.com/html/pic_mountain.jpg">'},
	{view:'iframe', id:'MostrarDiseno',height:320,src:''},

	//MOSTRAR IMAGEN MostrarDiseno
	{view:'text',id:'TamanoFuente',name:'TamanoFuente',width:150,value:'',placeholder:'<%=idiomaModulo.getProperty("TamanoFuente")%>',label:'<%=idiomaModulo.getProperty("TamanoFuente")%>',labelPosition:'top'},
	{view:'textarea',id:'TextoCredencial',name:'TextoCredencial',width:280,height:200,value:'',placeholder:'<%=idiomaModulo.getProperty("TextoCredencial")%>',label:'<%=idiomaModulo.getProperty("TextoCredencial")%>',labelPosition:'top',attributes:{maxlength:10000},required:true},		
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',value:etiquetaCredencial,width:135,click:'credencial'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{},{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',id:'GenerarCredencial',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'Diseno',header:'<%=idiomaModulo.getProperty("Diseno")%>',fillspace:true,sort:'string',adjust:"all",minWidth:250},
	{id:'MostrarDiseno',header:'<%=idiomaModulo.getProperty("MostrarDiseno")%>',sort:'string',adjust:"all",minWidth:200},
	{id:'TamanoFuente',header:'<%=idiomaModulo.getProperty("TamanoFuente")%>',sort:'string',adjust:"all",minWidth:80},
	{id:'TextoCredencial',header:'<%=idiomaModulo.getProperty("TextoCredencial")%>',sort:'string',adjust:"all",minWidth:80}
	]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'GENERAR CREDENCIAL'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('mylist').clearAll();$$('Confirmacion').clearAll(); $$('Tabla').clearAll();$$('Mensaje').setValue(nada); $$('Vacio').show();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');$$('mylist').clearAll();}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/CredencialesServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Diseno")%>',value: info.Diseno});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("MostrarDiseno")%>',value: info.MostrarDiseno});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("TamanoFuente")%>',value: info.TamanoFuente});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("TextoCredencial")%>',value: info.TextoCredencial});
	$$('mylist').clearAll();
}
function credencial(){ 
	var DisenoValor=$$('Diseno').getValue();
	var TamanoFuenteValor=$$('TamanoFuente').getValue();
	var TextoCredencialValor=$$('TextoCredencial').getValue();
	document.location = 'servlet/GenerarCredencialesTextoServlet?Diseno='+DisenoValor+'&TamanoFuente='+TamanoFuenteValor+'&TextoCredencial='+$$('TextoCredencial').getValue();
	//document.location = 'servlet/GenerarCredencialesTextoServlet?Diseno='+DisenoValor+'&TamanoFuente='+TamanoFuenteValor+'&TextoCredencial='+TextoCredencialValor;
	//document.location = 'servlet/GenerarCredencialesTextoServlet?Tabla=Credenciales&Id=' + $$('Tabla').getSelectedId();
}

$$('Diseno').attachEvent('onChange',function(nuevo,anterior){
//DEBUG alert('SI');
 if (nuevo == "BLANCO"){
 	//DEBUG alert('SI2');
 	$$('MostrarDiseno').show();
 	$$('MostrarDiseno').load("CredencialesDiseno.jsp?CredencialDiseno=Blanco");
 }else if (nuevo == "CENEFA SUPERIOR MCS"){
 	//DEBUG  alert('SI3');
 	$$('MostrarDiseno').show();
 	$$('MostrarDiseno').load("CredencialesDiseno.jsp?CredencialDiseno=CenefaSupMCS");
 }
 
 
 });
/* $$('MostrarDiseno').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('MostrarDiseno').setValue(nuevo); });
$$('TamanoFuente').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('TamanoFuente').setValue(nuevo); });
$$('TextoCredencial').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('TextoCredencial').setValue(nuevo); }); */

$$('MostrarDiseno').hide();
$$('TamanoFuente').hide();
//alert(tiempo);
$$('TamanoFuente').setValue(""+tiempo+"");
$$('BotonNuevo').hide();

</script>
<%=EncabezadoPie.getPie()%>