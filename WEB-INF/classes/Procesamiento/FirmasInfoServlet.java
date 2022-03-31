package Procesamiento;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import Configuraciones.Generales;
import Configuraciones.BaseDeDatosPool;
import Utilerias.Fechas;
import Utilerias.TraduccionesSQL;
import Objetos.FirmasInfo;

import com.google.gson.Gson;

public class FirmasInfoServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6123303622287490560L;
	private HttpSession session;
	private DataSource datasource = null;
	private Generales generales;
	private int ultimoId;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;
	private BaseDeDatosPool dbConf;

	public FirmasInfoServlet() {
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
		
		request.setCharacterEncoding("UTF-8");
		validar(request,response);
		Connection conexion = null;
		Statement sentencia = null;
		ResultSet resultados = null;
		FirmasInfo objeto;
		
		try {
			conexion = datasource.getConnection();
			sentencia = conexion.createStatement();
			if(request.getParameter("Accion").equals("Guardar")) {
				sentencia.executeUpdate("insert into FirmasInfo (U,G,E,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + traducciones.getEntero(request.getParameter("IdUsuario")) + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Titulo") + "','" + request.getParameter("Email") + "','" + request.getParameter("Nextel") + "','" + request.getParameter("NextelId") + "')",Statement.RETURN_GENERATED_KEYS);
				ResultSet indice = sentencia.getGeneratedKeys();
				while(indice.next()) {
					ultimoId = indice.getInt(1);
				}
				try { if(null!=indice)indice.close();} catch (SQLException e) {;}
				sentencia.executeUpdate("insert into FirmasInfoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId from FirmasInfo where Id = '" + ultimoId + "'");
				
				objeto = new FirmasInfo();
				objeto.setId(ultimoId);
				objeto.setIdUsuario(request.getParameter("IdUsuario"));
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setTitulo(request.getParameter("Titulo"));
				objeto.setEmail(request.getParameter("Email"));
				objeto.setNextel(request.getParameter("Nextel"));
				objeto.setNextelId(request.getParameter("NextelId"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				objeto = new FirmasInfo();
				objeto.setIdUsuario(request.getParameter("IdUsuario"));
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setTitulo(request.getParameter("Titulo"));
				objeto.setEmail(request.getParameter("Email"));
				objeto.setNextel(request.getParameter("Nextel"));
				objeto.setNextelId(request.getParameter("NextelId"));

				if(!objeto.getIdUsuario().equals("")) { where.append(" and A.IdUsuario like '" + objeto.getIdUsuario() + "%'"); entro = true;}
				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getTitulo().equals("")) { where.append(" and A.Titulo like '" + objeto.getTitulo() + "%'"); entro = true;}
				if(!objeto.getEmail().equals("")) { where.append(" and A.Email like '" + objeto.getEmail() + "%'"); entro = true;}
				if(!objeto.getNextel().equals("")) { where.append(" and A.Nextel like '" + objeto.getNextel() + "%'"); entro = true;}
				if(!objeto.getNextelId().equals("")) { where.append(" and A.NextelId like '" + objeto.getNextelId() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = sentencia.executeQuery("select A.* from FirmasInfo as A" + whereInicio + where.toString());
				ArrayList<FirmasInfo> info = new ArrayList<FirmasInfo>();
				while(resultados.next()) {
					objeto = new FirmasInfo();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("IdUsuario"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setTitulo(resultados.getString("Titulo"));
					objeto.setEmail(resultados.getString("Email"));
					objeto.setNextel(resultados.getString("Nextel"));
					objeto.setNextelId(resultados.getString("NextelId"));
					info.add(objeto);
				}
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("Borrar")) {
				String ids = request.getParameter("Ids");
				String[] id = ids.split(",");
				for(int i = 0; i < id.length; i++) {
					if(!id[i].equals("")) {
						sentencia.executeUpdate("insert into FirmasInfoApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId from FirmasInfo where Id = '" + id[i] + "'");
						sentencia.executeUpdate("delete from FirmasInfo where Id = '" + id[i] + "'");
					}
				}
				
				objeto = new FirmasInfo();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				resultados = sentencia.executeQuery("select A.* from FirmasInfo as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new FirmasInfo();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("IdUsuario"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setTitulo(resultados.getString("Titulo"));
					objeto.setEmail(resultados.getString("Email"));
					objeto.setNextel(resultados.getString("Nextel"));
					objeto.setNextelId(resultados.getString("NextelId"));
				}
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				sentencia.executeUpdate("update FirmasInfo set IdUsuario='" + traducciones.getEntero(request.getParameter("IdUsuario")) + "',Nombre='" + request.getParameter("Nombre") + "',Titulo='" + request.getParameter("Titulo") + "',Email='" + request.getParameter("Email") + "',Nextel='" + request.getParameter("Nextel") + "',NextelId='" + request.getParameter("NextelId") + "' where Id = '" + request.getParameter("id") + "'");
				sentencia.executeUpdate("insert into FirmasInfoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId from FirmasInfo where Id = '" + request.getParameter("id") + "'");
				
				objeto = new FirmasInfo();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setIdUsuario(request.getParameter("IdUsuario"));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setTitulo(request.getParameter("Titulo"));
					objeto.setEmail(request.getParameter("Email"));
					objeto.setNextel(request.getParameter("Nextel"));
					objeto.setNextelId(request.getParameter("NextelId"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getFirmasInfo")) {
				resultados = sentencia.executeQuery("select Id, <columna> from FirmasInfo where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<FirmasInfo> info = new ArrayList<FirmasInfo>();
				while(resultados.next()) {
					objeto = new FirmasInfo();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				
				imprimeJson(response,info);
			}
			conexion.close();
		} catch(SQLException e) {
			objeto = new FirmasInfo();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new FirmasInfo();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} finally {
			try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
			try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
			try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
		}
	}

	public void init() throws ServletException {
		// Put your code here
		try {
			dbConf = new BaseDeDatosPool();
			Context initContext = new InitialContext();
			Context envContext = (Context)initContext.lookup("java:/comp/env");
			datasource = (DataSource)envContext.lookup(dbConf.getDatabase());
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
	
	private void imprimeJson(HttpServletResponse response, FirmasInfo objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<FirmasInfo> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(FirmasInfo objeto, Exception e) {
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
/* FirmasInfoServlet */
