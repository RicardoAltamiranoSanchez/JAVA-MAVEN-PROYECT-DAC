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
import Objetos.Gerentes;

import com.google.gson.Gson;

public class GerentesServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1683979814383488868L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Gerentes objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public GerentesServlet() {
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
				eDB.setQuery("insert into Gerentes (U,G,E,IdUsuario) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + traducciones.getEntero(request.getParameter("IdGerente")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into GerentesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario from Gerentes where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Gerentes();
				objeto.setId(ultimoId);
				objeto.setIdUsuario(traducciones.getEntero(request.getParameter("IdGerente")));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where G.Id > 0 order by U.Nombre asc";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Gerentes();
				objeto.setIdUsuario(traducciones.getEntero(request.getParameter("IdGerente")));
				
				//ANTES DIVISION resultados = eDB.getQuery("select G.Id, U.Nombre from Gerentes as G left join Usuarios as U on(G.IdUsuario = U.Id)" + whereInicio);
				resultados = eDB.getQuery("select G.Id, U.Nombre from Gerentes as G left join Usuarios as U on(G.IdUsuario = U.Id) left join Empleados as E on (E.IdUsuario = G.IdUsuario) left join EmpresasGrupo as EG on (E.Division = EG.Id) where EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "')) and G.Id > 0 order by U.Nombre asc");
				ArrayList<Gerentes> info = new ArrayList<Gerentes>();
				while(resultados.next()) {
					objeto = new Gerentes();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("Nombre"));
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
						eDB.setQuery("insert into GerentesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdUsuario) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdUsuario from Gerentes where Id = '" + id[i] + "'");
						eDB.setQuery("delete from Gerentes where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Gerentes();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from Gerentes as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new Gerentes();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("IdUsuario"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update Gerentes set IdUsuario='" + traducciones.getEntero(request.getParameter("IdGerente")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into GerentesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario from Gerentes where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Gerentes();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setIdUsuario(traducciones.getEntero(request.getParameter("IdGerente")));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getUsuarios")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, Nombre from Usuarios where Nombre like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<Gerentes> info = new ArrayList<Gerentes>();
				while(resultados.next()) {
					objeto = new Gerentes();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("Nombre"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getUsuariosDiv")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select U.Id as Id, U.Nombre as Nombre from Usuarios as U, Empleados as E, EmpresasGrupo as EG where U.Nombre like '" + request.getParameter("filter[value]") + "%' and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "')) and U.Id = E.IdUsuario and E.Division = EG.Id");
				ArrayList<Gerentes> info = new ArrayList<Gerentes>();
				while(resultados.next()) {
					objeto = new Gerentes();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("Nombre"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getGerentes")) {
				eDB.setConexion();
				
				//System.out.println("select G.IdUsuario, U.Nombre from Gerentes as G left join Usuarios as U on(G.IdUsuario = U.Id) where U.Nombre like '" + request.getParameter("filter[value]") + "%' order by U.Nombre asc");
				// ANTES DIVISION resultados = eDB.getQuery("select G.IdUsuario, U.Nombre from Gerentes as G left join Usuarios as U on(G.IdUsuario = U.Id) where U.Nombre like '" + request.getParameter("filter[value]") + "%' order by U.Nombre asc");
				resultados = eDB.getQuery("select G.IdUsuario, EG.Admon as Admon, U.Nombre from Gerentes as G left join Usuarios as U on(G.IdUsuario = U.Id) left join Empleados as E on (G.IdUsuario = E.IdUsuario) left join EmpresasGrupo as EG on (EG.Id = E.Division) where U.Nombre like '" + request.getParameter("filter[value]") + "%' and EG.Admon =(select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '"+session.getAttribute("IdUsuario")+"')) order by U.Nombre asc");
				ArrayList<Gerentes> info = new ArrayList<Gerentes>();
				
				int i=0;
				
				while(resultados.next()) {
					objeto = new Gerentes();
					objeto.setId(resultados.getInt("IdUsuario"));
					objeto.setValue(resultados.getString("Nombre"));
					
					while (i==0){
						System.out.println("Los Gerentes Obtenidos para el llenado del combo son de "+resultados.getString("Admon"));
						i++;
					}
					
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new Gerentes();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Gerentes();
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
	
	private void imprimeJson(HttpServletResponse response, Gerentes objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Gerentes> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Gerentes objeto, Exception e) {
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
/* GerentesServlet */
