package Procesamiento;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import Configuraciones.Generales;
import Libreria.MysqlPool;
import Objetos.CredencialesExternos;
import Utilerias.Fechas;
import Utilerias.TraduccionesSQL;

public class CredencialesExternosServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6535376864995357708L;
	/**
	 * 
	 */
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private CredencialesExternos objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL SQL;
	/**
	 * Constructor of the object.
	 */
	public CredencialesExternosServlet() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		//valida la sesion
		validar(request,response);
		
		try{
			if(request.getParameter("Accion").equals("Guardar")) {
				String Imagen = request.getParameter("Archivo");
				Imagen = Imagen.replace(" ", "_");
				SQL = new TraduccionesSQL();
				eDB.setConexion();
				eDB.setQuery("insert into CredencialesExternos (U,G,E,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("NombreCompleto") + "','" + request.getParameter("Puesto") + "','" + request.getParameter("Empresa") + "','" + request.getParameter("Estacion") + "','" + request.getParameter("IMSS") + "','" + request.getParameter("CURP") + "','" + request.getParameter("Antiguedad") + "','" + request.getParameter("Division") + "','" + request.getParameter("Nivel") + "','" + request.getParameter("FechaEmision") + "','" + request.getParameter("FechaVigencia") + "','" + Imagen + "','" + SQL.getEntero(request.getParameter("IdImagenAdelante")) + "','" + SQL.getEntero(request.getParameter("IdImagenAtras")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into CredencialesExternosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras from CredencialesExternos where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				//guardamos los datos en el objeto
				objeto = new CredencialesExternos();
				objeto.setId(ultimoId);
				objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
				objeto.setPuesto(request.getParameter("Puesto"));
				objeto.setEmpresa(request.getParameter("Empresa"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setIMSS(request.getParameter("IMSS"));
				objeto.setCURP(request.getParameter("CURP"));
				objeto.setAntiguedad(request.getParameter("Antiguedad"));
				objeto.setDivision(request.getParameter("Division"));
				objeto.setNivel(request.getParameter("Nivel"));
				objeto.setFechaEmision(request.getParameter("FechaEmision"));
				objeto.setFechaVigencia(request.getParameter("FechaVigencia"));
				objeto.setImagen(request.getParameter("Archivo"));
				objeto.setIdImagenAdelante(request.getParameter("IdImagenAdelante"));
				objeto.setIdImagenAtras(request.getParameter("IdImagenAtras"));
				
				imprimeJson(response,objeto);
			}else if(request.getParameter("Accion").equals("Buscar")){
				StringBuffer where = new StringBuffer();
				String whereInicio = " where C.Id > 0";
				boolean entro = false;
				SQL = new TraduccionesSQL();
				
				eDB.setConexion();
				objeto = new CredencialesExternos();
				objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
				objeto.setPuesto(request.getParameter("Puesto"));
				objeto.setEmpresa(request.getParameter("Empresa"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setIMSS(request.getParameter("IMSS"));
				objeto.setCURP(request.getParameter("CURP"));
				objeto.setAntiguedad(request.getParameter("Antiguedad"));
				objeto.setDivision(request.getParameter("Division"));
				objeto.setNivel(request.getParameter("Nivel"));
				objeto.setFechaEmision(request.getParameter("FechaEmision"));
				objeto.setFechaVigencia(request.getParameter("FechaVigencia"));
				objeto.setImagen(request.getParameter("Archivo"));
				objeto.setIdImagenAdelante(request.getParameter("IdImagenAdelante"));
				objeto.setIdImagenAtras(request.getParameter("IdImagenAtras"));

				if(!objeto.getNombreCompleto().equals("")) { where.append(" and C.NombreCompleto like '" + objeto.getNombreCompleto() + "%'"); entro = true;}
				if(!objeto.getPuesto().equals("")) { where.append(" and C.Puesto like '" + objeto.getPuesto() + "%'"); entro = true;}
				if(!objeto.getEmpresa().equals("")) { where.append(" and C.Empresa like '" + objeto.getEmpresa() + "%'"); entro = true;}
				if(!objeto.getEstacion().equals("")) { where.append(" and C.Estacion like '" + objeto.getEstacion() + "%'"); entro = true;}
				if(!objeto.getIMSS().equals("")) { where.append(" and C.IMSS like '" + objeto.getIMSS() + "%'"); entro = true;}
				if(!objeto.getCURP().equals("")) { where.append(" and C.CURP like '" + objeto.getCURP() + "%'"); entro = true;}
				if(!objeto.getAntiguedad().equals("")) { where.append(" and C.Antiguedad like '" + objeto.getAntiguedad() + "%'"); entro = true;}
				if(!objeto.getDivision().equals("")) { where.append(" and C.Division like '" + objeto.getDivision() + "%'"); entro = true;}
				if(!objeto.getNivel().equals("")) { where.append(" and C.Nivel like '" + objeto.getNivel() + "%'"); entro = true;}
				if(!objeto.getFechaEmision().equals("")) { where.append(" and C.FechaEmision like '" + objeto.getFechaEmision() + "%'"); entro = true;}
				if(!objeto.getFechaVigencia().equals("")) { where.append(" and C.FechaVigencia like '" + objeto.getFechaVigencia() + "%'"); entro = true;}
				if(!objeto.getImagen().equals("")) { where.append(" and C.Imagen like '" + objeto.getImagen() + "%'"); entro = true;}
				if(!objeto.getIdImagenAdelante().equals("")) { where.append(" and C.IdImagenAdelante like '" + objeto.getIdImagenAdelante() + "%'"); entro = true;}
				if(!objeto.getIdImagenAtras().equals("")) { where.append(" and C.IdImagenAtras like '" + objeto.getIdImagenAtras() + "%'"); entro = true;}
				if(entro) { whereInicio = " where C.Id > 0"; }
				
				resultados = eDB.getQuery("select C.*,IF(C.FechaEmision = '0000-00-00','',C.FechaEmision) as FechaE, IF(C.FechaVigencia = '0000-00-00','',C.FechaVigencia) as FechaV  from CredencialesExternos as C" + whereInicio + where.toString());
				ArrayList<CredencialesExternos> info = new ArrayList<CredencialesExternos>();
				while(resultados.next()) {
					objeto = new CredencialesExternos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setEmpresa(resultados.getString("Empresa"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setIMSS(resultados.getString("IMSS"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setAntiguedad(resultados.getString("Antiguedad"));
					objeto.setDivision(resultados.getString("Division"));
					objeto.setNivel(resultados.getString("Nivel"));
					objeto.setFechaEmision(resultados.getString("FechaE"));
					objeto.setFechaVigencia(resultados.getString("FechaV"));
					objeto.setImagen(resultados.getString("Imagen"));
					objeto.setIdImagenAdelante(resultados.getString("IdImagenAdelante"));
					objeto.setIdImagenAtras(resultados.getString("IdImagenAtras"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}else if(request.getParameter("Accion").equals("Borrar")) {
				eDB.setConexion();
				String ids = request.getParameter("Ids");
				String[] id = ids.split(",");
				for(int i = 0; i < id.length; i++) {
					if(!id[i].equals("")) {
						eDB.setQuery("insert into CredencialesExternosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras from CredencialesExternos where Id = '" + id[i] + "'");
						eDB.setQuery("delete from CredencialesExternos where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new CredencialesExternos();
				imprimeJson(response,objeto);
			}else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select C.*,IF(C.FechaEmision = '0000-00-00','',C.FechaEmision) as FechaE, IF(C.FechaVigencia = '0000-00-00','',C.FechaVigencia) as FechaV from CredencialesExternos as C where C.Id = '" + request.getParameter("id") + "'");
				objeto = new CredencialesExternos();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setEmpresa(resultados.getString("Empresa"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setIMSS(resultados.getString("IMSS"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setAntiguedad(resultados.getString("Antiguedad"));
					objeto.setDivision(resultados.getString("Division"));
					objeto.setNivel(resultados.getString("Nivel"));
					objeto.setFechaEmision(resultados.getString("FechaE"));
					objeto.setFechaVigencia(resultados.getString("FechaV"));
					objeto.setImagen(resultados.getString("Imagen"));
					objeto.setIdImagenAdelante(resultados.getString("IdImagenAdelante"));
					objeto.setIdImagenAtras(resultados.getString("IdImagenAtras"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}else if(request.getParameter("Accion").equals("Modificar")) {
				String Imagen = request.getParameter("Archivo");
				Imagen = Imagen.replace(" ", "_");
				SQL = new TraduccionesSQL();
				eDB.setConexion();
				String ImagenUpdate = "";
				if(Imagen != ""){
					ImagenUpdate = "Imagen='" + Imagen + "',";
				}
				eDB.setQuery("update CredencialesExternos set NombreCompleto='" + request.getParameter("NombreCompleto") + "',Puesto='" + request.getParameter("Puesto") + "',Empresa='" + request.getParameter("Empresa") + "',Estacion='" + request.getParameter("Estacion") + "',IMSS='" + request.getParameter("IMSS") + "',CURP='" + request.getParameter("CURP") + "',Antiguedad='" + request.getParameter("Antiguedad") + "',Division='" + request.getParameter("Division") + "',Nivel='" + request.getParameter("Nivel") + "',FechaEmision='" + request.getParameter("FechaEmision") + "',FechaVigencia='" + request.getParameter("FechaVigencia") + "'," + ImagenUpdate + "IdImagenAdelante='" + SQL.getEntero(request.getParameter("IdImagenAdelante")) + "',IdImagenAtras='" + SQL.getEntero(request.getParameter("IdImagenAtras")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into CredencialesExternosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras from CredencialesExternos where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new CredencialesExternos();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
				objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
				objeto.setPuesto(request.getParameter("Puesto"));
				objeto.setEmpresa(request.getParameter("Empresa"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setIMSS(request.getParameter("IMSS"));
				objeto.setCURP(request.getParameter("CURP"));
				objeto.setAntiguedad(request.getParameter("Antiguedad"));
				objeto.setDivision(request.getParameter("Division"));
				objeto.setNivel(request.getParameter("Nivel"));
				objeto.setFechaEmision(request.getParameter("FechaEmision"));
				objeto.setFechaVigencia(request.getParameter("FechaVigencia"));
				objeto.setImagen(request.getParameter("Archivo"));
				objeto.setIdImagenAdelante(request.getParameter("IdImagenAdelante"));
				objeto.setIdImagenAtras(request.getParameter("IdImagenAtras"));
				imprimeJson(response,objeto);
			}else if(request.getParameter("Accion").equals("getCredencialesExternos")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, NombreCompleto from CredencialesExternos where NombreCompleto like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<CredencialesExternos> info = new ArrayList<CredencialesExternos>();
				while(resultados.next()) {
					objeto = new CredencialesExternos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("NombreCompleto"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}else if(request.getParameter("Accion").equals("ConsultarCredencialesExternos")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select * from CredencialesExternos");
				ArrayList<CredencialesExternos> info = new ArrayList<CredencialesExternos>();
				while(resultados.next()) {
					objeto = new CredencialesExternos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setEmpresa(resultados.getString("Empresa"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setIMSS(resultados.getString("IMSS"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setAntiguedad(resultados.getString("Antiguedad"));
					objeto.setDivision(resultados.getString("Division"));
					objeto.setNivel(resultados.getString("Nivel"));
					objeto.setFechaEmision(resultados.getString("FechaEmision"));
					objeto.setFechaVigencia(resultados.getString("FechaVigencia"));
					objeto.setImagen(resultados.getString("Imagen"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}else if(request.getParameter("Accion").equals("Actualizar")){
				eDB.setConexion();
				resultados = eDB.getQuery("select C.* from CredencialesExternos as C where C.IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				objeto = new CredencialesExternos();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setEmpresa(resultados.getString("Empresa"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setIMSS(resultados.getString("IMSS"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setAntiguedad(resultados.getString("Antiguedad"));
					objeto.setDivision(resultados.getString("Division"));
					objeto.setNivel(resultados.getString("Nivel"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}else if(request.getParameter("Accion").equals("ModificarInfo")){
				eDB.setConexion();
				resultados = eDB.getQuery("select IdUsuario from CredencialesExternos where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				if(resultados.next()){
					eDB.setQuery("update CredencialesExternos set NombreCompleto='" + request.getParameter("NombreCompleto") + "',Puesto='" + request.getParameter("Puesto") + "',Empresa='" + request.getParameter("Empresa") + "',Estacion='" + request.getParameter("Estacion") + "',IMSS='" + request.getParameter("IMSS") + "',CURP='" + request.getParameter("CURP") + "',Antiguedad='" + request.getParameter("Antiguedad") + "',Division='" + request.getParameter("Division") + "',Nivel='" + request.getParameter("Nivel") + "' where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				}else{
					resultados = eDB.getQuery("select CURP from CredencialesExternos where CURP = '" + request.getParameter("CURP") + "'");
					if(resultados.next()){
						eDB.setQuery("update CredencialesExternos set NombreCompleto='" + request.getParameter("NombreCompleto") + "',Puesto='" + request.getParameter("Puesto") + "',Empresa='" + request.getParameter("Empresa") + "',Estacion='" + request.getParameter("Estacion") + "',IMSS='" + request.getParameter("IMSS") + "',CURP='" + request.getParameter("CURP") + "',Antiguedad='" + request.getParameter("Antiguedad") + "',Division='" + request.getParameter("Division") + "',Nivel='" + request.getParameter("Nivel") + "',IdUsuario='" + session.getAttribute("IdUsuario") + "' where CURP = '" + request.getParameter("CURP") + "'");
					}else{
						eDB.setQuery("insert into CredencialesExternos (U,G,E,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,IdUsuario) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("NombreCompleto") + "','" + request.getParameter("Puesto") + "','" + request.getParameter("Empresa") + "','" + request.getParameter("Estacion") + "','" + request.getParameter("IMSS") + "','" + request.getParameter("CURP") + "','" + request.getParameter("Antiguedad") + "','" + request.getParameter("Division") + "','" + request.getParameter("Nivel") + "','" + session.getAttribute("IdUsuario") + "')");
					}
				}
				eDB.setQuery("insert into CredencialesExternosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras,IdUsuario) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras,IdUsuario from CredencialesExternos where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
			}
		} catch(SQLException e) {
			objeto = new CredencialesExternos();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new CredencialesExternos();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		}
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
		try {
			eDB = new MysqlPool();
			generales = new Generales();
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
	
	private void imprimeJson(HttpServletResponse response, CredencialesExternos objeto) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("ISO-8859-1");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<CredencialesExternos> objeto) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("ISO-8859-1");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(CredencialesExternos objeto, Exception e) {
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
