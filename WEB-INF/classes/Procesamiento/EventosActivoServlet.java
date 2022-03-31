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
import Objetos.EventosActivo;

import com.google.gson.Gson;

public class EventosActivoServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4770246678874077488L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private EventosActivo objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public EventosActivoServlet() {
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
				eDB.setQuery("insert into EventosActivo (U,G,E,Descripcion,FechEvento,IdInventario) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Descripcion") + "','" + traducciones.getFecha(request.getParameter("FechEvento")) + "','" + traducciones.getEntero(request.getParameter("IdInventario")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into EventosActivoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Descripcion,FechEvento,IdInventario) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Descripcion,FechEvento,IdInventario from EventosActivo where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new EventosActivo();
				objeto.setId(ultimoId);
				objeto.setDescripcion(request.getParameter("Descripcion"));
				objeto.setFechEvento(request.getParameter("FechEvento"));
				objeto.setIdInventario(request.getParameter("IdInventario"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new EventosActivo();
				objeto.setDescripcion(request.getParameter("Descripcion"));
				objeto.setFechEvento(request.getParameter("FechEvento"));
				objeto.setIdInventario(request.getParameter("IdInventario"));

				if(!objeto.getDescripcion().equals("")) { where.append(" and A.Descripcion like '" + objeto.getDescripcion() + "%'"); entro = true;}
				if(!objeto.getFechEvento().equals("")) { where.append(" and A.FechEvento like '" + objeto.getFechEvento() + "%'"); entro = true;}
				if(!objeto.getIdInventario().equals("")) { where.append(" and A.IdInventario like '" + objeto.getIdInventario() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from EventosActivo as A" + whereInicio + where.toString());
				ArrayList<EventosActivo> info = new ArrayList<EventosActivo>();
				while(resultados.next()) {
					objeto = new EventosActivo();
					objeto.setId(resultados.getInt("Id"));
					objeto.setDescripcion(resultados.getString("Descripcion"));
					objeto.setFechEvento(resultados.getString("FechEvento"));
					objeto.setIdInventario(resultados.getString("IdInventario"));
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
						eDB.setQuery("insert into EventosActivoApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Descripcion,FechEvento,IdInventario) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Descripcion,FechEvento,IdInventario from EventosActivo where Id = '" + id[i] + "'");
						eDB.setQuery("delete from EventosActivo where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new EventosActivo();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from EventosActivo as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new EventosActivo();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setDescripcion(resultados.getString("Descripcion"));
					objeto.setFechEvento(resultados.getString("FechEvento"));
					objeto.setIdInventario(resultados.getString("IdInventario"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update EventosActivo set Descripcion='" + request.getParameter("Descripcion") + "',FechEvento='" + traducciones.getFecha(request.getParameter("FechEvento")) + "',IdInventario='" + traducciones.getEntero(request.getParameter("IdInventario")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into EventosActivoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Descripcion,FechEvento,IdInventario) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Descripcion,FechEvento,IdInventario from EventosActivo where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new EventosActivo();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setDescripcion(request.getParameter("Descripcion"));
					objeto.setFechEvento(request.getParameter("FechEvento"));
					objeto.setIdInventario(request.getParameter("IdInventario"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getEventosActivo")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from EventosActivo where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<EventosActivo> info = new ArrayList<EventosActivo>();
				while(resultados.next()) {
					objeto = new EventosActivo();
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
			objeto = new EventosActivo();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new EventosActivo();
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
	
	private void imprimeJson(HttpServletResponse response, EventosActivo objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<EventosActivo> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(EventosActivo objeto, Exception e) {
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
/* EventosActivoServlet */
