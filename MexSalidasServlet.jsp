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
<%@ page import="Objetos.MexSalidas"%>
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
private void imprimeJson(HttpServletResponse response, MexSalidas objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MexSalidas> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MexSalidas objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MexSalidasServlet.jsp");
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
MexSalidas objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexSalidas();
		objeto.setIdEntradas(request.getParameter("Campo"));
		//objeto.setFecha(request.getParameter("Campo"));
		//objeto.setCantidad(request.getParameter("Campo"));
		//objeto.setProducto(request.getParameter("Campo"));
		//objeto.setUnidad(request.getParameter("Campo"));
		//objeto.setAplicacion(request.getParameter("Campo"));
		//objeto.setComentarios(request.getParameter("Campo"));

		if(!objeto.getIdEntradas().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdEntradas like '" + objeto.getIdEntradas() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCantidad().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Cantidad like '" + objeto.getCantidad() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getProducto().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Producto like '" + objeto.getProducto() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getUnidad().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Unidad like '" + objeto.getUnidad() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getAplicacion().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Aplicacion like '" + objeto.getAplicacion() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getComentarios().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Comentarios like '" + objeto.getComentarios() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from MexSalidas as A" + whereInicio + where.toString());
		ArrayList<MexSalidas> info = new ArrayList<MexSalidas>();
		while(resultados.next()) {
			objeto = new MexSalidas();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdEntradas(resultados.getString("IdEntradas"));
		objeto.setFecha(resultados.getString("Fecha"));
		objeto.setCantidad(resultados.getString("Cantidad"));
		objeto.setProducto(resultados.getString("Producto"));
		objeto.setUnidad(resultados.getString("Unidad"));
		objeto.setAplicacion(resultados.getString("Aplicacion"));
		objeto.setComentarios(resultados.getString("Comentarios"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into MexSalidas (U,G,E,Bloquear,IdEntradas,Fecha,Cantidad,Producto,Unidad,Aplicacion,Comentarios) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdEntradas")) + "','" + valoresDefault.getFecha(request.getParameter("Fecha")) + "','" + valoresDefault.getDecimal(request.getParameter("Cantidad")) + "','" + request.getParameter("Producto") + "','" + request.getParameter("Unidad") + "','" + request.getParameter("Aplicacion") + "','" + request.getParameter("Comentarios") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into MexSalidasApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdEntradas,Fecha,Cantidad,Producto,Unidad,Aplicacion,Comentarios) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdEntradas,Fecha,Cantidad,Producto,Unidad,Aplicacion,Comentarios from MexSalidas where Id = '" + ultimoId + "'");
		objeto = new MexSalidas();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			MexSalidas[] ids = gson.fromJson(request.getParameter("Ids"), MexSalidas[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into MexSalidasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdEntradas,Fecha,Cantidad,Producto,Unidad,Aplicacion,Comentarios) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdEntradas,Fecha,Cantidad,Producto,Unidad,Aplicacion,Comentarios from MexSalidas where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from MexSalidas where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			MexSalidas ids = gson.fromJson(request.getParameter("Ids"), MexSalidas.class);
			sentencia.executeUpdate("insert into MexSalidasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdEntradas,Fecha,Cantidad,Producto,Unidad,Aplicacion,Comentarios) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdEntradas,Fecha,Cantidad,Producto,Unidad,Aplicacion,Comentarios from MexSalidas where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from MexSalidas where Id = '" + ids.getId() + "'");
		}
		objeto = new MexSalidas();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update MexSalidas set IdEntradas='" + valoresDefault.getEntero(request.getParameter("IdEntradas")) + "',Fecha='" + valoresDefault.getFecha(request.getParameter("Fecha")) + "',Cantidad='" + valoresDefault.getDecimal(request.getParameter("Cantidad")) + "',Producto='" + request.getParameter("Producto") + "',Unidad='" + request.getParameter("Unidad") + "',Aplicacion='" + request.getParameter("Aplicacion") + "',Comentarios='" + request.getParameter("Comentarios") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into MexSalidasApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdEntradas,Fecha,Cantidad,Producto,Unidad,Aplicacion,Comentarios) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdEntradas,Fecha,Cantidad,Producto,Unidad,Aplicacion,Comentarios from MexSalidas where Id = '" + request.getParameter("id") + "'");
		objeto = new MexSalidas();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getMexSalidas")) {
		resultados = sentencia.executeQuery("select Id, <columna> from MexSalidas where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<MexSalidas> info = new ArrayList<MexSalidas>();
		while(resultados.next()) {
			objeto = new MexSalidas();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new MexSalidas();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MexSalidas();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MexSalidasServlet.jsp */
%>



