<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
//falta crear su modulo y ponerle el numero que le corresponde
String moduloIdioma = "366";
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

var IdEmpleados = 'INDIQUE EL EMPLEADO OCS';
var NombreCompleto = 'NOMBRE COMPLETO';
var Puesto = 'PUESTO';
var IMSS = 'IMSS';
var CURP = 'CURP';
var Antiguedad = 'ANTIGÜEDAD';
var FechaEmision = 'FECHA DE EMISIÓN';
var FechaVigencia = 'VÁLIDA HASTA';
var Imagen = 'IMAGEN';

var forma={view:'form',id:'Forma',width:600,scroll:'y',height:'100%',enctype:"multipart/form-data",elements:[
	{view:'combo',id:'IdEmpleados',name:'IdEmpleados',value:'',placeholder:IdEmpleados,label:IdEmpleados,required:false,options:[],yCount:'3'},
	{view:'text',id:'NombreCompleto',name:'NombreCompleto',value:'',placeholder:NombreCompleto,label:NombreCompleto,required:true},
	{view:'text',id:'Puesto',name:'Puesto',value:'',placeholder:Puesto,label:Puesto,required:true},
	{view:'text',id:'IMSS',name:'IMSS',value:'',placeholder:IMSS,label:IMSS,attributes:{maxlength:11},required:true},
	{view:'text',id:'CURP',name:'CURP',value:'',placeholder:CURP,label:CURP,attributes:{maxlength:18},required:true},
	{view:'text',id:'Antiguedad',name:'Antiguedad',value:'',placeholder:Antiguedad,label:Antiguedad,attributes:{maxlength:4},required:true},
	{view:'datepicker',date: new Date(),stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),id:'FechaEmision',name: 'FechaEmision',placeholder:FechaEmision,label:FechaEmision,timepicker:true,required:false},
	{view:'datepicker',date: new Date(),stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),id:'FechaVigencia',name: 'FechaVigencia',label: '',timepicker:true,hidden:true,required:false},

	{view:'uploader',id:'Imagen',name:'Archivo',value:'',link:'mylist',placeholder:Imagen,label:Imagen,upload:'servlet/SubirCredencialesServlet',autosend:true,multiple:false},
	{borderless: true, view:"list", id:"mylist", type:"uploader", autoheight:true, minHeight: 50},
	{view:'combo',id:'IdImagenAdelante',name:'IdImagenAdelante',value:'',placeholder:'<%=idiomaModulo.getProperty("IdImagenAdelante") %>',label:'<%=idiomaModulo.getProperty("IdImagenAdelante") %>',options:[],yCount:'3',hidden:true,required:true,labelWidth:150},
	{view:'combo',id:'IdImagenAtras',name:'IdImagenAtras',value:'',placeholder:'<%=idiomaModulo.getProperty("IdImagenAtras") %>',label:'<%=idiomaModulo.getProperty("IdImagenAtras") %>',options:[],yCount:'3',hidden:true,required:true,labelWidth:150},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{},{view:'button',value:'GENERAR CREDENCIAL',width:135,click:'credencial'},{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'NombreCompleto',header:NombreCompleto,fillspace:true,sort:'string',adjust:"all",minWidth:250},
	{id:'Puesto',header:Puesto,sort:'string',adjust:"all",minWidth:200},
	{id:'IMSS',header:IMSS,sort:'string',adjust:"all",minWidth:100},
	{id:'CURP',header:CURP,sort:'string',adjust:"all",minWidth:150},
	{id:'Antiguedad',header:Antiguedad,sort:'string',adjust:"all",minWidth:90},
	{id:'FechaEmision',header:FechaEmision,sort:'date',adjust:"all",minWidth:100},
	{id:'FechaVigencia',header:FechaVigencia,sort:'date',adjust:"all",minWidth:100},
	{id:'Imagen',header:Imagen,sort:'string',adjust:"all",minWidth:100},
	//{id:'IdImagenAdelante',header:IdImagenAdelante,sort:'string',adjust:"all",minWidth:100},
	//{id:'IdImagenAdelante',header:IdImagenAtras,sort:'string',adjust:"all",minWidth:100}	
]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'FORMATOS'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('mylist').clearAll();$$('Confirmacion').clearAll(); $$('Tabla').clearAll();$$('Mensaje').setValue(nada); $$('Vacio').show();}
function guardar(){$$('Confirmacion').clearAll();/* $$('FechaEmision').setValue('2002-01-05'); */$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');$$('mylist').clearAll();}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('CredencialesOcsServlet.jsp',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:NombreCompleto,value: info.NombreCompleto});
	$$('Confirmacion').add({campo:Puesto,value: info.Puesto});
	$$('Confirmacion').add({campo:IMSS,value: info.IMSS});
	$$('Confirmacion').add({campo:CURP,value: info.CURP});
	$$('Confirmacion').add({campo:Antiguedad,value: info.Antiguedad});
	$$('Confirmacion').add({campo:FechaEmision,value: info.FechaEmision});
	$$('Confirmacion').add({campo:FechaVigencia,value: info.FechaVigencia});
	$$('Confirmacion').add({campo:Imagen,value: info.Imagen});
	<%-- $$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdImagenAdelante")%>',value: info.IdImagenAdelante});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdImagenAtras")%>',value: info.IdImagenAtras}); --%>
	$$('mylist').clearAll();
}
//$$('NombreCompleto').disable();
//$$('Puesto').disable();
//$$('Empresa').disable();
//$$('Estacion').disable();
//$$('IMSS').disable();
//$$('CURP').disable();
//$$('Division').setValue('');
//$$('Nivel').setValue('');
//$$('Antiguedad').setValue('2002-01-05');
//$$('FechaEmision').setValue('2002-01-05');


