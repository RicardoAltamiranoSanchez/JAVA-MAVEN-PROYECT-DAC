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
import Objetos.FirmasPersonal;

import com.google.gson.Gson;

public class FirmasPersonalServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5430705988490280536L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private FirmasPersonal objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;
	public FirmasPersonalServlet() {
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
				eDB.setQuery("insert into FirmasPersonal (U,G,E,IdFirmas,IdEmpleados) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("IdFirmas") + "','" + request.getParameter("IdEmpleados") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into FirmasPersonalApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdFirmas,IdEmpleados) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdFirmas,IdEmpleados from FirmasPersonal where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new FirmasPersonal();
				objeto.setId(ultimoId);
				objeto.setIdFirmas(request.getParameter("IdFirmas"));
				objeto.setIdEmpleados(request.getParameter("IdEmpleados"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new FirmasPersonal();
				objeto.setIdFirmas(request.getParameter("IdFirmas"));
				objeto.setIdEmpleados(request.getParameter("IdEmpleados"));

				//if(!objeto.getIdFirmas().equals("")) { where.append(" and A.IdFirmas like '" + objeto.getIdFirmas() + "%'"); entro = true;}
				if(!objeto.getIdFirmas().equals("")) { where.append(" and A.IdFirmas like '" + objeto.getIdFirmas() + "'"); entro = true;}
				if(!objeto.getIdEmpleados().equals("")) { where.append(" and A.IdEmpleados like '" + objeto.getIdEmpleados() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.*, E.NombreCompleto as Empleado, F.NombreFirma as Firma from FirmasPersonal as A left join Empleados as E on (E.Id = A.IdEmpleados) left join Firmas as F on (F.Id = A.IdFirmas)" + whereInicio + where.toString());
				ArrayList<FirmasPersonal> info = new ArrayList<FirmasPersonal>();
				while(resultados.next()) {
					objeto = new FirmasPersonal();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdFirmas(resultados.getString("Firma"));
					objeto.setIdEmpleados(resultados.getString("Empleado"));
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
						eDB.setQuery("insert into FirmasPersonalApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdFirmas,IdEmpleados) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdFirmas,IdEmpleados from FirmasPersonal where Id = '" + id[i] + "'");
						eDB.setQuery("delete from FirmasPersonal where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new FirmasPersonal();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from FirmasPersonal as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new FirmasPersonal();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdFirmas(resultados.getString("IdFirmas"));
					objeto.setIdEmpleados(resultados.getString("IdEmpleados"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update FirmasPersonal set IdFirmas='" + request.getParameter("IdFirmas") + "',IdEmpleados='" + request.getParameter("IdEmpleados") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into FirmasPersonalApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdFirmas,IdEmpleados) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdFirmas,IdEmpleados from FirmasPersonal where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new FirmasPersonal();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setIdFirmas(request.getParameter("IdFirmas"));
					objeto.setIdEmpleados(request.getParameter("IdEmpleados"));
				imprimeJson(response,objeto);
			}
			// COMBO acción que hace consulta para llenar combo
			else if(request.getParameter("Accion").equals("getFirmasPersonal")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, IdFirmas,IdEmpleados from FirmasPersonal where IdFirmas like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<FirmasPersonal> info = new ArrayList<FirmasPersonal>();
				while(resultados.next()) {
					objeto = new FirmasPersonal();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("IdFirmas"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new FirmasPersonal();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new FirmasPersonal();
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
	
	private void imprimeJson(HttpServletResponse response, FirmasPersonal objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<FirmasPersonal> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(FirmasPersonal objeto, Exception e) {
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
/* FirmasPersonalServlet */