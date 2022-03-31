<%@ page import="Configuraciones.Propiedades"%><%@ page import="java.util.Properties"%><%@ page import="Libreria.MysqlPool" %><%@ page import="java.sql.ResultSet" %><%@ page import="java.sql.SQLException" %>
<%@ page import="Utilerias.Cantidades" %><%@ page import="Objetos.Credenciales" %>
<%@ include file="valida.jsp" %>
<%response.setContentType("application/vnd.ms-excel");
response.setHeader("Cache-Control","no-cache");
response.setHeader("Content-Disposition", "attachment; filename=Credenciales.xls");
Propiedades propiedades = new Propiedades();
String moduloIdioma = "141";
Properties idioma = (Properties)session.getAttribute("IdiomaGeneral");
Properties idiomaModulo = (Properties)session.getAttribute(moduloIdioma);
MysqlPool eDB;
ResultSet datos;
Credenciales objeto;
eDB = new MysqlPool();
eDB.setConexion();
out.println("<table border=\"0\">");
out.println("<tr>");
out.println("<th>Nombre Completo</th>");
out.println("<th>Correo Electronico</th>");
out.println("<th>Telefono</th>");
out.println("<th>Domicilio</th>");
out.println("<th>Pagina Web</th>");
out.println("<th>Puesto</th>");
out.println("<th>Empresa</th>");
out.println("<th>Estacion</th>");
out.println("<th>IMSS</th>");
out.println("<th>CURP</th>");
out.println("<th>Antiguedad</th>");
out.println("<th>Vigencia</th>");
out.println("</tr>");

StringBuffer where = new StringBuffer();
String whereInicio = " where C.Id > 0";
boolean entro = false;

eDB.setConexion();
objeto = new Credenciales();
objeto.setIdEmpleados(request.getParameter("IdEmpleados"));
if(request.getParameter("NombreCompleto") == null){
	objeto.setNombreCompleto("");
}else{
	objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
}
//DEBUGSystem.out.println(objeto.getNombreCompleto());
objeto.setCorreoElectronico(request.getParameter("CorreoElectronico"));
objeto.setTelefono(request.getParameter("Telefono"));
objeto.setDomicilio(request.getParameter("Domicilio"));
objeto.setPaginaWeb(request.getParameter("PaginaWeb"));
objeto.setPuesto(request.getParameter("Puesto"));
objeto.setEmpresa(request.getParameter("Empresa"));
objeto.setEstacion(request.getParameter("Estacion"));
objeto.setIMSS(request.getParameter("IMSS"));
objeto.setCURP(request.getParameter("CURP"));
//DEBUGSystem.out.println(request.getParameter("Antiguedad"));
objeto.setAntiguedad(request.getParameter("Antiguedad"));
objeto.setFechaVigencia(request.getParameter("FechaVigencia"));

if(request.getParameter("Antiguedad").equals("null")){
	//DEBUGSystem.out.println("Si fue null anti");
	objeto.setAntiguedad("");
}

if(request.getParameter("FechaVigencia").equals("null")){
	//DEBUGSystem.out.println("Si fue null vigen");
	objeto.setFechaVigencia("");
}

if(!objeto.getNombreCompleto().equals("")) { where.append(" and C.NombreCompleto like '" + objeto.getNombreCompleto() + "%'"); entro = true;}
if(!objeto.getCorreoElectronico().equals("")) { where.append(" and C.CorreoElectronico like '" + objeto.getCorreoElectronico() + "%'"); entro = true;}
if(!objeto.getTelefono().equals("")) { where.append(" and C.Telefono like '" + objeto.getTelefono() + "%'"); entro = true;}
if(!objeto.getDomicilio().equals("")) { where.append(" and C.Domicilio like '" + objeto.getDomicilio() + "%'"); entro = true;}
if(!objeto.getPaginaWeb().equals("")) { where.append(" and C.PaginaWeb like '" + objeto.getPaginaWeb() + "%'"); entro = true;}
if(!objeto.getPuesto().equals("")) { where.append(" and C.Puesto like '" + objeto.getPuesto() + "%'"); entro = true;}
if(!objeto.getEmpresa().equals("")) { where.append(" and C.Empresa like '" + objeto.getEmpresa() + "%'"); entro = true;}
if(!objeto.getEstacion().equals("")) { where.append(" and C.Estacion like '" + objeto.getEstacion() + "%'"); entro = true;}
if(!objeto.getIMSS().equals("")) { where.append(" and C.IMSS like '" + objeto.getIMSS() + "%'"); entro = true;}
if(!objeto.getCURP().equals("")) { where.append(" and C.CURP like '" + objeto.getCURP() + "%'"); entro = true;}
if(!objeto.getAntiguedad().equals("")) { where.append(" and C.Antiguedad like '" + objeto.getAntiguedad() + "%'"); entro = true;}
if(!objeto.getFechaVigencia().equals("")) { where.append(" and C.FechaVigencia like '" + objeto.getFechaVigencia() + "%'"); entro = true;}


//DEBUGSystem.out.println("select C.*,IF(C.FechaEmision = '0000-00-00','',C.FechaEmision) as FechaE, IF(C.FechaVigencia = '0000-00-00','',C.FechaVigencia) as FechaV  from Credenciales as C" + whereInicio + where.toString()+" and C.Admon = (select EG.Admon as Admon from EmpresasGrupo as EG, Empleados as E, Usuarios as U where E.IdUsuario = U.Id and E.Division = EG.Id and U.Id = '" + session.getAttribute("IdUsuario") + "')");
String query = "select C.*,IF(C.FechaEmision = '0000-00-00','',C.FechaEmision) as FechaE, IF(C.FechaVigencia = '0000-00-00','',C.FechaVigencia) as FechaV  from Credenciales as C" + whereInicio + where.toString()+" and C.Admon = (select EG.Admon as Admon from EmpresasGrupo as EG, Empleados as E, Usuarios as U where E.IdUsuario = U.Id and E.Division = EG.Id and U.Id = '" + session.getAttribute("IdUsuario") + "')";
datos = eDB.getQuery(query);
	
	while(datos.next()) {
		out.print("<tr>");
		out.println("<td>" + datos.getString("NombreCompleto") + "</td>");
		out.println("<td>" + datos.getString("CorreoElectronico") + "</td>");
		out.println("<td>" + datos.getString("Telefono") + "</td>");
		out.println("<td>" + datos.getString("Domicilio") + "</td>");
		out.println("<td>" + datos.getString("PaginaWeb") + "</td>");
		out.println("<td>" + datos.getString("Puesto") + "</td>");
		out.println("<td>" + datos.getString("Empresa") + "</td>");
		out.println("<td>" + datos.getString("Estacion") + "</td>");
		out.println("<td>" + datos.getString("IMSS") + "</td>");
		out.println("<td>" + datos.getString("CURP") + "</td>");
		out.println("<td>" + datos.getString("Antiguedad") + "</td>");
		out.println("<td>" + datos.getString("FechaVigencia") + "</td>");
		out.print("</tr>");
	}
out.println("<tr><th>Fin de Reporte</th><tr>");
out.println("</table>");
eDB.setCerrarConexion();
%>