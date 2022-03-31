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
import Objetos.Banner;
import Objetos.BannerCategoriaFirma;
import Objetos.PuestosGrupo;

import com.google.gson.Gson;

public class BannerCategoriaFirmaServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1713396351321225457L;
	/**
	 * 
	 */

	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private BannerCategoriaFirma objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;
	
	public BannerCategoriaFirmaServlet() {
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
				eDB.setQuery("insert into BannerCategoriaFirma (U,G,E,CategoriaFirma,Archivo) select '" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "',GrupoEmpleados,concat(GrupoEmpleados,'.png') from FirmasGrupos where Id = '" + request.getParameter("CategoriaFirma") + "'");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into BannerCategoriaFirmaApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,CategoriaFirma,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,CategoriaFirma,Archivo from BannerCategoriaFirma where Id = '" + ultimoId + "'");
				resultados = eDB.getQuery("Select * from BannerCategoriaFirma where Id ='" + ultimoId + "'");
				
				
				objeto = new BannerCategoriaFirma();
				objeto.setId(ultimoId);
				resultados.next();
				objeto.setCategoriaFirma(resultados.getString("CategoriaFirma"));
				objeto.setArchivo(resultados.getString("Archivo"));
				
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new BannerCategoriaFirma();
				objeto.setCategoriaFirma(request.getParameter("CategoriaFirma"));
				objeto.setArchivo(request.getParameter("Archivo"));

				if(!objeto.getCategoriaFirma().equals("")) { where.append(" and A.CategoriaFirma like '" + objeto.getCategoriaFirma() + "%'"); entro = true;}
				//if(!objeto.getArchivo().equals("")) { where.append(" and A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from BannerCategoriaFirma as A" + whereInicio + where.toString() + " Group by A.CategoriaFirma");
				ArrayList<BannerCategoriaFirma> info = new ArrayList<BannerCategoriaFirma>();
				while(resultados.next()) {
					System.out.println(entro);
					objeto = new BannerCategoriaFirma();
					objeto.setId(resultados.getInt("Id"));
					objeto.setCategoriaFirma(resultados.getString("CategoriaFirma"));
					objeto.setArchivo(resultados.getString("Archivo"));
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
						eDB.setQuery("insert into BannerCategoriaFirmaApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,CategoriaFirma,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,CategoriaFirma,Archivo from BannerCategoriaFirma where Id = '" + id[i] + "'");
						eDB.setQuery("delete from BannerCategoriaFirma where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new BannerCategoriaFirma();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from BannerCategoriaFirma as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new BannerCategoriaFirma();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setCategoriaFirma(resultados.getString("CategoriaFirma"));
					objeto.setArchivo(resultados.getString("Archivo"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update BannerCategoriaFirma set Sitio='" + request.getParameter("CategoriaFirma") + "',Archivo='" + request.getParameter("Archivo") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into BannerCategoriaFirmaApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,CategoriaFirma,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,CategoriaFirma,Archivo from BannerCategoriaFirma where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new BannerCategoriaFirma();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setCategoriaFirma(request.getParameter("CategoriaFirma"));
					objeto.setArchivo(request.getParameter("Archivo"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getBannerCategoriaFirma")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from BannerCategoriaFirma where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<BannerCategoriaFirma> info = new ArrayList<BannerCategoriaFirma>();
				while(resultados.next()) {
					objeto = new BannerCategoriaFirma();
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
			objeto = new BannerCategoriaFirma();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new BannerCategoriaFirma();
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
	
	private void imprimeJson(HttpServletResponse response, BannerCategoriaFirma objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<BannerCategoriaFirma> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(BannerCategoriaFirma objeto, Exception e) {
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
/* BannerCategoriaFirmaServlet */
