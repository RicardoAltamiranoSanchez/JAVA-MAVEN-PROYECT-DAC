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
import Objetos.Avisos; 
import Objetos.Noticias;

import com.google.gson.Gson;

public class AvisosServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6897801964581120987L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Avisos objeto;
	private Gson gson;
	private Fechas fechas;
	
	String Admon = "";

	public AvisosServlet() {
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
			System.out.println("Se interactuará con los Avisos de "+Admon);
			
			if(request.getParameter("Accion").equals("Guardar")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					eDB.setQuery("insert into Avisos (U,G,E,Fecha,Aviso,Ocultar) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Fecha") + "','" + request.getParameter("Aviso") + "','" + request.getParameter("Ocultar") + "')");
					ultimoId = eDB.getUltimoId();
					eDB.setQuery("insert into AvisosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Aviso,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Aviso,Ocultar from Avisos where Id = '" + ultimoId + "'");
				}else{
					eDB.setQuery("insert into AvisosGdl (U,G,E,Fecha,Aviso,Ocultar) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Fecha") + "','" + request.getParameter("Aviso") + "','" + request.getParameter("Ocultar") + "')");
					ultimoId = eDB.getUltimoId();
					eDB.setQuery("insert into AvisosGdlApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Aviso,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Aviso,Ocultar from AvisosGdl where Id = '" + ultimoId + "'");
				}				
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Avisos();
				objeto.setId(ultimoId);
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setAviso(request.getParameter("Aviso"));
				objeto.setOcultar(request.getParameter("Ocultar"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Avisos();
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setAviso(request.getParameter("Aviso"));
				objeto.setOcultar(request.getParameter("Ocultar"));

				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha like '" + objeto.getFecha() + "%'"); entro = true;}
				if(!objeto.getAviso().equals("")) { where.append(" and A.Aviso like '" + objeto.getAviso() + "%'"); entro = true;}
				if(!objeto.getOcultar().equals("")) { where.append(" and A.Ocultar like '" + objeto.getOcultar() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select A.* from Avisos as A" + whereInicio + where.toString());
				}else{
					resultados = eDB.getQuery("select A.* from AvisosGdl as A" + whereInicio + where.toString());
				}				
				ArrayList<Avisos> info = new ArrayList<Avisos>();
				while(resultados.next()) {
					objeto = new Avisos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setAviso(resultados.getString("Aviso"));
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
							eDB.setQuery("insert into AvisosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,Aviso,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,Aviso,Ocultar from Avisos where Id = '" + id[i] + "'");
							eDB.setQuery("delete from Avisos where Id = '" + id[i] + "'");
						}else{
							eDB.setQuery("insert into AvisosGdlApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,Aviso,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,Aviso,Ocultar from AvisosGdl where Id = '" + id[i] + "'");
							eDB.setQuery("delete from AvisosGdl where Id = '" + id[i] + "'");
						}						
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Avisos();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select A.* from Avisos as A where A.Id = '" + request.getParameter("id") + "'");
				}else{
					resultados = eDB.getQuery("select A.* from AvisosGdl as A where A.Id = '" + request.getParameter("id") + "'");
				}				
				objeto = new Avisos();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setAviso(resultados.getString("Aviso"));
					objeto.setOcultar(resultados.getString("Ocultar"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					eDB.setQuery("update Avisos set Fecha='" + request.getParameter("Fecha") + "',Aviso='" + request.getParameter("Aviso") + "',Ocultar='" + request.getParameter("Ocultar") + "' where Id = '" + request.getParameter("id") + "'");
					eDB.setQuery("insert into AvisosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Aviso,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Aviso,Ocultar from Avisos where Id = '" + request.getParameter("id") + "'");
				}else{
					eDB.setQuery("update AvisosGdl set Fecha='" + request.getParameter("Fecha") + "',Aviso='" + request.getParameter("Aviso") + "',Ocultar='" + request.getParameter("Ocultar") + "' where Id = '" + request.getParameter("id") + "'");
					eDB.setQuery("insert into AvisosGdlApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Aviso,Ocultar) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Aviso,Ocultar from AvisosGdl where Id = '" + request.getParameter("id") + "'");
				}				
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Avisos();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setFecha(request.getParameter("Fecha"));
					objeto.setAviso(request.getParameter("Aviso"));
					objeto.setOcultar(request.getParameter("Ocultar"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getAvisos")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select Id, <columna> from Avisos where <columna> like '" + request.getParameter("filter[value]") + "%'");
				}else{
					resultados = eDB.getQuery("select Id, <columna> from AvisosGdl where <columna> like '" + request.getParameter("filter[value]") + "%'");
				}				
				ArrayList<Avisos> info = new ArrayList<Avisos>();
				while(resultados.next()) {
					objeto = new Avisos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("ConsultarAvisos")) {
				eDB.setConexion();
				if (Admon.equals("MEX")){
					resultados = eDB.getQuery("select Id,Fecha,concat(SUBSTRING(Aviso,1,55),'...') as Aviso from Avisos where Ocultar = 'No' order by Fecha desc, Id desc");
				}else{
					resultados = eDB.getQuery("select Id,Fecha,concat(SUBSTRING(Aviso,1,55),'...') as Aviso from AvisosGdl where Ocultar = 'No' order by Fecha desc, Id desc");
				}				
				ArrayList<Avisos> info = new ArrayList<Avisos>();
				while(resultados.next()) {
					objeto = new Avisos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setAviso(resultados.getString("Aviso"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new Avisos();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Avisos();
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
	
	private void imprimeJson(HttpServletResponse response, Avisos objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Avisos> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Avisos objeto, Exception e) {
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