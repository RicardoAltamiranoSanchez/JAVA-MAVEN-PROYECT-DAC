<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "326";
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
	// COMBO en lugar de text se cambia a combo para mostrar una lista de otra tabla
	{view:'combo',/* inputWidth:300, */id:'GrupoEmpleados',name:'GrupoEmpleados',value:'',placeholder:'<%=idiomaModulo.getProperty("GrupoEmpleados") %>',label:'<%=idiomaModulo.getProperty("GrupoEmpleados") %>',labelPosition:'top',required:true,options:[],yCount:'5'},
	{view:'textarea',id:'Firma',name:'Firma',height:200,value:'',placeholder:'<%=idiomaModulo.getProperty("Firma")%>',label:'<%=idiomaModulo.getProperty("Firma")%>',labelPosition:'top',attributes:{maxlength:10000},required:true},
	{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]},
	{view: 'label',id:'GrupoTexto',name:'GrupoTexto'}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'GrupoEmpleados',header:'<%=idiomaModulo.getProperty("GrupoEmpleados")%>',fillspace:false,width:'300',sort:'string'},
	{id:'Firma',header:'<%=idiomaModulo.getProperty("Firma")%>',fillspace:true,sort:'string'}]}]};
	
<%-- QUITANDO COMENTATARIO SE OCULTA NUEVAMENTE EL BOTON MODIFICAR var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},/* OCULTANDO BOTON MODIFICAR *//* {view:'button',value:etiquetaModificar,width:85,click:'consultar'} */]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'GrupoEmpleados',header:'<%=idiomaModulo.getProperty("GrupoEmpleados")%>',fillspace:false,width:'300',sort:'string'},
	{id:'Firma',header:'<%=idiomaModulo.getProperty("Firma")%>',fillspace:true,sort:'string'}]}]}; --%>
	
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'FIRMA POR GRUPOS'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('Confirmacion').clearAll();$$('Tabla').clearAll();$$('Mensaje').setValue(nada);$$('Vacio').show();iniciales();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
/* function guardarDespues(){$$('Forma').clear();inicial();} */
function guardarDespues(){$$('Forma').clear();inicial(); ;}
// QUITANDO COMENTATARIO SE HABILITA EL QUE NO MUESTRE ELEMENTOS YA EXISTENTES function guardarDespues(){$$('Forma').clear();inicial(); /* VOLVIENDO A LLENAR LA LISTA PARA QUE NO ESCOJA A ALGUIEN QUE YA REGISTRO  */var listaGrupoEmpleados = $$("GrupoEmpleados").getPopup().getList();listaGrupoEmpleados.clearAll();listaGrupoEmpleados.load("servlet/AgrupadorEmpleadosServlet?Accion=getAgrupadorEmpleados&filter[value]=");}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
// QUITANDO COMENTATARIO SE HABILITA EL QUE NO MUESTRE ELEMENTOS YA EXISTENTESfunction borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar'); /* VOLVIENDO A LLENAR LA LISTA PARA QUE INGRESE AL EMPLEADO QUE FUE ELIMINADO DE LA TABLA  */var listaGrupoEmpleados = $$("GrupoEmpleados").getPopup().getList();listaGrupoEmpleados.clearAll();listaGrupoEmpleados.load("servlet/AgrupadorEmpleadosServlet?Accion=getAgrupadorEmpleados&filter[value]=");}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function modificarDespues(){}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/FirmasGruposServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("GrupoEmpleados")%>',value: info.GrupoEmpleados});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Firma")%>',value: info.Firma});
}
//COMBO se bloquea el onChange de área pues no existe funcion validada
//$$('GrupoEmpleados').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('GrupoEmpleados').setValue(nuevo); });
//$$('GrupoTexto').hide();
$$('GrupoEmpleados').attachEvent('onChange',function(){ $$('GrupoTexto').setValue($$('GrupoEmpleados').getValue()); });
//$$('Firma').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Firma').setValue(nuevo); });
// COMBO llenar lista de empleados
var listaGrupoEmpleados = $$("GrupoEmpleados").getPopup().getList();listaGrupoEmpleados.clearAll();listaGrupoEmpleados.load("servlet/AgrupadorEmpleadosServlet?Accion=getAgrupadorEmpleados&filter[value]=");
inicial();
</script>
<%=EncabezadoPie.getPie()%>
<% //PuestosGrupo.jsp %>