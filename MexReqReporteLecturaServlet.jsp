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
<%@ page import="Objetos.MexReqFinalizados"%>
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
private void imprimeJson(HttpServletResponse response, MexReqFinalizados objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MexReqFinalizados> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MexReqFinalizados objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MexReqFinalizadosServlet.jsp");
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
MexReqFinalizados objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar") || request.getParameter("Accion").equals("Requisicion") || request.getParameter("Accion").equals("VistoBueno") 
			|| request.getParameter("Accion").equals("PreAutorizar") || request.getParameter("Accion").equals("Autorizar") || request.getParameter("Accion").equals("Compras")
			|| request.getParameter("Accion").equals("Facturacion") || request.getParameter("Accion").equals("ParteContable")) {
		
		
		
		
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(3,session,new String[]{""}) + " order by Id desc";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexReqFinalizados();
		//objeto.setFecha(request.getParameter("Fecha"));
		//objeto.setAlias(request.getParameter("Alias"));
		objeto.setNombre(request.getParameter("Nombre"));
		//objeto.setEmpresa(request.getParameter("Empresa"));
		objeto.setArea(request.getParameter("Area"));
		//objeto.setUnidad(request.getParameter("Unidad"));
		//objeto.setPrincipal(request.getParameter("Principal"));
		//objeto.setSoporte1(request.getParameter("Soporte1"));
		//objeto.setSoporte2(request.getParameter("Soporte2"));

		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getAlias().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Alias like '" + objeto.getAlias() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEmpresa().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Empresa like '" + objeto.getEmpresa() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getArea().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Area like '" + objeto.getArea() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getUnidad().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Unidad like '" + objeto.getUnidad() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getPrincipal().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Principal like '" + objeto.getPrincipal() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(3,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.*, if(A.Estatus = 'Entradas','FACTURACION',if(A.Estatus = 'EntradasAdmon','PARTE CONTABLE',A.Estatus)) Estatus2 from MexReqTodos as A" + whereInicio + where.toString());
		ArrayList<MexReqFinalizados> info = new ArrayList<MexReqFinalizados>();
		while(resultados.next()) {
			objeto = new MexReqFinalizados();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setAlias(resultados.getString("Alias"));
			objeto.setNombre(resultados.getString("Nombre"));
			objeto.setEmpresa(resultados.getString("Empresa"));
			objeto.setArea(resultados.getString("Area"));
			objeto.setUnidad(resultados.getString("Unidad"));
			if(resultados.getString("Principal") == null) {
				objeto.setPrincipal("");
			} else {
				objeto.setPrincipal(resultados.getString("Principal").replaceAll(" ","_"));
			}
			objeto.setLog(resultados.getString("Estatus2").toUpperCase());
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	
	conexion.close();
} catch(SQLException e) {
	objeto = new MexReqFinalizados();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MexReqFinalizados();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MexReqFinalizadosServlet.jsp */
%>


