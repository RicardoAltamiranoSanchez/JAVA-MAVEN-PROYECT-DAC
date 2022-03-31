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
import Objetos.DirectorioTelefonico;
import Objetos.Gerentes;

import com.google.gson.Gson;

public class DirectorioTelefonicoServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2138939568214746468L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private DirectorioTelefonico objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;
	
	private boolean debug = false;

	public DirectorioTelefonicoServlet() {
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
			
			if(debug){System.out.println("Accion: " + request.getParameter("Accion"));}
			
			if(request.getParameter("Accion").equals("Guardar")) {
				eDB.setConexion();	
						
				String varCurp = "";
				String nombreMostrar = "";
				String query1 = "select C.NombreCompleto, C.CURP from Credenciales as C where C.Id = '" + request.getParameter("IdCredenciales") + "'";
				if(debug){ System.out.println("");}
				resultados = eDB.getQuery(query1);		
				while(resultados.next()){
					nombreMostrar = resultados.getString("NombreCompleto");
					varCurp = resultados.getString("CURP");
				}
				if(debug){ System.out.println("CURP: " + varCurp);}
				
				int anioCurp = Integer.parseInt(varCurp.substring(4,6));
				String mesCurp = varCurp.substring(6,8);
				String diaCurp = varCurp.substring(8,10);
				
				if(debug){
					System.out.println("anioCurp: " + anioCurp);
					System.out.println("mesCurp: " + mesCurp);
					System.out.println("diaCurp: " + diaCurp);
				}
								
				anioCurp = anioCurp + 1900;
								
				if(anioCurp < 1909){
					anioCurp = anioCurp + 100;
				}
				
				String varFechaNacimiento = "" + anioCurp + "-" + mesCurp + "-" + diaCurp;
				
				if(debug){ System.out.println("varFechaNacimiento: " + varFechaNacimiento);}
				
								
				eDB.setQuery("insert into DirectorioTelefonico (U,G,E,IdCredenciales,FechaNacimiento,NextelId,NextelTel,Celular,Email) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + traducciones.getEntero(request.getParameter("IdCredenciales")) + "','" + traducciones.getFecha(varFechaNacimiento) + "','" + request.getParameter("NextelId") + "','" + traducciones.getEntero(request.getParameter("NextelTel")) + "','" + traducciones.getEntero(request.getParameter("Celular")) + "','" + request.getParameter("Email") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into DirectorioTelefonicoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdCredenciales,FechaNacimiento,NextelId,NextelTel,Celular,Email) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdCredenciales,FechaNacimiento,NextelId,NextelTel,Celular,Email from DirectorioTelefonico where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new DirectorioTelefonico();
				objeto.setId(ultimoId);
				objeto.setIdCredenciales(nombreMostrar);
				//objeto.setFechaNacimiento(request.getParameter("FechaNacimiento"));				
				objeto.setNextelId(request.getParameter("NextelId"));
				objeto.setNextelTel(request.getParameter("NextelTel"));
				objeto.setCelular(request.getParameter("Celular"));
				objeto.setEmail(request.getParameter("Email"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new DirectorioTelefonico();
				objeto.setIdCredenciales(request.getParameter("IdCredenciales"));
				//objeto.setFechaNacimiento(request.getParameter("FechaNacimiento"));				
				objeto.setNextelId(request.getParameter("NextelId"));
				objeto.setNextelTel(request.getParameter("NextelTel"));
				objeto.setCelular(request.getParameter("Celular"));
				objeto.setEmail(request.getParameter("Email"));

				if(!objeto.getIdCredenciales().equals("")) { where.append(" and A.IdCredenciales like '" + objeto.getIdCredenciales() + "%'"); entro = true;}
				//if(!objeto.getFechaNacimiento().equals("")) { where.append(" and A.FechaNacimiento like '" + objeto.getFechaNacimiento() + "%'"); entro = true;}				
				if(!objeto.getNextelId().equals("")) { where.append(" and A.NextelId like '" + objeto.getNextelId() + "%'"); entro = true;}
				if(!objeto.getNextelTel().equals("")) { where.append(" and A.NextelTel like '" + objeto.getNextelTel() + "%'"); entro = true;}
				if(!objeto.getCelular().equals("")) { where.append(" and A.Celular like '" + objeto.getCelular() + "%'"); entro = true;}
				if(!objeto.getEmail().equals("")) { where.append(" and A.Email like '" + objeto.getEmail() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				String query2 = "select A.*, C.NombreCompleto from DirectorioTelefonico as A Join Credenciales as C on C.Id = A.IdCredenciales " + whereInicio + where.toString();
				if(debug){System.out.println("query2: " + query2);	}			
				resultados = eDB.getQuery(query2);
				ArrayList<DirectorioTelefonico> info = new ArrayList<DirectorioTelefonico>();
				while(resultados.next()) {
					objeto = new DirectorioTelefonico();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdCredenciales(resultados.getString("NombreCompleto"));
					//objeto.setFechaNacimiento(resultados.getString("FechaNacimiento"));				
					objeto.setNextelId(resultados.getString("NextelId"));
					objeto.setNextelTel(resultados.getString("NextelTel"));
					objeto.setCelular(resultados.getString("Celular"));
					objeto.setEmail(resultados.getString("Email"));
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
						eDB.setQuery("insert into DirectorioTelefonicoApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdCredenciales,FechaNacimiento,NextelId,NextelTel,Celular,Email) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdCredenciales,FechaNacimiento,NextelId,NextelTel,Celular,Email from DirectorioTelefonico where Id = '" + id[i] + "'");
						eDB.setQuery("delete from DirectorioTelefonico where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new DirectorioTelefonico();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from DirectorioTelefonico as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new DirectorioTelefonico();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdCredenciales(resultados.getString("IdCredenciales"));
					//objeto.setFechaNacimiento(resultados.getString("FechaNacimiento"));					
					objeto.setNextelId(resultados.getString("NextelId"));
					objeto.setNextelTel(resultados.getString("NextelTel"));
					objeto.setCelular(resultados.getString("Celular"));
					objeto.setEmail(resultados.getString("Email"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				
				String varCurp = "";
				String nombreMostrar = "";
				
				String query3 = "select C.NombreCompleto, C.CURP from Credenciales as C where C.Id = '" + request.getParameter("IdCredenciales") + "'" ;	
				if(debug){ System.out.println(""+query3); }												
				eDB.setConexion();						
				resultados = eDB.getQuery(query3);				
				while (resultados.next()){
					nombreMostrar = resultados.getString("NombreCompleto");
					varCurp = resultados.getString("CURP");
				}										
				int anioCurp = Integer.parseInt(varCurp.substring(4,6));
				String mesCurp = varCurp.substring(6,8);
				String diaCurp = varCurp.substring(8,10);
											
				anioCurp = anioCurp + 1900;								
				if(anioCurp < 1909){
					anioCurp = anioCurp + 100;
				}				
				String varFechaNacimiento = "" + anioCurp + "-" + mesCurp + "-" + diaCurp;
				
				if(debug){ System.out.println("varFechaNacimiento: " + varFechaNacimiento);}
				
				eDB.setQuery("update DirectorioTelefonico set IdCredenciales='" + traducciones.getEntero(request.getParameter("IdCredenciales")) + "',FechaNacimiento='" + traducciones.getFecha(varFechaNacimiento) + "',NextelId='" + request.getParameter("NextelId") + "',NextelTel='" + traducciones.getEntero(request.getParameter("NextelTel")) + "',Celular='" + traducciones.getEntero(request.getParameter("Celular")) + "',Email='" + request.getParameter("Email") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into DirectorioTelefonicoApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdCredenciales,FechaNacimiento,NextelId,NextelTel,Celular,Email) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdCredenciales,FechaNacimiento,NextelId,NextelTel,Celular,Email from DirectorioTelefonico where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new DirectorioTelefonico();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setIdCredenciales(nombreMostrar);
					objeto.setFechaNacimiento(request.getParameter("FechaNacimiento"));					
					objeto.setNextelId(request.getParameter("NextelId"));
					objeto.setNextelTel(request.getParameter("NextelTel"));
					objeto.setCelular(request.getParameter("Celular"));
					objeto.setEmail(request.getParameter("Email"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getUsuarios")) {										
				String query = "select Id, CURP, NombreCompleto from Credenciales where NombreCompleto like '" + request.getParameter("filter[value]") + "%'" ;				
				if(debug){ System.out.println(""+query); }				
				eDB.setConexion();
				resultados = eDB.getQuery(query);
				ArrayList<DirectorioTelefonico> info = new ArrayList<DirectorioTelefonico>();
				while(resultados.next()) {										
					objeto = new DirectorioTelefonico();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("NombreCompleto"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getDirectorioTelefonico")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from DirectorioTelefonico where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<DirectorioTelefonico> info = new ArrayList<DirectorioTelefonico>();
				while(resultados.next()) {
					objeto = new DirectorioTelefonico();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new DirectorioTelefonico();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new DirectorioTelefonico();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		}
	}

	private int parseInt(String substring) {
		// TODO Auto-generated method stub
		return 0;
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
	
	private void imprimeJson(HttpServletResponse response, DirectorioTelefonico objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<DirectorioTelefonico> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(DirectorioTelefonico objeto, Exception e) {
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
/* DirectorioTelefonicoServlet */