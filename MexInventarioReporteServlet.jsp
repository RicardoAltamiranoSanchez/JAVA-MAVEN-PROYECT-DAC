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
<%@ page import="Objetos.MexInventario"%>
<%@ page import="com.google.gson.Gson"%>
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
private void imprimeJson(HttpServletResponse response, MexInventario objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MexInventario> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MexInventario objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MexInventarioServlet.jsp");
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
MexInventario objeto = null;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexInventario();
		objeto.setIdEntradas(request.getParameter("IdEntradas"));
		objeto.setProducto(request.getParameter("Producto"));
		objeto.setUnidad(request.getParameter("Unidad"));
		objeto.setCantidad(request.getParameter("Cantidad"));
		objeto.setUbicacion(request.getParameter("Ubicacion"));

		if(!objeto.getIdEntradas().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdEntradas like '" + objeto.getIdEntradas() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getProducto().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Producto like '" + objeto.getProducto() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getUnidad().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Unidad like '" + objeto.getUnidad() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCantidad().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Cantidad like '" + objeto.getCantidad() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getUbicacion().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Ubicacion like '" + objeto.getUbicacion() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from MexInventario as A" + whereInicio + where.toString());
		ArrayList<MexInventario> info = new ArrayList<MexInventario>();
		while(resultados.next()) {
			objeto = new MexInventario();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdEntradas(resultados.getString("IdEntradas"));
		objeto.setProducto(resultados.getString("Producto"));
		objeto.setUnidad(resultados.getString("Unidad"));
		objeto.setCantidad(resultados.getString("Cantidad"));
		objeto.setUbicacion(resultados.getString("Ubicacion"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new MexInventario();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MexInventario();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MexInventarioReporteServlet.jsp */
%>



