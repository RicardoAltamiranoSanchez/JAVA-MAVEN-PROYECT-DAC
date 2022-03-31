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
import Objetos.OrdenesCompra;

import com.google.gson.Gson;

public class OrdenesCompraServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2052449574565866439L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private OrdenesCompra objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public OrdenesCompraServlet() {
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
				eDB.setQuery("insert into OrdenesCompra (U,G,E,Fecha,IdEmpresasGrupo,IdProveedores,FechaEntrega,FechaPago,IdUsuarios,FechaAutorizacion,FechaFinanzas,Subtotal,Iva,IvaRetenido,IsrRetenido,Total,Llave,Factura,XmlFactura) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + traducciones.getFecha(request.getParameter("Fecha")) + "','" + traducciones.getEntero(request.getParameter("IdEmpresasGrupo")) + "','" + traducciones.getEntero(request.getParameter("IdProveedores")) + "','" + traducciones.getFecha(request.getParameter("FechaEntrega")) + "','" + traducciones.getFecha(request.getParameter("FechaPago")) + "','" + traducciones.getEntero(request.getParameter("IdUsuarios")) + "','" + traducciones.getFecha(request.getParameter("FechaAutorizacion")) + "','" + traducciones.getFecha(request.getParameter("FechaFinanzas")) + "','" + traducciones.getDecimal(request.getParameter("Subtotal")) + "','" + traducciones.getDecimal(request.getParameter("Iva")) + "','" + traducciones.getDecimal(request.getParameter("IvaRetenido")) + "','" + traducciones.getDecimal(request.getParameter("IsrRetenido")) + "','" + traducciones.getDecimal(request.getParameter("Total")) + "','" + request.getParameter("Llave") + "','" + request.getParameter("Factura") + "','" + request.getParameter("XmlFactura") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into OrdenesCompraApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,IdEmpresasGrupo,IdProveedores,FechaEntrega,FechaPago,IdUsuarios,FechaAutorizacion,FechaFinanzas,Subtotal,Iva,IvaRetenido,IsrRetenido,Total,Llave,Factura,XmlFactura) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,IdEmpresasGrupo,IdProveedores,FechaEntrega,FechaPago,IdUsuarios,FechaAutorizacion,FechaFinanzas,Subtotal,Iva,IvaRetenido,IsrRetenido,Total,Llave,Factura,XmlFactura from OrdenesCompra where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new OrdenesCompra();
				objeto.setId(ultimoId);
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
				objeto.setIdProveedores(request.getParameter("IdProveedores"));
				objeto.setFechaEntrega(request.getParameter("FechaEntrega"));
				objeto.setFechaPago(request.getParameter("FechaPago"));
				objeto.setIdUsuarios(request.getParameter("IdUsuarios"));
				objeto.setFechaAutorizacion(request.getParameter("FechaAutorizacion"));
				objeto.setFechaFinanzas(request.getParameter("FechaFinanzas"));
				objeto.setSubtotal(request.getParameter("Subtotal"));
				objeto.setIva(request.getParameter("Iva"));
				objeto.setIvaRetenido(request.getParameter("IvaRetenido"));
				objeto.setIsrRetenido(request.getParameter("IsrRetenido"));
				objeto.setTotal(request.getParameter("Total"));
				objeto.setLlave(request.getParameter("Llave"));
				objeto.setFactura(request.getParameter("Factura"));
				objeto.setXmlFactura(request.getParameter("XmlFactura"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new OrdenesCompra();
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
				objeto.setIdProveedores(request.getParameter("IdProveedores"));
				objeto.setFechaEntrega(request.getParameter("FechaEntrega"));
				objeto.setFechaPago(request.getParameter("FechaPago"));
				objeto.setIdUsuarios(request.getParameter("IdUsuarios"));
				objeto.setFechaAutorizacion(request.getParameter("FechaAutorizacion"));
				objeto.setFechaFinanzas(request.getParameter("FechaFinanzas"));
				objeto.setSubtotal(request.getParameter("Subtotal"));
				objeto.setIva(request.getParameter("Iva"));
				objeto.setIvaRetenido(request.getParameter("IvaRetenido"));
				objeto.setIsrRetenido(request.getParameter("IsrRetenido"));
				objeto.setTotal(request.getParameter("Total"));
				objeto.setLlave(request.getParameter("Llave"));
				objeto.setFactura(request.getParameter("Factura"));
				objeto.setXmlFactura(request.getParameter("XmlFactura"));

				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha like '" + objeto.getFecha() + "%'"); entro = true;}
				if(!objeto.getIdEmpresasGrupo().equals("")) { where.append(" and A.IdEmpresasGrupo like '" + objeto.getIdEmpresasGrupo() + "%'"); entro = true;}
				if(!objeto.getIdProveedores().equals("")) { where.append(" and A.IdProveedores like '" + objeto.getIdProveedores() + "%'"); entro = true;}
				if(!objeto.getFechaEntrega().equals("")) { where.append(" and A.FechaEntrega like '" + objeto.getFechaEntrega() + "%'"); entro = true;}
				if(!objeto.getFechaPago().equals("")) { where.append(" and A.FechaPago like '" + objeto.getFechaPago() + "%'"); entro = true;}
				if(!objeto.getIdUsuarios().equals("")) { where.append(" and A.IdUsuarios like '" + objeto.getIdUsuarios() + "%'"); entro = true;}
				if(!objeto.getFechaAutorizacion().equals("")) { where.append(" and A.FechaAutorizacion like '" + objeto.getFechaAutorizacion() + "%'"); entro = true;}
				if(!objeto.getFechaFinanzas().equals("")) { where.append(" and A.FechaFinanzas like '" + objeto.getFechaFinanzas() + "%'"); entro = true;}
				if(!objeto.getSubtotal().equals("")) { where.append(" and A.Subtotal like '" + objeto.getSubtotal() + "%'"); entro = true;}
				if(!objeto.getIva().equals("")) { where.append(" and A.Iva like '" + objeto.getIva() + "%'"); entro = true;}
				if(!objeto.getIvaRetenido().equals("")) { where.append(" and A.IvaRetenido like '" + objeto.getIvaRetenido() + "%'"); entro = true;}
				if(!objeto.getIsrRetenido().equals("")) { where.append(" and A.IsrRetenido like '" + objeto.getIsrRetenido() + "%'"); entro = true;}
				if(!objeto.getTotal().equals("")) { where.append(" and A.Total like '" + objeto.getTotal() + "%'"); entro = true;}
				if(!objeto.getLlave().equals("")) { where.append(" and A.Llave like '" + objeto.getLlave() + "%'"); entro = true;}
				if(!objeto.getFactura().equals("")) { where.append(" and A.Factura like '" + objeto.getFactura() + "%'"); entro = true;}
				if(!objeto.getXmlFactura().equals("")) { where.append(" and A.XmlFactura like '" + objeto.getXmlFactura() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from OrdenesCompra as A" + whereInicio + where.toString());
				ArrayList<OrdenesCompra> info = new ArrayList<OrdenesCompra>();
				while(resultados.next()) {
					objeto = new OrdenesCompra();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setIdEmpresasGrupo(resultados.getString("IdEmpresasGrupo"));
					objeto.setIdProveedores(resultados.getString("IdProveedores"));
					objeto.setFechaEntrega(resultados.getString("FechaEntrega"));
					objeto.setFechaPago(resultados.getString("FechaPago"));
					objeto.setIdUsuarios(resultados.getString("IdUsuarios"));
					objeto.setFechaAutorizacion(resultados.getString("FechaAutorizacion"));
					objeto.setFechaFinanzas(resultados.getString("FechaFinanzas"));
					objeto.setSubtotal(resultados.getString("Subtotal"));
					objeto.setIva(resultados.getString("Iva"));
					objeto.setIvaRetenido(resultados.getString("IvaRetenido"));
					objeto.setIsrRetenido(resultados.getString("IsrRetenido"));
					objeto.setTotal(resultados.getString("Total"));
					objeto.setLlave(resultados.getString("Llave"));
					objeto.setFactura(resultados.getString("Factura"));
					objeto.setXmlFactura(resultados.getString("XmlFactura"));
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
						eDB.setQuery("insert into OrdenesCompraApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,IdEmpresasGrupo,IdProveedores,FechaEntrega,FechaPago,IdUsuarios,FechaAutorizacion,FechaFinanzas,Subtotal,Iva,IvaRetenido,IsrRetenido,Total,Llave,Factura,XmlFactura) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,IdEmpresasGrupo,IdProveedores,FechaEntrega,FechaPago,IdUsuarios,FechaAutorizacion,FechaFinanzas,Subtotal,Iva,IvaRetenido,IsrRetenido,Total,Llave,Factura,XmlFactura from OrdenesCompra where Id = '" + id[i] + "'");
						eDB.setQuery("delete from OrdenesCompra where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new OrdenesCompra();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from OrdenesCompra as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new OrdenesCompra();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setIdEmpresasGrupo(resultados.getString("IdEmpresasGrupo"));
					objeto.setIdProveedores(resultados.getString("IdProveedores"));
					objeto.setFechaEntrega(resultados.getString("FechaEntrega"));
					objeto.setFechaPago(resultados.getString("FechaPago"));
					objeto.setIdUsuarios(resultados.getString("IdUsuarios"));
					objeto.setFechaAutorizacion(resultados.getString("FechaAutorizacion"));
					objeto.setFechaFinanzas(resultados.getString("FechaFinanzas"));
					objeto.setSubtotal(resultados.getString("Subtotal"));
					objeto.setIva(resultados.getString("Iva"));
					objeto.setIvaRetenido(resultados.getString("IvaRetenido"));
					objeto.setIsrRetenido(resultados.getString("IsrRetenido"));
					objeto.setTotal(resultados.getString("Total"));
					objeto.setLlave(resultados.getString("Llave"));
					objeto.setFactura(resultados.getString("Factura"));
					objeto.setXmlFactura(resultados.getString("XmlFactura"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update OrdenesCompra set Fecha='" + traducciones.getFecha(request.getParameter("Fecha")) + "',IdEmpresasGrupo='" + traducciones.getEntero(request.getParameter("IdEmpresasGrupo")) + "',IdProveedores='" + traducciones.getEntero(request.getParameter("IdProveedores")) + "',FechaEntrega='" + traducciones.getFecha(request.getParameter("FechaEntrega")) + "',FechaPago='" + traducciones.getFecha(request.getParameter("FechaPago")) + "',IdUsuarios='" + traducciones.getEntero(request.getParameter("IdUsuarios")) + "',FechaAutorizacion='" + traducciones.getFecha(request.getParameter("FechaAutorizacion")) + "',FechaFinanzas='" + traducciones.getFecha(request.getParameter("FechaFinanzas")) + "',Subtotal='" + traducciones.getDecimal(request.getParameter("Subtotal")) + "',Iva='" + traducciones.getDecimal(request.getParameter("Iva")) + "',IvaRetenido='" + traducciones.getDecimal(request.getParameter("IvaRetenido")) + "',IsrRetenido='" + traducciones.getDecimal(request.getParameter("IsrRetenido")) + "',Total='" + traducciones.getDecimal(request.getParameter("Total")) + "',Llave='" + request.getParameter("Llave") + "',Factura='" + request.getParameter("Factura") + "',XmlFactura='" + request.getParameter("XmlFactura") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into OrdenesCompraApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,IdEmpresasGrupo,IdProveedores,FechaEntrega,FechaPago,IdUsuarios,FechaAutorizacion,FechaFinanzas,Subtotal,Iva,IvaRetenido,IsrRetenido,Total,Llave,Factura,XmlFactura) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,IdEmpresasGrupo,IdProveedores,FechaEntrega,FechaPago,IdUsuarios,FechaAutorizacion,FechaFinanzas,Subtotal,Iva,IvaRetenido,IsrRetenido,Total,Llave,Factura,XmlFactura from OrdenesCompra where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new OrdenesCompra();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setFecha(request.getParameter("Fecha"));
					objeto.setIdEmpresasGrupo(request.getParameter("IdEmpresasGrupo"));
					objeto.setIdProveedores(request.getParameter("IdProveedores"));
					objeto.setFechaEntrega(request.getParameter("FechaEntrega"));
					objeto.setFechaPago(request.getParameter("FechaPago"));
					objeto.setIdUsuarios(request.getParameter("IdUsuarios"));
					objeto.setFechaAutorizacion(request.getParameter("FechaAutorizacion"));
					objeto.setFechaFinanzas(request.getParameter("FechaFinanzas"));
					objeto.setSubtotal(request.getParameter("Subtotal"));
					objeto.setIva(request.getParameter("Iva"));
					objeto.setIvaRetenido(request.getParameter("IvaRetenido"));
					objeto.setIsrRetenido(request.getParameter("IsrRetenido"));
					objeto.setTotal(request.getParameter("Total"));
					objeto.setLlave(request.getParameter("Llave"));
					objeto.setFactura(request.getParameter("Factura"));
					objeto.setXmlFactura(request.getParameter("XmlFactura"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getOrdenesCompra")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from OrdenesCompra where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<OrdenesCompra> info = new ArrayList<OrdenesCompra>();
				while(resultados.next()) {
					objeto = new OrdenesCompra();
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
			objeto = new OrdenesCompra();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new OrdenesCompra();
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
	
	private void imprimeJson(HttpServletResponse response, OrdenesCompra objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<OrdenesCompra> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(OrdenesCompra objeto, Exception e) {
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
/* OrdenesCompraServlet */
