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
<%@ page import="Objetos.MexReqFacturas"%>
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
private void imprimeJson(HttpServletResponse response, MexReqFacturas objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MexReqFacturas> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MexReqFacturas objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MexReqFacturasServlet.jsp");
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
MexReqFacturas objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexReqFacturas();
		objeto.setIdRequerimientos(request.getParameter("Campo"));
		//objeto.setArchivo(request.getParameter("Campo"));
		//objeto.setNombre(request.getParameter("Campo"));

		if(!objeto.getIdRequerimientos().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdRequerimientos like '" + objeto.getIdRequerimientos() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from MexReqFacturas as A" + whereInicio + where.toString());
		ArrayList<MexReqFacturas> info = new ArrayList<MexReqFacturas>();
		while(resultados.next()) {
			objeto = new MexReqFacturas();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setIdRequerimientos(resultados.getString("IdRequerimientos"));
			objeto.setArchivo(resultados.getString("Archivo").replaceAll(" ","_"));
			objeto.setNombre(resultados.getString("Nombre"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into MexReqFacturas (U,G,E,Bloquear,IdRequerimientos,Archivo,Nombre) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdRequerimientos")) + "','" + request.getParameter("Archivo") + "','" + request.getParameter("Nombre") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into MexReqFacturasApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Archivo,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdRequerimientos,Archivo,Nombre from MexReqFacturas where Id = '" + ultimoId + "'");
		objeto = new MexReqFacturas();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			MexReqFacturas[] ids = gson.fromJson(request.getParameter("Ids"), MexReqFacturas[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into MexReqFacturasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Archivo,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequerimientos,Archivo,Nombre from MexReqFacturas where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from MexReqFacturas where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			MexReqFacturas ids = gson.fromJson(request.getParameter("Ids"), MexReqFacturas.class);
			sentencia.executeUpdate("insert into MexReqFacturasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Archivo,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequerimientos,Archivo,Nombre from MexReqFacturas where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from MexReqFacturas where Id = '" + ids.getId() + "'");
		}
		objeto = new MexReqFacturas();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update MexReqFacturas set IdRequerimientos='" + valoresDefault.getEntero(request.getParameter("IdRequerimientos")) + "',Archivo='" + request.getParameter("Archivo") + "',Nombre='" + request.getParameter("Nombre") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into MexReqFacturasApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Archivo,Nombre) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdRequerimientos,Archivo,Nombre from MexReqFacturas where Id = '" + request.getParameter("id") + "'");
		objeto = new MexReqFacturas();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getMexReqFacturas")) {
		resultados = sentencia.executeQuery("select Id, <columna> from MexReqFacturas where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<MexReqFacturas> info = new ArrayList<MexReqFacturas>();
		while(resultados.next()) {
			objeto = new MexReqFacturas();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new MexReqFacturas();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MexReqFacturas();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MexReqFacturasServlet.jsp */
%>


