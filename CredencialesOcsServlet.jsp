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
<%@ page import="Objetos.CredencialesOcs"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.JsonSyntaxException"%>
<%@ page import="Utilerias.TraduccionesSQL"%>
<%@ page import="Libreria.MysqlPool"%>
<%!
HttpSession session;
DataSource datasource;
BaseDeDatosPool dbConf;
Generales generales;
Seguridad seguridad;
Gson gson;
Fechas fechas;
ValoresDefault valoresDefault;
TraduccionesSQL SQL;
MysqlPool eDB;

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
private void imprimeJson(HttpServletResponse response, CredencialesOcs objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<CredencialesOcs> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(CredencialesOcs objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("CredencialesOcsServlet.jsp");
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
CredencialesOcs objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	eDB = new MysqlPool();
	
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where C.Id > 0";
		boolean entro = false;
		SQL = new TraduccionesSQL();
		
		eDB.setConexion();
		objeto = new CredencialesOcs();
		objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
		objeto.setPuesto(request.getParameter("Puesto"));
		objeto.setIMSS(request.getParameter("IMSS"));
		objeto.setCURP(request.getParameter("CURP"));
		objeto.setAntiguedad(request.getParameter("Antiguedad"));
		objeto.setFechaEmision(request.getParameter("FechaEmision"));
		objeto.setFechaVigencia(request.getParameter("FechaVigencia"));
		objeto.setImagen(request.getParameter("Archivo"));
		objeto.setIdImagenAdelante(request.getParameter("IdImagenAdelante"));
		objeto.setIdImagenAtras(request.getParameter("IdImagenAtras"));

		if(!objeto.getNombreCompleto().equals("")) { where.append(" and C.NombreCompleto like '" + objeto.getNombreCompleto() + "%'"); entro = true;}
		if(!objeto.getPuesto().equals("")) { where.append(" and C.Puesto like '" + objeto.getPuesto() + "%'"); entro = true;}
		if(!objeto.getIMSS().equals("")) { where.append(" and C.IMSS like '" + objeto.getIMSS() + "%'"); entro = true;}
		if(!objeto.getCURP().equals("")) { where.append(" and C.CURP like '" + objeto.getCURP() + "%'"); entro = true;}
		if(!objeto.getAntiguedad().equals("")) { where.append(" and C.Antiguedad like '" + objeto.getAntiguedad() + "%'"); entro = true;}
		if(!objeto.getFechaEmision().equals("")) { where.append(" and C.FechaEmision like '" + objeto.getFechaEmision() + "%'"); entro = true;}
		if(!objeto.getFechaVigencia().equals("")) { where.append(" and C.FechaVigencia like '" + objeto.getFechaVigencia() + "%'"); entro = true;}
		if(!objeto.getImagen().equals("")) { where.append(" and C.Imagen like '" + objeto.getImagen() + "%'"); entro = true;}
		if(!objeto.getIdImagenAdelante().equals("")) { where.append(" and C.IdImagenAdelante like '" + objeto.getIdImagenAdelante() + "%'"); entro = true;}
		if(!objeto.getIdImagenAtras().equals("")) { where.append(" and C.IdImagenAtras like '" + objeto.getIdImagenAtras() + "%'"); entro = true;}
		if(entro) { whereInicio = " where C.Id > 0"; }
		
		resultados = eDB.getQuery("select C.*,IF(C.FechaEmision = '0000-00-00','',C.FechaEmision) as FechaE, IF(C.FechaVigencia = '0000-00-00','',C.FechaVigencia) as FechaV  from CredencialesOcs as C" + whereInicio + where.toString());
		ArrayList<CredencialesOcs> info = new ArrayList<CredencialesOcs>();
		while(resultados.next()) {
			objeto = new CredencialesOcs();
			objeto.setId(resultados.getInt("Id"));
			objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
			objeto.setPuesto(resultados.getString("Puesto"));
			objeto.setIMSS(resultados.getString("IMSS"));
			objeto.setCURP(resultados.getString("CURP"));
			objeto.setAntiguedad(resultados.getString("Antiguedad"));
			objeto.setFechaEmision(resultados.getString("FechaE"));
			objeto.setFechaVigencia(resultados.getString("FechaV"));
			objeto.setImagen(resultados.getString("Imagen"));
			objeto.setIdImagenAdelante(resultados.getString("IdImagenAdelante"));
			objeto.setIdImagenAtras(resultados.getString("IdImagenAtras"));
			info.add(objeto);
		}
		eDB.setCerrar(resultados);
		eDB.setCerrar();
		eDB.setCerrarConexion();
		
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		String Imagen = request.getParameter("Archivo");
		Imagen = Imagen.replace(" ", "_");
		SQL = new TraduccionesSQL();
		eDB.setConexion();
		eDB.setQuery("insert into CredencialesOcs (U,G,E,NombreCompleto,Puesto,IMSS,CURP,Antiguedad,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) values ('" + 
			session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + 
			request.getParameter("NombreCompleto") + "','" + request.getParameter("Puesto") + "','" + request.getParameter("IMSS") + "','" + request.getParameter("CURP") + "','" + 
			request.getParameter("Antiguedad") + "','" + request.getParameter("FechaEmision") + "','" + request.getParameter("FechaVigencia") + "','" + Imagen + "','" + 
			SQL.getEntero(request.getParameter("IdImagenAdelante")) + "','" + SQL.getEntero(request.getParameter("IdImagenAtras")) + "')");
		ultimoId = eDB.getUltimoId();
		eDB.setQuery("insert into CredencialesOcsApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreCompleto,Puesto,IMSS,CURP,Antiguedad,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreCompleto,Puesto,IMSS,CURP,Antiguedad,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras from CredencialesOcs where Id = '" + ultimoId + "'");
		eDB.setCerrar();
		eDB.setCerrarConexion();
		//guardamos los datos en el objeto
		objeto = new CredencialesOcs();
		objeto.setId(ultimoId);
		objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
		objeto.setPuesto(request.getParameter("Puesto"));
		objeto.setIMSS(request.getParameter("IMSS"));
		objeto.setCURP(request.getParameter("CURP"));
		objeto.setAntiguedad(request.getParameter("Antiguedad"));
		objeto.setFechaEmision(request.getParameter("FechaEmision"));
		objeto.setFechaVigencia(request.getParameter("FechaVigencia"));
		objeto.setImagen(request.getParameter("Archivo"));
		objeto.setIdImagenAdelante(request.getParameter("IdImagenAdelante"));
		objeto.setIdImagenAtras(request.getParameter("IdImagenAtras"));
		
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		eDB.setConexion();
		String ids = request.getParameter("Ids");
		String[] id = ids.split(",");
		for(int i = 0; i < id.length; i++) {
			if(!id[i].equals("")) {
				eDB.setQuery("insert into CredencialesOcsApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,NombreCompleto,Puesto,IMSS,CURP,Antiguedad,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,NombreCompleto,Puesto,IMSS,CURP,Antiguedad,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras from CredencialesOcs where Id = '" + id[i] + "'");
				eDB.setQuery("delete from CredencialesOcs where Id = '" + id[i] + "'");
			}
		}
		eDB.setCerrar();
		eDB.setCerrarConexion();
		
		objeto = new CredencialesOcs();
		imprimeJson(response,objeto);
	}else if(request.getParameter("Accion").equals("Consultar")) {
		eDB.setConexion();
		resultados = eDB.getQuery("select C.*,IF(C.FechaEmision = '0000-00-00','',C.FechaEmision) as FechaE, IF(C.FechaVigencia = '0000-00-00','',C.FechaVigencia) as FechaV from CredencialesOcs as C where C.Id = '" + request.getParameter("id") + "'");
		objeto = new CredencialesOcs();
		while(resultados.next()) {
			objeto.setId(resultados.getInt("Id"));
			objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
			objeto.setPuesto(resultados.getString("Puesto"));
			objeto.setIMSS(resultados.getString("IMSS"));
			objeto.setCURP(resultados.getString("CURP"));
			objeto.setAntiguedad(resultados.getString("Antiguedad"));
			objeto.setFechaEmision(resultados.getString("FechaE"));
			objeto.setFechaVigencia(resultados.getString("FechaV"));
			objeto.setImagen(resultados.getString("Imagen"));
			objeto.setIdImagenAdelante(resultados.getString("IdImagenAdelante"));
			objeto.setIdImagenAtras(resultados.getString("IdImagenAtras"));
		}
		eDB.setCerrar(resultados);
		eDB.setCerrar();
		eDB.setCerrarConexion();
		
		imprimeJson(response,objeto);
	}else if(request.getParameter("Accion").equals("Modificar")) {
		String Imagen = request.getParameter("Archivo");
		Imagen = Imagen.replace(" ", "_");
		SQL = new TraduccionesSQL();
		eDB.setConexion();
		String ImagenUpdate = "";
		if(Imagen != ""){
			ImagenUpdate = "Imagen='" + Imagen + "',";
		}
		eDB.setQuery("update CredencialesOcs set NombreCompleto='" + request.getParameter("NombreCompleto") + "',Puesto='" + request.getParameter("Puesto") + "',IMSS='" + request.getParameter("IMSS") + "',CURP='" + request.getParameter("CURP") + "',Antiguedad='" + request.getParameter("Antiguedad") + "',FechaEmision='" + request.getParameter("FechaEmision") + "',FechaVigencia='" + request.getParameter("FechaVigencia") + "'," + ImagenUpdate + "IdImagenAdelante='" + SQL.getEntero(request.getParameter("IdImagenAdelante")) + "',IdImagenAtras='" + SQL.getEntero(request.getParameter("IdImagenAtras")) + "' where Id = '" + request.getParameter("id") + "'");
		eDB.setQuery("insert into CredencialesOcsApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreCompleto,Puesto,IMSS,CURP,Antiguedad,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreCompleto,Puesto,IMSS,CURP,Antiguedad,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras from CredencialesOcs where Id = '" + request.getParameter("id") + "'");
		eDB.setCerrar();
		eDB.setCerrarConexion();
		
		objeto = new CredencialesOcs();
		objeto.setId(Integer.parseInt(request.getParameter("id")));
		objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
		objeto.setPuesto(request.getParameter("Puesto"));
		objeto.setIMSS(request.getParameter("IMSS"));
		objeto.setCURP(request.getParameter("CURP"));
		objeto.setAntiguedad(request.getParameter("Antiguedad"));
		objeto.setFechaEmision(request.getParameter("FechaEmision"));
		objeto.setFechaVigencia(request.getParameter("FechaVigencia"));
		objeto.setImagen(request.getParameter("Archivo"));
		objeto.setIdImagenAdelante(request.getParameter("IdImagenAdelante"));
		objeto.setIdImagenAtras(request.getParameter("IdImagenAtras"));
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getCredencialesOcs")) {
		eDB.setConexion();
		resultados = eDB.getQuery("select Id, NombreCompleto from CredencialesOcs where NombreCompleto like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<CredencialesOcs> info = new ArrayList<CredencialesOcs>();
		while(resultados.next()) {
			objeto = new CredencialesOcs();
			objeto.setId(resultados.getInt("Id"));
			objeto.setValue(resultados.getString("NombreCompleto"));
			info.add(objeto);
		}
		eDB.setCerrar(resultados);
		eDB.setCerrar();
		eDB.setCerrarConexion();
		
		imprimeJson(response,info);
	}else if(request.getParameter("Accion").equals("ConsultarCredencialesOcs")) {
		eDB.setConexion();
		resultados = eDB.getQuery("select * from CredencialesOcs");
		ArrayList<CredencialesOcs> info = new ArrayList<CredencialesOcs>();
		while(resultados.next()) {
			objeto = new CredencialesOcs();
			objeto.setId(resultados.getInt("Id"));
			objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
			objeto.setPuesto(resultados.getString("Puesto"));
			objeto.setIMSS(resultados.getString("IMSS"));
			objeto.setCURP(resultados.getString("CURP"));
			objeto.setAntiguedad(resultados.getString("Antiguedad"));
			objeto.setFechaEmision(resultados.getString("FechaEmision"));
			objeto.setFechaVigencia(resultados.getString("FechaVigencia"));
			objeto.setImagen(resultados.getString("Imagen"));
			info.add(objeto);
		}
		eDB.setCerrar(resultados);
		eDB.setCerrar();
		eDB.setCerrarConexion();
		
		imprimeJson(response,info);
	}else if(request.getParameter("Accion").equals("Actualizar")){
		eDB.setConexion();
		resultados = eDB.getQuery("select C.* from CredencialesOcs as C where C.IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
		objeto = new CredencialesOcs();
		while(resultados.next()) {
			objeto.setId(resultados.getInt("Id"));
			objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
			objeto.setPuesto(resultados.getString("Puesto"));
			objeto.setIMSS(resultados.getString("IMSS"));
			objeto.setCURP(resultados.getString("CURP"));
			objeto.setAntiguedad(resultados.getString("Antiguedad"));
		}
		eDB.setCerrar(resultados);
		eDB.setCerrar();
		eDB.setCerrarConexion();
		
		imprimeJson(response,objeto);
	}else if(request.getParameter("Accion").equals("ModificarInfo")){
		eDB.setConexion();
		resultados = eDB.getQuery("select IdUsuario from CredencialesOcs where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
		if(resultados.next()){
			eDB.setQuery("update CredencialesOcs set NombreCompleto='" + request.getParameter("NombreCompleto") + "',Puesto='" + request.getParameter("Puesto") + "',IMSS='" + request.getParameter("IMSS") + "',CURP='" + request.getParameter("CURP") + "',Antiguedad='" + request.getParameter("Antiguedad") + "' where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
		}else{
			resultados = eDB.getQuery("select CURP from CredencialesOcs where CURP = '" + request.getParameter("CURP") + "'");
			if(resultados.next()){
				eDB.setQuery("update CredencialesOcs set NombreCompleto='" + request.getParameter("NombreCompleto") + "',Puesto='" + request.getParameter("Puesto") + "',IMSS='" + request.getParameter("IMSS") + "',CURP='" + request.getParameter("CURP") + "',Antiguedad='" + request.getParameter("Antiguedad") + "',IdUsuario='" + session.getAttribute("IdUsuario") + "' where CURP = '" + request.getParameter("CURP") + "'");
			}else{
				eDB.setQuery("insert into CredencialesOcs (U,G,E,NombreCompleto,Puesto,IMSS,CURP,Antiguedad,IdUsuario) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("NombreCompleto") + "','" + request.getParameter("Puesto") + "','" + "','" + request.getParameter("IMSS") + "','" + request.getParameter("CURP") + "','" + request.getParameter("Antiguedad") + "','" + session.getAttribute("IdUsuario") + "')");
			}
		}
		eDB.setQuery("insert into CredencialesOcsApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreCompleto,Puesto,IMSS,CURP,Antiguedad,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras,IdUsuario) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreCompleto,Puesto,IMSS,CURP,Antiguedad,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras,IdUsuario from CredencialesOcs where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
		eDB.setCerrar(resultados);
		eDB.setCerrar();
		eDB.setCerrarConexion();
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new CredencialesOcs();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new CredencialesOcs();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* CredencialesOcsServlet.jsp */
%>



