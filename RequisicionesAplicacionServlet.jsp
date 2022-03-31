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
<%@ page import="Objetos.RequisicionesAplicacion"%>
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
private void imprimeJson(HttpServletResponse response, RequisicionesAplicacion objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<RequisicionesAplicacion> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(RequisicionesAplicacion objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("RequisicionesAplicacionServlet.jsp");
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
RequisicionesAplicacion objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and C.Id = A.IdCentroCostos and PC.Id = A.IdCuentas order by A.Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new RequisicionesAplicacion();
		objeto.setIdRequisiciones(request.getParameter("Campo"));
		//objeto.setIdCentroCostos(request.getParameter("Campo"));
		//objeto.setIdCuentas(request.getParameter("Campo"));
		//objeto.setImporte(request.getParameter("Campo"));

		if(!objeto.getIdRequisiciones().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdRequisiciones = '" + objeto.getIdRequisiciones() + "'"); entro = true; agregaOr = true;}
		if(!objeto.getIdCentroCostos().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdCentroCostos like '" + objeto.getIdCentroCostos() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getIdCuentas().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdCuentas like '" + objeto.getIdCuentas() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getImporte().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Importe like '" + objeto.getImporte() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and C.IdUsuarios = A.IdCentroCostos and PC.Id = A.IdCuentas and ("; where.append(")");}

		//resultados = sentencia.executeQuery("select A.*, C.CentroCosto, PC.Concepto from RequisicionesAplicacion as A, RequisicionesCentroCostos C, PresupuestoCuentas PC " + whereInicio + where.toString());
		resultados = sentencia.executeQuery("select A.*, C.CentroCosto, PC.Concepto from RequisicionesAplicacion as A, RequisicionesCentroCostos C, PresupuestoCuentas PC where A.IdRequisiciones = '" + request.getParameter("Campo") + "' and A.IdCentroCostos = C.Id and A.IdCuentas = PC.Id");
		ArrayList<RequisicionesAplicacion> info = new ArrayList<RequisicionesAplicacion>();
		double suma = 0.00;
		while(resultados.next()) {
			objeto = new RequisicionesAplicacion();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setIdRequisiciones(resultados.getString("IdRequisiciones"));
			objeto.setIdCentroCostos(resultados.getString("IdCentroCostos"));
			objeto.setCentroCostos(resultados.getString("CentroCosto"));
			objeto.setIdCuentas(resultados.getString("IdCuentas"));
			objeto.setCuentas(resultados.getString("Concepto"));
			objeto.setImporte(resultados.getString("Importe"));
			info.add(objeto);
			suma += resultados.getDouble("Importe");
		}
		objeto = new RequisicionesAplicacion();
		objeto.setId("100000");
		objeto.setBloquear(true);
		objeto.setIdRequisiciones("");
		objeto.setIdCentroCostos("");
		objeto.setCentroCostos("");
		objeto.setIdCuentas("");
		objeto.setCuentas("TOTAL:");
		objeto.setImporte("" + suma);
		info.add(objeto);

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into RequisicionesAplicacion (U,G,E,Bloquear,IdRequisiciones,IdCentroCostos,IdCuentas,Importe) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdRequisiciones")) + "','" + valoresDefault.getEntero(request.getParameter("IdCentroCostos")) + "','" + valoresDefault.getEntero(request.getParameter("IdCuentas")) + "','" + valoresDefault.getDecimal(request.getParameter("Importe")) + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into RequisicionesAplicacionApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRequisiciones,IdCentroCostos,IdCuentas,Importe) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdRequisiciones,IdCentroCostos,IdCuentas,Importe from RequisicionesAplicacion where Id = '" + ultimoId + "'");
		objeto = new RequisicionesAplicacion();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			RequisicionesAplicacion[] ids = gson.fromJson(request.getParameter("Ids"), RequisicionesAplicacion[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into RequisicionesAplicacionApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequisiciones,IdCentroCostos,IdCuentas,Importe) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequisiciones,IdCentroCostos,IdCuentas,Importe from RequisicionesAplicacion where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from RequisicionesAplicacion where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			RequisicionesAplicacion ids = gson.fromJson(request.getParameter("Ids"), RequisicionesAplicacion.class);
			sentencia.executeUpdate("insert into RequisicionesAplicacionApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequisiciones,IdCentroCostos,IdCuentas,Importe) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequisiciones,IdCentroCostos,IdCuentas,Importe from RequisicionesAplicacion where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from RequisicionesAplicacion where Id = '" + ids.getId() + "'");
		}
		objeto = new RequisicionesAplicacion();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update RequisicionesAplicacion set IdRequisiciones='" + valoresDefault.getEntero(request.getParameter("IdRequisiciones")) + "',IdCentroCostos='" + valoresDefault.getEntero(request.getParameter("IdCentroCostos")) + "',IdCuentas='" + valoresDefault.getEntero(request.getParameter("IdCuentas")) + "',Importe='" + valoresDefault.getDecimal(request.getParameter("Importe")) + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into RequisicionesAplicacionApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRequisiciones,IdCentroCostos,IdCuentas,Importe) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdRequisiciones,IdCentroCostos,IdCuentas,Importe from RequisicionesAplicacion where Id = '" + request.getParameter("id") + "'");
		objeto = new RequisicionesAplicacion();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getRequisicionesAplicacion")) {
		resultados = sentencia.executeQuery("select Id, <columna> from RequisicionesAplicacion where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<RequisicionesAplicacion> info = new ArrayList<RequisicionesAplicacion>();
		while(resultados.next()) {
			objeto = new RequisicionesAplicacion();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new RequisicionesAplicacion();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new RequisicionesAplicacion();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* RequisicionesAplicacionServlet.jsp */
%>



