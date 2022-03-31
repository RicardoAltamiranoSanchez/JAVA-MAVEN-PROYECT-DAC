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
import Objetos.EmpresasGrupo;

import com.google.gson.Gson;

public class EmpresasGrupoServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4957403192187632452L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private EmpresasGrupo objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public EmpresasGrupoServlet() {
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
				eDB.setQuery("insert into EmpresasGrupo (U,G,E,Nombre,Codigo,DomFiscal,RFC,Admon) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Codigo") + "','" + request.getParameter("DomFiscal") + "','" + request.getParameter("RFC") + "','" + request.getParameter("Admon") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into EmpresasGrupoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Codigo,DomFiscal,RFC,Admon) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Codigo,DomFiscal,RFC,Admon from EmpresasGrupo where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new EmpresasGrupo();
				objeto.setId(ultimoId);
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setCodigo(request.getParameter("Codigo"));
				objeto.setDomFiscal(request.getParameter("DomFiscal"));
				objeto.setRFC(request.getParameter("RFC"));
				objeto.setAdmon(request.getParameter("Admon"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new EmpresasGrupo();
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setCodigo(request.getParameter("Codigo"));
				objeto.setDomFiscal(request.getParameter("DomFiscal"));
				objeto.setRFC(request.getParameter("RFC"));
				objeto.setAdmon(request.getParameter("Admon"));

				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getCodigo().equals("")) { where.append(" and A.Codigo like '" + objeto.getCodigo() + "%'"); entro = true;}
				if(!objeto.getDomFiscal().equals("")) { where.append(" and A.DomFiscal like '" + objeto.getDomFiscal() + "%'"); entro = true;}
				if(!objeto.getRFC().equals("")) { where.append(" and A.RFC like '" + objeto.getRFC() + "%'"); entro = true;}
				if(!objeto.getAdmon().equals("")) { where.append(" and A.Admon like '" + objeto.getAdmon() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from EmpresasGrupo as A" + whereInicio + where.toString());
				ArrayList<EmpresasGrupo> info = new ArrayList<EmpresasGrupo>();
				while(resultados.next()) {
					objeto = new EmpresasGrupo();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setCodigo(resultados.getString("Codigo"));
					objeto.setDomFiscal(resultados.getString("DomFiscal"));
					objeto.setRFC(resultados.getString("RFC"));
					objeto.setAdmon(resultados.getString("Admon"));
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
						eDB.setQuery("insert into EmpresasGrupoApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Nombre,Codigo,DomFiscal,RFC,Admon) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Nombre,Codigo,DomFiscal,RFC,Admon from EmpresasGrupo where Id = '" + id[i] + "'");
						eDB.setQuery("delete from EmpresasGrupo where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new EmpresasGrupo();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from EmpresasGrupo as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new EmpresasGrupo();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setCodigo(resultados.getString("Codigo"));
					objeto.setDomFiscal(resultados.getString("DomFiscal"));
					objeto.setRFC(resultados.getString("RFC"));
					objeto.setAdmon(resultados.getString("Admon"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update EmpresasGrupo set Nombre='" + request.getParameter("Nombre") + "',Codigo='" + request.getParameter("Codigo") + "',DomFiscal='" + request.getParameter("DomFiscal") + "',RFC='" + request.getParameter("RFC") + "',Admon='" + request.getParameter("Admon") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into EmpresasGrupoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Codigo,DomFiscal,RFC,Admon) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Codigo,DomFiscal,RFC,Admon from EmpresasGrupo where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new EmpresasGrupo();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setCodigo(request.getParameter("Codigo"));
					objeto.setDomFiscal(request.getParameter("DomFiscal"));
					objeto.setRFC(request.getParameter("RFC"));
					objeto.setAdmon(request.getParameter("Admon"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getEmpresasGrupo")) {
				eDB.setConexion();
				// ANTES DE DIVISION resultados = eDB.getQuery("select Id, concat(Codigo,'-',Nombre) as Codigo from EmpresasGrupo where Codigo like '" + request.getParameter("filter[value]") + "%'");
				resultados = eDB.getQuery("select Id, Admon, concat(Codigo,'-',Nombre) as Codigo from EmpresasGrupo where Codigo like '" + request.getParameter("filter[value]") + "%' and Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '"+session.getAttribute("IdUsuario")+"'))");
				ArrayList<EmpresasGrupo> info = new ArrayList<EmpresasGrupo>();
				
				int i = 0;
				
				while(resultados.next()) {
					objeto = new EmpresasGrupo();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("Codigo"));
					while (i==0){
						System.out.println("Las Empresas consideradas para llenar la lista del combo son de "+resultados.getString("Admon"));
						i++;
					}
					info.add(objeto);	
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getEmpresasGrupoSoloTi")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, concat(Codigo,'-',Nombre) as Codigo from EmpresasGrupo where Codigo like '" + request.getParameter("filter[value]") + "%'");				
				ArrayList<EmpresasGrupo> info = new ArrayList<EmpresasGrupo>();				
				while(resultados.next()) {
					objeto = new EmpresasGrupo();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("Codigo"));					
					info.add(objeto);	
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new EmpresasGrupo();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new EmpresasGrupo();
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
	
	private void imprimeJson(HttpServletResponse response, EmpresasGrupo objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<EmpresasGrupo> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(EmpresasGrupo objeto, Exception e) {
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
/* EmpresasGrupoServlet */
