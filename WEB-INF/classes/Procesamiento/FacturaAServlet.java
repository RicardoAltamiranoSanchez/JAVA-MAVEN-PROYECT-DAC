
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
import Objetos.FacturaA;

import com.google.gson.Gson;

public class FacturaAServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3699359064307497621L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private FacturaA objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public FacturaAServlet() {
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
				eDB.setQuery("insert into FacturaA (U,G,E,Rfc,Empresa) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Rfc") + "','" + request.getParameter("Empresa") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into FacturaAApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Rfc,Empresa) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Rfc,Empresa from FacturaA where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new FacturaA();
				objeto.setId("" + ultimoId);
				objeto.setRfc(request.getParameter("Rfc"));
				objeto.setEmpresa(request.getParameter("Empresa"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id > 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new FacturaA();
				objeto.setRfc(request.getParameter("Rfc"));
				objeto.setEmpresa(request.getParameter("Empresa"));

				if(!objeto.getRfc().equals("")) { where.append(" and A.Rfc like '" + objeto.getRfc() + "%'"); entro = true;}
				if(!objeto.getEmpresa().equals("")) { where.append(" and A.Empresa like '" + objeto.getEmpresa() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from FacturaA as A" + whereInicio + where.toString());
				ArrayList<FacturaA> info = new ArrayList<FacturaA>();
				while(resultados.next()) {
					objeto = new FacturaA();
					objeto.setId(resultados.getString("Id"));
					objeto.setRfc(resultados.getString("Rfc"));
					objeto.setEmpresa(resultados.getString("Empresa"));
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
						eDB.setQuery("insert into FacturaAApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Rfc,Empresa) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Rfc,Empresa from FacturaA where Id = '" + id[i] + "'");
						eDB.setQuery("delete from FacturaA where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new FacturaA();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from FacturaA as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new FacturaA();
				while(resultados.next()) {
					objeto.setId(resultados.getString("Id"));
					objeto.setRfc(resultados.getString("Rfc"));
					objeto.setEmpresa(resultados.getString("Empresa"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update FacturaA set Rfc='" + request.getParameter("Rfc") + "',Empresa='" + request.getParameter("Empresa") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into FacturaAApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Rfc,Empresa) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Rfc,Empresa from FacturaA where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new FacturaA();
				objeto.setId(request.getParameter("id"));
				objeto.setRfc(request.getParameter("Rfc"));
				objeto.setEmpresa(request.getParameter("Empresa"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getFacturaA")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, Rfc, Empresa from FacturaA where Rfc like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<FacturaA> info = new ArrayList<FacturaA>();
				while(resultados.next()) {
					objeto = new FacturaA();
					objeto.setId(resultados.getString("Rfc"));
					objeto.setValue(resultados.getString("Empresa"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new FacturaA();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new FacturaA();
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
	
	private void imprimeJson(HttpServletResponse response, FacturaA objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<FacturaA> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(FacturaA objeto, Exception e) {
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
/* FacturaAServlet */