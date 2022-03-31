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
<%@ page import="Objetos.PresupuestoReporte"%>
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
private void imprimeJson(HttpServletResponse response, PresupuestoReporte objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<PresupuestoReporte> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(PresupuestoReporte objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("PresupuestoReporteServlet.jsp");
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
PresupuestoReporte objeto = null;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		
		objeto = new PresupuestoReporte();

		resultados = sentencia.executeQuery("select " + 
				"P.Id," + 
				"P.Ao AS Ao," + 
				"PC.Tipo AS Tipo," + 
				"PC.Concepto AS Concepto," + 
				"P.M1 AS M1," + 
				"@1:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-01-01' and Fecha <= '" + request.getParameter("Ao") + "-01-31') AS R1," + 
				"If(@1 is null, P.M1, P.M1-@1) as D1," + 
				"'' as S1," + 
				"P.M2 AS M2," + 
				"@2:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-02-01' and Fecha <= '" + request.getParameter("Ao") + "-02-31') AS R2," + 
				"If(@2 is null, P.M2, P.M2-@2) as D2," + 
				"'' as S2," + 
				"P.M3 AS M3," + 
				"@3:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-03-01' and Fecha <= '" + request.getParameter("Ao") + "-03-31') AS R3," + 
				"If(@3 is null, P.M3, P.M3-@3) as D3," + 
				"'' as S3," + 
				"P.M4 AS M4," + 
				"@4:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-04-01' and Fecha <= '" + request.getParameter("Ao") + "-04-31') AS R4," + 
				"If(@4 is null, P.M4, P.M4-@4) as D4," + 
				"'' as S4," + 
				"P.M5 AS M5," + 
				"@5:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-05-01' and Fecha <= '" + request.getParameter("Ao") + "-05-31') AS R5," + 
				"If(@5 is null, P.M5, P.M5-@5) as D5," + 
				"'' as S5," + 
				"P.M6 AS M6," + 
				"@6:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-06-01' and Fecha <= '" + request.getParameter("Ao") + "-06-31') AS R6," + 
				"If(@6 is null, P.M6, P.M6-@6) as D6," + 
				"'' as S6," + 
				"P.M7 AS M7," + 
				"@7:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-07-01' and Fecha <= '" + request.getParameter("Ao") + "-07-31') AS R7," + 
				"If(@7 is null, P.M7, P.M7-@7) as D7," + 
				"'' as S7," + 
				"P.M8 AS M8," + 
				"@8:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-08-01' and Fecha <= '" + request.getParameter("Ao") + "-08-31') AS R8," + 
				"If(@8 is null, P.M8, P.M8-@8) as D8," + 
				"'' as S8," + 
				"P.M9 AS M9," + 
				"@9:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-09-01' and Fecha <= '" + request.getParameter("Ao") + "-09-31') AS R9," + 
				"If(@9 is null, P.M9, P.M9-@9) as D9," + 
				"'' as S9," + 
				"P.M10 AS M10," + 
				"@10:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-10-01' and Fecha <= '" + request.getParameter("Ao") + "-10-31') AS R10," + 
				"If(@10 is null, P.M10, P.M10-@10) as D10," + 
				"'' as S10," + 
				"P.M11 AS M11," + 
				"@11:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-11-01' and Fecha <= '" + request.getParameter("Ao") + "-11-31') AS R11," + 
				"If(@11 is null, P.M11, P.M11-@11) as D11," + 
				"'' as S11," + 
				"P.M12 AS M12," + 
				"@12:=(select sum(Importe) from EgresosIngresos where IdUsuario = P.IdUsuario and IdCuentas = P.IdCuentas and Fecha >= '" + request.getParameter("Ao") + "-12-01' and Fecha <= '" + request.getParameter("Ao") + "-12-31') AS R12," + 
				"If(@12 is null, P.M12, P.M12-@12) as D12 " + 
				"from " + 
				"Presupuesto P, " + 
				"PresupuestoCuentas PC " + 
				"where " + 
				"P.Ao = '" + request.getParameter("Ao") + "'" + 
				"and P.IdUsuario = '" + request.getParameter("IdUsuario") + "'" + 
				"and PC.Id = P.IdCuentas " + 
				"order by " + 
				"P.Ao,P.IdUsuario,PC.Indice");
		ArrayList<PresupuestoReporte> info = new ArrayList<PresupuestoReporte>();
		while(resultados.next()) {
			objeto = new PresupuestoReporte();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(true);
			objeto.setAo(resultados.getString("Ao"));
			objeto.setTipo(resultados.getString("Tipo"));
			objeto.setConcepto(resultados.getString("Concepto"));
			objeto.setM1(resultados.getString("M1"));
			objeto.setR1(resultados.getString("R1"));
			objeto.setD1(resultados.getString("D1"));
			objeto.setS1(resultados.getString("S1"));
			objeto.setM2(resultados.getString("M2"));
			objeto.setR2(resultados.getString("R2"));
			objeto.setD2(resultados.getString("D2"));
			objeto.setS2(resultados.getString("S2"));
			objeto.setM3(resultados.getString("M3"));
			objeto.setR3(resultados.getString("R3"));
			objeto.setD3(resultados.getString("D3"));
			objeto.setS3(resultados.getString("S3"));
			objeto.setM4(resultados.getString("M4"));
			objeto.setR4(resultados.getString("R4"));
			objeto.setD4(resultados.getString("D4"));
			objeto.setS4(resultados.getString("S4"));
			objeto.setM5(resultados.getString("M5"));
			objeto.setR5(resultados.getString("R5"));
			objeto.setD5(resultados.getString("D5"));
			objeto.setS5(resultados.getString("S5"));
			objeto.setM6(resultados.getString("M6"));
			objeto.setR6(resultados.getString("R6"));
			objeto.setD6(resultados.getString("D6"));
			objeto.setS6(resultados.getString("S6"));
			objeto.setM7(resultados.getString("M7"));
			objeto.setR7(resultados.getString("R7"));
			objeto.setD7(resultados.getString("D7"));
			objeto.setS7(resultados.getString("S7"));
			objeto.setM8(resultados.getString("M8"));
			objeto.setR8(resultados.getString("R8"));
			objeto.setD8(resultados.getString("D8"));
			objeto.setS8(resultados.getString("S8"));
			objeto.setM9(resultados.getString("M9"));
			objeto.setR9(resultados.getString("R9"));
			objeto.setD9(resultados.getString("D9"));
			objeto.setS9(resultados.getString("S9"));
			objeto.setM10(resultados.getString("M10"));
			objeto.setR10(resultados.getString("R10"));
			objeto.setD10(resultados.getString("D10"));
			objeto.setS10(resultados.getString("S10"));
			objeto.setM11(resultados.getString("M11"));
			objeto.setR11(resultados.getString("R11"));
			objeto.setD11(resultados.getString("D11"));
			objeto.setS11(resultados.getString("S11"));
			objeto.setM12(resultados.getString("M12"));
			objeto.setR12(resultados.getString("R12"));
			objeto.setD12(resultados.getString("D12"));
			info.add(objeto);
		}
		objeto = new PresupuestoReporte();
		objeto.setId("10000");
		objeto.setBloquear(false);
		objeto.setAo("");
		objeto.setTipo("");
		objeto.setConcepto("UTILIDAD O PERDIDA");
		objeto.setM1("");
		objeto.setR1("");
		objeto.setD1("");
		objeto.setS1("");
		objeto.setM2("");
		objeto.setR2("");
		objeto.setD2("");
		objeto.setS2("");
		objeto.setM3("");
		objeto.setR3("");
		objeto.setD3("");
		objeto.setS3("");
		objeto.setM4("");
		objeto.setR4("");
		objeto.setD4("");
		objeto.setS4("");
		objeto.setM5("");
		objeto.setR5("");
		objeto.setD5("");
		objeto.setS5("");
		objeto.setM6("");
		objeto.setR6("");
		objeto.setD6("");
		objeto.setS6("");
		objeto.setM7("");
		objeto.setR7("");
		objeto.setD7("");
		objeto.setS7("");
		objeto.setM8("");
		objeto.setR8("");
		objeto.setD8("");
		objeto.setS8("");
		objeto.setM9("");
		objeto.setR9("");
		objeto.setD9("");
		objeto.setS9("");
		objeto.setM10("");
		objeto.setR10("");
		objeto.setD10("");
		objeto.setS10("");
		objeto.setM11("");
		objeto.setR11("");
		objeto.setD11("");
		objeto.setS11("");
		objeto.setM12("");
		objeto.setR12("");
		objeto.setD12("");
		info.add(objeto);

		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new PresupuestoReporte();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new PresupuestoReporte();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* PresupuestoReporteReporteServlet.jsp */
%>
