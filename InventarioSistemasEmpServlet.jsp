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
<%@ page import="Objetos.InventarioSistemasEmp"%>
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
private void imprimeJson(HttpServletResponse response, InventarioSistemasEmp objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<InventarioSistemasEmp> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(InventarioSistemasEmp objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("InventarioSistemasEmpServlet.jsp");
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
InventarioSistemasEmp objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new InventarioSistemasEmp();
		objeto.setIdInventarioSistemas(request.getParameter("Campo"));
		//objeto.setFecha(request.getParameter("Campo"));
		//objeto.setIdEmpleado(request.getParameter("Campo"));

		if(!objeto.getIdInventarioSistemas().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdInventarioSistemas = '" + objeto.getIdInventarioSistemas() + "'"); entro = true; agregaOr = true;}
		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getIdEmpleado().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdEmpleado like '" + objeto.getIdEmpleado() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.*, E.NombreCompleto, DE.Nombre Division, E1.NombreCompleto Responsable from InventarioSistemasEmp as A " + 
				"left join Empleados E on (E.Id = A.IdEmpleado) left join DivisionesAsignacion DA on (DA.IdEmpleados = A.IdEmpleado) left join DivisionesEmpleados DE on (DE.Id = DA.IdDivisionesEmpleados) " +
				"left join Empleados E1 on (E1.Id = A.IdResponsable) " + 
			whereInicio + where.toString());
		ArrayList<InventarioSistemasEmp> info = new ArrayList<InventarioSistemasEmp>();
		while(resultados.next()) {
			objeto = new InventarioSistemasEmp();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setIdInventarioSistemas(resultados.getString("IdInventarioSistemas"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdEmpleado(resultados.getString("IdEmpleado"));
			objeto.setEmpleado(resultados.getString("NombreCompleto"));
			objeto.setDivision(resultados.getString("Division"));
			objeto.setIdResponsable(resultados.getString("IdResponsable"));
			objeto.setResponsable(resultados.getString("Responsable"));
			objeto.setLocalizacion(resultados.getString("Localizacion"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into InventarioSistemasEmp (U,G,E,Bloquear,IdInventarioSistemas,Fecha,IdEmpleado,IdResponsable,Localizacion) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdInventarioSistemas")) + "','" + valoresDefault.getFecha(request.getParameter("Fecha")) + "','" + valoresDefault.getEntero(request.getParameter("IdEmpleado")) + "','" + valoresDefault.getEntero(request.getParameter("IdResponsable")) + "','" + request.getParameter("Localizacion") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into InventarioSistemasEmpApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdInventarioSistemas,Fecha,IdEmpleado,IdResponsable,Localizacion) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdInventarioSistemas,Fecha,IdEmpleado,IdResponsable,Localizacion from InventarioSistemasEmp where Id = '" + ultimoId + "'");
		objeto = new InventarioSistemasEmp();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			InventarioSistemasEmp[] ids = gson.fromJson(request.getParameter("Ids"), InventarioSistemasEmp[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into InventarioSistemasEmpApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdInventarioSistemas,Fecha,IdEmpleado,IdResponsable,Localizacion) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdInventarioSistemas,Fecha,IdEmpleado,IdResponsable,Localizacion from InventarioSistemasEmp where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from InventarioSistemasEmp where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			InventarioSistemasEmp ids = gson.fromJson(request.getParameter("Ids"), InventarioSistemasEmp.class);
			sentencia.executeUpdate("insert into InventarioSistemasEmpApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdInventarioSistemas,Fecha,IdEmpleado,IdResponsable,Localizacion) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdInventarioSistemas,Fecha,IdEmpleado,IdResponsable,Localizacion from InventarioSistemasEmp where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from InventarioSistemasEmp where Id = '" + ids.getId() + "'");
		}
		objeto = new InventarioSistemasEmp();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update InventarioSistemasEmp set IdInventarioSistemas='" + valoresDefault.getEntero(request.getParameter("IdInventarioSistemas")) + "',Fecha='" + valoresDefault.getFecha(request.getParameter("Fecha")) + "',IdEmpleado='" + valoresDefault.getEntero(request.getParameter("IdEmpleado")) + "',IdResponsable='" + valoresDefault.getEntero(request.getParameter("IdResponsable")) + "',Localizacion='" + request.getParameter("Localizacion") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into InventarioSistemasEmpApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdInventarioSistemas,Fecha,IdEmpleado,IdResponsable,Localizacion) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdInventarioSistemas,Fecha,IdEmpleado,IdResponsable,Localizacion from InventarioSistemasEmp where Id = '" + request.getParameter("id") + "'");
		objeto = new InventarioSistemasEmp();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getInventarioSistemasEmp")) {
		resultados = sentencia.executeQuery("select Id, <columna> from InventarioSistemasEmp where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<InventarioSistemasEmp> info = new ArrayList<InventarioSistemasEmp>();
		while(resultados.next()) {
			objeto = new InventarioSistemasEmp();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new InventarioSistemasEmp();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new InventarioSistemasEmp();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* InventarioSistemasEmpServlet.jsp */
%>



