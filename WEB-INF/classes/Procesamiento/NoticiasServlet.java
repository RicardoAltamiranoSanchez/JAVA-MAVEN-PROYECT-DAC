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
import Objetos.Noticias; 

import com.google.gson.Gson;

public class NoticiasServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8673827518512598524L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Noticias objeto;
	private Gson gson;
	private Fechas fechas;
	
	String Admon = "";

	public NoticiasServlet() {
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
			
			eDB.setConexion();			
			resultados = eDB.getQuery("select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "')");
			resultados.next();
			Admon = resultados.getString("Admon");
			eDB.setCerrar();
			eDB.setCerrarConexion();
			System.out.println("Se interactuará con las Noticias de "+Admon);
			
			if(request.getParameter("Accion").equals("Guardar")) {
				String nombre = request.getParameter("Archivo");
				nombre = nombre.replaceAll(" ","_");
				eDB.setConexion();
				if (Admon.equals("MEX")){
					eDB.setQuery("insert into Noticias (U,G,E,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Fecha") + "','" + request.getParameter("Titulo") + "','" + nombre + "','" + request.getParameter("Resumen") + "','" + request.getParameter("Noticia") + "','" + request.getParameter("Ocultar") + "')");
					ultimoId = eDB.getUltimoId();
					eDB.setQuery("insert into NoticiasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar from Noticias where Id = '" + ultimoId + "'");
				}else{
					eDB.setQuery("insert into NoticiasGdl (U,G,E,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Fecha") + "','" + request.getParameter("Titulo") + "','" + nombre + "','" + request.getParameter("Resumen") + "','" + request.getParameter("Noticia") + "','" + request.getParameter("Ocultar") + "')");
					ultimoId = eDB.getUltimoId();
					eDB.setQuery("insert into NoticiasGdlApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar from NoticiasGdl where Id = '" + ultimoId + "'");
				}				
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Noticias();
				objeto.setId(ultimoId);
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setTitulo(request.getParameter("Titulo"));
				objeto.setArchivo(request.getParameter("Archivo"));
				objeto.setResumen(request.getParameter("Resumen"));
				objeto.setNoticia(request.getParameter("Noticia"));
				objeto.setOcultar(request.getParameter("Ocultar"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Noticias();
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setTitulo(request.getParameter("Titulo"));
				objeto.setArchivo(request.getParameter("Archivo"));
				objeto.setResumen(request.getParameter("Resumen"));
				objeto.setNoticia(request.getParameter("Noticia"));
				objeto.setOcultar(request.getParameter("Ocultar"));

				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha like '" + objeto.getFecha() + "%'"); entro = true;}
				if(!objeto.getTitulo().equals("")) { where.append(" and A.Titulo like '" + objeto.getTitulo() + "%'"); entro = true;}
				if(!objeto.getArchivo().equals("")) { where.append(" and A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true;}
				if(!objeto.getResumen().equals("")) { where.append(" and A.Resumen like '" + objeto.getResumen() + "%'"); entro = true;}
				if(!objeto.getNoticia().equals("")) { where.append(" and A.Noticia like '" + objeto.getNoticia() + "%'"); entro = true;}
				if(!objeto.getOcultar().equals("")) { where.append(" and A.Ocultar like '" + objeto.getOcultar() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select A.* from Noticias as A" + whereInicio + where.toString());
				}else{
					resultados = eDB.getQuery("select A.* from NoticiasGdl as A" + whereInicio + where.toString());
				}				
				ArrayList<Noticias> info = new ArrayList<Noticias>();
				while(resultados.next()) {
					objeto = new Noticias();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setTitulo(resultados.getString("Titulo"));
					objeto.setArchivo(resultados.getString("Archivo"));
					objeto.setResumen(resultados.getString("Resumen"));
					objeto.setNoticia(resultados.getString("Noticia"));
					objeto.setOcultar(resultados.getString("Ocultar"));
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
						if (Admon.equals("MEX")){
							eDB.setQuery("insert into NoticiasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar from Noticias where Id = '" + id[i] + "'");
							eDB.setQuery("delete from Noticias where Id = '" + id[i] + "'");
						}else{
							eDB.setQuery("insert into NoticiasGdlApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar from NoticiasGdl where Id = '" + id[i] + "'");
							eDB.setQuery("delete from NoticiasGdl where Id = '" + id[i] + "'");
						}						
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Noticias();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select A.* from Noticias as A where A.Id = '" + request.getParameter("id") + "'");
				}else{
					resultados = eDB.getQuery("select A.* from NoticiasGdl as A where A.Id = '" + request.getParameter("id") + "'");
				}				
				objeto = new Noticias();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setTitulo(resultados.getString("Titulo"));
					objeto.setArchivo(resultados.getString("Archivo"));
					objeto.setResumen(resultados.getString("Resumen"));
					objeto.setNoticia(resultados.getString("Noticia"));
					objeto.setOcultar(resultados.getString("Ocultar"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				String nombre = request.getParameter("Archivo");
				nombre = nombre.replaceAll(" ","_");
				eDB.setConexion();
				if (Admon.equals("MEX")){
					eDB.setQuery("update Noticias set Fecha='" + request.getParameter("Fecha") + "',Titulo='" + request.getParameter("Titulo") + "',Archivo='" + nombre + "',Resumen='" + request.getParameter("Resumen") + "',Noticia='" + request.getParameter("Noticia") + "',Ocultar='" + request.getParameter("Ocultar") + "' where Id = '" + request.getParameter("id") + "'");
					eDB.setQuery("insert into NoticiasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar from Noticias where Id = '" + request.getParameter("id") + "'");
				}else{
					eDB.setQuery("update NoticiasGdl set Fecha='" + request.getParameter("Fecha") + "',Titulo='" + request.getParameter("Titulo") + "',Archivo='" + nombre + "',Resumen='" + request.getParameter("Resumen") + "',Noticia='" + request.getParameter("Noticia") + "',Ocultar='" + request.getParameter("Ocultar") + "' where Id = '" + request.getParameter("id") + "'");
					eDB.setQuery("insert into NoticiasGdlApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Titulo,Archivo,Resumen,Noticia,Ocultar from NoticiasGdl where Id = '" + request.getParameter("id") + "'");
				}				
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Noticias();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setFecha(request.getParameter("Fecha"));
					objeto.setTitulo(request.getParameter("Titulo"));
					objeto.setArchivo(request.getParameter("Archivo"));
					objeto.setResumen(request.getParameter("Resumen"));
					objeto.setNoticia(request.getParameter("Noticia"));
					objeto.setOcultar(request.getParameter("Ocultar"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getNoticias")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select Id, <columna> from Noticias where <columna> like '" + request.getParameter("filter[value]") + "%'");
				}else{
					resultados = eDB.getQuery("select Id, <columna> from NoticiasGdl where <columna> like '" + request.getParameter("filter[value]") + "%'");
				}				
				ArrayList<Noticias> info = new ArrayList<Noticias>();
				while(resultados.next()) {
					objeto = new Noticias();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("ConsultarNoticias")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select * from Noticias");
				}else{
					resultados = eDB.getQuery("select * from NoticiasGdl");
				}				
				ArrayList<Noticias> info = new ArrayList<Noticias>();
				while(resultados.next()) {
					objeto = new Noticias();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setTitulo(resultados.getString("Titulo"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new Noticias();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Noticias();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		}
	}

	public void init() throws ServletException {
		// Put your code here
		try {
			eDB = new MysqlPool();
			generales = new Generales();
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
	
	private void imprimeJson(HttpServletResponse response, Noticias objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Noticias> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Noticias objeto, Exception e) {
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
