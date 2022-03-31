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
<%@ page import="Objetos.ProveedoresDoc"%>
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
private void imprimeJson(HttpServletResponse response, ProveedoresDoc objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<ProveedoresDoc> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(ProveedoresDoc objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("ProveedoresDocServlet.jsp");
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
ProveedoresDoc objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new ProveedoresDoc();
		objeto.setIdProveedores(request.getParameter("Campo"));
		//objeto.setDocumento(request.getParameter("Campo"));
		//objeto.setArchivo(request.getParameter("Campo"));

		if(!objeto.getIdProveedores().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdProveedores like '" + objeto.getIdProveedores() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getDocumento().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Documento like '" + objeto.getDocumento() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from ProveedoresDoc as A" + whereInicio + where.toString());
		ArrayList<ProveedoresDoc> info = new ArrayList<ProveedoresDoc>();
		while(resultados.next()) {
			objeto = new ProveedoresDoc();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdProveedores(resultados.getString("IdProveedores"));
		objeto.setDocumento(resultados.getString("Documento"));
		objeto.setArchivo(resultados.getString("Archivo"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		
		String nombreArchivo =request.getParameter("Archivo").replaceAll(" ", "_");
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
		
		sentencia.executeUpdate("insert into ProveedoresDoc (U,G,E,Bloquear,IdProveedores,Documento,Archivo) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdProveedores")) + "','" + request.getParameter("Documento") + "','" + nombreArchivo + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into ProveedoresDocApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdProveedores,Documento,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdProveedores,Documento,Archivo from ProveedoresDoc where Id = '" + ultimoId + "'");
		objeto = new ProveedoresDoc();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			ProveedoresDoc[] ids = gson.fromJson(request.getParameter("Ids"), ProveedoresDoc[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into ProveedoresDocApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdProveedores,Documento,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdProveedores,Documento,Archivo from ProveedoresDoc where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from ProveedoresDoc where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			ProveedoresDoc ids = gson.fromJson(request.getParameter("Ids"), ProveedoresDoc.class);
			sentencia.executeUpdate("insert into ProveedoresDocApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdProveedores,Documento,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdProveedores,Documento,Archivo from ProveedoresDoc where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from ProveedoresDoc where Id = '" + ids.getId() + "'");
		}
		objeto = new ProveedoresDoc();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		
		String nombreArchivo =request.getParameter("Archivo").replaceAll(" ", "_");
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
		
		sentencia.executeUpdate("update ProveedoresDoc set IdProveedores='" + valoresDefault.getEntero(request.getParameter("IdProveedores")) + "',Documento='" + request.getParameter("Documento") + "',Archivo='" + nombreArchivo + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into ProveedoresDocApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdProveedores,Documento,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdProveedores,Documento,Archivo from ProveedoresDoc where Id = '" + request.getParameter("id") + "'");
		objeto = new ProveedoresDoc();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getProveedoresDoc")) {
		resultados = sentencia.executeQuery("select Id, <columna> from ProveedoresDoc where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<ProveedoresDoc> info = new ArrayList<ProveedoresDoc>();
		while(resultados.next()) {
			objeto = new ProveedoresDoc();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new ProveedoresDoc();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new ProveedoresDoc();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* ProveedoresDocServlet.jsp */
%>

