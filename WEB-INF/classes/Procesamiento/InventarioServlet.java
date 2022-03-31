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
import Objetos.Inventario;

import com.google.gson.Gson;

public class InventarioServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4388459805490799609L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Inventario objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public InventarioServlet() {
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
				eDB.setQuery("insert into Inventario (U,G,E,ValidarSoftware,IdTiposActivo,IdEmpresasGrupo,IdUbicacionesGrupo,NumActivoFijo,FechaCompra,FechaFinGarantia,Descripcion,IdEmpleadosGrupo,FechaAsignacionActivo,Marca,Modelo,Serie,NombreSoftware,VersionSoftware,Matricula,NumUnidad,Restauracion,IdInventario,ImporteSinIva,IdEstatusActivos) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("ValidarSoftware") + "','" + traducciones.getEntero(request.getParameter("IdTiposActivo")) + "','" + traducciones.getEntero(request.getParameter("IdEmpresasGrupo")) + "','" + traducciones.getEntero(request.getParameter("IdUbicacionesGrupo")) + "','" + request.getParameter("NumActivoFijo") + "','" + traducciones.getFecha(request.getParameter("FechaCompra")) + "','" + traducciones.getFecha(request.getParameter("FechaFinGarantia")) + "','" + request.getParameter("Descripcion") + "','" + traducciones.getEntero(request.getParameter("IdEmpleadosGrupo")) + "','" + traducciones.getFecha(request.getParameter("FechaAsignacionActivo")) + "','" + request.getParameter("Marca") + "','" + request.getParameter("Modelo") + "','" + request.getParameter("Serie") + "','" + request.getParameter("NombreSoftware") + "','" + request.getParameter("VersionSoftware") + "','" + request.getParameter("Matricula") + "','" + request.getParameter("NumUnidad") + "','" + request.getParameter("Restauracion") + "','" + traducciones.getEntero(request.getParameter("IdInventario")) + "','" + traducciones.getDecimal(request.getParameter("ImporteSinIva")) + "','" + traducciones.getEntero(request.getParameter("IdEstatusActivos")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into InventarioApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,ValidarSoftware,IdTiposActivo,IdEmpresasGrupo,IdUbicacionesGrupo,NumActivoFijo,FechaCompra,FechaFinGarantia,Descripcion,IdEmpleadosGrupo,FechaAsignacionActivo,Marca,Modelo,Serie,NombreSoftware,VersionSoftware,Matricula,NumUnidad,Restauracion,IdInventario,ImporteSinIva,IdEstatusActivos) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,ValidarSoftware,IdTiposActivo,IdEmpresasGrupo,IdUbicacionesGrupo,NumActivoFijo,FechaCompra,FechaFinGarantia,Descripcion,IdEmpleadosGrupo,FechaAsignacionActivo,Marca,Modelo,Serie,NombreSoftware,VersionSoftware,Matricula,NumUnidad,Restauracion,IdInventario,ImporteSinIva,IdEstatusActivos from Inventario where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Inventario();
				objeto.setId(ultimoId);
				objeto.setValidarSoftware(request.getParameter("ValidarSoftware"));
				objeto.setIdTiposActivo(request.getParameter("IdTiposActivo"));
				objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
				objeto.setIdUbicacionesGrupo(request.getParameter("IdUbicacionesGrupo"));
				objeto.setNumActivoFijo(request.getParameter("NumActivoFijo"));
				objeto.setFechaCompra(request.getParameter("FechaCompra"));
				objeto.setFechaFinGarantia(request.getParameter("FechaFinGarantia"));
				objeto.setDescripcion(request.getParameter("Descripcion"));
				objeto.setIdEmpleadosGrupo(request.getParameter("IdEmpleadosGrupo"));
				objeto.setFechaAsignacionActivo(request.getParameter("FechaAsignacionActivo"));
				objeto.setMarca(request.getParameter("Marca"));
				objeto.setModelo(request.getParameter("Modelo"));
				objeto.setSerie(request.getParameter("Serie"));
				objeto.setNombreSoftware(request.getParameter("NombreSoftware"));
				objeto.setVersionSoftware(request.getParameter("VersionSoftware"));
				objeto.setMatricula(request.getParameter("Matricula"));
				objeto.setNumUnidad(request.getParameter("NumUnidad"));
				objeto.setRestauracion(request.getParameter("Restauracion"));
				objeto.setIdInventario(request.getParameter("IdInventario"));
				objeto.setImporteSinIva(request.getParameter("ImporteSinIva"));
				objeto.setIdEstatusActivos(request.getParameter("IdEstatusActivos"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Inventario();
				objeto.setValidarSoftware(request.getParameter("ValidarSoftware"));
				objeto.setIdTiposActivo(request.getParameter("IdTiposActivo"));
				objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
				objeto.setIdUbicacionesGrupo(request.getParameter("IdUbicacionesGrupo"));
				objeto.setNumActivoFijo(request.getParameter("NumActivoFijo"));
				objeto.setFechaCompra(request.getParameter("FechaCompra"));
				objeto.setFechaFinGarantia(request.getParameter("FechaFinGarantia"));
				objeto.setDescripcion(request.getParameter("Descripcion"));
				objeto.setIdEmpleadosGrupo(request.getParameter("IdEmpleadosGrupo"));
				objeto.setFechaAsignacionActivo(request.getParameter("FechaAsignacionActivo"));
				objeto.setMarca(request.getParameter("Marca"));
				objeto.setModelo(request.getParameter("Modelo"));
				objeto.setSerie(request.getParameter("Serie"));
				objeto.setNombreSoftware(request.getParameter("NombreSoftware"));
				objeto.setVersionSoftware(request.getParameter("VersionSoftware"));
				objeto.setMatricula(request.getParameter("Matricula"));
				objeto.setNumUnidad(request.getParameter("NumUnidad"));
				objeto.setRestauracion(request.getParameter("Restauracion"));
				objeto.setIdInventario(request.getParameter("IdInventario"));
				objeto.setImporteSinIva(request.getParameter("ImporteSinIva"));
				objeto.setIdEstatusActivos(request.getParameter("IdEstatusActivos"));

				if(!objeto.getValidarSoftware().equals("")) { where.append(" and A.ValidarSoftware like '" + objeto.getValidarSoftware() + "%'"); entro = true;}
				if(!objeto.getIdTiposActivo().equals("")) { where.append(" and A.IdTiposActivo like '" + objeto.getIdTiposActivo() + "%'"); entro = true;}
				if(!objeto.getIdEmpresasGrupo().equals("")) { where.append(" and A.IdEmpresasGrupo like '" + objeto.getIdEmpresasGrupo() + "%'"); entro = true;}
				if(!objeto.getIdUbicacionesGrupo().equals("")) { where.append(" and A.IdUbicacionesGrupo like '" + objeto.getIdUbicacionesGrupo() + "%'"); entro = true;}
				if(!objeto.getNumActivoFijo().equals("")) { where.append(" and A.NumActivoFijo like '" + objeto.getNumActivoFijo() + "%'"); entro = true;}
				if(!objeto.getFechaCompra().equals("")) { where.append(" and A.FechaCompra like '" + objeto.getFechaCompra() + "%'"); entro = true;}
				if(!objeto.getFechaFinGarantia().equals("")) { where.append(" and A.FechaFinGarantia like '" + objeto.getFechaFinGarantia() + "%'"); entro = true;}
				if(!objeto.getDescripcion().equals("")) { where.append(" and A.Descripcion like '" + objeto.getDescripcion() + "%'"); entro = true;}
				if(!objeto.getIdEmpleadosGrupo().equals("")) { where.append(" and A.IdEmpleadosGrupo like '" + objeto.getIdEmpleadosGrupo() + "%'"); entro = true;}
				if(!objeto.getFechaAsignacionActivo().equals("")) { where.append(" and A.FechaAsignacionActivo like '" + objeto.getFechaAsignacionActivo() + "%'"); entro = true;}
				if(!objeto.getMarca().equals("")) { where.append(" and A.Marca like '" + objeto.getMarca() + "%'"); entro = true;}
				if(!objeto.getModelo().equals("")) { where.append(" and A.Modelo like '" + objeto.getModelo() + "%'"); entro = true;}
				if(!objeto.getSerie().equals("")) { where.append(" and A.Serie like '" + objeto.getSerie() + "%'"); entro = true;}
				if(!objeto.getNombreSoftware().equals("")) { where.append(" and A.NombreSoftware like '" + objeto.getNombreSoftware() + "%'"); entro = true;}
				if(!objeto.getVersionSoftware().equals("")) { where.append(" and A.VersionSoftware like '" + objeto.getVersionSoftware() + "%'"); entro = true;}
				if(!objeto.getMatricula().equals("")) { where.append(" and A.Matricula like '" + objeto.getMatricula() + "%'"); entro = true;}
				if(!objeto.getNumUnidad().equals("")) { where.append(" and A.NumUnidad like '" + objeto.getNumUnidad() + "%'"); entro = true;}
				if(!objeto.getRestauracion().equals("")) { where.append(" and A.Restauracion like '" + objeto.getRestauracion() + "%'"); entro = true;}
				if(!objeto.getIdInventario().equals("")) { where.append(" and A.IdInventario like '" + objeto.getIdInventario() + "%'"); entro = true;}
				if(!objeto.getImporteSinIva().equals("")) { where.append(" and A.ImporteSinIva like '" + objeto.getImporteSinIva() + "%'"); entro = true;}
				if(!objeto.getIdEstatusActivos().equals("")) { where.append(" and A.IdEstatusActivos like '" + objeto.getIdEstatusActivos() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from Inventario as A" + whereInicio + where.toString());
				ArrayList<Inventario> info = new ArrayList<Inventario>();
				while(resultados.next()) {
					objeto = new Inventario();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValidarSoftware(resultados.getString("ValidarSoftware"));
					objeto.setIdTiposActivo(resultados.getString("IdTiposActivo"));
					objeto.setIdEmpresasGrupo(resultados.getString("IdEmpresasGrupo"));
					objeto.setIdUbicacionesGrupo(resultados.getString("IdUbicacionesGrupo"));
					objeto.setNumActivoFijo(resultados.getString("NumActivoFijo"));
					objeto.setFechaCompra(resultados.getString("FechaCompra"));
					objeto.setFechaFinGarantia(resultados.getString("FechaFinGarantia"));
					objeto.setDescripcion(resultados.getString("Descripcion"));
					objeto.setIdEmpleadosGrupo(resultados.getString("IdEmpleadosGrupo"));
					objeto.setFechaAsignacionActivo(resultados.getString("FechaAsignacionActivo"));
					objeto.setMarca(resultados.getString("Marca"));
					objeto.setModelo(resultados.getString("Modelo"));
					objeto.setSerie(resultados.getString("Serie"));
					objeto.setNombreSoftware(resultados.getString("NombreSoftware"));
					objeto.setVersionSoftware(resultados.getString("VersionSoftware"));
					objeto.setMatricula(resultados.getString("Matricula"));
					objeto.setNumUnidad(resultados.getString("NumUnidad"));
					objeto.setRestauracion(resultados.getString("Restauracion"));
					objeto.setIdInventario(resultados.getString("IdInventario"));
					objeto.setImporteSinIva(resultados.getString("ImporteSinIva"));
					objeto.setIdEstatusActivos(resultados.getString("IdEstatusActivos"));
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
						eDB.setQuery("insert into InventarioApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,ValidarSoftware,IdTiposActivo,IdEmpresasGrupo,IdUbicacionesGrupo,NumActivoFijo,FechaCompra,FechaFinGarantia,Descripcion,IdEmpleadosGrupo,FechaAsignacionActivo,Marca,Modelo,Serie,NombreSoftware,VersionSoftware,Matricula,NumUnidad,Restauracion,IdInventario,ImporteSinIva,IdEstatusActivos) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,ValidarSoftware,IdTiposActivo,IdEmpresasGrupo,IdUbicacionesGrupo,NumActivoFijo,FechaCompra,FechaFinGarantia,Descripcion,IdEmpleadosGrupo,FechaAsignacionActivo,Marca,Modelo,Serie,NombreSoftware,VersionSoftware,Matricula,NumUnidad,Restauracion,IdInventario,ImporteSinIva,IdEstatusActivos from Inventario where Id = '" + id[i] + "'");
						eDB.setQuery("delete from Inventario where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Inventario();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from Inventario as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new Inventario();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setValidarSoftware(resultados.getString("ValidarSoftware"));
					objeto.setIdTiposActivo(resultados.getString("IdTiposActivo"));
					objeto.setIdEmpresasGrupo(resultados.getString("IdEmpresasGrupo"));
					objeto.setIdUbicacionesGrupo(resultados.getString("IdUbicacionesGrupo"));
					objeto.setNumActivoFijo(resultados.getString("NumActivoFijo"));
					objeto.setFechaCompra(resultados.getString("FechaCompra"));
					objeto.setFechaFinGarantia(resultados.getString("FechaFinGarantia"));
					objeto.setDescripcion(resultados.getString("Descripcion"));
					objeto.setIdEmpleadosGrupo(resultados.getString("IdEmpleadosGrupo"));
					objeto.setFechaAsignacionActivo(resultados.getString("FechaAsignacionActivo"));
					objeto.setMarca(resultados.getString("Marca"));
					objeto.setModelo(resultados.getString("Modelo"));
					objeto.setSerie(resultados.getString("Serie"));
					objeto.setNombreSoftware(resultados.getString("NombreSoftware"));
					objeto.setVersionSoftware(resultados.getString("VersionSoftware"));
					objeto.setMatricula(resultados.getString("Matricula"));
					objeto.setNumUnidad(resultados.getString("NumUnidad"));
					objeto.setRestauracion(resultados.getString("Restauracion"));
					objeto.setIdInventario(resultados.getString("IdInventario"));
					objeto.setImporteSinIva(resultados.getString("ImporteSinIva"));
					objeto.setIdEstatusActivos(resultados.getString("IdEstatusActivos"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update Inventario set ValidarSoftware='" + request.getParameter("ValidarSoftware") + "',IdTiposActivo='" + traducciones.getEntero(request.getParameter("IdTiposActivo")) + "',IdEmpresasGrupo='" + traducciones.getEntero(request.getParameter("IdEmpresasGrupo")) + "',IdUbicacionesGrupo='" + traducciones.getEntero(request.getParameter("IdUbicacionesGrupo")) + "',NumActivoFijo='" + request.getParameter("NumActivoFijo") + "',FechaCompra='" + traducciones.getFecha(request.getParameter("FechaCompra")) + "',FechaFinGarantia='" + traducciones.getFecha(request.getParameter("FechaFinGarantia")) + "',Descripcion='" + request.getParameter("Descripcion") + "',IdEmpleadosGrupo='" + traducciones.getEntero(request.getParameter("IdEmpleadosGrupo")) + "',FechaAsignacionActivo='" + traducciones.getFecha(request.getParameter("FechaAsignacionActivo")) + "',Marca='" + request.getParameter("Marca") + "',Modelo='" + request.getParameter("Modelo") + "',Serie='" + request.getParameter("Serie") + "',NombreSoftware='" + request.getParameter("NombreSoftware") + "',VersionSoftware='" + request.getParameter("VersionSoftware") + "',Matricula='" + request.getParameter("Matricula") + "',NumUnidad='" + request.getParameter("NumUnidad") + "',Restauracion='" + request.getParameter("Restauracion") + "',IdInventario='" + traducciones.getEntero(request.getParameter("IdInventario")) + "',ImporteSinIva='" + traducciones.getDecimal(request.getParameter("ImporteSinIva")) + "',IdEstatusActivos='" + traducciones.getEntero(request.getParameter("IdEstatusActivos")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into InventarioApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,ValidarSoftware,IdTiposActivo,IdEmpresasGrupo,IdUbicacionesGrupo,NumActivoFijo,FechaCompra,FechaFinGarantia,Descripcion,IdEmpleadosGrupo,FechaAsignacionActivo,Marca,Modelo,Serie,NombreSoftware,VersionSoftware,Matricula,NumUnidad,Restauracion,IdInventario,ImporteSinIva,IdEstatusActivos) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,ValidarSoftware,IdTiposActivo,IdEmpresasGrupo,IdUbicacionesGrupo,NumActivoFijo,FechaCompra,FechaFinGarantia,Descripcion,IdEmpleadosGrupo,FechaAsignacionActivo,Marca,Modelo,Serie,NombreSoftware,VersionSoftware,Matricula,NumUnidad,Restauracion,IdInventario,ImporteSinIva,IdEstatusActivos from Inventario where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Inventario();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setValidarSoftware(request.getParameter("ValidarSoftware"));
					objeto.setIdTiposActivo(request.getParameter("IdTiposActivo"));
					objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
					objeto.setIdUbicacionesGrupo(request.getParameter("IdUbicacionesGrupo"));
					objeto.setNumActivoFijo(request.getParameter("NumActivoFijo"));
					objeto.setFechaCompra(request.getParameter("FechaCompra"));
					objeto.setFechaFinGarantia(request.getParameter("FechaFinGarantia"));
					objeto.setDescripcion(request.getParameter("Descripcion"));
					objeto.setIdEmpleadosGrupo(request.getParameter("IdEmpleadosGrupo"));
					objeto.setFechaAsignacionActivo(request.getParameter("FechaAsignacionActivo"));
					objeto.setMarca(request.getParameter("Marca"));
					objeto.setModelo(request.getParameter("Modelo"));
					objeto.setSerie(request.getParameter("Serie"));
					objeto.setNombreSoftware(request.getParameter("NombreSoftware"));
					objeto.setVersionSoftware(request.getParameter("VersionSoftware"));
					objeto.setMatricula(request.getParameter("Matricula"));
					objeto.setNumUnidad(request.getParameter("NumUnidad"));
					objeto.setRestauracion(request.getParameter("Restauracion"));
					objeto.setIdInventario(request.getParameter("IdInventario"));
					objeto.setImporteSinIva(request.getParameter("ImporteSinIva"));
					objeto.setIdEstatusActivos(request.getParameter("IdEstatusActivos"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getInventario")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from Inventario where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<Inventario> info = new ArrayList<Inventario>();
				while(resultados.next()) {
					objeto = new Inventario();
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
			objeto = new Inventario();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Inventario();
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
	
	private void imprimeJson(HttpServletResponse response, Inventario objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Inventario> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Inventario objeto, Exception e) {
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
/* InventarioServlet */