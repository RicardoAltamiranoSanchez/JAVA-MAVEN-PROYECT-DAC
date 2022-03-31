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
import Objetos.PersonasGeneral;

import com.google.gson.Gson;

public class PersonasGeneralServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7875109907412116954L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private PersonasGeneral objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public PersonasGeneralServlet() {
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
				eDB.setQuery("insert into PersonasGeneral (U,G,E,Empleado,NumEmpleado,NombreCompleto,NSS,RFC,CURP,IdUbicacionesGrupo,IdAreasGrupo,IdPuestosGrupo,IdEmpleadosGrupo,IdEmpresasGrupo,SueldoBruto,FechIngreso,FechaCump,EstatusEmpGpo) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Empleado") + "','" + traducciones.getEntero(request.getParameter("NumEmpleado")) + "','" + request.getParameter("NombreCompleto") + "','" + request.getParameter("NSS") + "','" + request.getParameter("RFC") + "','" + request.getParameter("CURP") + "','" + traducciones.getEntero(request.getParameter("IdUbicacionesGrupo")) + "','" + traducciones.getEntero(request.getParameter("IdAreasGrupo")) + "','" + traducciones.getEntero(request.getParameter("IdPuestosGrupo")) + "','" + traducciones.getEntero(request.getParameter("IdEmpleadosGrupo")) + "','" + traducciones.getEntero(request.getParameter("IdEmpresasGrupo")) + "','" + traducciones.getDecimal(request.getParameter("SueldoBruto")) + "','" + traducciones.getFecha(request.getParameter("FechIngreso")) + "','" + request.getParameter("FechaCump") + "','" + request.getParameter("EstatusEmpGpo") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into PersonasGeneralApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Empleado,NumEmpleado,NombreCompleto,NSS,RFC,CURP,IdUbicacionesGrupo,IdAreasGrupo,IdPuestosGrupo,IdEmpleadosGrupo,IdEmpresasGrupo,SueldoBruto,FechIngreso,FechaCump,EstatusEmpGpo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Empleado,NumEmpleado,NombreCompleto,NSS,RFC,CURP,IdUbicacionesGrupo,IdAreasGrupo,IdPuestosGrupo,IdEmpleadosGrupo,IdEmpresasGrupo,SueldoBruto,FechIngreso,FechaCump,EstatusEmpGpo from PersonasGeneral where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new PersonasGeneral();
				objeto.setId(ultimoId);
				objeto.setEmpleado(request.getParameter("Empleado"));
				objeto.setNumEmpleado(request.getParameter("NumEmpleado"));
				objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
				objeto.setNSS(request.getParameter("NSS"));
				objeto.setRFC(request.getParameter("RFC"));
				objeto.setCURP(request.getParameter("CURP"));
				objeto.setIdUbicacionesGrupo(request.getParameter("IdUbicacionesGrupo"));
				objeto.setIdAreasGrupo(request.getParameter("IdAreasGrupo"));
				objeto.setIdPuestosGrupo(request.getParameter("IdPuestosGrupo"));
				objeto.setIdEmpleadosGrupo(request.getParameter("IdEmpleadosGrupo"));
				objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
				objeto.setSueldoBruto(request.getParameter("SueldoBruto"));
				objeto.setFechIngreso(request.getParameter("FechIngreso"));
				objeto.setFechaCump(request.getParameter("FechaCump"));
				objeto.setEstatusEmpGpo(request.getParameter("EstatusEmpGpo"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new PersonasGeneral();
				objeto.setEmpleado(request.getParameter("Empleado"));
				objeto.setNumEmpleado(request.getParameter("NumEmpleado"));
				objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
				objeto.setNSS(request.getParameter("NSS"));
				objeto.setRFC(request.getParameter("RFC"));
				objeto.setCURP(request.getParameter("CURP"));
				objeto.setIdUbicacionesGrupo(request.getParameter("IdUbicacionesGrupo"));
				objeto.setIdAreasGrupo(request.getParameter("IdAreasGrupo"));
				objeto.setIdPuestosGrupo(request.getParameter("IdPuestosGrupo"));
				objeto.setIdEmpleadosGrupo(request.getParameter("IdEmpleadosGrupo"));
				objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
				objeto.setSueldoBruto(request.getParameter("SueldoBruto"));
				objeto.setFechIngreso(request.getParameter("FechIngreso"));
				objeto.setFechaCump(request.getParameter("FechaCump"));
				objeto.setEstatusEmpGpo(request.getParameter("EstatusEmpGpo"));

				if(!objeto.getEmpleado().equals("")) { where.append(" and A.Empleado like '" + objeto.getEmpleado() + "%'"); entro = true;}
				if(!objeto.getNumEmpleado().equals("")) { where.append(" and A.NumEmpleado like '" + objeto.getNumEmpleado() + "%'"); entro = true;}
				if(!objeto.getNombreCompleto().equals("")) { where.append(" and A.NombreCompleto like '" + objeto.getNombreCompleto() + "%'"); entro = true;}
				if(!objeto.getNSS().equals("")) { where.append(" and A.NSS like '" + objeto.getNSS() + "%'"); entro = true;}
				if(!objeto.getRFC().equals("")) { where.append(" and A.RFC like '" + objeto.getRFC() + "%'"); entro = true;}
				if(!objeto.getCURP().equals("")) { where.append(" and A.CURP like '" + objeto.getCURP() + "%'"); entro = true;}
				if(!objeto.getIdUbicacionesGrupo().equals("")) { where.append(" and A.IdUbicacionesGrupo like '" + objeto.getIdUbicacionesGrupo() + "%'"); entro = true;}
				if(!objeto.getIdAreasGrupo().equals("")) { where.append(" and A.IdAreasGrupo like '" + objeto.getIdAreasGrupo() + "%'"); entro = true;}
				if(!objeto.getIdPuestosGrupo().equals("")) { where.append(" and A.IdPuestosGrupo like '" + objeto.getIdPuestosGrupo() + "%'"); entro = true;}
				if(!objeto.getIdEmpleadosGrupo().equals("")) { where.append(" and A.IdEmpleadosGrupo like '" + objeto.getIdEmpleadosGrupo() + "%'"); entro = true;}
				if(!objeto.getIdEmpresasGrupo().equals("")) { where.append(" and A.IdEmpresasGrupo like '" + objeto.getIdEmpresasGrupo() + "%'"); entro = true;}
				if(!objeto.getSueldoBruto().equals("")) { where.append(" and A.SueldoBruto like '" + objeto.getSueldoBruto() + "%'"); entro = true;}
				if(!objeto.getFechIngreso().equals("")) { where.append(" and A.FechIngreso like '" + objeto.getFechIngreso() + "%'"); entro = true;}
				if(!objeto.getFechaCump().equals("")) { where.append(" and A.FechaCump like '" + objeto.getFechaCump() + "%'"); entro = true;}
				if(!objeto.getEstatusEmpGpo().equals("")) { where.append(" and A.EstatusEmpGpo like '" + objeto.getEstatusEmpGpo() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				// se modifica para que en el reporte muestre el nombre en lugar del Id, Sucursal agregado a partir de left join.. y otros 4 mas
				resultados = eDB.getQuery("select A.*, UG.Sucursal as SucursalGrupo, AG.Nombre as NombreArea, PG.Nombre as NombrePuesto, EG.NombreCompleto as JefeInmediato, EmG.Codigo as CodigoEmpresa from PersonasGeneral as A left join UbicacionesGrupo as UG on (UG.Id = A.IdUbicacionesGrupo) left join AreasGrupo as AG on (AG.Id = A.IdAreasGrupo) left join PuestosGrupo as PG on (PG.Id = A.IdPuestosGrupo) left join PersonasGeneral as EG on (EG.Id = A.IdEmpleadosGrupo) left join EmpresasGrupo as EmG on (Emg.Id = A.IdEmpresasGrupo)" + whereInicio + where.toString());
				ArrayList<PersonasGeneral> info = new ArrayList<PersonasGeneral>();
				while(resultados.next()) {
					objeto = new PersonasGeneral();
					objeto.setId(resultados.getInt("Id"));
					objeto.setEmpleado(resultados.getString("Empleado"));
					objeto.setNumEmpleado(resultados.getString("NumEmpleado"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setNSS(resultados.getString("NSS"));
					objeto.setRFC(resultados.getString("RFC"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setIdUbicacionesGrupo(resultados.getString("SucursalGrupo"));
					objeto.setIdAreasGrupo(resultados.getString("NombreArea"));
					objeto.setIdPuestosGrupo(resultados.getString("NombrePuesto"));
					objeto.setIdEmpleadosGrupo(resultados.getString("JefeInmediato"));
					objeto.setIdEmpresasGrupo(resultados.getString("CodigoEmpresa"));
					objeto.setSueldoBruto(resultados.getString("SueldoBruto"));
					// en caso de nos ser empleado se dejó una fecha fija, de ser encontrada el resultado en la tabla es en blanco, si no se entrega la fecha resultante
					if (resultados.getString("FechIngreso").equals("1951-01-01")){
						objeto.setFechIngreso("");
					} else {
						objeto.setFechIngreso(resultados.getString("FechIngreso"));
					}
					objeto.setFechaCump(resultados.getString("FechaCump"));
					objeto.setEstatusEmpGpo(resultados.getString("EstatusEmpGpo"));
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
						eDB.setQuery("insert into PersonasGeneralApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Empleado,NumEmpleado,NombreCompleto,NSS,RFC,CURP,IdUbicacionesGrupo,IdAreasGrupo,IdPuestosGrupo,IdEmpleadosGrupo,IdEmpresasGrupo,SueldoBruto,FechIngreso,FechaCump,EstatusEmpGpo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Empleado,NumEmpleado,NombreCompleto,NSS,RFC,CURP,IdUbicacionesGrupo,IdAreasGrupo,IdPuestosGrupo,IdEmpleadosGrupo,IdEmpresasGrupo,SueldoBruto,FechIngreso,FechaCump,EstatusEmpGpo from PersonasGeneral where Id = '" + id[i] + "'");
						eDB.setQuery("delete from PersonasGeneral where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new PersonasGeneral();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from PersonasGeneral as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new PersonasGeneral();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setEmpleado(resultados.getString("Empleado"));
					objeto.setNumEmpleado(resultados.getString("NumEmpleado"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setNSS(resultados.getString("NSS"));
					objeto.setRFC(resultados.getString("RFC"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setIdUbicacionesGrupo(resultados.getString("IdUbicacionesGrupo"));
					objeto.setIdAreasGrupo(resultados.getString("IdAreasGrupo"));
					objeto.setIdPuestosGrupo(resultados.getString("IdPuestosGrupo"));
					objeto.setIdEmpleadosGrupo(resultados.getString("IdEmpleadosGrupo"));
					objeto.setIdEmpresasGrupo(resultados.getString("IdEmpresasGrupo"));
					objeto.setSueldoBruto(resultados.getString("SueldoBruto"));
					objeto.setFechIngreso(resultados.getString("FechIngreso"));
					// CAMPO COMPUESTO POR COMBOS se agregaron al objeto los dos combos y con el siguiente proceso se llenan en la forma al querer modficar
					//objeto.setFechaCump(resultados.getString("FechaCump"));
					try {
					 String FechaCumple = resultados.getString("FechaCump");
					 String[] DiaMes = FechaCumple.split("/");
					 objeto.setDiaCumple(DiaMes[0]);
					 objeto.setMesCumple(DiaMes[1]);
					} catch(Exception e1234){						
					}
					objeto.setEstatusEmpGpo(resultados.getString("EstatusEmpGpo"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update PersonasGeneral set Empleado='" + request.getParameter("Empleado") + "',NumEmpleado='" + traducciones.getEntero(request.getParameter("NumEmpleado")) + "',NombreCompleto='" + request.getParameter("NombreCompleto") + "',NSS='" + request.getParameter("NSS") + "',RFC='" + request.getParameter("RFC") + "',CURP='" + request.getParameter("CURP") + "',IdUbicacionesGrupo='" + traducciones.getEntero(request.getParameter("IdUbicacionesGrupo")) + "',IdAreasGrupo='" + traducciones.getEntero(request.getParameter("IdAreasGrupo")) + "',IdPuestosGrupo='" + traducciones.getEntero(request.getParameter("IdPuestosGrupo")) + "',IdEmpleadosGrupo='" + traducciones.getEntero(request.getParameter("IdEmpleadosGrupo")) + "',IdEmpresasGrupo='" + traducciones.getEntero(request.getParameter("IdEmpresasGrupo")) + "',SueldoBruto='" + traducciones.getDecimal(request.getParameter("SueldoBruto")) + "',FechIngreso='" + traducciones.getFecha(request.getParameter("FechIngreso")) + "',FechaCump='" + request.getParameter("FechaCump") + "',EstatusEmpGpo='" + request.getParameter("EstatusEmpGpo") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into PersonasGeneralApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Empleado,NumEmpleado,NombreCompleto,NSS,RFC,CURP,IdUbicacionesGrupo,IdAreasGrupo,IdPuestosGrupo,IdEmpleadosGrupo,IdEmpresasGrupo,SueldoBruto,FechIngreso,FechaCump,EstatusEmpGpo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Empleado,NumEmpleado,NombreCompleto,NSS,RFC,CURP,IdUbicacionesGrupo,IdAreasGrupo,IdPuestosGrupo,IdEmpleadosGrupo,IdEmpresasGrupo,SueldoBruto,FechIngreso,FechaCump,EstatusEmpGpo from PersonasGeneral where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new PersonasGeneral();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setEmpleado(request.getParameter("Empleado"));
					objeto.setNumEmpleado(request.getParameter("NumEmpleado"));
					objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
					objeto.setNSS(request.getParameter("NSS"));
					objeto.setRFC(request.getParameter("RFC"));
					objeto.setCURP(request.getParameter("CURP"));
					objeto.setIdUbicacionesGrupo(request.getParameter("IdUbicacionesGrupo"));
					objeto.setIdAreasGrupo(request.getParameter("IdAreasGrupo"));
					objeto.setIdPuestosGrupo(request.getParameter("IdPuestosGrupo"));
					objeto.setIdEmpleadosGrupo(request.getParameter("IdEmpleadosGrupo"));
					objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
					objeto.setSueldoBruto(request.getParameter("SueldoBruto"));
					objeto.setFechIngreso(request.getParameter("FechIngreso"));
					objeto.setFechaCump(request.getParameter("FechaCump"));
					objeto.setEstatusEmpGpo(request.getParameter("EstatusEmpGpo"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getPersonasGeneral")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from PersonasGeneral where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<PersonasGeneral> info = new ArrayList<PersonasGeneral>();
				while(resultados.next()) {
					objeto = new PersonasGeneral();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getEmpleadosGrupo")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, NombreCompleto from PersonasGeneral where Empleado = 'SI' and EstatusEmpGpo = 'ACTIVO' and NombreCompleto like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<PersonasGeneral> info = new ArrayList<PersonasGeneral>();
				while(resultados.next()) {
					objeto = new PersonasGeneral();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("NombreCompleto"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new PersonasGeneral();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new PersonasGeneral();
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
	
	private void imprimeJson(HttpServletResponse response, PersonasGeneral objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<PersonasGeneral> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(PersonasGeneral objeto, Exception e) {
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
/* PersonasGeneralServlet */

