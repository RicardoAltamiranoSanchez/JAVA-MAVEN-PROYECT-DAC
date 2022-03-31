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
<%@ page import="Objetos.TrainingPersonal"%>
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
private void imprimeJson(HttpServletResponse response, TrainingPersonal objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<TrainingPersonal> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(TrainingPersonal objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("TrainingPersonalServlet.jsp");
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
TrainingPersonal objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new TrainingPersonal();
		objeto.setNombre(request.getParameter("Campo"));
		//objeto.setEmpresa(request.getParameter("Campo"));

		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEmpresa().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Empresa like '" + objeto.getEmpresa() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getOcultar().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Ocultar like '" + objeto.getOcultar() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from TrainingPersonal as A" + whereInicio + where.toString());
		ArrayList<TrainingPersonal> info = new ArrayList<TrainingPersonal>();
		while(resultados.next()) {
			objeto = new TrainingPersonal();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setNombre(resultados.getString("Nombre"));
		objeto.setEmpresa(resultados.getString("Empresa"));
		objeto.setOcultar(resultados.getString("Ocultar"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into TrainingPersonal (U,G,E,Bloquear,Nombre,Empresa,Ocultar) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + request.getParameter("Nombre") + "','" + request.getParameter("Empresa") + "','" + request.getParameter("Ocultar") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into TrainingPersonalApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Nombre,Empresa,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Nombre,Empresa,Ocultar from TrainingPersonal where Id = '" + ultimoId + "'");
		objeto = new TrainingPersonal();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			TrainingPersonal[] ids = gson.fromJson(request.getParameter("Ids"), TrainingPersonal[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into TrainingPersonalApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Nombre,Empresa,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Nombre,Empresa,Ocultar from TrainingPersonal where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from TrainingPersonal where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			TrainingPersonal ids = gson.fromJson(request.getParameter("Ids"), TrainingPersonal.class);
			sentencia.executeUpdate("insert into TrainingPersonalApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Nombre,Empresa,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Nombre,Empresa,Ocultar from TrainingPersonal where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from TrainingPersonal where Id = '" + ids.getId() + "'");
		}
		objeto = new TrainingPersonal();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update TrainingPersonal set Nombre='" + request.getParameter("Nombre") + "',Empresa='" + request.getParameter("Empresa") + "',Ocultar='" + request.getParameter("Ocultar") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into TrainingPersonalApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Nombre,Empresa,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Nombre,Empresa,Ocultar from TrainingPersonal where Id = '" + request.getParameter("id") + "'");
		objeto = new TrainingPersonal();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getTrainingPersonal")) {
		resultados = sentencia.executeQuery("select Id, Nombre, Empresa from TrainingPersonal where Nombre like '" + request.getParameter("filter[value]") + "%' order by Nombre");
		ArrayList<TrainingPersonal> info = new ArrayList<TrainingPersonal>();
		while(resultados.next()) {
			objeto = new TrainingPersonal();
			objeto.setId(resultados.getString("Id"));
			String[] Empresa = (resultados.getString("Empresa")).split(" ");
			//System.out.println("Tengo 2 "+Empresa[0]+" "+Empresa[1]);
			String SiglasEmpresa = "";
			int Palabras = Empresa.length;
			//System.out.println("Son "+Palabras+" siglas");
			int i=0;
			while (i!=Palabras){
				//System.out.println("Estoy por agregar Siglas "+SiglasEmpresa);
				SiglasEmpresa = (SiglasEmpresa+Empresa[i].substring(0,1)+" ");
				//System.out.println("He almacenado las siglas "+SiglasEmpresa);
				i++;
			}
			//System.out.println("Salí del while");
			objeto.setValue(resultados.getString("Nombre")+" "+SiglasEmpresa);
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new TrainingPersonal();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new TrainingPersonal();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* TrainingPersonalServlet.jsp */
%>



