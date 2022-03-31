<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "152";
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
var Politicas = ["Politica General MCS Aerocarga.pdf"];
webix.ui({
	view:'form',id:'Forma',width:'100%',height:'100%',elements:[{view:'toolbar',id:'TablaTools',width:'100%',height:'50%',rows:[
	{rows:[
			{view:'label',id:'Politicas',label:'POLITICAS Y PROCEDIMIENTOS',align:'center'},
			{view:"list",id:"ListaPoliticas",template:"Politica: #politica# <span class='info'>Descargar</span>",data:[],
				ready:function(){
					for(var x = 0; x < Politicas.length; x++)
						$$('ListaPoliticas').add({politica: Politicas[x]});
					},
				select:true,onClick:{info:function(e, id){link('politicas/' + this.getItem(id).politica);return false;}}},
		]}]}]});

function link(dato){
	document.location = dato;
}
</script>
<%=EncabezadoPie.getPie()%>