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
<%@ page import="Objetos.MexReqPreAutorizar"%>
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
private void imprimeJson(HttpServletResponse response, MexReqPreAutorizar objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MexReqPreAutorizar> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MexReqPreAutorizar objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MexReqPreAutorizarServlet.jsp");
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
MexReqPreAutorizar objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar") || request.getParameter("Accion").equals("Autorizar") || request.getParameter("Accion").equals("Rechazar")) {
		if(request.getParameter("Accion").equals("Autorizar")) {
			gson = new Gson();
			try {
				MexReqPreAutorizar[] ids = gson.fromJson(request.getParameter("Ids"), MexReqPreAutorizar[].class);
				for(int i = 0; i < ids.length; i++) {
					
					sentencia.executeUpdate("update MexRequerimientos set Estatus = 'PreAutorizar', Bloquear = 'true' where Id = '" + ids[i].getId() + "'");
					sentencia.executeUpdate("insert into MexRequerimientosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades from MexRequerimientos where Id = '" + ids[i].getId() + "'");
					
					sentencia.executeUpdate("update MexReqProductos set Estatus = 'PreAutorizar', Bloquear = 'true' where IdRequerimientos = '" + ids[i].getId() + "'");
					sentencia.executeUpdate("insert into MexReqProductosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra from MexReqProductos where IdRequerimientos = '" + ids[i].getId() + "'");
					
				}
			} catch(JsonSyntaxException e1) {
				MexReqPreAutorizar ids = gson.fromJson(request.getParameter("Ids"), MexReqPreAutorizar.class);
				
				sentencia.executeUpdate("update MexRequerimientos set Estatus = 'PreAutorizar', Bloquear = 'true' where Id = '" + ids.getId() + "'");
				sentencia.executeUpdate("insert into MexRequerimientosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades from MexRequerimientos where Id = '" + ids.getId() + "'");
				
				sentencia.executeUpdate("update MexReqProductos set Estatus = 'PreAutorizar', Bloquear = 'true' where IdRequerimientos = '" + ids.getId() + "'");
				sentencia.executeUpdate("insert into MexReqProductosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra from MexReqProductos where IdRequerimientos = '" + ids.getId() + "'");
				
			}
		}
		else if(request.getParameter("Accion").equals("Rechazar")) {
			gson = new Gson();
			try {
				MexReqPreAutorizar[] ids = gson.fromJson(request.getParameter("Ids"), MexReqPreAutorizar[].class);
				for(int i = 0; i < ids.length; i++) {
					
					sentencia.executeUpdate("update MexRequerimientos set Estatus = 'Rechazado', Bloquear = 'true', Motivo = '" + request.getParameter("Motivo") + "' where Id = '" + ids[i].getId() + "'");
					sentencia.executeUpdate("insert into MexRequerimientosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,Motivo from MexRequerimientos where Id = '" + ids[i].getId() + "'");
					
					sentencia.executeUpdate("update MexReqProductos set Estatus = 'Rechazado', Bloquear = 'true' where IdRequerimientos = '" + ids[i].getId() + "'");
					sentencia.executeUpdate("insert into MexReqProductosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra from MexReqProductos where IdRequerimientos = '" + ids[i].getId() + "'");
					
				}
			} catch(JsonSyntaxException e1) {
				MexReqPreAutorizar ids = gson.fromJson(request.getParameter("Ids"), MexReqPreAutorizar.class);
				
				sentencia.executeUpdate("update MexRequerimientos set Estatus = 'Rechazado', Bloquear = 'true', Motivo = '" + request.getParameter("Motivo") + "' where Id = '" + ids.getId() + "'");
				sentencia.executeUpdate("insert into MexRequerimientosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,Motivo from MexRequerimientos where Id = '" + ids.getId() + "'");
				
				sentencia.executeUpdate("update MexReqProductos set Estatus = 'Rechazado', Bloquear = 'true' where IdRequerimientos = '" + ids.getId() + "'");
				sentencia.executeUpdate("insert into MexReqProductosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdRequerimientos,Cantidad,Producto,Unidad,Precio,Estatus,IdOrdenCompra from MexReqProductos where IdRequerimientos = '" + ids.getId() + "'");
	
			}
		}
		
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexReqPreAutorizar();
		//objeto.setFecha(request.getParameter("Fecha"));
		//objeto.setAlias(request.getParameter("Alias"));
		objeto.setNombre(request.getParameter("Nombre"));
		//objeto.setEmpresa(request.getParameter("Empresa"));
		objeto.setArea(request.getParameter("Area"));
		//objeto.setUnidad(request.getParameter("Unidad"));
		//objeto.setPrincipal(request.getParameter("Principal"));
		//objeto.setSoporte1(request.getParameter("Soporte1"));
		//objeto.setSoporte2(request.getParameter("Soporte2"));

		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getAlias().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Alias like '" + objeto.getAlias() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEmpresa().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Empresa like '" + objeto.getEmpresa() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getArea().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Area like '" + objeto.getArea() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getUnidad().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Unidad like '" + objeto.getUnidad() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getPrincipal().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Principal like '" + objeto.getPrincipal() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getSoporte1().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Soporte1 like '" + objeto.getSoporte1() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getSoporte2().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Soporte2 like '" + objeto.getSoporte2() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from MexReqPreAutorizar as A" + whereInicio + where.toString());
		ArrayList<MexReqPreAutorizar> info = new ArrayList<MexReqPreAutorizar>();
		while(resultados.next()) {
			objeto = new MexReqPreAutorizar();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setAlias(resultados.getString("Alias"));
			objeto.setNombre(resultados.getString("Nombre"));
			objeto.setEmpresa(resultados.getString("Empresa"));
			objeto.setArea(resultados.getString("Area"));
			objeto.setUnidad(resultados.getString("Unidad"));
			if(resultados.getString("Principal") == null) {
				objeto.setPrincipal("");
			} else {
				objeto.setPrincipal(resultados.getString("Principal").replaceAll(" ","_"));
			}
			if(resultados.getString("Soporte1") == null) {
				objeto.setSoporte1("");
			} else {
				objeto.setSoporte1(resultados.getString("Soporte1").replaceAll(" ","_"));
			}
			if(resultados.getString("Soporte2") == null) {
				objeto.setSoporte2("");
			} else {
				objeto.setSoporte2(resultados.getString("Soporte2").replaceAll(" ","_"));
			}
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	
	conexion.close();
} catch(SQLException e) {
	objeto = new MexReqPreAutorizar();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MexReqPreAutorizar();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MexReqPreAutorizarServlet.jsp */
%>



