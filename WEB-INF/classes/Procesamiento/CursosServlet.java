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
import Objetos.Cursos;

import com.google.gson.Gson;

public class CursosServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3867904312056068843L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Cursos objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public CursosServlet() {
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
				eDB.setQuery("insert into Cursos (U,G,E,Clave,Curso,HorasCurso,HorarioCurso,TipoCurso) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Clave") + "','" + request.getParameter("Curso") + "','" + traducciones.getEntero(request.getParameter("HorasCurso")) + "','" + request.getParameter("HorarioCurso") + "','" + request.getParameter("TipoCurso") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into CursosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Clave,Curso,HorasCurso,HorarioCurso,TipoCurso) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Clave,Curso,HorasCurso,HorarioCurso,TipoCurso from Cursos where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Cursos();
				objeto.setId(ultimoId);
				objeto.setClave(request.getParameter("Clave"));
				objeto.setCurso(request.getParameter("Curso"));
				objeto.setHorasCurso(request.getParameter("HorasCurso"));
				objeto.setHorarioCurso(request.getParameter("HorarioCurso"));
				objeto.setTipoCurso(request.getParameter("TipoCurso"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Cursos();
				objeto.setClave(request.getParameter("Clave"));
				objeto.setCurso(request.getParameter("Curso"));
				objeto.setHorasCurso(request.getParameter("HorasCurso"));
				objeto.setHorarioCurso(request.getParameter("HorarioCurso"));
				objeto.setTipoCurso(request.getParameter("TipoCurso"));

				if(!objeto.getClave().equals("")) { where.append(" and A.Clave like '" + objeto.getClave() + "%'"); entro = true;}
				if(!objeto.getCurso().equals("")) { where.append(" and A.Curso like '" + objeto.getCurso() + "%'"); entro = true;}
				if(!objeto.getHorasCurso().equals("")) { where.append(" and A.HorasCurso like '" + objeto.getHorasCurso() + "%'"); entro = true;}
				if(!objeto.getHorarioCurso().equals("")) { where.append(" and A.HorarioCurso like '" + objeto.getHorarioCurso() + "%'"); entro = true;}
				if(!objeto.getTipoCurso().equals("")) { where.append(" and A.TipoCurso like '" + objeto.getTipoCurso() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from Cursos as A" + whereInicio + where.toString());
				ArrayList<Cursos> info = new ArrayList<Cursos>();
				while(resultados.next()) {
					objeto = new Cursos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setClave(resultados.getString("Clave"));
					objeto.setCurso(resultados.getString("Curso"));
					objeto.setHorasCurso(resultados.getString("HorasCurso"));
					objeto.setHorarioCurso(resultados.getString("HorarioCurso"));
					objeto.setTipoCurso(resultados.getString("TipoCurso"));
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
						eDB.setQuery("insert into CursosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Clave,Curso,HorasCurso,HorarioCurso,TipoCurso) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Clave,Curso,HorasCurso,HorarioCurso,TipoCurso from Cursos where Id = '" + id[i] + "'");
						eDB.setQuery("delete from Cursos where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Cursos();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from Cursos as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new Cursos();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setClave(resultados.getString("Clave"));
					objeto.setCurso(resultados.getString("Curso"));
					objeto.setHorasCurso(resultados.getString("HorasCurso"));
					objeto.setHorarioCurso(resultados.getString("HorarioCurso"));
					objeto.setTipoCurso(resultados.getString("TipoCurso"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update Cursos set Clave='" + request.getParameter("Clave") + "',Curso='" + request.getParameter("Curso") + "',HorasCurso='" + traducciones.getEntero(request.getParameter("HorasCurso")) + "',HorarioCurso='" + request.getParameter("HorarioCurso") + "',TipoCurso='" + request.getParameter("TipoCurso") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into CursosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Clave,Curso,HorasCurso,HorarioCurso,TipoCurso) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Clave,Curso,HorasCurso,HorarioCurso,TipoCurso from Cursos where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Cursos();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setClave(request.getParameter("Clave"));
					objeto.setCurso(request.getParameter("Curso"));
					objeto.setHorasCurso(request.getParameter("HorasCurso"));
					objeto.setHorarioCurso(request.getParameter("HorarioCurso"));
					objeto.setTipoCurso(request.getParameter("TipoCurso"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getCursos")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, Curso from Cursos where Curso like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<Cursos> info = new ArrayList<Cursos>();
				while(resultados.next()) {
					objeto = new Cursos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("Curso"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new Cursos();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Cursos();
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
	
	private void imprimeJson(HttpServletResponse response, Cursos objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Cursos> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Cursos objeto, Exception e) {
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
/* CursosServlet */