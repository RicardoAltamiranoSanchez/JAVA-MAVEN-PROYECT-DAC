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
<%@ page import="Objetos.MexReqArchivos"%>
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
private void imprimeJson(HttpServletResponse response, MexReqArchivos objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MexReqArchivos> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MexReqArchivos objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MexReqArchivosServlet.jsp");
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
MexReqArchivos objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexReqArchivos();
		objeto.setIdRequerimientos(request.getParameter("Campo"));
		//objeto.setTipo(request.getParameter("Campo"));
		//objeto.setArchivo(request.getParameter("Campo"));

		if(!objeto.getIdRequerimientos().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdRequerimientos like '" + objeto.getIdRequerimientos() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getTipo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Tipo like '" + objeto.getTipo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from MexReqArchivos as A" + whereInicio + where.toString());
		ArrayList<MexReqArchivos> info = new ArrayList<MexReqArchivos>();
		while(resultados.next()) {
			objeto = new MexReqArchivos();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setIdRequerimientos(resultados.getString("IdRequerimientos"));
			objeto.setTipo(resultados.getString("Tipo"));
			objeto.setArchivo(resultados.getString("Archivo").replaceAll(" ","_"));
			objeto.setNombre(resultados.getString("Nombre"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		
		//Quitar Caracteres Especiales		
		String nombreArchivo = request.getParameter("Archivo").toString();
		nombreArchivo = nombreArchivo.replaceAll(" ","_");
		nombreArchivo = nombreArchivo.replaceAll("?","a");
		nombreArchivo = nombreArchivo.replaceAll("?","e");
		nombreArchivo = nombreArchivo.replaceAll("?","i");
		nombreArchivo = nombreArchivo.replaceAll("?","o");
		nombreArchivo = nombreArchivo.replaceAll("?","u");
		nombreArchivo = nombreArchivo.replaceAll("?","A");
		nombreArchivo = nombreArchivo.replaceAll("?","E");
		nombreArchivo = nombreArchivo.replaceAll("?","I");
		nombreArchivo = nombreArchivo.replaceAll("?","O");
		nombreArchivo = nombreArchivo.replaceAll("?","U");
		nombreArchivo = nombreArchivo.replaceAll("?","n");
		nombreArchivo = nombreArchivo.replaceAll("?","N");
		nombreArchivo = nombreArchivo.replaceAll("?","u");
		nombreArchivo = nombreArchivo.replaceAll("?","U");
		
		sentencia.executeUpdate("insert into MexReqArchivos (U,G,E,Bloquear,IdRequerimientos,Tipo,Archivo,Nombre) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdRequerimientos")) + "','" + request.getParameter("Tipo") + "','" + nombreArchivo + "','" + request.getParameter("Nombre") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into MexReqArchivosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Tipo,Archivo,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdRequerimientos,Tipo,Archivo,Nombre from MexReqArchivos where Id = '" + ultimoId + "'");
		objeto = new MexReqArchivos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			MexReqArchivos[] ids = gson.fromJson(request.getParameter("Ids"), MexReqArchivos[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into MexReqArchivosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Tipo,Archivo,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequerimientos,Tipo,Archivo,Nombre from MexReqArchivos where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from MexReqArchivos where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			MexReqArchivos ids = gson.fromJson(request.getParameter("Ids"), MexReqArchivos.class);
			sentencia.executeUpdate("insert into MexReqArchivosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Tipo,Archivo,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequerimientos,Tipo,Archivo,Nombre from MexReqArchivos where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from MexReqArchivos where Id = '" + ids.getId() + "'");
		}
		objeto = new MexReqArchivos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		
		//Quitar Caracteres Especiales		
				String nombreArchivo = request.getParameter("Archivo").toString();
				nombreArchivo = nombreArchivo.replaceAll("?","a");
				nombreArchivo = nombreArchivo.replaceAll("?","e");
				nombreArchivo = nombreArchivo.replaceAll("?","i");
				nombreArchivo = nombreArchivo.replaceAll("?","o");
				nombreArchivo = nombreArchivo.replaceAll("?","u");
				nombreArchivo = nombreArchivo.replaceAll("?","A");
				nombreArchivo = nombreArchivo.replaceAll("?","E");
				nombreArchivo = nombreArchivo.replaceAll("?","I");
				nombreArchivo = nombreArchivo.replaceAll("?","O");
				nombreArchivo = nombreArchivo.replaceAll("?","U");
				nombreArchivo = nombreArchivo.replaceAll("?","n");
				nombreArchivo = nombreArchivo.replaceAll("?","N");
				nombreArchivo = nombreArchivo.replaceAll("?","u");
				nombreArchivo = nombreArchivo.replaceAll("?","U");
		
		sentencia.executeUpdate("update MexReqArchivos set IdRequerimientos='" + valoresDefault.getEntero(request.getParameter("IdRequerimientos")) + "',Tipo='" + request.getParameter("Tipo") + "',Archivo='" + nombreArchivo + "',Nombre='" + request.getParameter("Nombre") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into MexReqArchivosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Tipo,Archivo,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdRequerimientos,Tipo,Archivo,Nombre from MexReqArchivos where Id = '" + request.getParameter("id") + "'");
		objeto = new MexReqArchivos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getMexReqArchivos")) {
		resultados = sentencia.executeQuery("select Id, <columna> from MexReqArchivos where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<MexReqArchivos> info = new ArrayList<MexReqArchivos>();
		while(resultados.next()) {
			objeto = new MexReqArchivos();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new MexReqArchivos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MexReqArchivos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MexReqArchivosServlet.jsp */
%>



