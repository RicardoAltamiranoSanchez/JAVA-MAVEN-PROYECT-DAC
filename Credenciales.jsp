<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
//falta crear su modulo y ponerle el numero que le corresponde
String moduloIdioma = "131";
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

var CorreoElectronico = 'CORREO ELECTRONICO';
var Telefono = 'TELEFONO';
var Domicilio = 'DOMICILIO';
var PaginaWeb = 'PAGINA WEB';

var forma={view:'form',id:'Forma',width:600,scroll:'y',height:'100%',enctype:"multipart/form-data",elements:[
	{view:'combo',id:'IdEmpleados',name:'IdEmpleados',value:'',placeholder:'<%=idiomaModulo.getProperty("IdEmpleados") %>',label:'<%=idiomaModulo.getProperty("IdEmpleados") %>',required:false,options:[],yCount:'3'},
	{view:'text',id:'NombreCompleto',name:'NombreCompleto',value:'',placeholder:'<%=idiomaModulo.getProperty("NombreCompleto")%>',label:'<%=idiomaModulo.getProperty("NombreCompleto")%>',required:true},
	{cols:[
		{view:'text',id:'CorreoElectronico',name:'CorreoElectronico',value:'',placeholder:CorreoElectronico,label:CorreoElectronico,required:true},
		{view:'text',id:'Telefono',name:'Telefono',value:'',placeholder:Telefono,label:Telefono,required:true},
	]},
	{view:'text',id:'Domicilio',name:'Domicilio',value:'',placeholder:Domicilio,label:Domicilio,required:true},
	{view:'text',id:'PaginaWeb',name:'PaginaWeb',value:'',placeholder:PaginaWeb,label:PaginaWeb,required:true},
	{view:'text',id:'Puesto',name:'Puesto',value:'',placeholder:'<%=idiomaModulo.getProperty("Puesto")%>',label:'<%=idiomaModulo.getProperty("Puesto")%>',required:true},
	{view:'text',id:'Empresa',name:'Empresa',value:'',placeholder:'<%=idiomaModulo.getProperty("Empresa")%>',label:'<%=idiomaModulo.getProperty("Empresa")%>',required:true},
	{view:'combo',id:'Estacion',name:'Estacion',value:'',placeholder:'<%=idiomaModulo.getProperty("Estacion") %>',label:'<%=idiomaModulo.getProperty("Estacion")%>',required:true,yCount:'5',options:["GDL","MEX","TLC","HMO","MXL","CUL","MTY","CUN","MID"]},
	{view:'text',id:'IMSS',name:'IMSS',value:'',placeholder:'<%=idiomaModulo.getProperty("IMSS")%>',label:'<%=idiomaModulo.getProperty("IMSS")%>',required:true},
	{view:'text',id:'CURP',name:'CURP',value:'',placeholder:'<%=idiomaModulo.getProperty("CURP")%>',label:'<%=idiomaModulo.getProperty("CURP")%>',required:true},
	{view:'datepicker',date: new Date(),stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),id:'Antiguedad',name: 'Antiguedad',label: '<%=idiomaModulo.getProperty("Antiguedad")%>',timepicker:true,required:true},
	{view:'combo',id:'Division',name:'Division',value:'',placeholder:'<%=idiomaModulo.getProperty("Division") %>',label:'<%=idiomaModulo.getProperty("Division")%>',required:false,hidden:true,yCount:'5',options:["DLV","DAC","MWS","JMF","NET","MCS","MAM","SEG","OLG","AE","ACH","RGS","HS","TH"]},
	{view:'combo',id:'Nivel',name:'Nivel',value:'',placeholder:'<%=idiomaModulo.getProperty("Nivel") %>',label:'<%=idiomaModulo.getProperty("Nivel")%>',yCount:'5',hidden:true,options:["BLANCO","AMARILLO","VERDE","AZUL"]},
	{cols:[
		{view:'datepicker',date: new Date(),stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),id:'FechaEmision',name: 'FechaEmision',label: '<%=idiomaModulo.getProperty("FechaEmision")%>',timepicker:true,hidden:true,required:false}, 
		{},
		{view:'datepicker',date: new Date(),stringResult:true,format:webix.Date.dateToStr("%Y-%m-%d"),id:'FechaVigencia',name: 'FechaVigencia',label: '<%=idiomaModulo.getProperty("FechaVigencia")%>',timepicker:true,required:true}
	]},
	{view:'uploader',id:'Imagen',name:'Archivo',value:'',link:'mylist',placeholder:'<%=idiomaModulo.getProperty("Imagen")%>',label:'<%=idiomaModulo.getProperty("Imagen")%>',upload:'servlet/SubirCredencialesServlet',autosend:true,multiple:false},
	{borderless: true, view:"list", id:"mylist", type:"uploader", autoheight:true, minHeight: 50},
	{view:'combo',id:'IdImagenAdelante',name:'IdImagenAdelante',value:'',placeholder:'<%=idiomaModulo.getProperty("IdImagenAdelante") %>',label:'<%=idiomaModulo.getProperty("IdImagenAdelante") %>',options:[],yCount:'3',required:true,labelWidth:150},
	{view:'combo',id:'IdImagenAtras',name:'IdImagenAtras',value:'',placeholder:'<%=idiomaModulo.getProperty("IdImagenAtras") %>',label:'<%=idiomaModulo.getProperty("IdImagenAtras") %>',options:[],yCount:'3',required:true,labelWidth:150},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:'EXCEL',width:85,click:'excel'},{view:'button',value:etiquetaCredencial,width:135,click:'credencial'},{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'NombreCompleto',header:'<%=idiomaModulo.getProperty("NombreCompleto")%>',fillspace:true,sort:'string',adjust:"all",minWidth:250},
	{id:'CorreoElectronico',header:CorreoElectronico,fillspace:true,sort:'string',adjust:"all",minWidth:250},
	{id:'Telefono',header:Telefono,fillspace:true,sort:'string',adjust:"all",minWidth:100},
	{id:'Domicilio',header:Domicilio,fillspace:true,sort:'string',adjust:"all",minWidth:250},
	{id:'PaginaWeb',header:PaginaWeb,fillspace:true,sort:'string',adjust:"all",minWidth:250},
	{id:'Puesto',header:'<%=idiomaModulo.getProperty("Puesto")%>',sort:'string',adjust:"all",minWidth:200},
	{id:'Empresa',header:'<%=idiomaModulo.getProperty("Empresa")%>',sort:'string',adjust:"all",minWidth:80},
	{id:'Estacion',header:'<%=idiomaModulo.getProperty("Estacion")%>',sort:'string',adjust:"all",minWidth:80},
	{id:'IMSS',header:'<%=idiomaModulo.getProperty("IMSS")%>',sort:'string',adjust:"all",minWidth:100},
	{id:'CURP',header:'<%=idiomaModulo.getProperty("CURP")%>',sort:'string',adjust:"all",minWidth:150},
	{id:'Antiguedad',header:'<%=idiomaModulo.getProperty("Antiguedad")%>',sort:'string',adjust:"all",minWidth:90},
	<%-- YA NO ES NECESARIO {id:'Division',header:'<%=idiomaModulo.getProperty("Division")%>',sort:'string',adjust:"all",minWidth:70}, --%>
	<%-- YA NO ES NECESARIO {id:'Nivel',header:'<%=idiomaModulo.getProperty("Nivel")%>',sort:'string',adjust:"all",minWidth:80}, --%>
	<%-- YA NO ES NECESARIO {id:'FechaEmision',header:'<%=idiomaModulo.getProperty("FechaEmision")%>',sort:'date',adjust:"all",minWidth:100}, --%>
	{id:'FechaVigencia',header:'<%=idiomaModulo.getProperty("FechaVigencia")%>',sort:'date',adjust:"all",minWidth:100},
	{id:'Imagen',header:'<%=idiomaModulo.getProperty("Imagen")%>',sort:'string',adjust:"all",minWidth:100},
	{id:'IdImagenAdelante',header:'<%=idiomaModulo.getProperty("IdImagenAdelante")%>',sort:'string',adjust:"all",minWidth:100},
	{id:'IdImagenAdelante',header:'<%=idiomaModulo.getProperty("IdImagenAtras")%>',sort:'string',adjust:"all",minWidth:100}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'FORMATOS'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('mylist').clearAll();$$('Confirmacion').clearAll(); $$('Tabla').clearAll();$$('Mensaje').setValue(nada); $$('Vacio').show();}
