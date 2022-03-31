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
<%@ page import="Objetos.DocumentosDH"%>
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
private void imprimeJson(HttpServletResponse response, DocumentosDH objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}
private void imprimeJson(HttpServletResponse response, ArrayList<DocumentosDH> objeto) throws IOException {
	response.setContentType("application/json");
	PrintWriter out = response.getWriter();
	gson = new Gson();
	out.println(gson.toJson(objeto));
	out.flush();
	out.close();
}

private void armaLog(DocumentosDH objeto, Exception e) {
	objeto.setError(true);
	fechas = new Fechas();
	StringBuffer log = new StringBuffer();
	log.append("Serie:");
	log.append("DocumentosDHServlet.jsp");
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
DocumentosDH objeto = null;
int ultimoId = 0;
try {
	conexion = datasource.getConnection();
	sentencia = conexion.createStatement();
	if(request.getParameter("Accion").equals("Buscar")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new DocumentosDH();
		objeto.setModulo(request.getParameter("Campo"));
		objeto.setCodigo(request.getParameter("Campo"));
		objeto.setNombre(request.getParameter("Campo"));
		objeto.setArchivo(request.getParameter("Campo"));
		//objeto.setTitulo(request.getParameter("Campo"));
		//objeto.setFecha(request.getParameter("Campo"));

		if(!objeto.getModulo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Modulo like '%" + objeto.getModulo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCodigo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Codigo like '%" + objeto.getCodigo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '%" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNumRevision().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.NumRevision like '" + objeto.getNumRevision() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFechaRevision().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.FechaRevision like '" + objeto.getFechaRevision() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from DocumentosDH as A" + whereInicio + where.toString());
		ArrayList<DocumentosDH> info = new ArrayList<DocumentosDH>();
		while(resultados.next()) {
			objeto = new DocumentosDH();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
		objeto.setModulo(resultados.getString("Modulo"));
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
		
		objeto = new DocumentosDH();
		objeto.setModulo(request.getParameter("Campo"));
		objeto.setCodigo(request.getParameter("Campo"));
		objeto.setNombre(request.getParameter("Campo"));
		objeto.setArchivo(request.getParameter("Campo"));
		//objeto.setTitulo(request.getParameter("Campo"));
		//objeto.setFecha(request.getParameter("Campo"));

		if(!objeto.getModulo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Modulo like '%" + objeto.getModulo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCodigo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Codigo like '" + objeto.getCodigo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNumRevision().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.NumRevision like '" + objeto.getNumRevision() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFechaRevision().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.FechaRevision like '" + objeto.getFechaRevision() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from DocumentosDH as A" + whereInicio + where.toString());
		/* System.out.println("select A.*,E.Id as UsuarioActivo from DocumentosDH as A, Empleados as E where Nombre like '%%' and E.IdUsuario = '"+session.getAttribute("IdUsuario")+"' and E.Estatus = 'ACTIVO'");
		resultados = sentencia.executeQuery("select A.*,E.Id as UsuarioActivo from DocumentosDH as A, Empleados as E where Nombre like '%%' and E.IdUsuario = '"+session.getAttribute("IdUsuario")+"' and E.Estatus = 'ACTIVO'"); */
		ArrayList<DocumentosDH> info = new ArrayList<DocumentosDH>();
		while(resultados.next()) {
			objeto = new DocumentosDH();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setModulo(resultados.getString("Modulo"));
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
	else if(request.getParameter("Accion").equals("BuscarFiltradoModulo")) {
		StringBuffer where = new StringBuffer();
		String whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " order by Id desc limit 5";
		boolean entro = false;
		boolean agregaOr = false;
		
		objeto = new DocumentosDH();
		objeto.setModulo(request.getParameter("Campo"));
		//objeto.setCodigo(request.getParameter("Campo"));
		//objeto.setNombre(request.getParameter("Campo"));
		//objeto.setArchivo(request.getParameter("Campo"));
		//objeto.setTitulo(request.getParameter("Campo"));
		//objeto.setFecha(request.getParameter("Campo"));

		if(!objeto.getModulo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Modulo like '%" + objeto.getModulo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getCodigo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Codigo like '" + objeto.getCodigo() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNombre().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Nombre like '" + objeto.getNombre() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getNumRevision().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.NumRevision like '" + objeto.getNumRevision() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getFechaRevision().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.FechaRevision like '" + objeto.getFechaRevision() + "%'"); entro = true; agregaOr = true;}
		if(!objeto.getArchivo().equals("")) { if(agregaOr){ where.append(" or"); } where.append(" A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true; agregaOr = true;}
		if(entro) { whereInicio = " where " + seguridad.getNivel(0,session,new String[]{""}) + " and ("; where.append(")");}

		resultados = sentencia.executeQuery("select A.* from DocumentosDH as A" + whereInicio + where.toString());
		/* System.out.println("select A.*,E.Id as UsuarioActivo from DocumentosDH as A, Empleados as E where Nombre like '%%' and E.IdUsuario = '"+session.getAttribute("IdUsuario")+"' and E.Estatus = 'ACTIVO'");
		resultados = sentencia.executeQuery("select A.*,E.Id as UsuarioActivo from DocumentosDH as A, Empleados as E where Nombre like '%%' and E.IdUsuario = '"+session.getAttribute("IdUsuario")+"' and E.Estatus = 'ACTIVO'"); */
		ArrayList<DocumentosDH> info = new ArrayList<DocumentosDH>();
		while(resultados.next()) {
			objeto = new DocumentosDH();
			objeto.setId(resultados.getString("Id"));
			objeto.setBloquear(resultados.getBoolean("Bloquear"));
			objeto.setModulo(resultados.getString("Modulo"));
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
		
		sentencia.executeUpdate("insert into DocumentosDH (U,G,E,Bloquear,Modulo,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','false','" + request.getParameter("Modulo") + "','" + request.getParameter("Codigo") + "','" + request.getParameter("Nombre") + "','" + request.getParameter("NumRevision") + "','" + request.getParameter("FechaRevision") + "','" + nombreArchivo + "','" + request.getParameter("IdsUsuariosLectura") + "')",Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		while(indice.next()) {
			ultimoId = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {;}
		sentencia.executeUpdate("insert into DocumentosDHApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Modulo,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Modulo,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura from DocumentosDH where Id = '" + ultimoId + "'");
		
		//BLOQUEO LA FUNCIÓN DE ENVÍO DE CORREO EN NUEVA ALTA
		/* resultados = sentencia.executeQuery("select A.* from DocumentosDH as A where Id = '" + ultimoId + "'");
		
		String moduloDocDH = "",codigoDocDH = "",nombreDocDH = "",revisionDocDH = "";
		while(resultados.next()) {
			moduloDocDH = resultados.getString("Modulo");
			codigoDocDH = resultados.getString("Codigo");
			nombreDocDH = resultados.getString("Nombre");
			revisionDocDH = resultados.getString("NumRevision");
		}
		
		//ENVIA CORREO POR ALTAS
		StringBuffer mensajeAvisoSeg = new StringBuffer();
		
		mensajeAvisoSeg.append("Se notifica la publicación del siguiente Documento de seguridad:\n");
		mensajeAvisoSeg.append("\n");
		mensajeAvisoSeg.append(codigoDocDH+"-"+nombreDocDH+" Revision "+revisionDocDH+"\n");
		mensajeAvisoSeg.append("\n");
		mensajeAvisoSeg.append("Favor de contactar a su supervisor para obtener detalles");
		
		CorreosElectronicos emailsSeg = new CorreosElectronicos();
		String[] Seg = {"cctv@mcs-holding.com","seguridad@mcs-holding.com"};
		String[] SegBCC = {"aquezada@mcs-holding.com"};
		emailsSeg.setA(Seg);
		emailsSeg.setBCC(SegBCC);
		emailsSeg.setTitulo("Alta de documento de Seguridad");
		emailsSeg.setMensaje(mensajeAvisoSeg.toString());
		emailsSeg.enviar(); */
		
		
		objeto = new DocumentosDH();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("Borrar")) {
		gson = new Gson();
		try {
			DocumentosDH[] ids = gson.fromJson(request.getParameter("Ids"), DocumentosDH[].class);
			for(int i = 0; i < ids.length; i++) {
				sentencia.executeUpdate("insert into DocumentosDHApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Modulo,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Modulo,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura from DocumentosDH where Id = '" + ids[i].getId() + "'");
				sentencia.executeUpdate("delete from DocumentosDH where Id = '" + ids[i].getId() + "'");
			}
		} catch(JsonSyntaxException e1) {
			DocumentosDH ids = gson.fromJson(request.getParameter("Ids"), DocumentosDH.class);
			sentencia.executeUpdate("insert into DocumentosDHApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,Bloquear,Modulo,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,Bloquear,Modulo,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura from DocumentosDH where Id = '" + ids.getId() + "'");
			sentencia.executeUpdate("delete from DocumentosDH where Id = '" + ids.getId() + "'");
		}
		objeto = new DocumentosDH();
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
		
		sentencia.executeUpdate("update DocumentosDH set Modulo='" + request.getParameter("Modulo") + "',Codigo='" + request.getParameter("Codigo") + "',Nombre='" + request.getParameter("Nombre") + "',NumRevision='" + request.getParameter("NumRevision") + "',FechaRevision='" + request.getParameter("FechaRevision") + "',Archivo='" + nombreArchivo + "',IdsUsuariosLectura='" + request.getParameter("IdsUsuariosLectura") + "' where Id = '" + request.getParameter("id") + "'");
		sentencia.executeUpdate("insert into DocumentosDHApoyo (Quien,Registro,IdOrigen,U,G,E,Bloquear,Modulo,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,Bloquear,Modulo,Codigo,Nombre,NumRevision,FechaRevision,Archivo,IdsUsuariosLectura from DocumentosDH where Id = '" + request.getParameter("id") + "'");
		
		
		//BLOQUEO LA FUNCIÓN DE ENVÍO DE CORREO EN NUEVA ALTA
		/*
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
		String[] SegBCC = {"aquezada@mcs-holding.com"};
		emailsSeg.setA(Seg);
		emailsSeg.setBCC(SegBCC);
		emailsSeg.setTitulo("Modificación en documento de Seguridad");
		emailsSeg.setMensaje(mensajeAvisoSeg.toString());
		emailsSeg.enviar();
		*/
		
		
		
		
		objeto = new DocumentosDH();
		imprimeJson(response,objeto);
	}
	else if(request.getParameter("Accion").equals("getDocumentosDH")) {
		resultados = sentencia.executeQuery("select Id, <columna> from DocumentosDH where <columna> like '" + request.getParameter("filter[value]") + "%'");
		ArrayList<DocumentosDH> info = new ArrayList<DocumentosDH>();
		while(resultados.next()) {
			objeto = new DocumentosDH();
			objeto.setId(resultados.getString("Id"));
			objeto.setValue(resultados.getString("<columna>"));
			info.add(objeto);
		}
		imprimeJson(response,info);
	}
	conexion.close();
} catch(SQLException e) {
	objeto = new DocumentosDH();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} catch(NullPointerException e) {
	objeto = new DocumentosDH();
	armaLog(objeto,e);
	imprimeJson(response, objeto);
} finally {
	try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
	try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
	try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
}

/* DocumentosDHServlet.jsp */
%>


