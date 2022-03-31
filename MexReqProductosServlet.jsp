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
<%@ page import="Objetos.MexReqProductos"%>
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
private void imprimeJson(HttpServletResponse response, MexReqProductos objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MexReqProductos> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MexReqProductos objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MexReqProductosServlet.jsp");
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
MexReqProductos objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexReqProductos();
		objeto.setIdRequerimientos(request.getParameter("Campo"));
		//objeto.setCantidad(request.getParameter("Campo"));
		//objeto.setProducto(request.getParameter("Campo"));
		//objeto.setUnidad(request.getParameter("Campo"));
		//objeto.setPrecio(request.getParameter("Campo"));
		//objeto.setEstatus(request.getParameter("Campo"));
		//objeto.setIdOrdenCompra(request.getParameter("Campo"));

		if(!objeto.getIdRequerimientos().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdRequerimientos like '" + objeto.getIdRequerimientos() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCantidad().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Cantidad like '" + objeto.getCantidad() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getProducto().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Producto like '" + objeto.getProducto() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getUnidad().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Unidad like '" + objeto.getUnidad() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getPrecio().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Precio like '" + objeto.getPrecio() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEstatus().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Estatus like '" + objeto.getEstatus() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getIdOrdenCompra().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdOrdenCompra like '" + objeto.getIdOrdenCompra() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from MexReqProductos as A" + whereInicio + where.toString());
		ArrayList<MexReqProductos> info = new ArrayList<MexReqProductos>();
		while(resultados.next()) {
			objeto = new MexReqProductos();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setIdRequerimientos(resultados.getString("IdRequerimientos"));
			objeto.setCantidad(resultados.getString("Cantidad"));
			objeto.setProducto(resultados.getString("Producto"));
			objeto.setUnidad(resultados.getString("Unidad"));
			objeto.setPrecio(resultados.getString("Precio"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setIdOrdenCompra(resultados.getString("IdOrdenCompra"));
			objeto.setIva(resultados.getString("Iva"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into MexReqProductos (U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra,Iva) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdRequerimientos")) + "','" + valoresDefault.getDecimal(request.getParameter("Cantidad")) + "','" + request.getParameter("Producto") + "','" + request.getParameter("Unidad") + "','" + valoresDefault.getDecimal(request.getParameter("Precio")) + "','" + request.getParameter("Estatus") + "','" + valoresDefault.getEntero(request.getParameter("IdOrdenCompra")) + "','" + valoresDefault.getEntero(request.getParameter("Iva")) + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into MexReqProductosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra,Iva) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra,Iva from MexReqProductos where Id = '" + ultimoId + "'");
		objeto = new MexReqProductos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			MexReqProductos[] ids = gson.fromJson(request.getParameter("Ids"), MexReqProductos[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into MexReqProductosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra,Iva) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra,Iva from MexReqProductos where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from MexReqProductos where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			MexReqProductos ids = gson.fromJson(request.getParameter("Ids"), MexReqProductos.class);
			sentencia.executeUpdate("insert into MexReqProductosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra,Iva) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra,Iva from MexReqProductos where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from MexReqProductos where Id = '" + ids.getId() + "'");
		}
		objeto = new MexReqProductos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update MexReqProductos set IdRequerimientos='" + valoresDefault.getEntero(request.getParameter("IdRequerimientos")) + "',Cantidad='" + valoresDefault.getDecimal(request.getParameter("Cantidad")) + "',Producto='" + request.getParameter("Producto") + "',Unidad='" + request.getParameter("Unidad") + "',Precio='" + valoresDefault.getDecimal(request.getParameter("Precio")) + "',Estatus='" + request.getParameter("Estatus") + "',IdOrdenCompra='" + valoresDefault.getEntero(request.getParameter("IdOrdenCompra")) + "',Iva='" + valoresDefault.getEntero(request.getParameter("Iva")) + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into MexReqProductosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra,Iva) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra,Iva from MexReqProductos where Id = '" + request.getParameter("id") + "'");
		objeto = new MexReqProductos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getMexReqProductos")) {
		resultados = sentencia.executeQuery("select Id, <columna> from MexReqProductos where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<MexReqProductos> info = new ArrayList<MexReqProductos>();
		while(resultados.next()) {
			objeto = new MexReqProductos();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new MexReqProductos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MexReqProductos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MexReqProductosServlet.jsp */
%>



