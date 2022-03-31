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
<%@ page import="Objetos.RegistroSalidasAlmacenes"%>
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
private void imprimeJson(HttpServletResponse response, RegistroSalidasAlmacenes objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<RegistroSalidasAlmacenes> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(RegistroSalidasAlmacenes objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("RegistroSalidasAlmacenesServlet.jsp"); //??
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
//validar(request,response);
Connection conexion = null;
Statement sentencia = null;
ResultSet resultados = null;
RegistroSalidasAlmacenes objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new RegistroSalidasAlmacenes();
		objeto.setIdRegistroEntradasAlmacenes(request.getParameter("Campo"));
		//objeto.setPrefijo(request.getParameter("Campo"));
		//objeto.setAwb(request.getParameter("Campo"));
		//objeto.setObservaciones(request.getParameter("Campo"));
		//objeto.setFechaHora(request.getParameter("Campo"));

		if(!objeto.getIdRegistroEntradasAlmacenes().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdRegistroEntradasAlmacenes like '" + objeto.getIdRegistroEntradasAlmacenes() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getPrefijo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Prefijo like '" + objeto.getPrefijo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getAwb().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Awb like '" + objeto.getAwb() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getObservaciones().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Observaciones like '" + objeto.getObservaciones() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.*, RE.Nombre as Visitante, RE.Gafete from RegistroSalidasAlmacenes as A left join RegistroEntradasAlmacenes as RE on (RE.Id = A.IdRegistroEntradasAlmacenes)" + whereInicio + where.toString());
		ArrayList<RegistroSalidasAlmacenes> info = new ArrayList<RegistroSalidasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroSalidasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdRegistroEntradasAlmacenes(resultados.getString("Visitante")+" / "+resultados.getString("Gafete"));
		objeto.setPrefijo(resultados.getString("Prefijo"));
		objeto.setAwb(resultados.getString("Awb"));
		objeto.setObservaciones(resultados.getString("Observaciones"));
		objeto.setFechaHora(resultados.getString("FechaHora"));
		objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("update RegistroEntradasAlmacenes Set Estatus = 'INACTIVO' where Id =  '"+request.getParameter("IdRegistroEntradasAlmacenes")+"'");
		sentencia.executeUpdate("insert into RegistroSalidasAlmacenes (U,G,E,Bloquear,IdRegistroEntradasAlmacenes,Prefijo,Awb,Observaciones,FechaHora,Estacion) values ('1','2','3','false','" + request.getParameter("IdRegistroEntradasAlmacenes") + "','" + request.getParameter("Prefijo") + "','" + valoresDefault.getEntero(request.getParameter("Awb")) + "','" + valoresDefault.getEntero(request.getParameter("Observaciones")) + "',now(),'" + request.getParameter("Estacion") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into RegistroSalidasAlmacenesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRegistroEntradasAlmacenes,Prefijo,Awb,Observaciones,FechaHora,Estacion) select '1',now(),Id,U,G,E,Bloquear,IdRegistroEntradasAlmacenes,Prefijo,Awb,Observaciones,FechaHora,Estacion from RegistroSalidasAlmacenes where Id = '" + ultimoId + "'");
		objeto = new RegistroSalidasAlmacenes();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			RegistroSalidasAlmacenes[] ids = gson.fromJson(request.getParameter("Ids"), RegistroSalidasAlmacenes[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into RegistroSalidasAlmacenesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRegistroEntradasAlmacenes,Prefijo,Awb,Observaciones,FechaHora,Estacion) select '1',now(),'Si',Id,U,G,E,Bloquear,IdRegistroEntradasAlmacenes,Prefijo,Awb,Observaciones,FechaHora,Estacion from RegistroSalidasAlmacenes where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from RegistroSalidasAlmacenes where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			RegistroSalidasAlmacenes ids = gson.fromJson(request.getParameter("Ids"), RegistroSalidasAlmacenes.class);
			sentencia.executeUpdate("insert into RegistroSalidasAlmacenesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRegistroEntradasAlmacenes,Prefijo,Awb,Observaciones,FechaHora,Estacion) select '1',now(),'Si',Id,U,G,E,Bloquear,IdRegistroEntradasAlmacenes,Prefijo,Awb,Observaciones,FechaHora,Estacion from RegistroSalidasAlmacenes where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from RegistroSalidasAlmacenes where Id = '" + ids.getId() + "'");
		}
		objeto = new RegistroSalidasAlmacenes();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update RegistroSalidasAlmacenes set IdRegistroEntradasAlmacenes='" + request.getParameter("IdRegistroEntradasAlmacenes") + "',Prefijo='" + request.getParameter("Prefijo") + "',Awb='" + valoresDefault.getEntero(request.getParameter("Awb")) + "',Observaciones='" + valoresDefault.getEntero(request.getParameter("Observaciones")) + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into RegistroSalidasAlmacenesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRegistroEntradasAlmacenes,Prefijo,Awb,Observaciones,FechaHora,Estacion) select '1',now(),Id,U,G,E,Bloquear,IdRegistroEntradasAlmacenes,Prefijo,Awb,Observaciones,FechaHora,Estacion from RegistroSalidasAlmacenes where Id = '" + request.getParameter("id") + "'");
		objeto = new RegistroSalidasAlmacenes();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getRegistroSalidasAlmacenes")) {
		resultados = sentencia.executeQuery("select Id, IdRegistroEntradasAlmacenes, Prefijo, Awb, Observaciones from RegistroSalidasAlmacenes where IdRegistroEntradasAlmacenes like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<RegistroSalidasAlmacenes> info = new ArrayList<RegistroSalidasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroSalidasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("IdRegistroEntradasAlmacenes"));
			objeto.setPrefijo(resultados.getString("Prefijo"));
			objeto.setAwb(resultados.getString("Awb"));
			objeto.setObservaciones(resultados.getString("Observaciones"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new RegistroSalidasAlmacenes();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new RegistroSalidasAlmacenes();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* RegistroSalidaVisitasAlmacenesServlet.jsp */
%>



