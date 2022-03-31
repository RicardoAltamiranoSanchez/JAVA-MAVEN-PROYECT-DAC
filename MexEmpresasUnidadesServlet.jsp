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
<%@ page import="Objetos.MexEmpresasUnidades"%>
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
private void imprimeJson(HttpServletResponse response, MexEmpresasUnidades objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MexEmpresasUnidades> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MexEmpresasUnidades objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MexEmpresasUnidadesServlet.jsp");
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
MexEmpresasUnidades objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexEmpresasUnidades();
		objeto.setIdAreas(request.getParameter("Campo"));
		//objeto.setUnidad(request.getParameter("Campo"));

		if(!objeto.getIdAreas().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdAreas like '" + objeto.getIdAreas() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getUnidad().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Unidad like '" + objeto.getUnidad() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from MexEmpresasUnidades as A" + whereInicio + where.toString());
		ArrayList<MexEmpresasUnidades> info = new ArrayList<MexEmpresasUnidades>();
		while(resultados.next()) {
			objeto = new MexEmpresasUnidades();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdAreas(resultados.getString("IdAreas"));
		objeto.setUnidad(resultados.getString("Unidad"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into MexEmpresasUnidades (U,G,E,Bloquear,IdAreas,Unidad) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdAreas")) + "','" + request.getParameter("Unidad") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into MexEmpresasUnidadesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdAreas,Unidad) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdAreas,Unidad from MexEmpresasUnidades where Id = '" + ultimoId + "'");
		objeto = new MexEmpresasUnidades();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			MexEmpresasUnidades[] ids = gson.fromJson(request.getParameter("Ids"), MexEmpresasUnidades[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into MexEmpresasUnidadesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdAreas,Unidad) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdAreas,Unidad from MexEmpresasUnidades where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from MexEmpresasUnidades where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			MexEmpresasUnidades ids = gson.fromJson(request.getParameter("Ids"), MexEmpresasUnidades.class);
			sentencia.executeUpdate("insert into MexEmpresasUnidadesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdAreas,Unidad) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdAreas,Unidad from MexEmpresasUnidades where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from MexEmpresasUnidades where Id = '" + ids.getId() + "'");
		}
		objeto = new MexEmpresasUnidades();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update MexEmpresasUnidades set IdAreas='" + valoresDefault.getEntero(request.getParameter("IdAreas")) + "',Unidad='" + request.getParameter("Unidad") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into MexEmpresasUnidadesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdAreas,Unidad) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdAreas,Unidad from MexEmpresasUnidades where Id = '" + request.getParameter("id") + "'");
		objeto = new MexEmpresasUnidades();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getMexEmpresasUnidades")) {
		resultados = sentencia.executeQuery("select Id, Unidad from MexEmpresasUnidades where IdAreas like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<MexEmpresasUnidades> info = new ArrayList<MexEmpresasUnidades>();
		while(resultados.next()) {
			objeto = new MexEmpresasUnidades();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Unidad"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new MexEmpresasUnidades();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MexEmpresasUnidades();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MexEmpresasUnidadesServlet.jsp */
%>



