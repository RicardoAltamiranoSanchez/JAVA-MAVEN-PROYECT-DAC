<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%><%@ page import="Libreria.MysqlPool" %><%@ page import="java.sql.ResultSet" %>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "193";
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
var etiquetaAutorizacion1 = '<%=idiomaModulo.getProperty("etiquetaAutorizacion1") %>';
var etiquetaAutorizacion2 = '<%=idiomaModulo.getProperty("etiquetaAutorizacion2") %>';
var etiquetaCancelar = '<%=idiomaModulo.getProperty("etiquetaCancelar") %>';
var etiquetaMotivo = '<%=idiomaModulo.getProperty("etiquetaMotivo") %>';
var tipo = "";
<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
%>

var forma={view:'form',id:'Forma',width:400,height:'100%',elements:[
	{view:'datepicker',date: new Date(),stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),labelPosition:'top',id:'Fecha',name: 'Fecha',placeholder:'<%=idiomaModulo.getProperty("Fecha")%>',label: '<%=idiomaModulo.getProperty("Fecha")%>',timepicker:true,required:true},
	{view:'datepicker',date: new Date(),stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),id:'FechaFin',name: 'FechaFin',labelPosition:'top',placeholder:'<%=idiomaModulo.getProperty("FechaFin")%>',label: '<%=idiomaModulo.getProperty("FechaFin")%>',timepicker:true,hidden:true},
	{view:'combo',id:'IdGerente',name:'IdGerente',value:'',placeholder:'<%=idiomaModulo.getProperty("IdGerente") %>',label:'<%=idiomaModulo.getProperty("IdGerente")%>',labelPosition:'top',required:true,yCount:'3',options:[]},
	{view:'text',id:'Nombre',name:'Nombre',value:'',placeholder:'<%=idiomaModulo.getProperty("Nombre")%>',label:'<%=idiomaModulo.getProperty("Nombre")%>',labelPosition:'top',required:true},
	{view:'text',id:'Area',name:'Area',value:'',placeholder:'<%=idiomaModulo.getProperty("Area")%>',label:'<%=idiomaModulo.getProperty("Area")%>',labelPosition:'top',required:true},
	{view:'text',id:'Cantidad',name:'Cantidad',value:'',placeholder:'<%=idiomaModulo.getProperty("Cantidad")%>',label:'<%=idiomaModulo.getProperty("Cantidad")%>',labelPosition:'top',required:true},
	{view:'text',id:'Descripcion',name:'Descripcion',value:'',placeholder:'<%=idiomaModulo.getProperty("Descripcion")%>',label:'<%=idiomaModulo.getProperty("Descripcion")%>',labelPosition:'top',required:true},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaAutorizacion1,click:'Autorizacion1',width:110,id:'Autorizacion1',hidden:true},{view:'button',value:etiquetaCancelar,width:85,click:'cancelar',id:'Cancelar',hidden:true},{view:'button',value:etiquetaAutorizacion2,width:110,click:'Autorizacion2',id:'Autorizacion2',hidden:true},{view:'button',id:'botonBorrar',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',id:'botonModificar',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'Fecha',header:'<%=idiomaModulo.getProperty("Fecha")%>',fillspace:true,sort:'date',adjust:"all"},
	{id:'Nombre',header:'<%=idiomaModulo.getProperty("Nombre")%>',sort:'string',adjust:"all"},
	{id:'Area',header:'<%=idiomaModulo.getProperty("Area")%>',sort:'string',adjust:"all"},
	{id:'Cantidad',header:'<%=idiomaModulo.getProperty("Cantidad")%>',sort:'string',adjust:"all"},
	{id:'Descripcion',header:'<%=idiomaModulo.getProperty("Descripcion")%>',sort:'string',adjust:"all"},
	{id:'IdGerente',header:'<%=idiomaModulo.getProperty("IdGerente")%>',sort:'string',adjust:"all"},
	{id:'AutorizacionDirector',header:'<%=idiomaModulo.getProperty("AutorizacionDirector")%>',sort:'string',adjust:"all"},
	{id:'AutorizacionFinanzas',header:'<%=idiomaModulo.getProperty("AutorizacionFinanzas")%>',sort:'string',adjust:"all"},
	{id:'Estatus',header:'<%=idiomaModulo.getProperty("Estatus")%>',sort:'string',adjust:"all"},
	{id:'Motivo',header:'<%=idiomaModulo.getProperty("Motivo")%>',sort:'string',adjust:"all"}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'REQUISICIONCOMPRA'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('Confirmacion').clearAll();$$('Tabla').clearAll();$$('Mensaje').setValue(nada);$$('Vacio').show();iniciales();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
function guardarDespues(){$$('Forma').clear();inicial();}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){if(tipo == "44"){$$('Forma').setValues({Accion:'AutorizacionRH'},true);enviar(busquedaFinalizada,'Buscar');}else{$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');}}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function modificarDespues(){}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().get('servlet/RequisicionCompraServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());/*MENSAJE DONDE NO PUEDE MODIFICAR*/if($$('Nombre').getValue() == ''){webix.message("SOLO PUEDES MODIFICAR CON ESTATUS SOLICITUD");$$('Mensaje').setValue('<font color="green"><strong>SOLO PUEDES MODIFICAR CON ESTATUS SOLICITUD</strong></font>');}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){if(data.json().Nombre == ""){ registroEliminado = "REGISTRO(S) ELIMINADO(S)"; }else{ registroEliminado = "SOLO PUEDES BORRAR CON ESTATUS SOLICITUD"; }borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Fecha")%>',value: info.Fecha});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Nombre")%>',value: info.Nombre});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Area")%>',value: info.Area});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Cantidad")%>',value: info.Cantidad});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Descripcion")%>',value: info.Descripcion});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdGerente")%>',value: info.IdGerente});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("AutorizacionDirector")%>',value: info.AutorizacionDirector});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("AutorizacionFinanzas")%>',value: info.AutorizacionFinanzas});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Estatus")%>',value: info.Estatus});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Motivo")%>',value: info.Motivo});
}
//funciones dependiendo el nivel de operacion
<% 	final MysqlPool eDB;
   	final ResultSet resultados;
   	eDB = new MysqlPool();
    eDB.setConexion();
    resultados = eDB.getQuery("select U.IdPerfilesUsuarios from Usuarios as U left join Gerentes as G on(U.Id = G.IdUsuario) where U.Id = '" + session.getAttribute("IdUsuario") + "'");
    while(resultados.next()){ %>
    	if(<%=resultados.getString("IdPerfilesUsuarios").equals("43")%>){
    		//director
    		$$('Autorizacion1').show();
			$$('Cancelar').show();
			$$('Forma').hide();
			$$('botonBorrar').hide();
			$$('botonModificar').hide();
			tipo = "43";
			$$('Forma').setValues({Accion:'AutorizacionGerentes'},true);
			enviar(busquedaFinalizada,'Buscar');
    	}else if(<%=resultados.getString("IdPerfilesUsuarios").equals("44")%>){
    		//finanzas
    		$$('Autorizacion2').show();
			$$('Cancelar').show();
			$$('FechaFin').show();
			//ocultar lo que no se necesita
			$$('BotonGuardar').hide();
			$$('IdGerente').hide();
			$$('Area').hide();
			$$('Cantidad').hide();
			$$('Descripcion').hide();
			$$('botonBorrar').hide();
			$$('botonModificar').hide();
			tipo = "44";
			$$('Forma').setValues({Accion:'AutorizacionRH'},true);
			enviar(busquedaFinalizada,'Buscar');
    	}else if(<%=resultados.getString("IdPerfilesUsuarios").equals("25")%>){
    		//ti
    		modoTI();
    	}
<%  }
    eDB.setCerrar(resultados);
    eDB.setCerrar();
	eDB.setCerrarConexion();
