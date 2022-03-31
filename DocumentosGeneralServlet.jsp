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
<%@ page import="Objetos.DocumentosGeneral"%>
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
private void imprimeJson(HttpServletResponse response, DocumentosGeneral objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<DocumentosGeneral> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(DocumentosGeneral objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("DocumentosGeneralServlet.jsp");
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
DocumentosGeneral objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new DocumentosGeneral();
		objeto.setArchivo(request.getParameter("Campo"));
		//objeto.setTitulo(request.getParameter("Campo"));
		//objeto.setFecha(request.getParameter("Campo"));

		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getTitulo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Titulo like '" + objeto.getTitulo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from DocumentosGeneral as A" + whereInicio + where.toString());
		ArrayList<DocumentosGeneral> info = new ArrayList<DocumentosGeneral>();
		while(resultados.next()) {
			objeto = new DocumentosGeneral();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setArchivo(resultados.getString("Archivo").replaceAll(" ","_"));
		objeto.setTitulo(resultados.getString("Titulo"));
		objeto.setFecha(resultados.getString("Fecha"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		String nombreArchivo = request.getParameter("Archivo").toString();
		nombreArchivo = nombreArchivo.replaceAll(" ","_");
		nombreArchivo = nombreArchivo.replaceAll("á","a");
		nombreArchivo = nombreArchivo.replaceAll("é","e");
		nombreArchivo = nombreArchivo.replaceAll("í","i");
		nombreArchivo = nombreArchivo.replaceAll("ó","o");
		nombreArchivo = nombreArchivo.replaceAll("ú","u");
		nombreArchivo = nombreArchivo.replaceAll("Á","A");
		nombreArchivo = nombreArchivo.replaceAll("É","E");
		nombreArchivo = nombreArchivo.replaceAll("Í","I");
		nombreArchivo = nombreArchivo.replaceAll("Ó","O");
		nombreArchivo = nombreArchivo.replaceAll("Ú","U");
		nombreArchivo = nombreArchivo.replaceAll("ñ","n");
		nombreArchivo = nombreArchivo.replaceAll("Ñ","N");
		nombreArchivo = nombreArchivo.replaceAll("ü","u");
		nombreArchivo = nombreArchivo.replaceAll("Ü","U");
		
		sentencia.executeUpdate("insert into DocumentosGeneral (U,G,E,Bloquear,Archivo,Titulo,Fecha) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + nombreArchivo + "','" + valoresDefault.getEntero(request.getParameter("Titulo")) + "','" + request.getParameter("Fecha") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into DocumentosGeneralApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Archivo,Titulo,Fecha) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Archivo,Titulo,Fecha from DocumentosGeneral where Id = '" + ultimoId + "'");
		objeto = new DocumentosGeneral();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			DocumentosGeneral[] ids = gson.fromJson(request.getParameter("Ids"), DocumentosGeneral[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into DocumentosGeneralApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Archivo,Titulo,Fecha) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Archivo,Titulo,Fecha from DocumentosGeneral where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from DocumentosGeneral where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			DocumentosGeneral ids = gson.fromJson(request.getParameter("Ids"), DocumentosGeneral.class);
			sentencia.executeUpdate("insert into DocumentosGeneralApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Archivo,Titulo,Fecha) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Archivo,Titulo,Fecha from DocumentosGeneral where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from DocumentosGeneral where Id = '" + ids.getId() + "'");
		}
		objeto = new DocumentosGeneral();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		String nombreArchivo = request.getParameter("Archivo").toString();
		nombreArchivo = nombreArchivo.replaceAll("á","a");
		nombreArchivo = nombreArchivo.replaceAll("é","e");
		nombreArchivo = nombreArchivo.replaceAll("í","i");
		nombreArchivo = nombreArchivo.replaceAll("ó","o");
		nombreArchivo = nombreArchivo.replaceAll("ú","u");
		nombreArchivo = nombreArchivo.replaceAll("Á","A");
		nombreArchivo = nombreArchivo.replaceAll("É","E");
		nombreArchivo = nombreArchivo.replaceAll("Í","I");
		nombreArchivo = nombreArchivo.replaceAll("Ó","O");
		nombreArchivo = nombreArchivo.replaceAll("Ú","U");
		nombreArchivo = nombreArchivo.replaceAll("ñ","n");
		nombreArchivo = nombreArchivo.replaceAll("Ñ","N");
		nombreArchivo = nombreArchivo.replaceAll("ü","u");
		nombreArchivo = nombreArchivo.replaceAll("Ü","U");
		
		sentencia.executeUpdate("update DocumentosGeneral set Archivo='" + nombreArchivo + "',Titulo='" + valoresDefault.getEntero(request.getParameter("Titulo")) + "',Fecha='" + request.getParameter("Fecha") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into DocumentosGeneralApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Archivo,Titulo,Fecha) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Archivo,Titulo,Fecha from DocumentosGeneral where Id = '" + request.getParameter("id") + "'");
		objeto = new DocumentosGeneral();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getDocumentosGeneral")) {
		resultados = sentencia.executeQuery("select Id, <columna> from DocumentosGeneral where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<DocumentosGeneral> info = new ArrayList<DocumentosGeneral>();
		while(resultados.next()) {
			objeto = new DocumentosGeneral();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new DocumentosGeneral();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new DocumentosGeneral();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* DocumentosGeneralServlet.jsp */
%>


