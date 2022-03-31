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
import Objetos.VacacionesDias;

import com.google.gson.Gson;

public class VacacionesDiasServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5227398970583478547L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private VacacionesDias objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;
	
	//int diasTemporal = 0;

	public VacacionesDiasServlet() {
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
				// TANTO EN GUARDAR (VACACIONES) COMO EN GUARDARSINGOCE (DIAS SIN GOCE) SE AGREGARON VALORES FIJOS PARA TIPO, PERO NO SE CONSULTAN NI SE AGREGARON EN EL OBJETO
			if(request.getParameter("Accion").equals("Guardar")) {//AGREGAR DIAS
				eDB.setConexion();
				// agregar validacion de dï¿½ï¿½as
				resultados = eDB.getQuery("select Vacaciones, NoDisfrutadosPeriodoAnterior from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				objeto = new VacacionesDias();
				if(resultados.next()) {
					if(resultados.getInt("NoDisfrutadosPeriodoAnterior") > 0) {
						eDB.setQuery("insert into VacacionesDias (U,G,E,IdUsuario,Dias,Llave,Tipo) values ('" + 
								session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + 
								session.getAttribute("IdUsuario") + "','" + traducciones.getFecha(request.getParameter("Dias")) + "','" + request.getParameter("Llave") + "','VACACIONES')");
							ultimoId = eDB.getUltimoId();
							eDB.setQuery("insert into VacacionesDiasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,Dias,Llave,Tipo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,Dias,Llave,'VACACIONES' from VacacionesDias where Id = '" + ultimoId + "'");
							eDB.setQuery("update Empleados set NoDisfrutadosPeriodoAnterior = NoDisfrutadosPeriodoAnterior - 1 where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
					}
					else if(resultados.getInt("Vacaciones") > 0) {
						
//						diasTemporal++;
//						System.out.println("Cantidad de días en Guardar "+diasTemporal);
						
						eDB.setQuery("insert into VacacionesDias (U,G,E,IdUsuario,Dias,Llave,Tipo) values ('" + 
							session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + 
							session.getAttribute("IdUsuario") + "','" + traducciones.getFecha(request.getParameter("Dias")) + "','" + request.getParameter("Llave") + "','VACACIONES')");
						ultimoId = eDB.getUltimoId();
						eDB.setQuery("insert into VacacionesDiasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,Dias,Llave,Tipo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,Dias,Llave,'VACACIONES' from VacacionesDias where Id = '" + ultimoId + "'");
						eDB.setQuery("update Empleados set Vacaciones = Vacaciones - 1 where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
					} else {
						objeto.setError(true);
						objeto.setLog("NO TIENE VACACIONES DISPONIBLES");
					}
				} else {
					objeto.setError(true);
					objeto.setLog("NO TIENE VACACIONES DISPONIBLES");
				}
				//
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				
				objeto.setId(ultimoId);
				objeto.setIdUsuario(session.getAttribute("IdUsuario").toString());
				objeto.setDias(request.getParameter("Dias"));
				objeto.setLlave(request.getParameter("Llave"));
				
				imprimeJson(response,objeto);
			}else if(request.getParameter("Accion").equals("GuardarSinGoce")) {
				eDB.setConexion();
				objeto = new VacacionesDias();
				eDB.setQuery("insert into VacacionesDias (U,G,E,IdUsuario,Dias,Llave,Tipo) values ('" + 
						session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + 
						session.getAttribute("IdUsuario") + "','" + traducciones.getFecha(request.getParameter("Dias")) + "','" + request.getParameter("Llave") + "','DIAS SIN GOCE')");
					ultimoId = eDB.getUltimoId();
					eDB.setQuery("insert into VacacionesDiasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,Dias,Llave,Tipo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,Dias,Llave,'DIAS SIN GOCE' from VacacionesDias where Id = '" + ultimoId + "'");

				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				
				objeto.setId(ultimoId);
				objeto.setIdUsuario(session.getAttribute("IdUsuario").toString());
				objeto.setDias(request.getParameter("Dias"));
				objeto.setLlave(request.getParameter("Llave"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id > 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new VacacionesDias();
				objeto.setLlave(request.getParameter("Llave"));

				if(!objeto.getIdUsuario().equals("")) { where.append(" and A.IdUsuario like '" + objeto.getIdUsuario() + "%'"); entro = true;}
				if(!objeto.getDias().equals("")) { where.append(" and A.Dias like '" + objeto.getDias() + "%'"); entro = true;}
				if(!objeto.getLlave().equals("")) { where.append(" and A.Llave like '" + objeto.getLlave() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from VacacionesDias as A" + whereInicio + where.toString());
				ArrayList<VacacionesDias> info = new ArrayList<VacacionesDias>();
				while(resultados.next()) {
					objeto = new VacacionesDias();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("IdUsuario"));
					objeto.setDias(resultados.getString("Dias"));
					objeto.setLlave(resultados.getString("Llave"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("Borrar")) {//QUITAR DIAS
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
						
//						diasTemporal--;
//						System.out.println("Cantidad de días en Borrar "+diasTemporal);
						
						// validando que el día borrado no incremente vacaciones al empleado si es que fue sin goce
						// DEBUG System.out.println(Categoria);
						if(Categoria.equals("VACACIONES")){
							// Query que incrementa un día si es que el borrado fue tipo vacaciones
							eDB.setQuery("update Empleados set Vacaciones = (Vacaciones+1) where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
						}
						eDB.setQuery("insert into EmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,IdJefeDirecto) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,IdJefeDirecto from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new VacacionesDias();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from VacacionesDias as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new VacacionesDias();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("IdUsuario"));
					objeto.setDias(resultados.getString("Dias"));
					objeto.setLlave(resultados.getString("Llave"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update VacacionesDias set IdUsuario='" + traducciones.getEntero(request.getParameter("IdUsuario")) + "',Dias='" + traducciones.getFecha(request.getParameter("Dias")) + "',Llave='" + request.getParameter("Llave") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into VacacionesDiasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,Dias,Llave) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,Dias,Llave from VacacionesDias where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new VacacionesDias();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setIdUsuario(request.getParameter("IdUsuario"));
					objeto.setDias(request.getParameter("Dias"));
					objeto.setLlave(request.getParameter("Llave"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getVacacionesDias")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from VacacionesDias where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<VacacionesDias> info = new ArrayList<VacacionesDias>();
				while(resultados.next()) {
					objeto = new VacacionesDias();
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
			objeto = new VacacionesDias();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new VacacionesDias();
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
	
	private void imprimeJson(HttpServletResponse response, VacacionesDias objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<VacacionesDias> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(VacacionesDias objeto, Exception e) {
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
/* VacacionesDiasServlet */