function guardar(){$$('Confirmacion').clearAll();$$('FechaEmision').setValue('2002-01-05');$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');$$('mylist').clearAll();}
function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post('servlet/CredencialesServlet',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}else{if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}else{webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});}else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});}}else if(accion=='Borrar'){borrarDespues();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("NombreCompleto")%>',value: info.NombreCompleto});
	$$('Confirmacion').add({campo:CorreoElectronico,value: info.CorreoElectronico});
	$$('Confirmacion').add({campo:Telefono,value: info.Telefono});
	$$('Confirmacion').add({campo:Domicilio,value: info.Domicilio});
	$$('Confirmacion').add({campo:PaginaWeb,value: info.PaginaWeb});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Puesto")%>',value: info.Puesto});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Empresa")%>',value: info.Empresa});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Estacion")%>',value: info.Estacion});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IMSS")%>',value: info.IMSS});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("CURP")%>',value: info.CURP});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Antiguedad")%>',value: info.Antiguedad});
	<%-- YA NO ES NECESARIO $$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Division")%>',value: info.Division}); --%>
	<%-- YA NO ES NECESARIO $$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Nivel")%>',value: info.Nivel}); --%>
	<%-- YA NO ES NECESARIO $$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechaEmision")%>',value: info.FechaEmision}); --%>
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("FechaVigencia")%>',value: info.FechaVigencia});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("Imagen")%>',value: info.Imagen});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdImagenAdelante")%>',value: info.IdImagenAdelante});
	$$('Confirmacion').add({campo:'<%=idiomaModulo.getProperty("IdImagenAtras")%>',value: info.IdImagenAtras});
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


