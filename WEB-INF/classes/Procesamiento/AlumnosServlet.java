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
import Objetos.Alumnos;

import com.google.gson.Gson;

public class AlumnosServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7105718919691391621L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Alumnos objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public AlumnosServlet() {
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
				eDB.setQuery("insert into Alumnos (U,G,E,Nombre,Telefono,Empresa,Estacion,Departamento,Puesto) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Nombre") + "','" + traducciones.getEntero(request.getParameter("Telefono")) + "','" + request.getParameter("Empresa") + "','" + request.getParameter("Estacion") + "','" + request.getParameter("Departamento") + "','" + request.getParameter("Puesto") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into AlumnosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Telefono,Empresa,Estacion,Departamento,Puesto) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Telefono,Empresa,Estacion,Departamento,Puesto from Alumnos where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Alumnos();
				objeto.setId(ultimoId);
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setTelefono(request.getParameter("Telefono"));
				objeto.setEmpresa(request.getParameter("Empresa"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setDepartamento(request.getParameter("Departamento"));
				objeto.setPuesto(request.getParameter("Puesto"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Alumnos();
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setTelefono(request.getParameter("Telefono"));
				objeto.setEmpresa(request.getParameter("Empresa"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setDepartamento(request.getParameter("Departamento"));
				objeto.setPuesto(request.getParameter("Puesto"));

				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getTelefono().equals("")) { where.append(" and A.Telefono like '" + objeto.getTelefono() + "%'"); entro = true;}
				if(!objeto.getEmpresa().equals("")) { where.append(" and A.Empresa like '" + objeto.getEmpresa() + "%'"); entro = true;}
				if(!objeto.getEstacion().equals("")) { where.append(" and A.Estacion like '" + objeto.getEstacion() + "%'"); entro = true;}
				if(!objeto.getDepartamento().equals("")) { where.append(" and A.Departamento like '" + objeto.getDepartamento() + "%'"); entro = true;}
				if(!objeto.getPuesto().equals("")) { where.append(" and A.Puesto like '" + objeto.getPuesto() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from Alumnos as A" + whereInicio + where.toString());
				ArrayList<Alumnos> info = new ArrayList<Alumnos>();
				while(resultados.next()) {
					objeto = new Alumnos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setTelefono(resultados.getString("Telefono"));
					objeto.setEmpresa(resultados.getString("Empresa"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setDepartamento(resultados.getString("Departamento"));
					objeto.setPuesto(resultados.getString("Puesto"));
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
						eDB.setQuery("insert into AlumnosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Nombre,Telefono,Empresa,Estacion,Departamento,Puesto) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Nombre,Telefono,Empresa,Estacion,Departamento,Puesto from Alumnos where Id = '" + id[i] + "'");
						eDB.setQuery("delete from Alumnos where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Alumnos();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from Alumnos as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new Alumnos();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setTelefono(resultados.getString("Telefono"));
					objeto.setEmpresa(resultados.getString("Empresa"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setDepartamento(resultados.getString("Departamento"));
					objeto.setPuesto(resultados.getString("Puesto"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update Alumnos set Nombre='" + request.getParameter("Nombre") + "',Telefono='" + traducciones.getEntero(request.getParameter("Telefono")) + "',Empresa='" + request.getParameter("Empresa") + "',Estacion='" + request.getParameter("Estacion") + "',Departamento='" + request.getParameter("Departamento") + "',Puesto='" + request.getParameter("Puesto") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into AlumnosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Telefono,Empresa,Estacion,Departamento,Puesto) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Telefono,Empresa,Estacion,Departamento,Puesto from Alumnos where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Alumnos();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setTelefono(request.getParameter("Telefono"));
					objeto.setEmpresa(request.getParameter("Empresa"));
					objeto.setEstacion(request.getParameter("Estacion"));
					objeto.setDepartamento(request.getParameter("Departamento"));
					objeto.setPuesto(request.getParameter("Puesto"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getAlumnos")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, Nombre from Alumnos where Nombre like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<Alumnos> info = new ArrayList<Alumnos>();
				while(resultados.next()) {
					objeto = new Alumnos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("Nombre"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new Alumnos();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Alumnos();
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
	
	private void imprimeJson(HttpServletResponse response, Alumnos objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Alumnos> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Alumnos objeto, Exception e) {
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
/* AlumnosServlet */