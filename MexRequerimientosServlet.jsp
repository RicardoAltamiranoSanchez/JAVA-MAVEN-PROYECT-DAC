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
<%@ page import="Objetos.MexRequerimientos"%>
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
private void imprimeJson(HttpServletResponse response, MexRequerimientos objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MexRequerimientos> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MexRequerimientos objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MexRequerimientosServlet.jsp");
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
MexRequerimientos objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(3,session,new String[]{""}) + " and P.Id = A.IdProveedores and A.Estatus = ''";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexRequerimientos();
		objeto.setFecha(request.getParameter("Campo"));
		//objeto.setIdPara(request.getParameter("Campo"));
		//objeto.setIdProveedores(request.getParameter("Campo"));
		//objeto.setJustificacion(request.getParameter("Campo"));

		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(3,session,new String[]{""}) + " and P.Id = A.IdProveedores and A.Estatus = '' and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.*, " + 
				"if((select Archivo from MexReqArchivos where IdRequerimientos = A.Id and Tipo = 'PRINCIPAL' limit 1) is null,'FALTA COT.PRINCIPAL'," +
				"if((select Archivo from MexReqArchivos where IdRequerimientos = A.Id and Tipo = 'SOPORTE' limit 1) is null,'FALTA COT.SOPORTE'," + 
				"if((select Producto from MexReqProductos where IdRequerimientos = A.Id limit 1) is null,'FALTAN PRODUCTOS','OK')" +
				")) Estatus1, " + 
				"P.Alias " + 
			"from MexRequerimientos as A, MexProveedores P" + whereInicio + where.toString());
		ArrayList<MexRequerimientos> info = new ArrayList<MexRequerimientos>();
		while(resultados.next()) {
			objeto = new MexRequerimientos();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdPara(resultados.getString("IdPara"));
			objeto.setIdProveedores(resultados.getString("IdProveedores"));
			objeto.setProveedores(resultados.getString("Alias"));
			objeto.setJustificacion(resultados.getString("Justificacion"));
			objeto.setIdEmpresas(resultados.getString("IdEmpresas"));
			objeto.setIdAreas(resultados.getString("IdAreas"));
			objeto.setIdUnidades(resultados.getString("IdUnidades"));
			objeto.setEstatus(resultados.getString("Estatus1"));
			objeto.setFormaPago(resultados.getString("FormaPago"));
			objeto.setMetodoPago(resultados.getString("MetodoPago"));
			objeto.setInstruccionesPago(resultados.getString("InstruccionesPago"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into MexRequerimientos (U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,FormaPago,MetodoPago,InstruccionesPago) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getFecha(request.getParameter("Fecha")) + "','" + valoresDefault.getEntero(request.getParameter("IdPara")) + "','" + valoresDefault.getEntero(request.getParameter("IdProveedores")) + "','" + request.getParameter("Justificacion") + "','" + valoresDefault.getEntero(request.getParameter("IdEmpresas")) + "','" + valoresDefault.getEntero(request.getParameter("IdAreas")) + "','" + valoresDefault.getEntero(request.getParameter("IdUnidades")) + "','" + request.getParameter("FormaPago") + "','" + request.getParameter("MetodoPago") + "','" + request.getParameter("InstruccionesPago") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into MexRequerimientosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,FormaPago,MetodoPago,InstruccionesPago) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,FormaPago,MetodoPago,InstruccionesPago from MexRequerimientos where Id = '" + ultimoId + "'");
		objeto = new MexRequerimientos();
		objeto.setId("" + ultimoId);
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			MexRequerimientos[] ids = gson.fromJson(request.getParameter("Ids"), MexRequerimientos[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into MexRequerimientosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,FormaPago,InstruccionesPago) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,FormaPago,MetodoPago,InstruccionesPago from MexRequerimientos where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from MexRequerimientos where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			MexRequerimientos ids = gson.fromJson(request.getParameter("Ids"), MexRequerimientos.class);
			sentencia.executeUpdate("insert into MexRequerimientosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,FormaPago,InstruccionesPago) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,FormaPago,MetodoPago,InstruccionesPago from MexRequerimientos where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from MexRequerimientos where Id = '" + ids.getId() + "'");
		}
		objeto = new MexRequerimientos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update MexRequerimientos set Fecha='" + valoresDefault.getFecha(request.getParameter("Fecha")) + "',IdPara='" + valoresDefault.getEntero(request.getParameter("IdPara")) + "',IdProveedores='" + valoresDefault.getEntero(request.getParameter("IdProveedores")) + "',Justificacion='" + request.getParameter("Justificacion") + "',IdEmpresas='" + valoresDefault.getEntero(request.getParameter("IdEmpresas")) + "',IdAreas='" + valoresDefault.getEntero(request.getParameter("IdAreas")) + "',IdUnidades='" + valoresDefault.getEntero(request.getParameter("IdUnidades")) + "',FormaPago='" + request.getParameter("FormaPago") + "',MetodoPago='" + request.getParameter("MetodoPago") + "',InstruccionesPago='" + request.getParameter("InstruccionesPago") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into MexRequerimientosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,FormaPago,InstruccionesPago) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,IdPara,IdProveedores,Justificacion,IdEmpresas,IdAreas,IdUnidades,FormaPago,InstruccionesPago from MexRequerimientos where Id = '" + request.getParameter("id") + "'");
		objeto = new MexRequerimientos();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Consultar")) {
		resultados = sentencia.executeQuery("select A.* from MexRequerimientos as A where A.Id = '" + request.getParameter("Id") + "'");
		while(resultados.next()) {
			objeto = new MexRequerimientos();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdPara(resultados.getString("IdPara"));
			objeto.setIdProveedores(resultados.getString("IdProveedores"));
			objeto.setJustificacion(resultados.getString("Justificacion"));
			objeto.setIdEmpresas(resultados.getString("IdEmpresas"));
			objeto.setIdAreas(resultados.getString("IdAreas"));
			objeto.setIdUnidades(resultados.getString("IdUnidades"));
			objeto.setFormaPago(resultados.getString("FormaPago"));
			objeto.setMetodoPago(resultados.getString("MetodoPago"));
			objeto.setInstruccionesPago(resultados.getString("InstruccionesPago"));
		}
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getMexRequerimientos")) {
		resultados = sentencia.executeQuery("select Id, <columna> from MexRequerimientos where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<MexRequerimientos> info = new ArrayList<MexRequerimientos>();
		while(resultados.next()) {
			objeto = new MexRequerimientos();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new MexRequerimientos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MexRequerimientos();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MexRequerimientosServlet.jsp */
%>



