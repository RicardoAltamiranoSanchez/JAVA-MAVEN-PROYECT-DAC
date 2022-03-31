<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ page import="java.sql.ResultSet" %><%@ page import="java.sql.SQLException" %><%@ page import="Libreria.MysqlPool" %><%@ page import="java.util.ArrayList" %>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
//falta crear su modulo y ponerle el numero que le corresponde
String moduloIdioma = "";
Properties idioma = (Properties)session.getAttribute("IdiomaGeneral");
Properties idiomaModulo = (Properties)session.getAttribute(moduloIdioma);%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<%
//variables sql
MysqlPool eDB = new MysqlPool();
ResultSet resultados;
//variables de los datos
ArrayList<String> Titulos = new ArrayList<String>();
ArrayList<String> Descripcion = new ArrayList<String>();
ArrayList<String> Archivo = new ArrayList<String>();
int y = 0;

String Admon = "";

//conexiones sql
try{

	eDB.setConexion();			
	resultados = eDB.getQuery("select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "')");
	resultados.next();
	Admon = resultados.getString("Admon");
	eDB.setCerrar();
	eDB.setCerrarConexion();
	//DEBUGSystem.out.println("Se ha cargado la información de Politicas para "+Admon);

	eDB.setConexion();
	if (Admon.equals("MEX")){
		resultados = eDB.getQuery("select * from PoliticasInternasGenerales");
	}else{
		/* resultados = eDB.getQuery("select * from FormatosDhGdl"); ANTES CUANDO EXISTÍA EL MÓDULO FORMATOS*/
		resultados = eDB.getQuery("select * from PoliticasDhGdl");
	}	
	while(resultados.next()){
		Titulos.add(resultados.getString("Titulo"));
		Descripcion.add(resultados.getString("Descripcion"));
		Archivo.add(resultados.getString("Archivo"));
	}
	eDB.setCerrar(resultados);
	eDB.setCerrar();
	eDB.setCerrarConexion();
}catch(SQLException e){
	System.out.println("Error MySQL: ");
	e.printStackTrace(System.out);
}catch(NullPointerException e){
	System.out.println("Error Request: ");
	e.printStackTrace(System.out);
}
%>
<!-- Codigo HTML -->
<link rel="stylesheet" type="text/css" href="css/fuentes.css" media="screen" />
<style>
<!-- -->
#contenedor {
	overflow: hidden;
}
#indice {
  height: 100%;
  position: fixed;
  width: 29.4%;
  overflow: scroll;
  background-color: #105384;
  top:9px;
}

#contenido {
  height: 100%;
  left: 30%;
  overflow: hidden;
  position: fixed;
  width: 70%;
}

#McsLateral{
	position: fixed;
	align: left;
}

#McsLogo{
	position: fixed;
	left: 89%;
	align: right;
}

li{
	list-style: none;
}

li a{
	text-decoration:none;
}

a:visited {
		color: white;
		text-decoration:none;
}

a:link {
		color: white;
		text-decoration:none;
}

.Apartado{
	position: relative;
  	height: 100%;
  	width: 78%;
  	left: 6%;
  	overflow: scroll;
  	text-align:justify;
}
</style>
<div id="contenedor" class="texto">
	<div id="indice">
		<ul>
			<% 
				for(y = 0; y < Titulos.size(); y++){
			%>
	  				<li class="texto-BlancoNegritas"><a href="#Apartado<%=y+1 %>"><%=(y+1) + ".- " %><%=Titulos.get(y) %></a></li>
	  		<%
	  			}
	  		%>
		</ul>
	</div>
	
	<div id="contenido">
		<img src="imagenes/MCS_LATERAL.png" id="McsLateral"></img>
		<img src="imagenes/MCS_LOGO.png" id="McsLogo"></img>
		<%
			for(y = 0; y < Descripcion.size(); y++){
		%>
			
				<div class="Apartado" id="Apartado<%=y+1 %>">
					
					<h2 class="texto-Alegreya18"><strong><%=Titulos.get(y) %></strong></h2>
			  		<%	
			  				String tmp = Descripcion.get(y);
			  				String tmpDes[] = tmp.split("\n");
			  				for(int z = 0; z < tmpDes.length; z++){ 
			  					if(y==1000004 && z == 14 ){ %>
			  					<!-- <div style="display:table-cell; horizontal-align:middle;">
			  						<table style="text-align:center;" BORDER CELLPADDING=3 CELLSPACING=0>
										<tr>
											<td style="background-color:white;"><b>Años de antigüedad</b></td>
											<td style="background-color:white;"><b>D&iacute;as de vacaciones</b></td>
										</tr>
										<tr>
											<td>Uno</td>
											<td>Seis</td>
										</tr>
										<tr>
											<td>Dos</td>
											<td>Ocho</td>
										</tr>
										<tr>
											<td>Tres</td>
											<td>Diez</td>
										</tr>
										<tr>
											<td>Cuatro</td>
											<td>Doce</td>
										</tr>
										<tr>
											<td>Cinco a nueve</td>
											<td>Catorce</td>
										</tr>
										<tr>
											<td>Diez a catorce</td>
											<td>Diecis&eacute;is</td>
										</tr>
										<tr>
											<td>Quince a diecinueve</td>
											<td>Dieciocho</td>
										</tr>
										<tr>
											<td>Veinte a veinticuatro</td>
											<td>Veinte</td>
										</tr>
										<tr>
											<td>Veinticinco a veintinueve</td>
											<td>Veintid&oacute;s</td>
										</tr>
										<tr>
											<td>Treinta a treinta y cuatro</td>
											<td>Veinticuatro</td>
										</tr>
									</table>
								</div> -->
			  					<% }else{ %>
			  						<%=tmpDes[z] %><br>
			  					<% }
			  				}
			  				
			  				if(!Archivo.get(y).equals("''")){ %>
			  					<a href="formatos/<%=Archivo.get(y) %>">Descargar <%=Archivo.get(y) %></a>
			  				<% }
			  			%>
				</div>
		<%
	  		}
	  	%>
	  	
	</div>
</div>
<script>
</script>
<%=EncabezadoPie.getPie()%>