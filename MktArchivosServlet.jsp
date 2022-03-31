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
<%@ page import="Objetos.MktArchivos"%>
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
private void imprimeJson(HttpServletResponse response, MktArchivos objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MktArchivos> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MktArchivos objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MktArchivosServlet.jsp");
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
MktArchivos objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MktArchivos();
		objeto.setArchivo(request.getParameter("Campo"));
		//objeto.setIdMktTipoArchivo(request.getParameter("Campo"));
		//objeto.setVistaPrevia(request.getParameter("Campo"));

		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getIdMktTipoArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdMktTipoArchivo like '" + objeto.getIdMktTipoArchivo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getVistaPrevia().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.VistaPrevia like '" + objeto.getVistaPrevia() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from MktArchivos as A" + whereInicio + where.toString());
		ArrayList<MktArchivos> info = new ArrayList<MktArchivos>();
		while(resultados.next()) {
			objeto = new MktArchivos();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setArchivo(resultados.getString("Archivo"));
		objeto.setIdMktTipoArchivo(resultados.getString("IdMktTipoArchivo"));
		objeto.setVistaPrevia(resultados.getString("VistaPrevia"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into MktArchivos (U,G,E,Bloquear,Archivo,IdMktTipoArchivo,VistaPrevia) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + request.getParameter("Archivo") + "','" + valoresDefault.getEntero(request.getParameter("IdMktTipoArchivo")) + "','" + request.getParameter("VistaPrevia") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into MktArchivosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Archivo,IdMktTipoArchivo,VistaPrevia) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Archivo,IdMktTipoArchivo,VistaPrevia from MktArchivos where Id = '" + ultimoId + "'");
		objeto = new MktArchivos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			MktArchivos[] ids = gson.fromJson(request.getParameter("Ids"), MktArchivos[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into MktArchivosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Archivo,IdMktTipoArchivo,VistaPrevia) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Archivo,IdMktTipoArchivo,VistaPrevia from MktArchivos where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from MktArchivos where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			MktArchivos ids = gson.fromJson(request.getParameter("Ids"), MktArchivos.class);
			sentencia.executeUpdate("insert into MktArchivosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Archivo,IdMktTipoArchivo,VistaPrevia) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Archivo,IdMktTipoArchivo,VistaPrevia from MktArchivos where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from MktArchivos where Id = '" + ids.getId() + "'");
		}
		objeto = new MktArchivos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update MktArchivos set Archivo='" + request.getParameter("Archivo") + "',IdMktTipoArchivo='" + valoresDefault.getEntero(request.getParameter("IdMktTipoArchivo")) + "',VistaPrevia='" + request.getParameter("VistaPrevia") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into MktArchivosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Archivo,IdMktTipoArchivo,VistaPrevia) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Archivo,IdMktTipoArchivo,VistaPrevia from MktArchivos where Id = '" + request.getParameter("id") + "'");
		objeto = new MktArchivos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getMktArchivos")) {
		resultados = sentencia.executeQuery("select Id, <columna> from MktArchivos where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<MktArchivos> info = new ArrayList<MktArchivos>();
		while(resultados.next()) {
			objeto = new MktArchivos();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new MktArchivos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MktArchivos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MktArchivosServlet.jsp */
%>


