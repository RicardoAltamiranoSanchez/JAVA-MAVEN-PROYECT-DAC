<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/TrainingServlet';
var servlet='TrainingServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='TrainingArchivos.jsp';var modoSubforma=true;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:'Ingreso',valor:'" + session.getAttribute("NombreUsuario") + "'}"); // Inserta el nombre del Usuario en el campo que lo debe de contener; //La acción Buscar lo trae pero eso no ayuda en nada, es independiente.
out.println("];");%>

var IdTrainingCursos = 'Registro';
var IdTrainingPersonal = 'Embajador y Empresa';
var Tipo = 'Tipo de Certificación';
var DiasNotificacion = 'Dias Notificacion';
var DiasVigencia = 'Dias Vigencia';
var NumeroCurso = 'Numero Curso';
var FechaHoy = 'Fecha de Hoy';// oculta
var Fecha = 'Fecha de Inicio';// autosugerir
var FechaVencimiento = 'Fecha Vencimiento';// calcular con los días de vigencia
var Estatus = 'Estatus';// Verificar con fecha de vencimiento
var Estacion = 'Estacion';
var Comprobante = 'Comprobante';
var Ingreso = 'Lo Registró';// obtener de sesión de usuario

var forma={view:'form',id:'Forma',width:500,scroll:'y',height:'100%',elements:[
	{view:'combo',id:'IdTrainingCursos',name:'IdTrainingCursos',value:'',placeholder:IdTrainingCursos,label:IdTrainingCursos,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true},
	{view:'combo',id:'IdTrainingPersonal',name:'IdTrainingPersonal',value:'',placeholder:IdTrainingPersonal,label:IdTrainingPersonal,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true},
	{cols:[
		{view:'combo',id:'Tipo',name:'Tipo',value:'',placeholder:Tipo,label:Tipo,labelPosition:'top',required:true,yCount:'2',options:[{id:'CURSO',value:'CURSO'},{id:'DOCUMENTO',value:'DOCUMENTO'}]},
	]},
	{cols:[
		{view:'text',id:'DiasNotificacion',name:'DiasNotificacion',value:'',placeholder:DiasNotificacion,label:DiasNotificacion,labelWidth:100,labelPosition:'left',required:true},
		{view:'text',id:'DiasVigencia',name:'DiasVigencia',value:'',placeholder:DiasVigencia,label:DiasVigencia,labelWidth:100,labelPosition:'left',required:true},
	]},
	{view:'text',id:'NumeroCurso',name:'NumeroCurso',value:'',placeholder:NumeroCurso,label:NumeroCurso,labelWidth:100,labelPosition:'left',required:true},
	{view:'datepicker',id:'FechaHoy',name:'FechaHoy',value: new Date(),placeholder:FechaHoy,label:FechaHoy,labelWidth:100,labelPosition:'left',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:true,hidden:true},
	{cols:[
		{view:'datepicker',id:'Fecha',name:'Fecha',value: new Date(),placeholder:Fecha,label:Fecha,labelWidth:100,labelPosition:'left',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:true},
		{view:'datepicker',id:'FechaVencimiento',name:'FechaVencimiento',value: new Date(),placeholder:FechaVencimiento,label:FechaVencimiento,labelWidth:100,labelPosition:'left',stringResult:true,format:webix.Date.dateToStr('%Y-%m-%d'),required:true},
	]},
	{view:'combo',id:'Estatus',name:'Estatus',value:'',placeholder:Estatus,label:Estatus,labelPosition:'top',required:true,yCount:'2',options:[{id:'VIGENTE',value:'VIGENTE'},{id:'CADUCADO',value:'CADUCADO'}]},	
	{cols:[
		{view:'text',id:'Estacion',name:'Estacion',value:'',placeholder:Estacion,label:Estacion,labelWidth:100,labelPosition:'left',required:true},	
		{view:'combo',id:'Comprobante',name:'Comprobante',value:'',placeholder:Comprobante,label:Comprobante,labelPosition:'top',required:true,yCount:'2',options:[{id:'SI',value:'SI'},{id:'NO',value:'NO'}]},
	]},
	{view:'text',id:'Ingreso',name:'Ingreso',value:'',placeholder:Ingreso,label:Ingreso,labelWidth:100,labelPosition:'left',required:true},
{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaBotonGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
{view:'iframe',id:'FrameSubforma',width:'80%',height:300,src:archivo},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'TrainingCursos',header:IdTrainingCursos,fillspace:true,sort:'string',minWidth:150},
	{id:'TrainingPersonal',header:IdTrainingPersonal,sort:'string',width:150},
	{id:'Tipo',header:Tipo,sort:'string',width:150},
	{id:'DiasNotificacion',header:DiasNotificacion,sort:'string',width:150},
	{id:'DiasVigencia',header:DiasVigencia,sort:'string',width:150},
	{id:'NumeroCurso',header:NumeroCurso,sort:'string',width:150},
	{id:'Fecha',header:Fecha,sort:'string',width:150},
	{id:'FechaVencimiento',header:FechaVencimiento,sort:'string',width:150},
	{id:'Estatus',header:Estatus,sort:'string',width:150},
	{id:'Estacion',header:Estacion,sort:'string',width:150},
	{id:'Comprobante',header:Comprobante,sort:'string',width:150},
	{id:'Ingreso',header:Ingreso,sort:'string',width:150}
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
function enviar(mensaje,accion){var valores=$$('Forma').getValues();
	if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post(servlet,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},
		success:function(text,data,XmlHttpRequest){
			if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');
			if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;
			if(accion=='Guardar'){guardarFinal();}else{modificarFinal();}}
			else if(accion=='Borrar'){borrarFinal();}
			else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}

$$('Tabla').attachEvent('onAfterSelect',function(id){$$('Forma').setValues({
	IdTrainingCursos: $$('Tabla').getItem(id).IdTrainingCursos,
	IdTrainingPersonal: $$('Tabla').getItem(id).IdTrainingPersonal,
	Tipo: $$('Tabla').getItem(id).Tipo,
	DiasNotificacion: $$('Tabla').getItem(id).DiasNotificacion,
	DiasVigencia: $$('Tabla').getItem(id).DiasVigencia,
	NumeroCurso: $$('Tabla').getItem(id).NumeroCurso,
	Fecha: $$('Tabla').getItem(id).Fecha,
	FechaVencimiento: $$('Tabla').getItem(id).FechaVencimiento,
	Estatus: $$('Tabla').getItem(id).Estatus,
	Estacion: $$('Tabla').getItem(id).Estacion,
	Comprobante: $$('Tabla').getItem(id).Comprobante,
	Ingreso: $$('Tabla').getItem(id).Ingreso,
	id: $$('Tabla').getItem(id).id,
	Accion:'Modificar'
});idGenerado=id;if(modoSubforma){setSubforma();}if($$('Tabla').getItem(id).bloquear){$$('BotonGuardar').hide();$$('BotonModificar').hide();$$('BotonBorrar').hide();}else{$$('BotonGuardar').hide();$$('BotonModificar').show();}
});

var servletIdTrainingCursos='TrainingCursosServlet.jsp';var listaIdTrainingCursos=$$('IdTrainingCursos').getPopup().getList();listaIdTrainingCursos.clearAll();listaIdTrainingCursos.load(servletIdTrainingCursos + '?Accion=getTrainingCursos&filter[value]=');
var servletIdTrainingPersonal='TrainingPersonalServlet.jsp';var listaIdTrainingPersonal=$$('IdTrainingPersonal').getPopup().getList();listaIdTrainingPersonal.clearAll();listaIdTrainingPersonal.load(servletIdTrainingPersonal + '?Accion=getTrainingPersonal&filter[value]=');

var format = webix.Date.dateToStr("%Y%m%d");
var FechaHoy = format(new Date($$('FechaHoy').getValue()));
//DEBUGalert(FechaHoy); 

$$('IdTrainingCursos').attachEvent('onChange',function(nuevo,anterior){ if(nuevo !== '') { 
	var objeto = $$('IdTrainingCursos').getList().getItem(nuevo);
	$$('Tipo').setValue (objeto.Tipo);
	var objeto = $$('IdTrainingCursos').getList().getItem(nuevo);
	$$('DiasNotificacion').setValue (objeto.DiasNotificacion);
	var objeto = $$('IdTrainingCursos').getList().getItem(nuevo);
	$$('DiasVigencia').setValue (objeto.DiasVigencia);
	var Fecha = $$('Fecha').getValue();
	Fecha=Fecha.replace('-',' ');
	Fecha=Fecha.replace('-',' ');
	Fecha=Fecha.split(" ",3);
	//DEBUGalert(Fecha);
	
	
	var FechaVigente = format(new Date($$('FechaVencimiento').getValue()));
	//DEBUGalert(FechaVigente);
	if (FechaVigente >= FechaHoy){
		$$('Estatus').setValue('VIGENTE');
	}else{
		$$('Estatus').setValue('CADUCADO');
	}
		
	var FechaFin = new Date(Fecha);
	var Dias=($$('DiasVigencia').getValue());
	//var Dias=2;
	var DiasFin=parseInt(Dias);
	//DEBUGalert(DiasFin);
	var FechaVencimiento = webix.Date.add(FechaFin,DiasFin,"day",true);
	//DEBUGalert(FechaVencimiento);
	//$$('Fecha') add($$('Fecha'),$$('DiasVigencia').getValue(),'day','No');
	$$('FechaVencimiento').setValue(FechaVencimiento);
	//$$('FechaVencimiento').setValue($$('Fecha').getValue()+$$('DiasVigencia').getValue());
	
} });

$$('Tipo').disable();
$$('DiasNotificacion').disable();
$$('DiasVigencia').disable();
$$('NumeroCurso').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('NumeroCurso').setValue(nuevo);});

