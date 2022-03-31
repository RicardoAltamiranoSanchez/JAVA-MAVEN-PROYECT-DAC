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
import Objetos.EmpresasVacaciones;

import com.google.gson.Gson;

public class EmpresasVacacionesServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3325981393895936228L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private EmpresasVacaciones objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public EmpresasVacacionesServlet() {
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
				eDB.setQuery("insert into EmpresasVacaciones (U,G,E,IdEmpresasGrupo,Ao,DiasLey,DiasExtra) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + traducciones.getEntero(request.getParameter("IdEmpresasGrupo")) + "','" + traducciones.getEntero(request.getParameter("Ao")) + "','" + traducciones.getEntero(request.getParameter("DiasLey")) + "','" + traducciones.getEntero(request.getParameter("DiasExtra")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into EmpresasVacacionesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdEmpresasGrupo,Ao,DiasLey,DiasExtra) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdEmpresasGrupo,Ao,DiasLey,DiasExtra from EmpresasVacaciones where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new EmpresasVacaciones();
				objeto.setId(ultimoId);
				objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
				objeto.setAo(request.getParameter("Ao"));
				objeto.setDiasLey(request.getParameter("DiasLey"));
				objeto.setDiasExtra(request.getParameter("DiasExtra"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id > 0 and E.Id = A.IdEmpresasGrupo";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new EmpresasVacaciones();
				objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
				objeto.setAo(request.getParameter("Ao"));
				objeto.setDiasLey(request.getParameter("DiasLey"));
				objeto.setDiasExtra(request.getParameter("DiasExtra"));

				if(!objeto.getIdEmpresasGrupo().equals("")) { where.append(" and A.IdEmpresasGrupo like '" + objeto.getIdEmpresasGrupo() + "%'"); entro = true;}
				if(!objeto.getAo().equals("")) { where.append(" and A.Ao like '" + objeto.getAo() + "%'"); entro = true;}
				if(!objeto.getDiasLey().equals("")) { where.append(" and A.DiasLey like '" + objeto.getDiasLey() + "%'"); entro = true;}
				if(!objeto.getDiasExtra().equals("")) { where.append(" and A.DiasExtra like '" + objeto.getDiasExtra() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0 and E.Id = A.IdEmpresasGrupo"; }
				
				resultados = eDB.getQuery("select A.*, E.Nombre from EmpresasVacaciones as A, EmpresasGrupo as E" + whereInicio + where.toString());
				ArrayList<EmpresasVacaciones> info = new ArrayList<EmpresasVacaciones>();
				while(resultados.next()) {
					objeto = new EmpresasVacaciones();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdEmpresasGrupo(resultados.getString("Nombre"));
					objeto.setAo(resultados.getString("Ao"));
					objeto.setDiasLey(resultados.getString("DiasLey"));
					objeto.setDiasExtra(resultados.getString("DiasExtra"));
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
						eDB.setQuery("insert into EmpresasVacacionesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdEmpresasGrupo,Ao,DiasLey,DiasExtra) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdEmpresasGrupo,Ao,DiasLey,DiasExtra from EmpresasVacaciones where Id = '" + id[i] + "'");
						eDB.setQuery("delete from EmpresasVacaciones where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new EmpresasVacaciones();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from EmpresasVacaciones as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new EmpresasVacaciones();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdEmpresasGrupo(resultados.getString("IdEmpresasGrupo"));
					objeto.setAo(resultados.getString("Ao"));
					objeto.setDiasLey(resultados.getString("DiasLey"));
					objeto.setDiasExtra(resultados.getString("DiasExtra"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update EmpresasVacaciones set IdEmpresasGrupo='" + traducciones.getEntero(request.getParameter("IdEmpresasGrupo")) + "',Ao='" + traducciones.getEntero(request.getParameter("Ao")) + "',DiasLey='" + traducciones.getEntero(request.getParameter("DiasLey")) + "',DiasExtra='" + traducciones.getEntero(request.getParameter("DiasExtra")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into EmpresasVacacionesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdEmpresasGrupo,Ao,DiasLey,DiasExtra) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdEmpresasGrupo,Ao,DiasLey,DiasExtra from EmpresasVacaciones where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new EmpresasVacaciones();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
					objeto.setAo(request.getParameter("Ao"));
					objeto.setDiasLey(request.getParameter("DiasLey"));
					objeto.setDiasExtra(request.getParameter("DiasExtra"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getEmpresasVacaciones")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from EmpresasVacaciones where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<EmpresasVacaciones> info = new ArrayList<EmpresasVacaciones>();
				while(resultados.next()) {
					objeto = new EmpresasVacaciones();
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
			objeto = new EmpresasVacaciones();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new EmpresasVacaciones();
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
	
	private void imprimeJson(HttpServletResponse response, EmpresasVacaciones objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<EmpresasVacaciones> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(EmpresasVacaciones objeto, Exception e) {
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
/* EmpresasVacacionesServlet */