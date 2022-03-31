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
<%@ page import="Objetos.Requisiciones"%>
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
private void imprimeJson(HttpServletResponse response, Requisiciones objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<Requisiciones> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(Requisiciones objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("RequisicionesServlet.jsp");
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
Requisiciones objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(3,session,new String[]{""}) + " and P.Id = A.IdProveedores and U.Id = A.IdPara and U1.Id = A.U and A.Estatus = '' order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Requisiciones();
		objeto.setFecha(request.getParameter("Campo"));
		
		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(3,session,new String[]{""}) + " and P.Id = A.IdProveedores and U.Id = A.IdPara and U1.Id = A.U and A.Estatus = '' and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para, U1.Nombre De from Requisiciones as A, Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();
		while(resultados.next()) {
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setDe(resultados.getString("De"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdProveedores(resultados.getString("IdProveedores"));
			objeto.setProveedores(resultados.getString("Provee"));
			objeto.setIdEmpresas(resultados.getString("IdEmpresas"));
			objeto.setIdPara(resultados.getString("IdPara"));
			objeto.setPara(resultados.getString("Para"));
			objeto.setFormaPago(resultados.getString("FormaPago"));
			objeto.setInstruccionesPago(resultados.getString("InstruccionesPago"));
			objeto.setDescripcion(resultados.getString("Descripcion"));
			objeto.setImporte(resultados.getString("Importe"));
			objeto.setIva(resultados.getString("Iva"));
			objeto.setTotal(resultados.getString("Total"));
			objeto.setEstatus(resultados.getString("Estatus").toUpperCase());
			objeto.setMoneda(resultados.getString("Moneda"));
			objeto.setMotivoRechazo(resultados.getString("MotivoRechazo"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("BuscarEstatus")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(11,session,new String[]{""}) + " and P.Id = A.IdProveedores and U.Id = A.IdPara and U1.Id = A.U order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Requisiciones();
		objeto.setFecha(request.getParameter("Fecha"));
		objeto.setEstatus(request.getParameter("Estatus"));
		
		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(11,session,new String[]{""}) + " and P.Id = A.IdProveedores and U.Id = A.IdPara and U1.Id = A.U and ("; where.append(")");}

		//resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para, U1.Nombre De from Requisiciones as A, Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para, U1.Nombre De, RAP.Pago TipoPago,RAP.Archivo ArchivoPagos,RAP.ValidarPago from Requisiciones as A left join RequisicionesArchivosPagos RAP on (RAP.IdRequisiciones = A.Id), Proveedores P, Usuarios U, Usuarios U1" + whereInicio + where.toString());
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();
		while(resultados.next()) {
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setDe(resultados.getString("De"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdProveedores(resultados.getString("IdProveedores"));
			objeto.setProveedores(resultados.getString("Provee"));
			objeto.setIdEmpresas(resultados.getString("IdEmpresas"));
			objeto.setIdPara(resultados.getString("IdPara"));
			objeto.setPara(resultados.getString("Para"));
			objeto.setFormaPago(resultados.getString("FormaPago"));
			objeto.setInstruccionesPago(resultados.getString("InstruccionesPago"));
			objeto.setDescripcion(resultados.getString("Descripcion"));
			objeto.setImporte(resultados.getString("Importe"));
			objeto.setIva(resultados.getString("Iva"));
			objeto.setTotal(resultados.getString("Total"));
			objeto.setEstatus(resultados.getString("Estatus").toUpperCase());
			objeto.setMoneda(resultados.getString("Moneda"));
			objeto.setMotivoRechazo(resultados.getString("MotivoRechazo"));
			//if (resultados.getString("ArchivoPagos") == null){//VALIDAR 1
			if (resultados.getString("ArchivoPagos") == null||resultados.getString("ValidarPago") == null||resultados.getString("ValidarPago").equals("Pendiente")||resultados.getString("ValidarPago").equals("Parcial")){
				objeto.setArchivoPagos("No hay pago");
			}else{
				objeto.setArchivoPagos(resultados.getString("ArchivoPagos"));
			}
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("BuscarEstatusTodos")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where  P.Id = A.IdProveedores and U.Id = A.IdPara and U1.Id = A.U order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Requisiciones();
		objeto.setFecha(request.getParameter("Fecha"));
		objeto.setEstatus(request.getParameter("Estatus"));
		
		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where  P.Id = A.IdProveedores and U.Id = A.IdPara and U1.Id = A.U and ("; where.append(")");}

		//resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para, U1.Nombre De from Requisiciones as A, Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para, U1.Nombre De, RAP.Pago TipoPago,RAP.Archivo ArchivoPagos,RAP.ValidarPago from Requisiciones as A left join RequisicionesArchivosPagos RAP on (RAP.IdRequisiciones = A.Id), Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();
		while(resultados.next()) {
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setDe(resultados.getString("De"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdProveedores(resultados.getString("IdProveedores"));
			objeto.setProveedores(resultados.getString("Provee"));
			objeto.setIdEmpresas(resultados.getString("IdEmpresas"));
			objeto.setIdPara(resultados.getString("IdPara"));
			objeto.setPara(resultados.getString("Para"));
			objeto.setFormaPago(resultados.getString("FormaPago"));
			objeto.setInstruccionesPago(resultados.getString("InstruccionesPago"));
			objeto.setDescripcion(resultados.getString("Descripcion"));
			objeto.setImporte(resultados.getString("Importe"));
			objeto.setIva(resultados.getString("Iva"));
			objeto.setTotal(resultados.getString("Total"));
			objeto.setEstatus(resultados.getString("Estatus").toUpperCase());
			objeto.setMoneda(resultados.getString("Moneda"));
			objeto.setMotivoRechazo(resultados.getString("MotivoRechazo"));
			//if (resultados.getString("ArchivoPagos") == null){ //Validar 2
			if (resultados.getString("ArchivoPagos") == null||resultados.getString("ValidarPago") == null||resultados.getString("ValidarPago").equals("Pendiente")||resultados.getString("ValidarPago").equals("Parcial")){
				objeto.setArchivoPagos("No hay pago");
			}else{
				objeto.setArchivoPagos(resultados.getString("ArchivoPagos"));
			}
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("BuscarEstatusTodosDatosFactura")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where  P.Id = A.IdProveedores and U.Id = A.IdPara and U1.Id = A.U order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Requisiciones();
		objeto.setFecha(request.getParameter("Fecha"));
		objeto.setEstatus(request.getParameter("Estatus"));
		
		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where  P.Id = A.IdProveedores and U.Id = A.IdPara and U1.Id = A.U and ("; where.append(")");}

		//resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para, U1.Nombre De from Requisiciones as A, Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, RE.Empresa Empresa, U.Nombre Para, U1.Nombre De, RAP.Pago TipoPago,RAP.Archivo ArchivoPagos,RAP.ValidarPago from Requisiciones as A left join RequisicionesArchivosPagos RAP on (RAP.IdRequisiciones = A.Id) left join RequisicionesEmpresas as RE on (RE.Id = A.IdEmpresas), Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();
		while(resultados.next()) {
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setDe(resultados.getString("De"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdProveedores(resultados.getString("IdProveedores"));
			objeto.setProveedores(resultados.getString("Provee"));
			objeto.setValue(resultados.getString("Empresa"));
			objeto.setIdPara(resultados.getString("IdPara"));
			objeto.setPara(resultados.getString("Para"));
			objeto.setFormaPago(resultados.getString("FormaPago"));
			objeto.setInstruccionesPago(resultados.getString("InstruccionesPago"));
			objeto.setDescripcion(resultados.getString("Descripcion"));
			objeto.setImporte(resultados.getString("Importe"));
			objeto.setIva(resultados.getString("Iva"));
			objeto.setTotal(resultados.getString("Total"));
			objeto.setEstatus(resultados.getString("Estatus").toUpperCase());
			objeto.setMoneda(resultados.getString("Moneda"));
			objeto.setMotivoRechazo(resultados.getString("MotivoRechazo"));
			objeto.setFacturaFolio(resultados.getString("FacturaFolio"));
			objeto.setFacturaMontoTotal(resultados.getString("FacturaMontoTotal"));
			objeto.setFacturaFechaIdealPago(resultados.getString("FacturaFechaIdealPago"));
			objeto.setFacturaObservaciones(resultados.getString("FacturaObservaciones"));
			//if (resultados.getString("ArchivoPagos") == null){//Validar 3
			if (resultados.getString("ArchivoPagos") == null||resultados.getString("ValidarPago") == null||resultados.getString("ValidarPago").equals("Pendiente")||resultados.getString("ValidarPago").equals("Parcial")){
				objeto.setArchivoPagos("No hay pago");
			}else{
				objeto.setArchivoPagos(resultados.getString("ArchivoPagos"));
			}
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("BuscarEstatusTodosDatosFacturaFiltros")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = "";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Requisiciones();
		//objeto.setFecha(request.getParameter("Fecha")); ANTES CON UNA SOLA FECHA
		String[] FechaDesde = request.getParameter("FechaDesde").split(" ");
		String[] FechaHasta = request.getParameter("FechaHasta").split(" ");
		
		String Proveedor = request.getParameter("IdProveedores");
		String Empresa = request.getParameter("IdRequisicionesEmpresas");
		
		String ComparaProveedor = "";
		String ComparaEmpresa = "";
		
		if (Proveedor.equals("")){
			ComparaProveedor = "like";
			Proveedor = "%%";
		}else{
			ComparaProveedor = "=";
		}
		
		if (Empresa.equals("")){
			ComparaEmpresa = "like";;
			Empresa = "%%";			
		}else{
			ComparaEmpresa = "=";
		}
		
		//objeto.setFecha(FechaDesde[0]);
		objeto.setEstatus(request.getParameter("Estatus"));
		
		//if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		whereInicio = " where  P.Id = A.IdProveedores"+ 
				" and U.Id = A.IdPara "+
				" and U1.Id = A.U "+
				" and A.Fecha >= '"+FechaDesde[0]+"'"+
				" and A.Fecha <= '"+FechaHasta[0]+"'"+
				" and A.IdProveedores "+ComparaProveedor+" '"+Proveedor+"'"+
				" and A.IdEmpresas "+ComparaEmpresa+" '"+Empresa+"'";

		//resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para, U1.Nombre De from Requisiciones as A, Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		//DEBUG System.out.println("select A.*, if((select @f1:=RA.Registro from RequisicionesApoyo as RA where A.Id = RA.IdOrigen and RA.Estatus = '' group by IdOrigen) is null,'',@f1) FechaSolicitud, if((select @f1:=RA.Registro from RequisicionesApoyo as RA where A.Id = RA.IdOrigen and RA.Estatus = 'Autorizado' group by IdOrigen) is null,'',@f1) FechaAutorizacion, concat('(',P.Alias,') ',P.Nombre) Provee, RE.Empresa Empresa, U.Nombre Para, U1.Nombre De,RAP.Pago TipoPago,(select SUM(MontoPago) from RequisicionesArchivosPagos where IdRequisiciones = A.Id) MontoTotalPago,RAP.Archivo ArchivoPagos,RAP.ValidarPago from Requisiciones as A left join RequisicionesArchivosPagos RAP on (RAP.IdRequisiciones = A.Id) left join RequisicionesEmpresas as RE on (RE.Id = A.IdEmpresas), Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		resultados = sentencia.executeQuery("select A.*, if((select @f1:=RA.Registro from RequisicionesApoyo as RA where A.Id = RA.IdOrigen and RA.Estatus = '' group by IdOrigen) is null,'',@f1) FechaSolicitud, if((select @f1:=RA.Registro from RequisicionesApoyo as RA where A.Id = RA.IdOrigen and RA.Estatus = 'Autorizado' group by IdOrigen) is null,'',@f1) FechaAutorizacion, concat('(',P.Alias,') ',P.Nombre) Provee, RE.Empresa Empresa, U.Nombre Para, U1.Nombre De,RAP.Pago TipoPago,(select SUM(MontoPago) from RequisicionesArchivosPagos where IdRequisiciones = A.Id) MontoTotalPago,RAP.Archivo ArchivoPagos,RAP.ValidarPago from Requisiciones as A left join RequisicionesArchivosPagos RAP on (RAP.IdRequisiciones = A.Id) left join RequisicionesEmpresas as RE on (RE.Id = A.IdEmpresas), Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();
		
		// ESTATUS PAGO
		// Monto Restante
		String estatusPago = "";
		float restantePago = 0;
		float montoPagado = 0;
		
		while(resultados.next()) {
			
			estatusPago = resultados.getString("ValidarPago");
			
			//DEBUGSystem.out.println("Estatus Pago "+estatusPago);
			
			if(estatusPago == null||estatusPago.equals("Pendiente")){
				estatusPago = "PENDIENTE";
			}else{
				estatusPago = resultados.getString("ValidarPago");
			}
			
			montoPagado = 0;
			
			
			if(resultados.getString("MontoTotalPago") != null){
				montoPagado = Float.valueOf(resultados.getString("MontoTotalPago"));
				
			}
			
			//DEBUGSystem.out.println("Monto Total "+resultados.getString("FacturaMontoTotal"));
			
			boolean numeric = true;
			
			try {
            	Double num = Double.parseDouble(resultados.getString("FacturaMontoTotal"));
	        } catch (NumberFormatException e) {
	            numeric = false;
	        }
			
			
			if(numeric){
				restantePago = Float.valueOf(resultados.getString("FacturaMontoTotal").replaceAll(",", ""))-montoPagado;
			}else{
				restantePago = Float.valueOf(resultados.getString("Total"))-montoPagado;
			}
			
			
		
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setDe(resultados.getString("De"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdProveedores(resultados.getString("IdProveedores"));
			objeto.setProveedores(resultados.getString("Provee"));
			objeto.setValue(resultados.getString("Empresa"));
			objeto.setIdPara(resultados.getString("IdPara"));
			objeto.setPara(resultados.getString("Para"));
			objeto.setFormaPago(resultados.getString("FormaPago"));
			objeto.setInstruccionesPago(resultados.getString("InstruccionesPago"));
			objeto.setDescripcion(resultados.getString("Descripcion"));
			objeto.setImporte(resultados.getString("Importe"));
			objeto.setIva(resultados.getString("Iva"));
			objeto.setTotal(resultados.getString("Total"));
			objeto.setEstatus(resultados.getString("Estatus").toUpperCase());
			objeto.setMoneda(resultados.getString("Moneda"));
			objeto.setMotivoRechazo(resultados.getString("MotivoRechazo"));
			objeto.setFacturaFolio(resultados.getString("FacturaFolio"));
			objeto.setFacturaMontoTotal(resultados.getString("FacturaMontoTotal"));
			objeto.setFacturaFechaIdealPago(resultados.getString("FacturaFechaIdealPago"));
			objeto.setFacturaObservaciones(resultados.getString("FacturaObservaciones"));
			objeto.setEstatusPago(estatusPago);
			objeto.setRestantePago(String.valueOf(restantePago));
			objeto.setFechaSolicitud(resultados.getString("FechaSolicitud"));
			objeto.setFechaAutorizacion(resultados.getString("FechaAutorizacion"));
			if (resultados.getString("ArchivoPagos") == null||resultados.getString("ValidarPago") == null||resultados.getString("ValidarPago").equals("Pendiente")||resultados.getString("ValidarPago").equals("Parcial")){
				objeto.setArchivoPagos("No hay pago");
			}else{
				objeto.setArchivoPagos(resultados.getString("ArchivoPagos"));
			}
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("BuscarEstatusTodosDatosNoFacturaFiltros")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = "";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Requisiciones();
		//objeto.setFecha(request.getParameter("Fecha")); ANTES CON UNA SOLA FECHA
		String[] FechaDesde = request.getParameter("FechaDesde").split(" ");
		String[] FechaHasta = request.getParameter("FechaHasta").split(" ");
		
		String Proveedor = request.getParameter("IdProveedores");
		String Empresa = request.getParameter("IdRequisicionesEmpresas");
		
		String ComparaProveedor = "";
		String ComparaEmpresa = "";
		
		if (Proveedor.equals("")){
			ComparaProveedor = "like";
			Proveedor = "%%";
		}else{
			ComparaProveedor = "=";
		}
		
		if (Empresa.equals("")){
			ComparaEmpresa = "like";;
			Empresa = "%%";			
		}else{
			ComparaEmpresa = "=";
		}
		
		//objeto.setFecha(FechaDesde[0]);
		objeto.setEstatus(request.getParameter("Estatus"));
		
		//if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;}
		whereInicio = " where  P.Id = A.IdProveedores"+ 
				" and U.Id = A.IdPara "+
				" and U1.Id = A.U "+
				" and A.Fecha >= '"+FechaDesde[0]+"'"+
				" and A.Fecha <= '"+FechaHasta[0]+"'"+
				" and A.IdProveedores "+ComparaProveedor+" '"+Proveedor+"'"+
				" and A.IdEmpresas "+ComparaEmpresa+" '"+Empresa+"'";

		//resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para, U1.Nombre De from Requisiciones as A, Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		//DEBUGSystem.out.println("select A.*, if((select @f1:=RA.Registro from RequisicionesApoyo as RA where A.Id = RA.IdOrigen and RA.Estatus = '' group by IdOrigen) is null,'',@f1) FechaSolicitud, if((select @f1:=RA.Registro from RequisicionesApoyo as RA where A.Id = RA.IdOrigen and RA.Estatus = 'Autorizado' group by IdOrigen) is null,'',@f1) FechaAutorizacion, concat('(',P.Alias,') ',P.Nombre) Provee, RE.Empresa Empresa, U.Nombre Para, U1.Nombre De, RAP.Pago TipoPago,(select SUM(MontoPago) from RequisicionesArchivosPagos where IdRequisiciones = A.Id) MontoTotalPago,RAP.Archivo ArchivoPagos,RAP.ValidarPago from Requisiciones as A left join RequisicionesArchivosPagos RAP on (RAP.IdRequisiciones = A.Id) left join RequisicionesEmpresas as RE on (RE.Id = A.IdEmpresas), Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		resultados = sentencia.executeQuery("select A.*, if((select @f1:=RA.Registro from RequisicionesApoyo as RA where A.Id = RA.IdOrigen and RA.Estatus = '' group by IdOrigen) is null,'',@f1) FechaSolicitud, if((select @f1:=RA.Registro from RequisicionesApoyo as RA where A.Id = RA.IdOrigen and RA.Estatus = 'Autorizado' group by IdOrigen) is null,'',@f1) FechaAutorizacion, concat('(',P.Alias,') ',P.Nombre) Provee, RE.Empresa Empresa, U.Nombre Para, U1.Nombre De, RAP.Pago TipoPago,(select SUM(MontoPago) from RequisicionesArchivosPagos where IdRequisiciones = A.Id) MontoTotalPago,RAP.Archivo ArchivoPagos,RAP.ValidarPago from Requisiciones as A left join RequisicionesArchivosPagos RAP on (RAP.IdRequisiciones = A.Id) left join RequisicionesEmpresas as RE on (RE.Id = A.IdEmpresas), Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		
		//DEBUGSystem.out.println("Si pasé Query");
		
		String estatusPago = "";
		float restantePago = 0;
		float montoPagado = 0;
		
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();
		while(resultados.next()) {
			//DEBUGSystem.out.println("Entré while");
			
			estatusPago = resultados.getString("ValidarPago");
			
			if(estatusPago == null||estatusPago.equals("Pendiente")){
				estatusPago = "PENDIENTE";
			}else{
				estatusPago = resultados.getString("ValidarPago");
			}
			
			montoPagado = 0;
			
			if(resultados.getString("MontoTotalPago") != null){
				montoPagado = Float.valueOf(resultados.getString("MontoTotalPago"));
				
			}
			
			//DEBUGSystem.out.println("Monto Pagado "+montoPagado);
			
			boolean numeric = true;
			
			try {
            	Double num = Double.parseDouble(resultados.getString("FacturaMontoTotal"));
	        } catch (NumberFormatException e) {
	            numeric = false;
	        }
			
			
			if(numeric){
				restantePago = Float.valueOf(resultados.getString("FacturaMontoTotal").replaceAll(",", ""))-montoPagado;
			}else{
				restantePago = Float.valueOf(resultados.getString("Total"))-montoPagado;
			}
			
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setDe(resultados.getString("De"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdProveedores(resultados.getString("IdProveedores"));
			objeto.setProveedores(resultados.getString("Provee"));
			objeto.setValue(resultados.getString("Empresa"));
			objeto.setIdPara(resultados.getString("IdPara"));
			objeto.setPara(resultados.getString("Para"));
			objeto.setFormaPago(resultados.getString("FormaPago"));
			objeto.setInstruccionesPago(resultados.getString("InstruccionesPago"));
			objeto.setDescripcion(resultados.getString("Descripcion"));
			objeto.setImporte(resultados.getString("Importe"));
			objeto.setIva(resultados.getString("Iva"));
			objeto.setTotal(resultados.getString("Total"));
			objeto.setEstatus(resultados.getString("Estatus").toUpperCase());
			objeto.setMoneda(resultados.getString("Moneda"));
			objeto.setMotivoRechazo(resultados.getString("MotivoRechazo"));
			objeto.setFacturaFolio(resultados.getString("FacturaFolio"));
			objeto.setFacturaMontoTotal(resultados.getString("FacturaMontoTotal"));
			objeto.setFacturaFechaIdealPago(resultados.getString("FacturaFechaIdealPago"));
			objeto.setFacturaObservaciones(resultados.getString("FacturaObservaciones"));
			objeto.setEstatusPago(estatusPago);
			objeto.setRestantePago(String.valueOf(restantePago));
			objeto.setFechaSolicitud(resultados.getString("FechaSolicitud"));
			objeto.setFechaAutorizacion(resultados.getString("FechaAutorizacion"));
			
			//DEBUGSystem.out.println(resultados.getString("ArchivoPagos") +" "+resultados.getString("ValidarPago")+" "+resultados.getString("ValidarPago"));
			if (resultados.getString("ArchivoPagos") == null||resultados.getString("ValidarPago") == null||resultados.getString("ValidarPago").equals("Pendiente")||resultados.getString("ValidarPago").equals("Parcial")){
				objeto.setArchivoPagos("No hay pago");
				info.add(objeto);
			}else{
				objeto.setArchivoPagos(resultados.getString("ArchivoPagos"));
			}
			//info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("BuscarAutorizar")) {
		StringBuffer where = new StringBuffer();
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Requisiciones();
		String whereInicio = " where " + seguridad.getNivel(10,session,new String[]{""}) + " and P.Id = A.IdProveedores and U.Id = A.IdPara and U1.Id = A.U and A.Estatus = ''";
		resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para, U1.Nombre De from Requisiciones as A, Proveedores P, Usuarios U, Usuarios U1 " + whereInicio);
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();
		while(resultados.next()) {
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setDe(resultados.getString("De"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdProveedores(resultados.getString("IdProveedores"));
			objeto.setProveedores(resultados.getString("Provee"));
			objeto.setIdEmpresas(resultados.getString("IdEmpresas"));
			objeto.setIdPara(resultados.getString("IdPara"));
			objeto.setPara(resultados.getString("Para"));
			objeto.setFormaPago(resultados.getString("FormaPago"));
			objeto.setInstruccionesPago(resultados.getString("InstruccionesPago"));
			objeto.setDescripcion(resultados.getString("Descripcion"));
			objeto.setImporte(resultados.getString("Importe"));
			objeto.setIva(resultados.getString("Iva"));
			objeto.setTotal(resultados.getString("Total"));
			objeto.setEstatus(resultados.getString("Estatus").toUpperCase());
			objeto.setMoneda(resultados.getString("Moneda"));
			objeto.setMotivoRechazo(resultados.getString("MotivoRechazo"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	if(request.getParameter("Accion").equals("BuscarFolio")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and P.Id = A.IdProveedores and A.IdEmpresas = RE.Id and U.Id = A.IdPara and U1.Id = A.U and A.Estatus = 'Autorizado' order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new Requisiciones();
		/* objeto.setFecha(request.getParameter("Campo"));
		
		if(!objeto.getFecha().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Fecha like '" + objeto.getFecha() + "%'"); entro = true; agregaOr = true;} */
		objeto.setId(request.getParameter("Campo"));
		
		if(!objeto.getId().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Id = '" + objeto.getId() + "'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and P.Id = A.IdProveedores and A.IdEmpresas = RE.Id and U.Id = A.IdPara and U1.Id = A.U and A.Estatus = 'Autorizado' and ("; where.append(")");}

		/* System.out.println("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para, U1.Nombre De from Requisiciones as A, Proveedores P, Usuarios U, Usuarios U1 " + whereInicio + where.toString()); */
		
		resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para, RE.Empresa Empresas, U1.Nombre De from Requisiciones as A, Proveedores P, RequisicionesEmpresas RE, Usuarios U, Usuarios U1 " + whereInicio + where.toString());
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();
		while(resultados.next()) {
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setDe(resultados.getString("De"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdProveedores(resultados.getString("IdProveedores"));
			objeto.setProveedores(resultados.getString("Provee"));
			objeto.setIdEmpresas(resultados.getString("IdEmpresas"));
			objeto.setEmpresas(resultados.getString("Empresas"));
			objeto.setIdPara(resultados.getString("IdPara"));
			objeto.setPara(resultados.getString("Para"));
			objeto.setFormaPago(resultados.getString("FormaPago"));
			objeto.setInstruccionesPago(resultados.getString("InstruccionesPago"));
			objeto.setDescripcion(resultados.getString("Descripcion"));
			objeto.setImporte(resultados.getString("Importe"));
			objeto.setIva(resultados.getString("Iva"));
			objeto.setTotal(resultados.getString("Total"));
			objeto.setEstatus(resultados.getString("Estatus").toUpperCase());
			objeto.setMoneda(resultados.getString("Moneda"));
			objeto.setMotivoRechazo(resultados.getString("MotivoRechazo"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		String[] soloFecha=request.getParameter("FacturaFechaIdealPago").split(" ");
		sentencia.executeUpdate("insert into Requisiciones (U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo,FacturaFechaIdealPago) values ('" + 
			session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + valoresDefault.getFecha(request.getParameter("Fecha")) + "','" + valoresDefault.getEntero(request.getParameter("IdProveedores")) + "','" + valoresDefault.getEntero(request.getParameter("IdEmpresas")) + "','" + valoresDefault.getEntero(request.getParameter("IdPara")) + "','" + request.getParameter("FormaPago") + "','" + request.getParameter("InstruccionesPago") + "','" + request.getParameter("Descripcion") + "','" + valoresDefault.getDecimal(request.getParameter("Importe")) + "','" + valoresDefault.getDecimal(request.getParameter("Iva")) + "','" + valoresDefault.getDecimal(request.getParameter("Total")) + "','" + request.getParameter("Estatus") + "','" + request.getParameter("Moneda") + "','" + request.getParameter("MotivoRechazo") + "','" + soloFecha[0] + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into RequisicionesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo,FacturaFechaIdealPago) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo,FacturaFechaIdealPago from Requisiciones where Id = '" + ultimoId + "'");
		objeto = new Requisiciones();
		objeto.setId("" + ultimoId);
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			Requisiciones[] ids = gson.fromJson(request.getParameter("Ids"), Requisiciones[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into RequisicionesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo from Requisiciones where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from Requisiciones where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			Requisiciones ids = gson.fromJson(request.getParameter("Ids"), Requisiciones.class);
			sentencia.executeUpdate("insert into RequisicionesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo from Requisiciones where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from Requisiciones where Id = '" + ids.getId() + "'");
		}
		objeto = new Requisiciones();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		sentencia.executeUpdate("update Requisiciones set Fecha='" + valoresDefault.getFecha(request.getParameter("Fecha")) + "',IdProveedores='" + valoresDefault.getEntero(request.getParameter("IdProveedores")) + "',IdEmpresas='" + valoresDefault.getEntero(request.getParameter("IdEmpresas")) + "',IdPara='" + valoresDefault.getEntero(request.getParameter("IdPara")) + "',FormaPago='" + request.getParameter("FormaPago") + "',InstruccionesPago='" + request.getParameter("InstruccionesPago") + "',Descripcion='" + request.getParameter("Descripcion") + "',Importe='" + valoresDefault.getDecimal(request.getParameter("Importe")) + "',Iva='" + valoresDefault.getDecimal(request.getParameter("Iva")) + "',Total='" + valoresDefault.getDecimal(request.getParameter("Total")) + "',Estatus='" + request.getParameter("Estatus") + "',Moneda='" + request.getParameter("Moneda") + "',MotivoRechazo='" + request.getParameter("MotivoRechazo") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into RequisicionesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo from Requisiciones where Id = '" + request.getParameter("id") + "'");
		objeto = new Requisiciones();
		objeto.setId(request.getParameter("id"));
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Autorizar")) {
		gson = new Gson();
		try {
			Requisiciones[] ids = gson.fromJson(request.getParameter("Ids"), Requisiciones[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("update Requisiciones set Estatus='Autorizado' where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("insert into RequisicionesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo from Requisiciones where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			Requisiciones ids = gson.fromJson(request.getParameter("Ids"), Requisiciones.class);
			sentencia.executeUpdate("update Requisiciones set Estatus='Autorizado' where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("insert into RequisicionesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo from Requisiciones where Id = '" + ids.getId() + "'");
		}
		objeto = new Requisiciones();
		objeto.setId(request.getParameter("id"));
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Rechazar")) {
		gson = new Gson();
		try {
			Requisiciones[] ids = gson.fromJson(request.getParameter("Ids"), Requisiciones[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("update Requisiciones set Estatus='Rechazar',MotivoRechazo='" + request.getParameter("MotivoRechazo") + "' where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("insert into RequisicionesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo from Requisiciones where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			Requisiciones ids = gson.fromJson(request.getParameter("Ids"), Requisiciones.class);
			sentencia.executeUpdate("update Requisiciones set Estatus='Rechazar',MotivoRechazo='" + request.getParameter("MotivoRechazo") + "' where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("insert into RequisicionesApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Fecha,IdProveedores,IdEmpresas,IdPara,FormaPago,InstruccionesPago,Descripcion,Importe,Iva,Total,Estatus,Moneda,MotivoRechazo from Requisiciones where Id = '" + ids.getId() + "'");
		}
		
		objeto = new Requisiciones();
		objeto.setId(request.getParameter("id"));
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Consultar")) {
	
		resultados = sentencia.executeQuery("select A.*, concat('(',P.Alias,') ',P.Nombre) Provee, U.Nombre Para from Requisiciones as A, Proveedores P, Usuarios U where P.Id = A.IdProveedores and U.Id = A.IdPara and A.Id = '" + request.getParameter("Id") + "'");
		objeto = new Requisiciones();
		while(resultados.next()) {
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setFecha(resultados.getString("Fecha"));
			objeto.setIdProveedores(resultados.getString("IdProveedores"));
			objeto.setProveedores(resultados.getString("Provee"));
			objeto.setIdEmpresas(resultados.getString("IdEmpresas"));
			objeto.setIdPara(resultados.getString("IdPara"));
			objeto.setPara(resultados.getString("Para"));
			objeto.setFormaPago(resultados.getString("FormaPago"));
			objeto.setInstruccionesPago(resultados.getString("InstruccionesPago"));
			objeto.setDescripcion(resultados.getString("Descripcion"));
			objeto.setImporte(resultados.getString("Importe"));
			objeto.setIva(resultados.getString("Iva"));
			objeto.setTotal(resultados.getString("Total"));
			objeto.setEstatus(resultados.getString("Estatus").toUpperCase());
			objeto.setMoneda(resultados.getString("Moneda"));
			objeto.setMotivoRechazo(resultados.getString("MotivoRechazo"));
		}

		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getRequisiciones")) {
		resultados = sentencia.executeQuery("select Id, <columna> from Requisiciones where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<Requisiciones> info = new ArrayList<Requisiciones>();
		while(resultados.next()) {
			objeto = new Requisiciones();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new Requisiciones();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new Requisiciones();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* RequisicionesServlet.jsp */
%>



