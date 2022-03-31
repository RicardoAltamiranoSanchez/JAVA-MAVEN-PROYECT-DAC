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
import Objetos.Directorio;

import com.google.gson.Gson;

public class DirectorioServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8246193413371203857L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Directorio objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public DirectorioServlet() {
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
				eDB.setQuery("insert into Directorio (U,G,E,Nombre,Puesto,Division,Estacion,Telefono,Nextel,IdNextel,Correo) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Puesto") + "','" + request.getParameter("Division") + "','" + request.getParameter("Estacion") + "','" + request.getParameter("Telefono") + "','" + request.getParameter("Nextel") + "','" + request.getParameter("IdNextel") + "','" + request.getParameter("Correo") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into DirectorioApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Puesto,Division,Estacion,Telefono,Nextel,IdNextel,Correo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Puesto,Division,Estacion,Telefono,Nextel,IdNextel,Correo from Directorio where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Directorio();
				objeto.setId(ultimoId);
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setPuesto(request.getParameter("Puesto"));
				objeto.setDivision(request.getParameter("Division"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setTelefono(request.getParameter("Telefono"));
				objeto.setNextel(request.getParameter("Nextel"));
				objeto.setIdNextel(request.getParameter("IdNextel"));
				objeto.setCorreo(request.getParameter("Correo"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Directorio();
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setPuesto(request.getParameter("Puesto"));
				objeto.setDivision(request.getParameter("Division"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setTelefono(request.getParameter("Telefono"));
				objeto.setNextel(request.getParameter("Nextel"));
				objeto.setIdNextel(request.getParameter("IdNextel"));
				objeto.setCorreo(request.getParameter("Correo"));

				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getPuesto().equals("")) { where.append(" and A.Puesto like '" + objeto.getPuesto() + "%'"); entro = true;}
				if(!objeto.getDivision().equals("")) { where.append(" and A.Division like '" + objeto.getDivision() + "%'"); entro = true;}
				if(!objeto.getEstacion().equals("")) { where.append(" and A.Estacion like '" + objeto.getEstacion() + "%'"); entro = true;}
				if(!objeto.getTelefono().equals("")) { where.append(" and A.Telefono like '" + objeto.getTelefono() + "%'"); entro = true;}
				if(!objeto.getNextel().equals("")) { where.append(" and A.Nextel like '" + objeto.getNextel() + "%'"); entro = true;}
				if(!objeto.getIdNextel().equals("")) { where.append(" and A.IdNextel like '" + objeto.getIdNextel() + "%'"); entro = true;}
				if(!objeto.getCorreo().equals("")) { where.append(" and A.Correo like '" + objeto.getCorreo() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from Directorio as A" + whereInicio + where.toString());
				ArrayList<Directorio> info = new ArrayList<Directorio>();
				while(resultados.next()) {
					objeto = new Directorio();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setDivision(resultados.getString("Division"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setTelefono(resultados.getString("Telefono"));
					objeto.setNextel(resultados.getString("Nextel"));
					objeto.setIdNextel(resultados.getString("IdNextel"));
					objeto.setCorreo(resultados.getString("Correo"));
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
						eDB.setQuery("insert into DirectorioApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Nombre,Puesto,Division,Estacion,Telefono,Nextel,IdNextel,Correo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Nombre,Puesto,Division,Estacion,Telefono,Nextel,IdNextel,Correo from Directorio where Id = '" + id[i] + "'");
						eDB.setQuery("delete from Directorio where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Directorio();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from Directorio as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new Directorio();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setDivision(resultados.getString("Division"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setTelefono(resultados.getString("Telefono"));
					objeto.setNextel(resultados.getString("Nextel"));
					objeto.setIdNextel(resultados.getString("IdNextel"));
					objeto.setCorreo(resultados.getString("Correo"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update Directorio set Nombre='" + request.getParameter("Nombre") + "',Puesto='" + request.getParameter("Puesto") + "',Division='" + request.getParameter("Division") + "',Estacion='" + request.getParameter("Estacion") + "',Telefono='" + request.getParameter("Telefono") + "',Nextel='" + request.getParameter("Nextel") + "',IdNextel='" + request.getParameter("IdNextel") + "',Correo='" + request.getParameter("Correo") + "' where Id = '" + request.getParameter("id") + "'");
				System.out.println("update Directorio set Nombre='" + request.getParameter("Nombre") + "',Puesto='" + request.getParameter("Puesto") + "',Division='" + request.getParameter("Division") + "',Estacion='" + request.getParameter("Estacion") + "',Telefono='" + request.getParameter("Telefono") + "',Nextel='" + request.getParameter("Nextel") + "',IdNextel='" + request.getParameter("IdNextel") + "',Correo='" + request.getParameter("Correo") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into DirectorioApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Puesto,Division,Estacion,Telefono,Nextel,IdNextel,Correo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Puesto,Division,Estacion,Telefono,Nextel,IdNextel,Correo from Directorio where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Directorio();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setPuesto(request.getParameter("Puesto"));
					objeto.setDivision(request.getParameter("Division"));
					objeto.setEstacion(request.getParameter("Estacion"));
					objeto.setTelefono(request.getParameter("Telefono"));
					objeto.setNextel(request.getParameter("Nextel"));
					objeto.setIdNextel(request.getParameter("IdNextel"));
					objeto.setCorreo(request.getParameter("Correo"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getDirectorio")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from Directorio where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<Directorio> info = new ArrayList<Directorio>();
				while(resultados.next()) {
					objeto = new Directorio();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("BuscarInfo")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id,Puesto,Division,Estacion from Credenciales where NombreCompleto = '" + request.getParameter("Nombre") + "'");
				objeto = new Directorio();
				while(resultados.next()) {
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setDivision(resultados.getString("Division"));
					objeto.setEstacion(resultados.getString("Estacion"));
				}
				if(request.getParameter("id") != ""){
					resultados = eDB.getQuery("select A.* from Directorio as A where A.Id = '" + request.getParameter("id") + "'");
					while(resultados.next()) {
						objeto.setId(resultados.getInt("Id"));
						objeto.setTelefono(resultados.getString("Telefono"));
						objeto.setNextel(resultados.getString("Nextel"));
						objeto.setIdNextel(resultados.getString("IdNextel"));
						objeto.setCorreo(resultados.getString("Correo"));
					}
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				imprimeJson(response,objeto);
			}
		} catch(SQLException e) {
			objeto = new Directorio();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Directorio();
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
	
	private void imprimeJson(HttpServletResponse response, Directorio objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Directorio> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Directorio objeto, Exception e) {
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
/* DirectorioServlet */