function excel(){
	
		document.location = 'CredencialesExcel.jsp?Accion=Guardar' +  
				'&NombreCompleto=' + $$('NombreCompleto').getValue() +
				'&CorreoElectronico=' + $$('CorreoElectronico').getValue() +
				'&Telefono=' + $$('Telefono').getValue() +
				'&Domicilio=' + $$('Domicilio').getValue() +
				'&PaginaWeb=' + $$('PaginaWeb').getValue() +
				'&Puesto=' + $$('Puesto').getValue() +
				'&Empresa=' + $$('Empresa').getValue() +
				'&Estacion=' + $$('Estacion').getValue() +
				'&IMSS=' + $$('IMSS').getValue() +
				'&CURP=' + $$('CURP').getValue() +
				'&Antiguedad=' + $$('Antiguedad').getValue() +
				'&FechaVigencia=' + $$('FechaVigencia').getValue();
}

function credencial(){ 
	document.location = 'servlet/GenerarCredencialServlet?Tabla=Credenciales&Id=' + $$('Tabla').getSelectedId();
}
var IdImagenAdelante = $$("IdImagenAdelante").getPopup().getList();IdImagenAdelante.clearAll();IdImagenAdelante.load("servlet/TiposCredencialesServlet?Accion=getTiposCredencialesDiv&filter[value]=");
var IdImagenAtras = $$("IdImagenAtras").getPopup().getList();IdImagenAtras.clearAll();IdImagenAtras.load("servlet/TiposCredencialesServlet?Accion=getTiposCredencialesDiv&filter[value]=");
$$('NombreCompleto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NombreCompleto').setValue(nuevo); });
$$('Puesto').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Puesto').setValue(nuevo); });
$$('Empresa').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Empresa').setValue(nuevo); });
$$('Estacion').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Estacion').setValue(nuevo); });
$$('IMSS').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IMSS').setValue(nuevo); });
$$('CURP').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('CURP').setValue(nuevo); });
$$('Division').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Division').setValue(nuevo); });
$$('Nivel').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Nivel').setValue(nuevo); });

var listaIdEmpleados = $$("IdEmpleados").getPopup().getList();listaIdEmpleados.clearAll();listaIdEmpleados.load("servlet/EmpleadosServlet?Accion=getEmpleadosDatosCorreo&filter[value]=");

$$('IdEmpleados').attachEvent('onChange',function(nuevo,anterior){ if(nuevo !== '') { 
	var objeto = $$('IdEmpleados').getPopup().getList().getItem(nuevo);
	$$('NombreCompleto').setValue (objeto.NombreCompleto);
	$$('CorreoElectronico').setValue (objeto.CorreoElectronico);
	$$('Puesto').setValue (objeto.Puesto);
	$$('Empresa').setValue (objeto.Division);
	$$('Estacion').setValue (objeto.Estacion);
	$$('IMSS').setValue (objeto.NSS);
	$$('CURP').setValue (objeto.CURP);
	$$('Antiguedad').setValue (objeto.FechaIngreso);
}});

</script>
<%=EncabezadoPie.getPie()%>