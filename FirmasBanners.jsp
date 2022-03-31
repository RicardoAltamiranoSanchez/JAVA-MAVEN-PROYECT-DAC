<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "336";
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

var value = 'Receptor de respuesta en Servlet';
<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
%>

var forma={view:'form',id:'Forma',width:400,height:'100%',elements:[
	{view:'combo',id:'IdFirmas',name:'IdFirmas',value:'',placeholder:'<%=idiomaModulo.getProperty("IdFirmas") %>',label:'<%=idiomaModulo.getProperty("IdFirmas") %>',labelPosition:'top',required:true,options:[],yCount:'3'},
	{view:'uploader',id:'ArchivoBannerFirma',name:'ArchivoBannerFirma',value:'',link:'mylist',placeholder:'<%=idiomaModulo.getProperty("ArchivoBannerFirma")%>',label:'<%=idiomaModulo.getProperty("ArchivoBannerFirma")%>',upload:'servlet/SubirFirmasBannersServlet',autosend:true,required:true,multiple:false},
	{borderless: true, view:"list", id:"mylist", type:"uploader", autoheight:true, minHeight: 50},
	{view:'label',id:'value',name:'value',value:'',placeholder:value,label:value,required:false,hidden:true},	
	{view:'combo',id:'EstatusBannerFirma',name:'EstatusBannerFirma',value:'ACTIVO',placeholder:'<%=idiomaModulo.getProperty("EstatusBannerFirma") %>',label:'<%=idiomaModulo.getProperty("EstatusBannerFirma")%>',labelPosition:'top',required:true,yCount:'5',options:[{id:'ACTIVO',value:'<%=idiomaModulo.getProperty("ACTIVO")%>'},{id:'INACTIVO',value:'<%=idiomaModulo.getProperty("INACTIVO")%>'}]},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',rowHeight:200,resizeRow:true,select:'row',multiselect:true,columns:[
	{id:'IdFirmas',header:'<%=idiomaModulo.getProperty("IdFirmas")%>',width:200,sort:'string'},
	{id:'ArchivoBannerFirma',header:'<%=idiomaModulo.getProperty("ArchivoBannerFirma")%>',fillspace:true,sort:'string',template:"<img height=200 src='/MCSNetJDacIntra/banners/#ArchivoBannerFirma#'/>",minWidth:150},
	{id:'Espejo',header:'Link Espejo',sort:'string',template:'<a href="http://banners2.mcs-holding.com?Firma=#log#.png" target="#ArchivoBannerFirma#">[Mirror 2]</a>',width:100},
	{id:'EstatusBannerFirma',header:'<%=idiomaModulo.getProperty("EstatusBannerFirma")%>',sort:'string',width:100}]
}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'AREAS DEL GRUPO'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function nuevo(){$$('BotonGuardar').show();$$('ArchivoBannerFirma').disable();$$('BotonModificar').hide();$$('Forma').clear();$$('Confirmacion').clearAll();$$('Tabla').clearAll();$$('Mensaje').setValue(nada);$$('Vacio').show();inicial();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
function guardarDespues(){$$('Forma').clear();inicial();}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function modificarDespues(){}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/FirmasBannersServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdFirmas")%>',value: info.IdFirmas});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("ArchivoBannerFirma")%>',value: info.ArchivoBannerFirma});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("EstatusBannerFirma")%>',value: info.EstatusBannerFirma});
}
/* $$('ArchivoBannerFirma').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('ArchivoBannerFirma').setValue(nuevo); });
$$('EstatusBannerFirma').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('EstatusBannerFirma').setValue(nuevo); }); */
inicial();

var IdFirmas = $$("IdFirmas").getPopup().getList();IdFirmas.clearAll();IdFirmas.load("servlet/FirmasServlet?Accion=getFirmas&filter[value]=");

$$('ArchivoBannerFirma').disable();
$$('IdFirmas').attachEvent('onChange',function(){
	$$('ArchivoBannerFirma').define('formData',{Llave:$$('IdFirmas').getValue()});
	if ($$('IdFirmas').getValue() != ''){
				$$('ArchivoBannerFirma').enable();
		}
});
$$('ArchivoBannerFirma').attachEvent('onItemClick',function(){ 
		if ($$('IdFirmas').getValue() == ''){
				//'Antes de subir archivo seleccione el grupo'
				webix.alert({
		    	title: "Campo Vacio",
		    	text: "Antes de subir archivo seleccione el grupo",
		    	type:"alert-error"
			});
		} 
	});

</script>
<%=EncabezadoPie.getPie()%>
<% //AreasGrupo.jsp %>