<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
var nada='';var valoresBusqueda='';var idGenerado='';var campo='IdProveedores';
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:campo,valor:'" + request.getParameter("IdGenerado") + "'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var IdProveedores = 'IdProveedores';
var Documento = 'Documento';
var Archivo = 'Archivo';

var forma={view:'form',id:'Forma',elements:[
	{view:'combo',id:'IdProveedores',name:'IdProveedores',value:'',hidden:true},
	{cols:[
		{view:'text',id:'Documento',name:'Documento',value:'',placeholder:Documento,label:Documento,labelWidth:70,labelPosition:'left',required:true},
		{cols:[
			{view:'uploader',id:'Archivo',name:'Archivo',value:'',link:'listaArchivo',placeholder:Archivo,label:Archivo,labelWidth:100,labelPosition:'left',required:true,upload:'MexProveedoresSubirDoc.jsp',autosend:true,multiple:false},
			{borderless: false, view:"list", id:"listaArchivo", type:"uploader", autoheight:true, minHeight: 20}
		]},
	]},
{view:'toolbar', cols:[{view:'button',id:'BotonBorrar',value:'BORRAR ARCHIVO',width:85,click:'borrar'},{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:'GUARDAR ARCHIVO',width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:'MODIFICAR ARCHIVO',width:85,click:'modificar',hidden:true}]},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Documento',header:Documento,sort:'string',width:150},
	{id:'Archivo',header:Archivo,sort:'string',fillspace:true,sort:'string',minWidth:150,template:'<a href="proveedoresMex/#Archivo#" target="#Archivo#">#Archivo#</a>'}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'accordion',type:'wide',multi:true,height:'100%',rows:[{body:forma},{body:tabla}]}]});
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
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post('MexProveedoresDocServlet.jsp',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	Documento: $$('Tabla').getItem(id).Documento,
	Archivo: $$('Tabla').getItem(id).Archivo,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

$$('Documento').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Documento').setValue(nuevo);});

inicial();buscar();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//MexProveedoresDoc.jsp
%>