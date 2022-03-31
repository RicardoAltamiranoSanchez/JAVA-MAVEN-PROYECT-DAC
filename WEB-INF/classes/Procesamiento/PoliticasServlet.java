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
import Objetos.Politicas; 

import com.google.gson.Gson;

public class PoliticasServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2199196593288783739L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Politicas objeto;
	private Gson gson;
	private Fechas fechas;
	
	String Admon = "";

	public PoliticasServlet() {
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
			System.out.println("Se interactuará con las Politicas de "+Admon);
			
			if(request.getParameter("Accion").equals("Guardar")) {
				
				String nombre = request.getParameter("Archivo");
				nombre = nombre.replaceAll(" ","_");
				
				eDB.setConexion();
				if (Admon.equals("MEX")){
					eDB.setQuery("insert into Politicas (U,G,E,Fecha,Politica,Archivo,Ocultar) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Fecha") + "','" + request.getParameter("Politica") + "','" + nombre + "','" + request.getParameter("Ocultar") + "')");
					ultimoId = eDB.getUltimoId();
					eDB.setQuery("insert into PoliticasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar from Politicas where Id = '" + ultimoId + "'");
				}else{
					eDB.setQuery("insert into PoliticasGdl (U,G,E,Fecha,Politica,Archivo,Ocultar) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Fecha") + "','" + request.getParameter("Politica") + "','" + nombre + "','" + request.getParameter("Ocultar") + "')");
					ultimoId = eDB.getUltimoId();
					eDB.setQuery("insert into PoliticasGdlApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar from PoliticasGdl where Id = '" + ultimoId + "'");
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Politicas();
				objeto.setId(ultimoId);
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setPolitica(request.getParameter("Politica"));
				objeto.setArchivo(request.getParameter("Archivo"));
				objeto.setOcultar(request.getParameter("Ocultar"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id > 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Politicas();
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setPolitica(request.getParameter("Politica"));
				objeto.setOcultar(request.getParameter("Ocultar"));

				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha >= '" + objeto.getFecha() + "'"); entro = true;}
				if(!objeto.getPolitica().equals("")) { where.append(" and A.Politica like '" + objeto.getPolitica() + "%'"); entro = true;}
				if(!objeto.getOcultar().equals("")) { where.append(" and A.Ocultar = '" + objeto.getOcultar() + "'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select A.* from Politicas as A" + whereInicio + where.toString());
				}else{
					resultados = eDB.getQuery("select A.* from PoliticasGdl as A" + whereInicio + where.toString());
				}
				ArrayList<Politicas> info = new ArrayList<Politicas>();
				while(resultados.next()) {
					objeto = new Politicas();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setPolitica(resultados.getString("Politica"));
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
							eDB.setQuery("insert into PoliticasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar from Politicas where Id = '" + id[i] + "'");
							eDB.setQuery("delete from Politicas where Id = '" + id[i] + "'");
						}else{
							eDB.setQuery("insert into PoliticasGdlApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar from PoliticasGdl where Id = '" + id[i] + "'");
							eDB.setQuery("delete from PoliticasGdl where Id = '" + id[i] + "'");
						}						
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Politicas();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select A.* from Politicas as A where A.Id = '" + request.getParameter("id") + "'");
				}else{
					resultados = eDB.getQuery("select A.* from PoliticasGdl as A where A.Id = '" + request.getParameter("id") + "'");
				}				
				objeto = new Politicas();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setPolitica(resultados.getString("Politica"));
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
					eDB.setQuery("update Politicas set Fecha='" + request.getParameter("Fecha") + "',Politica='" + request.getParameter("Politica") + "',Archivo='" + nombre + "',Ocultar='" + request.getParameter("Ocultar") + "' where Id = '" + request.getParameter("id") + "'");
					eDB.setQuery("insert into PoliticasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar from Politicas where Id = '" + request.getParameter("id") + "'");
				}else{
					eDB.setQuery("update PoliticasGdl set Fecha='" + request.getParameter("Fecha") + "',Politica='" + request.getParameter("Politica") + "',Archivo='" + nombre + "',Ocultar='" + request.getParameter("Ocultar") + "' where Id = '" + request.getParameter("id") + "'");
					eDB.setQuery("insert into PoliticasGdlApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Politica,Archivo,Ocultar from PoliticasGdl where Id = '" + request.getParameter("id") + "'");
				}				
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Politicas();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setFecha(request.getParameter("Fecha"));
					objeto.setPolitica(request.getParameter("Politica"));
					objeto.setArchivo(request.getParameter("Archivo"));
					objeto.setOcultar(request.getParameter("Ocultar"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getPoliticas")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select Id, <columna> from Politicas where <columna> like '" + request.getParameter("filter[value]") + "%'");
				}else{
					resultados = eDB.getQuery("select Id, <columna> from PoliticasGdl where <columna> like '" + request.getParameter("filter[value]") + "%'");
				}
				ArrayList<Politicas> info = new ArrayList<Politicas>();
				while(resultados.next()) {
					objeto = new Politicas();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("ConsultarPoliticas")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select * from Politicas where Ocultar = 'No'");
				}else{
					resultados = eDB.getQuery("select * from PoliticasGdl where Ocultar = 'No'");
				}				
				ArrayList<Politicas> info = new ArrayList<Politicas>();
				while(resultados.next()) {
					objeto = new Politicas();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setPolitica(resultados.getString("Politica"));
					objeto.setArchivo(resultados.getString("Archivo"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new Politicas();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Politicas();
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
	
	private void imprimeJson(HttpServletResponse response, Politicas objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Politicas> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Politicas objeto, Exception e) {
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
/* PoliticasServlet */
