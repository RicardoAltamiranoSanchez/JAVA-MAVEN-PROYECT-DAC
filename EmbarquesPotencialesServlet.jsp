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
<%@ page import="Configuraciones.BaseDeDatosPool"%>
<%@ page import="Configuraciones.Generales"%>
<%@ page import="Configuraciones.Seguridad"%>
<%@ page import="Utilerias.Fechas"%>
<%@ page import="Utilerias.ValoresDefault"%>
<%@ page import="Objetos.EmbarquesPotenciales"%>
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
private void imprimeJson(HttpServletResponse response, EmbarquesPotenciales objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<EmbarquesPotenciales> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(EmbarquesPotenciales objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("EmbarquesPotencialesServlet.jsp");
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
EmbarquesPotenciales objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new EmbarquesPotenciales();
		objeto.setFecha(request.getParameter("Campo"));
		objeto.setCliente(request.getParameter("Campo"));
		//objeto.setTelefono(request.getParameter("Campo"));
		objeto.setCorreo(request.getParameter("Campo"));
		objeto.setOrigen(request.getParameter("Campo"));
		objeto.setDestino(request.getParameter("Campo"));
		objeto.setKilos(request.getParameter("Campo"));
		objeto.setDescripcionProducto(request.getParameter("Campo"));

		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCliente().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Cliente like '" + objeto.getCliente() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getTelefono().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Telefono like '" + objeto.getTelefono() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCorreo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Correo like '" + objeto.getCorreo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getOrigen().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Origen like '" + objeto.getOrigen() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getDestino().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Destino like '" + objeto.getDestino() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getKilos().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Kilos like '" + objeto.getKilos() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getDescripcionProducto().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.DescripcionProducto like '" + objeto.getDescripcionProducto() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from EmbarquesPotenciales as A" + whereInicio + where.toString());
		ArrayList<EmbarquesPotenciales> info = new ArrayList<EmbarquesPotenciales>();
		while(resultados.next()) {
			objeto = new EmbarquesPotenciales();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setFecha(resultados.getString("Fecha"));
		objeto.setCliente(resultados.getString("Cliente"));
		objeto.setTelefono(resultados.getString("Telefono"));
		objeto.setCorreo(resultados.getString("Correo"));
		objeto.setOrigen(resultados.getString("Origen"));
		objeto.setDestino(resultados.getString("Destino"));
		objeto.setKilos(resultados.getString("Kilos"));
		objeto.setDescripcionProducto(resultados.getString("DescripcionProducto"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into EmbarquesPotenciales (U,G,E,Bloquear,Fecha,Cliente,Telefono,Correo,Origen,Destino,Kilos,DescripcionProducto) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getFecha(request.getParameter("Fecha")) + "','" + request.getParameter("Cliente") + "','" + request.getParameter("Telefono") + "','" + request.getParameter("Correo") + "','" + request.getParameter("Origen") + "','" + request.getParameter("Destino") + "','" + valoresDefault.getDecimal(request.getParameter("Kilos")) + "','" + request.getParameter("DescripcionProducto") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into EmbarquesPotencialesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,Cliente,Telefono,Correo,Origen,Destino,Kilos,DescripcionProducto) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,Cliente,Telefono,Correo,Origen,Destino,Kilos,DescripcionProducto from EmbarquesPotenciales where Id = '" + ultimoId + "'");
		objeto = new EmbarquesPotenciales();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			EmbarquesPotenciales[] ids = gson.fromJson(request.getParameter("Ids"), EmbarquesPotenciales[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into EmbarquesPotencialesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,Cliente,Telefono,Correo,Origen,Destino,Kilos,DescripcionProducto) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,Cliente,Telefono,Correo,Origen,Destino,Kilos,DescripcionProducto from EmbarquesPotenciales where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from EmbarquesPotenciales where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			EmbarquesPotenciales ids = gson.fromJson(request.getParameter("Ids"), EmbarquesPotenciales.class);
			sentencia.executeUpdate("insert into EmbarquesPotencialesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,Cliente,Telefono,Correo,Origen,Destino,Kilos,DescripcionProducto) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,Cliente,Telefono,Correo,Origen,Destino,Kilos,DescripcionProducto from EmbarquesPotenciales where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from EmbarquesPotenciales where Id = '" + ids.getId() + "'");
		}
		objeto = new EmbarquesPotenciales();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update EmbarquesPotenciales set Fecha='" + valoresDefault.getFecha(request.getParameter("Fecha")) + "',Cliente='" + request.getParameter("Cliente") + "',Telefono='" + request.getParameter("Telefono") + "',Correo='" + request.getParameter("Correo") + "',Origen='" + request.getParameter("Origen") + "',Destino='" + request.getParameter("Destino") + "',Kilos='" + valoresDefault.getDecimal(request.getParameter("Kilos")) + "',DescripcionProducto='" + request.getParameter("DescripcionProducto") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into EmbarquesPotencialesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,Cliente,Telefono,Correo,Origen,Destino,Kilos,DescripcionProducto) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,Cliente,Telefono,Correo,Origen,Destino,Kilos,DescripcionProducto from EmbarquesPotenciales where Id = '" + request.getParameter("id") + "'");
		objeto = new EmbarquesPotenciales();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getEmbarquesPotenciales")) {
		resultados = sentencia.executeQuery("select Id, <columna> from EmbarquesPotenciales where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<EmbarquesPotenciales> info = new ArrayList<EmbarquesPotenciales>();
		while(resultados.next()) {
			objeto = new EmbarquesPotenciales();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new EmbarquesPotenciales();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new EmbarquesPotenciales();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* EmbarquesPotencialesServlet.jsp */
%>


