<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/EmbarquesPotencialesServlet';
var servlet='EmbarquesPotencialesServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var Fecha = 'Fecha';
var Cliente = 'Cliente';
var Telefono = 'Telefono';
var Correo = 'Correo';
var Origen = 'Origen';
var Destino = 'Destino';
var Kilos = 'Kilos';
var DescripcionProducto = 'Descripcion del Producto';

var forma={view:'form',id:'Forma',width:400,height:'100%',scroll:'y',elements:[
	{view:'datepicker',id:'Fecha',name:'Fecha',value: new Date(),placeholder:Fecha,label:Fecha,labelWidth:100,labelPosition:'left',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:true},
	{view:'textarea',id:'Cliente',name:'Cliente',value:'',placeholder:Cliente,label:Cliente,labelWidth:100,labelPosition:'left',height:100,required:true},
	{view:'text',id:'Telefono',name:'Telefono',value:'',placeholder:Telefono,label:Telefono,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Correo',name:'Correo',value:'',placeholder:Correo,label:Correo,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Origen',name:'Origen',value:'',placeholder:Origen,label:Origen,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Destino',name:'Destino',value:'',placeholder:Destino,label:Destino,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'Kilos',name:'Kilos',value:'',placeholder:Kilos,label:Kilos,labelWidth:100,labelPosition:'left',required:true},
	{view:'textarea',id:'DescripcionProducto',name:'DescripcionProducto',value:'',placeholder:DescripcionProducto,label:DescripcionProducto,labelWidth:100,labelPosition:'left',height:100,required:true},
{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
//{view:'iframe',id:'FrameSubforma',width:'80%',src:archivo},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Fecha',header:Fecha,fillspace:true,sort:'string',minWidth:150},
	{id:'Cliente',header:Cliente,sort:'string',width:150},
	{id:'Telefono',header:Telefono,sort:'string',width:150},
	{id:'Correo',header:Correo,sort:'string',width:150},
	{id:'Origen',header:Origen,sort:'string',width:150},
	{id:'Destino',header:Destino,sort:'string',width:150},
	{id:'Kilos',header:Kilos,sort:'string',width:150},
	{id:'DescripcionProducto',header:DescripcionProducto,sort:'string',width:150}
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
	Fecha: $$('Tabla').getItem(id).Fecha,
	Cliente: $$('Tabla').getItem(id).Cliente,
	Telefono: $$('Tabla').getItem(id).Telefono,
	Correo: $$('Tabla').getItem(id).Correo,
	Origen: $$('Tabla').getItem(id).Origen,
	Destino: $$('Tabla').getItem(id).Destino,
	Kilos: $$('Tabla').getItem(id).Kilos,
	DescripcionProducto: $$('Tabla').getItem(id).DescripcionProducto,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if(modoSubforma){setSubforma();}if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});


$$('Cliente').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Cliente').setValue(nuevo);});
$$('Telefono').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Telefono').setValue(nuevo);});
$$('Correo').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Correo').setValue(nuevo);});
$$('Origen').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Origen').setValue(nuevo);});
$$('Destino').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Destino').setValue(nuevo);});
$$('Kilos').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Kilos').setValue(nuevo);});
$$('DescripcionProducto').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('DescripcionProducto').setValue(nuevo);});

function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();ultimosCapturados(ultimos5);

$$('Fecha').disable();

</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//EmbarquesPotenciales.jsp
%>