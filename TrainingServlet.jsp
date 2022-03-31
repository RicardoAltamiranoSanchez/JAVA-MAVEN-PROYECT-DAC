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
<%@ page import="Objetos.Training"%>
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
private void imprimeJson(HttpServletResponse response, Training objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<Training> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(Training objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("TrainingServlet.jsp");
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
Training objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and TC.Id = A.IdTrainingCursos and TP.Id = A.IdTrainingPersonal order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Training();
		//objeto.setIdTrainingCursos(request.getParameter("Campo"));
		objeto.setTrainingCursos(request.getParameter("Campo"));
		//objeto.setIdTrainingPersonal(request.getParameter("Campo"));
		objeto.setTrainingPersonal(request.getParameter("Campo"));
		//objeto.setTipo(request.getParameter("Campo"));
		//objeto.setDiasNotificacion(request.getParameter("Campo"));
		//objeto.setDiasVigencia(request.getParameter("Campo"));
		//objeto.setNumeroCurso(request.getParameter("Campo"));
		//objeto.setFecha(request.getParameter("Campo"));
		//objeto.setFechaVencimiento(request.getParameter("Campo"));
		//objeto.setEstatus(request.getParameter("Campo"));
		//objeto.setEstacion(request.getParameter("Campo"));
		//objeto.setComprobante(request.getParameter("Campo"));
		//objeto.setIngreso(request.getParameter("Campo"));

		if(!objeto.getIdTrainingCursos().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdTrainingCursos like '" + objeto.getIdTrainingCursos() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getTrainingCursos().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" TC.Nombre like '" + objeto.getTrainingCursos() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getIdTrainingPersonal().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.IdTrainingPersonal like '" + objeto.getIdTrainingPersonal() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getTrainingPersonal().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" TP.Nombre like '" + objeto.getTrainingCursos() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getTipo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Tipo like '" + objeto.getTipo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getDiasNotificacion().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.DiasNotificacion like '" + objeto.getDiasNotificacion() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getDiasVigencia().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.DiasVigencia like '" + objeto.getDiasVigencia() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNumeroCurso().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.NumeroCurso like '" + objeto.getNumeroCurso() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFechaVencimiento().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.FechaVencimiento like '" + objeto.getFechaVencimiento() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEstatus().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Estatus like '" + objeto.getEstatus() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEstacion().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Estacion like '" + objeto.getEstacion() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getComprobante().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Comprobante like '" + objeto.getComprobante() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getIngreso().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Ingreso like '" + objeto.getIngreso() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and TC.Id = A.IdTrainingCursos and TP.Id = A.IdTrainingPersonal and TP.Ocultar='NO' and ("; where.append(")");} //se agrega and TP.Ocultar='NO' para que no muestre los alumnos con Ocultar activo

		resultados = sentencia.executeQuery("select A.*, TC.Nombre as NombreRegistro, concat(TP.Nombre,' ',TP.Empresa) as EmpleadoEmpresa from Training as A, TrainingCursos as TC, TrainingPersonal as TP " + whereInicio + where.toString()); //Se modificó el Query para obtener el nombre del usuario de la sesión y cargarlo en el Value del objeto
		//resultados = sentencia.executeQuery("select * from (select A.* from Training as A" + whereInicio + where.toString()+")as TrainingResults,(select U.Nombre as value from Usuarios as U where U.Id ="+"'"+session.getAttribute("IdUsuario")+"'"+")as UsuarioResults"); //bloqueado por que no fue necesario, ya que se obtiene el dato de session en el training.jsp
		ArrayList<Training> info = new ArrayList<Training>();
		while(resultados.next()) {
			objeto = new Training();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setIdTrainingCursos(resultados.getString("IdTrainingCursos"));
		objeto.setTrainingCursos(resultados.getString("NombreRegistro"));
		objeto.setIdTrainingPersonal(resultados.getString("IdTrainingPersonal"));
		objeto.setTrainingPersonal(resultados.getString("EmpleadoEmpresa"));
		objeto.setTipo(resultados.getString("Tipo"));
		objeto.setDiasNotificacion(resultados.getString("DiasNotificacion"));
		objeto.setDiasVigencia(resultados.getString("DiasVigencia"));
		objeto.setNumeroCurso(resultados.getString("NumeroCurso"));
		objeto.setFecha(resultados.getString("Fecha"));
		objeto.setFechaVencimiento(resultados.getString("FechaVencimiento"));
		objeto.setEstatus(resultados.getString("Estatus"));
		objeto.setEstacion(resultados.getString("Estacion"));
		objeto.setComprobante(resultados.getString("Comprobante"));
		objeto.setIngreso(resultados.getString("Ingreso"));
		//objeto.setValue(resultados.getString("value"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into Training (U,G,E,Bloquear,IdTrainingCursos,IdTrainingPersonal,Tipo,DiasNotificacion,DiasVigencia,NumeroCurso,Fecha,FechaVencimiento,Estatus,Estacion,Comprobante,Ingreso) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getEntero(request.getParameter("IdTrainingCursos")) + "','" + valoresDefault.getEntero(request.getParameter("IdTrainingPersonal")) + "','" + request.getParameter("Tipo") + "','" + valoresDefault.getEntero(request.getParameter("DiasNotificacion")) + "','" + valoresDefault.getEntero(request.getParameter("DiasVigencia")) + "','" + request.getParameter("NumeroCurso") + "','" + valoresDefault.getFecha(request.getParameter("Fecha")) + "','" + valoresDefault.getFecha(request.getParameter("FechaVencimiento")) + "','" + request.getParameter("Estatus") + "','" + request.getParameter("Estacion") + "','" + request.getParameter("Comprobante") + "','" + request.getParameter("Ingreso") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into TrainingApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdTrainingCursos,IdTrainingPersonal,Tipo,DiasNotificacion,DiasVigencia,NumeroCurso,Fecha,FechaVencimiento,Estatus,Estacion,Comprobante,Ingreso) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdTrainingCursos,IdTrainingPersonal,Tipo,DiasNotificacion,DiasVigencia,NumeroCurso,Fecha,FechaVencimiento,Estatus,Estacion,Comprobante,Ingreso from Training where Id = '" + ultimoId + "'");
		objeto = new Training();
		objeto.setId("" + ultimoId);
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			Training[] ids = gson.fromJson(request.getParameter("Ids"), Training[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into TrainingApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdTrainingCursos,IdTrainingPersonal,Tipo,DiasNotificacion,DiasVigencia,NumeroCurso,Fecha,FechaVencimiento,Estatus,Estacion,Comprobante,Ingreso) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdTrainingCursos,IdTrainingPersonal,Tipo,DiasNotificacion,DiasVigencia,NumeroCurso,Fecha,FechaVencimiento,Estatus,Estacion,Comprobante,Ingreso from Training where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from Training where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			Training ids = gson.fromJson(request.getParameter("Ids"), Training.class);
			sentencia.executeUpdate("insert into TrainingApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,IdTrainingCursos,IdTrainingPersonal,Tipo,DiasNotificacion,DiasVigencia,NumeroCurso,Fecha,FechaVencimiento,Estatus,Estacion,Comprobante,Ingreso) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,IdTrainingCursos,IdTrainingPersonal,Tipo,DiasNotificacion,DiasVigencia,NumeroCurso,Fecha,FechaVencimiento,Estatus,Estacion,Comprobante,Ingreso from Training where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from Training where Id = '" + ids.getId() + "'");
		}
		objeto = new Training();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update Training set IdTrainingCursos='" + valoresDefault.getEntero(request.getParameter("IdTrainingCursos")) + "',IdTrainingPersonal='" + valoresDefault.getEntero(request.getParameter("IdTrainingPersonal")) + "',Tipo='" + request.getParameter("Tipo") + "',DiasNotificacion='" + valoresDefault.getEntero(request.getParameter("DiasNotificacion")) + "',DiasVigencia='" + valoresDefault.getEntero(request.getParameter("DiasVigencia")) + "',NumeroCurso='" + request.getParameter("NumeroCurso") + "',Fecha='" + valoresDefault.getFecha(request.getParameter("Fecha")) + "',FechaVencimiento='" + valoresDefault.getFecha(request.getParameter("FechaVencimiento")) + "',Estatus='" + request.getParameter("Estatus") + "',Estacion='" + request.getParameter("Estacion") + "',Comprobante='" + request.getParameter("Comprobante") + "',Ingreso='" + request.getParameter("Ingreso") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into TrainingApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,IdTrainingCursos,IdTrainingPersonal,Tipo,DiasNotificacion,DiasVigencia,NumeroCurso,Fecha,FechaVencimiento,Estatus,Estacion,Comprobante,Ingreso) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,IdTrainingCursos,IdTrainingPersonal,Tipo,DiasNotificacion,DiasVigencia,NumeroCurso,Fecha,FechaVencimiento,Estatus,Estacion,Comprobante,Ingreso from Training where Id = '" + request.getParameter("id") + "'");
		objeto = new Training();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getTraining")) {
		resultados = sentencia.executeQuery("select Id, <columna> from Training where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<Training> info = new ArrayList<Training>();
		while(resultados.next()) {
			objeto = new Training();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new Training();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new Training();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* TrainingServlet.jsp */
%>



