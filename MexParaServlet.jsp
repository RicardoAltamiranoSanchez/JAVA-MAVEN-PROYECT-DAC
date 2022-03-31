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
<%@ page import="Configuraciones.BaseDeDatos"%>
<%@ page import="Configuraciones.Generales"%>
<%@ page import="Configuraciones.Seguridad"%>
<%@ page import="Utilerias.Fechas"%>
<%@ page import="Utilerias.ValoresDefault"%>
<%@ page import="Objetos.MexPara"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.JsonSyntaxException"%>
<%!
HttpSession session;
DataSource datasource;
BaseDeDatos dbConf;
Generales generales;
Seguridad seguridad;
Gson gson;
Fechas fechas;
ValoresDefault valoresDefault;

public void jspInit() {
	try {
		BaseDeDatos dbConf = new BaseDeDatos();
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
private void imprimeJson(HttpServletResponse response, MexPara objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MexPara> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MexPara objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MexParaServlet.jsp");
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
MexPara objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and U.Id = A.IdUsuarios order by U.Nombre";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexPara();
		objeto.setIdUsuarios(request.getParameter("Campo"));

		if(!objeto.getIdUsuarios().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdUsuarios like '" + objeto.getIdUsuarios() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and U.Id = A.IdUsuarios and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.*, U.Nombre from MexPara as A, Usuarios as U" + whereInicio + where.toString());
		ArrayList<MexPara> info = new ArrayList<MexPara>();
		while(resultados.next()) {
			objeto = new MexPara();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setIdUsuarios(resultados.getString("IdUsuarios"));
			objeto.setUsuarios(resultados.getString("Nombre"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into MexPara (U,G,E,Bloquear,IdUsuarios) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdUsuarios")) + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into MexParaApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdUsuarios) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdUsuarios from MexPara where Id = '" + ultimoId + "'");
		objeto = new MexPara();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			MexPara[] ids = gson.fromJson(request.getParameter("Ids"), MexPara[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into MexParaApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdUsuarios) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdUsuarios from MexPara where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from MexPara where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			MexPara ids = gson.fromJson(request.getParameter("Ids"), MexPara.class);
			sentencia.executeUpdate("insert into MexParaApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdUsuarios) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdUsuarios from MexPara where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from MexPara where Id = '" + ids.getId() + "'");
		}
		objeto = new MexPara();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update MexPara set IdUsuarios='" + valoresDefault.getEntero(request.getParameter("IdUsuarios")) + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into MexParaApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdUsuarios) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdUsuarios from MexPara where Id = '" + request.getParameter("id") + "'");
		objeto = new MexPara();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getMexPara")) {
		resultados = sentencia.executeQuery("select A.Id, A.IdUsuarios, U.Nombre from MexPara A, Usuarios U where U.Id = A.IdUsuarios and A.IdUsuarios like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<MexPara> info = new ArrayList<MexPara>();
		while(resultados.next()) {
			objeto = new MexPara();
			objeto.setId(resultados.getString("IdUsuarios"));
			objeto.setValue(resultados.getString("Nombre"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getMexParaNombre")) {
		resultados = sentencia.executeQuery("select A.Id, A.IdUsuarios, U.Nombre from MexPara A, Usuarios U where U.Id = A.IdUsuarios and A.IdUsuarios like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<MexPara> info = new ArrayList<MexPara>();
		while(resultados.next()) {
			objeto = new MexPara();
			objeto.setId(resultados.getString("Nombre"));
			objeto.setValue(resultados.getString("Nombre"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new MexPara();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MexPara();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MexParaServlet.jsp */
%>



