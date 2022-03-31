<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/1.js"></script><!-- Para que no valide la sesión se cambia  <%-- <%=session.getAttribute("Idioma")%> --%> por 1 -->
<script>
//var servlet='servlet/RegistroEntradasAlmacenGdlServlet';
var servletacc='RegistroEntradasAlmacenGdlServlet.jsp';
var servletsal='RegistroSalidasAlmacenGdlServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

//VARIABLES
var Nombre = 'Se le da Acceso a';
var Gafete = 'Gafete Otorgado';

var IdRegistroEntradasAlmacenGdl = 'Seleccione a quien le dará salida';
var Prefijo = 'Prefijo';
var Awb = 'Awb';
var Guia = 'Registre alguna Guía';
var Observaciones = 'Observaciones';

//DEFINIENDO FORMAS
	//ACCESOS
	var formaacc={view:'form',id:'FormaAcc',width:'100%',height:'100%',elements:[
		{view:"label", 
		    label: '<font size ="6"><font color="green"><strong>ACCESOS</font color="red"></strong></font size ="3">', 
		    height:40,
		    align:"center"},
		{cols:[
			{rows:[
				{view:'text',id:'Nombre',name:'Nombre',value:'',placeholder:Nombre,label:'<font size ="3"><font color="black"><strong>Favor de registrar su Nombre o Empresa a dar acceso</font color="red"></strong></font size ="3">',labelWidth:130,width:1100,height:100,labelPosition:'top',required:true},	
				{view:'text',id:'Gafete',name:'Gafete',value:'',placeholder:Gafete,label:'<font size ="3"><font color="black"><strong>Registre el Gafete que se le asignó</font color="red"></strong></font size ="3">',labelWidth:130,width:1100,height:100,labelPosition:'top',required:true},
			]},
				{view:'button',id:'BotonGuardarAcc',type:'image',value:'',width:200,click:'guardaracc',image:'imagenes/registro200px.png'},
		]},
		{view:"label", 
		    label: '<font size ="2"><font color="green"><strong>Finalice el acceso presionando el botón REGISTRO</font color="red"></strong></font size ="3">', 
		    height:30,
		    align:"center"},
		{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:'NUEVO',width:85, click:'nuevoacc'},{},{}]},
	]};
	//SALIDAS BASE
	var formasal1={view:'form',id:'FormaSal1',width:'100%',height:'100%',elements:[
			{rows:[
				//BLOQUEADO, FUNCIONA COMBO
				/* {view:'combo',id:'IdRegistroEntradasAlmacenGdl',name:'IdRegistroEntradasAlmacenGdl',value:'',placeholder:IdRegistroEntradasAlmacenGdl,label:IdRegistroEntradasAlmacenGdl,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true}, */
					{view:"label", 
		    		label: '<font size ="6"><font color="red"><strong>SALIDAS</font color="red"></strong></font size ="3">', 
		    		height:40,
		    		align:"center"},
		    		
		    		{view:"label", 
		    		    label: '<font size ="2"><font color="green"><strong>Presione sobre su Registro para ingresar la información de su operación y dar salida</font color="red"></strong></font size ="3">', 
		    		    align:"center"},
					
		    		{view:"dataview",
				    id:'BotonesSalidas',name:'BotonesSalidas',
				    container:"dataA",
				    select:true,
				    template:"<div style= 'background:#a4c2d7; border:2px dotted black; font-size:12px;text-align:center'class='webix_strong'>#Nombre# <li>Gafete: #Gafete#</li></div>",
				    data:[],
				    //datatype:"...",
				    xCount:6, //the number of items in a row
				    yCount:4, //the number of items in a column
				    type:{
				        width: 261,
				        height: 60
				    }
			    },
				
			]},
			{view:'toolbar', cols:[{},{},{},{},{}]},
	]};

//NO SE USA, OCULTA
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,hidden:true,columns:[
	{id:'Nombre',header:Nombre,fillspace:true,sort:'string',minWidth:150},
	{id:'Gafete',header:Gafete,sort:'string',width:150},
	{id:'FechaHora',header:'Hora de Acceso',sort:'string',width:88},
]}]};
var vacio={id:'Vacio'};

// ESTRUCTURA PRINCIPAL
webix.ui({id:'principal',type:'space',rows:[{view:'accordion',type:'wide',multi:true,height:'100%',rows:[{height:'50%',header:'ACCESOS',body:formaacc},{height:'50%',header:'SALIDAS',body:formasal1}]}]});

//SALIDAS VENTANA EMERGENTE
var formasal2={view:'form',id:'FormaSal2',width:800,height:800,elements:[
	{view:'text',id:'IdRegistroEntradasAlmacenGdl',name:'IdRegistroEntradasAlmacenGdl',value:'',placeholder:Guia,attributes:{maxlength:8},hidden:true,required:false},
	/* {view:"label", id:'NombreSalida',
		label: '', 
		height:80,
		align:"center"}, */
	{cols:[
		{view:'label',id:'etiquetaGuia',name:'etiquetaGuia',label:Guia},
		{cols:[
			{},
			{view:'combo',id:'Prefijo',name:'Prefijo',value:'',required:false,yCount:'2',options:[{id:'A02',value:'A02'},{id:'036',value:'036'}]},
		]},
		{view:'text',id:'Awb',name:'Awb',value:'',placeholder:Guia,attributes:{maxlength:8},required:false},
		{},
		{},
		{},
	]},
	{view:'textarea',id:'Observaciones',name:'Observaciones',value:'',placeholder:Observaciones,label:Observaciones,labelWidth:100,height:230,labelPosition:'left',required:false},
	{view:'toolbar', cols:[{},{},{},{},{view:'button',id:'BotonGuardarSal',value:'SALIDA',width:85,click:'guardarsal'}]},
]};

