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
<%@ page import="Objetos.FormatosSeguridad"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.JsonSyntaxException"%>
<%@ page import="Libreria.CorreosElectronicos" %>
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
private void imprimeJson(HttpServletResponse response, FormatosSeguridad objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<FormatosSeguridad> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(FormatosSeguridad objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("FormatosSeguridadServlet.jsp");
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
FormatosSeguridad objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new FormatosSeguridad();
		objeto.setCodigo(request.getParameter("Campo"));
		objeto.setNombre(request.getParameter("Campo"));
		objeto.setArchivo(request.getParameter("Campo"));
		//objeto.setTitulo(request.getParameter("Campo"));
		//objeto.setFecha(request.getParameter("Campo"));

		if(!objeto.getCodigo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Codigo like '%" + objeto.getCodigo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '%" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNumRevision().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.NumRevision like '" + objeto.getNumRevision() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFechaRevision().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.FechaRevision like '" + objeto.getFechaRevision() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from FormatosSeguridad as A" + whereInicio + where.toString());
		ArrayList<FormatosSeguridad> info = new ArrayList<FormatosSeguridad>();
		while(resultados.next()) {
			objeto = new FormatosSeguridad();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setCodigo(resultados.getString("Codigo"));
		objeto.setNombre(resultados.getString("Nombre"));
		objeto.setNumRevision(resultados.getString("NumRevision"));
		objeto.setFechaRevision(resultados.getString("FechaRevision"));
		objeto.setArchivo(resultados.getString("Archivo").replaceAll(" ","_"));
		objeto.setIdsUsuariosLectura(resultados.getString("IdsUsuariosLectura"));
			info.add(objeto);
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("BuscarFiltrado")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new FormatosSeguridad();
		objeto.setCodigo(request.getParameter("Campo"));
		objeto.setNombre(request.getParameter("Campo"));
		objeto.setArchivo(request.getParameter("Campo"));
		//objeto.setTitulo(request.getParameter("Campo"));
		//objeto.setFecha(request.getParameter("Campo"));

		if(!objeto.getCodigo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Codigo like '" + objeto.getCodigo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNumRevision().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.NumRevision like '" + objeto.getNumRevision() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFechaRevision().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.FechaRevision like '" + objeto.getFechaRevision() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from FormatosSeguridad as A" + whereInicio + where.toString());
		/* System.out.println("select A.*,E.Id as UsuarioActivo from FormatosSeguridad as A, Empleados as E where Nombre like '%%' and E.IdUsuario = '"+session.getAttribute("IdUsuario")+"' and E.Estatus = 'ACTIVO'");
		resultados = sentencia.executeQuery("select A.*,E.Id as UsuarioActivo from FormatosSeguridad as A, Empleados as E where Nombre like '%%' and E.IdUsuario = '"+session.getAttribute("IdUsuario")+"' and E.Estatus = 'ACTIVO'"); */
		ArrayList<FormatosSeguridad> info = new ArrayList<FormatosSeguridad>();
		while(resultados.next()) {
			objeto = new FormatosSeguridad();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setCodigo(resultados.getString("Codigo"));
			objeto.setNombre(resultados.getString("Nombre"));
			objeto.setNumRevision(resultados.getString("NumRevision"));
			objeto.setFechaRevision(resultados.getString("FechaRevision"));
			objeto.setArchivo(resultados.getString("Archivo").replaceAll(" ","_"));
			objeto.setIdsUsuariosLectura(resultados.getString("IdsUsuariosLectura"));
		
			//String idsCadena=resultados.getString("IdsUsuariosLectura")+",FIN";
			/* if(!resultados.getString("IdsUsuariosLectura").contains(",")){
				System.out.println("No tuvo coma");
				idsCadena=resultados.getString("IdsUsuariosLectura")+",";
				System.out.println("Ya la agregué "+idsCadena);
			}else{
				idsCadena=resultados.getString("IdsUsuariosLectura");
			} */
		
			//System.out.println("La Cadena de Ids contiene "+idsCadena);
			
			//String[] Ids = idsCadena.split(",");
			String[] Ids = resultados.getString("IdsUsuariosLectura").split(",");
			//System.out.println("El largo de Ids es "+Ids.length+" y los valores son 0 "+Ids[0]+" el 2 "+Ids[1]);
			//DEBUGSystem.out.println("El largo de Ids es "+Ids.length);
			boolean idEncontrado = false;
			int elementos = 0;
			/* while(!Ids[elementos].equals("FIN")) {
				System.out.println("Valor de Id revisado "+Ids[elementos]+" Valor de Id de Sesión "+resultados.getString("UsuarioActivo"));
					if(Ids[elementos] == resultados.getString("UsuarioActivo")){
						idEncontrado=true;
					}
				elementos++;
			} */
			while(elementos < Ids.length) {
				//DEBUGSystem.out.println("Valor de Id revisado "+Ids[elementos]+" Valor de Id de Sesión "+session.getAttribute("IdUsuario"));
					if(Ids[elementos].equals(session.getAttribute("IdUsuario"))){
						idEncontrado=true;
					}
				elementos++;
			}
			//DEBUGSystem.out.println("Valor de idEncontrado "+idEncontrado);
			if (idEncontrado){
				info.add(objeto);
			}
			elementos = 0;
		}

		imprimeJson(response,info);
	}
	else if(request.getParameter("Accion").equals("Guardar")) {
		String nombreArchivo = request.getParameter("Archivo").toString();
		nombreArchivo = nombreArchivo.replaceAll(" ","_");
		nombreArchivo = nombreArchivo.replaceAll("á","a");
		nombreArchivo = nombreArchivo.replaceAll("é","e");
		nombreArchivo = nombreArchivo.replaceAll("í","i");
		nombreArchivo = nombreArchivo.replaceAll("ó","o");
		nombreArchivo = nombreArchivo.replaceAll("ú","u");
		nombreArchivo = nombreArchivo.replaceAll("Á","A");
		nombreArchivo = nombreArchivo.replaceAll("É","E");
		nombreArchivo = nombreArchivo.replaceAll("Í","I");
		nombreArchivo = nombreArchivo.replaceAll("Ó","O");
		nombreArchivo = nombreArchivo.replaceAll("Ú","U");
		nombreArchivo = nombreArchivo.replaceAll("ñ","n");
		nombreArchivo = nombreArchivo.replaceAll("Ñ","N");
		nombreArchivo = nombreArchivo.replaceAll("ü","u");
		nombreArchivo = nombreArchivo.replaceAll("Ü","U");
		
		sentencia.executeUpdate("insert into FormatosSeguridad (U,G,E,Bloquear,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + request.getParameter("Codigo") + "','" + request.getParameter("Nombre") + "','" + request.getParameter("NumRevision") + "','" + request.getParameter("FechaRevision") + "','" + nombreArchivo + "','" + request.getParameter("IdsUsuariosLectura") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into FormatosSeguridadApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura from FormatosSeguridad where Id = '" + ultimoId + "'");
		
		
		resultados = sentencia.executeQuery("select A.* from FormatosSeguridad as A where Id = '" + ultimoId + "'");
		
		String codigoDocSeg = "",nombreDocSeg = "",revisionDocSeg = "";
		while(resultados.next()) {
			codigoDocSeg = resultados.getString("Codigo");
			nombreDocSeg = resultados.getString("Nombre");
			revisionDocSeg = resultados.getString("NumRevision");
		}
		
		//ENVIA CORREO POR ALTAS
		StringBuffer mensajeAvisoSeg = new StringBuffer();
		
		mensajeAvisoSeg.append("Se notifica la publicación del siguiente Documento de seguridad:\n");
		mensajeAvisoSeg.append("\n");
		mensajeAvisoSeg.append(codigoDocSeg+"-"+nombreDocSeg+" Revision "+revisionDocSeg+"\n");
		mensajeAvisoSeg.append("\n");
		mensajeAvisoSeg.append("Favor de contactar a su supervisor para obtener detalles");
		
		CorreosElectronicos emailsSeg = new CorreosElectronicos();
		String[] Seg = {"cctv@mcs-holding.com","seguridad@mcs-holding.com"};
		/* String[] Seg = {"aquezada@mcs-holding.com","support@cargo-sales.net"}; */
		String[] SegBCC = {"aquezada@mcs-holding.com"};
		emailsSeg.setA(Seg);
		emailsSeg.setBCC(SegBCC);
		emailsSeg.setTitulo("Alta de documento de Seguridad");
		emailsSeg.setMensaje(mensajeAvisoSeg.toString());
		emailsSeg.enviar();
		
		
		objeto = new FormatosSeguridad();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			FormatosSeguridad[] ids = gson.fromJson(request.getParameter("Ids"), FormatosSeguridad[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into FormatosSeguridadApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura from FormatosSeguridad where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from FormatosSeguridad where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			FormatosSeguridad ids = gson.fromJson(request.getParameter("Ids"), FormatosSeguridad.class);
			sentencia.executeUpdate("insert into FormatosSeguridadApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura from FormatosSeguridad where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from FormatosSeguridad where Id = '" + ids.getId() + "'");
		}
		objeto = new FormatosSeguridad();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Modificar")) {
		String nombreArchivo = request.getParameter("Archivo").toString();
		nombreArchivo = nombreArchivo.replaceAll("á","a");
		nombreArchivo = nombreArchivo.replaceAll("é","e");
		nombreArchivo = nombreArchivo.replaceAll("í","i");
		nombreArchivo = nombreArchivo.replaceAll("ó","o");
		nombreArchivo = nombreArchivo.replaceAll("ú","u");
		nombreArchivo = nombreArchivo.replaceAll("Á","A");
		nombreArchivo = nombreArchivo.replaceAll("É","E");
		nombreArchivo = nombreArchivo.replaceAll("Í","I");
		nombreArchivo = nombreArchivo.replaceAll("Ó","O");
		nombreArchivo = nombreArchivo.replaceAll("Ú","U");
		nombreArchivo = nombreArchivo.replaceAll("ñ","n");
		nombreArchivo = nombreArchivo.replaceAll("Ñ","N");
		nombreArchivo = nombreArchivo.replaceAll("ü","u");
		nombreArchivo = nombreArchivo.replaceAll("Ü","U");
		
		sentencia.executeUpdate("update FormatosSeguridad set Codigo='" + request.getParameter("Codigo") + "',Nombre='" + request.getParameter("Nombre") + "',NumRevision='" + request.getParameter("NumRevision") + "',FechaRevision='" + request.getParameter("FechaRevision") + "',Archivo='" + nombreArchivo + "',IdsUsuariosLectura='" + request.getParameter("IdsUsuariosLectura") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into FormatosSeguridadApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura from FormatosSeguridad where Id = '" + request.getParameter("id") + "'");
		
		
		//ENVIA CORREO POR MODIFICACIONES
		StringBuffer mensajeAvisoSeg = new StringBuffer();
		
		mensajeAvisoSeg.append("El Documento de seguridad:\n");
		mensajeAvisoSeg.append("\n");
		mensajeAvisoSeg.append(request.getParameter("Codigo")+"-"+request.getParameter("Nombre")+"\n");
		mensajeAvisoSeg.append("\n");
		mensajeAvisoSeg.append("Ha sido modificado. \n");
		mensajeAvisoSeg.append("\n");
		mensajeAvisoSeg.append("Favor de contactar a su supervisor para obtener detalles");
		
		CorreosElectronicos emailsSeg = new CorreosElectronicos();
		String[] Seg = {"cctv@mcs-holding.com","seguridad@mcs-holding.com"};
		/* String[] Seg = {"aquezada@mcs-holding.com","support@cargo-sales.net"}; */
		String[] SegBCC = {"aquezada@mcs-holding.com"};
		emailsSeg.setA(Seg);
		emailsSeg.setBCC(SegBCC);
		emailsSeg.setTitulo("Modificación en documento de Seguridad");
		emailsSeg.setMensaje(mensajeAvisoSeg.toString());
		emailsSeg.enviar();
		
		objeto = new FormatosSeguridad();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getFormatosSeguridad")) {
		resultados = sentencia.executeQuery("select Id, <columna> from FormatosSeguridad where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<FormatosSeguridad> info = new ArrayList<FormatosSeguridad>();
		while(resultados.next()) {
			objeto = new FormatosSeguridad();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new FormatosSeguridad();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new FormatosSeguridad();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* FormatosSeguridadServlet.jsp */
%>


