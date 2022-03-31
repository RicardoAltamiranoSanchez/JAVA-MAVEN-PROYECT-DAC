<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/1.js"></script>
<script>
//var servlet='servlet/MexRegistroFilaServlet';
var servlet='MexRegistroFilaServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var Gafete = 'Gafete';
var FechaHora = 'Fecha Hora';

var forma={view:'form',id:'Forma',width:400,elements:[
	{view:'text',id:'Gafete',name:'Gafete',value:'',placeholder:Gafete,label:Gafete,labelWidth:100,labelPosition:'left',required:true},
	{view:'datepicker',id:'FechaHora',name:'FechaHora',value: new Date(),placeholder:FechaHora,label:FechaHora,labelWidth:100,labelPosition:'left',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),hidden:true},
{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:'REGISTRAR',width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
//{view:'iframe',id:'FrameSubforma',width:'80%',src:archivo},
{}
]};
var tabla={id:'PanelTabla',rows:[{view:'datatable',id:'Tabla',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Gafete',header:Gafete,fillspace:true,sort:'string',minWidth:150},
	{id:'FechaHora',header:FechaHora,sort:'string',width:150}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'toolbar',cols:[{view:'label',label:'Registro Fila'},{},{view:'button',id:'BotonBorrar',value:etiquetaBotonBorrar,width:85,click:'borrar',hidden:true},{view:'text',id:'CampoBuscar',name:'CampoBuscar',value:'',placeholder:etiquetaBotonBuscar,width:300,hidden:true},{view:'button',id:'BotonBuscar',value:etiquetaBotonBuscar,width:85,click:'buscar',hidden:true}]},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{body:tabla},{header:' ',body:forma}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){$$('FrameSubforma').hide();}}
function ultimosCapturados(mensaje){valoresBusqueda={Accion:'Buscar',Campo:''};enviar(mensaje,'Buscar');}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function guardar(){$$('Forma').setValues({Accion:'Guardar'},true);if($$('Forma').validate()){enviar(datosGuardados,'Guardar');}}
function guardarFinal(){if(modoSubforma){$$('BotonGuardar').hide();ultimosCapturados(datosGuardados);setSubforma();}else{$$('Forma').clear();inicial();ultimosCapturados(datosGuardados);}}
function borrar(){webix.confirm({title:tituloEliminar,ok:si,cancel:no,type:'confirm-error',text:seguroQueDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(datosEliminados,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();enviar(datosEliminados,'Buscar');$$('BotonGuardar').show();$$('BotonModificar').hide();if(modoSubforma){$$('FrameSubforma').hide();}}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(datosModificados,'Modificar');}}
function modificarFinal(){if(modoSubforma){enviar(datosModificados,'Buscar');}else{$$('Forma').clear();enviar(datosModificados,'Buscar');$$('BotonGuardar').show();$$('BotonModificar').hide();}}
function buscar(){if($$('CampoBuscar').getValue()==''){$$('CampoBuscar').setValue('%');}valoresBusqueda={Accion:'Buscar',Campo:$$('CampoBuscar').getValue()};enviar(resultadosEncontrados,'Buscar');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post(servlet,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());}}}});}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	Gafete: $$('Tabla').getItem(id).Gafete,
	FechaHora: $$('Tabla').getItem(id).FechaHora,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if(modoSubforma){setSubforma();}if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

$$('Gafete').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Gafete').setValue(nuevo);});


function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();ultimosCapturados(ultimos5);
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//MexRegistroFila.jsp
%>
