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
import Objetos.Formatos; 
import Objetos.Noticias;

import com.google.gson.Gson;

public class FormatosServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8498087759518546590L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Formatos objeto;
	private Gson gson;
	private Fechas fechas;
	
	String Admon = "";

	public FormatosServlet() {
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
			System.out.println("Se interactuará con los Formatos de "+Admon);
			
			if(request.getParameter("Accion").equals("Guardar")) {
				
				String nombre = request.getParameter("Archivo");
				nombre = nombre.replaceAll(" ","_");
				
				eDB.setConexion();
				if (Admon.equals("MEX")){
					eDB.setQuery("insert into Formatos (U,G,E,Nombre,Seccion,Archivo,Ocultar) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Seccion") + "','" + nombre + "','" + request.getParameter("Ocultar") + "')");
					ultimoId = eDB.getUltimoId();
					eDB.setQuery("insert into FormatosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar from Formatos where Id = '" + ultimoId + "'");
				} else {
					eDB.setQuery("insert into FormatosGDL (U,G,E,Nombre,Seccion,Archivo,Ocultar) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Seccion") + "','" + nombre + "','" + request.getParameter("Ocultar") + "')");
					ultimoId = eDB.getUltimoId();
					eDB.setQuery("insert into FormatosGDLApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar from FormatosGdl where Id = '" + ultimoId + "'");
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Formatos();
				objeto.setId(ultimoId);
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setSeccion(request.getParameter("Seccion"));
				objeto.setArchivo(request.getParameter("Archivo"));
				objeto.setOcultar(request.getParameter("Ocultar"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Formatos();
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setSeccion(request.getParameter("Seccion"));
				objeto.setArchivo(request.getParameter("Archivo"));
				objeto.setOcultar(request.getParameter("Ocultar"));

				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getSeccion().equals("")) { where.append(" and A.Seccion like '" + objeto.getSeccion() + "%'"); entro = true;}
				if(!objeto.getArchivo().equals("")) { where.append(" and A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true;}
				if(!objeto.getOcultar().equals("")) { where.append(" and A.Ocultar like '" + objeto.getOcultar() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select A.* from Formatos as A" + whereInicio + where.toString());
				}else{
					resultados = eDB.getQuery("select A.* from FormatosGdl as A" + whereInicio + where.toString());
				}
				ArrayList<Formatos> info = new ArrayList<Formatos>();
				while(resultados.next()) {
					objeto = new Formatos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setSeccion(resultados.getString("Seccion"));
					objeto.setArchivo(resultados.getString("Archivo"));
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
							eDB.setQuery("insert into FormatosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar from Formatos where Id = '" + id[i] + "'");
							eDB.setQuery("delete from Formatos where Id = '" + id[i] + "'");
						}else{
							eDB.setQuery("insert into FormatosGdlApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar from FormatosGdl where Id = '" + id[i] + "'");
							eDB.setQuery("delete from FormatosGdl where Id = '" + id[i] + "'");
						}
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Formatos();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select A.* from Formatos as A where A.Id = '" + request.getParameter("id") + "'");
				}else{
					resultados = eDB.getQuery("select A.* from FormatosGdl as A where A.Id = '" + request.getParameter("id") + "'");
				}
				objeto = new Formatos();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setSeccion(resultados.getString("Seccion"));
					objeto.setArchivo(resultados.getString("Archivo"));
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
					eDB.setQuery("update Formatos set Nombre='" + request.getParameter("Nombre") + "',Seccion='" + request.getParameter("Seccion") + "',Archivo='" + nombre + "',Ocultar='" + request.getParameter("Ocultar") + "' where Id = '" + request.getParameter("id") + "'");
					eDB.setQuery("insert into FormatosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar from Formatos where Id = '" + request.getParameter("id") + "'");
				}else{
					eDB.setQuery("update FormatosGdl set Nombre='" + request.getParameter("Nombre") + "',Seccion='" + request.getParameter("Seccion") + "',Archivo='" + nombre + "',Ocultar='" + request.getParameter("Ocultar") + "' where Id = '" + request.getParameter("id") + "'");
					eDB.setQuery("insert into FormatosGdlApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Seccion,Archivo,Ocultar from FormatosGdl where Id = '" + request.getParameter("id") + "'");
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Formatos();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setSeccion(request.getParameter("Seccion"));
					objeto.setArchivo(request.getParameter("Archivo"));
					objeto.setOcultar(request.getParameter("Ocultar"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getFormatos")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select Id, <columna> from Formatos where <columna> like '" + request.getParameter("filter[value]") + "%'");
				}else{
					resultados = eDB.getQuery("select Id, <columna> from FormatosGdl where <columna> like '" + request.getParameter("filter[value]") + "%'");
				}
				ArrayList<Formatos> info = new ArrayList<Formatos>();
				while(resultados.next()) {
					objeto = new Formatos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("ConsultarFormatos")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){				
					resultados = eDB.getQuery("select * from Formatos");
				}else{
					resultados = eDB.getQuery("select * from FormatosGdl");
				}
				ArrayList<Formatos> info = new ArrayList<Formatos>();
				while(resultados.next()) {
					objeto = new Formatos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setArchivo(resultados.getString("Archivo"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new Formatos();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Formatos();
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
	
	private void imprimeJson(HttpServletResponse response, Formatos objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Formatos> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Formatos objeto, Exception e) {
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