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
<%@ page import="Objetos.RegistroChecadorEmpleados"%>
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
private void imprimeJson(HttpServletResponse response, RegistroChecadorEmpleados objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<RegistroChecadorEmpleados> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(RegistroChecadorEmpleados objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("RegistroChecadorEmpleadosServlet.jsp");
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
RegistroChecadorEmpleados objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new RegistroChecadorEmpleados();
		objeto.setNumEmpleado(request.getParameter("Campo"));
		objeto.setTipoRegistro(request.getParameter("Campo"));
		objeto.setEstacion(request.getParameter("Campo"));
		//objeto.setFechaHora(request.getParameter("Campo"));

		if(!objeto.getNumEmpleado().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.NumEmpleado like '" + objeto.getNumEmpleado() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getTipoRegistro().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.TipoRegistro like '" + objeto.getTipoRegistro() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEstacion().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Estacion like '" + objeto.getEstacion() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from RegistroChecadorEmpleados as A" + whereInicio + where.toString());
		ArrayList<RegistroChecadorEmpleados> info = new ArrayList<RegistroChecadorEmpleados>();
		while(resultados.next()) {
			objeto = new RegistroChecadorEmpleados();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setNumEmpleado(resultados.getString("NumEmpleado"));
		objeto.setTipoRegistro(resultados.getString("TipoRegistro"));
		objeto.setFechaHora(resultados.getString("FechaHora"));
		objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	//NO SE USA EL MÉTODO GUARDAR
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into RegistroChecadorEmpleados (U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora) values ('1','2','3','false','" + request.getParameter("Nombre") + "','" + request.getParameter("Gafete") + "','ACTIVO',now())",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into RegistroChecadorEmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora) select '1',now(),Id,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora from RegistroChecadorEmpleados where Id = '" + ultimoId + "'");
		objeto = new RegistroChecadorEmpleados();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("GuardarEntrada")) {
		objeto = new RegistroChecadorEmpleados();
		
		sentencia.executeUpdate("truncate PassConvert");
		sentencia.executeUpdate("insert into PassConvert (Password) values (md5('"+request.getParameter("PasswordIntranet")+"'))");
		
		resultados = sentencia.executeQuery("select A.NombreCompleto from Empleados as A, Usuarios as B where B.Usuario = '"+request.getParameter("UsuarioIntranet")+"' and A.IdUsuario = B.Id and B.Password = (select Password from PassConvert)");
		ArrayList<RegistroChecadorEmpleados> info = new ArrayList<RegistroChecadorEmpleados>();
		int valida = 0;
		while(resultados.next()) {
			objeto = new RegistroChecadorEmpleados();
		    objeto.setValue(resultados.getString("NombreCompleto"));
		    objeto.setLog("entrada");
		    valida++;
		}
		sentencia.executeUpdate("truncate PassConvert");
		//DEBUG System.out.println(valida);
		if (valida==1)
		{
			sentencia.executeUpdate("insert into RegistroChecadorEmpleados (U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion) values ('1','2','3','false',(select Id from Usuarios where Usuario ='"+ request.getParameter("UsuarioIntranet")+"'),'" + request.getParameter("UsuarioIntranet") + "','ENTRADA',now(),'" + request.getParameter("Estacion") + "')",Statement.RETURN_GENERATED_KEYS);
			ResultSet indice = sentencia.getGeneratedKeys();		
			while(indice.next()) {
				ultimoId = indice.getInt(1);
			}
			try { if(null!=indice)indice.close();} catch (SQLException e) {;}
			sentencia.executeUpdate("insert into RegistroChecadorEmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion) select '1',now(),Id,U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion from RegistroChecadorEmpleados where Id = '" + ultimoId + "'");
		}
		valida=0;
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("GuardarSalida")) {
		objeto = new RegistroChecadorEmpleados();
		
		sentencia.executeUpdate("truncate PassConvert");
		sentencia.executeUpdate("insert into PassConvert (Password) values (md5('"+request.getParameter("PasswordIntranet")+"'))");
		
		resultados = sentencia.executeQuery("select A.NombreCompleto from Empleados as A, Usuarios as B where B.Usuario = '"+request.getParameter("UsuarioIntranet")+"' and A.IdUsuario = B.Id and B.Password = (select Password from PassConvert)");
		ArrayList<RegistroChecadorEmpleados> info = new ArrayList<RegistroChecadorEmpleados>();
		int valida = 0;
		while(resultados.next()) {
			objeto = new RegistroChecadorEmpleados();
		    objeto.setValue(resultados.getString("NombreCompleto"));
		    objeto.setLog("salida");
		    valida++;
		}
		sentencia.executeUpdate("truncate PassConvert");
		//DEBUG System.out.println(valida);
		if (valida==1)
		{
			sentencia.executeUpdate("insert into RegistroChecadorEmpleados (U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion) values ('1','2','3','false',(select Id from Usuarios where Usuario ='"+ request.getParameter("UsuarioIntranet")+"'),'" + request.getParameter("UsuarioIntranet") + "','SALIDA',now(),'" + request.getParameter("Estacion") + "')",Statement.RETURN_GENERATED_KEYS);
			ResultSet indice = sentencia.getGeneratedKeys();		
			while(indice.next()) {
				ultimoId = indice.getInt(1);
			}
			try { if(null!=indice)indice.close();} catch (SQLException e) {;}
			sentencia.executeUpdate("insert into RegistroChecadorEmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion) select '1',now(),Id,U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion from RegistroChecadorEmpleados where Id = '" + ultimoId + "'");
		}
		valida=0;
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("GuardarEntradaComida")) {
		objeto = new RegistroChecadorEmpleados();
		
		sentencia.executeUpdate("truncate PassConvert");
		sentencia.executeUpdate("insert into PassConvert (Password) values (md5('"+request.getParameter("PasswordIntranet")+"'))");
		
		resultados = sentencia.executeQuery("select A.NombreCompleto from Empleados as A, Usuarios as B where B.Usuario = '"+request.getParameter("UsuarioIntranet")+"' and A.IdUsuario = B.Id and B.Password = (select Password from PassConvert)");
		ArrayList<RegistroChecadorEmpleados> info = new ArrayList<RegistroChecadorEmpleados>();
		int valida = 0;
		while(resultados.next()) {
			objeto = new RegistroChecadorEmpleados();
		    objeto.setValue(resultados.getString("NombreCompleto"));
		    objeto.setLog("entrada");
		    valida++;
		}
		sentencia.executeUpdate("truncate PassConvert");
		//DEBUG System.out.println(valida);
		if (valida==1)
		{
			sentencia.executeUpdate("insert into RegistroChecadorEmpleados (U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion) values ('1','2','3','false',(select Id from Usuarios where Usuario ='"+ request.getParameter("UsuarioIntranet")+"'),'" + request.getParameter("UsuarioIntranet") + "','ENTRADA COMIDA',now(),'" + request.getParameter("Estacion") + "')",Statement.RETURN_GENERATED_KEYS);
			ResultSet indice = sentencia.getGeneratedKeys();		
			while(indice.next()) {
				ultimoId = indice.getInt(1);
			}
			try { if(null!=indice)indice.close();} catch (SQLException e) {;}
			sentencia.executeUpdate("insert into RegistroChecadorEmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion) select '1',now(),Id,U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion from RegistroChecadorEmpleados where Id = '" + ultimoId + "'");
		}
		valida=0;
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("GuardarSalidaComida")) {
		objeto = new RegistroChecadorEmpleados();
		
		sentencia.executeUpdate("truncate PassConvert");
		sentencia.executeUpdate("insert into PassConvert (Password) values (md5('"+request.getParameter("PasswordIntranet")+"'))");
		
		resultados = sentencia.executeQuery("select A.NombreCompleto from Empleados as A, Usuarios as B where B.Usuario = '"+request.getParameter("UsuarioIntranet")+"' and A.IdUsuario = B.Id and B.Password = (select Password from PassConvert)");
		ArrayList<RegistroChecadorEmpleados> info = new ArrayList<RegistroChecadorEmpleados>();
		int valida = 0;
		while(resultados.next()) {
			objeto = new RegistroChecadorEmpleados();
		    objeto.setValue(resultados.getString("NombreCompleto"));
		    objeto.setLog("salida");
		    valida++;
		}
		sentencia.executeUpdate("truncate PassConvert");
		//DEBUG System.out.println(valida);
		if (valida==1)
		{
			sentencia.executeUpdate("insert into RegistroChecadorEmpleados (U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion) values ('1','2','3','false',(select Id from Usuarios where Usuario ='"+ request.getParameter("UsuarioIntranet")+"'),'" + request.getParameter("UsuarioIntranet") + "','SALIDA COMIDA',now(),'" + request.getParameter("Estacion") + "')",Statement.RETURN_GENERATED_KEYS);
			ResultSet indice = sentencia.getGeneratedKeys();		
			while(indice.next()) {
				ultimoId = indice.getInt(1);
			}
			try { if(null!=indice)indice.close();} catch (SQLException e) {;}
			sentencia.executeUpdate("insert into RegistroChecadorEmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion) select '1',now(),Id,U,G,E,Bloquear,NumEmpleado,UsuarioIntranet,TipoRegistro,FechaHora,Estacion from RegistroChecadorEmpleados where Id = '" + ultimoId + "'");
		}
		valida=0;
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			RegistroChecadorEmpleados[] ids = gson.fromJson(request.getParameter("Ids"), RegistroChecadorEmpleados[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into RegistroChecadorEmpleadosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora) select '1',now(),'Si',Id,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora from RegistroChecadorEmpleados where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from RegistroChecadorEmpleados where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			RegistroChecadorEmpleados ids = gson.fromJson(request.getParameter("Ids"), RegistroChecadorEmpleados.class);
			sentencia.executeUpdate("insert into RegistroChecadorEmpleadosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora) select '1',now(),'Si',Id,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora from RegistroChecadorEmpleados where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from RegistroChecadorEmpleados where Id = '" + ids.getId() + "'");
		}
		objeto = new RegistroChecadorEmpleados();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update RegistroChecadorEmpleados set Nombre='" + request.getParameter("Nombre") + "',Gafete='" + request.getParameter("Gafete") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into RegistroChecadorEmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora) select '1',now(),Id,U,G,E,Bloquear,Nombre,Gafete,Estatus,FechaHora from RegistroChecadorEmpleados where Id = '" + request.getParameter("id") + "'");
		objeto = new RegistroChecadorEmpleados();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getRegistroChecadorEmpleados")) {
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora from RegistroChecadorEmpleados where Nombre like '" + request.getParameter("filter[value]") + "%' group by Nombre");
		ArrayList<RegistroChecadorEmpleados> info = new ArrayList<RegistroChecadorEmpleados>();
		while(resultados.next()) {
			objeto = new RegistroChecadorEmpleados();
			objeto.setId(resultados.getString("Id"));
			//objeto.setValue(resultados.getString("Nombre"));
			objeto.setNumEmpleado(resultados.getString("NumEmpleado"));
			objeto.setTipoRegistro(resultados.getString("TipoRegistro"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getIdRegistroChecadorEmpleadosActivos")) {
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora from RegistroChecadorEmpleados where Nombre like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO'");
		ArrayList<RegistroChecadorEmpleados> info = new ArrayList<RegistroChecadorEmpleados>();
		while(resultados.next()) {
			objeto = new RegistroChecadorEmpleados();
			objeto.setId(resultados.getString("Id"));
			//objeto.setValue(resultados.getString("Nombre")+" "+resultados.getString("Gafete"));
			objeto.setNumEmpleado(resultados.getString("NumEmpleado"));
			objeto.setTipoRegistro(resultados.getString("TipoRegistro"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getRegistroChecadorEmpleadosInactivos")) {
		resultados = sentencia.executeQuery("select Id, Nombre, Gafete, Estatus, FechaHora from RegistroChecadorEmpleados where Nombre like '" + request.getParameter("filter[value]") + "%' and Estatus = 'INACTIVO' group by Nombre");
		ArrayList<RegistroChecadorEmpleados> info = new ArrayList<RegistroChecadorEmpleados>();
		while(resultados.next()) {
			objeto = new RegistroChecadorEmpleados();
			objeto.setId(resultados.getString("Id"));
			objeto.setNumEmpleado(resultados.getString("NumEmpleado"));
			objeto.setTipoRegistro(resultados.getString("TipoRegistro"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getRegistroChecadoresNumEmpleados")) {
		resultados = sentencia.executeQuery("select Id, NumEmpleado, TipoRegistro, FechaHora, Estacion from RegistroChecadorEmpleados where NumEmpleado like '" + request.getParameter("filter[value]") + "%' group by  NumEmpleado");
		ArrayList<RegistroChecadorEmpleados> info = new ArrayList<RegistroChecadorEmpleados>();
		while(resultados.next()) {
			objeto = new RegistroChecadorEmpleados();
			objeto.setValue(resultados.getString("NumEmpleado"));
			objeto.setId(resultados.getString("Id"));
			objeto.setNumEmpleado(resultados.getString("NumEmpleado"));
			objeto.setTipoRegistro(resultados.getString("TipoRegistro"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("getRegistroChecadoresEstaciones")) { //OJO YA NO ES INACTIVO
		resultados = sentencia.executeQuery("select Id, NumEmpleado, TipoRegistro, FechaHora, Estacion from RegistroChecadorEmpleados where NumEmpleado like '" + request.getParameter("filter[value]") + "%' group by  Estacion");
		ArrayList<RegistroChecadorEmpleados> info = new ArrayList<RegistroChecadorEmpleados>();
		while(resultados.next()) {
			objeto = new RegistroChecadorEmpleados();
			objeto.setValue(resultados.getString("Estacion"));
			objeto.setId(resultados.getString("Id"));
			objeto.setNumEmpleado(resultados.getString("NumEmpleado"));
			objeto.setTipoRegistro(resultados.getString("TipoRegistro"));
			objeto.setFechaHora(resultados.getString("FechaHora"));
			objeto.setEstacion(resultados.getString("Estacion"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new RegistroChecadorEmpleados();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new RegistroChecadorEmpleados();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* RegistroChecadorEmpleadosServlet.jsp */
%>



