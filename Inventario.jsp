<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "";
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
	{view:'text',id:'ValidarSoftware',name:'ValidarSoftware',value:'',placeholder:'<%=idiomaModulo.getProperty("ValidarSoftware")%>',label:'<%=idiomaModulo.getProperty("ValidarSoftware")%>',required:true},
	{view:'text',id:'IdTiposActivo',name:'IdTiposActivo',value:'',placeholder:'<%=idiomaModulo.getProperty("IdTiposActivo")%>',label:'<%=idiomaModulo.getProperty("IdTiposActivo")%>',required:true},
	{view:'text',id:'IdEmpresasGrupo',name:'IdEmpresasGrupo',value:'',placeholder:'<%=idiomaModulo.getProperty("IdEmpresasGrupo")%>',label:'<%=idiomaModulo.getProperty("IdEmpresasGrupo")%>',required:true},
	{view:'text',id:'IdUbicacionesGrupo',name:'IdUbicacionesGrupo',value:'',placeholder:'<%=idiomaModulo.getProperty("IdUbicacionesGrupo")%>',label:'<%=idiomaModulo.getProperty("IdUbicacionesGrupo")%>',required:true},
	{view:'text',id:'NumActivoFijo',name:'NumActivoFijo',value:'',placeholder:'<%=idiomaModulo.getProperty("NumActivoFijo")%>',label:'<%=idiomaModulo.getProperty("NumActivoFijo")%>',required:true},
	{view:'text',id:'FechaCompra',name:'FechaCompra',value:'',placeholder:'<%=idiomaModulo.getProperty("FechaCompra")%>',label:'<%=idiomaModulo.getProperty("FechaCompra")%>',required:true},
	{view:'text',id:'FechaFinGarantia',name:'FechaFinGarantia',value:'',placeholder:'<%=idiomaModulo.getProperty("FechaFinGarantia")%>',label:'<%=idiomaModulo.getProperty("FechaFinGarantia")%>',required:true},
	{view:'text',id:'Descripcion',name:'Descripcion',value:'',placeholder:'<%=idiomaModulo.getProperty("Descripcion")%>',label:'<%=idiomaModulo.getProperty("Descripcion")%>',required:true},
	{view:'text',id:'IdEmpleadosGrupo',name:'IdEmpleadosGrupo',value:'',placeholder:'<%=idiomaModulo.getProperty("IdEmpleadosGrupo")%>',label:'<%=idiomaModulo.getProperty("IdEmpleadosGrupo")%>',required:true},
	{view:'text',id:'FechaAsignacionActivo',name:'FechaAsignacionActivo',value:'',placeholder:'<%=idiomaModulo.getProperty("FechaAsignacionActivo")%>',label:'<%=idiomaModulo.getProperty("FechaAsignacionActivo")%>',required:true},
	{view:'text',id:'Marca',name:'Marca',value:'',placeholder:'<%=idiomaModulo.getProperty("Marca")%>',label:'<%=idiomaModulo.getProperty("Marca")%>',required:true},
	{view:'text',id:'Modelo',name:'Modelo',value:'',placeholder:'<%=idiomaModulo.getProperty("Modelo")%>',label:'<%=idiomaModulo.getProperty("Modelo")%>',required:true},
	{view:'text',id:'Serie',name:'Serie',value:'',placeholder:'<%=idiomaModulo.getProperty("Serie")%>',label:'<%=idiomaModulo.getProperty("Serie")%>',required:true},
	{view:'text',id:'NombreSoftware',name:'NombreSoftware',value:'',placeholder:'<%=idiomaModulo.getProperty("NombreSoftware")%>',label:'<%=idiomaModulo.getProperty("NombreSoftware")%>',required:true},
	{view:'text',id:'VersionSoftware',name:'VersionSoftware',value:'',placeholder:'<%=idiomaModulo.getProperty("VersionSoftware")%>',label:'<%=idiomaModulo.getProperty("VersionSoftware")%>',required:true},
	{view:'text',id:'Matricula',name:'Matricula',value:'',placeholder:'<%=idiomaModulo.getProperty("Matricula")%>',label:'<%=idiomaModulo.getProperty("Matricula")%>',required:true},
	{view:'text',id:'NumUnidad',name:'NumUnidad',value:'',placeholder:'<%=idiomaModulo.getProperty("NumUnidad")%>',label:'<%=idiomaModulo.getProperty("NumUnidad")%>',required:true},
	{view:'text',id:'Restauracion',name:'Restauracion',value:'',placeholder:'<%=idiomaModulo.getProperty("Restauracion")%>',label:'<%=idiomaModulo.getProperty("Restauracion")%>',required:true},
	{view:'text',id:'IdInventario',name:'IdInventario',value:'',placeholder:'<%=idiomaModulo.getProperty("IdInventario")%>',label:'<%=idiomaModulo.getProperty("IdInventario")%>',required:true},
	{view:'text',id:'ImporteSinIva',name:'ImporteSinIva',value:'',placeholder:'<%=idiomaModulo.getProperty("ImporteSinIva")%>',label:'<%=idiomaModulo.getProperty("ImporteSinIva")%>',required:true},
	{view:'text',id:'IdEstatusActivos',name:'IdEstatusActivos',value:'',placeholder:'<%=idiomaModulo.getProperty("IdEstatusActivos")%>',label:'<%=idiomaModulo.getProperty("IdEstatusActivos")%>',required:true},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'ValidarSoftware',header:'<%=idiomaModulo.getProperty("ValidarSoftware")%>',fillspace:true,sort:'string'},
	{id:'IdTiposActivo',header:'<%=idiomaModulo.getProperty("IdTiposActivo")%>',sort:'string'},
	{id:'IdEmpresasGrupo',header:'<%=idiomaModulo.getProperty("IdEmpresasGrupo")%>',sort:'string'},
	{id:'IdUbicacionesGrupo',header:'<%=idiomaModulo.getProperty("IdUbicacionesGrupo")%>',sort:'string'},
	{id:'NumActivoFijo',header:'<%=idiomaModulo.getProperty("NumActivoFijo")%>',sort:'string'},
	{id:'FechaCompra',header:'<%=idiomaModulo.getProperty("FechaCompra")%>',sort:'string'},
	{id:'FechaFinGarantia',header:'<%=idiomaModulo.getProperty("FechaFinGarantia")%>',sort:'string'},
	{id:'Descripcion',header:'<%=idiomaModulo.getProperty("Descripcion")%>',sort:'string'},
	{id:'IdEmpleadosGrupo',header:'<%=idiomaModulo.getProperty("IdEmpleadosGrupo")%>',sort:'string'},
	{id:'FechaAsignacionActivo',header:'<%=idiomaModulo.getProperty("FechaAsignacionActivo")%>',sort:'string'},
	{id:'Marca',header:'<%=idiomaModulo.getProperty("Marca")%>',sort:'string'},
	{id:'Modelo',header:'<%=idiomaModulo.getProperty("Modelo")%>',sort:'string'},
	{id:'Serie',header:'<%=idiomaModulo.getProperty("Serie")%>',sort:'string'},
	{id:'NombreSoftware',header:'<%=idiomaModulo.getProperty("NombreSoftware")%>',sort:'string'},
	{id:'VersionSoftware',header:'<%=idiomaModulo.getProperty("VersionSoftware")%>',sort:'string'},
	{id:'Matricula',header:'<%=idiomaModulo.getProperty("Matricula")%>',sort:'string'},
	{id:'NumUnidad',header:'<%=idiomaModulo.getProperty("NumUnidad")%>',sort:'string'},
	{id:'Restauracion',header:'<%=idiomaModulo.getProperty("Restauracion")%>',sort:'string'},
	{id:'IdInventario',header:'<%=idiomaModulo.getProperty("IdInventario")%>',sort:'string'},
	{id:'ImporteSinIva',header:'<%=idiomaModulo.getProperty("ImporteSinIva")%>',sort:'string'},
	{id:'IdEstatusActivos',header:'<%=idiomaModulo.getProperty("IdEstatusActivos")%>',sort:'string'}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'INVENTARIO'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
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
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/InventarioServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("ValidarSoftware")%>',value: info.ValidarSoftware});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdTiposActivo")%>',value: info.IdTiposActivo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdEmpresasGrupo")%>',value: info.IdEmpresasGrupo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdUbicacionesGrupo")%>',value: info.IdUbicacionesGrupo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NumActivoFijo")%>',value: info.NumActivoFijo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechaCompra")%>',value: info.FechaCompra});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechaFinGarantia")%>',value: info.FechaFinGarantia});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Descripcion")%>',value: info.Descripcion});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdEmpleadosGrupo")%>',value: info.IdEmpleadosGrupo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechaAsignacionActivo")%>',value: info.FechaAsignacionActivo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Marca")%>',value: info.Marca});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Modelo")%>',value: info.Modelo});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Serie")%>',value: info.Serie});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NombreSoftware")%>',value: info.NombreSoftware});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("VersionSoftware")%>',value: info.VersionSoftware});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Matricula")%>',value: info.Matricula});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NumUnidad")%>',value: info.NumUnidad});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Restauracion")%>',value: info.Restauracion});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdInventario")%>',value: info.IdInventario});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("ImporteSinIva")%>',value: info.ImporteSinIva});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdEstatusActivos")%>',value: info.IdEstatusActivos});
}
$$('ValidarSoftware').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('ValidarSoftware').setValue(nuevo); });
$$('IdTiposActivo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdTiposActivo').setValue(nuevo); });
$$('IdEmpresasGrupo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdEmpresasGrupo').setValue(nuevo); });
$$('IdUbicacionesGrupo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdUbicacionesGrupo').setValue(nuevo); });
$$('NumActivoFijo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NumActivoFijo').setValue(nuevo); });
$$('FechaCompra').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('FechaCompra').setValue(nuevo); });
$$('FechaFinGarantia').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('FechaFinGarantia').setValue(nuevo); });
$$('Descripcion').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Descripcion').setValue(nuevo); });
$$('IdEmpleadosGrupo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdEmpleadosGrupo').setValue(nuevo); });
$$('FechaAsignacionActivo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('FechaAsignacionActivo').setValue(nuevo); });
$$('Marca').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Marca').setValue(nuevo); });
$$('Modelo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Modelo').setValue(nuevo); });
$$('Serie').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Serie').setValue(nuevo); });
$$('NombreSoftware').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NombreSoftware').setValue(nuevo); });
$$('VersionSoftware').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('VersionSoftware').setValue(nuevo); });
$$('Matricula').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Matricula').setValue(nuevo); });
$$('NumUnidad').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NumUnidad').setValue(nuevo); });
$$('Restauracion').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Restauracion').setValue(nuevo); });
$$('IdInventario').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdInventario').setValue(nuevo); });
$$('ImporteSinIva').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('ImporteSinIva').setValue(nuevo); });
$$('IdEstatusActivos').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdEstatusActivos').setValue(nuevo); });
inicial();
</script>
<%=EncabezadoPie.getPie()%>
<% //Inventario.jsp %>