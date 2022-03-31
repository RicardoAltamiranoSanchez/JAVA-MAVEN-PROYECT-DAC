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
import Objetos.PermisosSinGoce;

import com.google.gson.Gson;

public class PermisosSinGoceServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3616595443763048777L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private PermisosSinGoce objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public PermisosSinGoceServlet() {
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
				eDB.setQuery("insert into PermisosSinGoce (U,G,E,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + traducciones.getFecha(request.getParameter("Fecha")) + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Area") + "','" + request.getParameter("Puesto") + "','" + request.getParameter("Empresa") + "','" + traducciones.getFecha(request.getParameter("FechaIngreso")) + "','" + traducciones.getEntero(request.getParameter("DiasTomar")) + "','" + request.getParameter("FechaDiasTomar") + "','" + traducciones.getEntero(request.getParameter("IdGerente")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into PermisosSinGoceApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo from PermisosSinGoce where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new PermisosSinGoce();
				objeto.setId(ultimoId);
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setArea(request.getParameter("Area"));
				objeto.setPuesto(request.getParameter("Puesto"));
				objeto.setEmpresa(request.getParameter("Empresa"));
				objeto.setFechaIngreso(request.getParameter("FechaIngreso"));
				objeto.setDiasTomar(request.getParameter("DiasTomar"));
				objeto.setFechaDiasTomar(request.getParameter("FechaDiasTomar"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id > 0 and A.U = '" + session.getAttribute("IdUsuario") + "'";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new PermisosSinGoce();
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setArea(request.getParameter("Area"));
				objeto.setPuesto(request.getParameter("Puesto"));
				objeto.setEmpresa(request.getParameter("Empresa"));
				objeto.setFechaIngreso(request.getParameter("FechaIngreso"));
				objeto.setDiasTomar(request.getParameter("DiasTomar"));
				objeto.setFechaDiasTomar(request.getParameter("FechaDiasTomar"));
				objeto.setIdGerente(request.getParameter("IdGerente"));

				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha like '" + objeto.getFecha() + "%'"); entro = true;}
				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getArea().equals("")) { where.append(" and A.Area like '" + objeto.getArea() + "%'"); entro = true;}
				if(!objeto.getPuesto().equals("")) { where.append(" and A.Puesto like '" + objeto.getPuesto() + "%'"); entro = true;}
				if(!objeto.getEmpresa().equals("")) { where.append(" and A.Empresa like '" + objeto.getEmpresa() + "%'"); entro = true;}
				if(!objeto.getFechaIngreso().equals("")) { where.append(" and A.FechaIngreso like '" + objeto.getFechaIngreso() + "%'"); entro = true;}
				if(!objeto.getDiasTomar().equals("")) { where.append(" and A.DiasTomar like '" + objeto.getDiasTomar() + "%'"); entro = true;}
				if(!objeto.getFechaDiasTomar().equals("")) { where.append(" and A.FechaDiasTomar like '" + objeto.getFechaDiasTomar() + "%'"); entro = true;}
				if(!objeto.getIdGerente().equals("")) { where.append(" and A.IdGerente = '" + objeto.getIdGerente() + "'"); entro = true;}
				
				
				//validar que tipo de usuario es con la session
				if(entro) { whereInicio = " where A.Id > 0 and A.U = '" + session.getAttribute("IdUsuario") + "'"; }
				resultados = eDB.getQuery("select U.Nombre as NombreGerente,A.*, if(A.AutorizacionGerente = '0000-00-00 00:00:00','', A.AutorizacionGerente) as Gerente, if(A.AutorizacionRH = '0000-00-00 00:00:00','', A.AutorizacionRH) as RH from PermisosSinGoce as A left join Gerentes as G on(G.Id = A.IdGerente) left join Usuarios as U on(G.IdUsuario = U.Id)" + whereInicio + where.toString());
				ArrayList<PermisosSinGoce> info = new ArrayList<PermisosSinGoce>();
				while(resultados.next()) {
					objeto = new PermisosSinGoce();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setArea(resultados.getString("Area"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setEmpresa(resultados.getString("Empresa"));
					objeto.setFechaIngreso(resultados.getString("FechaIngreso"));
					objeto.setDiasTomar(resultados.getString("DiasTomar"));
					objeto.setFechaDiasTomar(resultados.getString("FechaDiasTomar"));
					objeto.setIdGerente(resultados.getString("NombreGerente"));
					objeto.setAutorizacionGerente(resultados.getString("Gerente"));
					objeto.setAutorizacionRH(resultados.getString("RH"));
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
						eDB.setQuery("insert into PermisosSinGoceApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo from PermisosSinGoce where Id = '" + id[i] + "' and Estatus = 'Solicitud'");
						eDB.setQuery("delete from PermisosSinGoce where Id = '" + id[i] + "' and Estatus = 'Solicitud'");
						resultados = eDB.getQuery("select Nombre from PermisosSinGoce where Id = '" + id[i] + "'");
					}
				}
				objeto = new PermisosSinGoce();
				while(resultados.next()){
					objeto.setNombre(resultados.getString("Nombre"));
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.*, if(A.AutorizacionGerente = '0000-00-00 00:00:00','', A.AutorizacionGerente) as Gerente, if(A.AutorizacionRH = '0000-00-00 00:00:00','', A.AutorizacionRH) as RH from PermisosSinGoce as A where A.Id = '" + request.getParameter("id") + "' and A.Estatus = 'Solicitud'");
				objeto = new PermisosSinGoce();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setArea(resultados.getString("Area"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setEmpresa(resultados.getString("Empresa"));
					objeto.setFechaIngreso(resultados.getString("FechaIngreso"));
					objeto.setDiasTomar(resultados.getString("DiasTomar"));
					objeto.setFechaDiasTomar(resultados.getString("FechaDiasTomar"));
					objeto.setIdGerente(resultados.getString("IdGerente"));
					objeto.setAutorizacionGerente(resultados.getString("Gerente"));
					objeto.setAutorizacionRH(resultados.getString("RH"));
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
				eDB.setQuery("update PermisosSinGoce set Fecha='" + traducciones.getFecha(request.getParameter("Fecha")) + "',Nombre='" + request.getParameter("Nombre") + "',Area='" + request.getParameter("Area") + "',Puesto='" + request.getParameter("Puesto") + "',Empresa='" + request.getParameter("Empresa") + "',FechaIngreso='" + traducciones.getFecha(request.getParameter("FechaIngreso")) + "',DiasTomar='" + traducciones.getEntero(request.getParameter("DiasTomar")) + "',FechaDiasTomar='" + request.getParameter("FechaDiasTomar") + "',IdGerente='" + traducciones.getEntero(request.getParameter("IdGerente")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into PermisosSinGoceApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo from PermisosSinGoce where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new PermisosSinGoce();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setFecha(request.getParameter("Fecha"));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setArea(request.getParameter("Area"));
					objeto.setPuesto(request.getParameter("Puesto"));
					objeto.setEmpresa(request.getParameter("Empresa"));
					objeto.setFechaIngreso(request.getParameter("FechaIngreso"));
					objeto.setDiasTomar(request.getParameter("DiasTomar"));
					objeto.setFechaDiasTomar(request.getParameter("FechaDiasTomar"));
					objeto.setIdGerente(traducciones.getEntero(request.getParameter("IdGerente")));
					objeto.setAutorizacionGerente(request.getParameter("AutorizacionGerente"));
					objeto.setAutorizacionRH(request.getParameter("AutorizacionRH"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getPermisosSinGoce")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from PermisosSinGoce where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<PermisosSinGoce> info = new ArrayList<PermisosSinGoce>();
				while(resultados.next()) {
					objeto = new PermisosSinGoce();
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
				eDB.setQuery("update PermisosSinGoce set AutorizacionGerente = (if(Estatus = 'Cancelado',if(AutorizacionRH = '0000-00-00 00:00:00',AutorizacionGerente,'0000-00-00 00:00:00'),if(Estatus = 'Pendiente',AutorizacionGerente,if(Estatus = 'Autorizado',AutorizacionGerente,now())))), Estatus = (if(Estatus = 'Cancelado','Cancelado',if(Estatus = 'Pendiente',if(AutorizacionRH = '0000-00-00 00:00:00','Pendiente','Autorizado'),if(Estatus = 'Autorizado','Autorizado','Pendiente')))) where Id = '" + request.getParameter("Id") + "'");
				eDB.setQuery("insert into PermisosSinGoceApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo from PermisosSinGoce where Id = '" + request.getParameter("Id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
			}
			else if(request.getParameter("Accion").equals("Autorizacion2")){
				eDB.setConexion();
				eDB.setQuery("update PermisosSinGoce set AutorizacionRH = (if(Estatus = 'Cancelado','0000-00-00 00:00:00',if(Estatus = 'Pendiente',now(),if(Estatus = 'Autorizado',AutorizacionRH,now())))), Estatus = (if(Estatus = 'Cancelado','Cancelado',if(Estatus = 'Pendiente',if(AutorizacionGerente = '0000-00-00 00:00:00','Pendiente','Autorizado'),if(Estatus = 'Autorizado','Autorizado','Pendiente')))) where Id = '" + request.getParameter("Id") + "'");
				eDB.setQuery("insert into PermisosSinGoceApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo from PermisosSinGoce where Id = '" + request.getParameter("Id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
			}
			else if(request.getParameter("Accion").equals("Cancelar")){
				eDB.setConexion();
				if(request.getParameter("Perfil").equals("24")){
					//session de gerentes
					eDB.setQuery("update PermisosSinGoce set Motivo = CONCAT('" + request.getParameter("Motivo") + "',' ',now()), Estatus = 'Cancelado' where Id = '" + request.getParameter("Id") + "' and AutorizacionGerente = '0000-00-00 00:00:00' and Estatus = 'Solicitud'");
					eDB.setQuery("insert into PermisosSinGoceApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo from PermisosSinGoce where Id = '" + request.getParameter("Id") + "'");
				}else if(request.getParameter("Perfil").equals("42")){
					//session de recursos humanos
					eDB.setQuery("update PermisosSinGoce set Motivo = CONCAT('" + request.getParameter("Motivo") + "',' ',now()), Estatus = 'Cancelado' where Id = '" + request.getParameter("Id") + "' and AutorizacionRH = '0000-00-00 00:00:00' and Estatus = 'Pendiente'");
					eDB.setQuery("insert into PermisosSinGoceApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Nombre,Area,Puesto,Empresa,FechaIngreso,DiasTomar,FechaDiasTomar,IdGerente,AutorizacionGerente,AutorizacionRH,Estatus,Motivo from PermisosSinGoce where Id = '" + request.getParameter("Id") + "'");
				}
				resultados = eDB.getQuery("select Estatus from PermisosSinGoce where Id = '" + request.getParameter("Id") + "'");
				objeto = new PermisosSinGoce();
				while(resultados.next()){
					objeto.setEstatus(resultados.getString("Estatus"));
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("AutorizacionGerentes")){
				eDB.setConexion();
				resultados = eDB.getQuery("select U.Nombre as NombreGerente,A.*, if(A.AutorizacionGerente = '0000-00-00 00:00:00','', A.AutorizacionGerente) as Gerente, if(A.AutorizacionRH = '0000-00-00 00:00:00','', A.AutorizacionRH) as RH from PermisosSinGoce as A left join Gerentes as G on(G.Id = A.IdGerente) left join Usuarios as U on(G.IdUsuario = U.Id) where U.Id = '" + session.getAttribute("IdUsuario") + "'");
				ArrayList<PermisosSinGoce> info = new ArrayList<PermisosSinGoce>();
				while(resultados.next()) {
					objeto = new PermisosSinGoce();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setArea(resultados.getString("Area"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setEmpresa(resultados.getString("Empresa"));
					objeto.setFechaIngreso(resultados.getString("FechaIngreso"));
					objeto.setDiasTomar(resultados.getString("DiasTomar"));
					objeto.setFechaDiasTomar(resultados.getString("FechaDiasTomar"));
					objeto.setIdGerente(resultados.getString("IdGerente"));
					objeto.setAutorizacionGerente(resultados.getString("Gerente"));
					objeto.setAutorizacionRH(resultados.getString("RH"));
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
				objeto = new PermisosSinGoce();
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setFechaIngreso(request.getParameter("FechaFin"));
				

				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha >= '" + objeto.getFecha() + "'"); entro = true;}
				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getFechaIngreso().equals("")) { where.append(" and A.Fecha <= '" + objeto.getFechaIngreso() + "'"); entro = true;}
				
				
				//validar que tipo de usuario es con la session
				if(entro) { whereInicio = " where A.Id > 0 and A.Estatus <> 'Solicitud'"; }
				resultados = eDB.getQuery("select U.Nombre as NombreGerente,A.*, if(A.AutorizacionGerente = '0000-00-00 00:00:00','', A.AutorizacionGerente) as Gerente, if(A.AutorizacionRH = '0000-00-00 00:00:00','', A.AutorizacionRH) as RH from PermisosSinGoce as A left join Gerentes as G on(G.Id = A.IdGerente) left join Usuarios as U on(G.IdUsuario = U.Id)" + whereInicio + where.toString());
				ArrayList<PermisosSinGoce> info = new ArrayList<PermisosSinGoce>();
				while(resultados.next()) {
					objeto = new PermisosSinGoce();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setArea(resultados.getString("Area"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setEmpresa(resultados.getString("Empresa"));
					objeto.setFechaIngreso(resultados.getString("FechaIngreso"));
					objeto.setDiasTomar(resultados.getString("DiasTomar"));
					objeto.setFechaDiasTomar(resultados.getString("FechaDiasTomar"));
					objeto.setIdGerente(resultados.getString("NombreGerente"));
					objeto.setAutorizacionGerente(resultados.getString("Gerente"));
					objeto.setAutorizacionRH(resultados.getString("RH"));
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
			objeto = new PermisosSinGoce();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new PermisosSinGoce();
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
	
	private void imprimeJson(HttpServletResponse response, PermisosSinGoce objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<PermisosSinGoce> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(PermisosSinGoce objeto, Exception e) {
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
/* PermisosSinGoceServlet */
