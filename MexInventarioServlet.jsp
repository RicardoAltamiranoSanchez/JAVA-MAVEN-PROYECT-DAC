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
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexInventario();
		objeto.setIdEntradas(request.getParameter("Campo"));
		//objeto.setProducto(request.getParameter("Campo"));
		//objeto.setUnidad(request.getParameter("Campo"));
		//objeto.setCantidad(request.getParameter("Campo"));
		//objeto.setUbicacion(request.getParameter("Campo"));

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
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into MexInventario (U,G,E,Bloquear,IdEntradas,Producto,Unidad,Cantidad,Ubicacion) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdEntradas")) + "','" + request.getParameter("Producto") + "','" + request.getParameter("Unidad") + "','" + valoresDefault.getDecimal(request.getParameter("Cantidad")) + "','" + request.getParameter("Ubicacion") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into MexInventarioApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdEntradas,Producto,Unidad,Cantidad,Ubicacion) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdEntradas,Producto,Unidad,Cantidad,Ubicacion from MexInventario where Id = '" + ultimoId + "'");
		objeto = new MexInventario();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			MexInventario[] ids = gson.fromJson(request.getParameter("Ids"), MexInventario[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into MexInventarioApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdEntradas,Producto,Unidad,Cantidad,Ubicacion) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdEntradas,Producto,Unidad,Cantidad,Ubicacion from MexInventario where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from MexInventario where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			MexInventario ids = gson.fromJson(request.getParameter("Ids"), MexInventario.class);
			sentencia.executeUpdate("insert into MexInventarioApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdEntradas,Producto,Unidad,Cantidad,Ubicacion) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdEntradas,Producto,Unidad,Cantidad,Ubicacion from MexInventario where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from MexInventario where Id = '" + ids.getId() + "'");
		}
		objeto = new MexInventario();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update MexInventario set IdEntradas='" + valoresDefault.getEntero(request.getParameter("IdEntradas")) + "',Producto='" + request.getParameter("Producto") + "',Unidad='" + request.getParameter("Unidad") + "',Cantidad='" + valoresDefault.getDecimal(request.getParameter("Cantidad")) + "',Ubicacion='" + request.getParameter("Ubicacion") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into MexInventarioApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdEntradas,Producto,Unidad,Cantidad,Ubicacion) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdEntradas,Producto,Unidad,Cantidad,Ubicacion from MexInventario where Id = '" + request.getParameter("id") + "'");
		objeto = new MexInventario();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getMexInventario")) {
		resultados = sentencia.executeQuery("select Id, <columna> from MexInventario where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<MexInventario> info = new ArrayList<MexInventario>();
		while(resultados.next()) {
			objeto = new MexInventario();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
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

/* MexInventarioServlet.jsp */
%>



