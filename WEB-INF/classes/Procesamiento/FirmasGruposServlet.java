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
import Objetos.FirmasGrupos;
import Objetos.FirmasGrupos;
import Objetos.PuestosGrupo;

import com.google.gson.Gson;

public class FirmasGruposServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8315600625523537365L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private FirmasGrupos objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;
	
	String valor;

	public FirmasGruposServlet() {
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
				eDB.setQuery("insert into FirmasGrupos (U,G,E,GrupoEmpleados,Firma) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "', (select GrupoEmpleados from AgrupadorEmpleados where Id = '" + request.getParameter("GrupoEmpleados") + "'),'" + traducciones.getEntero(request.getParameter("Firma")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into FirmasGruposApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,GrupoEmpleados,Firma) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,GrupoEmpleados,Firma from FirmasGrupos where Id = '" + ultimoId + "'");
				// 1 Se hace una consulta en Agrupador, para traer el valor String del Id que corresnde al Grupo de esa tabla
				resultados = eDB.getQuery("select GrupoEmpleados from AgrupadorEmpleados where Id = '" + request.getParameter("GrupoEmpleados") + "'");
				// Se pone en la primer posción
				resultados.next();
				// Se crea una variable String en donde se deposita el resultado
				String Grupo = resultados.getString("GrupoEmpleados");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new FirmasGrupos();
				objeto.setId(ultimoId);
				// Se sobreescribe la asignación del valor objeto.setGrupoEmpleados(request.getParameter("GrupoEmpleados") para regresar el valor String en lugar del Id de la Tabla AgrupadorEmpleados);
				objeto.setGrupoEmpleados(Grupo);
				objeto.setFirma(request.getParameter("Firma"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where AE.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new FirmasGrupos();
				objeto.setGrupoEmpleados(request.getParameter("GrupoEmpleados"));
				objeto.setFirma(request.getParameter("Firma"));

				//if(!objeto.getGrupoEmpleados().equals("")) { where.append(" and AE.GrupoEmpleados like '" + objeto.getGrupoEmpleados() + "%'"); entro = true;}
				if(!objeto.getGrupoEmpleados().equals("")) { where.append(" and AE.GrupoEmpleados like '" + objeto.getGrupoEmpleados() + "'"); entro = true;}
				if(!objeto.getFirma().equals("")) { where.append(" and AE.Firma like '" + objeto.getFirma() + "%'"); entro = true;}
				if(entro) { whereInicio = " where AE.Id > 0"; }
				
				// se modifica para que en el reporte muestre el nombre en lugar del Id, codigo agregado a partir de left join..
				resultados = eDB.getQuery("select AE.*, E.NombreCompleto as NombreEmpleado from FirmasGrupos as AE left join Empleados as E on (E.Id = AE.Firma)" + whereInicio + where.toString());
				ArrayList<FirmasGrupos> info = new ArrayList<FirmasGrupos>();
				while(resultados.next()) {
					objeto = new FirmasGrupos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setGrupoEmpleados(resultados.getString("GrupoEmpleados"));
					//objeto.setIdAreasGrupo(resultados.getString("IdAreasGrupo")); linea por default, se cambia por la de abajo para que aparezca el nombre en lugar del Id
					objeto.setFirma(resultados.getString("Firma"));
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
						eDB.setQuery("insert into FirmasGruposApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,GrupoEmpleados,Firma) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,GrupoEmpleados,Firma from FirmasGrupos where Id = '" + id[i] + "'");
						eDB.setQuery("delete from FirmasGrupos where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new FirmasGrupos();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from FirmasGrupos as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new FirmasGrupos();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setGrupoEmpleados(resultados.getString("GrupoEmpleados"));
					objeto.setFirma(resultados.getString("Firma"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				
				try{
					valor="No Numero";
				     int numero = Integer.parseInt(request.getParameter("GrupoEmpleados"));
				}catch(NumberFormatException e){
					valor = "Numero";
				}
				
				
				
				if (valor == "No Numero"){
					eDB.setQuery("update FirmasGrupos set GrupoEmpleados= (select GrupoEmpleados from AgrupadorEmpleados where Id = '" + request.getParameter("GrupoEmpleados") + "'),Firma='" + traducciones.getEntero(request.getParameter("Firma")) + "' where Id = '" + request.getParameter("id") + "'");
					// DEBUG System.out.println("Fui Numero");
				}else{
					eDB.setQuery("update FirmasGrupos set GrupoEmpleados='" + request.getParameter("GrupoEmpleados") + "',Firma='" + traducciones.getEntero(request.getParameter("Firma")) + "' where Id = '" + request.getParameter("id") + "'");
					// DEBUG System.out.println("No Fui Un Numero");
				}
				eDB.setQuery("insert into FirmasGruposApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,GrupoEmpleados,Firma) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,GrupoEmpleados,Firma from FirmasGrupos where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new FirmasGrupos();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setGrupoEmpleados(request.getParameter("GrupoEmpleados"));
					objeto.setFirma(request.getParameter("Firma"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getFirmasGrupos")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, GrupoEmpleados from FirmasGrupos where GrupoEmpleados like '" + request.getParameter("filter[value]") + "%' group by GrupoEmpleados");
				ArrayList<FirmasGrupos> info = new ArrayList<FirmasGrupos>();
				while(resultados.next()) {
					objeto = new FirmasGrupos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("GrupoEmpleados"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getFirmasGruposNoExistentes")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, GrupoEmpleados from FirmasGrupos where GrupoEmpleados like '" + request.getParameter("filter[value]") + "%'and Not GrupoEmpleados In (select GrupoEmpleados from FirmasGrupos) group by GrupoEmpleados");
				ArrayList<FirmasGrupos> info = new ArrayList<FirmasGrupos>();
				while(resultados.next()) {
					objeto = new FirmasGrupos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("GrupoEmpleados"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			// COMBO DEPENDIENTE agrego un nuevo método que llenará los datos exclusivos pertenecientes a otra selección previa
			else if(request.getParameter("Accion").equals("getFirmasGruposDeArea")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, GrupoEmpleados from FirmasGrupos where Firma ='" + request.getParameter("filter[value]")+"'");
				ArrayList<FirmasGrupos> info = new ArrayList<FirmasGrupos>();
				while(resultados.next()) {
					objeto = new FirmasGrupos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("GrupoEmpleados"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getFirmasGruposDeAreaBanner")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, GrupoEmpleados from FirmasGrupos");
				ArrayList<FirmasGrupos> info = new ArrayList<FirmasGrupos>();
				while(resultados.next()) {
					objeto = new FirmasGrupos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("GrupoEmpleados"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new FirmasGrupos();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new FirmasGrupos();
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
	
	private void imprimeJson(HttpServletResponse response, FirmasGrupos objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<FirmasGrupos> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(FirmasGrupos objeto, Exception e) {
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
/* FirmasGruposServlet */