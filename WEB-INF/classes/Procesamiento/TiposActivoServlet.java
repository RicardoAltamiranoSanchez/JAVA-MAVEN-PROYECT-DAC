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
import Objetos.TiposActivo;

import com.google.gson.Gson;

public class TiposActivoServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3630557632480023923L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private TiposActivo objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public TiposActivoServlet() {
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
				eDB.setQuery("insert into TiposActivo (U,G,E,Nombre,IdClasificacionActivos,Plantilla) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Nombre") + "','" + traducciones.getEntero(request.getParameter("IdClasificacionActivos")) + "','" + request.getParameter("Plantilla") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into TiposActivoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,IdClasificacionActivos,Plantilla) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,IdClasificacionActivos,Plantilla from TiposActivo where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new TiposActivo();
				objeto.setId(ultimoId);
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setIdClasificacionActivos(request.getParameter("IdClasificacionActivos"));
				objeto.setPlantilla(request.getParameter("Plantilla"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new TiposActivo();
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setIdClasificacionActivos(request.getParameter("IdClasificacionActivos"));
				objeto.setPlantilla(request.getParameter("Plantilla"));

				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getIdClasificacionActivos().equals("")) { where.append(" and A.IdClasificacionActivos like '" + objeto.getIdClasificacionActivos() + "%'"); entro = true;}
				if(!objeto.getPlantilla().equals("")) { where.append(" and A.Plantilla like '" + objeto.getPlantilla() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				// se modifica para que en el reporte muestre el nombre en lugar del Id, codigo agregado a partir de left join..
				resultados = eDB.getQuery("select A.*, CA.Nombre as ClasificacionActivo from TiposActivo as A left join ClasificacionActivos as CA on (CA.Id = A.IdClasificacionActivos)" + whereInicio + where.toString());
				ArrayList<TiposActivo> info = new ArrayList<TiposActivo>();
				while(resultados.next()) {
					objeto = new TiposActivo();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setIdClasificacionActivos(resultados.getString("ClasificacionActivo"));
					objeto.setPlantilla(resultados.getString("Plantilla"));
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
						eDB.setQuery("insert into TiposActivoApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Nombre,IdClasificacionActivos,Plantilla) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Nombre,IdClasificacionActivos,Plantilla from TiposActivo where Id = '" + id[i] + "'");
						eDB.setQuery("delete from TiposActivo where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new TiposActivo();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from TiposActivo as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new TiposActivo();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setIdClasificacionActivos(resultados.getString("IdClasificacionActivos"));
					objeto.setPlantilla(resultados.getString("Plantilla"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update TiposActivo set Nombre='" + request.getParameter("Nombre") + "',IdClasificacionActivos='" + traducciones.getEntero(request.getParameter("IdClasificacionActivos")) + "',Plantilla='" + request.getParameter("Plantilla") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into TiposActivoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,IdClasificacionActivos,Plantilla) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,IdClasificacionActivos,Plantilla from TiposActivo where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new TiposActivo();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setIdClasificacionActivos(request.getParameter("IdClasificacionActivos"));
					objeto.setPlantilla(request.getParameter("Plantilla"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getTiposActivo")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from TiposActivo where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<TiposActivo> info = new ArrayList<TiposActivo>();
				while(resultados.next()) {
					objeto = new TiposActivo();
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
			objeto = new TiposActivo();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new TiposActivo();
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
	
	private void imprimeJson(HttpServletResponse response, TiposActivo objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<TiposActivo> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(TiposActivo objeto, Exception e) {
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
/* TiposActivoServlet */