<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "96";
Properties idioma = (Properties)session.getAttribute("IdiomaGeneral");
Properties idiomaModulo = (Properties)session.getAttribute(moduloIdioma);
%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<style>
<!--
.info{
    width:100px;
    text-align: center;
    font-weight:bold;
    float:right;
    background-color:#444;
    color:white;
    border-radius:3px;
}
-->
</style>
<script>
webix.ui({
	view:'form',id:'Forma',width:'100%',height:'100%',elements:[{view:'toolbar',id:'TablaTools',width:'100%',height:'50%',rows:[
	{cols:[
		{rows:[
			{view:'label',id:'Formatos',label:'VACACIONES',align:'center'},
			{cols:[
				{view:"list", id:"ListaVacaciones1",template:"#etiqueta# #dato# ", data:[],
				ready:function(){ $$('Forma').setValues({Accion:'ConsultarSolicitudesVacacionesConVencidas'},true);webix.ajax().post("servlet/VacacionesServlet", $$('Forma').getValues(),{
	    		error:function(text, data, XmlHttpRequest){webix.message("Error");},
	    		success:function(text, data, XmlHttpRequest){ 
	    			setConfirmacionInformacion(data.json());
	    		 }});}
				},
				{view:"list", id:"ListaVacaciones2",autoheight:true,autowidth:true,scroll:"xy",template:"#etiqueta# #dato#", data:[]},
				{view:"textarea", id:"ListaVacaciones3",autoheight:true,autowidth:true,scroll:"xy",readonly:true}
			]}
		]}
	]},
	{cols:[
	   	{rows:[    
	   		{view:'label',id:'Formatos',label:'INFORMACION INSTITUCIONAL',align:'center'},
	    	{view:"list", id:"ListaFormato", template:"Nombre : #nombre# <span class='info'>Descargar</span>", data:[],
	    		ready:function(){ $$('Forma').setValues({Accion:'ConsultarFormatos'},true);webix.ajax().post("servlet/FormatosServlet", $$('Forma').getValues(),{
	    		error:function(text, data, XmlHttpRequest){webix.message("Error");},
	    		success:function(text, data, XmlHttpRequest){setConfirmacion(data.json(),"3");}});},
	    		select:true,onClick:{info:function(e, id){link('formatos/' + this.getItem(id).archivo);return false;}}}
		]},
		{rows:[
			{view:'label',id:'Politicas',label:'POLITICAS Y PROCEDIMIENTOS',align:'center'},
			{view:"list",id:"ListaPoliticas",template:"Fecha: #fecha#, Politica: #politica# <span class='info'>Descargar</span>",data:[],
				ready:function(){$$('Forma').setValues({Accion:'ConsultarPoliticas'},true);webix.ajax().post("servlet/PoliticasServlet",$$('Forma').getValues(),{
        		error:function(text, data, XmlHttpRequest){webix.message("Error");},
        		success:function(text, data, XmlHttpRequest){setConfirmacion(data.json(),"4");}});},
				select:true,onClick:{info:function(e, id){link('politicas/' + this.getItem(id).archivo);return false;}}},
		]}
	]},
	{cols:[
		{rows:[
			{view:'label',id:'Noticias',label:'NOTICIAS',align:'center'},
	    	{view:"list",id:"ListaNoticias",template:"Fecha: #fecha#, Titulo: #titulo# <span class='info'>Detalles</span>",data:[],
	    		ready:function(){$$('Forma').setValues({Accion:'ConsultarNoticias'},true);webix.ajax().post("servlet/NoticiasServlet",$$('Forma').getValues(),{
	        	error:function(text, data, XmlHttpRequest){webix.message("Error");},
	        	success:function(text, data, XmlHttpRequest){setConfirmacion(data.json(),"2");}});},
	        	select:true,onClick:{info:function(e, id){link("NoticiasFormato.jsp?Id=" + this.getItem(id).id + "");return false;}}}
		]},
		{rows:[
	  		{view:'label',id:'Avisos',label:'AVISOS',align:'center'},
			{view:"list",id:"ListaAvisos",template:"Fecha: #fecha#, Aviso: #aviso# <span class='info'>Ver</span>",data:[],
				ready:function(){$$('Forma').setValues({Accion:'ConsultarAvisos'},true);webix.ajax().post("servlet/AvisosServlet",$$('Forma').getValues(),{
        		error:function(text, data, XmlHttpRequest){webix.message("Error");},
        		success:function(text, data, XmlHttpRequest){setConfirmacion(data.json(),"1");}});},
				select:true,onClick:{info:function(e, id){link("AvisosFormato.jsp?Id=" + this.getItem(id).id + "");return false;}}},
	    		
		]}
	]}]}]});


