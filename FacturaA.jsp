<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%><%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<script>
var errorComunicacion='ERROR DE COMUNICACION';
var errorEjecutarAccion='ERROR AL EJECUTAR ACCION';
var registroGuardado='REGISTRO GUARDADO';
var registroModificado='REGISTRO MODIFICADO';
var tituloEliminado='ELIMINACION DE REGISTRO';
var registroEliminado='REGISTRO(S) ELIMINADO(S)';
var seguroDeseaEliminar='SEGURO QUE DESEA ELIMINAR';
var busquedaFinalizada='BUSQUEDA FINALIZADA';
var unRegistro='FAVOR DE SELECCIONAR AL MENOS UN REGISTRO';
var soloUnRegistro='FAVOR DE SELECCIONAR SOLO UN REGISTRO';
var id='';
var si='SI';
var no='NO';
var nada='';
var guardado='GUARDADO';
var modificado='MODIFICADO';
var etiquetaNuevo = 'NUEVO';
var etiquetaGuardar = 'GUARDAR';
var etiquetaModificar = 'MODIFICAR';
var etiquetaBuscar = 'BUSCAR';
var etiquetaBorrar = 'BORRAR';
<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
%>

var Rfc = 'Rfc';
var Empresa = 'Empresa';

var forma={view:'form',id:'Forma',width:400,height:'100%',elements:[
	{view:'text',id:'Rfc',name:'Rfc',value:'',placeholder:Rfc,label:Rfc,required:true},
	{view:'text',id:'Empresa',name:'Empresa',value:'',placeholder:Empresa,label:Empresa,required:true},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Rfc',header:Rfc,sort:'string',width:100},
	{id:'Empresa',header:Empresa,sort:'string',fillspace:true}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'FACTURA A'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
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
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/FacturaAServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:Rfc,value: info.Rfc});
	$$('Confirmacion').add({campo:Empresa,value: info.Empresa});
}
$$('Rfc').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Rfc').setValue(nuevo); });
$$('Empresa').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Empresa').setValue(nuevo); });
inicial();
buscar();
</script>
<%=EncabezadoPie.getPie()%>
<% //FacturaA.jsp %>
