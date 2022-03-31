<%@ page import="java.io.IOException"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="javax.sql.DataSource"%>
<%@ page import="Configuraciones.BaseDeDatosPool"%>
<%@ page import="Configuraciones.Generales"%>
<%@ page import="Configuraciones.Seguridad"%>
<%@ page import="Utilerias.Fechas"%>
<%@ page import="Utilerias.ValoresDefault"%>
<%@ page import="Objetos.DivisionesAsignacion"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.JsonSyntaxException"%>
<%!
HttpSession session;
DataSource datasource;
BaseDeDatosPool dbConf;
Generales generales;
Seguridad seguridad;
Gson gson;
Fechas fechas;
ValoresDefault valoresDefault;

public void jspInit() {
	try {
		BaseDeDatosPool dbConf = new BaseDeDatosPool();
		Context initContext = new InitialContext();
		Context envContext = (Context)initContext.lookup("java:/comp/env");
		datasource = (DataSource)envContext.lookup(dbConf.getDatabase());
		generales = new Generales();
		seguridad = new Seguridad();
		valoresDefault = new ValoresDefault();
	} catch(NamingException e) {
		System.out.println("Driver: " + e);
	}
}
private void validar(HttpServletRequest request, HttpServletResponse response) throws IOException {
	session = request.getSession();
	try {
		try {
			session.getAttribute("Usuario").equals("");
			if(session.getAttribute("Usuario").equals("")) {
				response.sendRedirect("/" + generales.getDirectorio() + "/index.jsp");
			}
		} catch(NullPointerException e) {
			response.sendRedirect("/" + generales.getDirectorio() + "/index.jsp");
		}
	} catch(IllegalStateException e) {
		response.setHeader("Location","/" + generales.getDirectorio() + "/index.jsp");
	}
}
private void imprimeJson(HttpServletResponse response, DivisionesAsignacion objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<DivisionesAsignacion> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(DivisionesAsignacion objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("DivisionesAsignacionServlet.jsp");
	log.append(" Evento:");
	log.append(fechas.getKey());
	log.append(" ");
	System.out.print(log.toString());
	e.printStackTrace(System.out);
	log.append(e.getMessage());
	objeto.setLog(log.toString());
}
%>
<%
request.setCharacterEncoding("UTF-8");
validar(request,response);
Connection conexion = null;
Statement sentencia = null;
ResultSet resultados = null;
DivisionesAsignacion objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		//String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and E.Id = A.IdEmpleados and A.IdDivisionesEmpleados = DE.Id order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new DivisionesAsignacion();
		objeto.setIdDivisionesEmpleados(request.getParameter("Campo"));
		objeto.setNombreDivisionesEmpleados(request.getParameter("Campo"));
		objeto.setIdEmpleados(request.getParameter("Campo"));
		objeto.setNombreEmpleados(request.getParameter("Campo"));

		if(!objeto.getIdDivisionesEmpleados().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdDivisionesEmpleados = '" + objeto.getIdDivisionesEmpleados() + "'"); entro = true; agregaOr = true;}
		if(!objeto.getNombreDivisionesEmpleados().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" DE.Nombre like '%" + objeto.getNombreDivisionesEmpleados() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getIdEmpleados().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdEmpleados = '" + objeto.getIdEmpleados() + "'"); entro = true; agregaOr = true;}
		if(!objeto.getNombreEmpleados().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" E.NombreCompleto like '%" + objeto.getNombreEmpleados() + "%'"); entro = true; agregaOr = true;}
		//if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and E.Id = A.IdEmpleados and A.IdDivisionesEmpleados = DE.Id and ("; where.append(")");}

		//resultados = sentencia.executeQuery("select A.* from DivisionesAsignacion as A" + whereInicio + where.toString());
		//DEBUGSystem.out.println("select A.*, E.NombreCompleto as Empleado, DE.Nombre as Division from DivisionesAsignacion as A, Empleados as E, DivisionesEmpleados as DE" + whereInicio + where.toString());
		//DEBUGSystem.out.println("Where inicio "+whereInicio+" Where "+where.toString());
		resultados = sentencia.executeQuery("select A.*, E.NombreCompleto as Empleado, DE.Nombre as Division from DivisionesAsignacion as A, Empleados as E, DivisionesEmpleados as DE" + whereInicio + where.toString());
		ArrayList<DivisionesAsignacion> info = new ArrayList<DivisionesAsignacion>();
		while(resultados.next()) {
			objeto = new DivisionesAsignacion();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdDivisionesEmpleados(resultados.getString("IdDivisionesEmpleados"));
		objeto.setNombreDivisionesEmpleados(resultados.getString("Division"));
		objeto.setIdEmpleados(resultados.getString("IdEmpleados"));
		objeto.setNombreEmpleados(resultados.getString("Empleado"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	
	if(request.getParameter("Accion").equals("BuscarCHECAR")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new DivisionesAsignacion();
		objeto.setIdDivisionesEmpleados(request.getParameter("Campo"));
		//objeto.setIdEmpleados(request.getParameter("Campo"));

		if(!objeto.getIdDivisionesEmpleados().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdDivisionesEmpleados like '" + objeto.getIdDivisionesEmpleados() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getIdEmpleados().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdEmpleados like '" + objeto.getIdEmpleados() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and E.Id = A.IdEmpleados and A.IdDivisionesEmpleados = DE.Id and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.*, E.NombreCompleto as Empleado, DE.Nombre as Division from DivisionesAsignacion as A, Empleados as E, DivisionesEmpleados as DE" + whereInicio + where.toString());
		ArrayList<DivisionesAsignacion> info = new ArrayList<DivisionesAsignacion>();
		while(resultados.next()) {
			objeto = new DivisionesAsignacion();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdDivisionesEmpleados(resultados.getString("Division"));
		objeto.setIdEmpleados(resultados.getString("Empleado"));
			info.add(objeto);
		}
		
		imprimeJson(response,info);
	}
	
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into DivisionesAsignacion (U,G,E,Bloquear,IdDivisionesEmpleados,IdEmpleados) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdDivisionesEmpleados")) + "','" + valoresDefault.getEntero(request.getParameter("IdEmpleados")) + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into DivisionesAsignacionApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdDivisionesEmpleados,IdEmpleados) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdDivisionesEmpleados,IdEmpleados from DivisionesAsignacion where Id = '" + ultimoId + "'");
		objeto = new DivisionesAsignacion();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			DivisionesAsignacion[] ids = gson.fromJson(request.getParameter("Ids"), DivisionesAsignacion[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into DivisionesAsignacionApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdDivisionesEmpleados,IdEmpleados) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdDivisionesEmpleados,IdEmpleados from DivisionesAsignacion where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from DivisionesAsignacion where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			DivisionesAsignacion ids = gson.fromJson(request.getParameter("Ids"), DivisionesAsignacion.class);
			sentencia.executeUpdate("insert into DivisionesAsignacionApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdDivisionesEmpleados,IdEmpleados) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdDivisionesEmpleados,IdEmpleados from DivisionesAsignacion where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from DivisionesAsignacion where Id = '" + ids.getId() + "'");
		}
		objeto = new DivisionesAsignacion();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update DivisionesAsignacion set IdDivisionesEmpleados='" + valoresDefault.getEntero(request.getParameter("IdDivisionesEmpleados")) + "',IdEmpleados='" + valoresDefault.getEntero(request.getParameter("IdEmpleados")) + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into DivisionesAsignacionApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdDivisionesEmpleados,IdEmpleados) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdDivisionesEmpleados,IdEmpleados from DivisionesAsignacion where Id = '" + request.getParameter("id") + "'");
		objeto = new DivisionesAsignacion();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getDivisionesAsignacion")) {
		resultados = sentencia.executeQuery("select Id, <columna> from DivisionesAsignacion where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<DivisionesAsignacion> info = new ArrayList<DivisionesAsignacion>();
		while(resultados.next()) {
			objeto = new DivisionesAsignacion();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new DivisionesAsignacion();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new DivisionesAsignacion();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* DivisionesAsignacionServlet.jsp */
%>



