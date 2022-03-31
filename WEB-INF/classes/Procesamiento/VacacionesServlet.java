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
import Libreria.CorreosElectronicosHtml;
import Libreria.MysqlPool;
import Utilerias.Fechas;
import Utilerias.TraduccionesSQL;
import Objetos.Vacaciones;
import Objetos.InformacionVacaciones;

import com.google.gson.Gson;

public class VacacionesServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5528342110803458203L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private ResultSet resultados2, resultados3;
	private int ultimoId;
	private Vacaciones objeto;
	private InformacionVacaciones informacion;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public VacacionesServlet() {
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
				eDB.setQuery("insert into Vacaciones (U,G,E,IdUsuario,FechaSolicitud,Gerente,Jefe,Llave) values ('" + 
						session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + 
						session.getAttribute("IdUsuario") + "','" + traducciones.getFecha(request.getParameter("FechaSolicitud")) + "','" + 
						traducciones.getEntero(request.getParameter("Gerente")) + "','" + 
						traducciones.getEntero(request.getParameter("Jefe")) + "','" + request.getParameter("Llave") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into VacacionesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave from Vacaciones where Id = '" + ultimoId + "'");
				
				
				objeto = new Vacaciones();
				objeto.setId(ultimoId);
				objeto.setIdUsuario(request.getParameter("IdUsuario"));
				objeto.setFechaSolicitud(request.getParameter("FechaSolicitud"));
				objeto.setEstatus(request.getParameter("Estatus"));
				objeto.setGerente(request.getParameter("Gerente"));
				objeto.setJefe(request.getParameter("Jefe"));
				objeto.setLlave(request.getParameter("Llave"));
				
				imprimeJson(response,objeto);
				
				CorreosElectronicosHtml email = new CorreosElectronicosHtml();
				email.correoSolicitudVacaciones(eDB, "" + ultimoId);
				//BLOQUEO TEMPORAL CorreosElectronicos email = new CorreosElectronicos();
				//BLOQUEO TEMPORAL email.correoSolicitudVacaciones(eDB, "" + ultimoId);
				
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
				eDB.setQuery("insert into VacacionesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave from Vacaciones where Id = '" + ultimoId + "'");
				
				objeto = new Vacaciones();
				objeto.setId(ultimoId);
				objeto.setIdUsuario(request.getParameter("IdUsuario"));
				objeto.setFechaSolicitud(request.getParameter("FechaSolicitud"));
				objeto.setEstatus(request.getParameter("Estatus"));
				objeto.setGerente(request.getParameter("Gerente"));
				objeto.setJefe(request.getParameter("Jefe"));
				objeto.setLlave(request.getParameter("Llave"));
				
				imprimeJson(response,objeto);
				
				CorreosElectronicosHtml email = new CorreosElectronicosHtml();
				email.correoSolicitudVacaciones(eDB, "" + ultimoId);
				//BLOQUEO TEMPORAL CorreosElectronicos email = new CorreosElectronicos();
				//BLOQUEO TEMPORAL email.correoSolicitudVacaciones(eDB, "" + ultimoId);
				
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id > 0 and U.Id = A.IdUsuario and (Gerente = '" + session.getAttribute("IdUsuario") + "' or Jefe = '" + session.getAttribute("IdUsuario") + "') ";
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
				
				//resultados = eDB.getQuery("select A.*,if(A.FechaSolicitud = '0000-00-00',0,A.FechaSolicitud) as Fecha, U.Nombre, (select group_concat(Dias) from VacacionesDias where IdUsuario = A.IdUsuario and Llave = A.Llave) as Dias from Vacaciones as A, Usuarios as U" + whereInicio + where.toString());
				
//				resultados = eDB.getQuery("select A.*,if(A.FechaSolicitud = '0000-00-00',0,A.FechaSolicitud) as Fecha, U.Nombre, "
//						+ "((select group_concat(Dias) from VacacionesDias where IdUsuario = A.IdUsuario and Llave = A.Llave) union (select group_concat(Dias) from VacacionesDiasRechazados where IdUsuario = A.IdUsuario and Llave = A.Llave)) as Dias "
//						+ "from Vacaciones as A, Usuarios as U" + whereInicio + where.toString());
				
				resultados = eDB.getQuery("select A.*,if(A.FechaSolicitud = '0000-00-00',0,A.FechaSolicitud) as Fecha, U.Nombre, if(@1:=(select group_concat(Dias) from VacacionesDias where IdUsuario = A.IdUsuario and Llave = A.Llave) is null,(select group_concat(Dias) from VacacionesDiasRechazados where IdUsuario = A.IdUsuario and Llave = A.Llave),(select group_concat(Dias) from VacacionesDias where IdUsuario = A.IdUsuario and Llave = A.Llave)) as Dias from Vacaciones as A, Usuarios as U" + whereInicio + where.toString());
				
				ArrayList<Vacaciones> info = new ArrayList<Vacaciones>();
				while(resultados.next()) {
					objeto = new Vacaciones();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("Nombre"));
					objeto.setFechaSolicitud(resultados.getString("Fecha"));
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
				resultados = eDB.getQuery("SELECT VacacionesDias.Id from VacacionesDias INNER JOIN Vacaciones ON VacacionesDias.Llave = Vacaciones.Llave where Vacaciones.Id = '" + request.getParameter("Ids") + "'");
				resultados2 = eDB.getQuery("select * from VacacionesDias where Llave = (select Llave from Vacaciones where Id = '" + request.getParameter("Ids") + "')");
				int devolver = 0;
				resultados2.last();
				devolver = resultados2.getRow();
				
				
				// DEBUG System.out.println("Días "+devolver);
				String ids = request.getParameter("Ids");
				String[] id = ids.split(",");
				for(int i = 0; i < id.length; i++) {
					if(!id[i].equals("")) {
						//query donde actualiza el estatus
						eDB.setQuery("update Vacaciones set Estatus = '" + request.getParameter("Tipo") + "' where Id = '" + id[i] + "'");
						eDB.setQuery("insert into VacacionesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdUsuario,FechaSolicitud,Estatus,Gerente,Jefe,Llave from Vacaciones where Id = '" + id[i] + "'");
						
						if(request.getParameter("Tipo").equals("Rechazado")){
							// Valida no incrementar días cuando son sin goce
							resultados3 = eDB.getQuery("select VacacionesDias.Tipo from VacacionesDias INNER JOIN Vacaciones ON VacacionesDias.Llave = Vacaciones.Llave where Vacaciones.Id = '" + id[i] + "'");
							resultados3.next(); // Avanca a la primer Casilla y está validando con cada incremento el día seleccionado
							String Categoria = resultados3.getString("VacacionesDias.Tipo");
							// DEBUG System.out.println(Categoria);
							if(Categoria.equals("VACACIONES")){
								//query para aumentar los dias cuando se rechazan
								for (int i2 = 0; i2 < devolver; i2++){
									eDB.setQuery("UPDATE Empleados INNER JOIN Vacaciones ON Empleados.IdUsuario = Vacaciones.IdUsuario set Empleados.Vacaciones = (Vacaciones+1) where Vacaciones.Id ='" + request.getParameter("Ids") + "'");
								}
							}
							eDB.setQuery("insert into VacacionesDiasRechazados select * from VacacionesDias where Llave = (select Llave from Vacaciones where Id = '" + id[i] + "')");
							eDB.setQuery("delete from VacacionesDias where Llave = (select Llave from Vacaciones where Id = '" + id[i] + "')");
							eDB.setQuery("insert into VacacionesDiasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdUsuario,Dias,Llave) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdUsuario,Dias,Llave from VacacionesDias where Id = '" + id[i] + "'");
							CorreosElectronicosHtml email = new CorreosElectronicosHtml();
							email.correoRechazoVacaciones(eDB, "" + id[i]);
							//BLOQUEO TEMPORAL CorreosElectronicos email = new CorreosElectronicos();
							//BLOQUEO TEMPORAL email.correoRechazoVacaciones(eDB, "" + id[i]);
						} else {
							CorreosElectronicosHtml email = new CorreosElectronicosHtml();
							email.correoAutorizacionVacaciones(eDB, "" + id[i]);
							//BLOQUEO TEMPORAL CorreosElectronicos email = new CorreosElectronicos();
							//BLOQUEO TEMPORAL email.correoAutorizacionVacaciones(eDB, "" + id[i]);
						}
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Vacaciones();
				imprimeJson(response,objeto);
				devolver = 0;
			}
			else if(request.getParameter("Accion").equals("Anular")) {
				eDB.setConexion();
				
				resultados = eDB.getQuery("select " + 
						"	V.*, " + 
						"'" + session.getAttribute("IdUsuario") + "' as QuienAnuloId, "+
//					    "(select NombreCompleto from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "' and Estatus = 'ACTIVO') QuienAnuloNombre, "+
						"(select Nombre from Usuarios where Id = '" + session.getAttribute("IdUsuario") + "') QuienAnuloNombre, "+
						"now() as Cuando, "+
						"    (select NombreCompleto from Empleados where IdUsuario = V.IdUsuario) SolicitanteNombre, " + 
						"    (select group_concat(Dias) as Dias from VacacionesDias where Llave = V.Llave) DiasAnulados " + 
						"		from " + 
						"			Vacaciones as V " + 
						"				where V.Llave = '" + request.getParameter("Llave") + "'");
				
				String quienAnuloId = "";
				String quienAnuloNombre = "";
				String cuando = "";
				String solicitanteId = "";
				String solicitanteNombre = "";
				String fechaSolicitud = "";
				String tipo = "";
				String estatus = "";
				String diasAnulados = "";
				String llave = "";
				
				
				while(resultados.next()) {
					quienAnuloId = resultados.getString("QuienAnuloId");
					quienAnuloNombre = resultados.getString("QuienAnuloNombre");
					cuando = resultados.getString("Cuando");
					solicitanteId = resultados.getString("IdUsuario");
					solicitanteNombre = resultados.getString("SolicitanteNombre");
					fechaSolicitud = resultados.getString("FechaSolicitud");
					tipo = resultados.getString("Tipo");
					estatus = resultados.getString("Estatus");
					diasAnulados = resultados.getString("DiasAnulados");
					llave = resultados.getString("Llave");
				}
				
				
				
				eDB.setQuery("insert into VacacionesAnuladas (QuienAnuloId,QuienAnuloNombre,Cuando,SolicitanteId,SolicitanteNombre,FechaSolicitud,Tipo,Estatus,DiasAnulados,Llave) values ('" + 
						quienAnuloId + "','" + quienAnuloNombre + "','" + cuando + "','" + 
						solicitanteId + "','" + solicitanteNombre + "','" + 
						fechaSolicitud + "','" +
						tipo + "','" +
						estatus + "','" + diasAnulados + "','" + llave + "')");
				
				
				
				
				resultados = eDB.getQuery("SELECT count(Dias) as CantidadDias FROM VacacionesDias where Llave = '" + request.getParameter("Llave") + "'");
				
				int cantidadDias = 0;
				
				while(resultados.next()) {
					cantidadDias = Integer.parseInt(resultados.getString("CantidadDias"));
				}
				
				//DEBUGSystem.out.println("Dias a Sumar de Vacaciones "+ cantidadDias);
				
				
				eDB.setQuery("Update Empleados set Vacaciones = Vacaciones +"+cantidadDias+" where IdUsuario = '"+solicitanteId+"' and Estatus = 'ACTIVO'");
				
				eDB.setQuery("Delete from Vacaciones where Llave = '"+llave+"'");
				eDB.setQuery("Delete from VacacionesDias where Llave = '"+llave+"'");
				
				
				
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
				System.out.println("select count(*) as Pendiente from Vacaciones where Estatus = 'Pendiente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				resultados = eDB.getQuery("select count(*) as Pendiente from Vacaciones where Estatus = 'Pendiente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()) {
					informacion.setSolicitudesPendientes(resultados.getString("Pendiente"));
				}
				
				//query que calcula las solicitudes rechazadas
				System.out.println("select count(*) as Rechazado from Vacaciones where Estatus = 'Rechazado' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				resultados = eDB.getQuery("select count(*) as Rechazado from Vacaciones where Estatus = 'Rechazado' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()){
					informacion.setSolicitudesRechazadas(resultados.getString("Rechazado"));
				}
				
				//query que calcula las solicitudes aceptadas
				//System.out.println("select count(*) as Aceptado from Vacaciones where Estatus = 'AutorizadoGerente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				System.out.println("select count(*) as Aceptado from Vacaciones where Estatus = 'Autorizado' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				//resultados = eDB.getQuery("select count(*) as Aceptado from Vacaciones where Estatus = 'AutorizadoGerente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				resultados = eDB.getQuery("select count(*) as Aceptado from Vacaciones where Estatus = 'Autorizado' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()){
					informacion.setSolicitudesAutorizadas(resultados.getString("Aceptado"));
				}
				
				//query que calcula las cuando es tu fecha limite para las vacaciones
				System.out.println("select ADDDATE(FechaIngreso,INTERVAL (TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE())+1) YEAR) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				resultados = eDB.getQuery("select ADDDATE(FechaIngreso,INTERVAL (TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE())+1) YEAR) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()){
					informacion.setVencimiento(resultados.getString("Limite"));
				}
				
				//query que calcula los dias solicitados (pedidos con estatus aceptado)
				informacion.setDiasDisfrutar("0");
				System.out.println("select Vacaciones from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				resultados = eDB.getQuery("select Vacaciones from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				//SE COMENTA PORQUE LA SUMA DA NÚMEROS NEGATIVOS EN DÍAS QUE HAS SOLICITADO
				//resultados = eDB.getQuery("select SUM(Vacaciones + NoDisfrutadosPeriodoAnterior) as Vacaciones from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()) {
					informacion.setDiasDisfrutar(resultados.getString("Vacaciones"));
				}
				
				//query que calcula los dias totales del empleado
				System.out.println("select sum(EV.DiasLey+EV.DiasExtra) as Total,EV.Ao from Empleados as E left join EmpresasGrupo as EG on(E.Division = EG.Id) left join EmpresasVacaciones as EV on(EV.IdEmpresasGrupo = EG.Id) where E.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and EV.Ao = (select TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE()) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "' and Estatus = 'ACTIVO') and E.Estatus = 'ACTIVO'");
				resultados = eDB.getQuery("select sum(EV.DiasLey+EV.DiasExtra) as Total,EV.Ao from Empleados as E left join EmpresasGrupo as EG on(E.Division = EG.Id) left join EmpresasVacaciones as EV on(EV.IdEmpresasGrupo = EG.Id) where E.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and EV.Ao = (select TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE()) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "' and Estatus = 'ACTIVO') and E.Estatus = 'ACTIVO'");
				//SE COMENTA PORQUE ALTERA LA CANTIDAD DE DÍAS TOTAL DEL AÑO
				//resultados = eDB.getQuery("select sum(EV.DiasLey+EV.DiasExtra+ E.NoDisfrutadosPeriodoAnterior) as Total,EV.Ao from Empleados as E left join EmpresasGrupo as EG on(E.Division = EG.Id) left join EmpresasVacaciones as EV on(EV.IdEmpresasGrupo = EG.Id) where E.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and EV.Ao = (select TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE()) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "' and Estatus = 'ACTIVO') and E.Estatus = 'ACTIVO'");
				while(resultados.next()) {
					try{
						if(!resultados.getString("Total").equals("null"))
							informacion.setDiasTotales(resultados.getString("Total"));
					}catch(NullPointerException e){
						informacion.setDiasTotales("0");
					}
				}
				
				//calcula los dias por disfrutar (dias pendientes)
				informacion.setDiasSolicitados(String.valueOf(Integer.parseInt(informacion.getDiasTotales()) - Integer.parseInt(informacion.getDiasDisfrutar())));
				
				//query donde se obtienen los dias que han sido solicitados
				//System.out.println("select ifnull(group_concat(D.Dias),0) as Dias from Vacaciones as V left join VacacionesDias as D on(V.Llave = D.Llave) where D.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and D.Dias < '" + informacion.getVencimiento() + "' and D.Dias > (select ADDDATE('" + informacion.getVencimiento() + "',INTERVAL (TIMESTAMPDIFF(YEAR, '" + informacion.getVencimiento() + "', CURDATE())-1) YEAR)) and (V.Estatus = 'AutorizadoSupervisor' or V.Estatus = 'AutorizadoGerente') and V.IdUsuario = '" + session.getAttribute("IdUsuario") + "' order by D.Dias");
				System.out.println("select ifnull(group_concat(D.Dias),0) as Dias from Vacaciones as V left join VacacionesDias as D on(V.Llave = D.Llave) where D.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and D.Dias < '" + informacion.getVencimiento() + "' and D.Dias > (select ADDDATE('" + informacion.getVencimiento() + "',INTERVAL (TIMESTAMPDIFF(YEAR, '" + informacion.getVencimiento() + "', CURDATE())-1) YEAR)) and (V.Estatus = 'AutorizadoSupervisor' or V.Estatus = 'Autorizado') and V.IdUsuario = '" + session.getAttribute("IdUsuario") + "' order by D.Dias");
				//resultados = eDB.getQuery("select ifnull(group_concat(D.Dias),0) as Dias from Vacaciones as V left join VacacionesDias as D on(V.Llave = D.Llave) where D.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and D.Dias < '" + informacion.getVencimiento() + "' and D.Dias > (select ADDDATE('" + informacion.getVencimiento() + "',INTERVAL (TIMESTAMPDIFF(YEAR, '" + informacion.getVencimiento() + "', CURDATE())-1) YEAR)) and (V.Estatus = 'AutorizadoSupervisor' or V.Estatus = 'AutorizadoGerente') and V.IdUsuario = '" + session.getAttribute("IdUsuario") + "' order by D.Dias");
				resultados = eDB.getQuery("select ifnull(group_concat(D.Dias),0) as Dias from Vacaciones as V left join VacacionesDias as D on(V.Llave = D.Llave) where D.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and D.Dias < '" + informacion.getVencimiento() + "' and D.Dias > (select ADDDATE('" + informacion.getVencimiento() + "',INTERVAL (TIMESTAMPDIFF(YEAR, '" + informacion.getVencimiento() + "', CURDATE())-1) YEAR)) and (V.Estatus = 'AutorizadoSupervisor' or V.Estatus = 'Autorizado') and V.IdUsuario = '" + session.getAttribute("IdUsuario") + "' order by D.Dias");
				while(resultados.next()) {
					if(resultados.getString("Dias").equals("0")){
						informacion.setDias("");
					}else{
						informacion.setDias(resultados.getString("Dias"));
					}
				}
				
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,informacion);
			}
			else if(request.getParameter("Accion").equals("ConsultarSolicitudesVacacionesConVencidas")) {
				/*" ",
					"SOLICITUDES PENDIENTES DE AUTORIZAR: ",
					"SOLICITUDES AUTORIZADAS: ",
					"SOLICITUDES RECHAZADAS: "
					*/
				eDB.setConexion();
				informacion = new InformacionVacaciones();
				
				resultados = eDB.getQuery("select EG.Admon from EmpresasGrupo as EG, Empleados as E where E.Division = EG.Id and E.IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()) {
					informacion.setAdmon(resultados.getString("Admon"));
				}
				
				//query que calcula las solicitudes pendientes
				//DEBUGSystem.out.println("select count(*) as Pendiente from Vacaciones where Estatus = 'Pendiente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				resultados = eDB.getQuery("select count(*) as Pendiente from Vacaciones where Estatus = 'Pendiente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()) {
					informacion.setSolicitudesPendientes(resultados.getString("Pendiente"));
				}
				
				//query que calcula las solicitudes rechazadas
				//DEBUGSystem.out.println("select count(*) as Rechazado from Vacaciones where Estatus = 'Rechazado' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				resultados = eDB.getQuery("select count(*) as Rechazado from Vacaciones where Estatus = 'Rechazado' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()){
					informacion.setSolicitudesRechazadas(resultados.getString("Rechazado"));
				}
				
				//query que calcula las solicitudes aceptadas
				//System.out.println("select count(*) as Aceptado from Vacaciones where Estatus = 'AutorizadoGerente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				//DEBUGSystem.out.println("select count(*) as Aceptado from Vacaciones where Estatus = 'Autorizado' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				//resultados = eDB.getQuery("select count(*) as Aceptado from Vacaciones where Estatus = 'AutorizadoGerente' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				resultados = eDB.getQuery("select count(*) as Aceptado from Vacaciones where Estatus = 'Autorizado' and IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()){
					informacion.setSolicitudesAutorizadas(resultados.getString("Aceptado"));
				}
				
				//query que calcula las cuando es tu fecha limite para las vacaciones
				//DEBUGSystem.out.println("select ADDDATE(FechaIngreso,INTERVAL (TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE())+1) YEAR) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				resultados = eDB.getQuery("select ADDDATE(FechaIngreso,INTERVAL (TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE())+1) YEAR) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()){
					informacion.setVencimiento(resultados.getString("Limite"));
				}
				
				//query que calcula los dias solicitados (pedidos con estatus aceptado)
				informacion.setDiasDisfrutar("0");
				//DEBUGSystem.out.println("select Vacaciones, NoDisfrutadosPeriodoAnterior from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				resultados = eDB.getQuery("select Vacaciones, NoDisfrutadosPeriodoAnterior from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				//SE COMENTA PORQUE LA SUMA DA NÚMEROS NEGATIVOS EN DÍAS QUE HAS SOLICITADO
				//resultados = eDB.getQuery("select SUM(Vacaciones + NoDisfrutadosPeriodoAnterior) as Vacaciones from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				while(resultados.next()) {
					informacion.setDiasDisfrutar(resultados.getString("Vacaciones"));
					informacion.setDiasDisfrutarPeriodoAnterior(resultados.getString("NoDisfrutadosPeriodoAnterior"));
				}
				
				//query que calcula los dias totales del empleado
				//DEBUGSystem.out.println("select sum(EV.DiasLey+EV.DiasExtra) as Total,EV.Ao from Empleados as E left join EmpresasGrupo as EG on(E.Division = EG.Id) left join EmpresasVacaciones as EV on(EV.IdEmpresasGrupo = EG.Id) where E.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and EV.Ao = (select TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE()) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "' and Estatus = 'ACTIVO') and E.Estatus = 'ACTIVO'");
				resultados = eDB.getQuery("select sum(EV.DiasLey+EV.DiasExtra) as Total,EV.Ao from Empleados as E left join EmpresasGrupo as EG on(E.Division = EG.Id) left join EmpresasVacaciones as EV on(EV.IdEmpresasGrupo = EG.Id) where E.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and EV.Ao = (select TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE()) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "' and Estatus = 'ACTIVO') and E.Estatus = 'ACTIVO'");
				//SE COMENTA PORQUE ALTERA LA CANTIDAD DE DÍAS TOTAL DEL AÑO
				//resultados = eDB.getQuery("select sum(E.Vacaciones) as Total,E.NoDisfrutadosPeriodoAnterior,EV.Ao from Empleados as E left join EmpresasGrupo as EG on(E.Division = EG.Id) left join EmpresasVacaciones as EV on(EV.IdEmpresasGrupo = EG.Id) where E.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and EV.Ao = (select TIMESTAMPDIFF(YEAR, FechaIngreso, CURDATE()) as Limite from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "' and Estatus = 'ACTIVO') and E.Estatus = 'ACTIVO'");
				while(resultados.next()) {
					try{
						if(!resultados.getString("Total").equals("null")) {
							int totales = Integer.parseInt(resultados.getString("Total"));
							//int noDisfrutados = Integer.parseInt(resultados.getString("NoDisfrutadosPeriodoAnterior"));
							//DDEBUGSystem.out.println("Totales es "+totales+" y del Periodo Anterior "+noDisfrutados);
							//int sumaTotales = totales + noDisfrutados; 
							
							//informacion.setDiasTotales(String.valueOf(sumaTotales));
							informacion.setDiasTotales(String.valueOf(resultados.getString("Total")));
						
						}
					}catch(NullPointerException e){
						informacion.setDiasTotales("0");
					}
				}
				
				//calcula los dias por disfrutar (dias pendientes)
				//informacion.setDiasSolicitados(String.valueOf(Integer.parseInt(informacion.getDiasTotales()) - (Integer.parseInt(informacion.getDiasDisfrutar()) + Integer.parseInt(informacion.getDiasDisfrutarPeriodoAnterior()) )));
				//SE ANULA ABAJO informacion.setDiasSolicitados(String.valueOf(Integer.parseInt(informacion.getDiasTotales()) - Integer.parseInt(informacion.getDiasDisfrutar())));
				
				//query donde se obtienen los dias que han sido solicitados
				//System.out.println("select ifnull(group_concat(D.Dias),0) as Dias from Vacaciones as V left join VacacionesDias as D on(V.Llave = D.Llave) where D.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and D.Dias < '" + informacion.getVencimiento() + "' and D.Dias > (select ADDDATE('" + informacion.getVencimiento() + "',INTERVAL (TIMESTAMPDIFF(YEAR, '" + informacion.getVencimiento() + "', CURDATE())-1) YEAR)) and (V.Estatus = 'AutorizadoSupervisor' or V.Estatus = 'AutorizadoGerente') and V.IdUsuario = '" + session.getAttribute("IdUsuario") + "' order by D.Dias");
				//DEBUGSystem.out.println("select ifnull(group_concat(D.Dias),0) as Dias from Vacaciones as V left join VacacionesDias as D on(V.Llave = D.Llave) where D.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and V.FechaSolicitud < '" + informacion.getVencimiento() + "' and V.FechaSolicitud > (select ADDDATE('" + informacion.getVencimiento() + "',INTERVAL (TIMESTAMPDIFF(YEAR, '" + informacion.getVencimiento() + "', CURDATE())-1) YEAR)) and (V.Estatus = 'AutorizadoSupervisor' or V.Estatus = 'Autorizado') and V.IdUsuario = '" + session.getAttribute("IdUsuario") + "' order by D.Dias");
				//resultados = eDB.getQuery("select ifnull(group_concat(D.Dias),0) as Dias from Vacaciones as V left join VacacionesDias as D on(V.Llave = D.Llave) where D.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and D.Dias < '" + informacion.getVencimiento() + "' and D.Dias > (select ADDDATE('" + informacion.getVencimiento() + "',INTERVAL (TIMESTAMPDIFF(YEAR, '" + informacion.getVencimiento() + "', CURDATE())-1) YEAR)) and (V.Estatus = 'AutorizadoSupervisor' or V.Estatus = 'AutorizadoGerente') and V.IdUsuario = '" + session.getAttribute("IdUsuario") + "' order by D.Dias");
				resultados = eDB.getQuery("select ifnull(group_concat(D.Dias),0) as Dias from Vacaciones as V left join VacacionesDias as D on(V.Llave = D.Llave) where D.IdUsuario = '" + session.getAttribute("IdUsuario") + "' and V.FechaSolicitud < '" + informacion.getVencimiento() + "' and V.FechaSolicitud > (select ADDDATE('" + informacion.getVencimiento() + "',INTERVAL (TIMESTAMPDIFF(YEAR, '" + informacion.getVencimiento() + "', CURDATE())-1) YEAR)) and (V.Estatus = 'AutorizadoSupervisor' or V.Estatus = 'Autorizado') and V.IdUsuario = '" + session.getAttribute("IdUsuario") + "' order by D.Dias");
				int cantidadDias = 0;
				while(resultados.next()) {
					if(resultados.getString("Dias").equals("0")){
						informacion.setDias("");
					}else{
						informacion.setDias(resultados.getString("Dias"));
						String[] cuentaDias = resultados.getString("Dias").split(",");
						cantidadDias = cuentaDias.length;
					}
				}
				
				informacion.setDiasSolicitados(String.valueOf(cantidadDias));
				
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,informacion);
			}
			else if(request.getParameter("Accion").equals("ReporteVacaciones")){
				eDB.setConexion();
				ArrayList<InformacionVacaciones> info = new ArrayList<InformacionVacaciones>();
				//query que calcula los dias solicitados (pedidos con estatus aceptado)
				String where = "";
				if(request.getParameter("FechaInicio") != ""){
					where += " and D.Dias >= '" + request.getParameter("FechaInicio") + "'";
				}
				if(request.getParameter("FechaFin") != ""){
					where += " and D.Dias <= '" + request.getParameter("FechaFin") + "'";
				}
				if(request.getParameter("IdEmpleado") != ""){
					where += " and E.Id = '" + request.getParameter("IdEmpleado") + "' and D.IdUsuario = (select IdUsuario from Empleados where Id = '" + request.getParameter("IdEmpleado") + "')";
				}
				if(request.getParameter("IdDivision") != ""){
					where += " and E.Division = '" + request.getParameter("IdDivision") + "'";
				}
						
				// ANTES DIVISION String query = "select E.NombreCompleto,V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Usuarios as U left join Empleados as E on(U.Id = E.IdUsuario) where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and U.Id = V.IdUsuario and E.Estatus = 'ACTIVO'" + where + " group by V.IdUsuario";
				//String query = "select E.NombreCompleto, EG.Admon as Admon, V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Usuarios as U left join Empleados as E on(U.Id = E.IdUsuario) left join EmpresasGrupo as EG on (EG.Id = E.Division) where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and U.Id = V.IdUsuario and E.Estatus = 'ACTIVO' and EG.Admon =(select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '"+session.getAttribute("IdUsuario")+"'))" + where + " group by V.IdUsuario";
				String query = "select E.NombreCompleto, EG.Admon as Admon, V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Usuarios as U left join Empleados as E on(U.Id = E.IdUsuario) left join EmpresasGrupo as EG on (EG.Id = E.Division) where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'Autorizado' and U.Id = V.IdUsuario and E.Estatus = 'ACTIVO' and EG.Admon =(select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '"+session.getAttribute("IdUsuario")+"'))" + where + " group by V.IdUsuario";
				//DEBUGSystem.out.println(query);
				resultados = eDB.getQuery(query);
				
				int i=0;
				
				while(resultados.next()) {
					informacion = new InformacionVacaciones();
					
					informacion.setNombre(resultados.getString("NombreCompleto"));
					
					while (i==0){
						//DEBUGSystem.out.println("Los Empleados considerados en el Reporte de Vacaciones son de "+resultados.getString("Admon"));
						i++;
					}
					
					//query para obtener las fechas de vacaciones
					//String query2 = "select group_concat(D.Dias) as Dias, count(D.Dias) as DiasSolicitados from VacacionesDias as D, Vacaciones as V left join Empleados as E on(V.IdUsuario = E.IdUsuario) where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and D.IdUsuario = '" + resultados.getString("IdUsuario") + "' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "'" + where + "";
					String query2 = "select group_concat(D.Dias) as Dias, count(D.Dias) as DiasSolicitados from VacacionesDias as D, Vacaciones as V left join Empleados as E on(V.IdUsuario = E.IdUsuario) where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'Autorizado' and D.IdUsuario = '" + resultados.getString("IdUsuario") + "' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "'" + where + "";
					//DEBUGSystem.out.println(query2);
					resultados2 = eDB.getQuery(query2);
					while(resultados2.next()){
						informacion.setFechasVacaciones(resultados2.getString("Dias"));
						informacion.setDiasSolicitados(resultados2.getString("DiasSolicitados"));
					}
					info.add(informacion);
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
				//resultados = eDB.getQuery("select count(*) as DiasSolicitados,P.NombreCompleto,V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Empleados as P where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and P.IdUsuario = V.IdUsuario and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "' group by V.IdUsuario");
				resultados = eDB.getQuery("select count(*) as DiasSolicitados,P.NombreCompleto,V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Empleados as P where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'Autorizado' and P.IdUsuario = V.IdUsuario and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "' group by V.IdUsuario");
				//System.out.println("select count(*) as DiasSolicitados,P.NombreCompleto,V.IdUsuario from VacacionesDias as D left join Vacaciones as V on(V.Llave = D.Llave), Empleados as P where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and P.IdUsuario = V.IdUsuario and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "' group by V.IdUsuario");
				while(resultados.next()) {
					informacion = new InformacionVacaciones();
					informacion.setDiasSolicitados(resultados.getString("DiasSolicitados"));
					informacion.setNombre(resultados.getString("NombreCompleto"));
					//query para obtener las fechas de vacaciones
					//resultados2 = eDB.getQuery("select D.Dias from VacacionesDias as D, Vacaciones as V where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "' and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "'");
					resultados2 = eDB.getQuery("select D.Dias from VacacionesDias as D, Vacaciones as V where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'Autorizado' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "' and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "'");
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
			else if(request.getParameter("Accion").equals("BorrarVacaciones")){
				//funcion donde borra las vacaciones que seleccionaron para ser liberadas
				eDB.setConexion();
				String ids = request.getParameter("Ids");
				String[] id = ids.split(",");
				for(int i = 0; i < id.length; i++) {
					if(!id[i].equals("")) {
						
						// Obteniendo el tipo y asignandolo a una variable string
						resultados = eDB.getQuery("select Tipo from VacacionesDias where Id = '" + id[i] + "'");
						resultados.next(); // Avanca a la primer Casilla para obtener información del primer valor
						String Categoria = resultados.getString("Tipo");
						
						eDB.setQuery("insert into VacacionesDiasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdUsuario,Dias,Llave,Tipo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdUsuario,Dias,Llave,Tipo from VacacionesDias where Id = '" + id[i] + "'");
						eDB.setQuery("delete from VacacionesDias where Id = '" + id[i] + "'");
						
						// validando que el día borrado no incremente vacaciones al empleado si es que fue sin goce
						// DEBUG System.out.println(Categoria);
						if(Categoria.equals("VACACIONES")){
							// Query que incrementa un día si es que el borrado fue tipo vacaciones
							eDB.setQuery("update Empleados set Vacaciones = (Vacaciones+1) where Id = '" + request.getParameter("NombreEmpleado") + "'");
						}
						eDB.setQuery("insert into EmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,IdJefeDirecto) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,IdJefeDirecto from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Vacaciones();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("BuscarVacaciones")){
				//funcion donde busca las vacaciones que no fueron guardadas
				String usuario = request.getParameter("Usuario"),nombre = request.getParameter("NombreEmpleado");
				
				eDB.setConexion();
				resultados = eDB.getQuery("select U.Id,E.NombreCompleto from Usuarios as U left join Empleados as E on(E.IdUsuario = U.Id) where U.Usuario = '" + usuario + "' and E.Id = '" + nombre + "'");
				ArrayList<Vacaciones> info = new ArrayList<Vacaciones>();
				while(resultados.next()){
					resultados2 = eDB.getQuery("select D.Id,D.Dias, ifnull(V.Estatus,'NO GUARDADO') as Estatus from VacacionesDias as D left join Vacaciones as V on(D.Llave = V.Llave) where D.IdUsuario = '" + resultados.getString("Id") + "' order by D.Id asc");
					while(resultados2.next()){
						if(resultados2.getString("Estatus").equals("NO GUARDADO")){
							objeto = new Vacaciones();
							objeto.setFechaSolicitud(resultados2.getString("Dias"));
							objeto.setEstatus(resultados2.getString("Estatus"));
							objeto.setId(resultados2.getInt("Id"));
							info.add(objeto);
						}
					}
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar(resultados2);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("ConsultarVacacionesEmpleados")){
				//variable que contiene todas las fechas
//				String fechas = "";
				eDB.setConexion();
				resultados = eDB.getQuery("select * from (select E.NombreCompleto as NombreSolicitante, U.Usuario as UsuarioSolicitante, V.FechaSolicitud as VacacionesFechaSolicitud, if(U1.Nombre is null,'',U1.Nombre) Solicito1, U1.Usuario as UsuarioAutorizador1, if(U2.Nombre is null,'',U2.Nombre) Solicito2, U2.Usuario as UsuarioAutorizador2, V.Tipo, V.Estatus, (select group_concat(Dias) as Dias from VacacionesDias where Llave = D.Llave) VacacionesDias, V.IdUsuario from VacacionesDias as D, Vacaciones as V left join Usuarios U1 on (U1.Id = V.Jefe) left join Usuarios U2 on (U2.Id = V.Gerente) left join Empleados E on (E.IdUsuario = V.IdUsuario), Usuarios as U where V.Llave = D.Llave and U.Id = V.IdUsuario) InfoVacaciones where IdUsuario = (select IdUsuario from Empleados where Id = '" + request.getParameter("IdUsuario") + "') group by VacacionesDias");
				ArrayList<InformacionVacaciones> info = new ArrayList<InformacionVacaciones>();
				//System.out.println("select * from (select E.NombreCompleto as NombreSolicitante, U.Usuario as UsuarioSolicitante, V.FechaSolicitud as VacacionesFechaSolicitud, if(U1.Nombre is null,'',U1.Nombre) Solicito1, U1.Usuario as UsuarioAutorizador1, if(U2.Nombre is null,'',U2.Nombre) Solicito2, U2.Usuario as UsuarioAutorizador2, V.Tipo, V.Estatus, (select group_concat(Dias) as Dias from VacacionesDias where Llave = D.Llave) VacacionesDias, V.IdUsuario from VacacionesDias as D, Vacaciones as V left join Usuarios U1 on (U1.Id = V.Jefe) left join Usuarios U2 on (U2.Id = V.Gerente) left join Empleados E on (E.IdUsuario = V.IdUsuario), Usuarios as U where V.Llave = D.Llave and U.Id = V.IdUsuario) InfoVacaciones where IdUsuario = (select IdUsuario from Empleados where Id = '" + request.getParameter("IdUsuario") + "') group by VacacionesDias");
				while(resultados.next()) {
					informacion = new InformacionVacaciones();
					informacion.setNombreSolicitante(resultados.getString("NombreSolicitante"));
					informacion.setUsuarioSolicitante(resultados.getString("UsuarioSolicitante"));
					informacion.setVacacionesFechaSolicitud(resultados.getString("VacacionesFechaSolicitud"));
					informacion.setSolicito1(resultados.getString("Solicito1"));
					informacion.setUsuarioAutorizador1(resultados.getString("UsuarioAutorizador1"));
					informacion.setSolicito2(resultados.getString("Solicito2"));
					informacion.setUsuarioAutorizador2(resultados.getString("UsuarioAutorizador2"));
					informacion.setTipo(resultados.getString("Tipo"));
					informacion.setEstatus(resultados.getString("Estatus"));
					informacion.setVacacionesDias(resultados.getString("VacacionesDias"));
					//query para obtener las fechas de vacaciones
//					resultados2 = eDB.getQuery("select D.Dias from VacacionesDias as D, Vacaciones as V where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "' and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "'");
					//System.out.println("select D.Dias from VacacionesDias as D, Vacaciones as V where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "' and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "'");
//					while(resultados2.next()){
//						fechas += resultados2.getString("Dias") + "  ";
//					}
//					informacion.setFechasVacaciones(fechas);
 					info.add(informacion);
//					fechas = "";
				}

				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info,0);
			}
			else if(request.getParameter("Accion").equals("ConsultarVacacionesAutorizadasEmpleados")){
				//variable que contiene todas las fechas
//				String fechas = "";
				eDB.setConexion();
//				System.out.println("select * from (select E.NombreCompleto as NombreSolicitante, U.Usuario as UsuarioSolicitante, V.FechaSolicitud as VacacionesFechaSolicitud, if(U1.Nombre is null,'',U1.Nombre) Solicito1, U1.Usuario as UsuarioAutorizador1, if(U2.Nombre is null,'',U2.Nombre) Solicito2, U2.Usuario as UsuarioAutorizador2, V.Tipo, V.Estatus, (select group_concat(Dias) as Dias from VacacionesDias where Llave = D.Llave) VacacionesDias, V.IdUsuario from VacacionesDias as D, Vacaciones as V left join Usuarios U1 on (U1.Id = V.Jefe) left join Usuarios U2 on (U2.Id = V.Gerente) left join Empleados E on (E.IdUsuario = V.IdUsuario), Usuarios as U where V.Llave = D.Llave and U.Id = V.IdUsuario) InfoVacaciones where IdUsuario = (select IdUsuario from Empleados where Id = '" + request.getParameter("IdUsuario") + "') group by VacacionesDias");
//				resultados = eDB.getQuery("select * from (select E.NombreCompleto as NombreSolicitante, U.Usuario as UsuarioSolicitante, V.FechaSolicitud as VacacionesFechaSolicitud, if(U1.Nombre is null,'',U1.Nombre) Solicito1, U1.Usuario as UsuarioAutorizador1, if(U2.Nombre is null,'',U2.Nombre) Solicito2, U2.Usuario as UsuarioAutorizador2, V.Tipo, V.Estatus, (select group_concat(Dias) as Dias from VacacionesDias where Llave = D.Llave) VacacionesDias, V.IdUsuario from VacacionesDias as D, Vacaciones as V left join Usuarios U1 on (U1.Id = V.Jefe) left join Usuarios U2 on (U2.Id = V.Gerente) left join Empleados E on (E.IdUsuario = V.IdUsuario), Usuarios as U where V.Llave = D.Llave and U.Id = V.IdUsuario) InfoVacaciones where IdUsuario = (select IdUsuario from Empleados where Id = '" + request.getParameter("IdUsuario") + "') group by VacacionesDias");
				String fechaDesde = request.getParameter("Fecha");
				String fechaHasta = request.getParameter("FechaA");
				if(fechaDesde.equals("")) {
					fechaDesde="1990-01-01";
				}
				if(fechaHasta.equals("")) {
					fechaHasta="5000-01-01";
				}
				resultados = eDB.getQuery("select " + 
						"	V.*, " + 
						"    (select NombreCompleto from Empleados where Id = '" + request.getParameter("IdUsuario") + "') NombreSolicitante, " + 
						"    (select group_concat(Dias) as Dias from VacacionesDias where Llave = V.Llave) DiasSolicitados " + 
						"		from " + 
						"			Vacaciones as V " + 
						"				where " + 
						"					V.IdUsuario = (select IdUsuario from Empleados where Id = '" + request.getParameter("IdUsuario") + "') " + 
						"                    and V.Estatus = 'Autorizado' " + 
						"                    and V.Tipo = 'VACACIONES' " + 
						"					and V.FechaSolicitud >= '"+fechaDesde+"' " + 
						"                    and V.FechaSolicitud <= '"+fechaHasta+"'");
				ArrayList<InformacionVacaciones> info = new ArrayList<InformacionVacaciones>();
				//System.out.println("select * from (select E.NombreCompleto as NombreSolicitante, U.Usuario as UsuarioSolicitante, V.FechaSolicitud as VacacionesFechaSolicitud, if(U1.Nombre is null,'',U1.Nombre) Solicito1, U1.Usuario as UsuarioAutorizador1, if(U2.Nombre is null,'',U2.Nombre) Solicito2, U2.Usuario as UsuarioAutorizador2, V.Tipo, V.Estatus, (select group_concat(Dias) as Dias from VacacionesDias where Llave = D.Llave) VacacionesDias, V.IdUsuario from VacacionesDias as D, Vacaciones as V left join Usuarios U1 on (U1.Id = V.Jefe) left join Usuarios U2 on (U2.Id = V.Gerente) left join Empleados E on (E.IdUsuario = V.IdUsuario), Usuarios as U where V.Llave = D.Llave and U.Id = V.IdUsuario) InfoVacaciones where IdUsuario = (select IdUsuario from Empleados where Id = '" + request.getParameter("IdUsuario") + "') group by VacacionesDias");
				while(resultados.next()) {
					informacion = new InformacionVacaciones();
					informacion.setNombreSolicitante(resultados.getString("NombreSolicitante"));
					//informacion.setUsuarioSolicitante(resultados.getString("UsuarioSolicitante"));
					informacion.setVacacionesFechaSolicitud(resultados.getString("FechaSolicitud"));
					//informacion.setSolicito1(resultados.getString("Solicito1"));
					//informacion.setUsuarioAutorizador1(resultados.getString("UsuarioAutorizador1"));
					//informacion.setSolicito2(resultados.getString("Solicito2"));
					//informacion.setUsuarioAutorizador2(resultados.getString("UsuarioAutorizador2"));
					informacion.setTipo(resultados.getString("Tipo"));
					informacion.setEstatus(resultados.getString("Estatus"));
					informacion.setVacacionesDias(resultados.getString("DiasSolicitados"));
					informacion.setLlave(resultados.getString("Llave"));
					//query para obtener las fechas de vacaciones
//					resultados2 = eDB.getQuery("select D.Dias from VacacionesDias as D, Vacaciones as V where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "' and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "'");
					//System.out.println("select D.Dias from VacacionesDias as D, Vacaciones as V where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "' and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "'");
//					while(resultados2.next()){
//						fechas += resultados2.getString("Dias") + "  ";
//					}
//					informacion.setFechasVacaciones(fechas);
 					info.add(informacion);
//					fechas = "";
				}

				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info,0);
			}
			else if(request.getParameter("Accion").equals("ConsultarSolicitudesPendientesEmpleadosGdl")){
				//variable que contiene todas las fechas
//				String fechas = "";
				eDB.setConexion();
				
				String fechaDesde = request.getParameter("Fecha");
				String fechaHasta = request.getParameter("FechaA");
				String idEmpleado = request.getParameter("IdUsuario");
				if(fechaDesde.equals("")) {
					fechaDesde="1990-01-01";
				}
				if(fechaHasta.equals("")) {
					fechaHasta="5000-01-01";
				}
				if(idEmpleado.equals("")) {
					idEmpleado="like '%%'";
				}else {
					idEmpleado="= (select IdUsuario from Empleados where Id = '"+request.getParameter("IdUsuario")+"')";
					
				}
//				DEBUG System.out.println("select * from (select E.NombreCompleto as NombreSolicitante, U.Usuario as UsuarioSolicitante, V.FechaSolicitud as VacacionesFechaSolicitud, if(U1.Nombre is null,'',U1.Nombre) Solicito1, U1.Usuario as UsuarioAutorizador1, if(U2.Nombre is null,'',U2.Nombre) Solicito2, U2.Usuario as UsuarioAutorizador2, V.Tipo, V.Estatus, (select group_concat(Dias) as Dias from VacacionesDias where Llave = D.Llave) VacacionesDias, V.IdUsuario from VacacionesDias as D, Vacaciones as V left join Usuarios U1 on (U1.Id = V.Jefe) left join Usuarios U2 on (U2.Id = V.Gerente) left join Empleados E on (E.IdUsuario = V.IdUsuario), Usuarios as U, EmpresasGrupo as EG where V.Llave = D.Llave and U.Id = V.IdUsuario and E.Division = EG.Id and EG.Admon = 'GDL') InfoVacaciones where IdUsuario "+idEmpleado+" and Estatus = 'Pendiente' and VacacionesFechaSolicitud >= '"+fechaDesde+"' and VacacionesFechaSolicitud <= '"+fechaHasta+"' group by VacacionesDias");
				resultados = eDB.getQuery("select * from (select E.NombreCompleto as NombreSolicitante, U.Usuario as UsuarioSolicitante, V.FechaSolicitud as VacacionesFechaSolicitud, if(U1.Nombre is null,'',U1.Nombre) Solicito1, U1.Usuario as UsuarioAutorizador1, if(U2.Nombre is null,'',U2.Nombre) Solicito2, U2.Usuario as UsuarioAutorizador2, V.Tipo, V.Estatus, (select group_concat(Dias) as Dias from VacacionesDias where Llave = D.Llave) VacacionesDias, V.IdUsuario from VacacionesDias as D, Vacaciones as V left join Usuarios U1 on (U1.Id = V.Jefe) left join Usuarios U2 on (U2.Id = V.Gerente) left join Empleados E on (E.IdUsuario = V.IdUsuario), Usuarios as U, EmpresasGrupo as EG where V.Llave = D.Llave and U.Id = V.IdUsuario and E.Division = EG.Id and EG.Admon = 'GDL') InfoVacaciones where IdUsuario "+idEmpleado+" and Estatus = 'Pendiente' and VacacionesFechaSolicitud >= '"+fechaDesde+"' and VacacionesFechaSolicitud <= '"+fechaHasta+"' group by VacacionesDias");
				ArrayList<InformacionVacaciones> info = new ArrayList<InformacionVacaciones>();
				while(resultados.next()) {
					informacion = new InformacionVacaciones();
					informacion.setNombreSolicitante(resultados.getString("NombreSolicitante"));
					informacion.setUsuarioSolicitante(resultados.getString("UsuarioSolicitante"));
					informacion.setVacacionesFechaSolicitud(resultados.getString("VacacionesFechaSolicitud"));
					informacion.setSolicito1(resultados.getString("Solicito1"));
					informacion.setUsuarioAutorizador1(resultados.getString("UsuarioAutorizador1"));
					informacion.setSolicito2(resultados.getString("Solicito2"));
					informacion.setUsuarioAutorizador2(resultados.getString("UsuarioAutorizador2"));
					informacion.setTipo(resultados.getString("Tipo"));
					informacion.setEstatus(resultados.getString("Estatus"));
					informacion.setVacacionesDias(resultados.getString("VacacionesDias"));
					//query para obtener las fechas de vacaciones
//					resultados2 = eDB.getQuery("select D.Dias from VacacionesDias as D, Vacaciones as V where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "' and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "'");
					//System.out.println("select D.Dias from VacacionesDias as D, Vacaciones as V where V.Tipo = 'VACACIONES' and V.Llave = D.Llave and V.Estatus = 'AutorizadoGerente' and V.IdUsuario = '" + resultados.getString("IdUsuario") + "' and D.Dias >= '" + request.getParameter("FechaInicio") + "' and D.Dias <= '" + request.getParameter("FechaFin") + "' and V.Gerente = '" + session.getAttribute("IdUsuario") + "'");
//					while(resultados2.next()){
//						fechas += resultados2.getString("Dias") + "  ";
//					}
//					informacion.setFechasVacaciones(fechas);
 					info.add(informacion);
//					fechas = "";
				}

				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info,0);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id > 0 and U.Id = A.IdUsuario and (Gerente = '" + session.getAttribute("IdUsuario") + "' or Jefe = '" + session.getAttribute("IdUsuario") + "') ";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Vacaciones();
				objeto.setIdUsuario(session.getAttribute("IdUsuario").toString());
				objeto.setFechaSolicitud(request.getParameter("FechaSolicitud"));
				objeto.setEstatus(request.getParameter("Estatus"));
				objeto.setGerente(request.getParameter("Gerente"));
				objeto.setJefe(request.getParameter("Jefe"));
				objeto.setLlave(request.getParameter("Llave"));

				resultados = eDB.getQuery("select A.*,if(A.FechaSolicitud = '0000-00-00',0,A.FechaSolicitud) as Fecha, U.Nombre, if(@1:=(select group_concat(Dias) from VacacionesDias where IdUsuario = A.IdUsuario and Llave = A.Llave) is null,(select group_concat(Dias) from VacacionesDiasRechazados where IdUsuario = A.IdUsuario and Llave = A.Llave),(select group_concat(Dias) from VacacionesDias where IdUsuario = A.IdUsuario and Llave = A.Llave)) as Dias from Vacaciones as A, Usuarios as U" + whereInicio + where.toString());
				
				ArrayList<Vacaciones> info = new ArrayList<Vacaciones>();
				while(resultados.next()) {
					objeto = new Vacaciones();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("Nombre"));
					objeto.setFechaSolicitud(resultados.getString("Fecha"));
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
 
