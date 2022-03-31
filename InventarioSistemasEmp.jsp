<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
var nada='';var valoresBusqueda='';var idGenerado='';var campo='IdInventarioSistemas';
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:campo,valor:'" + request.getParameter("IdGenerado") + "'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var IdInventarioSistemas = 'IdInventarioSistemas';
var Fecha = 'Fecha';
var IdEmpleado = 'Empleado';
var IdResponsable = 'Responsable';
var Localizacion = 'Localizacion';

var forma={view:'form',id:'Forma',elements:[
	{view:'text',id:'IdInventarioSistemas',name:'IdInventarioSistemas',hidden:true},
	{view:'datepicker',id:'Fecha',name:'Fecha',value: new Date(),placeholder:Fecha,label:Fecha,labelWidth:100,labelPosition:'left',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:true},
	{view:'combo',id:'IdEmpleado',name:'IdEmpleado',value:'',placeholder:IdEmpleado,label:IdEmpleado,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true},
	{view:'combo',id:'IdResponsable',name:'IdResponsable',value:'',placeholder:IdResponsable,label:IdResponsable,labelWidth:100,labelPosition:'left',options:[],yCount:'3'},
	{view:'combo',id:'Localizacion',name:'Localizacion',value:'',placeholder:Localizacion,label:Localizacion,labelWidth:100,labelPosition:'left',required:true,yCount:'5',options:['Home Office','Almacen GDL','Hermosillo','Mexicali']},
{view:'toolbar', cols:[{view:'button',id:'BotonBorrar',value:etiquetaBotonBorrar,width:85,click:'borrar'},{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'Fecha',header:Fecha,sort:'string',width:150},
	{id:'Empleado',header:IdEmpleado,sort:'string',fillspace:true,sort:'string',minWidth:150},
	{id:'Responsable',header:IdResponsable,sort:'string',width:150},
	{id:'Localizacion',header:Localizacion,sort:'string',width:150},
	{id:'Division',header:'Division',width:250}
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
function enviar(mensaje,accion){var valores=$$('Forma').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post('InventarioSistemasEmpServlet.jsp',valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	IdInventarioSistemas: $$('Tabla').getItem(id).IdInventarioSistemas,
	Fecha: $$('Tabla').getItem(id).Fecha,
	IdEmpleado: $$('Tabla').getItem(id).IdEmpleado,
	IdResponsable: $$('Tabla').getItem(id).IdResponsable,
	Localizacion: $$('Tabla').getItem(id).Localizacion,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

var servletIdEmpleado='EmpleadosServlet.jsp';var listaIdEmpleado=$$('IdEmpleado').getPopup().getList();listaIdEmpleado.clearAll();
var listaIdResponsable = $$("IdResponsable").getPopup().getList();
listaIdEmpleado.load(servletIdEmpleado + '?Accion=getEmpleadosActivosNoActivos&filter[value]=',function(){
	listaIdResponsable.clearAll();listaIdResponsable.load(servletIdEmpleado + '?Accion=getEmpleadosActivosNoActivos&filter[value]=');
});

inicial();buscar();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//InventarioSistemasEmp.jsp
%>
