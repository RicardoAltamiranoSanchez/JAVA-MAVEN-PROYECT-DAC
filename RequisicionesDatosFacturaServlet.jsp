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
<%@ page import="Objetos.Requisiciones"%>
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
private void imprimeJson(HttpServletResponse response, Requisiciones objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<Requisiciones> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(Requisiciones objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("RequisicionesServlet.jsp");
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
Requisiciones objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and C.Id = A.IdCentroCostos and PC.Id = A.IdCuentas order by A.Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Requisiciones();
		objeto.setId(request.getParameter("Campo").toString());
		//objeto.setIdCentroCostos(request.getParameter("Campo"));
		//objeto.setIdCuentas(request.getParameter("Campo"));
		//objeto.setImporte(request.getParameter("Campo"));

		if(!objeto.getId().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Id = '" + objeto.getId() + "'"); entro = true; agregaOr = true;}		
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		//resultados = sentencia.executeQuery("select A.*, C.CentroCosto, PC.Concepto from Requisiciones as A, RequisicionesCentroCostos C, PresupuestoCuentas PC " + whereInicio + where.toString());
		resultados = sentencia.executeQuery("select A.* from Requisiciones as A where A.Id = '" + request.getParameter("Campo") + "'");
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();		
		while(resultados.next()) {
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFacturaFolio(resultados.getString("FacturaFolio"));
			objeto.setFacturaMontoTotal(resultados.getString("FacturaMontoTotal"));
			objeto.setFacturaFechaIdealPago(resultados.getString("FacturaFechaIdealPago"));
			objeto.setFacturaObservaciones(resultados.getString("FacturaObservaciones"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("LlenarValores")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and C.Id = A.IdCentroCostos and PC.Id = A.IdCuentas order by A.Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Requisiciones();
		objeto.setId(request.getParameter("Id").toString());
		//objeto.setIdCentroCostos(request.getParameter("Campo"));
		//objeto.setIdCuentas(request.getParameter("Campo"));
		//objeto.setImporte(request.getParameter("Campo"));

		if(!objeto.getId().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Id = '" + objeto.getId() + "'"); entro = true; agregaOr = true;}		
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		//resultados = sentencia.executeQuery("select A.*, C.CentroCosto, PC.Concepto from Requisiciones as A, RequisicionesCentroCostos C, PresupuestoCuentas PC " + whereInicio + where.toString());
		resultados = sentencia.executeQuery("select A.* from Requisiciones as A where A.Id = '" + request.getParameter("Id") + "'");
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();		
		while(resultados.next()) {
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFacturaFolio(resultados.getString("FacturaFolio"));
			objeto.setFacturaMontoTotal(resultados.getString("FacturaMontoTotal"));
			objeto.setFacturaFechaIdealPago(resultados.getString("FacturaFechaIdealPago"));
			objeto.setFacturaObservaciones(resultados.getString("FacturaObservaciones"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update Requisiciones set FacturaFolio='" + request.getParameter("FacturaFolio") + "',FacturaMontoTotal='" + request.getParameter("FacturaMontoTotal") + "',FacturaFechaIdealPago='" + request.getParameter("FacturaFechaIdealPago") + "',FacturaObservaciones='" + request.getParameter("FacturaObservaciones") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into RequisicionesApoyo (Id,Quien,Registro,IdOrigen,U,G,E,Bloquear,FacturaFolio,FacturaMontoTotal,FacturaFechaIdealPago,FacturaObservaciones) select 0,'" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,FacturaFolio,FacturaMontoTotal,FacturaFechaIdealPago,FacturaObservaciones from Requisiciones where Id = '" + request.getParameter("id") + "'");
		objeto = new Requisiciones();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getRequisiciones")) {
		resultados = sentencia.executeQuery("select Id, <columna> from Requisiciones where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();
		while(resultados.next()) {
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new Requisiciones();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new Requisiciones();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* RequisicionesDatosFacturaServlet.jsp */
%>



