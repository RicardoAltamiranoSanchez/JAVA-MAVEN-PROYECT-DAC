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
<%@ page import="Objetos.RegistroSalidasAlmacenGdl"%>
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
private void imprimeJson(HttpServletResponse response, RegistroSalidasAlmacenGdl objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<RegistroSalidasAlmacenGdl> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(RegistroSalidasAlmacenGdl objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("RegistroSalidasAlmacenGdlServlet.jsp");
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
RegistroSalidasAlmacenGdl objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new RegistroSalidasAlmacenGdl();
		objeto.setIdRegistroEntradasAlmacenGdl(request.getParameter("Campo"));
		//objeto.setPrefijo(request.getParameter("Campo"));
		//objeto.setAwb(request.getParameter("Campo"));
		//objeto.setObservaciones(request.getParameter("Campo"));
		//objeto.setFechaHora(request.getParameter("Campo"));

		if(!objeto.getIdRegistroEntradasAlmacenGdl().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdRegistroEntradasAlmacenGdl like '" + objeto.getIdRegistroEntradasAlmacenGdl() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getPrefijo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Prefijo like '" + objeto.getPrefijo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getAwb().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Awb like '" + objeto.getAwb() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getObservaciones().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Observaciones like '" + objeto.getObservaciones() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.*, RE.Nombre as Visitante, RE.Gafete from RegistroSalidasAlmacenGdl as A left join RegistroEntradasAlmacenGdl as RE on (RE.Id = A.IdRegistroEntradasAlmacenGdl)" + whereInicio + where.toString());
		ArrayList<RegistroSalidasAlmacenGdl> info = new ArrayList<RegistroSalidasAlmacenGdl>();
		while(resultados.next()) {
			objeto = new RegistroSalidasAlmacenGdl();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdRegistroEntradasAlmacenGdl(resultados.getString("Visitante")+" / "+resultados.getString("Gafete"));
		objeto.setPrefijo(resultados.getString("Prefijo"));
		objeto.setAwb(resultados.getString("Awb"));
		objeto.setObservaciones(resultados.getString("Observaciones"));
		objeto.setFechaHora(resultados.getString("FechaHora"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("update RegistroEntradasAlmacenGdl Set Estatus = 'INACTIVO' where Id =  '"+request.getParameter("IdRegistroEntradasAlmacenGdl")+"'");
		sentencia.executeUpdate("insert into RegistroSalidasAlmacenGdl (U,G,E,Bloquear,IdRegistroEntradasAlmacenGdl,Prefijo,Awb,Observaciones,FechaHora) values ('1','2','3','false','" + request.getParameter("IdRegistroEntradasAlmacenGdl") + "','" + request.getParameter("Prefijo") + "','" + valoresDefault.getEntero(request.getParameter("Awb")) + "','" + valoresDefault.getEntero(request.getParameter("Observaciones")) + "',now())",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into RegistroSalidasAlmacenGdlApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRegistroEntradasAlmacenGdl,Prefijo,Awb,Observaciones) select '1',now(),Id,U,G,E,Bloquear,IdRegistroEntradasAlmacenGdl,Prefijo,Awb,Observaciones from RegistroSalidasAlmacenGdl where Id = '" + ultimoId + "'");
		objeto = new RegistroSalidasAlmacenGdl();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			RegistroSalidasAlmacenGdl[] ids = gson.fromJson(request.getParameter("Ids"), RegistroSalidasAlmacenGdl[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into RegistroSalidasAlmacenGdlApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRegistroEntradasAlmacenGdl,Prefijo,Awb,Observaciones) select '1',now(),'Si',Id,U,G,E,Bloquear,IdRegistroEntradasAlmacenGdl,Prefijo,Awb,Observaciones from RegistroSalidasAlmacenGdl where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from RegistroSalidasAlmacenGdl where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			RegistroSalidasAlmacenGdl ids = gson.fromJson(request.getParameter("Ids"), RegistroSalidasAlmacenGdl.class);
			sentencia.executeUpdate("insert into RegistroSalidasAlmacenGdlApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdRegistroEntradasAlmacenGdl,Prefijo,Awb,Observaciones) select '1',now(),'Si',Id,U,G,E,Bloquear,IdRegistroEntradasAlmacenGdl,Prefijo,Awb,Observaciones from RegistroSalidasAlmacenGdl where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from RegistroSalidasAlmacenGdl where Id = '" + ids.getId() + "'");
		}
		objeto = new RegistroSalidasAlmacenGdl();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update RegistroSalidasAlmacenGdl set IdRegistroEntradasAlmacenGdl='" + request.getParameter("IdRegistroEntradasAlmacenGdl") + "',Prefijo='" + request.getParameter("Prefijo") + "',Awb='" + valoresDefault.getEntero(request.getParameter("Awb")) + "',Observaciones='" + valoresDefault.getEntero(request.getParameter("Observaciones")) + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into RegistroSalidasAlmacenGdlApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdRegistroEntradasAlmacenGdl,Prefijo,Awb,Observaciones) select '1',now(),Id,U,G,E,Bloquear,IdRegistroEntradasAlmacenGdl,Prefijo,Awb,Observaciones from RegistroSalidasAlmacenGdl where Id = '" + request.getParameter("id") + "'");
		objeto = new RegistroSalidasAlmacenGdl();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getRegistroSalidasAlmacenGdl")) {
		resultados = sentencia.executeQuery("select Id, IdRegistroEntradasAlmacenGdl, Prefijo, Awb, Observaciones from RegistroSalidasAlmacenGdl where IdRegistroEntradasAlmacenGdl like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<RegistroSalidasAlmacenGdl> info = new ArrayList<RegistroSalidasAlmacenGdl>();
		while(resultados.next()) {
			objeto = new RegistroSalidasAlmacenGdl();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("IdRegistroEntradasAlmacenGdl"));
			objeto.setPrefijo(resultados.getString("Prefijo"));
			objeto.setAwb(resultados.getString("Awb"));
			objeto.setObservaciones(resultados.getString("Observaciones"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new RegistroSalidasAlmacenGdl();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new RegistroSalidasAlmacenGdl();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* RegistroSalidasAlmacenGdlServlet.jsp */
%>



