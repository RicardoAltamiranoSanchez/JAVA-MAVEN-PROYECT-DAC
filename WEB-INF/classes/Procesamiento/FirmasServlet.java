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
import Objetos.Firmas;

import com.google.gson.Gson;

public class FirmasServlet extends HttpServlet {


	/**
	 * 
	 */
	private static final long serialVersionUID = -6956996412461209758L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Firmas objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;
	public FirmasServlet() {
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
				eDB.setQuery("insert into Firmas (U,G,E,NombreFirma) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("NombreFirma") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into FirmasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreFirma) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreFirma from Firmas where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Firmas();
				objeto.setId(ultimoId);
				objeto.setNombreFirma(request.getParameter("NombreFirma"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Firmas();
				objeto.setNombreFirma(request.getParameter("NombreFirma"));

				if(!objeto.getNombreFirma().equals("")) { where.append(" and A.NombreFirma like '" + objeto.getNombreFirma() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from Firmas as A" + whereInicio + where.toString());
				ArrayList<Firmas> info = new ArrayList<Firmas>();
				while(resultados.next()) {
					objeto = new Firmas();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombreFirma(resultados.getString("NombreFirma"));
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
						eDB.setQuery("insert into FirmasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,NombreFirma) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,NombreFirma from Firmas where Id = '" + id[i] + "'");
						eDB.setQuery("delete from Firmas where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Firmas();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from Firmas as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new Firmas();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombreFirma(resultados.getString("NombreFirma"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update Firmas set NombreFirma='" + request.getParameter("NombreFirma") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into FirmasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreFirma) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreFirma from Firmas where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Firmas();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setNombreFirma(request.getParameter("NombreFirma"));
				imprimeJson(response,objeto);
			}
			// COMBO acción que hace consulta para llenar combo
			else if(request.getParameter("Accion").equals("getFirmas")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, NombreFirma from Firmas where NombreFirma like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<Firmas> info = new ArrayList<Firmas>();
				while(resultados.next()) {
					objeto = new Firmas();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("NombreFirma"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new Firmas();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Firmas();
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
	
	private void imprimeJson(HttpServletResponse response, Firmas objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Firmas> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Firmas objeto, Exception e) {
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
/* FirmasServlet */