$$('Fecha').attachEvent('onChange',function(nuevo,anterior){ if(nuevo !== '') {	
	var Fecha = $$('Fecha').getValue();
	Fecha=Fecha.replace('-',' ');
	Fecha=Fecha.replace('-',' ');
	Fecha=Fecha.split(" ",3);
	//DEBUGalert(Fecha);
	var FechaFin = new Date(Fecha);
	var Dias=($$('DiasVigencia').getValue());
	//var Dias=2;
	var DiasFin=parseInt(Dias);
	//DEBUGalert(DiasFin);
	var FechaVencimiento = webix.Date.add(FechaFin,DiasFin,"day",true);
	//DEBUGalert(FechaVencimiento);
	//$$('Fecha') add($$('Fecha'),$$('DiasVigencia').getValue(),'day','No');
	$$('FechaVencimiento').setValue(FechaVencimiento);
	//$$('FechaVencimiento').setValue($$('Fecha').getValue()+$$('DiasVigencia').getValue());
} });
	
$$('FechaVencimiento').attachEvent('onChange',function(nuevo,anterior){ if(nuevo !== '') {	
	
	
	var FechaVigente = format(new Date($$('FechaVencimiento').getValue()));
	//DEBUGalert(FechaVigente);
	if (FechaVigente >= FechaHoy){
		$$('Estatus').setValue('VIGENTE');
	}else{
		$$('Estatus').setValue('CADUCADO');
	}
	
} });
	
$$('FechaVencimiento').disable();
$$('Estatus').disable();
$$('Estacion').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Estacion').setValue(nuevo);});
$$('Comprobante').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Comprobante').setValue(nuevo);});
$$('Ingreso').disable();



function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();ultimosCapturados(ultimos5);
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//Training.jsp
%>
