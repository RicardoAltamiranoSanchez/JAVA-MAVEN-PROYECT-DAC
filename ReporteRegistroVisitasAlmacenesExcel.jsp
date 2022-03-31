<%@ page import="Configuraciones.Propiedades"%><%@ page import="java.util.Properties"%><%@ page import="Libreria.MysqlPool" %><%@ page import="java.sql.ResultSet" %><%@ page import="java.sql.SQLException" %>
<%@ page import="Utilerias.Cantidades" %><%@ page import="Objetos.RegistroEntradasAlmacenes" %>
<%@ include file="valida.jsp" %>
<%response.setContentType("application/vnd.ms-excel");
response.setHeader("Cache-Control","no-cache");
response.setHeader("Content-Disposition", "attachment; filename=ReporteRegistroVisitas.xls");
Propiedades propiedades = new Propiedades();
String moduloIdioma = "141";
Properties idioma = (Properties)session.getAttribute("IdiomaGeneral");
Properties idiomaModulo = (Properties)session.getAttribute(moduloIdioma);
MysqlPool eDB;
ResultSet datos;
RegistroEntradasAlmacenes objeto;
eDB = new MysqlPool();
eDB.setConexion();
out.println("<table border=\"0\">");
out.println("<tr>");
out.println("<th>Visitante</th>");
out.println("<th>Gafete</th>");
out.println("<th>Entrada</th>");
out.println("<th>Prefijo</th>");
out.println("<th>Awb</th>");
out.println("<th>Observaciones</th>");
out.println("<th>Salida</th>");
out.println("<th>Duración en Almacén</th>");
out.println("</tr>");

StringBuffer where = new StringBuffer();
String whereInicio = " where A.Id < 0";
boolean entro = false;

eDB.setConexion();
objeto = new RegistroEntradasAlmacenes();
//objeto.setFecha(request.getParameter("Fecha"));
//objeto.setSerie(request.getParameter("Serie"));
//objeto.setFolio(request.getParameter("Folio"));
//objeto.setPrefijo(request.getParameter("Prefijo"));
//objeto.setAwb(request.getParameter("Awb"));
//objeto.setNombre(request.getParameter("Nombre"));
//objeto.setRfc(request.getParameter("Rfc"));
//objeto.setEstatus(request.getParameter("Estatus"));

/* if(!objeto.getFecha().equals("")) { entro = true;}
if(!objeto.getSerie().equals("")) { where.append(" and A.Serie = '" + objeto.getSerie() + "'"); entro = true;}
if(!objeto.getFolio().equals("")) { where.append(" and A.Folio = '" + objeto.getFolio() + "'"); entro = true;}
if(!objeto.getPrefijo().equals("")) { where.append(" and A.Prefijo = '" + objeto.getPrefijo() + "'"); entro = true;}
if(!objeto.getAwb().equals("")) { where.append(" and A.Mawb = '" + objeto.getAwb() + "'"); entro = true;}
if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
if(!objeto.getRfc().equals("")) { where.append(" and A.Rfc = '" + objeto.getRfc() + "'"); entro = true;}
if(entro) { whereInicio = " where A.Fecha >= '" + request.getParameter("Fecha") + "' and A.Fecha <= '" + request.getParameter("FechaA") + "'";} */

//String query = "select A.* from ReporteFacturacion as A" + whereInicio + where.toString();
//System.out.println(query);
datos = eDB.getQuery(""+
		"select A.Id, A.Nombre, A.Gafete, A.FechaHora as FechaHoraEntrada, B.Prefijo, B.Awb, B.Observaciones, B.FechaHora as FechaHoraSalida, CONCAT(Timediff(B.FechaHora,A.FechaHora),'') as TiempoAlmacen"+ 
		" from RegistroEntradasAlmacenes as A, RegistroSalidasAlmacenes as B" + /* whereInicio + where.toString() */"" + 
		" where B.Estacion = '"+request.getParameter("Estacion")+"' and B.IdRegistroEntradasAlmacenes = A.Id "+
		" and A.Nombre like if(@1:=(select Nombre from RegistroEntradasAlmacenes where Id='"+request.getParameter("IdRegistroEntradasAlmacenes")+"') is null,('%%'),(select Nombre from RegistroEntradasAlmacenes where Id='"+request.getParameter("IdRegistroEntradasAlmacenes")+"'))"+
		" and A.FechaHora >= if(@1:=('"+request.getParameter("AuxFecha")+"') = 'vacio',('0000-00-00 00:00:00'),('"+request.getParameter("Fecha")+" 00:00:00'))" +
		" and A.FechaHora <= if(@1:=('"+request.getParameter("FechaA")+"') = '',('9999-12-31 00:00:00'),('"+request.getParameter("FechaA")+" 00:00:00'))"); // FUNCIONA
	
	while(datos.next()) {
		out.print("<tr>");
		out.println("<td>" + datos.getString("Nombre") + "</td>");
		out.println("<td>" + datos.getString("Gafete") + "</td>");
		out.println("<td>" + datos.getString("FechaHoraEntrada") + "</td>");
		out.println("<td>" + datos.getString("Prefijo") + "</td>");
		out.println("<td>" + datos.getString("Awb") + "</td>");
		out.println("<td>" + datos.getString("Observaciones") + "</td>");
		out.println("<td>" + datos.getString("FechaHoraSalida") + "</td>");
		out.println("<td>" + datos.getString("TiempoAlmacen") + "</td>");
		out.print("</tr>");
	}
out.println("<tr><th>Fin de Reporte</th><tr>");
out.println("</table>");
eDB.setCerrarConexion();
%>