function setConfirmacion(info,lista){
	if(lista == "2"){
		for(var x = 0; x < info.length; x++)
			$$('ListaNoticias').add({id: info[x].id,fecha:info[x].Fecha,titulo:info[x].Titulo});
	}else if(lista == "1"){
		for(var x = 0; x < info.length; x++)
			$$('ListaAvisos').add({id: info[x].id,fecha:info[x].Fecha,aviso:info[x].Aviso});
	}else if(lista == "3"){
		for(var x = 0; x < info.length; x++)
		$$('ListaFormato').add({id: info[x].id,nombre:info[x].Nombre,archivo:info[x].Archivo});
	}else if(lista == "4"){
		for(var x = 0; x < info.length; x++)
		$$('ListaPoliticas').add({id: info[x].id,fecha:info[x].Fecha,politica: info[x].Politica, archivo:info[x].Archivo});
	}
}
var infosolicitudes = ["VENCIMIENTO DE VACACIONES: ","SOLICITUDES PENDIENTES DE AUTORIZAR: ","SOLICITUDES AUTORIZADAS: ","SOLICITUDES RECHAZADAS: "];
var infodias = ["D&Iacute;AS DE VACACIONES DISPONIBLES: ","D&Iacute;AS QUE HAS SOLICITADO: ","TOTAL DE D&Iacute;AS DE VACACIONES EN ESTE AÑO: ","DIAS: ","D&Iacute;AS DISPONIBLES PERIODO ANTERIOR:"];
function setConfirmacionInformacion(info){
	var admon = info.Admon;
		$$('ListaVacaciones1').add({etiqueta:infosolicitudes[0],dato:info.Vencimiento});
		$$('ListaVacaciones1').add({etiqueta:infosolicitudes[1],dato:info.SolicitudesPendientes});
		$$('ListaVacaciones1').add({etiqueta:infosolicitudes[2],dato:info.SolicitudesAutorizadas});
		$$('ListaVacaciones1').add({etiqueta:infosolicitudes[3],dato:info.SolicitudesRechazadas});
		$$('ListaVacaciones2').add({etiqueta:infodias[0],dato:info.DiasDisfrutar});
		if (admon == 'GDL'){
			$$('ListaVacaciones2').add({etiqueta:infodias[4],dato:info.DiasDisfrutarPeriodoAnterior});
		}
		$$('ListaVacaciones2').add({etiqueta:infodias[1],dato:info.DiasSolicitados});
		
		/* if (admon == 'MEX'){
			$$('ListaVacaciones2').add({etiqueta:infodias[2],dato:info.DiasTotales});
		} */
		$$('ListaVacaciones2').add({etiqueta:infodias[2],dato:info.DiasTotales});
		
		if (admon == 'GDL'){
			$$('ListaVacaciones3').setValue("DÍAS AUTORIZADOS EN EL ÚLTIMO AÑO CORRESPONDIENTE A TUS VACACIONES OFICIALES Y EN CASO DE APLICAR, TAMBIÉN LOS DIAS DEL PERIODO ANTERIOR: \n\n" + info.Dias);
		}else{
			$$('ListaVacaciones3').setValue("DÍAS AUTORIZADOS EN EL ÚLTIMO AÑO CORRESPONDIENTE A TUS VACACIONES: \n\n" + info.Dias);
		}
}

function link(dato){
	document.location = dato;
}
</script>
<%=EncabezadoPie.getPie()%>