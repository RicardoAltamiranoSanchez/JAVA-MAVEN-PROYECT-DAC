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
import Objetos.ReporteGastosViajeDetalle;

import com.google.gson.Gson;

public class ReporteGastosViajeDetalleServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5437333051424628863L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private ReporteGastosViajeDetalle objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public ReporteGastosViajeDetalleServlet() {
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
				eDB.setQuery("insert into ReporteGastosViajeDetalle (U,G,E,IdReporteGastosViaje,Fecha,Documento,Proveedor,DetalleGasto,ImporteSinIva,ImporteConIva,Iva,GastosComprobados) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + traducciones.getEntero(request.getParameter("IdReporteGastosViaje")) + "','" + traducciones.getFecha(request.getParameter("Fecha")) + "','" + request.getParameter("Documento") + "','" + request.getParameter("Proveedor") + "','" + request.getParameter("DetalleGasto") + "','" + traducciones.getDecimal(request.getParameter("ImporteSinIva")) + "','" + traducciones.getDecimal(request.getParameter("ImporteConIva")) + "','" + traducciones.getDecimal(request.getParameter("Iva")) + "','" + traducciones.getDecimal(request.getParameter("GastosComprobados")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into ReporteGastosViajeDetalleApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdReporteGastosViaje,Fecha,Documento,Proveedor,DetalleGasto,ImporteSinIva,ImporteConIva,Iva,GastosComprobados) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdReporteGastosViaje,Fecha,Documento,Proveedor,DetalleGasto,ImporteSinIva,ImporteConIva,Iva,GastosComprobados from ReporteGastosViajeDetalle where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new ReporteGastosViajeDetalle();
				objeto.setId(ultimoId);
				objeto.setIdReporteGastosViaje(request.getParameter("IdReporteGastosViaje"));
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setDocumento(request.getParameter("Documento"));
				objeto.setProveedor(request.getParameter("Proveedor"));
				objeto.setDetalleGasto(request.getParameter("DetalleGasto"));
				objeto.setImporteSinIva(request.getParameter("ImporteSinIva"));
				objeto.setImporteConIva(request.getParameter("ImporteConIva"));
				objeto.setIva(request.getParameter("Iva"));
				objeto.setGastosComprobados(request.getParameter("GastosComprobados"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new ReporteGastosViajeDetalle();
				objeto.setIdReporteGastosViaje(request.getParameter("Campo"));
				//objeto.setFecha(request.getParameter("Fecha"));
				//objeto.setDocumento(request.getParameter("Documento"));
				//objeto.setProveedor(request.getParameter("Proveedor"));
				//objeto.setDetalleGasto(request.getParameter("DetalleGasto"));
				//objeto.setImporteSinIva(request.getParameter("ImporteSinIva"));
				//objeto.setImporteConIva(request.getParameter("ImporteConIva"));
				//objeto.setIva(request.getParameter("Iva"));
				//objeto.setGastosComprobados(request.getParameter("GastosComprobados"));

				if(!objeto.getIdReporteGastosViaje().equals("")) { where.append(" and A.IdReporteGastosViaje like '" + objeto.getIdReporteGastosViaje() + "%'"); entro = true;}
				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha like '" + objeto.getFecha() + "%'"); entro = true;}
				if(!objeto.getDocumento().equals("")) { where.append(" and A.Documento like '" + objeto.getDocumento() + "%'"); entro = true;}
				if(!objeto.getProveedor().equals("")) { where.append(" and A.Proveedor like '" + objeto.getProveedor() + "%'"); entro = true;}
				if(!objeto.getDetalleGasto().equals("")) { where.append(" and A.DetalleGasto like '" + objeto.getDetalleGasto() + "%'"); entro = true;}
				if(!objeto.getImporteSinIva().equals("")) { where.append(" and A.ImporteSinIva like '" + objeto.getImporteSinIva() + "%'"); entro = true;}
				if(!objeto.getImporteConIva().equals("")) { where.append(" and A.ImporteConIva like '" + objeto.getImporteConIva() + "%'"); entro = true;}
				if(!objeto.getIva().equals("")) { where.append(" and A.Iva like '" + objeto.getIva() + "%'"); entro = true;}
				if(!objeto.getGastosComprobados().equals("")) { where.append(" and A.GastosComprobados like '" + objeto.getGastosComprobados() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				eDB.setQuery("update ReporteGastosViaje set NetoCargoFavor = (select sum(GastosComprobados) from ReporteGastosViajeDetalle where IdReporteGastosViaje = '" + request.getParameter("Campo") + "' group by IdReporteGastosViaje) - ViaticosEntregados - FacturadoDirectoEmpresa where Id = '" + request.getParameter("Campo") + "'");
				resultados = eDB.getQuery("select A.* from ReporteGastosViajeDetalle as A" + whereInicio + where.toString());
				ArrayList<ReporteGastosViajeDetalle> info = new ArrayList<ReporteGastosViajeDetalle>();
				while(resultados.next()) {
					objeto = new ReporteGastosViajeDetalle();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdReporteGastosViaje(resultados.getString("IdReporteGastosViaje"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setDocumento(resultados.getString("Documento"));
					objeto.setProveedor(resultados.getString("Proveedor"));
					objeto.setDetalleGasto(resultados.getString("DetalleGasto"));
					objeto.setImporteSinIva(resultados.getString("ImporteSinIva"));
					objeto.setImporteConIva(resultados.getString("ImporteConIva"));
					objeto.setIva(resultados.getString("Iva"));
					objeto.setGastosComprobados(resultados.getString("GastosComprobados"));
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
						eDB.setQuery("insert into ReporteGastosViajeDetalleApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdReporteGastosViaje,Fecha,Documento,Proveedor,DetalleGasto,ImporteSinIva,ImporteConIva,Iva,GastosComprobados) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdReporteGastosViaje,Fecha,Documento,Proveedor,DetalleGasto,ImporteSinIva,ImporteConIva,Iva,GastosComprobados from ReporteGastosViajeDetalle where Id = '" + id[i] + "'");
						eDB.setQuery("delete from ReporteGastosViajeDetalle where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new ReporteGastosViajeDetalle();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from ReporteGastosViajeDetalle as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new ReporteGastosViajeDetalle();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdReporteGastosViaje(resultados.getString("IdReporteGastosViaje"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setDocumento(resultados.getString("Documento"));
					objeto.setProveedor(resultados.getString("Proveedor"));
					objeto.setDetalleGasto(resultados.getString("DetalleGasto"));
					objeto.setImporteSinIva(resultados.getString("ImporteSinIva"));
					objeto.setImporteConIva(resultados.getString("ImporteConIva"));
					objeto.setIva(resultados.getString("Iva"));
					objeto.setGastosComprobados(resultados.getString("GastosComprobados"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update ReporteGastosViajeDetalle set IdReporteGastosViaje='" + traducciones.getEntero(request.getParameter("IdReporteGastosViaje")) + "',Fecha='" + traducciones.getFecha(request.getParameter("Fecha")) + "',Documento='" + request.getParameter("Documento") + "',Proveedor='" + request.getParameter("Proveedor") + "',DetalleGasto='" + request.getParameter("DetalleGasto") + "',ImporteSinIva='" + traducciones.getDecimal(request.getParameter("ImporteSinIva")) + "',ImporteConIva='" + traducciones.getDecimal(request.getParameter("ImporteConIva")) + "',Iva='" + traducciones.getDecimal(request.getParameter("Iva")) + "',GastosComprobados='" + traducciones.getDecimal(request.getParameter("GastosComprobados")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into ReporteGastosViajeDetalleApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdReporteGastosViaje,Fecha,Documento,Proveedor,DetalleGasto,ImporteSinIva,ImporteConIva,Iva,GastosComprobados) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdReporteGastosViaje,Fecha,Documento,Proveedor,DetalleGasto,ImporteSinIva,ImporteConIva,Iva,GastosComprobados from ReporteGastosViajeDetalle where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new ReporteGastosViajeDetalle();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setIdReporteGastosViaje(request.getParameter("IdReporteGastosViaje"));
					objeto.setFecha(request.getParameter("Fecha"));
					objeto.setDocumento(request.getParameter("Documento"));
					objeto.setProveedor(request.getParameter("Proveedor"));
					objeto.setDetalleGasto(request.getParameter("DetalleGasto"));
					objeto.setImporteSinIva(request.getParameter("ImporteSinIva"));
					objeto.setImporteConIva(request.getParameter("ImporteConIva"));
					objeto.setIva(request.getParameter("Iva"));
					objeto.setGastosComprobados(request.getParameter("GastosComprobados"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getReporteGastosViajeDetalle")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from ReporteGastosViajeDetalle where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<ReporteGastosViajeDetalle> info = new ArrayList<ReporteGastosViajeDetalle>();
				while(resultados.next()) {
					objeto = new ReporteGastosViajeDetalle();
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
			objeto = new ReporteGastosViajeDetalle();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new ReporteGastosViajeDetalle();
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
	
	private void imprimeJson(HttpServletResponse response, ReporteGastosViajeDetalle objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<ReporteGastosViajeDetalle> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(ReporteGastosViajeDetalle objeto, Exception e) {
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
/* ReporteGastosViajeDetalleServlet */

