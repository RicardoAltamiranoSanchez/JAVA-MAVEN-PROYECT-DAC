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
<%@ page import="Objetos.Presupuesto"%>
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
private void imprimeJson(HttpServletResponse response, Presupuesto objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<Presupuesto> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(Presupuesto objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("PresupuestoServlet.jsp");
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
Presupuesto objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Presupuesto();
		objeto.setIdUsuario(request.getParameter("Campo"));
		//objeto.setAo(request.getParameter("Campo"));
		//objeto.setIdCuentas(request.getParameter("Campo"));
		//objeto.setM1(request.getParameter("Campo"));
		//objeto.setM2(request.getParameter("Campo"));
		//objeto.setM3(request.getParameter("Campo"));
		//objeto.setM4(request.getParameter("Campo"));
		//objeto.setM5(request.getParameter("Campo"));
		//objeto.setM6(request.getParameter("Campo"));
		//objeto.setM7(request.getParameter("Campo"));
		//objeto.setM8(request.getParameter("Campo"));
		//objeto.setM9(request.getParameter("Campo"));
		//objeto.setM10(request.getParameter("Campo"));
		//objeto.setM11(request.getParameter("Campo"));
		//objeto.setM12(request.getParameter("Campo"));

		if(!objeto.getIdUsuario().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdUsuario like '" + objeto.getIdUsuario() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getAo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Ao like '" + objeto.getAo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getIdCuentas().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdCuentas like '" + objeto.getIdCuentas() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM1().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M1 like '" + objeto.getM1() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM2().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M2 like '" + objeto.getM2() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM3().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M3 like '" + objeto.getM3() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM4().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M4 like '" + objeto.getM4() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM5().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M5 like '" + objeto.getM5() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM6().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M6 like '" + objeto.getM6() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM7().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M7 like '" + objeto.getM7() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM8().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M8 like '" + objeto.getM8() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM9().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M9 like '" + objeto.getM9() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM10().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M10 like '" + objeto.getM10() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM11().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M11 like '" + objeto.getM11() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getM12().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.M12 like '" + objeto.getM12() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from Presupuesto as A" + whereInicio + where.toString());
		ArrayList<Presupuesto> info = new ArrayList<Presupuesto>();
		while(resultados.next()) {
			objeto = new Presupuesto();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdUsuario(resultados.getString("IdUsuario"));
		objeto.setAo(resultados.getString("Ao"));
		objeto.setIdCuentas(resultados.getString("IdCuentas"));
		objeto.setM1(resultados.getString("M1"));
		objeto.setM2(resultados.getString("M2"));
		objeto.setM3(resultados.getString("M3"));
		objeto.setM4(resultados.getString("M4"));
		objeto.setM5(resultados.getString("M5"));
		objeto.setM6(resultados.getString("M6"));
		objeto.setM7(resultados.getString("M7"));
		objeto.setM8(resultados.getString("M8"));
		objeto.setM9(resultados.getString("M9"));
		objeto.setM10(resultados.getString("M10"));
		objeto.setM11(resultados.getString("M11"));
		objeto.setM12(resultados.getString("M12"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into Presupuesto (U,G,E,Bloquear,IdUsuario,Ao,IdCuentas,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdUsuario")) + "','" + valoresDefault.getEntero(request.getParameter("Ao")) + "','" + valoresDefault.getEntero(request.getParameter("IdCuentas")) + "','" + valoresDefault.getDecimal(request.getParameter("M1")) + "','" + valoresDefault.getDecimal(request.getParameter("M2")) + "','" + valoresDefault.getDecimal(request.getParameter("M3")) + "','" + valoresDefault.getDecimal(request.getParameter("M4")) + "','" + valoresDefault.getDecimal(request.getParameter("M5")) + "','" + valoresDefault.getDecimal(request.getParameter("M6")) + "','" + valoresDefault.getDecimal(request.getParameter("M7")) + "','" + valoresDefault.getDecimal(request.getParameter("M8")) + "','" + valoresDefault.getDecimal(request.getParameter("M9")) + "','" + valoresDefault.getDecimal(request.getParameter("M10")) + "','" + valoresDefault.getDecimal(request.getParameter("M11")) + "','" + valoresDefault.getDecimal(request.getParameter("M12")) + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into PresupuestoApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdUsuario,Ao,IdCuentas,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdUsuario,Ao,IdCuentas,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12 from Presupuesto where Id = '" + ultimoId + "'");
		objeto = new Presupuesto();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			Presupuesto[] ids = gson.fromJson(request.getParameter("Ids"), Presupuesto[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into PresupuestoApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdUsuario,Ao,IdCuentas,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdUsuario,Ao,IdCuentas,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12 from Presupuesto where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from Presupuesto where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			Presupuesto ids = gson.fromJson(request.getParameter("Ids"), Presupuesto.class);
			sentencia.executeUpdate("insert into PresupuestoApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdUsuario,Ao,IdCuentas,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdUsuario,Ao,IdCuentas,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12 from Presupuesto where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from Presupuesto where Id = '" + ids.getId() + "'");
		}
		objeto = new Presupuesto();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update Presupuesto set IdUsuario='" + valoresDefault.getEntero(request.getParameter("IdUsuario")) + "',Ao='" + valoresDefault.getEntero(request.getParameter("Ao")) + "',IdCuentas='" + valoresDefault.getEntero(request.getParameter("IdCuentas")) + "',M1='" + valoresDefault.getDecimal(request.getParameter("M1")) + "',M2='" + valoresDefault.getDecimal(request.getParameter("M2")) + "',M3='" + valoresDefault.getDecimal(request.getParameter("M3")) + "',M4='" + valoresDefault.getDecimal(request.getParameter("M4")) + "',M5='" + valoresDefault.getDecimal(request.getParameter("M5")) + "',M6='" + valoresDefault.getDecimal(request.getParameter("M6")) + "',M7='" + valoresDefault.getDecimal(request.getParameter("M7")) + "',M8='" + valoresDefault.getDecimal(request.getParameter("M8")) + "',M9='" + valoresDefault.getDecimal(request.getParameter("M9")) + "',M10='" + valoresDefault.getDecimal(request.getParameter("M10")) + "',M11='" + valoresDefault.getDecimal(request.getParameter("M11")) + "',M12='" + valoresDefault.getDecimal(request.getParameter("M12")) + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into PresupuestoApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdUsuario,Ao,IdCuentas,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdUsuario,Ao,IdCuentas,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12 from Presupuesto where Id = '" + request.getParameter("id") + "'");
		objeto = new Presupuesto();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getPresupuesto")) {
		resultados = sentencia.executeQuery("select Id, <columna> from Presupuesto where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<Presupuesto> info = new ArrayList<Presupuesto>();
		while(resultados.next()) {
			objeto = new Presupuesto();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new Presupuesto();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new Presupuesto();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* PresupuestoServlet.jsp */
%>


