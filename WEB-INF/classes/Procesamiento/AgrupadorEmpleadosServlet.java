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
import Objetos.AgrupadorEmpleados;
import Objetos.PuestosGrupo;

import com.google.gson.Gson;

public class AgrupadorEmpleadosServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4570247284998095992L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private AgrupadorEmpleados objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public AgrupadorEmpleadosServlet() {
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
				eDB.setQuery("insert into AgrupadorEmpleados (U,G,E,GrupoEmpleados,IdEmpleados) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("GrupoEmpleados") + "','" + traducciones.getEntero(request.getParameter("IdEmpleados")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into AgrupadorEmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,GrupoEmpleados,IdEmpleados) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,GrupoEmpleados,IdEmpleados from AgrupadorEmpleados where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new AgrupadorEmpleados();
				objeto.setId(ultimoId);
				objeto.setGrupoEmpleados(request.getParameter("GrupoEmpleados"));
				objeto.setIdEmpleados(request.getParameter("IdEmpleados"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where AE.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new AgrupadorEmpleados();
				objeto.setGrupoEmpleados(request.getParameter("GrupoEmpleados"));
				objeto.setIdEmpleados(request.getParameter("IdEmpleados"));

				if(!objeto.getGrupoEmpleados().equals("")) { where.append(" and AE.GrupoEmpleados like '" + objeto.getGrupoEmpleados() + "%'"); entro = true;}
				if(!objeto.getIdEmpleados().equals("")) { where.append(" and AE.IdEmpleados like '" + objeto.getIdEmpleados() + "%'"); entro = true;}
				if(entro) { whereInicio = " where AE.Id > 0"; }
				
				// se modifica para que en el reporte muestre el nombre en lugar del Id, codigo agregado a partir de left join..
				resultados = eDB.getQuery("select AE.*, E.NombreCompleto as NombreEmpleado from AgrupadorEmpleados as AE left join Empleados as E on (E.Id = AE.IdEmpleados)" + whereInicio + where.toString());
				ArrayList<AgrupadorEmpleados> info = new ArrayList<AgrupadorEmpleados>();
				while(resultados.next()) {
					objeto = new AgrupadorEmpleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setGrupoEmpleados(resultados.getString("GrupoEmpleados"));
					//objeto.setIdAreasGrupo(resultados.getString("IdAreasGrupo")); linea por default, se cambia por la de abajo para que aparezca el nombre en lugar del Id
					objeto.setIdEmpleados(resultados.getString("NombreEmpleado"));
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
						eDB.setQuery("insert into AgrupadorEmpleadosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,GrupoEmpleados,IdEmpleados) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,GrupoEmpleados,IdEmpleados from AgrupadorEmpleados where Id = '" + id[i] + "'");
						eDB.setQuery("delete from AgrupadorEmpleados where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new AgrupadorEmpleados();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from AgrupadorEmpleados as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new AgrupadorEmpleados();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setGrupoEmpleados(resultados.getString("GrupoEmpleados"));
					objeto.setIdEmpleados(resultados.getString("IdEmpleados"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update AgrupadorEmpleados set GrupoEmpleados='" + request.getParameter("GrupoEmpleados") + "',IdEmpleados='" + traducciones.getEntero(request.getParameter("IdEmpleados")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into AgrupadorEmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,GrupoEmpleados,IdEmpleados) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,GrupoEmpleados,IdEmpleados from AgrupadorEmpleados where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new AgrupadorEmpleados();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setGrupoEmpleados(request.getParameter("GrupoEmpleados"));
					objeto.setIdEmpleados(request.getParameter("IdEmpleados"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getAgrupadorEmpleados")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, GrupoEmpleados from AgrupadorEmpleados where GrupoEmpleados like '" + request.getParameter("filter[value]") + "%' group by GrupoEmpleados");
				ArrayList<AgrupadorEmpleados> info = new ArrayList<AgrupadorEmpleados>();
				while(resultados.next()) {
					objeto = new AgrupadorEmpleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setGrupoEmpleados(resultados.getString("GrupoEmpleados"));
					objeto.setValue(resultados.getString("GrupoEmpleados"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getAgrupadorEmpleadosNoExistentes")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, GrupoEmpleados from AgrupadorEmpleados where GrupoEmpleados like '" + request.getParameter("filter[value]") + "%'and Not GrupoEmpleados In (select GrupoEmpleados from FirmasGrupos) group by GrupoEmpleados");
				ArrayList<AgrupadorEmpleados> info = new ArrayList<AgrupadorEmpleados>();
				while(resultados.next()) {
					objeto = new AgrupadorEmpleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("GrupoEmpleados"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			// COMBO DEPENDIENTE agrego un nuevo método que llenará los datos exclusivos pertenecientes a otra selección previa
			else if(request.getParameter("Accion").equals("getAgrupadorEmpleadosDeArea")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, GrupoEmpleados from AgrupadorEmpleados where IdEmpleados ='" + request.getParameter("filter[value]")+"'");
				ArrayList<AgrupadorEmpleados> info = new ArrayList<AgrupadorEmpleados>();
				while(resultados.next()) {
					objeto = new AgrupadorEmpleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("GrupoEmpleados"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new AgrupadorEmpleados();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new AgrupadorEmpleados();
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
	
	private void imprimeJson(HttpServletResponse response, AgrupadorEmpleados objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<AgrupadorEmpleados> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(AgrupadorEmpleados objeto, Exception e) {
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
/* AgrupadorEmpleadosServlet */