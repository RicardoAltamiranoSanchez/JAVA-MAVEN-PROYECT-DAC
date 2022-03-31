<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezadoWebix503()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/DocumentosGeneralServlet';
var servlet='DocumentosDHServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var Modulo = 'Publicado en el Módulo';
var Codigo = 'Código del Documento';
var Nombre = 'Nombre del Documento';
var NumRevision = 'N° de Revisión';
var FechaRevision = 'Fecha de Revisión';
var Archivo = 'Adjunte Archivo descargable';
var IdsUsuariosLectura = 'Empleados que pueden consultarlo';


var forma={view:'form',id:'Forma',width:700,height:'100%',scroll:true,elements:[
	//{view:'text',id:'Archivo',name:'Archivo',value:'',placeholder:Archivo,label:Archivo,labelWidth:100,labelPosition:'left',required:true},
	
	{view:'combo',id:'Modulo',name:'Modulo',value:'',placeholder:Modulo,label:Modulo,labelPosition:'top',required:true,yCount:'4',options:[{id:'GENERALES',value:'GENERALES'},{id:'POLITICAS',value:'POLITICAS'},{id:'PROCEDIMIENTOS',value:'PROCEDIMIENTOS'},{id:'FORMATOS',value:'FORMATOS'}]},
	{view:'text',id:'Codigo',name:'Codigo',value:'',placeholder:Codigo,label:Codigo,labelWidth:160,labelPosition:'left',required:true},
	{view:'text',id:'Nombre',name:'Nombre',value:'',placeholder:Nombre,label:Nombre,labelWidth:80,labelPosition:'top',required:true},
	{cols:[
		{view:'text',id:'NumRevision',name:'NumRevision',value:'',placeholder:NumRevision,label:NumRevision,labelWidth:80,labelPosition:'top',required:true},
		{view:'datepicker',id:'FechaRevision',name:'FechaRevision',value: new Date(),placeholder:FechaRevision,label:FechaRevision,labelWidth:80,labelPosition:'top',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:true},
	]},
		
	{view:'uploader',id:'Archivo',name:'Archivo',value:'',link:'mylistArchivo',placeholder:Archivo,label:Archivo,upload:'SubirDocumentosDHServlet.jsp',autosend:true,required:true,multiple:false},
	{borderless: true, view:"list", id:"mylistArchivo", type:"uploader", autoheight:true, minHeight: 50},
	{view:'combo',id:'IdAreasLaborales',name:'IdAreasLaborales',value:'',placeholder:'Filtrar por Área Laboral',label:'Filtrar por Área Laboral',labelPosition:'top',required:false,options:[],yCount:'3'},
	
	 {
		view:"dbllist", 
		id:'IdsUsuariosLectura',name:'IdsUsuariosLectura',
	    /* list:{ autoheight: true, scroll:true}, */
	    list:{ height: 145, scroll:true},
	    labelLeft:IdsUsuariosLectura,
	    labelRight:"Empleados Seleccionados",
	    data:[
	    ],
	    required:true
	}, 
	
	 //{view:'text',id:'IdsUsuariosLectura',name:'IdsUsuariosLectura',value:'',placeholder:IdsUsuariosLectura,label:IdsUsuariosLectura,labelWidth:80,labelPosition:'left',required:true}, 
	
	
	
{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
//{view:'iframe',id:'FrameSubforma',width:'80%',src:archivo},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	//{id:'Archivo',header:Archivo,fillspace:true,sort:'string',minWidth:150},
	{id:'Modulo',header:Modulo,sort:'string',width:140},
	{id:'Codigo',header:Codigo,sort:'string',width:140},
	{id:'Nombre',header:Nombre,sort:'string',width:250},
	{id:'NumRevision',header: NumRevision,sort:'string',width:100},
	{id:'FechaRevision',header:FechaRevision,sort:'string',width:120},
	{id:'Archivo',header:'Archivo',fillspace:true,sort:'string',minWidth:150,template:'<a href="documentosDH/#Archivo#" target="#Archivo#">#Archivo#</a>'},
	{id:'IdsUsuariosLectura',header:IdsUsuariosLectura,sort:'string',width:250}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'toolbar',cols:[{},{view:'button',id:'BotonBorrar',value:etiquetaBotonBorrar,width:85,click:'borrar'},{view:'text',id:'CampoBuscar',name:'CampoBuscar',value:'',placeholder:etiquetaBotonBuscar,width:300},{view:'button',id:'BotonBuscar',value:etiquetaBotonBuscar,width:85,click:'buscar'}]},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{body:tabla},{header:' ',body:forma}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){$$('FrameSubforma').hide();}}
