package Procesamiento;
import java.io.IOException;
import java.sql.SQLException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Configuraciones.Generales;
import Libreria.MysqlPool;
import Utilerias.Fechas;
import Utilerias.TraduccionesSQL;
import Objetos.RequisicionCompra;

import com.google.gson.Gson;

public class RequisicionCompraServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6595935459568548860L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private RequisicionCompra objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public RequisicionCompraServlet() {
		super();
	}

	public void destroy() {
		super.destroy();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {	
		
		validar(request,response);
		
		try {
			if(request.getParameter("Accion").equals("Guardar")) {
				eDB.setConexion();
				eDB.setQuery("insert into RequisicionCompra (U,G,E,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + traducciones.getFecha(request.getParameter("Fecha")) + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Area") + "','" + traducciones.getEntero(request.getParameter("Cantidad")) + "','" + request.getParameter("Descripcion") + "','" + request.getParameter("IdGerente") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into RequisicionCompraApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo from RequisicionCompra where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new RequisicionCompra();
				objeto.setId(ultimoId);
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setArea(request.getParameter("Area"));
				objeto.setCantidad(request.getParameter("Cantidad"));
				objeto.setDescripcion(request.getParameter("Descripcion"));
				objeto.setAutorizacionDirector(request.getParameter("AutorizacionDirector"));
				objeto.setAutorizacionFinanzas(request.getParameter("AutorizacionFinanzas"));
				objeto.setIdGerente(request.getParameter("IdGerente"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id > 0 and A.U = '" + session.getAttribute("IdUsuario") + "'";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new RequisicionCompra();
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setArea(request.getParameter("Area"));
				objeto.setCantidad(request.getParameter("Cantidad"));
				objeto.setDescripcion(request.getParameter("Descripcion"));
				objeto.setIdGerente(request.getParameter("IdGerente"));

				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha like '" + objeto.getFecha() + "%'"); entro = true;}
				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getArea().equals("")) { where.append(" and A.Area like '" + objeto.getArea() + "%'"); entro = true;}
				if(!objeto.getCantidad().equals("")) { where.append(" and A.Cantidad like '" + objeto.getCantidad() + "%'"); entro = true;}
				if(!objeto.getDescripcion().equals("")) { where.append(" and A.Descripcion like '" + objeto.getDescripcion() + "%'"); entro = true;}
				if(!objeto.getIdGerente().equals("")) { where.append(" and A.IdGerente like '" + objeto.getIdGerente() + "%'"); entro = true;}
				
				//validar que tipo de usuario es con la session
				if(entro) { whereInicio = " where A.Id > 0 and A.U = '" + session.getAttribute("IdUsuario") + "'"; }
				resultados = eDB.getQuery("select U.Nombre as NombreGerente,A.*, if(A.AutorizacionDirector = '0000-00-00 00:00:00','', A.AutorizacionDirector) as Director, if(A.AutorizacionFinanzas = '0000-00-00 00:00:00','', A.AutorizacionFinanzas) as Finanzas from RequisicionCompra as A left join Gerentes as G on(G.Id = A.IdGerente) left join Usuarios as U on(G.IdUsuario = U.Id)" + whereInicio + where.toString());
				ArrayList<RequisicionCompra> info = new ArrayList<RequisicionCompra>();
				while(resultados.next()) {
					objeto = new RequisicionCompra();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setArea(resultados.getString("Area"));
					objeto.setCantidad(resultados.getString("Cantidad"));
					objeto.setDescripcion(resultados.getString("Descripcion"));
					objeto.setIdGerente(resultados.getString("NombreGerente"));
					objeto.setAutorizacionDirector(resultados.getString("Director"));
					objeto.setAutorizacionFinanzas(resultados.getString("Finanzas"));
					objeto.setEstatus(resultados.getString("Estatus"));
					objeto.setMotivo(resultados.getString("Motivo"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("Borrar")) {
				eDB.setConexion();
				String ids = request.getParameter("Ids");
				String[] id = ids.split(",");
				for(int i = 0; i < id.length; i++) {
					if(!id[i].equals("")) {
						eDB.setQuery("insert into RequisicionCompraApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo from RequisicionCompra where Id = '" + id[i] + "' and Estatus = 'Solicitud'");
						eDB.setQuery("delete from RequisicionCompra where Id = '" + id[i] + "' and Estatus = 'Solicitud'");
						resultados = eDB.getQuery("select Nombre from RequisicionCompra where Id = '" + id[i] + "'");
					}
				}
				objeto = new RequisicionCompra();
				while(resultados.next()){
					objeto.setNombre(resultados.getString("Nombre"));
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.*, if(A.AutorizacionDirector = '0000-00-00 00:00:00','', A.AutorizacionDirector) as Director, if(A.AutorizacionFinanzas = '0000-00-00 00:00:00','', A.AutorizacionFinanzas) as Finanzas from RequisicionCompra as A where A.Id = '" + request.getParameter("id") + "' and A.Estatus = 'Solicitud'");
				objeto = new RequisicionCompra();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setArea(resultados.getString("Area"));
					objeto.setCantidad(resultados.getString("Cantidad"));
					objeto.setDescripcion(resultados.getString("Descripcion"));
					objeto.setIdGerente(resultados.getString("IdGerente"));
					objeto.setAutorizacionDirector(resultados.getString("Director"));
					objeto.setAutorizacionFinanzas(resultados.getString("Finanzas"));
					objeto.setEstatus(resultados.getString("Estatus"));
					objeto.setMotivo(resultados.getString("Motivo"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update RequisicionCompra set Fecha='" + traducciones.getFecha(request.getParameter("Fecha")) + "',Nombre='" + request.getParameter("Nombre") + "',Area='" + request.getParameter("Area") + "',Cantidad='" + traducciones.getEntero(request.getParameter("Cantidad")) + "',Descripcion='" + request.getParameter("Descripcion") + "',IdGerente='" + request.getParameter("IdGerente") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into RequisicionCompraApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo from RequisicionCompra where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new RequisicionCompra();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setFecha(request.getParameter("Fecha"));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setArea(request.getParameter("Area"));
					objeto.setCantidad(request.getParameter("Cantidad"));
					objeto.setDescripcion(request.getParameter("Descripcion"));
					objeto.setIdGerente(request.getParameter("IdGerente"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getRequisicionCompra")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from RequisicionCompra where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<RequisicionCompra> info = new ArrayList<RequisicionCompra>();
				while(resultados.next()) {
					objeto = new RequisicionCompra();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("Autorizacion1")){
				eDB.setConexion();
				eDB.setQuery("update RequisicionCompra set AutorizacionDirector = (if(Estatus = 'Cancelado',if(AutorizacionFinanzas = '0000-00-00 00:00:00',AutorizacionDirector,'0000-00-00 00:00:00'),if(Estatus = 'Pendiente',AutorizacionDirector,if(Estatus = 'Autorizado',AutorizacionDirector,now())))), Estatus = (if(Estatus = 'Cancelado','Cancelado',if(Estatus = 'Pendiente',if(AutorizacionFinanzas = '0000-00-00 00:00:00','Pendiente','Autorizado'),if(Estatus = 'Autorizado','Autorizado','Pendiente')))) where Id = '" + request.getParameter("Id") + "'");
				eDB.setQuery("insert into RequisicionCompraApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo from RequisicionCompra where Id = '" + request.getParameter("Id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
			}
			else if(request.getParameter("Accion").equals("Autorizacion2")){
				eDB.setConexion();
				eDB.setQuery("update RequisicionCompra set AutorizacionFinanzas = (if(Estatus = 'Cancelado','0000-00-00 00:00:00',if(Estatus = 'Pendiente',now(),if(Estatus = 'Autorizado',AutorizacionFinanzas,now())))), Estatus = (if(Estatus = 'Cancelado','Cancelado',if(Estatus = 'Pendiente',if(AutorizacionDirector = '0000-00-00 00:00:00','Pendiente','Autorizado'),if(Estatus = 'Autorizado','Autorizado','Pendiente')))) where Id = '" + request.getParameter("Id") + "'");
				eDB.setQuery("insert into RequisicionCompraApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo from RequisicionCompra where Id = '" + request.getParameter("Id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
			}
			else if(request.getParameter("Accion").equals("Cancelar")){
				eDB.setConexion();
				if(request.getParameter("Perfil").equals("43")){
					//session de director
					eDB.setQuery("update RequisicionCompra set Motivo = CONCAT('" + request.getParameter("Motivo") + "',' ',now()), Estatus = 'Cancelado' where Id = '" + request.getParameter("Id") + "' and AutorizacionDirector = '0000-00-00 00:00:00' and Estatus = 'Solicitud'");
					eDB.setQuery("insert into RequisicionCompraApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo from RequisicionCompra where Id = '" + request.getParameter("Id") + "'");
				}else if(request.getParameter("Perfil").equals("44")){
					//session de finanzas
					eDB.setQuery("update RequisicionCompra set Motivo = CONCAT('" + request.getParameter("Motivo") + "',' ',now()), Estatus = 'Cancelado' where Id = '" + request.getParameter("Id") + "' and AutorizacionFinanzas = '0000-00-00 00:00:00' and Estatus = 'Pendiente'");
					eDB.setQuery("insert into RequisicionCompraApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Cantidad,Descripcion,IdGerente,AutorizacionDirector,AutorizacionFinanzas,Estatus,Motivo from RequisicionCompra where Id = '" + request.getParameter("Id") + "'");
				}
				resultados = eDB.getQuery("select Estatus from RequisicionCompra where Id = '" + request.getParameter("Id") + "'");
				objeto = new RequisicionCompra();
				while(resultados.next()){
					objeto.setEstatus(resultados.getString("Estatus"));
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("AutorizacionGerentes")){
				eDB.setConexion();
				resultados = eDB.getQuery("select U.Nombre as NombreGerente,A.*, if(A.AutorizacionDirector = '0000-00-00 00:00:00','', A.AutorizacionDirector) as Director, if(A.AutorizacionFinanzas = '0000-00-00 00:00:00','', A.AutorizacionFinanzas) as Finanzas from RequisicionCompra as A left join Gerentes as G on(G.Id = A.IdGerente) left join Usuarios as U on(G.IdUsuario = U.Id) where U.Id = '" + session.getAttribute("IdUsuario") + "'");
				ArrayList<RequisicionCompra> info = new ArrayList<RequisicionCompra>();
				while(resultados.next()) {
					objeto = new RequisicionCompra();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setArea(resultados.getString("Area"));
					objeto.setCantidad(resultados.getString("Cantidad"));
					objeto.setDescripcion(resultados.getString("Descripcion"));
					objeto.setIdGerente(resultados.getString("NombreGerente"));
					objeto.setAutorizacionDirector(resultados.getString("Director"));
					objeto.setAutorizacionFinanzas(resultados.getString("Finanzas"));
					objeto.setEstatus(resultados.getString("Estatus"));
					objeto.setMotivo(resultados.getString("Motivo"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("AutorizacionRH")){
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id > 0 and A.Estatus <> 'Solicitud'";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new RequisicionCompra();
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setArea(request.getParameter("FechaFin"));
				

				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha >= '" + objeto.getFecha() + "'"); entro = true;}
				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getArea().equals("")) { where.append(" and A.Fecha <= '" + objeto.getArea() + "'"); entro = true;}
				
				
				//validar que tipo de usuario es con la session
				if(entro) { whereInicio = " where A.Id > 0 and A.Estatus <> 'Solicitud'"; }
				resultados = eDB.getQuery("select U.Nombre as NombreGerente,A.*, if(A.AutorizacionDirector = '0000-00-00 00:00:00','', A.AutorizacionDirector) as Director, if(A.AutorizacionFinanzas = '0000-00-00 00:00:00','', A.AutorizacionFinanzas) as Finanzas from RequisicionCompra as A left join Gerentes as G on(G.Id = A.IdGerente) left join Usuarios as U on(G.IdUsuario = U.Id)" + whereInicio + where.toString());
				ArrayList<RequisicionCompra> info = new ArrayList<RequisicionCompra>();
				while(resultados.next()) {
					objeto = new RequisicionCompra();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setArea(resultados.getString("Area"));
					objeto.setCantidad(resultados.getString("Cantidad"));
					objeto.setDescripcion(resultados.getString("Descripcion"));
					objeto.setIdGerente(resultados.getString("NombreGerente"));
					objeto.setAutorizacionDirector(resultados.getString("Director"));
					objeto.setAutorizacionFinanzas(resultados.getString("Finanzas"));
					objeto.setEstatus(resultados.getString("Estatus"));
					objeto.setMotivo(resultados.getString("Motivo"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new RequisicionCompra();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new RequisicionCompra();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		}
	}

	public void init() throws ServletException {
		// Put your code here
		try {
			eDB = new MysqlPool();
			generales = new Generales();
			traducciones = new TraduccionesSQL();
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
	
	private void imprimeJson(HttpServletResponse response, RequisicionCompra objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<RequisicionCompra> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(RequisicionCompra objeto, Exception e) {
		objeto.setError(true);
		fechas = new Fechas();
		StringBuffer log = new StringBuffer();
		log.append("Serie:");
		log.append(serialVersionUID);
		log.append(" Evento:");
		log.append(fechas.getKey());
		log.append(" ");
		System.out.print(log.toString());
		e.printStackTrace(System.out);
		log.append(e.getMessage());
		objeto.setLog(log.toString());
	}
}
/* RequisicionCompraServlet */