//DEFINE LA VENTANA EMERGENTE Y SU CONTENIDO
webix.ui({view:"window",id:'VentanaFormaSal2',width:1024,height:350,position:'center',modal:true,head:{cols:[{},{view:'button', label:'X', width:50, click:("$$('VentanaFormaSal2').hide();cargaSalidas();")}]},body:{rows:[formasal2]}}).hide();

//DEFINE ELEMENTOS BOTONES
webix.ui({
    
});

//FUNCIONES DE FORMAS
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){$$('FrameSubforma').hide();}}
//function ultimosCapturados(mensaje){valoresBusqueda={Accion:'Buscar',Campo:''};enviar(mensaje,'Buscar');}
function nuevoacc(){$$('BotonGuardarAcc').show();$$('BotonGuardarAcc').show();$$('FormaAcc').clear();$$('Mensaje').setValue(nada);inicial();}
function nuevosal(){$$('BotonGuardarSal').show();$$('BotonGuardarSal').show();$$('FormaSal1').clear();$$('FormaSal2').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function guardaracc(){$$('FormaAcc').setValues({Accion:'Guardar'},true);if($$('FormaAcc').validate()){enviaracc(datosGuardados,'Guardar');}}
function guardarsal(){$$('FormaSal2').setValues({Accion:'Guardar'},true);if($$('FormaSal2').validate()){enviarsal(datosGuardados,'Guardar');}}
function guardarFinalAcc(){if(modoSubforma){$$('BotonGuardarAcc').hide();setSubforma();}else{$$('FormaAcc').clear();inicial();}}
function guardarFinalSal(){if(modoSubforma){$$('BotonGuardarSal').hide();setSubforma();}else{$$('FormaSal1').clear();$$('FormaSal2').clear();inicial();}}
function borrar(){webix.confirm({title:tituloEliminar,ok:si,cancel:no,type:'confirm-error',text:seguroQueDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(datosEliminados,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();enviar(datosEliminados,'Buscar');$$('BotonGuardarAcc').show();$$('BotonGuardarSal').show();$$('BotonModificar').hide();if(modoSubforma){$$('FrameSubforma').hide();}}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(datosModificados,'Modificar');}}
function modificarFinal(){if(modoSubforma){enviar(datosModificados,'Buscar');}else{$$('Forma').clear();enviar(datosModificados,'Buscar');$$('BotonGuardarAcc').show();$$('BotonGuardarSal').show();$$('BotonModificar').hide();}}
function buscar(){if($$('CampoBuscar').getValue()==''){$$('CampoBuscar').setValue('%');}valoresBusqueda={Accion:'Buscar',Campo:$$('CampoBuscar').getValue()};enviar(resultadosEncontrados,'Buscar');}
function enviaracc(mensaje,accion){var valores=$$('FormaAcc').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post(servletacc,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinalAcc();cargaSalidas();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){/* $$('PanelTabla').show(); */$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}
function enviarsal(mensaje,accion){var valores=$$('FormaSal2').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post(servletsal,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinalSal();$$('VentanaFormaSal2').hide();cargaSalidas();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){/* $$('PanelTabla').show(); */$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}


$$('Nombre').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Nombre').setValue(nuevo);});
$$('Gafete').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Gafete').setValue(nuevo);});

//BLOQUEADO, FUNCIONA COMBO
/* $$('IdRegistroEntradasAlmacenGdl').attachEvent("onItemClick", function(id, e){
    //code
	var servletIdRegistroEntradasAlmacenGdl='RegistroEntradasAlmacenGdlServlet.jsp';var listaIdRegistroEntradasAlmacenGdl=$$('IdRegistroEntradasAlmacenGdl').getPopup().getList();listaIdRegistroEntradasAlmacenGdl.clearAll();listaIdRegistroEntradasAlmacenGdl.load(servletIdRegistroEntradasAlmacenGdl + '?Accion=getIdRegistroEntradasAlmacenGdlActivos&filter[value]=');
	//$$('VentanaFormaSal2').show();
}); */

    //code
function cargaSalidas(){$$('BotonesSalidas').clearAll();$$('BotonesSalidas').load('RegistroEntradasAlmacenGdlServlet.jsp?Accion=getIdRegistroEntradasAlmacenGdlActivos&filter[value]=');}
//$$('VentanaFormaSal2').show();
cargaSalidas();

$$('BotonesSalidas').attachEvent('onSelectChange', function(id){
	//webix.message("Item "+id+" is selected!");
	$$('VentanaFormaSal2').show();
	$$('IdRegistroEntradasAlmacenGdl').setValue(parseInt(id));
	/* $$('NombreSalida').setValue('<font size ="2"><font color="green"><strong>'+$$('Nombre').getValue()+'</font color="red"></strong></font size ="3">'); */
});

function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
//inicial();ultimosCapturados(ultimos5);
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//RegistroEntradasAlmacenGdl.jsp
%>