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
<%@ page import="Objetos.TrainingArchivos"%>
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
private void imprimeJson(HttpServletResponse response, TrainingArchivos objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<TrainingArchivos> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(TrainingArchivos objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("TrainingArchivosServlet.jsp");
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
TrainingArchivos objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new TrainingArchivos();
		objeto.setIdTraining(request.getParameter("Campo"));
		//objeto.setArchivo(request.getParameter("Campo"));

		if(!objeto.getIdTraining().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdTraining = '" + objeto.getIdTraining() + "'"); entro = true; agregaOr = true;}
		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from TrainingArchivos as A" + whereInicio + where.toString());
		ArrayList<TrainingArchivos> info = new ArrayList<TrainingArchivos>();
		while(resultados.next()) {
			objeto = new TrainingArchivos();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setIdTraining(resultados.getString("IdTraining"));
			objeto.setArchivo(resultados.getString("Archivo"));
			String nombreArchivo =resultados.getString("Archivo").replaceAll(" ", "_");
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
			objeto.setValue(nombreArchivo);
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into TrainingArchivos (U,G,E,Bloquear,IdTraining,Archivo) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdTraining")) + "','" + request.getParameter("Archivo") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into TrainingArchivosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdTraining,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdTraining,Archivo from TrainingArchivos where Id = '" + ultimoId + "'");
		objeto = new TrainingArchivos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			TrainingArchivos[] ids = gson.fromJson(request.getParameter("Ids"), TrainingArchivos[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into TrainingArchivosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdTraining,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdTraining,Archivo from TrainingArchivos where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from TrainingArchivos where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			TrainingArchivos ids = gson.fromJson(request.getParameter("Ids"), TrainingArchivos.class);
			sentencia.executeUpdate("insert into TrainingArchivosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdTraining,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdTraining,Archivo from TrainingArchivos where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from TrainingArchivos where Id = '" + ids.getId() + "'");
		}
		objeto = new TrainingArchivos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update TrainingArchivos set IdTraining='" + valoresDefault.getEntero(request.getParameter("IdTraining")) + "',Archivo='" + request.getParameter("Archivo") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into TrainingArchivosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdTraining,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdTraining,Archivo from TrainingArchivos where Id = '" + request.getParameter("id") + "'");
		objeto = new TrainingArchivos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getTrainingArchivos")) {
		resultados = sentencia.executeQuery("select Id, <columna> from TrainingArchivos where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<TrainingArchivos> info = new ArrayList<TrainingArchivos>();
		while(resultados.next()) {
			objeto = new TrainingArchivos();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new TrainingArchivos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new TrainingArchivos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* TrainingArchivosServlet.jsp */
%>



