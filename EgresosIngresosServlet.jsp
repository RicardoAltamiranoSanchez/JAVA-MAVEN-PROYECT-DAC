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
<%@ page import="Objetos.EgresosIngresos"%>
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
private void imprimeJson(HttpServletResponse response, EgresosIngresos objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<EgresosIngresos> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(EgresosIngresos objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("EgresosIngresosServlet.jsp");
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
EgresosIngresos objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new EgresosIngresos();
		objeto.setIdUsuario(request.getParameter("Campo"));
		//objeto.setFecha(request.getParameter("Campo"));
		//objeto.setIdCuentas(request.getParameter("Campo"));
		//objeto.setConcepto(request.getParameter("Campo"));
		//objeto.setImporte(request.getParameter("Campo"));

		if(!objeto.getIdUsuario().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdUsuario like '" + objeto.getIdUsuario() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getIdCuentas().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdCuentas like '" + objeto.getIdCuentas() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getConcepto().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Concepto like '" + objeto.getConcepto() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getImporte().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Importe like '" + objeto.getImporte() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from EgresosIngresos as A" + whereInicio + where.toString());
		ArrayList<EgresosIngresos> info = new ArrayList<EgresosIngresos>();
		while(resultados.next()) {
			objeto = new EgresosIngresos();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdUsuario(resultados.getString("IdUsuario"));
		objeto.setFecha(resultados.getString("Fecha"));
		objeto.setIdCuentas(resultados.getString("IdCuentas"));
		objeto.setConcepto(resultados.getString("Concepto"));
		objeto.setImporte(resultados.getString("Importe"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into EgresosIngresos (U,G,E,Bloquear,IdUsuario,Fecha,IdCuentas,Concepto,Importe) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdUsuario")) + "','" + valoresDefault.getFecha(request.getParameter("Fecha")) + "','" + valoresDefault.getEntero(request.getParameter("IdCuentas")) + "','" + request.getParameter("Concepto") + "','" + valoresDefault.getDecimal(request.getParameter("Importe")) + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into EgresosIngresosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdUsuario,Fecha,IdCuentas,Concepto,Importe) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdUsuario,Fecha,IdCuentas,Concepto,Importe from EgresosIngresos where Id = '" + ultimoId + "'");
		objeto = new EgresosIngresos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			EgresosIngresos[] ids = gson.fromJson(request.getParameter("Ids"), EgresosIngresos[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into EgresosIngresosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdUsuario,Fecha,IdCuentas,Concepto,Importe) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdUsuario,Fecha,IdCuentas,Concepto,Importe from EgresosIngresos where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from EgresosIngresos where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			EgresosIngresos ids = gson.fromJson(request.getParameter("Ids"), EgresosIngresos.class);
			sentencia.executeUpdate("insert into EgresosIngresosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdUsuario,Fecha,IdCuentas,Concepto,Importe) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdUsuario,Fecha,IdCuentas,Concepto,Importe from EgresosIngresos where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from EgresosIngresos where Id = '" + ids.getId() + "'");
		}
		objeto = new EgresosIngresos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update EgresosIngresos set IdUsuario='" + valoresDefault.getEntero(request.getParameter("IdUsuario")) + "',Fecha='" + valoresDefault.getFecha(request.getParameter("Fecha")) + "',IdCuentas='" + valoresDefault.getEntero(request.getParameter("IdCuentas")) + "',Concepto='" + request.getParameter("Concepto") + "',Importe='" + valoresDefault.getDecimal(request.getParameter("Importe")) + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into EgresosIngresosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdUsuario,Fecha,IdCuentas,Concepto,Importe) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdUsuario,Fecha,IdCuentas,Concepto,Importe from EgresosIngresos where Id = '" + request.getParameter("id") + "'");
		objeto = new EgresosIngresos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getEgresosIngresos")) {
		resultados = sentencia.executeQuery("select Id, <columna> from EgresosIngresos where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<EgresosIngresos> info = new ArrayList<EgresosIngresos>();
		while(resultados.next()) {
			objeto = new EgresosIngresos();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new EgresosIngresos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new EgresosIngresos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* EgresosIngresosServlet.jsp */
%>

