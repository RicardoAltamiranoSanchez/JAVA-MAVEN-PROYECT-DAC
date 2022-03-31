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
import Objetos.Credenciales;
import Utilerias.Fechas;
import Utilerias.TraduccionesSQL;

public class CredencialesServlet extends HttpServlet {

	/**
	 *
	 */
	private static final long serialVersionUID = -5429892676148512970L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Credenciales objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL SQL;
	/**
	 * Constructor of the object.
	 */
	public CredencialesServlet() {
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
				Imagen = Imagen.replaceAll("á","a");
				Imagen = Imagen.replaceAll("é","e");
				Imagen = Imagen.replaceAll("í","i");
				Imagen = Imagen.replaceAll("ó","o");
				Imagen = Imagen.replaceAll("ú","u");
				Imagen = Imagen.replaceAll("Á","A");
				Imagen = Imagen.replaceAll("É","E");
				Imagen = Imagen.replaceAll("Í","I");
				Imagen = Imagen.replaceAll("Ó","O");
				Imagen = Imagen.replaceAll("Ú","U");
				Imagen = Imagen.replaceAll("ñ","n");
				Imagen = Imagen.replaceAll("Ñ","N");
				Imagen = Imagen.replaceAll("ü","u");
				Imagen = Imagen.replaceAll("Ü","U");
				
				
				SQL = new TraduccionesSQL();
				eDB.setConexion();
				//ANTES DIVISION
				//eDB.setQuery("insert into Credenciales (U,G,E,NombreCompleto,CorreoElectronico,Telefono,Domicilio,PaginaWeb,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("NombreCompleto") + "','" + request.getParameter("Puesto") + "','" + request.getParameter("Empresa") + "','" + request.getParameter("Estacion") + "','" + request.getParameter("IMSS") + "','" + request.getParameter("CURP") + "','" + request.getParameter("Antiguedad") + "','" + request.getParameter("Division") + "','" + request.getParameter("Nivel") + "','" + request.getParameter("FechaEmision") + "','" + request.getParameter("FechaVigencia") + "','" + Imagen + "','" + SQL.getEntero(request.getParameter("IdImagenAdelante")) + "','" + SQL.getEntero(request.getParameter("IdImagenAtras")) + "')");
				eDB.setQuery("insert into Credenciales (U,G,E,NombreCompleto,CorreoElectronico,Telefono,Domicilio,PaginaWeb,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras,Admon) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("NombreCompleto") + "','" + request.getParameter("CorreoElectronico") + "','" + request.getParameter("Telefono") + "','" + request.getParameter("Domicilio") + "','" + request.getParameter("PaginaWeb") + "','" + request.getParameter("Puesto") + "','" + request.getParameter("Empresa") + "','" + request.getParameter("Estacion") + "','" + request.getParameter("IMSS") + "','" + request.getParameter("CURP") + "','" + request.getParameter("Antiguedad") + "','" + request.getParameter("Division") + "','" + request.getParameter("Nivel") + "','" + request.getParameter("FechaEmision") + "','" + request.getParameter("FechaVigencia") + "','" + Imagen + "','" + SQL.getEntero(request.getParameter("IdImagenAdelante")) + "','" + SQL.getEntero(request.getParameter("IdImagenAtras")) + "',(select EG.Admon from EmpresasGrupo as EG, Empleados as E, Usuarios as U where E.IdUsuario = U.Id and E.Division = EG.Id and U.Id = '" + session.getAttribute("IdUsuario") + "'))");
				ultimoId = eDB.getUltimoId();
				//ANTES DIVISION
				//eDB.setQuery("insert into CredencialesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreCompleto,CorreoElectronico,Telefono,Domicilio,PaginaWeb,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreCompleto,CorreoElectronico,Telefono,Domicilio,PaginaWeb,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras from Credenciales where Id = '" + ultimoId + "'");
				eDB.setQuery("insert into CredencialesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreCompleto,CorreoElectronico,Telefono,Domicilio,PaginaWeb,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras,Admon) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreCompleto,CorreoElectronico,Telefono,Domicilio,PaginaWeb,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras,Admon from Credenciales where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				//guardamos los datos en el objeto
				objeto = new Credenciales();
				objeto.setId(ultimoId);
				objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
				objeto.setCorreoElectronico(request.getParameter("CorreoElectronico"));
				objeto.setTelefono(request.getParameter("Telefono"));
				objeto.setDomicilio(request.getParameter("Domicilio"));
				objeto.setPaginaWeb(request.getParameter("PaginaWeb"));
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
				objeto = new Credenciales();
				objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
				objeto.setCorreoElectronico(request.getParameter("CorreoElectronico"));
				objeto.setTelefono(request.getParameter("Telefono"));
				objeto.setDomicilio(request.getParameter("Domicilio"));
				objeto.setPaginaWeb(request.getParameter("PaginaWeb"));
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
				if(!objeto.getCorreoElectronico().equals("")) { where.append(" and C.CorreoElectronico like '" + objeto.getCorreoElectronico() + "%'"); entro = true;}
				if(!objeto.getTelefono().equals("")) { where.append(" and C.Telefono like '" + objeto.getTelefono() + "%'"); entro = true;}
				if(!objeto.getDomicilio().equals("")) { where.append(" and C.Domicilio like '" + objeto.getDomicilio() + "%'"); entro = true;}
				if(!objeto.getPaginaWeb().equals("")) { where.append(" and C.PaginaWeb like '" + objeto.getPaginaWeb() + "%'"); entro = true;}
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
				
				//ANTES DIVISION
				//resultados = eDB.getQuery("select C.*,IF(C.FechaEmision = '0000-00-00','',C.FechaEmision) as FechaE, IF(C.FechaVigencia = '0000-00-00','',C.FechaVigencia) as FechaV  from Credenciales as C" + whereInicio + where.toString());
				resultados = eDB.getQuery("select C.*,IF(C.FechaEmision = '0000-00-00','',C.FechaEmision) as FechaE, IF(C.FechaVigencia = '0000-00-00','',C.FechaVigencia) as FechaV  from Credenciales as C" + whereInicio + where.toString()+" and C.Admon = (select EG.Admon as Admon from EmpresasGrupo as EG, Empleados as E, Usuarios as U where E.IdUsuario = U.Id and E.Division = EG.Id and U.Id = '" + session.getAttribute("IdUsuario") + "')");
				ArrayList<Credenciales> info = new ArrayList<Credenciales>();
				while(resultados.next()) {
					objeto = new Credenciales();
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setCorreoElectronico(resultados.getString("CorreoElectronico"));
					objeto.setTelefono(resultados.getString("Telefono"));
					objeto.setDomicilio(resultados.getString("Domicilio"));
					objeto.setPaginaWeb(resultados.getString("PaginaWeb"));
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
						eDB.setQuery("insert into CredencialesApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,NombreCompleto,CorreoElectronico,Telefono,Domicilio,PaginaWeb,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,NombreCompleto,CorreoElectronico,Telefono,Domicilio,PaginaWeb,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras from Credenciales where Id = '" + id[i] + "'");
						eDB.setQuery("delete from Credenciales where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Credenciales();
				imprimeJson(response,objeto);
			}else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				//ANTES DIVISION
				//resultados = eDB.getQuery("select C.*,IF(C.FechaEmision = '0000-00-00','',C.FechaEmision) as FechaE, IF(C.FechaVigencia = '0000-00-00','',C.FechaVigencia) as FechaV from Credenciales as C where C.Id = '" + request.getParameter("id") + "'");
				resultados = eDB.getQuery("select C.*,IF(C.FechaEmision = '0000-00-00','',C.FechaEmision) as FechaE, IF(C.FechaVigencia = '0000-00-00','',C.FechaVigencia) as FechaV from Credenciales as C where C.Id = '" + request.getParameter("id") + "' and C.Admon = (select EG.Admon as Admon from EmpresasGrupo as EG, Empleados as E, Usuarios as U where E.IdUsuario = U.Id and E.Division = EG.Id and U.Id = '" + session.getAttribute("IdUsuario") + "')");
				objeto = new Credenciales();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setCorreoElectronico(resultados.getString("CorreoElectronico"));
					objeto.setTelefono(resultados.getString("Telefono"));
					objeto.setDomicilio(resultados.getString("Domicilio"));
					objeto.setPaginaWeb(resultados.getString("PaginaWeb"));
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
				Imagen = Imagen.replaceAll("á","a");
				Imagen = Imagen.replaceAll("é","e");
				Imagen = Imagen.replaceAll("í","i");
				Imagen = Imagen.replaceAll("ó","o");
				Imagen = Imagen.replaceAll("ú","u");
				Imagen = Imagen.replaceAll("Á","A");
				Imagen = Imagen.replaceAll("É","E");
				Imagen = Imagen.replaceAll("Í","I");
				Imagen = Imagen.replaceAll("Ó","O");
				Imagen = Imagen.replaceAll("Ú","U");
				Imagen = Imagen.replaceAll("ñ","n");
				Imagen = Imagen.replaceAll("Ñ","N");
				Imagen = Imagen.replaceAll("ü","u");
				Imagen = Imagen.replaceAll("Ü","U");
				SQL = new TraduccionesSQL();
				eDB.setConexion();
				String ImagenUpdate = "";
				if(Imagen != ""){
					ImagenUpdate = "Imagen='" + Imagen + "',";
				}
				eDB.setQuery("update Credenciales set NombreCompleto='" + request.getParameter("NombreCompleto") + "',CorreoElectronico='" + request.getParameter("CorreoElectronico") + "',Telefono='" + request.getParameter("Telefono") + "',Domicilio='" + request.getParameter("Domicilio") + "',PaginaWeb='" + request.getParameter("PaginaWeb") + "',Puesto='" + request.getParameter("Puesto") + "',Empresa='" + request.getParameter("Empresa") + "',Estacion='" + request.getParameter("Estacion") + "',IMSS='" + request.getParameter("IMSS") + "',CURP='" + request.getParameter("CURP") + "',Antiguedad='" + request.getParameter("Antiguedad") + "',Division='" + request.getParameter("Division") + "',Nivel='" + request.getParameter("Nivel") + "',FechaEmision='" + request.getParameter("FechaEmision") + "',FechaVigencia='" + request.getParameter("FechaVigencia") + "'," + ImagenUpdate + "IdImagenAdelante='" + SQL.getEntero(request.getParameter("IdImagenAdelante")) + "',IdImagenAtras='" + SQL.getEntero(request.getParameter("IdImagenAtras")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into CredencialesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreCompleto,CorreoElectronico,Telefono,Domicilio,PaginaWeb,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreCompleto,CorreoElectronico,Telefono,Domicilio,PaginaWeb,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras from Credenciales where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Credenciales();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
				objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
				objeto.setCorreoElectronico(request.getParameter("CorreoElectronico"));
				objeto.setTelefono(request.getParameter("Telefono"));
				objeto.setDomicilio(request.getParameter("Domicilio"));
				objeto.setPaginaWeb(request.getParameter("PaginaWeb"));
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
			}else if(request.getParameter("Accion").equals("getCredenciales")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, NombreCompleto from Credenciales where NombreCompleto like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<Credenciales> info = new ArrayList<Credenciales>();
				while(resultados.next()) {
					objeto = new Credenciales();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("NombreCompleto"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}else if(request.getParameter("Accion").equals("ConsultarCredenciales")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select * from Credenciales");
				ArrayList<Credenciales> info = new ArrayList<Credenciales>();
				while(resultados.next()) {
					objeto = new Credenciales();
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
				resultados = eDB.getQuery("select C.* from Credenciales as C where C.IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				objeto = new Credenciales();
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
				resultados = eDB.getQuery("select IdUsuario from Credenciales where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				if(resultados.next()){
					eDB.setQuery("update Credenciales set NombreCompleto='" + request.getParameter("NombreCompleto") + "',Puesto='" + request.getParameter("Puesto") + "',Empresa='" + request.getParameter("Empresa") + "',Estacion='" + request.getParameter("Estacion") + "',IMSS='" + request.getParameter("IMSS") + "',CURP='" + request.getParameter("CURP") + "',Antiguedad='" + request.getParameter("Antiguedad") + "',Division='" + request.getParameter("Division") + "',Nivel='" + request.getParameter("Nivel") + "' where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				}else{
					resultados = eDB.getQuery("select CURP from Credenciales where CURP = '" + request.getParameter("CURP") + "'");
					if(resultados.next()){
						eDB.setQuery("update Credenciales set NombreCompleto='" + request.getParameter("NombreCompleto") + "',Puesto='" + request.getParameter("Puesto") + "',Empresa='" + request.getParameter("Empresa") + "',Estacion='" + request.getParameter("Estacion") + "',IMSS='" + request.getParameter("IMSS") + "',CURP='" + request.getParameter("CURP") + "',Antiguedad='" + request.getParameter("Antiguedad") + "',Division='" + request.getParameter("Division") + "',Nivel='" + request.getParameter("Nivel") + "',IdUsuario='" + session.getAttribute("IdUsuario") + "' where CURP = '" + request.getParameter("CURP") + "'");
					}else{
						eDB.setQuery("insert into Credenciales (U,G,E,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,IdUsuario) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("NombreCompleto") + "','" + request.getParameter("Puesto") + "','" + request.getParameter("Empresa") + "','" + request.getParameter("Estacion") + "','" + request.getParameter("IMSS") + "','" + request.getParameter("CURP") + "','" + request.getParameter("Antiguedad") + "','" + request.getParameter("Division") + "','" + request.getParameter("Nivel") + "','" + session.getAttribute("IdUsuario") + "')");
					}
				}
				eDB.setQuery("insert into CredencialesApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras,IdUsuario) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,NombreCompleto,Puesto,Empresa,Estacion,IMSS,CURP,Antiguedad,Division,Nivel,FechaEmision,FechaVigencia,Imagen,IdImagenAdelante,IdImagenAtras,IdUsuario from Credenciales where IdUsuario = '" + session.getAttribute("IdUsuario") + "'");
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
			}
		} catch(SQLException e) {
			objeto = new Credenciales();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Credenciales();
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
	
	private void imprimeJson(HttpServletResponse response, Credenciales objeto) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("ISO-8859-1");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Credenciales> objeto) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("ISO-8859-1");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Credenciales objeto, Exception e) {
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
