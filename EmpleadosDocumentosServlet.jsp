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
<%@ page import="Configuraciones.BaseDeDatosPool"%>
<%@ page import="Configuraciones.Generales"%>
<%@ page import="Configuraciones.Seguridad"%>
<%@ page import="Utilerias.Fechas"%>
<%@ page import="Utilerias.ValoresDefault"%>
<%@ page import="Objetos.EmpleadosDocumentos"%>
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
		/* BaseDeDatos dbConf = new BaseDeDatos(); */
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
private void imprimeJson(HttpServletResponse response, EmpleadosDocumentos objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<EmpleadosDocumentos> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(EmpleadosDocumentos objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("EmpleadosDocumentosServlet.jsp");
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
EmpleadosDocumentos objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();//AQUI HAY ERROR
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new EmpleadosDocumentos();
		objeto.setIdEmpleados(request.getParameter("Campo"));
		//objeto.setTipo(request.getParameter("Campo"));
		//objeto.setArchivo(request.getParameter("Campo"));

		if(!objeto.getIdEmpleados().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdEmpleados = '" + objeto.getIdEmpleados() + "'"); entro = true; agregaOr = true;}
		if(!objeto.getTipo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Tipo like '" + objeto.getTipo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from EmpleadosDocumentos as A" + whereInicio + where.toString() + "and A.Tipo = 'DESCRIPCION DEL PUESTO'");
		ArrayList<EmpleadosDocumentos> info = new ArrayList<EmpleadosDocumentos>();
		while(resultados.next()) {
			objeto = new EmpleadosDocumentos();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setIdEmpleados(resultados.getString("IdEmpleados"));
			objeto.setTipo(resultados.getString("Tipo"));
			objeto.setArchivo(resultados.getString("Archivo").replaceAll(" ","_"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		
		//Quitar Caracteres Especiales		
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
		
		sentencia.executeUpdate("insert into EmpleadosDocumentos (U,G,E,Bloquear,IdEmpleados,Tipo,Archivo) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdEmpleados")) + "','" + request.getParameter("Tipo") + "','" + "ID_"+request.getParameter("IdEmpleados")+"_"+nombreArchivo + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into EmpleadosDocumentosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdEmpleados,Tipo,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdEmpleados,Tipo,Archivo from EmpleadosDocumentos where Id = '" + ultimoId + "'");
		objeto = new EmpleadosDocumentos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			EmpleadosDocumentos[] ids = gson.fromJson(request.getParameter("Ids"), EmpleadosDocumentos[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into EmpleadosDocumentosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdEmpleados,Tipo,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdEmpleados,Tipo,Archivo from EmpleadosDocumentos where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from EmpleadosDocumentos where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			EmpleadosDocumentos ids = gson.fromJson(request.getParameter("Ids"), EmpleadosDocumentos.class);
			sentencia.executeUpdate("insert into EmpleadosDocumentosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdEmpleados,Tipo,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdEmpleados,Tipo,Archivo from EmpleadosDocumentos where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from EmpleadosDocumentos where Id = '" + ids.getId() + "'");
		}
		objeto = new EmpleadosDocumentos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		
		//Quitar Caracteres Especiales		
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
		
		sentencia.executeUpdate("update EmpleadosDocumentos set IdEmpleados='" + valoresDefault.getEntero(request.getParameter("IdEmpleados")) + "',Tipo='" + request.getParameter("Tipo") + "',Archivo='" + "ID_"+request.getParameter("IdEmpleados")+"_"+nombreArchivo + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into EmpleadosDocumentosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdEmpleados,Tipo,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdEmpleados,Tipo,Archivo from EmpleadosDocumentos where Id = '" + request.getParameter("id") + "'");
		objeto = new EmpleadosDocumentos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getEmpleadosDocumentos")) {
		resultados = sentencia.executeQuery("select Id, <columna> from EmpleadosDocumentos where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<EmpleadosDocumentos> info = new ArrayList<EmpleadosDocumentos>();
		while(resultados.next()) {
			objeto = new EmpleadosDocumentos();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("BuscarMisActividades")) {
		StringBuffer where = new StringBuffer();
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new EmpleadosDocumentos();		

		resultados = sentencia.executeQuery("select A.* from EmpleadosDocumentos as A, Empleados as E, Usuarios as U where U.Id = '"+ session.getAttribute("IdUsuario") +"' and U.Id = E.IdUsuario and E.Id = A.IdEmpleados and A.Tipo = 'DESCRIPCION DEL PUESTO'");
		ArrayList<EmpleadosDocumentos> info = new ArrayList<EmpleadosDocumentos>();
		while(resultados.next()) {
			objeto = new EmpleadosDocumentos();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setIdEmpleados(resultados.getString("IdEmpleados"));
			objeto.setTipo(resultados.getString("Tipo"));
			objeto.setArchivo(resultados.getString("Archivo").replaceAll(" ","_"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new EmpleadosDocumentos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new EmpleadosDocumentos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* EmpleadosDocumentosServlet.jsp */
%>



