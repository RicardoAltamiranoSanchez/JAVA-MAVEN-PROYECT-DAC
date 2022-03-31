<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/PresupuestoServlet';
var servlet='PresupuestoServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

var IdUsuario = 'Usuario';
var Ao = 'Ao';
var IdCuentas = 'Cuenta';
var M1 = 'M1';
var M2 = 'M2';
var M3 = 'M3';
var M4 = 'M4';
var M5 = 'M5';
var M6 = 'M6';
var M7 = 'M7';
var M8 = 'M8';
var M9 = 'M9';
var M10 = 'M10';
var M11 = 'M11';
var M12 = 'M12';

var forma={view:'form',id:'Forma',width:400,height:'100%',elements:[
	{view:'combo',id:'IdUsuario',name:'IdUsuario',value:'',placeholder:IdUsuario,label:IdUsuario,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true},
	{view:'text',id:'Ao',name:'Ao',value:'',placeholder:Ao,label:Ao,labelWidth:100,labelPosition:'left',required:true},
	{view:'combo',id:'IdCuentas',name:'IdCuentas',value:'',placeholder:IdCuentas,label:IdCuentas,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true},
	{view:'text',id:'M1',name:'M1',value:'',placeholder:M1,label:M1,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'M2',name:'M2',value:'',placeholder:M2,label:M2,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'M3',name:'M3',value:'',placeholder:M3,label:M3,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'M4',name:'M4',value:'',placeholder:M4,label:M4,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'M5',name:'M5',value:'',placeholder:M5,label:M5,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'M6',name:'M6',value:'',placeholder:M6,label:M6,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'M7',name:'M7',value:'',placeholder:M7,label:M7,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'M8',name:'M8',value:'',placeholder:M8,label:M8,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'M9',name:'M9',value:'',placeholder:M9,label:M9,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'M10',name:'M10',value:'',placeholder:M10,label:M10,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'M11',name:'M11',value:'',placeholder:M11,label:M11,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'M12',name:'M12',value:'',placeholder:M12,label:M12,labelWidth:100,labelPosition:'left',required:true},
{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
//{view:'iframe',id:'FrameSubforma',width:'80%',src:archivo},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'IdUsuario',header:IdUsuario,fillspace:true,sort:'string',minWidth:150},
	{id:'Ao',header:Ao,sort:'string',width:150},
	{id:'IdCuentas',header:IdCuentas,sort:'string',width:150},
	{id:'M1',header:M1,sort:'string',width:150},
	{id:'M2',header:M2,sort:'string',width:150},
	{id:'M3',header:M3,sort:'string',width:150},
	{id:'M4',header:M4,sort:'string',width:150},
	{id:'M5',header:M5,sort:'string',width:150},
	{id:'M6',header:M6,sort:'string',width:150},
	{id:'M7',header:M7,sort:'string',width:150},
	{id:'M8',header:M8,sort:'string',width:150},
	{id:'M9',header:M9,sort:'string',width:150},
	{id:'M10',header:M10,sort:'string',width:150},
	{id:'M11',header:M11,sort:'string',width:150},
	{id:'M12',header:M12,sort:'string',width:150}
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
	IdUsuario: $$('Tabla').getItem(id).IdUsuario,
	Ao: $$('Tabla').getItem(id).Ao,
	IdCuentas: $$('Tabla').getItem(id).IdCuentas,
	M1: $$('Tabla').getItem(id).M1,
	M2: $$('Tabla').getItem(id).M2,
	M3: $$('Tabla').getItem(id).M3,
	M4: $$('Tabla').getItem(id).M4,
	M5: $$('Tabla').getItem(id).M5,
	M6: $$('Tabla').getItem(id).M6,
	M7: $$('Tabla').getItem(id).M7,
	M8: $$('Tabla').getItem(id).M8,
	M9: $$('Tabla').getItem(id).M9,
	M10: $$('Tabla').getItem(id).M10,
	M11: $$('Tabla').getItem(id).M11,
	M12: $$('Tabla').getItem(id).M12,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if(modoSubforma){setSubforma();}if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

var servletIdUsuario='servlet/GerentesServlet';var listaIdUsuario=$$('IdUsuario').getPopup().getList();listaIdUsuario.clearAll();listaIdUsuario.load(servletIdUsuario + '?Accion=getGerentes&filter[value]=');
$$('Ao').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Ao').setValue(nuevo);});
var servletIdCuentas='PresupuestoCuentasServlet.jsp';var listaIdCuentas=$$('IdCuentas').getPopup().getList();listaIdCuentas.clearAll();listaIdCuentas.load(servletIdCuentas + '?Accion=getPresupuestoCuentas&filter[value]=');
$$('M1').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M1').setValue(nuevo);});
$$('M2').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M2').setValue(nuevo);});
$$('M3').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M3').setValue(nuevo);});
$$('M4').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M4').setValue(nuevo);});
$$('M5').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M5').setValue(nuevo);});
$$('M6').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M6').setValue(nuevo);});
$$('M7').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M7').setValue(nuevo);});
$$('M8').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M8').setValue(nuevo);});
$$('M9').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M9').setValue(nuevo);});
$$('M10').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M10').setValue(nuevo);});
$$('M11').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M11').setValue(nuevo);});
$$('M12').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('M12').setValue(nuevo);});

function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();ultimosCapturados(ultimos5);
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//Presupuesto.jsp
%>