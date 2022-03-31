<%@ page import="Configuraciones.Propiedades"%><%@ page import="java.util.Properties"%><%@ page import="Libreria.MysqlPool" %><%@ page import="java.sql.ResultSet" %><%@ page import="java.sql.SQLException" %>
<%@ page import="Utilerias.Cantidades" %><%@ page import="Objetos.RegistroEntradasAlmacenes" %>
<%@ include file="valida.jsp" %>
<%response.setContentType("application/vnd.ms-excel");
response.setHeader("Cache-Control","no-cache");
response.setHeader("Content-Disposition", "attachment; filename=ReporteRegitstroChecadores.xls");
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
//out.println("<th>Número de Empleado</th>");
out.println("<th>Cuenta de Intranet</th>");
out.println("<th>Nombre</th>");
//out.println("<th>Registro</th>");
out.println("<th>Entrada</th>");
out.println("<th>Entrada Comida</th>");
out.println("<th>Salida Comida</th>");
out.println("<th>Salida</th>");
out.println("<th>Estacion</th>");
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
		"select A.Id, A.NumEmpleado, A.UsuarioIntranet, A.TipoRegistro, A.FechaHora, B.NombreCompleto as Nombre, CONCAT(A.FechaHora,'    Registró ',A.TipoRegistro) as Registro, A.Estacion"+
		" from RegistroChecadorEmpleados as A, Empleados as B, Usuarios as C"+ 
		" where FechaHora >= if(@1:=('"+request.getParameter("AuxFecha")+"') = 'vacio',('0000-00-00 00:00:00'),('"+request.getParameter("Fecha")+" 00:00:00'))"+
		" and A.FechaHora <= if(@1:=('"+request.getParameter("FechaA")+"') = '',('9999-12-31 00:00:00'),('"+request.getParameter("FechaA")+" 00:00:00'))"+
		" and A.Estacion like if(@1:=(select Estacion from RegistroChecadorEmpleados where Id = '"+request.getParameter("Estacion")+"') = '',('%%'),('%"+request.getParameter("Estacion")+"%'))"+
		" and A.UsuarioIntranet = C.Usuario"+
		" and B.IdUsuario = C.Id"+
		" order by Nombre, Registro");// FUNCIONA
	
		
		/*PROCESO ANTES DE CAMBIO DE FORMATO AL IMPLEMENTAR EL CHECADO DE LA COMIDA
		
	while(datos.next()) {
		String[] Momento = datos.getString("FechaHora").split(" ");
		String Fecha = Momento[0];
		String[] Horario = Momento [1].split(":");
		out.print("<tr>");
		//out.println("<td>" + datos.getString("NumEmpleado") + "</td>");
		out.println("<td>" + datos.getString("UsuarioIntranet") + "</td>");
		out.println("<td>" + datos.getString("Nombre") + "</td>");
		//out.println("<td>" + datos.getString("Registro") + "</td>");
		out.println("<td>" + datos.getString("TipoRegistro") + "</td>");
		out.println("<td>" + Fecha + "</td>");
		out.println("<td>" + Horario[0] + "</td>");
		out.println("<td>" + Horario[1]+":" +Horario[2]+ "</td>");
		out.println("<td>" + datos.getString("Estacion") + "</td>");
		out.print("</tr>");
	}*/
	String CuentaCompara = "";
	String FechaCompara ="";
	while(datos.next()) {
		String[] Momento = datos.getString("FechaHora").split(" ");
		String Fecha = Momento[0];
		String[] Horario = Momento [1].split(":");		
		
		
		if (!CuentaCompara.toUpperCase().equals(datos.getString("UsuarioIntranet").toUpperCase())){
			out.print("</tr>");
			out.print("<tr style='background-color: #2F2F2F;'>");
			out.print("</tr>");
			out.print("<tr>");
				out.println("<td style='font-weight:bold;font-size:30px;'>" + datos.getString("UsuarioIntranet") + "</td>");
				out.println("<td style='font-weight:bold;font-size:25px;'>" + datos.getString("Nombre") + "</td>");
			out.print("</tr>");
			out.print("<tr>");
				out.println("<td>"+Fecha+"</td>");
				out.println("<td>"+""+"</td>");
		}else{
			if (!FechaCompara.equals(Fecha)){
				out.print("</tr>");
				out.print("<tr style='background-color: #8E8E8E;height: 2px;'>");
				out.print("</tr>");
				out.print("<tr>");
				out.println("<td>"+Fecha+"</td>");
				out.println("<td>"+""+"</td>");
			}else{
				out.print("<tr>");
				out.println("<td>"+""+"</td>");
				out.println("<td>"+""+"</td>");
			}
		}
		String Evento = datos.getString("TipoRegistro");
		int TipoEvento = 0;
		if (Evento.equals("ENTRADA")){
			TipoEvento = 1;	
		}else if (Evento.equals("ENTRADA COMIDA")){
			TipoEvento = 2;	
		}else if (Evento.equals("SALIDA COMIDA")){
			TipoEvento = 3;	
		}else if (Evento.equals("SALIDA")){
			TipoEvento = 4;	
		}
		switch (TipoEvento){
			case 1: out.println("<td style='border-left: 3px solid black;border-right: 3px solid black;'>" + Horario[0]+":"+Horario[1] + "</td>");
					out.println("<td style='border-right: 3px solid black;background-color: #BEBEBE;'>" + "" + "</td>");
					out.println("<td style='border-right: 3px solid black;background-color: #BEBEBE;'>" + "" + "</td>");
					out.println("<td style='border-right: 3px solid black;'>" + "" + "</td>");
	        break;
			case 2: out.println("<td style='border-left: 3px solid black;border-right: 3px solid black;'>" + "" + "</td>");
					out.println("<td style='border-right: 3px solid black;background-color: #BEBEBE;'>" +Horario[0]+":"+Horario[1]+ "</td>");
					out.println("<td style='border-right: 3px solid black;background-color: #BEBEBE;'>" + "" + "</td>");
					out.println("<td style='border-right: 3px solid black;'>" + "" + "</td>");
	        break;
			case 3: out.println("<td style='border-left: 3px solid black;border-right: 3px solid black;'>" + "" + "</td>");
					out.println("<td style='border-right: 3px solid black;background-color: #BEBEBE;'>" + "" + "</td>");
					out.println("<td style='border-right: 3px solid black;background-color: #BEBEBE;'>" + Horario[0]+":"+Horario[1] + "</td>");
					out.println("<td style='border-right: 3px solid black;'>" + "" + "</td>");
	        break;
			case 4: out.println("<td style='border-left: 3px solid black;border-right: 3px solid black;'>" + "" + "</td>");
					out.println("<td style='border-right: 3px solid black;background-color: #BEBEBE;'>" + "" + "</td>");
					out.println("<td style='border-right: 3px solid black;background-color: #BEBEBE;'>" + "" + "</td>");
					out.println("<td style='border-right: 3px solid black;'>" + Horario[0]+":"+Horario[1] + "</td>");			
	        break;		
		}
		
		out.println("<td>" + datos.getString("Estacion") + "</td>");
		CuentaCompara = datos.getString("UsuarioIntranet");
		FechaCompara = Fecha;
	}	
		
out.println("<tr><th>Fin de Reporte</th><tr>");
out.println("</table>");
eDB.setCerrarConexion();
%>