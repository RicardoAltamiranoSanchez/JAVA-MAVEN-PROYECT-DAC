<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<script>


var forma={view:'form',id:'Forma',width:100,scroll:'y',height:'100%',enctype:"multipart/form-data",elements:[
	{view:'button',value:'1.Ingreso',width:95, click:'uno'},
	{view:'button',value:'2.Alta Cliente',width:95, click:'dos'},
	{view:'button',value:'3.Entradas',width:95, click:'tres'},
	{view:'button',value:'4.Salidas',width:95, click:'cuatro'}	
]};

var video1={view:"video",id:'video1',src:"videos/almacen01.mp4"};
var video2={view:"video",id:'video2',src:"videos/almacen02.mp4",hidden:true};
var video3={view:"video",id:'video3',src:"videos/almacen03.mp4",hidden:true};
var video4={view:"video",id:'video4',src:"videos/almacen04.mp4",hidden:true};

var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',
	rows:[{type:'header', template:'SISTEMA ALMACEN GDL'},
		{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[video1,video2,video3,video4]}]}]});

function uno(){ ocultar();
	$$('video1').show();
}

function dos(){ ocultar();
	$$('video2').show();
}

function tres(){ ocultar();
	$$('video3').show();
}

function cuatro(){ ocultar();
	$$('video4').show();
}

function ocultar() {
	$$('video1').hide();
	$$('video2').hide();
	$$('video3').hide();
	$$('video4').hide();
}

</script>
<%=EncabezadoPie.getPie()%>