<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/MexEntradasServlet';
var servlet='MexEntradasServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var IdReqProductos = 'IdReqProductos';
var Fecha = 'Fecha';
var Cantidad = 'Cantidad';
var Producto = 'Producto';
var Unidad = 'Unidad';
var Precio = 'Precio';
var Importe = 'Importe';
var Ubicacion = 'Ubicacion';

var forma={view:'form',id:'Forma',width:400,height:'100%',elements:[
	{view:'combo',id:'IdReqProductos',name:'IdReqProductos',value:'',placeholder:IdReqProductos,label:IdReqProductos,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true},
	{view:'datepicker',id:'Fecha',name:'Fecha',value: new Date(),placeholder:Fecha,label:Fecha,labelWidth:100,labelPosition:'left',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:true},
	{view:'text',id:'Cantidad',name:'Cantidad',value:'',placeholder:Cantidad,label:Cantidad,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Producto',name:'Producto',value:'',placeholder:Producto,label:Producto,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Unidad',name:'Unidad',value:'',placeholder:Unidad,label:Unidad,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Precio',name:'Precio',value:'',placeholder:Precio,label:Precio,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Importe',name:'Importe',value:'',placeholder:Importe,label:Importe,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Ubicacion',name:'Ubicacion',value:'',placeholder:Ubicacion,label:Ubicacion,labelWidth:100,labelPosition:'left',required:true},
{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
//{view:'iframe',id:'FrameSubforma',width:'80%',src:archivo},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'IdReqProductos',header:IdReqProductos,fillspace:true,sort:'string',minWidth:150},
	{id:'Fecha',header:Fecha,sort:'string',width:150},
	{id:'Cantidad',header:Cantidad,sort:'string',width:150},
	{id:'Producto',header:Producto,sort:'string',width:150},
	{id:'Unidad',header:Unidad,sort:'string',width:150},
	{id:'Precio',header:Precio,sort:'string',width:150},
	{id:'Importe',header:Importe,sort:'string',width:150},
	{id:'Ubicacion',header:Ubicacion,sort:'string',width:150}
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

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	IdReqProductos: $$('Tabla').getItem(id).IdReqProductos,
	Fecha: $$('Tabla').getItem(id).Fecha,
	Cantidad: $$('Tabla').getItem(id).Cantidad,
	Producto: $$('Tabla').getItem(id).Producto,
	Unidad: $$('Tabla').getItem(id).Unidad,
	Precio: $$('Tabla').getItem(id).Precio,
	Importe: $$('Tabla').getItem(id).Importe,
	Ubicacion: $$('Tabla').getItem(id).Ubicacion,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if(modoSubforma){setSubforma();}if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

var servletIdReqProductos='ReqProductosServlet.jsp';var listaIdReqProductos=$$('IdReqProductos').getPopup().getList();listaIdReqProductos.clearAll();listaIdReqProductos.load(servletIdReqProductos + '?Accion=getReqProductos&filter[value]=');

$$('Cantidad').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Cantidad').setValue(nuevo);});
$$('Producto').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Producto').setValue(nuevo);});
$$('Unidad').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Unidad').setValue(nuevo);});
$$('Precio').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Precio').setValue(nuevo);});
$$('Importe').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Importe').setValue(nuevo);});
$$('Ubicacion').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Ubicacion').setValue(nuevo);});

function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();ultimosCapturados(ultimos5);
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//MexEntradas.jsp
%>
