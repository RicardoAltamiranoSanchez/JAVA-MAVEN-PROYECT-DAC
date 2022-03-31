<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
var nada='';var valoresBusqueda='';var idGenerado='';var campo='IdRequerimientos';
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:campo,valor:'" + request.getParameter("IdGenerado") + "'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var IdRequerimientos = 'IdRequerimientos';
var Cantidad = 'Cantidad'.toUpperCase();
var Producto = 'Producto'.toUpperCase();
var Unidad = 'U.Medida'.toUpperCase();
var Precio = 'Precio s/iva'.toUpperCase();
var Estatus = 'Estatus'.toUpperCase();
var IdOrdenCompra = 'IdOrdenCompra';
var Iva = 'IVA';

var forma={view:'form',id:'Forma',elements:[
	{view:'text',id:'IdRequerimientos',name:'IdRequerimientos',hidden:true},
	{cols:[
		{view:'text',id:'Cantidad',name:'Cantidad',value:'',placeholder:Cantidad,label:Cantidad,width:70,labelPosition:'top',required:true},
		{view:'text',id:'Producto',name:'Producto',value:'',placeholder:Producto,label:Producto,suggest:'MexProductosServlet.jsp?Accion=getMexProductos',labelWidth:100,labelPosition:'top',required:true},
		{view:'text',id:'Unidad',name:'Unidad',value:'',placeholder:Unidad,label:Unidad,width:75,labelPosition:'top',required:true},
		{view:'combo',id:'Iva',name:'Iva',value:'',placeholder:Iva,label:Iva,labelWidth:50,width:50,labelPosition:'top',required:true,options:['16','0'],yCount:'3'},
		{view:'text',id:'Precio',name:'Precio',value:'',placeholder:Precio,label:Precio,width:80,labelPosition:'top',required:true},
	]},
	{view:'text',id:'Estatus',name:'Estatus',hidden:true},
	{view:'text',id:'IdOrdenCompra',name:'IdOrdenCompra',hidden:true},
{view:'toolbar',height:30,cols:[{view:'button',id:'BotonBorrar',value:etiquetaBotonBorrar,width:85,click:'borrar'},{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Cantidad',header:Cantidad,sort:'string',width:50},
	{id:'Producto',header:Producto,sort:'string',fillspace:true,sort:'string',minWidth:150},
	{id:'Unidad',header:Unidad,sort:'string',width:75},
	{id:'Iva',header:Iva,sort:'string',width:50},
	{id:'Precio',header:Precio,sort:'string',width:75}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'wide',rows:[{view:'accordion',type:'wide',multi:true,height:'100%',rows:[{body:forma},{body:tabla}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function ultimosCapturados(mensaje){valoresBusqueda={Accion:'Buscar',Campo:''};enviar(mensaje,'Buscar');}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('BotonBorrar').show();$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function guardar(){$$('Forma').setValues({Accion:'Guardar'},true);if($$('Forma').validate()){enviar(datosGuardados,'Guardar');}}
function guardarFinal(){$$('Forma').clear();inicial();buscar();}
function borrar(){webix.confirm({title:tituloEliminar,ok:si,cancel:no,type:'confirm-error',text:seguroQueDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(datosEliminados,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();$$('BotonGuardar').show();$$('BotonModificar').hide();inicial();buscar();}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(datosModificados,'Modificar');}}
function modificarFinal(){$$('Forma').clear();$$('BotonGuardar').show();$$('BotonModificar').hide();inicial();buscar();}
function buscar(){valoresBusqueda={Accion:'Buscar',Campo:$$(campo).getValue()};enviar(resultadosEncontrados,'Buscar');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post('MexReqProductosServlet.jsp',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	IdRequerimientos: $$('Tabla').getItem(id).IdRequerimientos,
	Cantidad: $$('Tabla').getItem(id).Cantidad,
	Producto: $$('Tabla').getItem(id).Producto,
	Unidad: $$('Tabla').getItem(id).Unidad,
	Precio: $$('Tabla').getItem(id).Precio,
	Estatus: $$('Tabla').getItem(id).Estatus,
	IdOrdenCompra: $$('Tabla').getItem(id).IdOrdenCompra,
	Iva: $$('Tabla').getItem(id).Iva,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

$$('Cantidad').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Cantidad').setValue(nuevo);});
$$('Producto').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Producto').setValue(nuevo);});
$$('Unidad').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Unidad').setValue(nuevo);});
$$('Precio').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Precio').setValue(nuevo);});

inicial();buscar();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//MexReqProductos.jsp
%>
