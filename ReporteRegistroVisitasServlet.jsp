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
<%@ page import="Objetos.RegistroEntradasAlmacenGdl"%>
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
private void imprimeJson(HttpServletResponse response, RegistroEntradasAlmacenGdl objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<RegistroEntradasAlmacenGdl> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(RegistroEntradasAlmacenGdl objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("RegistroEntradasAlmacenGdlServlet.jsp");
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
RegistroEntradasAlmacenGdl objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new RegistroEntradasAlmacenGdl();
		//objeto.setNombre(request.getParameter("Campo"));
		//objeto.setGafete(request.getParameter("Campo"));
		//objeto.setEstatus(request.getParameter("Campo"));
		//objeto.setFechaHora(request.getParameter("Campo"));

		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getGafete().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Gafete like '" + objeto.getGafete() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEstatus().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Estatus like '" + objeto.getEstatus() + "%'"); entro = true;}
		if(!objeto.getFechaHora().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.FechaHora like '" + objeto.getFechaHora() + "%'"); entro = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery(""+
				"select A.Id, A.Nombre, A.Gafete, A.FechaHora as FechaHoraEntrada, B.Prefijo, B.Awb, B.Observaciones, B.FechaHora as FechaHoraSalida, CONCAT(Timediff(B.FechaHora,A.FechaHora),'') as TiempoAlmacen"+ 
				" from RegistroEntradasAlmacenGdl as A, RegistroSalidasAlmacenGdl as B" + /* whereInicio + where.toString() */"" + 
				" where B.IdRegistroEntradasAlmacenGdl = A.Id "+
				" and A.Nombre like if(@1:=(select Nombre from RegistroEntradasAlmacenGdl where Id='"+request.getParameter("IdRegistroEntradasAlmacenGdl")+"') is null,('%%'),(select Nombre from RegistroEntradasAlmacenGdl where Id='"+request.getParameter("IdRegistroEntradasAlmacenGdl")+"'))"+
				" and A.FechaHora >= if(@1:=('"+request.getParameter("Fecha")+"') is null,('0000-00-00 00:00:00'),('"+request.getParameter("Fecha")+" 00:00:00'))" +
				" and A.FechaHora <= if(@1:=('"+request.getParameter("FechaA")+"') = '',('9999-12-31 00:00:00'),('"+request.getParameter("FechaA")+" 00:00:00'))");
		ArrayList<RegistroEntradasAlmacenGdl> info = new ArrayList<RegistroEntradasAlmacenGdl>();
		while(resultados.next()) {
			objeto = new RegistroEntradasAlmacenGdl();
			objeto.setId(resultados.getString("Id"));
			//objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setNombre(resultados.getString("Nombre"));
		objeto.setGafete(resultados.getString("Gafete"));
		objeto.setFechaHoraEntrada(resultados.getString("FechaHoraEntrada"));
		objeto.setPrefijo(resultados.getString("Prefijo"));
		objeto.setAwb(resultados.getString("Awb"));
		objeto.setObservaciones(resultados.getString("Observaciones"));
		objeto.setFechaHoraSalida(resultados.getString("FechaHoraSalida"));
		objeto.setTiempoAlmacen(resultados.getString("TiempoAlmacen"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new RegistroEntradasAlmacenGdl();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new RegistroEntradasAlmacenGdl();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* RegistroEntradasAlmacenGdlServlet.jsp */
%>



