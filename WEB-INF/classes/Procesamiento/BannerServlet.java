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

import com.google.gson.Gson;

public class BannerServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5883295508236210199L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Banner objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public BannerServlet() {
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
				eDB.setQuery("insert into Banner (U,G,E,Sitio,Posicion,Archivo,Ocultar,Link) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Sitio") + "','" + request.getParameter("Posicion") + "','" + request.getParameter("Archivo") + "','" + request.getParameter("Ocultar") + "','" + request.getParameter("Link") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into BannerApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Sitio,Posicion,Archivo,Ocultar,Link) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Sitio,Posicion,Archivo,Ocultar,Link from Banner where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Banner();
				objeto.setId(ultimoId);
				objeto.setSitio(request.getParameter("Sitio"));
				objeto.setPosicion(request.getParameter("Posicion"));
				objeto.setArchivo(request.getParameter("Archivo"));
				objeto.setOcultar(request.getParameter("Ocultar"));
				objeto.setLink(request.getParameter("Link"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Banner();
				objeto.setSitio(request.getParameter("Sitio"));
				objeto.setPosicion(request.getParameter("Posicion"));
				objeto.setArchivo(request.getParameter("Archivo"));
				objeto.setOcultar(request.getParameter("Ocultar"));
				objeto.setLink(request.getParameter("Link"));

				if(!objeto.getSitio().equals("")) { where.append(" and A.Sitio = '" + objeto.getSitio() + "'"); entro = true;}
				if(!objeto.getPosicion().equals("")) { where.append(" and A.Posicion like '" + objeto.getPosicion() + "%'"); entro = true;}
				if(!objeto.getArchivo().equals("")) { where.append(" and A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true;}
				if(!objeto.getOcultar().equals("")) { where.append(" and A.Ocultar like '" + objeto.getOcultar() + "%'"); entro = true;}
				if(!objeto.getLink().equals("")) { where.append(" and A.Link like '" + objeto.getLink() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.*,P.Posicion as Pos from Banner as A left join Posicion as P on(P.Id = A.Posicion)" + whereInicio + where.toString() + " order by A.Posicion, A.Archivo");
				ArrayList<Banner> info = new ArrayList<Banner>();
				while(resultados.next()) {
					objeto = new Banner();
					objeto.setId(resultados.getInt("Id"));
					objeto.setSitio(resultados.getString("Sitio"));
					objeto.setPosicion(resultados.getString("Pos"));
					objeto.setArchivo(resultados.getString("Archivo"));
					objeto.setOcultar(resultados.getString("Ocultar"));
					objeto.setLink(resultados.getString("Link"));
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
						eDB.setQuery("insert into BannerApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Sitio,Posicion,Archivo,Ocultar,Link) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Sitio,Posicion,Archivo,Ocultar,Link from Banner where Id = '" + id[i] + "'");
						eDB.setQuery("delete from Banner where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Banner();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from Banner as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new Banner();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setSitio(resultados.getString("Sitio"));
					objeto.setPosicion(resultados.getString("Posicion"));
					objeto.setArchivo(resultados.getString("Archivo"));
					objeto.setOcultar(resultados.getString("Ocultar"));
					objeto.setLink(resultados.getString("Link"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update Banner set Sitio='" + request.getParameter("Sitio") + "',Posicion='" + request.getParameter("Posicion") + "',Archivo='" + request.getParameter("Archivo") + "',Ocultar='" + request.getParameter("Ocultar") + "',Link='" + request.getParameter("Link") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into BannerApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Sitio,Posicion,Archivo,Ocultar,Link) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Sitio,Posicion,Archivo,Ocultar,Link from Banner where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Banner();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setSitio(request.getParameter("Sitio"));
					objeto.setPosicion(request.getParameter("Posicion"));
					objeto.setArchivo(request.getParameter("Archivo"));
					objeto.setOcultar(request.getParameter("Ocultar"));
					objeto.setLink(request.getParameter("Link"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getBanner")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from Banner where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<Banner> info = new ArrayList<Banner>();
				while(resultados.next()) {
					objeto = new Banner();
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
			objeto = new Banner();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Banner();
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
	
	private void imprimeJson(HttpServletResponse response, Banner objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Banner> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Banner objeto, Exception e) {
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
/* BannerServlet */
