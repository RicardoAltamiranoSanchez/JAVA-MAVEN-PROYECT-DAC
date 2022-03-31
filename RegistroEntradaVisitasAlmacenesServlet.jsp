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
<%@ page import="Objetos.RegistroEntradasAlmacenes"%>
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
private void imprimeJson(HttpServletResponse response, RegistroEntradasAlmacenes objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<RegistroEntradasAlmacenes> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(RegistroEntradasAlmacenes objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("RegistroEntradasAlmacenesAlmacenesServlet.jsp"); //??
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
RegistroEntradasAlmacenes objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new RegistroEntradasAlmacenes();
		objeto.setNombre(request.getParameter("Campo"));
		//objeto.setGafete(request.getParameter("Campo"));
		//objeto.setEstatus(request.getParameter("Campo"));
		//objeto.setFechaHora(request.getParameter("Campo"));

		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getGafete().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Gafete like '" + objeto.getGafete() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from RegistroEntradasAlmacenes as A" + whereInicio + where.toString());
		ArrayList<RegistroEntradasAlmacenes> info = new ArrayList<RegistroEntradasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroEntradasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setNombre(resultados.getString("Nombre"));
		objeto.setGafete(resultados.getString("Gafete"));
		objeto.setEstatus(resultados.getString("Estatus"));
		objeto.setFechaHora(resultados.getString("FechaHora"));
		objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into RegistroEntradasAlmacenes (U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora,Estacion) values ('1','2','3','false','" + request.getParameter("Nombre") + "','" + request.getParameter("Gafete") + "','ACTIVO',now(),'" + request.getParameter("Estacion") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into RegistroEntradasAlmacenesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora,Estacion) select '1',now(),Id,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora,Estacion from RegistroEntradasAlmacenes where Id = '" + ultimoId + "'");
		objeto = new RegistroEntradasAlmacenes();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			RegistroEntradasAlmacenes[] ids = gson.fromJson(request.getParameter("Ids"), RegistroEntradasAlmacenes[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into RegistroEntradasAlmacenesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora,Estacion) select '1',now(),'Si',Id,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora,Estacion from RegistroEntradasAlmacenes where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from RegistroEntradasAlmacenes where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			RegistroEntradasAlmacenes ids = gson.fromJson(request.getParameter("Ids"), RegistroEntradasAlmacenes.class);
			sentencia.executeUpdate("insert into RegistroEntradasAlmacenesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora,Estacion) select '1',now(),'Si',Id,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora,Estacion from RegistroEntradasAlmacenes where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from RegistroEntradasAlmacenes where Id = '" + ids.getId() + "'");
		}
		objeto = new RegistroEntradasAlmacenes();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update RegistroEntradasAlmacenes set Nombre='" + request.getParameter("Nombre") + "',Gafete='" + request.getParameter("Gafete") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into RegistroEntradasAlmacenesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora,Estacion) select '1',now(),Id,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora,Estacion from RegistroEntradasAlmacenes where Id = '" + request.getParameter("id") + "'");
		objeto = new RegistroEntradasAlmacenes();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getRegistroEntradasAlmacenes")) {
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora, Estacion from RegistroEntradasAlmacenes where Nombre like '" + request.getParameter("filter[value]") + "%' group by Nombre");
		ArrayList<RegistroEntradasAlmacenes> info = new ArrayList<RegistroEntradasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroEntradasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Nombre"));
			objeto.setGafete(resultados.getString("Gafete"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getIdRegistroEntradasAlmacenesActivos")) {
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora, Estacion from RegistroEntradasAlmacenes where Nombre like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO'");
		ArrayList<RegistroEntradasAlmacenes> info = new ArrayList<RegistroEntradasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroEntradasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Nombre")+" "+resultados.getString("Gafete"));
			objeto.setNombre(resultados.getString("Nombre"));
			objeto.setGafete(resultados.getString("Gafete"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getIdRegistroEntradasAlmacenesActivosEst")) {
		String recibe = (request.getParameter("filter[value]"));
		String[] valores = recibe.split(",");
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora, Estacion from RegistroEntradasAlmacenes where Nombre like '" + valores[0] + "%' and Estatus = 'ACTIVO' and Estacion ='"+valores[1]+"'");
		ArrayList<RegistroEntradasAlmacenes> info = new ArrayList<RegistroEntradasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroEntradasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Nombre")+" "+resultados.getString("Gafete"));
			objeto.setNombre(resultados.getString("Nombre"));
			objeto.setGafete(resultados.getString("Gafete"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	/* else if(request.getParameter("Accion").equals("getIdRegistroEntradasAlmacenesActivosGdl")) {
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora, Estacion from RegistroEntradasAlmacenes where Nombre like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO' and Estacion ='GDL'");
		ArrayList<RegistroEntradasAlmacenes> info = new ArrayList<RegistroEntradasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroEntradasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Nombre")+" "+resultados.getString("Gafete"));
			objeto.setNombre(resultados.getString("Nombre"));
			objeto.setGafete(resultados.getString("Gafete"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getIdRegistroEntradasAlmacenesActivosHmo")) {
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora, Estacion from RegistroEntradasAlmacenes where Nombre like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO' and Estacion ='HMO'");
		ArrayList<RegistroEntradasAlmacenes> info = new ArrayList<RegistroEntradasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroEntradasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Nombre")+" "+resultados.getString("Gafete"));
			objeto.setNombre(resultados.getString("Nombre"));
			objeto.setGafete(resultados.getString("Gafete"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getIdRegistroEntradasAlmacenesActivosMxl")) {
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora, Estacion from RegistroEntradasAlmacenes where Nombre like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO' and Estacion ='MXL'");
		ArrayList<RegistroEntradasAlmacenes> info = new ArrayList<RegistroEntradasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroEntradasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Nombre")+" "+resultados.getString("Gafete"));
			objeto.setNombre(resultados.getString("Nombre"));
			objeto.setGafete(resultados.getString("Gafete"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getIdRegistroEntradasAlmacenesActivosMex")) {
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora, Estacion from RegistroEntradasAlmacenes where Nombre like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO' and Estacion ='MEX'");
		ArrayList<RegistroEntradasAlmacenes> info = new ArrayList<RegistroEntradasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroEntradasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Nombre")+" "+resultados.getString("Gafete"));
			objeto.setNombre(resultados.getString("Nombre"));
			objeto.setGafete(resultados.getString("Gafete"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getIdRegistroEntradasAlmacenesActivosCul")) {
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora, Estacion from RegistroEntradasAlmacenes where Nombre like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO' and Estacion ='CUL'");
		ArrayList<RegistroEntradasAlmacenes> info = new ArrayList<RegistroEntradasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroEntradasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Nombre")+" "+resultados.getString("Gafete"));
			objeto.setNombre(resultados.getString("Nombre"));
			objeto.setGafete(resultados.getString("Gafete"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	} */
	else if(request.getParameter("Accion").equals("getRegistroEntradasAlmacenesInactivos")) {
		String recibe = (request.getParameter("filter[value]"));
		String[] valores = recibe.split(",");
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora, Estacion from RegistroEntradasAlmacenes where Nombre like '" + valores[0] + "%' and Estatus = 'INACTIVO' and Estacion ='"+valores[1]+"' group by Nombre");
		ArrayList<RegistroEntradasAlmacenes> info = new ArrayList<RegistroEntradasAlmacenes>();
		while(resultados.next()) {
			objeto = new RegistroEntradasAlmacenes();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Nombre"));
			objeto.setGafete(resultados.getString("Gafete"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new RegistroEntradasAlmacenes();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new RegistroEntradasAlmacenes();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* RegistroEntradasAlmacenesServlet.jsp */
%>