function ultimosCapturados(mensaje){valoresBusqueda={Accion:'Buscar',Campo:''};enviar(mensaje,'Buscar');}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('BotonBorrar').show();$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function guardar(){$$('Forma').setValues({Accion:'Guardar'},true);if($$('Forma').validate()){enviar(datosGuardados,'Guardar');}}
function guardarFinal(){if(modoSubforma){$$('BotonGuardar').hide();ultimosCapturados(datosGuardados);setSubforma();}else{$$('Forma').clear();inicial();ultimosCapturados(datosGuardados);}}
function borrar(){webix.confirm({title:tituloEliminar,ok:si,cancel:no,type:'confirm-error',text:seguroQueDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(datosEliminados,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();enviar(datosEliminados,'Buscar');$$('BotonGuardar').show();$$('BotonModificar').hide();if(modoSubforma){$$('FrameSubforma').hide();}}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(datosModificados,'Modificar');}}
function modificarFinal(){if(modoSubforma){enviar(datosModificados,'Buscar');}else{$$('Forma').clear();enviar(datosModificados,'Buscar');$$('BotonGuardar').show();$$('BotonModificar').hide();}}
function buscar(){if($$('CampoBuscar').getValue()==''){$$('CampoBuscar').setValue('%');}valoresBusqueda={Accion:'Buscar',Campo:$$('CampoBuscar').getValue()};enviar(resultadosEncontrados,'Buscar');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post(servlet,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}

var idAreasLaborales=$$('IdAreasLaborales').getValue();

var IdAreasLaborales = $$("IdAreasLaborales").getPopup().getList();IdAreasLaborales.clearAll();IdAreasLaborales.load("AreasLaboralesServlet.jsp?Accion=getAreasLaborales&filter[value]=");
function cargaEmpleados(){$$('IdsUsuariosLectura').load('servlet/EmpleadosServlet?Accion=getUsuariosPorAreasLaborales&filter[value]='+idAreasLaborales);}

$$('IdAreasLaborales').attachEvent('onChange',function(){
	idAreasLaborales=$$('IdAreasLaborales').getValue();
	$$('IdsUsuariosLectura').$$("left").clearAll();
	cargaEmpleados();
});

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	Modulo: $$('Tabla').getItem(id).Modulo,
	Codigo: $$('Tabla').getItem(id).Codigo,
	Nombre: $$('Tabla').getItem(id).Nombre,
	NumRevision: $$('Tabla').getItem(id).NumRevision,
	FechaRevision: $$('Tabla').getItem(id).FechaRevision,
	Archivo: $$('Tabla').getItem(id).Archivo,
	IdsUsuariosLectura: $$('Tabla').getItem(id).IdsUsuariosLectura,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if(modoSubforma){setSubforma();}if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});



//$$('Archivo').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Archivo').setValue(nuevo);});
//$$('IdsUsuariosLectura').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('IdsUsuariosLectura').setValue(nuevo);});
//$$('Fecha').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Fecha').setValue(nuevo);});


function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();cargaEmpleados();ultimosCapturados(ultimos5);
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//DocumentosGeneral.jsp
%>