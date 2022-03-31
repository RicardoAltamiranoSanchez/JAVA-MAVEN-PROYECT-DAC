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
import Libreria.CorreosElectronicos;
import Libreria.MysqlPool;
import Utilerias.Fechas;
import Utilerias.TraduccionesSQL;
import Objetos.Vacaciones;
import Objetos.InformacionVacaciones;

import com.google.gson.Gson;

public class PermisosServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5528342110803458203L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private ResultSet resultados2;
	private int ultimoId;
	private Vacaciones objeto;
	private InformacionVacaciones informacion;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public PermisosServlet() {
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
				eDB.setQuery("insert into Vacaciones (U,G,E,IdUsuario,FechaSolicitud,Gerente,Jefe,Llave,Tipo) values ('" + 
						session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + 
						session.getAttribute("IdUsuario") + "','" + traducciones.getFecha(request.getParameter("FechaSolicitud")) + "','" + 
						traducciones.getEntero(request.getParameter("Gerente")) + "','" + 
						traducciones.getEntero(request.getParameter("Jefe")) + "','" + request.getParameter("Llave") + "','DIAS SIN GOCE')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into VacacionesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave,Tipo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave,Tipo from Vacaciones where Id = '" + ultimoId + "'");
				
				
				objeto = new Vacaciones();
				objeto.setId(ultimoId);
				objeto.setIdUsuario(request.getParameter("IdUsuario"));
				objeto.setFechaSolicitud(request.getParameter("FechaSolicitud"));
				objeto.setEstatus(request.getParameter("Estatus"));
				objeto.setGerente(request.getParameter("Gerente"));
				objeto.setJefe(request.getParameter("Jefe"));
				objeto.setLlave(request.getParameter("Llave"));
				
				imprimeJson(response,objeto);
				
				CorreosElectronicos email = new CorreosElectronicos();
				email.correoSolicitudVacaciones(eDB, "" + ultimoId);
				
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
			}
			else if(request.getParameter("Accion").equals("GuardarDias")) {
				eDB.setConexion();
				eDB.setQuery("insert into Vacaciones (U,G,E,IdUsuario,FechaSolicitud,Gerente,Jefe,Llave,Tipo) values ('" + 
						session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + 
						session.getAttribute("IdUsuario") + "','" + traducciones.getFecha(request.getParameter("FechaSolicitud")) + "','" + 
						traducciones.getEntero(request.getParameter("Gerente")) + "','" + 
						traducciones.getEntero(request.getParameter("Jefe")) + "','" + request.getParameter("Llave") + "','DIAS SIN GOCE')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into VacacionesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave,Tipo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave,Tipo from Vacaciones where Id = '" + ultimoId + "'");
				
				objeto = new Vacaciones();
				objeto.setId(ultimoId);
				objeto.setIdUsuario(request.getParameter("IdUsuario"));
				objeto.setFechaSolicitud(request.getParameter("FechaSolicitud"));
				objeto.setEstatus(request.getParameter("Estatus"));
				objeto.setGerente(request.getParameter("Gerente"));
				objeto.setJefe(request.getParameter("Jefe"));
				objeto.setLlave(request.getParameter("Llave"));
				
				imprimeJson(response,objeto);
				
				CorreosElectronicos email = new CorreosElectronicos();
				email.correoSolicitudVacaciones(eDB, "" + ultimoId);
				
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id > 0 and A.Tipo = 'DIAS SIN GOCE' and U.Id = A.IdUsuario and (Gerente = '" + session.getAttribute("IdUsuario") + "' or Jefe = '" + session.getAttribute("IdUsuario") + "') ";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Vacaciones();
				objeto.setIdUsuario(session.getAttribute("IdUsuario").toString());
				objeto.setFechaSolicitud(request.getParameter("FechaSolicitud"));
				objeto.setEstatus(request.getParameter("Estatus"));
				objeto.setGerente(request.getParameter("Gerente"));
				objeto.setJefe(request.getParameter("Jefe"));
				objeto.setLlave(request.getParameter("Llave"));

				/*if(!objeto.getIdUsuario().equals("")) { where.append(" and A.IdUsuario like '" + objeto.getIdUsuario() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0 and U.Id = A.IdUsuario"; }*/
				
				resultados = eDB.getQuery("select A.*, U.Nombre, (select group_concat(Dias) from VacacionesDias where IdUsuario = A.IdUsuario and Llave = A.Llave) as Dias from Vacaciones as A, Usuarios as U" + whereInicio + where.toString());
				ArrayList<Vacaciones> info = new ArrayList<Vacaciones>();
				while(resultados.next()) {
					objeto = new Vacaciones();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("Nombre"));
					objeto.setFechaSolicitud(resultados.getString("FechaSolicitud"));
					objeto.setEstatus(resultados.getString("Estatus"));
					objeto.setGerente(resultados.getString("Gerente"));
					objeto.setJefe(resultados.getString("Jefe"));
					objeto.setLlave(resultados.getString("Dias"));
					objeto.setTipo(resultados.getString("Tipo"));
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
						//query donde actualiza el estatus
						eDB.setQuery("update Vacaciones set Estatus = '" + request.getParameter("Tipo") + "' where Id = '" + id[i] + "'");
						eDB.setQuery("insert into VacacionesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave,Tipo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave,Tipo from Vacaciones where Id = '" + id[i] + "'");
						
						if(request.getParameter("Tipo").equals("Rechazado")){
							//query para aumentar los dias cuando se rechazan
							CorreosElectronicos email = new CorreosElectronicos();
							email.correoRechazoVacaciones(eDB, "" + id[i]);
						} else {
							CorreosElectronicos email = new CorreosElectronicos();
							email.correoAutorizacionVacaciones(eDB, "" + id[i]);
						}
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Vacaciones();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getVacaciones")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from Vacaciones where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<Vacaciones> info = new ArrayList<Vacaciones>();
				while(resultados.next()) {
					objeto = new Vacaciones();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("ConsultarSolicitudesVacaciones")) {
				/*" ",
					"SOLICITUDES PENDIENTES DE AUTORIZAR: ",
					"SOLICITUDES AUTORIZADAS: ",
					"SOLICITUDES RECHAZADAS: "
					*/
				eDB.setConexion();
				informacion = new InformacionVacaciones();
				//query que calcula las solicitudes pendientes
				resultados = eDB.getQuery("select count(*) as Pendiente from Vacaciones where Tipo = 'DIAS SIN GOCE' and Estatus = 'Pendiente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()) {
					informacion.setSolicitudesPendientes(resultados.getString("Pendiente"));
				}
				//System.out.println("select count(*) as Pendiente from Vacaciones where Tipo = 'DIAS SIN GOCE' Estatus = 'Pendiente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				//query que calcula las solicitudes rechazadas
				resultados = eDB.getQuery("select count(*) as Rechazado from Vacaciones where Tipo = 'DIAS SIN GOCE' and Estatus = 'Rechazado' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()){
					informacion.setSolicitudesRechazadas(resultados.getString("Rechazado"));
				}
				//System.out.println("select count(*) as Rechazado from Vacaciones where Tipo = 'DIAS SIN GOCE' Estatus = 'Rechazado' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				//query que calcula las solicitudes aceptadas
				//resultados = eDB.getQuery("select count(*) as Aceptado from Vacaciones where Tipo = 'DIAS SIN GOCE' and Estatus = 'AutorizadoGerente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				resultados = eDB.getQuery("select count(*) as Aceptado from Vacaciones where Tipo = 'DIAS SIN GOCE' and Estatus = 'Autorizado' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()){
					informacion.setSolicitudesAutorizadas(resultados.getString("Aceptado"));
				}
				//System.out.println("select count(*) as Aceptado from Vacaciones where Estatus = 'AutorizadoGerente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				//query que calcula las cuando es tu fecha limite para las vacaciones
				resultados = eDB.getQuery("select ADDDATE(FechaIngreso,INTERVAL (TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE())+1) YEAR) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()){
					informacion.setVencimiento(resultados.getString("Limite"));
				}
				//System.out.println("select ADDDATE(FechaIngreso,INTERVAL (TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE())+1) YEAR) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				//query que calcula los dias solicitados (pedidos con estatus aceptado)
				//resultados = eDB.getQuery("select count(*) as DiasSolicitados from VacacionesDias as D, Vacaciones as V where V.Tipo = 'DIAS SIN GOCE' and V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and V.Estatus = 'AutorizadoGerente'");
				resultados = eDB.getQuery("select count(*) as DiasSolicitados from VacacionesDias as D, Vacaciones as V where V.Tipo = 'DIAS SIN GOCE' and V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and V.Estatus = 'Autorizado'");
				while(resultados.next()) {
					informacion.setDiasSolicitados(resultados.getString("DiasSolicitados"));
				}
				//System.out.println("select count(*) as DiasSolicitados from VacacionesDias as D, Vacaciones as V where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and V.Estatus = 'AutorizadoGerente'");
				//query que calcula los dias totales del empleado
				resultados = eDB.getQuery("select sum(EV.DiasLey+EV.DiasExtra) as Total,EV.Ao from Empleados as E left join EmpresasGrupo as EG on(E.Division = EG.Id) left join EmpresasVacaciones as EV on(EV.IdEmpresasGrupo = EG.Id) where E.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and EV.Ao = (select TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE()) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "')");
				while(resultados.next()) {
					try{
						if(!resultados.getString("Total").equals("null"))
							informacion.setDiasTotales(resultados.getString("Total"));
					}catch(NullPointerException e){
						informacion.setDiasTotales("0");
					}
				}
				//System.out.println("select sum(EV.DiasLey+EV.DiasExtra) as Total,EV.Ao from Empleados as E left join EmpresasGrupo as EG on(E.Division = EG.Id) left join EmpresasVacaciones as EV on(EV.IdEmpresasGrupo = EG.Id) where E.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and EV.Ao = (select TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE()) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "')");
				//calcula los dias por disfrutar (dias pendientes)
				informacion.setDiasDisfrutar(String.valueOf(Integer.parseInt(informacion.getDiasTotales()) - Integer.parseInt(informacion.getDiasSolicitados())));
				//System.out.println(String.valueOf(Integer.parseInt(informacion.getDiasTotales()) - Integer.parseInt(informacion.getDiasSolicitados())));
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,informacion);
			}
			else if(request.getParameter("Accion").equals("ReporteVacaciones")){
				//variable que contiene todas las fechas
				String fechas = "";
				eDB.setConexion();
				ArrayList<InformacionVacaciones> info = new ArrayList<InformacionVacaciones>();
				//query que calcula los dias solicitados (pedidos con estatus aceptado)
				String where = "";
				if(request.getParameter("FechaInicio") != ""){
					where = " and D.Dias >= '" + request.getParameter("FechaInicio") + "'";
				}
				if(request.getParameter("FechaFin") != ""){
					where += " and D.Dias <= '" + request.getParameter("FechaFin") + "'";
				}
				if(request.getParameter("IdEmpleado") != ""){
					where += " and E.Id = '" + request.getParameter("IdEmpleado") + "'";
				}
				
				// ANTES DIVISION String query = "select count(*) as DiasSolicitados,E.NombreCompleto,V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Usuarios as U left join Empleados as E on(U.Id = E.IdUsuario) where V.Tipo = 'DIAS SIN GOCE' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and U.Id = V.IdUsuario " + where + " group by V.IdUsuario";
				//String query = "select count(*) as DiasSolicitados,E.NombreCompleto, EG.Admon as Admon, V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Usuarios as U left join Empleados as E on(U.Id = E.IdUsuario) left join EmpresasGrupo as EG on (EG.Id = E.Division) where V.Tipo = 'DIAS SIN GOCE' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and U.Id = V.IdUsuario and EG.Admon =(select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '"+session.getAttribute("IdUsuario")+"'))" + where + " group by V.IdUsuario";
				String query = "select count(*) as DiasSolicitados,E.NombreCompleto, EG.Admon as Admon, V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Usuarios as U left join Empleados as E on(U.Id = E.IdUsuario) left join EmpresasGrupo as EG on (EG.Id = E.Division) where V.Tipo = 'DIAS SIN GOCE' and V.Llave = D.Llave and V.Estatus = 'Autorizado' and U.Id = V.IdUsuario and EG.Admon =(select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '"+session.getAttribute("IdUsuario")+"'))" + where + " group by V.IdUsuario";
				
				//System.out.println(query);
				resultados = eDB.getQuery(query);
				
				int i=0;
				
				while(resultados.next()) {
					informacion = new InformacionVacaciones();
					informacion.setDiasSolicitados(resultados.getString("DiasSolicitados"));
					informacion.setNombre(resultados.getString("NombreCompleto"));
					
					while (i==0){
						System.out.println("Los Empleados considerados en el Reporte de Permisos son de "+resultados.getString("Admon"));
						i++;
					}
					
					//query para obtener las fechas de vacaciones
					//String query2 = "select D.Dias from VacacionesDias as D, Vacaciones as V left join Empleados as E on(V.IdUsuario = E.IdUsuario) where V.Tipo = 'DIAS SIN GOCE' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "'" + where + "";
					String query2 = "select D.Dias from VacacionesDias as D, Vacaciones as V left join Empleados as E on(V.IdUsuario = E.IdUsuario) where V.Tipo = 'DIAS SIN GOCE' and V.Llave = D.Llave and V.Estatus = 'Autorizado' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "'" + where + "";
					//System.out.println(query2);
					resultados2 = eDB.getQuery(query2);
					while(resultados2.next()){
						fechas += resultados2.getString("Dias") + "  ";
					}
					informacion.setFechasVacaciones(fechas);
					info.add(informacion);
					fechas = "";
				}

				eDB.setCerrar(resultados);
				eDB.setCerrar(resultados2);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info,0);
			}
			else if(request.getParameter("Accion").equals("ReporteVacacionesGerente")){
				//variable que contiene todas las fechas
				String fechas = "";
				eDB.setConexion();
				ArrayList<InformacionVacaciones> info = new ArrayList<InformacionVacaciones>();
				//query que calcula los dias solicitados (pedidos con estatus aceptado)
				//resultados = eDB.getQuery("select count(*) as DiasSolicitados,P.NombreCompleto,V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Empleados as P where V.Tipo = 'DIAS SIN GOCE' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and P.IdUsuario = V.IdUsuario and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "' group by V.IdUsuario");
				resultados = eDB.getQuery("select count(*) as DiasSolicitados,P.NombreCompleto,V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Empleados as P where V.Tipo = 'DIAS SIN GOCE' and V.Llave = D.Llave and V.Estatus = 'Autorizado' and P.IdUsuario = V.IdUsuario and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "' group by V.IdUsuario");
				//System.out.println("select count(*) as DiasSolicitados,P.NombreCompleto,V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Empleados as P where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and P.IdUsuario = V.IdUsuario and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "' group by V.IdUsuario");
				while(resultados.next()) {
					informacion = new InformacionVacaciones();
					informacion.setDiasSolicitados(resultados.getString("DiasSolicitados"));
					informacion.setNombre(resultados.getString("NombreCompleto"));
					//query para obtener las fechas de vacaciones
					//resultados2 = eDB.getQuery("select D.Dias from VacacionesDias as D, Vacaciones as V where V.Tipo = 'DIAS SIN GOCE' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "' and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "'");
					resultados2 = eDB.getQuery("select D.Dias from VacacionesDias as D, Vacaciones as V where V.Tipo = 'DIAS SIN GOCE' and V.Llave = D.Llave and V.Estatus = 'Autorizado' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "' and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "'");
					//System.out.println("select D.Dias from VacacionesDias as D, Vacaciones as V where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "' and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "'");
					while(resultados2.next()){
						fechas += resultados2.getString("Dias") + "  ";
					}
					informacion.setFechasVacaciones(fechas);
					info.add(informacion);
					fechas = "";
				}

				eDB.setCerrar(resultados);
				eDB.setCerrar(resultados2);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info,0);
			}
		} catch(SQLException e) {
			objeto = new Vacaciones();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Vacaciones();
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
	
	private void imprimeJson(HttpServletResponse response, InformacionVacaciones objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, Vacaciones objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Vacaciones> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<InformacionVacaciones> objeto, int dato) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Vacaciones objeto, Exception e) {
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
/* VacacionesServlet */