%>
//funciones para autorizar
function Autorizacion1(){var id = $$('Tabla').getSelectedId();if(id == null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{webix.ajax().post("servlet/RequisicionCompraServlet",{Accion:"Autorizacion1",Id:id},{error:function(text, data, XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text, data, XmlHttpRequest){/*actualizar tabla*/$$('Forma').setValues({Accion:'AutorizacionGerentes'},true);enviar(busquedaFinalizada,'Buscar');}});}}
function Autorizacion2(){var id = $$('Tabla').getSelectedId();if(id == null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{webix.ajax().post("servlet/RequisicionCompraServlet",{Accion:"Autorizacion2",Id:id},{error:function(text, data, XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text, data, XmlHttpRequest){/*actualizar tabla*/$$('Forma').setValues({Accion:'AutorizacionRH'},true);enviar(busquedaFinalizada,'Buscar');}});}}
function cancelar(){webix.confirm({title:etiquetaMotivo,ok:si,cancel:no,type:'confirm-error',text:'SEGURO DE CANCELAR',callback:function(result){if(result){var id = $$('Tabla').getSelectedId();if(id == null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{var mot = prompt("INGRESA EL MOTIVO DE LA CANCELACION", "");if (mot != null) {mot = mot.toUpperCase();webix.ajax().post("servlet/RequisicionCompraServlet",{Accion:"Cancelar",Id:id,Motivo:mot,Perfil:tipo},{error:function(text, data, XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text, data, XmlHttpRequest){if(data.json().Estatus == 'Cancelado'){ webix.message("YA SE ENCUENTRA CANCELADA LA SOLICITUD"); }else if(data.json().Estatus == 'Autorizado' || data.json().Estatus == 'Pendiente'){ webix.message("NO PUEDES CANCELAR UNA VEZ AUTORIZADO"); }/*actualizar tabla*/if(tipo == "43"){ $$('Forma').setValues({Accion:'AutorizacionGerentes'},true);enviar(busquedaFinalizada,'Buscar'); }else if(tipo == "44"){ $$('Forma').setValues({Accion:'AutorizacionRH'},true);enviar(busquedaFinalizada,'Buscar'); }  }});}}}else{$$('Tabla').clearSelection();}}});}
$$('Nombre').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Nombre').setValue(nuevo); });
$$('Area').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Area').setValue(nuevo); });
$$('Cantidad').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Cantidad').setValue(nuevo); });
$$('Descripcion').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Descripcion').setValue(nuevo); });
var listaIdGerente = $$("IdGerente").getPopup().getList();listaIdGerente.clearAll();listaIdGerente.load("servlet/GerentesServlet?Accion=getGerentes&filter[value]=");
inicial();
</script>
<%=EncabezadoPie.getPie()%>
<% //RequisicionCompra.jsp %>