function credencial(){ 
	document.location = 'GenerarCredencialOcs.jsp?Tabla=CredencialesOcs&Id=' + $$('Tabla').getSelectedId();
}
var IdImagenAdelante = $$("IdImagenAdelante").getPopup().getList();IdImagenAdelante.clearAll();IdImagenAdelante.load("servlet/TiposCredencialesServlet?Accion=getTiposCredenciales&filter[value]=");
var IdImagenAtras = $$("IdImagenAtras").getPopup().getList();IdImagenAtras.clearAll();IdImagenAtras.load("servlet/TiposCredencialesServlet?Accion=getTiposCredenciales&filter[value]=");
$$('NombreCompleto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NombreCompleto').setValue(nuevo); });
$$('Puesto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Puesto').setValue(nuevo); });
$$('IMSS').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IMSS').setValue(nuevo); });
$$('CURP').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('CURP').setValue(nuevo); });

$$('FechaEmision').attachEvent('onChange',function(nuevo, anterior){
	
	if($$('FechaEmision').getValue() == null){}else{
		var Emision = $$('FechaEmision').getValue();
		Emision=Emision.replace('-',' ');
		Emision=Emision.replace('-',' ');
		Emision=Emision.split(" ",3);
		//DEBUG alert(Emision);
		
		var Vigencia = webix.Date.add(Emision,365,"day",true);
		
		$$('FechaVigencia').setValue(Vigencia);
		//DEBUG alert($$('FechaVigencia').getValue());
	}
});

var listaIdEmpleados = $$("IdEmpleados").getPopup().getList();listaIdEmpleados.clearAll();listaIdEmpleados.load("servlet/EmpleadosServlet?Accion=getEmpleadosDatosOcs&filter[value]=");

$$('IdEmpleados').attachEvent('onChange',function(nuevo,anterior){ if(nuevo !== '') { 
	var objeto = $$('IdEmpleados').getPopup().getList().getItem(nuevo);
	$$('NombreCompleto').setValue (objeto.NombreCompleto);	
	$$('Puesto').setValue (objeto.Puesto);
	$$('IMSS').setValue (objeto.NSS);
	$$('CURP').setValue (objeto.CURP);
	$$('Antiguedad').setValue (objeto.FechaIngreso);
}});

$$('IdImagenAdelante').setValue ('0');
$$('IdImagenAtras').setValue ('0');

</script>
<%=EncabezadoPie.getPie()%>