<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/1.js"></script><!-- Para que no valide la sesión se cambia  <%-- <%=session.getAttribute("Idioma")%> --%> por 1 -->
<script>
//var servlet='servlet/RegistroEntradasAlmacenMexServlet';
var servletacc='RegistroEntradaVisitasAlmacenesServlet.jsp';
var servletsal='RegistroSalidaVisitasAlmacenesServlet.jsp';
var servletchec='RegistroChecadoresServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

//VARIABLES
var Nombre = 'Se le da Acceso a';
var Gafete = 'Gafete Otorgado';

var IdRegistroEntradasAlmacenes = 'Seleccione a quien le dará salida';
var Prefijo = 'Prefijo';
var Awb = 'Awb';
var Guia = 'Registre alguna Guía';
var Observaciones = 'Observaciones';

//DEFINIENDO FORMAS (RESOLUCIÓN 1366 x 768)
	//ACCESOS
	var formaacc={view:'form',id:'FormaAcc',width:'100%',height:'100%',elements:[
		{view:"label", 
		    label: '<font size ="6"><font color="green"><strong>ACCESO VISITANTES</font color="red"></strong></font size ="3">', 
		    height:40,
		    align:"center"},
		{cols:[
			{rows:[
				{view:'text',id:'Nombre',name:'Nombre',value:'',placeholder:Nombre,label:'<font size ="3"><font color="black"><strong>Favor de registrar su Nombre o Empresa a dar acceso</font color="red"></strong></font size ="3">',labelWidth:130,width:450,height:100,labelPosition:'top',required:true},	
				{view:'text',id:'Gafete',name:'Gafete',value:'',placeholder:Gafete,label:'<font size ="3"><font color="black"><strong>Registre el Gafete que se le asignó</font color="red"></strong></font size ="3">',labelWidth:130,width:450,height:100,labelPosition:'top',required:true},
				//Aquí se define de forma constante la estacion, en este caso MEX
				{view:'text',id:'EstacionEnt',name:'Estacion',value:'MEX',placeholder:'Estacion',label:'Estacion',labelWidth:130,width:1100,height:100,labelPosition:'top',required:false,hidden:true},
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
				/* {view:'combo',id:'IdRegistroEntradasAlmacenMex',name:'IdRegistroEntradasAlmacenMex',value:'',placeholder:IdRegistroEntradasAlmacenMex,label:IdRegistroEntradasAlmacenMex,labelWidth:100,labelPosition:'left',options:[],yCount:'3',required:true}, */
					{view:"label", 
		    		label: '<font size ="6"><font color="red"><strong>SALIDA VISITANTES</font color="red"></strong></font size ="3">', 
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
	
	//CHECADOR
	var formachec={view:'form',id:'FormaChec',width:'100%',height:'100%',elements:[
		//Estacion
		{view:"label", 
		    label: "<span style='font-size:60px; color:red;font-family:verdana;font-style:bold'>MEX</span>", 
		    height:100,
		    align:"center"},
		    
		// Personal interno
	    {view:"label", 
		    label: "<span style='font-size:25px; color:green;font-family:verdana;font-style:bold'>PERSONAL INTERNO</span>", 
		    height:25,
		    align:"center"},
		
		 // Relój checador
	    {view:"label", 
		    label: "<span style='font-size:25px; color:red;font-family:verdana;font-style:bold'>RELOJ CHECADOR</span>", 
		    height:25,
		    align:"center"},
		 // Relój
	    {view:"label",id:"Reloj",
		    label: "<span style='font-size:40px; color:black;font-family:verdana;font-style:bold'>16:43</span>",
		    height:100,
		    align:"center"},
		//Número de Empleado  
		{view:"label",
		    label:'<font size ="5"><font color="black"><strong>Número de Empleado</font color="black"></strong></font size ="5">',
		    height:30,
		    align:"center",hidden:true}, //NO ESTA EN USO
		{view:'text',
		    	id:'NumEmpleado',name:'NumEmpleado',value:'',placeholder:'Se hará el registro de',label:'',
		    	width:350,height:70,align:'center',labelAlign:'center',required:false, hidden:true}, //NO ESTA EN USO
    	{view:"label",
		    label:'<font size ="5"><font color="black"><strong>Ingresa tu usuario de intranet</font color="black"></strong></font size ="5">',
		    height:30,
		    align:"center"},
	    {cols:[
			{},
		    {view:'text',
	    		id:'UsuarioIntranet',name:'UsuarioIntranet',value:'',placeholder:'Usuario Intranet',label:'',
	    		width:200,height:50,align:'center',labelAlign:'center',required:true, hidden:false,attributes:{ autocomplete:"new-password" }},
	    	{},
	    	{view:'text', type:"password",
		   		id:'PasswordIntranet',name:'PasswordIntranet',value:'',placeholder:'Contraseña Intranet',label:'',
		   		width:200,height:50,align:'center',labelAlign:'center',required:true, hidden:false,attributes:{ autocomplete:"new-password" }},
		   	{},
		]},
		{view:"label",id:'confirmacion',name:'confirmacion',
	    		value:'',
			    height:50,
			    align:"center"},
	  //Botones
    	{rows:[
    		{cols:[
	    		{},
	    		{view:"label",
	    		    label:'<font size ="3"><font color="black"><strong>Botones para Acceso Principal</font color="black"></strong></font size ="2">',width:260,
	    		    height:50,
	    		    align:"center"},
	    		{},
	    		{},
	    		{view:"label",
	    		    label:'<font size ="3"><font color="black"><strong>Botones para Horario de Comida</font color="black"></strong></font size ="2">',width:260,
	    		    height:50,
	    		    align:"center"},
	    		{},
	    	]},
	    	{cols:[
	    		{},
	    		{},
	    		{view:'button',id:'BotonEntradaChec',type:'image',value:'',width:120,height:120,click:'guardarentradachec',image:'imagenes/BtnEntradaChec120.png'},
	    		{},
	    		{view:'button',id:'BotonSalidaChec',type:'image',value:'',width:120,height:120,click:'guardarsalidachec',image:'imagenes/BtnSalidaChec120.png'},
	    		{},
	    		{},
	    		{},
	    		{},
	    		{},
	    		{view:'button',id:'BotonEntComChec',type:'image',value:'',width:120,height:120,click:'guardarentcomchec',image:'imagenes/BtnEntComChec120.png'},
	    		{},
	    		{view:'button',id:'BotonSalComChec',type:'image',value:'',width:120,height:120,click:'guardarsalcomchec',image:'imagenes/BtnSalComChec120.png'},
	    		{},
	    		{},
	    	]},
    	]},
    	
    	{},
		    
		{view:'text',id:'EstacionChec',name:'Estacion',value:'MEX',placeholder:'Estacion',label:'Estacion',labelWidth:130,width:1100,height:100,labelPosition:'top',required:false,hidden:true},
	]};

//NO SE USA, OCULTA
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,hidden:true,columns:[
	{id:'Nombre',header:Nombre,fillspace:true,sort:'string',minWidth:150},
	{id:'Gafete',header:Gafete,sort:'string',width:150},
	{id:'FechaHora',header:'Hora de Acceso',sort:'string',width:88},
]}]};
var vacio={id:'Vacio'};

// ESTRUCTURA PRINCIPAL
webix.ui({id:'principal',type:'space',cols:[{view:'accordion',type:'wide',multi:true,height:'100%',rows:[{height:'50%',header:'ACCESOS VISITANTES',body:formaacc},{height:'50%',header:'SALIDAS VISITANTES',body:formasal1}]},{height:'100%',header:'CHECADOR EMPLEADOS',body:formachec}]});

//SALIDAS VENTANA EMERGENTE
var formasal2={view:'form',id:'FormaSal2',width:800,height:800,elements:[
	{view:'text',id:'IdRegistroEntradasAlmacenes',name:'IdRegistroEntradasAlmacenes',value:'',placeholder:Guia,attributes:{maxlength:8},hidden:true,required:false},
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
	{view:'text',id:'EstacionSal',name:'Estacion',value:'MEX',placeholder:'Estacion',label:'Estacion',labelWidth:130,width:1100,height:100,labelPosition:'top',required:false,hidden:true},
	{view:'toolbar', cols:[{},{},{},{},{view:'button',id:'BotonGuardarSal',value:'SALIDA',width:85,click:'guardarsal'}]},
]};

//DEFINE LA VENTANA EMERGENTE Y SU CONTENIDO
webix.ui({view:"window",id:'VentanaFormaSal2',width:1024,height:350,position:'center',modal:true,head:{cols:[{},{view:'button', label:'X', width:50, click:("$$('VentanaFormaSal2').hide();cargaSalidas();")}]},body:{rows:[formasal2]}}).hide();

//DEFINE ELEMENTOS BOTONES
webix.ui({
    
});

//FUNCIONES DE FORMAS
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}/*DEFINIENDO SIEMPRE ESTACION AQUI*/$$('EstacionEnt').setValue('MEX');$$('EstacionSal').setValue('MEX');if(modoSubforma){$$('FrameSubforma').hide();}}
//function ultimosCapturados(mensaje){valoresBusqueda={Accion:'Buscar',Campo:''};enviar(mensaje,'Buscar');}
function nuevoacc(){$$('BotonGuardarAcc').show();$$('BotonGuardarAcc').show();$$('FormaAcc').clear();$$('Mensaje').setValue(nada);inicial();}
function nuevosal(){$$('BotonGuardarSal').show();$$('BotonGuardarSal').show();$$('FormaSal1').clear();$$('FormaSal2').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
//Visitantes
function guardaracc(){$$('FormaAcc').setValues({Accion:'Guardar'},true);if($$('FormaAcc').validate()){enviaracc(datosGuardados,'Guardar');}}
function guardarsal(){$$('FormaSal2').setValues({Accion:'Guardar'},true);if($$('FormaSal2').validate()){enviarsal(datosGuardados,'Guardar');}}
//Checador
//function guardarentradachec(){$$('FormaChec').setValues({Accion:'GuardarEntrada'},true);if($$('FormaChec').validate()){enviarchec(datosGuardados,'GuardarEntrada');webix.alert('Se registró el Acceso del Número de Empleado: '+$$('NumEmpleado').getValue());$$('FormaChec').clear();$$('EstacionChec').setValue('MEX');}}
//USADA CON NUMEMPLEADOfunction guardarentradachec(){$$('FormaChec').setValues({Accion:'GuardarEntrada'},true);if($$('FormaChec').validate()){enviarchec(datosGuardados,'GuardarEntrada');webix.alert("<span style='font-size:30px; color:green;font-family:verdana;font-style:bold'>Entrada Registrada</span>");$$('FormaChec').clear();$$('EstacionChec').setValue('GDL');}}
function guardarentradachec(){$$('FormaChec').setValues({Accion:'GuardarEntrada'},true);if($$('FormaChec').validate()){enviarchec(datosGuardados,'GuardarEntrada');$$('FormaChec').clear();$$('EstacionChec').setValue('MEX');}}
//function guardarsalidachec(){$$('FormaChec').setValues({Accion:'GuardarSalida'},true);if($$('FormaChec').validate()){enviarchec(datosGuardados,'GuardarSalida');webix.alert('Se registró la Salida del Número de Empleado: '+$$('NumEmpleado').getValue());$$('FormaChec').clear();$$('EstacionChec').setValue('GDL');}}
function guardarsalidachec(){$$('FormaChec').setValues({Accion:'GuardarSalida'},true);if($$('FormaChec').validate()){enviarchec(datosGuardados,'GuardarSalida');/*webix.alert("<span style='font-size:30px; color:red;font-family:verdana;font-style:bold'>Salida Registrada</span>");*/$$('FormaChec').clear();$$('EstacionChec').setValue('MEX');}}

function guardarentcomchec(){$$('FormaChec').setValues({Accion:'GuardarEntradaComida'},true);if($$('FormaChec').validate()){enviarchec(datosGuardados,'GuardarEntradaComida');$$('FormaChec').clear();$$('EstacionChec').setValue('MEX');}}
function guardarsalcomchec(){$$('FormaChec').setValues({Accion:'GuardarSalidaComida'},true);if($$('FormaChec').validate()){enviarchec(datosGuardados,'GuardarSalidaComida');$$('FormaChec').clear();$$('EstacionChec').setValue('MEX');}}


function guardarFinalAcc(){if(modoSubforma){$$('BotonGuardarAcc').hide();setSubforma();}else{$$('FormaAcc').clear();inicial();}}
function guardarFinalSal(){if(modoSubforma){$$('BotonGuardarSal').hide();setSubforma();}else{$$('FormaSal1').clear();$$('FormaSal2').clear();inicial();}}
//Checador
//function guardarFinalChec(){$$('FormaChec').clear();inicial();}


function borrar(){webix.confirm({title:tituloEliminar,ok:si,cancel:no,type:'confirm-error',text:seguroQueDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null){webix.message(seleccioneUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+seleccioneUnRegistro+'</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(datosEliminados,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarFinal(){$$('Forma').clear();enviar(datosEliminados,'Buscar');$$('BotonGuardarAcc').show();$$('BotonGuardarSal').show();$$('BotonModificar').hide();if(modoSubforma){$$('FrameSubforma').hide();}}
function modificar(){$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(datosModificados,'Modificar');}}
function modificarFinal(){if(modoSubforma){enviar(datosModificados,'Buscar');}else{$$('Forma').clear();enviar(datosModificados,'Buscar');$$('BotonGuardarAcc').show();$$('BotonGuardarSal').show();$$('BotonModificar').hide();}}
function buscar(){if($$('CampoBuscar').getValue()==''){$$('CampoBuscar').setValue('%');}valoresBusqueda={Accion:'Buscar',Campo:$$('CampoBuscar').getValue()};enviar(resultadosEncontrados,'Buscar');}

function enviaracc(mensaje,accion){var valores=$$('FormaAcc').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post(servletacc,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinalAcc();cargaSalidas();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){/* $$('PanelTabla').show(); */$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}
function enviarsal(mensaje,accion){var valores=$$('FormaSal2').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post(servletsal,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'){guardarFinalSal();$$('VentanaFormaSal2').hide();cargaSalidas();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){/* $$('PanelTabla').show(); */$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}
//Checador
function enviarchec(mensaje,accion){var valores=$$('FormaChec').getValues();if(accion=='Buscar'){valores=valoresBusqueda;}webix.ajax().post(servletchec,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');
var nombre = data.json().value; 
var evento = data.json().log; 
if(nombre ==''){
	$$('confirmacion').setValue("<span style='font-size:30px; color:red;font-family:verdana;font-style:bold'>DATOS INCORRECTOS</span>")
}else{
	if (evento == 'entrada'){
		$$('confirmacion').setValue("<span style='font-size:20px; color:green;font-family:verdana;font-style:bold'>ACCESO CORRECTO "+nombre+"</span>")
	}else{
		$$('confirmacion').setValue("<span style='font-size:20px; color:blue;font-family:verdana;font-style:bold'>SALIDA REGISTRADA "+nombre+"</span>")
	}
	
}
//webix.alert("<span style='font-size:30px; color:green;font-family:verdana;font-style:bold'>"+data.json().value+"</span>");//NOMBRE DE EMPLEADO
if(accion=='Guardar'||accion=='Modificar'){idGenerado=data.json().id;if(accion=='Guardar'||accion=='GuardarEntrada'||accion=='GuardarSalida'){guardarFinalChec();}else{modificarFinal();}}else if(accion=='Borrar'){borrarFinal();}else if(accion=='Buscar'){/* $$('PanelTabla').show(); */$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}}}});}

//RELOJ
function activaReloj(){
	var hoy = new Date();
	var h = hoy.getHours();
	var m = hoy.getMinutes();
	var s = hoy.getSeconds();
	if (h < 10){
		h = "0".concat(h);
	}
	if (m < 10){
		m = "0".concat(m);
	}
	if (s < 10){
		s = "0".concat(s);
	}
	$$('Reloj').setValue("<span style='font-size:50px; color:black;font-family:verdana;font-style:bold'>"+h+":"+m+":"+s+"</span>");
	setTimeout(activaReloj,1000);
}

$$('Nombre').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Nombre').setValue(nuevo);});
$$('Gafete').attachEvent('onChange',function(nuevo,anterior){nuevo=nuevo.toUpperCase();$$('Gafete').setValue(nuevo);});

//BLOQUEADO, FUNCIONA COMBO
/* $$('IdRegistroEntradasAlmacenMex').attachEvent("onItemClick", function(id, e){
    //code
	var servletIdRegistroEntradasAlmacenMex='RegistroEntradasAlmacenMexServlet.jsp';var listaIdRegistroEntradasAlmacenMex=$$('IdRegistroEntradasAlmacenMex').getPopup().getList();listaIdRegistroEntradasAlmacenMex.clearAll();listaIdRegistroEntradasAlmacenMex.load(servletIdRegistroEntradasAlmacenMex + '?Accion=getIdRegistroEntradasAlmacenMexActivos&filter[value]=');
	//$$('VentanaFormaSal2').show();
}); */

    //code
function cargaSalidas(){$$('BotonesSalidas').clearAll();$$('BotonesSalidas').load('RegistroEntradaVisitasAlmacenesServlet.jsp?Accion=getIdRegistroEntradasAlmacenesActivosEst&filter[value]=,MEX');}
//$$('VentanaFormaSal2').show();
cargaSalidas();
activaReloj();

$$('BotonesSalidas').attachEvent('onSelectChange', function(id){
	//webix.message("Item "+id+" is selected!");
	$$('VentanaFormaSal2').show();
	$$('IdRegistroEntradasAlmacenes').setValue(parseInt(id));
	/* $$('NombreSalida').setValue('<font size ="2"><font color="green"><strong>'+$$('Nombre').getValue()+'</font color="red"></strong></font size ="3">'); */
});

function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
//inicial();ultimosCapturados(ultimos5);
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//RegistroEntradasAlmacenMex.jsp
%>