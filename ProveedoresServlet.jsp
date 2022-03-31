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
<%@ page import="Configuraciones.BaseDeDatosPool"%>
<%@ page import="Configuraciones.Generales"%>
<%@ page import="Configuraciones.Seguridad"%>
<%@ page import="Utilerias.Fechas"%>
<%@ page import="Utilerias.ValoresDefault"%>
<%@ page import="Objetos.Proveedores"%>
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
private void imprimeJson(HttpServletResponse response, Proveedores objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<Proveedores> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(Proveedores objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("ProveedoresServlet.jsp");
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
Proveedores objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Proveedores();
		objeto.setFecha(request.getParameter("Campo"));
		objeto.setAlias(request.getParameter("Campo"));
		objeto.setNombre(request.getParameter("Campo"));
		objeto.setRfc(request.getParameter("Campo"));
		//objeto.setDireccion(request.getParameter("Campo"));
		//objeto.setNumeroExterior(request.getParameter("Campo"));
		//objeto.setNumeroInterior(request.getParameter("Campo"));
		//objeto.setColonia(request.getParameter("Campo"));
		//objeto.setCodigoPostal(request.getParameter("Campo"));
		//objeto.setTelefono(request.getParameter("Campo"));
		//objeto.setCiudad(request.getParameter("Campo"));
		//objeto.setEstado(request.getParameter("Campo"));
		//objeto.setPais(request.getParameter("Campo"));
		//objeto.setGiroEmpresa(request.getParameter("Campo"));
		//objeto.setSitioInternet(request.getParameter("Campo"));
		//objeto.setContacto(request.getParameter("Campo"));
		//objeto.setExtension(request.getParameter("Campo"));
		//objeto.setCelular(request.getParameter("Campo"));
		//objeto.setEmail(request.getParameter("Campo"));
		//objeto.setDaCredito(request.getParameter("Campo"));
		//objeto.setDiasCredito(request.getParameter("Campo"));
		//objeto.setBanco1(request.getParameter("Campo"));
		//objeto.setCuentaBancaria1(request.getParameter("Campo"));
		//objeto.setClabe1(request.getParameter("Campo"));
		//objeto.setMoneda1(request.getParameter("Campo"));
		//objeto.setBanco2(request.getParameter("Campo"));
		//objeto.setCuentaBancaria2(request.getParameter("Campo"));
		//objeto.setClabe2(request.getParameter("Campo"));
		//objeto.setMoneda2(request.getParameter("Campo"));
		//objeto.setEstatus(request.getParameter("Campo"));
		//objeto.setComentarios(request.getParameter("Campo"));

		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getAlias().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Alias like '" + objeto.getAlias() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getRfc().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Rfc like '" + objeto.getRfc() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getDireccion().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Direccion like '" + objeto.getDireccion() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNumeroExterior().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.NumeroExterior like '" + objeto.getNumeroExterior() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNumeroInterior().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.NumeroInterior like '" + objeto.getNumeroInterior() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getColonia().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Colonia like '" + objeto.getColonia() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCodigoPostal().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.CodigoPostal like '" + objeto.getCodigoPostal() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getTelefono().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Telefono like '" + objeto.getTelefono() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCiudad().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Ciudad like '" + objeto.getCiudad() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEstado().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Estado like '" + objeto.getEstado() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getPais().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Pais like '" + objeto.getPais() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getGiroEmpresa().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.GiroEmpresa like '" + objeto.getGiroEmpresa() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getSitioInternet().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.SitioInternet like '" + objeto.getSitioInternet() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getContacto().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Contacto like '" + objeto.getContacto() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getExtension().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Extension like '" + objeto.getExtension() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCelular().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Celular like '" + objeto.getCelular() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEmail().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Email like '" + objeto.getEmail() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getDaCredito().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.DaCredito like '" + objeto.getDaCredito() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getDiasCredito().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.DiasCredito like '" + objeto.getDiasCredito() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getBanco1().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Banco1 like '" + objeto.getBanco1() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCuentaBancaria1().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.CuentaBancaria1 like '" + objeto.getCuentaBancaria1() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getClabe1().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Clabe1 like '" + objeto.getClabe1() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getMoneda1().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Moneda1 like '" + objeto.getMoneda1() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getBanco2().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Banco2 like '" + objeto.getBanco2() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCuentaBancaria2().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.CuentaBancaria2 like '" + objeto.getCuentaBancaria2() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getClabe2().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Clabe2 like '" + objeto.getClabe2() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getMoneda2().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Moneda2 like '" + objeto.getMoneda2() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEstatus().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Estatus like '" + objeto.getEstatus() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getComentarios().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Comentarios like '" + objeto.getComentarios() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from Proveedores as A" + whereInicio + where.toString());
		ArrayList<Proveedores> info = new ArrayList<Proveedores>();
		while(resultados.next()) {
			objeto = new Proveedores();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setAlias(resultados.getString("Alias"));
			objeto.setNombre(resultados.getString("Nombre"));
			objeto.setRfc(resultados.getString("Rfc"));
			objeto.setDireccion(resultados.getString("Direccion"));
			objeto.setNumeroExterior(resultados.getString("NumeroExterior"));
			objeto.setNumeroInterior(resultados.getString("NumeroInterior"));
			objeto.setColonia(resultados.getString("Colonia"));
			objeto.setCodigoPostal(resultados.getString("CodigoPostal"));
			objeto.setTelefono(resultados.getString("Telefono"));
			objeto.setCiudad(resultados.getString("Ciudad"));
			objeto.setEstado(resultados.getString("Estado"));
			objeto.setPais(resultados.getString("Pais"));
			objeto.setGiroEmpresa(resultados.getString("GiroEmpresa"));
			objeto.setSitioInternet(resultados.getString("SitioInternet"));
			objeto.setContacto(resultados.getString("Contacto"));
			objeto.setExtension(resultados.getString("Extension"));
			objeto.setCelular(resultados.getString("Celular"));
			objeto.setEmail(resultados.getString("Email"));
			objeto.setDaCredito(resultados.getString("DaCredito"));
			objeto.setDiasCredito(resultados.getString("DiasCredito"));
			objeto.setBanco1(resultados.getString("Banco1"));
			objeto.setCuentaBancaria1(resultados.getString("CuentaBancaria1"));
			objeto.setClabe1(resultados.getString("Clabe1"));
			objeto.setMoneda1(resultados.getString("Moneda1"));
			objeto.setBanco2(resultados.getString("Banco2"));
			objeto.setCuentaBancaria2(resultados.getString("CuentaBancaria2"));
			objeto.setClabe2(resultados.getString("Clabe2"));
			objeto.setMoneda2(resultados.getString("Moneda2"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setComentarios(resultados.getString("Comentarios"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into Proveedores (U,G,E,Bloquear,Fecha,Alias,Nombre,Rfc,Direccion,NumeroExterior,NumeroInterior,Colonia,CodigoPostal,Telefono,Ciudad,Estado,Pais,GiroEmpresa,SitioInternet,Contacto,Extension,Celular,Email,DaCredito,DiasCredito,Banco1,CuentaBancaria1,Clabe1,Moneda1,Banco2,CuentaBancaria2,Clabe2,Moneda2,Estatus,Comentarios) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getFecha(request.getParameter("Fecha")) + "','" + request.getParameter("Alias") + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Rfc") + "','" + request.getParameter("Direccion") + "','" + request.getParameter("NumeroExterior") + "','" + request.getParameter("NumeroInterior") + "','" + request.getParameter("Colonia") + "','" + request.getParameter("CodigoPostal") + "','" + request.getParameter("Telefono") + "','" + request.getParameter("Ciudad") + "','" + request.getParameter("Estado") + "','" + request.getParameter("Pais") + "','" + request.getParameter("GiroEmpresa") + "','" + request.getParameter("SitioInternet") + "','" + request.getParameter("Contacto") + "','" + request.getParameter("Extension") + "','" + request.getParameter("Celular") + "','" + request.getParameter("Email") + "','" + request.getParameter("DaCredito") + "','" + valoresDefault.getEntero(request.getParameter("DiasCredito")) + "','" + request.getParameter("Banco1") + "','" + request.getParameter("CuentaBancaria1") + "','" + request.getParameter("Clabe1") + "','" + request.getParameter("Moneda1") + "','" + request.getParameter("Banco2") + "','" + request.getParameter("CuentaBancaria2") + "','" + request.getParameter("Clabe2") + "','" + request.getParameter("Moneda2") + "','" + request.getParameter("Estatus") + "','" + request.getParameter("Comentarios") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into ProveedoresApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,Alias,Nombre,Rfc,Direccion,NumeroExterior,NumeroInterior,Colonia,CodigoPostal,Telefono,Ciudad,Estado,Pais,GiroEmpresa,SitioInternet,Contacto,Extension,Celular,Email,DaCredito,DiasCredito,Banco1,CuentaBancaria1,Clabe1,Moneda1,Banco2,CuentaBancaria2,Clabe2,Moneda2,Estatus,Comentarios) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,Alias,Nombre,Rfc,Direccion,NumeroExterior,NumeroInterior,Colonia,CodigoPostal,Telefono,Ciudad,Estado,Pais,GiroEmpresa,SitioInternet,Contacto,Extension,Celular,Email,DaCredito,DiasCredito,Banco1,CuentaBancaria1,Clabe1,Moneda1,Banco2,CuentaBancaria2,Clabe2,Moneda2,Estatus,Comentarios from Proveedores where Id = '" + ultimoId + "'");
		objeto = new Proveedores();
		objeto.setId("" + ultimoId);
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			Proveedores[] ids = gson.fromJson(request.getParameter("Ids"), Proveedores[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into ProveedoresApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,Alias,Nombre,Rfc,Direccion,NumeroExterior,NumeroInterior,Colonia,CodigoPostal,Telefono,Ciudad,Estado,Pais,GiroEmpresa,SitioInternet,Contacto,Extension,Celular,Email,DaCredito,DiasCredito,Banco1,CuentaBancaria1,Clabe1,Moneda1,Banco2,CuentaBancaria2,Clabe2,Moneda2,Estatus,Comentarios) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,Alias,Nombre,Rfc,Direccion,NumeroExterior,NumeroInterior,Colonia,CodigoPostal,Telefono,Ciudad,Estado,Pais,GiroEmpresa,SitioInternet,Contacto,Extension,Celular,Email,DaCredito,DiasCredito,Banco1,CuentaBancaria1,Clabe1,Moneda1,Banco2,CuentaBancaria2,Clabe2,Moneda2,Estatus,Comentarios from Proveedores where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from Proveedores where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			Proveedores ids = gson.fromJson(request.getParameter("Ids"), Proveedores.class);
			sentencia.executeUpdate("insert into ProveedoresApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,Alias,Nombre,Rfc,Direccion,NumeroExterior,NumeroInterior,Colonia,CodigoPostal,Telefono,Ciudad,Estado,Pais,GiroEmpresa,SitioInternet,Contacto,Extension,Celular,Email,DaCredito,DiasCredito,Banco1,CuentaBancaria1,Clabe1,Moneda1,Banco2,CuentaBancaria2,Clabe2,Moneda2,Estatus,Comentarios) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,Alias,Nombre,Rfc,Direccion,NumeroExterior,NumeroInterior,Colonia,CodigoPostal,Telefono,Ciudad,Estado,Pais,GiroEmpresa,SitioInternet,Contacto,Extension,Celular,Email,DaCredito,DiasCredito,Banco1,CuentaBancaria1,Clabe1,Moneda1,Banco2,CuentaBancaria2,Clabe2,Moneda2,Estatus,Comentarios from Proveedores where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from Proveedores where Id = '" + ids.getId() + "'");
		}
		objeto = new Proveedores();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update Proveedores set Fecha='" + valoresDefault.getFecha(request.getParameter("Fecha")) + "',Alias='" + request.getParameter("Alias") + "',Nombre='" + request.getParameter("Nombre") + "',Rfc='" + request.getParameter("Rfc") + "',Direccion='" + request.getParameter("Direccion") + "',NumeroExterior='" + request.getParameter("NumeroExterior") + "',NumeroInterior='" + request.getParameter("NumeroInterior") + "',Colonia='" + request.getParameter("Colonia") + "',CodigoPostal='" + request.getParameter("CodigoPostal") + "',Telefono='" + request.getParameter("Telefono") + "',Ciudad='" + request.getParameter("Ciudad") + "',Estado='" + request.getParameter("Estado") + "',Pais='" + request.getParameter("Pais") + "',GiroEmpresa='" + request.getParameter("GiroEmpresa") + "',SitioInternet='" + request.getParameter("SitioInternet") + "',Contacto='" + request.getParameter("Contacto") + "',Extension='" + request.getParameter("Extension") + "',Celular='" + request.getParameter("Celular") + "',Email='" + request.getParameter("Email") + "',DaCredito='" + request.getParameter("DaCredito") + "',DiasCredito='" + valoresDefault.getEntero(request.getParameter("DiasCredito")) + "',Banco1='" + request.getParameter("Banco1") + "',CuentaBancaria1='" + request.getParameter("CuentaBancaria1") + "',Clabe1='" + request.getParameter("Clabe1") + "',Moneda1='" + request.getParameter("Moneda1") + "',Banco2='" + request.getParameter("Banco2") + "',CuentaBancaria2='" + request.getParameter("CuentaBancaria2") + "',Clabe2='" + request.getParameter("Clabe2") + "',Moneda2='" + request.getParameter("Moneda2") + "',Estatus='" + request.getParameter("Estatus") + "',Comentarios='" + request.getParameter("Comentarios") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into ProveedoresApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,Alias,Nombre,Rfc,Direccion,NumeroExterior,NumeroInterior,Colonia,CodigoPostal,Telefono,Ciudad,Estado,Pais,GiroEmpresa,SitioInternet,Contacto,Extension,Celular,Email,DaCredito,DiasCredito,Banco1,CuentaBancaria1,Clabe1,Moneda1,Banco2,CuentaBancaria2,Clabe2,Moneda2,Estatus,Comentarios) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,Alias,Nombre,Rfc,Direccion,NumeroExterior,NumeroInterior,Colonia,CodigoPostal,Telefono,Ciudad,Estado,Pais,GiroEmpresa,SitioInternet,Contacto,Extension,Celular,Email,DaCredito,DiasCredito,Banco1,CuentaBancaria1,Clabe1,Moneda1,Banco2,CuentaBancaria2,Clabe2,Moneda2,Estatus,Comentarios from Proveedores where Id = '" + request.getParameter("id") + "'");
		objeto = new Proveedores();
		objeto.setId(request.getParameter("id"));
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getProveedores")) {
		resultados = sentencia.executeQuery("select Id, concat(alias,' ',Nombre) as Proveedor from Proveedores where alias like '" + request.getParameter("filter[value]") + "%' order by Alias and Estatus = 'Activo'");
		ArrayList<Proveedores> info = new ArrayList<Proveedores>();
		while(resultados.next()) {
			objeto = new Proveedores();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("Proveedor"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new Proveedores();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new Proveedores();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* ProveedoresServlet.jsp */
%>