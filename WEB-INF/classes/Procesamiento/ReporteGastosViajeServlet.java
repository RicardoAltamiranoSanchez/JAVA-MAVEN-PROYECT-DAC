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
import Objetos.ReporteGastosViaje;

import com.google.gson.Gson;

public class ReporteGastosViajeServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6554510528473706377L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private ReporteGastosViaje objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public ReporteGastosViajeServlet() {
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
				eDB.setQuery("insert into ReporteGastosViaje (U,G,E,Fecha,Departamento,PeriodoDe,PeriodoA,Estacion,MotivoViaje,Partida,ViaticosEntregados,FacturadoDirectoEmpresa,NetoCargoFavor) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + traducciones.getFecha(request.getParameter("Fecha")) + "','" + request.getParameter("Departamento") + "','" + traducciones.getFecha(request.getParameter("PeriodoDe")) + "','" + traducciones.getFecha(request.getParameter("PeriodoA")) + "','" + request.getParameter("Estacion") + "','" + request.getParameter("MotivoViaje") + "','" + request.getParameter("Partida") + "','" + traducciones.getDecimal(request.getParameter("ViaticosEntregados")) + "','" + traducciones.getDecimal(request.getParameter("FacturadoDirectoEmpresa")) + "','" + traducciones.getDecimal(request.getParameter("NetoCargoFavor")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into ReporteGastosViajeApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Departamento,PeriodoDe,PeriodoA,Estacion,MotivoViaje,Partida,ViaticosEntregados,FacturadoDirectoEmpresa,NetoCargoFavor) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Departamento,PeriodoDe,PeriodoA,Estacion,MotivoViaje,Partida,ViaticosEntregados,FacturadoDirectoEmpresa,NetoCargoFavor from ReporteGastosViaje where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new ReporteGastosViaje();
				objeto.setId(ultimoId);
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setDepartamento(request.getParameter("Departamento"));
				objeto.setPeriodoDe(request.getParameter("PeriodoDe"));
				objeto.setPeriodoA(request.getParameter("PeriodoA"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setMotivoViaje(request.getParameter("MotivoViaje"));
				objeto.setPartida(request.getParameter("Partida"));
				objeto.setViaticosEntregados(request.getParameter("ViaticosEntregados"));
				objeto.setFacturadoDirectoEmpresa(request.getParameter("FacturadoDirectoEmpresa"));
				objeto.setNetoCargoFavor(request.getParameter("NetoCargoFavor"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.U = '" + session.getAttribute("IdUsuario") + "'";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new ReporteGastosViaje();
				//objeto.setFecha(request.getParameter("Fecha"));
				//objeto.setDepartamento(request.getParameter("Departamento"));
				//objeto.setPeriodoDe(request.getParameter("PeriodoDe"));
				//objeto.setPeriodoA(request.getParameter("PeriodoA"));
				//objeto.setEstacion(request.getParameter("Estacion"));
				//objeto.setMotivoViaje(request.getParameter("MotivoViaje"));
				//objeto.setPartida(request.getParameter("Partida"));
				//objeto.setViaticosEntregados(request.getParameter("ViaticosEntregados"));
				//objeto.setFacturadoDirectoEmpresa(request.getParameter("FacturadoDirectoEmpresa"));
				//objeto.setNetoCargoFavor(request.getParameter("NetoCargoFavor"));

				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha like '" + objeto.getFecha() + "%'"); entro = true;}
				if(!objeto.getDepartamento().equals("")) { where.append(" and A.Departamento like '" + objeto.getDepartamento() + "%'"); entro = true;}
				if(!objeto.getPeriodoDe().equals("")) { where.append(" and A.PeriodoDe like '" + objeto.getPeriodoDe() + "%'"); entro = true;}
				if(!objeto.getPeriodoA().equals("")) { where.append(" and A.PeriodoA like '" + objeto.getPeriodoA() + "%'"); entro = true;}
				if(!objeto.getEstacion().equals("")) { where.append(" and A.Estacion like '" + objeto.getEstacion() + "%'"); entro = true;}
				if(!objeto.getMotivoViaje().equals("")) { where.append(" and A.MotivoViaje like '" + objeto.getMotivoViaje() + "%'"); entro = true;}
				if(!objeto.getPartida().equals("")) { where.append(" and A.Partida like '" + objeto.getPartida() + "%'"); entro = true;}
				if(!objeto.getViaticosEntregados().equals("")) { where.append(" and A.ViaticosEntregados like '" + objeto.getViaticosEntregados() + "%'"); entro = true;}
				if(!objeto.getFacturadoDirectoEmpresa().equals("")) { where.append(" and A.FacturadoDirectoEmpresa like '" + objeto.getFacturadoDirectoEmpresa() + "%'"); entro = true;}
				if(!objeto.getNetoCargoFavor().equals("")) { where.append(" and A.NetoCargoFavor like '" + objeto.getNetoCargoFavor() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.U = '" + session.getAttribute("IdUsuario") + "'"; }
				
				resultados = eDB.getQuery("select A.* from ReporteGastosViaje as A" + whereInicio + where.toString());
				ArrayList<ReporteGastosViaje> info = new ArrayList<ReporteGastosViaje>();
				while(resultados.next()) {
					objeto = new ReporteGastosViaje();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setDepartamento(resultados.getString("Departamento"));
					objeto.setPeriodoDe(resultados.getString("PeriodoDe"));
					objeto.setPeriodoA(resultados.getString("PeriodoA"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setMotivoViaje(resultados.getString("MotivoViaje"));
					objeto.setPartida(resultados.getString("Partida"));
					objeto.setViaticosEntregados(resultados.getString("ViaticosEntregados"));
					objeto.setFacturadoDirectoEmpresa(resultados.getString("FacturadoDirectoEmpresa"));
					objeto.setNetoCargoFavor(resultados.getString("NetoCargoFavor"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("BuscarGlobal")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new ReporteGastosViaje();
				objeto.setFecha(request.getParameter("Fecha"));

				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha >= '" + request.getParameter("Fecha") + "' and A.Fecha <= '" + request.getParameter("FechaA") + "'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from ReporteGastosViaje as A" + whereInicio + where.toString());
				ArrayList<ReporteGastosViaje> info = new ArrayList<ReporteGastosViaje>();
				while(resultados.next()) {
					objeto = new ReporteGastosViaje();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setDepartamento(resultados.getString("Departamento"));
					objeto.setPeriodoDe(resultados.getString("PeriodoDe"));
					objeto.setPeriodoA(resultados.getString("PeriodoA"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setMotivoViaje(resultados.getString("MotivoViaje"));
					objeto.setPartida(resultados.getString("Partida"));
					objeto.setViaticosEntregados(resultados.getString("ViaticosEntregados"));
					objeto.setFacturadoDirectoEmpresa(resultados.getString("FacturadoDirectoEmpresa"));
					objeto.setNetoCargoFavor(resultados.getString("NetoCargoFavor"));
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
						eDB.setQuery("insert into ReporteGastosViajeApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,Departamento,PeriodoDe,PeriodoA,Estacion,MotivoViaje,Partida,ViaticosEntregados,FacturadoDirectoEmpresa,NetoCargoFavor) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,Departamento,PeriodoDe,PeriodoA,Estacion,MotivoViaje,Partida,ViaticosEntregados,FacturadoDirectoEmpresa,NetoCargoFavor from ReporteGastosViaje where Id = '" + id[i] + "'");
						eDB.setQuery("delete from ReporteGastosViaje where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new ReporteGastosViaje();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from ReporteGastosViaje as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new ReporteGastosViaje();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setDepartamento(resultados.getString("Departamento"));
					objeto.setPeriodoDe(resultados.getString("PeriodoDe"));
					objeto.setPeriodoA(resultados.getString("PeriodoA"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setMotivoViaje(resultados.getString("MotivoViaje"));
					objeto.setPartida(resultados.getString("Partida"));
					objeto.setViaticosEntregados(resultados.getString("ViaticosEntregados"));
					objeto.setFacturadoDirectoEmpresa(resultados.getString("FacturadoDirectoEmpresa"));
					objeto.setNetoCargoFavor(resultados.getString("NetoCargoFavor"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update ReporteGastosViaje set Fecha='" + traducciones.getFecha(request.getParameter("Fecha")) + "',Departamento='" + request.getParameter("Departamento") + "',PeriodoDe='" + traducciones.getFecha(request.getParameter("PeriodoDe")) + "',PeriodoA='" + traducciones.getFecha(request.getParameter("PeriodoA")) + "',Estacion='" + request.getParameter("Estacion") + "',MotivoViaje='" + request.getParameter("MotivoViaje") + "',Partida='" + request.getParameter("Partida") + "',ViaticosEntregados='" + traducciones.getDecimal(request.getParameter("ViaticosEntregados")) + "',FacturadoDirectoEmpresa='" + traducciones.getDecimal(request.getParameter("FacturadoDirectoEmpresa")) + 
						"',NetoCargoFavor=(select sum(GastosComprobados) from ReporteGastosViajeDetalle where IdReporteGastosViaje = '" + request.getParameter("id") + "' group by IdReporteGastosViaje) - ViaticosEntregados - FacturadoDirectoEmpresa " +  
						"where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into ReporteGastosViajeApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Departamento,PeriodoDe,PeriodoA,Estacion,MotivoViaje,Partida,ViaticosEntregados,FacturadoDirectoEmpresa,NetoCargoFavor) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Departamento,PeriodoDe,PeriodoA,Estacion,MotivoViaje,Partida,ViaticosEntregados,FacturadoDirectoEmpresa,NetoCargoFavor from ReporteGastosViaje where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new ReporteGastosViaje();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setFecha(request.getParameter("Fecha"));
					objeto.setDepartamento(request.getParameter("Departamento"));
					objeto.setPeriodoDe(request.getParameter("PeriodoDe"));
					objeto.setPeriodoA(request.getParameter("PeriodoA"));
					objeto.setEstacion(request.getParameter("Estacion"));
					objeto.setMotivoViaje(request.getParameter("MotivoViaje"));
					objeto.setPartida(request.getParameter("Partida"));
					objeto.setViaticosEntregados(request.getParameter("ViaticosEntregados"));
					objeto.setFacturadoDirectoEmpresa(request.getParameter("FacturadoDirectoEmpresa"));
					objeto.setNetoCargoFavor(request.getParameter("NetoCargoFavor"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getReporteGastosViaje")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from ReporteGastosViaje where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<ReporteGastosViaje> info = new ArrayList<ReporteGastosViaje>();
				while(resultados.next()) {
					objeto = new ReporteGastosViaje();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new ReporteGastosViaje();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new ReporteGastosViaje();
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
	
	private void imprimeJson(HttpServletResponse response, ReporteGastosViaje objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<ReporteGastosViaje> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(ReporteGastosViaje objeto, Exception e) {
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
/* ReporteGastosViajeServlet */
