<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
var nada='';var valoresBusqueda='';var idGenerado='';var campo='IdRequerimientos';
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:campo,valor:'" + request.getParameter("IdGenerado") + "'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var IdRequerimientos = 'IdRequerimientos';
var Tipo = 'Tipo Cotizacion'.toUpperCase();
var Archivo = 'Archivo'.toUpperCase();
var Nombre = 'Nombre'.toUpperCase();

var forma={view:'form',id:'Forma',elements:[
	{view:'text',id:'IdRequerimientos',name:'IdRequerimientos',hidden:true},
	{cols:[
		{view:'combo',id:'Tipo',name:'Tipo',value:'',placeholder:Tipo,label:Tipo,labelWidth:90,width:110,labelPosition:'top',required:true,options:["PRINCIPAL","SOPORTE"],yCount:'3'},
		{view:'text',id:'Nombre',name:'Nombre',value:'',placeholder:Nombre,label:Nombre,labelWidth:80,labelPosition:'top',required:true},
		{rows:[
			{view:'uploader',id:'Archivo',name:'Archivo',value:'',link:'listaArchivo',placeholder:Archivo,label:Archivo,width:90,labelWidth:50,height:22,labelPosition:'left',required:true,upload:'MexSubirCotizacionesServlet.jsp',autosend:true,multiple:false},
			{borderless: false, view:"list", id:"listaArchivo", type:"uploader", autoheight:true, minHeight:20},
		]}
	]},
	
	{view:'toolbar',height:30,cols:[{view:'button',id:'BotonBorrar',value:etiquetaBotonBorrar,width:85,click:'borrar'},{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Tipo',header:Tipo,sort:'string',width:75},
	{id:'Archivo',header:Archivo,sort:'string',fillspace:true,sort:'string',template:'<a href="cotizacionesMex/#Archivo#" target="Documento#id#">#Nombre#</a>',minWidth:150}
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
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post('MexReqArchivosServlet.jsp',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	IdRequerimientos: $$('Tabla').getItem(id).IdRequerimientos,
	Tipo: $$('Tabla').getItem(id).Tipo,
	Archivo: $$('Tabla').getItem(id).Archivo,
	Nombre: $$('Tabla').getItem(id).Nombre,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

$$('Tipo').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Tipo').setValue(nuevo);});
$$('Nombre').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Nombre').setValue(nuevo);});

$$("Archivo").attachEvent("onUploadComplete", function(response){
    guardar();
});

inicial();buscar();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//MexReqArchivos.jsp
%>
