<%@ page import="Configuraciones.Propiedades"%><%@ page import="java.util.Properties"%><%@ page import="Libreria.MysqlPool" %><%@ page import="java.sql.ResultSet" %><%@ page import="java.sql.SQLException" %>
<%@ page import="Utilerias.Cantidades" %><%@ page import="Objetos.Empleados" %>
<%@ include file="valida.jsp" %>
<%response.setContentType("application/vnd.ms-excel");
response.setHeader("Cache-Control","no-cache");
response.setHeader("Content-Disposition", "attachment; filename=Empleados.xls");
Propiedades propiedades = new Propiedades();
String moduloIdioma = "141";
Properties idioma = (Properties)session.getAttribute("IdiomaGeneral");
Properties idiomaModulo = (Properties)session.getAttribute(moduloIdioma);
MysqlPool eDB;
ResultSet datos;
Empleados objeto;
eDB = new MysqlPool();
eDB.setConexion();
out.println("<table border=\"0\">");
out.println("<tr>");
out.println("<th>Numero de Empleado</th>");
out.println("<th>Nombre Completo</th>");
out.println("<th>CURP</th>");
out.println("<th>Puesto</th>");
out.println("<th>Division</th>");
out.println("<th>Fecha de Ingreso</th>");
out.println("<th>Estatus</th>");
out.println("<th>Jefe Directo</th>");
out.println("<th>Vacaciones</th>");
out.println("</tr>");

StringBuffer where = new StringBuffer();
String whereInicio = " where A.Id > 0";
boolean entro = false;

eDB.setConexion();
objeto = new Empleados();
objeto.setNumeroEmpleado(request.getParameter("NumeroEmpleado"));
if(request.getParameter("NombreCompleto") == null){
	objeto.setNombreCompleto("");
}else{
	objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
}
//DEBUGSystem.out.println(objeto.getNombreCompleto());
objeto.setPuesto(request.getParameter("Puesto"));
objeto.setDivision(request.getParameter("Division"));
objeto.setFechaIngreso(request.getParameter("FechaIngreso"));
objeto.setEstatus(request.getParameter("Estatus"));
objeto.setIdJefeDirecto(request.getParameter("IdJefeDirecto"));
objeto.setVacaciones(request.getParameter("Vacaciones"));

if(!objeto.getNumeroEmpleado().equals("")) { where.append(" and A.NumeroEmpleado = '" + objeto.getNumeroEmpleado() + "'"); entro = true;}
if(!objeto.getNombreCompleto().equals("")) { where.append(" and A.NombreCompleto like '" + objeto.getNombreCompleto() + "%'"); entro = true;}
if(!objeto.getPuesto().equals("")) { where.append(" and A.Puesto like '" + objeto.getPuesto() + "%'"); entro = true;}
if(!objeto.getDivision().equals("")) { where.append(" and A.Division = '" + objeto.getDivision() + "'"); entro = true;}
if(!objeto.getEstacion().equals("")) { where.append(" and A.Estacion like '" + objeto.getEstacion() + "%'"); entro = true;}
if(!objeto.getFechaIngreso().equals("null")) { where.append(" and A.FechaIngreso = '" + objeto.getFechaIngreso() + "'"); entro = true;}
if(!objeto.getEstatus().equals("")) { where.append(" and A.Estatus = '" + objeto.getEstatus() + "'"); entro = true;}
if(!objeto.getIdJefeDirecto().equals("")) { where.append(" and A.IdJefeDirecto = '" + objeto.getIdJefeDirecto() + "'"); entro = true;}
/* if(!objeto.getVacaciones().equals("")) { where.append(" and A.Vacaciones= '" + objeto.getVacaciones() + "'"); entro = true;} */

//ANTES DIVISION
//String query = "select A.*,(Select Nombre from Usuarios where Id = A.IdJefeDirecto) as Jefe, (Select Nombre from EmpresasGrupo where Id = A.Division) as Empresa from Empleados as A left join EmpresasGrupo as EG on (EG.Id = A.Division) left join Usuarios as U on (U.Id = A.IdUsuario)" + whereInicio + where.toString();
//DIVISION
//DEBUGSystem.out.println("select A.*,(Select Nombre from Usuarios where Id = A.IdJefeDirecto) as Jefe, (Select Nombre from EmpresasGrupo where Id = A.Division) as Empresa from Empleados as A left join EmpresasGrupo as EG on (EG.Id = A.Division) left join Usuarios as U on (U.Id = A.IdUsuario)" + whereInicio + where.toString() + "and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'))");
String query = "select A.*,(Select Nombre from Usuarios where Id = A.IdJefeDirecto) as Jefe, (Select Nombre from EmpresasGrupo where Id = A.Division) as Empresa from Empleados as A left join EmpresasGrupo as EG on (EG.Id = A.Division) left join Usuarios as U on (U.Id = A.IdUsuario)" + whereInicio + where.toString() + "and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'))";
datos = eDB.getQuery(query);
	
	while(datos.next()) {
		out.print("<tr>");
		out.println("<td>" + datos.getString("NumeroEmpleado") + "</td>");
		out.println("<td>" + datos.getString("NombreCompleto") + "</td>");
		out.println("<td>" + datos.getString("CURP") + "</td>");
		out.println("<td>" + datos.getString("Puesto") + "</td>");
		out.println("<td>" + datos.getString("Empresa") + "</td>");
		out.println("<td>" + datos.getString("FechaIngreso") + "</td>");
		out.println("<td>" + datos.getString("Estatus") + "</td>");
		out.println("<td>" + datos.getString("Jefe") + "</td>");
		out.println("<td>" + datos.getString("Vacaciones") + "</td>");
		out.print("</tr>");
	}
out.println("<tr><th>Fin de Reporte</th><tr>");
out.println("</table>");
eDB.setCerrarConexion();
%>