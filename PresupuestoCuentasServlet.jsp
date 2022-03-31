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
<%@ page import="Objetos.PresupuestoCuentas"%>
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
private void imprimeJson(HttpServletResponse response, PresupuestoCuentas objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<PresupuestoCuentas> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(PresupuestoCuentas objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("PresupuestoCuentasServlet.jsp");
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
PresupuestoCuentas objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new PresupuestoCuentas();
		objeto.setIndice(request.getParameter("Campo"));
		//objeto.setTipo(request.getParameter("Campo"));
		//objeto.setConcepto(request.getParameter("Campo"));

		if(!objeto.getIndice().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Indice like '" + objeto.getIndice() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getTipo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Tipo like '" + objeto.getTipo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getConcepto().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Concepto like '" + objeto.getConcepto() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(") order by A.Indice");}

		resultados = sentencia.executeQuery("select A.* from PresupuestoCuentas as A" + whereInicio + where.toString());
		ArrayList<PresupuestoCuentas> info = new ArrayList<PresupuestoCuentas>();
		while(resultados.next()) {
			objeto = new PresupuestoCuentas();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIndice(resultados.getString("Indice"));
		objeto.setTipo(resultados.getString("Tipo"));
		objeto.setConcepto(resultados.getString("Concepto"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into PresupuestoCuentas (U,G,E,Bloquear,Indice,Tipo,Concepto) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("Indice")) + "','" + request.getParameter("Tipo") + "','" + request.getParameter("Concepto") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into PresupuestoCuentasApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Indice,Tipo,Concepto) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Indice,Tipo,Concepto from PresupuestoCuentas where Id = '" + ultimoId + "'");
		objeto = new PresupuestoCuentas();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			PresupuestoCuentas[] ids = gson.fromJson(request.getParameter("Ids"), PresupuestoCuentas[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into PresupuestoCuentasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Indice,Tipo,Concepto) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Indice,Tipo,Concepto from PresupuestoCuentas where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from PresupuestoCuentas where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			PresupuestoCuentas ids = gson.fromJson(request.getParameter("Ids"), PresupuestoCuentas.class);
			sentencia.executeUpdate("insert into PresupuestoCuentasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Indice,Tipo,Concepto) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Indice,Tipo,Concepto from PresupuestoCuentas where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from PresupuestoCuentas where Id = '" + ids.getId() + "'");
		}
		objeto = new PresupuestoCuentas();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update PresupuestoCuentas set Indice='" + valoresDefault.getEntero(request.getParameter("Indice")) + "',Tipo='" + request.getParameter("Tipo") + "',Concepto='" + request.getParameter("Concepto") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into PresupuestoCuentasApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Indice,Tipo,Concepto) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Indice,Tipo,Concepto from PresupuestoCuentas where Id = '" + request.getParameter("id") + "'");
		objeto = new PresupuestoCuentas();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getPresupuestoCuentas")) {
		resultados = sentencia.executeQuery("select Id, concat(Tipo,' (',Indice,') ',Concepto) Cuenta from PresupuestoCuentas where Concepto like '" + request.getParameter("filter[value]") + "%' order by Indice");
		ArrayList<PresupuestoCuentas> info = new ArrayList<PresupuestoCuentas>();
		while(resultados.next()) {
			objeto = new PresupuestoCuentas();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Cuenta"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getPresupuestoCuentasEgresos")) {
		resultados = sentencia.executeQuery("select Id, concat(Concepto,' (',Tipo,')') Concepto from PresupuestoCuentas where Concepto like '" + request.getParameter("filter[value]") + "%' and Tipo not like 'Ingresos%' order by Concepto ");
		ArrayList<PresupuestoCuentas> info = new ArrayList<PresupuestoCuentas>();
		while(resultados.next()) {
			objeto = new PresupuestoCuentas();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Concepto"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new PresupuestoCuentas();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new PresupuestoCuentas();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* PresupuestoCuentasServlet.jsp */
%>