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
<%@ page import="Configuraciones.Generales"%>
<%@ page import="Configuraciones.Seguridad"%>
<%@ page import="Utilerias.Fechas"%>
<%@ page import="Utilerias.ValoresDefault"%>
<%@ page import="Objetos.InventarioSistemas"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.JsonSyntaxException"%>
<%!
HttpSession session;
DataSource datasource;
BaseDeDatos dbConf;
Generales generales;
Seguridad seguridad;
Gson gson;
Fechas fechas;
ValoresDefault valoresDefault;

public void jspInit() {
	try {
		BaseDeDatos dbConf = new BaseDeDatos();
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
private void imprimeJson(HttpServletResponse response, InventarioSistemas objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<InventarioSistemas> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(InventarioSistemas objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("InventarioSistemasServlet.jsp");
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
InventarioSistemas objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new InventarioSistemas();
		objeto.setSerie(request.getParameter("Campo"));
		//objeto.setFolio(request.getParameter("Campo"));
		//objeto.setMarca(request.getParameter("Campo"));
		//objeto.setNumeroSerie(request.getParameter("Campo"));
		//objeto.setSistemaOperativo(request.getParameter("Campo"));
		//objeto.setLicenciaSO(request.getParameter("Campo"));
		//objeto.setOffice(request.getParameter("Campo"));
		//objeto.setProcesador(request.getParameter("Campo"));
		//objeto.setRam(request.getParameter("Campo"));
		//objeto.setDiscoDuro(request.getParameter("Campo"));
		//objeto.setLcd(request.getParameter("Campo"));
		//objeto.setFechaCompra(request.getParameter("Campo"));
		//objeto.setFactura(request.getParameter("Campo"));
		//objeto.setProveedor(request.getParameter("Campo"));
		//objeto.setMacAdressLan(request.getParameter("Campo"));
		//objeto.setMacAdressWifi(request.getParameter("Campo"));
		//objeto.setNombreEquipo(request.getParameter("Campo"));
		//objeto.setEstatus(request.getParameter("Campo"));
		//objeto.setMotivoBaja(request.getParameter("Campo"));

		if(!objeto.getSerie().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Serie like '" + objeto.getSerie() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFolio().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Folio like '" + objeto.getFolio() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getMarca().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Marca like '" + objeto.getMarca() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNumeroSerie().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.NumeroSerie like '" + objeto.getNumeroSerie() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getSistemaOperativo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.SistemaOperativo like '" + objeto.getSistemaOperativo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getLicenciaSO().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.LicenciaSO like '" + objeto.getLicenciaSO() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getOffice().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Office like '" + objeto.getOffice() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getProcesador().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Procesador like '" + objeto.getProcesador() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getRam().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Ram like '" + objeto.getRam() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getDiscoDuro().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.DiscoDuro like '" + objeto.getDiscoDuro() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getLcd().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Lcd like '" + objeto.getLcd() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFechaCompra().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.FechaCompra like '" + objeto.getFechaCompra() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFactura().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Factura like '" + objeto.getFactura() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getProveedor().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Proveedor like '" + objeto.getProveedor() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getMacAdressLan().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.MacAdressLan like '" + objeto.getMacAdressLan() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getMacAdressWifi().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.MacAdressWifi like '" + objeto.getMacAdressWifi() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNombreEquipo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.NombreEquipo like '" + objeto.getNombreEquipo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getEstatus().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Estatus like '" + objeto.getEstatus() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getMotivoBaja().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.MotivoBaja like '" + objeto.getMotivoBaja() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.*, if(A.FechaCompra = '0000-00-00','',A.FechaCompra) FechaCompra1, " + 
			"(select E.NombreCompleto from InventarioSistemasEmp IE left join DivisionesAsignacion DA on (DA.IdEmpleados = IE.IdEmpleado) left join DivisionesEmpleados DE on (DE.Id = DA.IdDivisionesEmpleados), Empleados E where IE.IdInventarioSistemas = A.Id and E.Id = IE.IdEmpleado order by IE.Fecha desc limit 1) Empleado, " +
			"(select E.Estatus from InventarioSistemasEmp IE left join DivisionesAsignacion DA on (DA.IdEmpleados = IE.IdEmpleado) left join DivisionesEmpleados DE on (DE.Id = DA.IdDivisionesEmpleados), Empleados E where IE.IdInventarioSistemas = A.Id and E.Id = IE.IdEmpleado order by IE.Fecha desc limit 1) EstatusEmpleado, " +
			"(select IE.Fecha from InventarioSistemasEmp IE where IE.IdInventarioSistemas = A.Id order by IE.Fecha desc limit 1) FechaAsignacion, " +
			"(select IE.Localizacion from InventarioSistemasEmp IE where IE.IdInventarioSistemas = A.Id order by IE.Fecha desc limit 1) Localizacion, " +
			"(select E.NombreCompleto from InventarioSistemasEmp IE left join DivisionesAsignacion DA on (DA.IdEmpleados = IE.IdResponsable) left join DivisionesEmpleados DE on (DE.Id = DA.IdDivisionesEmpleados), Empleados E where IE.IdInventarioSistemas = A.Id and E.Id = IE.IdResponsable order by IE.Fecha desc limit 1) Responsable, " +
			"(select DE.Nombre NombreDivision from InventarioSistemasEmp IE left join DivisionesAsignacion DA on (DA.IdEmpleados = IE.IdEmpleado) left join DivisionesEmpleados DE on (DE.Id = DA.IdDivisionesEmpleados), Empleados E where IE.IdInventarioSistemas = A.Id and E.Id = IE.IdEmpleado order by IE.Fecha desc limit 1) Division, " +
			"(select group_concat(Fecha,': ',Reparacion) from InventarioSistemasRep where IdInventarioSistemas = A.Id) Reparaciones " + 
			"from InventarioSistemas as A " + whereInicio + where.toString());
		ArrayList<InventarioSistemas> info = new ArrayList<InventarioSistemas>();
		while(resultados.next()) {
			
			objeto = new InventarioSistemas();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setSerie(resultados.getString("Serie"));
			objeto.setFolio(resultados.getString("Folio"));
			objeto.setEmpleado(resultados.getString("Empleado"));
			objeto.setEstatusEmpleado(resultados.getString("EstatusEmpleado"));
			objeto.setFechaAsignacion(resultados.getString("FechaAsignacion"));
			objeto.setResponsable(resultados.getString("Responsable"));
			objeto.setLocalizacion(resultados.getString("Localizacion"));
			objeto.setDivision(resultados.getString("Division"));
			objeto.setMarca(resultados.getString("Marca"));
			objeto.setNumeroSerie(resultados.getString("NumeroSerie"));
			objeto.setSistemaOperativo(resultados.getString("SistemaOperativo"));
			objeto.setLicenciaSO(resultados.getString("LicenciaSO"));
			objeto.setOffice(resultados.getString("Office"));
			objeto.setProcesador(resultados.getString("Procesador"));
			objeto.setRam(resultados.getString("Ram"));
			objeto.setDiscoDuro(resultados.getString("DiscoDuro"));
			objeto.setLcd(resultados.getString("Lcd"));
			objeto.setFechaCompra(resultados.getString("FechaCompra1"));
			objeto.setFactura(resultados.getString("Factura"));
			objeto.setProveedor(resultados.getString("Proveedor"));
			objeto.setMacAdressLan(resultados.getString("MacAdressLan"));
			objeto.setMacAdressWifi(resultados.getString("MacAdressWifi"));
			objeto.setNombreEquipo(resultados.getString("NombreEquipo"));
			objeto.setEstatus(resultados.getString("Estatus"));
			objeto.setReparaciones(resultados.getString("Reparaciones"));
			objeto.setMotivoBaja(resultados.getString("MotivoBaja"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		sentencia.executeUpdate("insert into InventarioSistemas (U,G,E,Bloquear,Serie,Folio,Marca,NumeroSerie,SistemaOperativo,LicenciaSO,Office,Procesador,Ram,DiscoDuro,Lcd,FechaCompra,Factura,Proveedor,MacAdressLan,MacAdressWifi,NombreEquipo,Estatus,MotivoBaja) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + request.getParameter("Serie") + "','" + valoresDefault.getEntero(request.getParameter("Folio")) + "','" + request.getParameter("Marca") + "','" + request.getParameter("NumeroSerie") + "','" + request.getParameter("SistemaOperativo") + "','" + request.getParameter("LicenciaSO") + "','" + request.getParameter("Office") + "','" + request.getParameter("Procesador") + "','" + request.getParameter("Ram") + "','" + request.getParameter("DiscoDuro") + "','" + request.getParameter("Lcd") + "','" + valoresDefault.getFecha(request.getParameter("FechaCompra")) + "','" + request.getParameter("Factura") + "','" + request.getParameter("Proveedor") + "','" + request.getParameter("MacAdressLan") + "','" + request.getParameter("MacAdressWifi") + "','" + request.getParameter("NombreEquipo") + "','" + request.getParameter("Estatus") + "','" + request.getParameter("MotivoBaja") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into InventarioSistemasApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Serie,Folio,Marca,NumeroSerie,SistemaOperativo,LicenciaSO,Office,Procesador,Ram,DiscoDuro,Lcd,FechaCompra,Factura,Proveedor,MacAdressLan,MacAdressWifi,NombreEquipo,Estatus,MotivoBaja) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Serie,Folio,Marca,NumeroSerie,SistemaOperativo,LicenciaSO,Office,Procesador,Ram,DiscoDuro,Lcd,FechaCompra,Factura,Proveedor,MacAdressLan,MacAdressWifi,NombreEquipo,Estatus,MotivoBaja from InventarioSistemas where Id = '" + ultimoId + "'");
		objeto = new InventarioSistemas();
		objeto.setId("" + ultimoId);
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			InventarioSistemas[] ids = gson.fromJson(request.getParameter("Ids"), InventarioSistemas[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into InventarioSistemasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Serie,Folio,Marca,NumeroSerie,SistemaOperativo,LicenciaSO,Office,Procesador,Ram,DiscoDuro,Lcd,FechaCompra,Factura,Proveedor,MacAdressLan,MacAdressWifi,NombreEquipo,Estatus,MotivoBaja) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Serie,Folio,Marca,NumeroSerie,SistemaOperativo,LicenciaSO,Office,Procesador,Ram,DiscoDuro,Lcd,FechaCompra,Factura,Proveedor,MacAdressLan,MacAdressWifi,NombreEquipo,Estatus,MotivoBaja from InventarioSistemas where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from InventarioSistemas where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			InventarioSistemas ids = gson.fromJson(request.getParameter("Ids"), InventarioSistemas.class);
			sentencia.executeUpdate("insert into InventarioSistemasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Serie,Folio,Marca,NumeroSerie,SistemaOperativo,LicenciaSO,Office,Procesador,Ram,DiscoDuro,Lcd,FechaCompra,Factura,Proveedor,MacAdressLan,MacAdressWifi,NombreEquipo,Estatus,MotivoBaja) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Serie,Folio,Marca,NumeroSerie,SistemaOperativo,LicenciaSO,Office,Procesador,Ram,DiscoDuro,Lcd,FechaCompra,Factura,Proveedor,MacAdressLan,MacAdressWifi,NombreEquipo,Estatus,MotivoBaja from InventarioSistemas where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from InventarioSistemas where Id = '" + ids.getId() + "'");
		}
		objeto = new InventarioSistemas();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update InventarioSistemas set Serie='" + request.getParameter("Serie") + "',Folio='" + valoresDefault.getEntero(request.getParameter("Folio")) + "',Marca='" + request.getParameter("Marca") + "',NumeroSerie='" + request.getParameter("NumeroSerie") + "',SistemaOperativo='" + request.getParameter("SistemaOperativo") + "',LicenciaSO='" + request.getParameter("LicenciaSO") + "',Office='" + request.getParameter("Office") + "',Procesador='" + request.getParameter("Procesador") + "',Ram='" + request.getParameter("Ram") + "',DiscoDuro='" + request.getParameter("DiscoDuro") + "',Lcd='" + request.getParameter("Lcd") + "',FechaCompra='" + valoresDefault.getFecha(request.getParameter("FechaCompra")) + "',Factura='" + request.getParameter("Factura") + "',Proveedor='" + request.getParameter("Proveedor") + "',MacAdressLan='" + request.getParameter("MacAdressLan") + "',MacAdressWifi='" + request.getParameter("MacAdressWifi") + "',NombreEquipo='" + request.getParameter("NombreEquipo") + "',Estatus='" + request.getParameter("Estatus") + "',MotivoBaja='" + request.getParameter("MotivoBaja") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into InventarioSistemasApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Serie,Folio,Marca,NumeroSerie,SistemaOperativo,LicenciaSO,Office,Procesador,Ram,DiscoDuro,Lcd,FechaCompra,Factura,Proveedor,MacAdressLan,MacAdressWifi,NombreEquipo,Estatus,MotivoBaja) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Serie,Folio,Marca,NumeroSerie,SistemaOperativo,LicenciaSO,Office,Procesador,Ram,DiscoDuro,Lcd,FechaCompra,Factura,Proveedor,MacAdressLan,MacAdressWifi,NombreEquipo,Estatus,MotivoBaja from InventarioSistemas where Id = '" + request.getParameter("id") + "'");
		objeto = new InventarioSistemas();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getInventarioSistemas")) {
		resultados = sentencia.executeQuery("select Id, <columna> from InventarioSistemas where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<InventarioSistemas> info = new ArrayList<InventarioSistemas>();
		while(resultados.next()) {
			objeto = new InventarioSistemas();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new InventarioSistemas();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new InventarioSistemas();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* InventarioSistemasServlet.jsp */
%>



