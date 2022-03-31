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
<%@ page import="Objetos.AreasLaborales"%>
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
private void imprimeJson(HttpServletResponse response, AreasLaborales objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<AreasLaborales> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(AreasLaborales objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("AreasLaboralesServlet.jsp");
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
AreasLaborales objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new AreasLaborales();
		objeto.setNombre(request.getParameter("Campo"));

		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from AreasLaborales as A" + whereInicio + where.toString());
		ArrayList<AreasLaborales> info = new ArrayList<AreasLaborales>();
		while(resultados.next()) {
			objeto = new AreasLaborales();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setNombre(resultados.getString("Nombre"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into AreasLaborales (U,G,E,Bloquear,Nombre) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + request.getParameter("Nombre") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into AreasLaboralesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Nombre from AreasLaborales where Id = '" + ultimoId + "'");
		objeto = new AreasLaborales();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			AreasLaborales[] ids = gson.fromJson(request.getParameter("Ids"), AreasLaborales[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into AreasLaboralesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Nombre from AreasLaborales where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from AreasLaborales where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			AreasLaborales ids = gson.fromJson(request.getParameter("Ids"), AreasLaborales.class);
			sentencia.executeUpdate("insert into AreasLaboralesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Nombre from AreasLaborales where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from AreasLaborales where Id = '" + ids.getId() + "'");
		}
		objeto = new AreasLaborales();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update AreasLaborales set Nombre='" + request.getParameter("Nombre") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into AreasLaboralesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Nombre from AreasLaborales where Id = '" + request.getParameter("id") + "'");
		objeto = new AreasLaborales();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getAreasLaborales")) {
		resultados = sentencia.executeQuery("select Id, Nombre from AreasLaborales where Nombre like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<AreasLaborales> info = new ArrayList<AreasLaborales>();
		while(resultados.next()) {
			objeto = new AreasLaborales();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Nombre"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new AreasLaborales();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new AreasLaborales();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* AreasLaboralesServlet.jsp */
%>



