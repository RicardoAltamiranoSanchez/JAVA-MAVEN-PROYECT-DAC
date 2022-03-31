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
<%@ page import="Objetos.MexRegistroSalidasAlmacen"%>
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
private void imprimeJson(HttpServletResponse response, MexRegistroSalidasAlmacen objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<MexRegistroSalidasAlmacen> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(MexRegistroSalidasAlmacen objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("MexRegistroSalidasAlmacenServlet.jsp");
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
MexRegistroSalidasAlmacen objeto = null;
int ultimoId = 0;

try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new MexRegistroSalidasAlmacen();
		objeto.setIdMexRegistroEntradasAlmacen(request.getParameter("Campo"));
		//objeto.setPrefijo(request.getParameter("Campo"));
		//objeto.setAwb(request.getParameter("Campo"));
		//objeto.setObservaciones(request.getParameter("Campo"));
		//objeto.setFechaHora(request.getParameter("Campo"));

		if(!objeto.getIdMexRegistroEntradasAlmacen().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdMexRegistroEntradasAlmacen like '" + objeto.getIdMexRegistroEntradasAlmacen() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getPrefijo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Prefijo like '" + objeto.getPrefijo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getAwb().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Awb like '" + objeto.getAwb() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getObservaciones().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Observaciones like '" + objeto.getObservaciones() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.*, RE.Nombre as Visitante, RE.Gafete from MexRegistroSalidasAlmacen as A left join MexRegistroEntradasAlmacen as RE on (RE.Id = A.IdMexRegistroEntradasAlmacen)" + whereInicio + where.toString());
		ArrayList<MexRegistroSalidasAlmacen> info = new ArrayList<MexRegistroSalidasAlmacen>();
		while(resultados.next()) {
			objeto = new MexRegistroSalidasAlmacen();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdMexRegistroEntradasAlmacen(resultados.getString("Visitante")+" / "+resultados.getString("Gafete"));
		objeto.setPrefijo(resultados.getString("Prefijo"));
		objeto.setAwb(resultados.getString("Awb"));
		objeto.setObservaciones(resultados.getString("Observaciones"));
		objeto.setFechaHora(resultados.getString("FechaHora"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("update MexRegistroEntradasAlmacen Set Estatus = 'INACTIVO' where Id =  '"+request.getParameter("IdMexRegistroEntradasAlmacen")+"'");
		sentencia.executeUpdate("insert into MexRegistroSalidasAlmacen (U,G,E,Bloquear,IdMexRegistroEntradasAlmacen,Prefijo,Awb,Observaciones,FechaHora) values ('1','2','3','false','" + request.getParameter("IdMexRegistroEntradasAlmacen") + "','" + request.getParameter("Prefijo") + "','" + valoresDefault.getEntero(request.getParameter("Awb")) + "','" + valoresDefault.getEntero(request.getParameter("Observaciones")) + "',now())",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into MexRegistroSalidasAlmacenApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdMexRegistroEntradasAlmacen,Prefijo,Awb,Observaciones) select '1',now(),Id,U,G,E,Bloquear,IdMexRegistroEntradasAlmacen,Prefijo,Awb,Observaciones from MexRegistroSalidasAlmacen where Id = '" + ultimoId + "'");
		objeto = new MexRegistroSalidasAlmacen();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			MexRegistroSalidasAlmacen[] ids = gson.fromJson(request.getParameter("Ids"), MexRegistroSalidasAlmacen[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into MexRegistroSalidasAlmacenApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdMexRegistroEntradasAlmacen,Prefijo,Awb,Observaciones) select '1',now(),'Si',Id,U,G,E,Bloquear,IdMexRegistroEntradasAlmacen,Prefijo,Awb,Observaciones from MexRegistroSalidasAlmacen where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from MexRegistroSalidasAlmacen where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			MexRegistroSalidasAlmacen ids = gson.fromJson(request.getParameter("Ids"), MexRegistroSalidasAlmacen.class);
			sentencia.executeUpdate("insert into MexRegistroSalidasAlmacenApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdMexRegistroEntradasAlmacen,Prefijo,Awb,Observaciones) select '1',now(),'Si',Id,U,G,E,Bloquear,IdMexRegistroEntradasAlmacen,Prefijo,Awb,Observaciones from MexRegistroSalidasAlmacen where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from MexRegistroSalidasAlmacen where Id = '" + ids.getId() + "'");
		}
		objeto = new MexRegistroSalidasAlmacen();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update MexRegistroSalidasAlmacen set IdMexRegistroEntradasAlmacen='" + request.getParameter("IdMexRegistroEntradasAlmacen") + "',Prefijo='" + request.getParameter("Prefijo") + "',Awb='" + valoresDefault.getEntero(request.getParameter("Awb")) + "',Observaciones='" + valoresDefault.getEntero(request.getParameter("Observaciones")) + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into MexRegistroSalidasAlmacenApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdMexRegistroEntradasAlmacen,Prefijo,Awb,Observaciones) select '1',now(),Id,U,G,E,Bloquear,IdMexRegistroEntradasAlmacen,Prefijo,Awb,Observaciones from MexRegistroSalidasAlmacen where Id = '" + request.getParameter("id") + "'");
		objeto = new MexRegistroSalidasAlmacen();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getMexRegistroSalidasAlmacen")) {
		resultados = sentencia.executeQuery("select Id, IdMexRegistroEntradasAlmacen, Prefijo, Awb, Observaciones from MexRegistroSalidasAlmacen where IdMexRegistroEntradasAlmacen like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<MexRegistroSalidasAlmacen> info = new ArrayList<MexRegistroSalidasAlmacen>();
		while(resultados.next()) {
			objeto = new MexRegistroSalidasAlmacen();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("IdMexRegistroEntradasAlmacen"));
			objeto.setPrefijo(resultados.getString("Prefijo"));
			objeto.setAwb(resultados.getString("Awb"));
			objeto.setObservaciones(resultados.getString("Observaciones"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new MexRegistroSalidasAlmacen();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new MexRegistroSalidasAlmacen();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* MexRegistroSalidasAlmacenServlet.jsp */
%>



