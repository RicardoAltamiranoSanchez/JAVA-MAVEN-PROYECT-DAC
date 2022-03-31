<%@ page import="java.sql.ResultSet" %><%@ page import="java.sql.SQLException" %><%@ page import="Libreria.MysqlPool" %><%@ page import="java.util.ArrayList" %>

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
	//DEBUGSystem.out.println("Se ha cargado la información de Politicas en el ENCABEZADO para "+Admon);

	/* eDB.setConexion();
	if (Admon.equals("MEX")){
		resultados = eDB.getQuery("select * from PoliticasInternasGenerales");
	}else{
		resultados = eDB.getQuery("select * from PoliticasInternasGeneralesGdl");
	}	
	while(resultados.next()){
		Titulos.add(resultados.getString("Titulo"));
		Descripcion.add(resultados.getString("Descripcion"));
		Archivo.add(resultados.getString("Archivo"));
	}
	eDB.setCerrar(resultados);
	eDB.setCerrar();
	eDB.setCerrarConexion(); */
}catch(SQLException e){
	System.out.println("Error MySQL: ");
	e.printStackTrace(System.out);
}catch(NullPointerException e){
	System.out.println("Error Request: ");
	e.printStackTrace(System.out);
}
%>
<!doctype html>
<html>
<head>
	<title>Cloud-Cargo</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link rel="stylesheet" href="css/webix.css" type="text/css"> 
	<script src="js/webix.js" type="text/javascript"></script>

<style>
body {
	margin: 0px 0px 0px 0px;
}

</style>
</head>
<body>
<table  width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr height="50" background="imagenes/1x150_FondoMenu.png">
		<td width="10">&nbsp;</td>
		<%
		if (Admon.equals("MEX")){
		%>
			<td><img align="left" src="imagenes/200x150_BcoIntranetDAC.png" height="55"><img align="right" src="imagenes/200x150_BcoIntranetDAC2.png" height="55"></td>
		<%
		}else{
		%>
			<td><img src="imagenes/200x150_BcoIntranet.png" height="55"></td>
		<%
		}
		%>
		<td>&nbsp;</td>
	</tr>
	<tr height="15">
		<td colspan=3><img src="imagenes/1x15_SombraA.png" height="15" width="100%"></td>
	</tr>
</table>
<table>
	<tr><td>&nbsp;</td></tr>
</table>
<script>
function activaFuncion() {
}
</script>
</body>
</html>