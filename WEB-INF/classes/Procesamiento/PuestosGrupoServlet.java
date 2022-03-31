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
import Objetos.PuestosGrupo;

import com.google.gson.Gson;

public class PuestosGrupoServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2421018501606189833L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private PuestosGrupo objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public PuestosGrupoServlet() {
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
				eDB.setQuery("insert into PuestosGrupo (U,G,E,Nombre,Clave,IdAreasGrupo) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Clave") + "','" + traducciones.getEntero(request.getParameter("IdAreasGrupo")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into PuestosGrupoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Clave,IdAreasGrupo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Clave,IdAreasGrupo from PuestosGrupo where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new PuestosGrupo();
				objeto.setId(ultimoId);
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setClave(request.getParameter("Clave"));
				objeto.setIdAreasGrupo(request.getParameter("IdAreasGrupo"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new PuestosGrupo();
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setClave(request.getParameter("Clave"));
				objeto.setIdAreasGrupo(request.getParameter("IdAreasGrupo"));

				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getClave().equals("")) { where.append(" and A.Clave like '" + objeto.getClave() + "%'"); entro = true;}
				if(!objeto.getIdAreasGrupo().equals("")) { where.append(" and A.IdAreasGrupo like '" + objeto.getIdAreasGrupo() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				// se modifica para que en el reporte muestre el nombre en lugar del Id, codigo agregado a partir de left join..
				resultados = eDB.getQuery("select A.*, AG.Nombre as NombreArea from PuestosGrupo as A left join AreasGrupo as AG on (AG.Id = A.IdAreasGrupo)" + whereInicio + where.toString());
				ArrayList<PuestosGrupo> info = new ArrayList<PuestosGrupo>();
				while(resultados.next()) {
					objeto = new PuestosGrupo();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setClave(resultados.getString("Clave"));
					//objeto.setIdAreasGrupo(resultados.getString("IdAreasGrupo")); linea por default, se cambia por la de abajo para que aparezca el nombre en lugar del Id
					objeto.setIdAreasGrupo(resultados.getString("NombreArea"));
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
						eDB.setQuery("insert into PuestosGrupoApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Nombre,Clave,IdAreasGrupo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Nombre,Clave,IdAreasGrupo from PuestosGrupo where Id = '" + id[i] + "'");
						eDB.setQuery("delete from PuestosGrupo where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new PuestosGrupo();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from PuestosGrupo as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new PuestosGrupo();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setClave(resultados.getString("Clave"));
					objeto.setIdAreasGrupo(resultados.getString("IdAreasGrupo"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update PuestosGrupo set Nombre='" + request.getParameter("Nombre") + "',Clave='" + request.getParameter("Clave") + "',IdAreasGrupo='" + traducciones.getEntero(request.getParameter("IdAreasGrupo")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into PuestosGrupoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Nombre,Clave,IdAreasGrupo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Nombre,Clave,IdAreasGrupo from PuestosGrupo where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new PuestosGrupo();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setClave(request.getParameter("Clave"));
					objeto.setIdAreasGrupo(request.getParameter("IdAreasGrupo"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getPuestosGrupo")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from PuestosGrupo where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<PuestosGrupo> info = new ArrayList<PuestosGrupo>();
				while(resultados.next()) {
					objeto = new PuestosGrupo();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			// COMBO DEPENDIENTE agrego un nuevo método que llenará los datos exclusivos pertenecientes a otra selección previa
			else if(request.getParameter("Accion").equals("getPuestosGrupoDeArea")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, Nombre from PuestosGrupo where IdAreasGrupo ='" + request.getParameter("filter[value]")+"'");
				ArrayList<PuestosGrupo> info = new ArrayList<PuestosGrupo>();
				while(resultados.next()) {
					objeto = new PuestosGrupo();
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
			objeto = new PuestosGrupo();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new PuestosGrupo();
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
	
	private void imprimeJson(HttpServletResponse response, PuestosGrupo objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<PuestosGrupo> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(PuestosGrupo objeto, Exception e) {
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
/* PuestosGrupoServlet */
