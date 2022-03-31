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
import Objetos.UbicacionesGrupo;

import com.google.gson.Gson;

public class UbicacionesGrupoServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -861272699777188882L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private UbicacionesGrupo objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public UbicacionesGrupoServlet() {
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
				eDB.setQuery("insert into UbicacionesGrupo (U,G,E,Pais,CodigoPais,Estado,Ciudad,CodigoCiudad,Sucursal,DomicilioSuc) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Pais") + "','" + request.getParameter("CodigoPais") + "','" + request.getParameter("Estado") + "','" + request.getParameter("Ciudad") + "','" + request.getParameter("CodigoCiudad") + "','" + request.getParameter("Sucursal") + "','" + request.getParameter("DomicilioSuc") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into UbicacionesGrupoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Pais,CodigoPais,Estado,Ciudad,CodigoCiudad,Sucursal,DomicilioSuc) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Pais,CodigoPais,Estado,Ciudad,CodigoCiudad,Sucursal,DomicilioSuc from UbicacionesGrupo where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new UbicacionesGrupo();
				objeto.setId(ultimoId);
				objeto.setPais(request.getParameter("Pais"));
				objeto.setCodigoPais(request.getParameter("CodigoPais"));
				objeto.setEstado(request.getParameter("Estado"));
				objeto.setCiudad(request.getParameter("Ciudad"));
				objeto.setCodigoCiudad(request.getParameter("CodigoCiudad"));
				objeto.setSucursal(request.getParameter("Sucursal"));
				objeto.setDomicilioSuc(request.getParameter("DomicilioSuc"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new UbicacionesGrupo();
				objeto.setPais(request.getParameter("Pais"));
				objeto.setCodigoPais(request.getParameter("CodigoPais"));
				objeto.setEstado(request.getParameter("Estado"));
				objeto.setCiudad(request.getParameter("Ciudad"));
				objeto.setCodigoCiudad(request.getParameter("CodigoCiudad"));
				objeto.setSucursal(request.getParameter("Sucursal"));
				objeto.setDomicilioSuc(request.getParameter("DomicilioSuc"));

				if(!objeto.getPais().equals("")) { where.append(" and A.Pais like '" + objeto.getPais() + "%'"); entro = true;}
				if(!objeto.getCodigoPais().equals("")) { where.append(" and A.CodigoPais like '" + objeto.getCodigoPais() + "%'"); entro = true;}
				if(!objeto.getEstado().equals("")) { where.append(" and A.Estado like '" + objeto.getEstado() + "%'"); entro = true;}
				if(!objeto.getCiudad().equals("")) { where.append(" and A.Ciudad like '" + objeto.getCiudad() + "%'"); entro = true;}
				if(!objeto.getCodigoCiudad().equals("")) { where.append(" and A.CodigoCiudad like '" + objeto.getCodigoCiudad() + "%'"); entro = true;}
				if(!objeto.getSucursal().equals("")) { where.append(" and A.Sucursal like '" + objeto.getSucursal() + "%'"); entro = true;}
				if(!objeto.getDomicilioSuc().equals("")) { where.append(" and A.DomicilioSuc like '" + objeto.getDomicilioSuc() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from UbicacionesGrupo as A" + whereInicio + where.toString());
				ArrayList<UbicacionesGrupo> info = new ArrayList<UbicacionesGrupo>();
				while(resultados.next()) {
					objeto = new UbicacionesGrupo();
					objeto.setId(resultados.getInt("Id"));
					objeto.setPais(resultados.getString("Pais"));
					objeto.setCodigoPais(resultados.getString("CodigoPais"));
					objeto.setEstado(resultados.getString("Estado"));
					objeto.setCiudad(resultados.getString("Ciudad"));
					objeto.setCodigoCiudad(resultados.getString("CodigoCiudad"));
					objeto.setSucursal(resultados.getString("Sucursal"));
					objeto.setDomicilioSuc(resultados.getString("DomicilioSuc"));
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
						eDB.setQuery("insert into UbicacionesGrupoApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Pais,CodigoPais,Estado,Ciudad,CodigoCiudad,Sucursal,DomicilioSuc) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Pais,CodigoPais,Estado,Ciudad,CodigoCiudad,Sucursal,DomicilioSuc from UbicacionesGrupo where Id = '" + id[i] + "'");
						eDB.setQuery("delete from UbicacionesGrupo where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new UbicacionesGrupo();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from UbicacionesGrupo as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new UbicacionesGrupo();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setPais(resultados.getString("Pais"));
					objeto.setCodigoPais(resultados.getString("CodigoPais"));
					objeto.setEstado(resultados.getString("Estado"));
					objeto.setCiudad(resultados.getString("Ciudad"));
					objeto.setCodigoCiudad(resultados.getString("CodigoCiudad"));
					objeto.setSucursal(resultados.getString("Sucursal"));
					objeto.setDomicilioSuc(resultados.getString("DomicilioSuc"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update UbicacionesGrupo set Pais='" + request.getParameter("Pais") + "',CodigoPais='" + request.getParameter("CodigoPais") + "',Estado='" + request.getParameter("Estado") + "',Ciudad='" + request.getParameter("Ciudad") + "',CodigoCiudad='" + request.getParameter("CodigoCiudad") + "',Sucursal='" + request.getParameter("Sucursal") + "',DomicilioSuc='" + request.getParameter("DomicilioSuc") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into UbicacionesGrupoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Pais,CodigoPais,Estado,Ciudad,CodigoCiudad,Sucursal,DomicilioSuc) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Pais,CodigoPais,Estado,Ciudad,CodigoCiudad,Sucursal,DomicilioSuc from UbicacionesGrupo where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new UbicacionesGrupo();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setPais(request.getParameter("Pais"));
					objeto.setCodigoPais(request.getParameter("CodigoPais"));
					objeto.setEstado(request.getParameter("Estado"));
					objeto.setCiudad(request.getParameter("Ciudad"));
					objeto.setCodigoCiudad(request.getParameter("CodigoCiudad"));
					objeto.setSucursal(request.getParameter("Sucursal"));
					objeto.setDomicilioSuc(request.getParameter("DomicilioSuc"));
				imprimeJson(response,objeto);
			}
			// COMBO acción que hace consulta para llenar combo
			else if(request.getParameter("Accion").equals("getUbicacionesGrupo")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, Sucursal from UbicacionesGrupo where Sucursal like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<UbicacionesGrupo> info = new ArrayList<UbicacionesGrupo>();
				while(resultados.next()) {
					objeto = new UbicacionesGrupo();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("Sucursal"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new UbicacionesGrupo();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new UbicacionesGrupo();
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
	
	private void imprimeJson(HttpServletResponse response, UbicacionesGrupo objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<UbicacionesGrupo> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(UbicacionesGrupo objeto, Exception e) {
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
/* UbicacionesGrupoServlet */