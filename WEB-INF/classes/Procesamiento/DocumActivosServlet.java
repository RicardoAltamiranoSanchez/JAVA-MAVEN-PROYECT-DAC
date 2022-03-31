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
import Objetos.DocumActivos;

import com.google.gson.Gson;

public class DocumActivosServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8003339215633779378L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private DocumActivos objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public DocumActivosServlet() {
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
				eDB.setQuery("insert into DocumActivos (U,G,E,Nombre,Factura,IdInventario) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Factura") + "','" + traducciones.getEntero(request.getParameter("IdInventario")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into DocumActivosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Factura,IdInventario) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Factura,IdInventario from DocumActivos where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new DocumActivos();
				objeto.setId(ultimoId);
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setFactura(request.getParameter("Factura"));
				objeto.setIdInventario(request.getParameter("IdInventario"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new DocumActivos();
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setFactura(request.getParameter("Factura"));
				objeto.setIdInventario(request.getParameter("IdInventario"));

				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getFactura().equals("")) { where.append(" and A.Factura like '" + objeto.getFactura() + "%'"); entro = true;}
				if(!objeto.getIdInventario().equals("")) { where.append(" and A.IdInventario like '" + objeto.getIdInventario() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from DocumActivos as A" + whereInicio + where.toString());
				ArrayList<DocumActivos> info = new ArrayList<DocumActivos>();
				while(resultados.next()) {
					objeto = new DocumActivos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setFactura(resultados.getString("Factura"));
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
						eDB.setQuery("insert into DocumActivosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Nombre,Factura,IdInventario) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Nombre,Factura,IdInventario from DocumActivos where Id = '" + id[i] + "'");
						eDB.setQuery("delete from DocumActivos where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new DocumActivos();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from DocumActivos as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new DocumActivos();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setFactura(resultados.getString("Factura"));
					objeto.setIdInventario(resultados.getString("IdInventario"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update DocumActivos set Nombre='" + request.getParameter("Nombre") + "',Factura='" + request.getParameter("Factura") + "',IdInventario='" + traducciones.getEntero(request.getParameter("IdInventario")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into DocumActivosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Factura,IdInventario) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Factura,IdInventario from DocumActivos where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new DocumActivos();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setFactura(request.getParameter("Factura"));
					objeto.setIdInventario(request.getParameter("IdInventario"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getDocumActivos")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from DocumActivos where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<DocumActivos> info = new ArrayList<DocumActivos>();
				while(resultados.next()) {
					objeto = new DocumActivos();
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
			objeto = new DocumActivos();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new DocumActivos();
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
	
	private void imprimeJson(HttpServletResponse response, DocumActivos objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<DocumActivos> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(DocumActivos objeto, Exception e) {
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
/* DocumActivosServlet */