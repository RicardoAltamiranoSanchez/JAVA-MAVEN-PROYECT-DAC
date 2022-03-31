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
import Objetos.TiposCredenciales;

import com.google.gson.Gson;

public class TiposCredencialesServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 589109363873805471L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private TiposCredenciales objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public TiposCredencialesServlet() {
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
				String Archivo = request.getParameter("Archivo");
				Archivo = Archivo.replace(" ", "_");
				eDB.setConexion();
				//ANTES DIVISION
				//eDB.setQuery("insert into TiposCredenciales (U,G,E,Nombre,Archivo) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Nombre") + "','" + Archivo + "')");
				eDB.setQuery("insert into TiposCredenciales (U,G,E,Nombre,Archivo,Admon) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Nombre") + "','" + Archivo + "',(select EG.Admon from EmpresasGrupo as EG, Empleados as E, Usuarios as U where E.IdUsuario = U.Id and E.Division = EG.Id and U.Id = '" + session.getAttribute("IdUsuario") + "'))");
				ultimoId = eDB.getUltimoId();
				//ANTES DIVISION
				//eDB.setQuery("insert into TiposCredencialesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Archivo from TiposCredenciales where Id = '" + ultimoId + "'");
				eDB.setQuery("insert into TiposCredencialesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Archivo,Admon) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Archivo,Admon from TiposCredenciales where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new TiposCredenciales();
				objeto.setId(ultimoId);
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setArchivo(request.getParameter("Archivo"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id > 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new TiposCredenciales();
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setArchivo(request.getParameter("Archivo"));

				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getArchivo().equals("")) { where.append(" and A.Archivo like '" + objeto.getArchivo() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				//ANTES DIVISION
				//resultados = eDB.getQuery("select A.* from TiposCredenciales as A" + whereInicio + where.toString());
				resultados = eDB.getQuery("select A.* from TiposCredenciales as A" + whereInicio + where.toString()+" and A.Admon = (select EG.Admon as Admon from EmpresasGrupo as EG, Empleados as E, Usuarios as U where E.IdUsuario = U.Id and E.Division = EG.Id and U.Id = '" + session.getAttribute("IdUsuario") + "')");
				ArrayList<TiposCredenciales> info = new ArrayList<TiposCredenciales>();
				while(resultados.next()) {
					objeto = new TiposCredenciales();
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
			else if(request.getParameter("Accion").equals("Borrar")) {
				eDB.setConexion();
				String ids = request.getParameter("Ids");
				String[] id = ids.split(",");
				for(int i = 0; i < id.length; i++) {
					if(!id[i].equals("")) {
						//ANTES DIVISION
						//eDB.setQuery("insert into TiposCredencialesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Nombre,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Nombre,Archivo from TiposCredenciales where Id = '" + id[i] + "'");
						eDB.setQuery("insert into TiposCredencialesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Nombre,Archivo,Admon) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Nombre,Archivo,Admon from TiposCredenciales where Id = '" + id[i] + "'");
						eDB.setQuery("delete from TiposCredenciales where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new TiposCredenciales();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				//ANTES DIVISION
				//resultados = eDB.getQuery("select A.* from TiposCredenciales as A where A.Id = '" + request.getParameter("id") + "'");
				resultados = eDB.getQuery("select A.* from TiposCredenciales as A where A.Id = '" + request.getParameter("id") + "' and A.Admon = (select EG.Admon as Admon from EmpresasGrupo as EG, Empleados as E, Usuarios as U where E.IdUsuario = U.Id and E.Division = EG.Id and U.Id = '" + session.getAttribute("IdUsuario") + "')");
				objeto = new TiposCredenciales();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setArchivo(resultados.getString("Archivo"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				String Archivo = request.getParameter("Archivo");
				Archivo = Archivo.replace(" ", "_");
				eDB.setConexion();
				//ANTES DIVISION
				//eDB.setQuery("update TiposCredenciales set Nombre='" + request.getParameter("Nombre") + "',Archivo='" + Archivo + "' where Id = '" + request.getParameter("id") + "'");
				//eDB.setQuery("insert into TiposCredencialesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Archivo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Archivo from TiposCredenciales where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("update TiposCredenciales set Nombre='" + request.getParameter("Nombre") + "',Archivo='" + Archivo + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into TiposCredencialesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Archivo,Admon) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Archivo,Admon from TiposCredenciales where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new TiposCredenciales();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setArchivo(request.getParameter("Archivo"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getTiposCredenciales")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, Nombre from TiposCredenciales where Nombre like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<TiposCredenciales> info = new ArrayList<TiposCredenciales>();
				while(resultados.next()) {
					objeto = new TiposCredenciales();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("Nombre"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getTiposCredencialesDiv")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, Nombre from TiposCredenciales where Nombre like '" + request.getParameter("filter[value]") + "%' and Admon = (select EG.Admon from EmpresasGrupo as EG, Empleados as E, Usuarios as U where E.IdUsuario = U.Id and E.Division = EG.Id and U.Id = '" + session.getAttribute("IdUsuario") + "')");
				ArrayList<TiposCredenciales> info = new ArrayList<TiposCredenciales>();
				while(resultados.next()) {
					objeto = new TiposCredenciales();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("Nombre"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new TiposCredenciales();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new TiposCredenciales();
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
	
	private void imprimeJson(HttpServletResponse response, TiposCredenciales objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<TiposCredenciales> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(TiposCredenciales objeto, Exception e) {
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
/* TiposCredencialesServlet */
