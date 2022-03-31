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
import Objetos.OrdenesCompraConceptos;

import com.google.gson.Gson;

public class OrdenesCompraConceptosServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5253662563860924386L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private OrdenesCompraConceptos objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public OrdenesCompraConceptosServlet() {
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
				eDB.setQuery("insert into OrdenesCompraConceptos (U,G,E,Llave,Articulo,Cantidad,Unidad,Precio,Importe,PorIva,Iva,IvaRetenido,IsrRetenido,Total) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Llave") + "','" + request.getParameter("Articulo") + "','" + traducciones.getDecimal(request.getParameter("Cantidad")) + "','" + request.getParameter("Unidad") + "','" + traducciones.getDecimal(request.getParameter("Precio")) + "','" + traducciones.getDecimal(request.getParameter("Importe")) + "','" + traducciones.getEntero(request.getParameter("PorIva")) + "','" + traducciones.getDecimal(request.getParameter("Iva")) + "','" + traducciones.getDecimal(request.getParameter("IvaRetenido")) + "','" + traducciones.getDecimal(request.getParameter("IsrRetenido")) + "','" + traducciones.getDecimal(request.getParameter("Total")) + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into OrdenesCompraConceptosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Llave,Articulo,Cantidad,Unidad,Precio,Importe,PorIva,Iva,IvaRetenido,IsrRetenido,Total) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Llave,Articulo,Cantidad,Unidad,Precio,Importe,PorIva,Iva,IvaRetenido,IsrRetenido,Total from OrdenesCompraConceptos where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new OrdenesCompraConceptos();
				objeto.setId(ultimoId);
				objeto.setLlave(request.getParameter("Llave"));
				objeto.setArticulo(request.getParameter("Articulo"));
				objeto.setCantidad(request.getParameter("Cantidad"));
				objeto.setUnidad(request.getParameter("Unidad"));
				objeto.setPrecio(request.getParameter("Precio"));
				objeto.setImporte(request.getParameter("Importe"));
				objeto.setPorIva(request.getParameter("PorIva"));
				objeto.setIva(request.getParameter("Iva"));
				objeto.setIvaRetenido(request.getParameter("IvaRetenido"));
				objeto.setIsrRetenido(request.getParameter("IsrRetenido"));
				objeto.setTotal(request.getParameter("Total"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new OrdenesCompraConceptos();
				objeto.setLlave(request.getParameter("Llave"));
				objeto.setArticulo(request.getParameter("Articulo"));
				objeto.setCantidad(request.getParameter("Cantidad"));
				objeto.setUnidad(request.getParameter("Unidad"));
				objeto.setPrecio(request.getParameter("Precio"));
				objeto.setImporte(request.getParameter("Importe"));
				objeto.setPorIva(request.getParameter("PorIva"));
				objeto.setIva(request.getParameter("Iva"));
				objeto.setIvaRetenido(request.getParameter("IvaRetenido"));
				objeto.setIsrRetenido(request.getParameter("IsrRetenido"));
				objeto.setTotal(request.getParameter("Total"));

				if(!objeto.getLlave().equals("")) { where.append(" and A.Llave like '" + objeto.getLlave() + "%'"); entro = true;}
				if(!objeto.getArticulo().equals("")) { where.append(" and A.Articulo like '" + objeto.getArticulo() + "%'"); entro = true;}
				if(!objeto.getCantidad().equals("")) { where.append(" and A.Cantidad like '" + objeto.getCantidad() + "%'"); entro = true;}
				if(!objeto.getUnidad().equals("")) { where.append(" and A.Unidad like '" + objeto.getUnidad() + "%'"); entro = true;}
				if(!objeto.getPrecio().equals("")) { where.append(" and A.Precio like '" + objeto.getPrecio() + "%'"); entro = true;}
				if(!objeto.getImporte().equals("")) { where.append(" and A.Importe like '" + objeto.getImporte() + "%'"); entro = true;}
				if(!objeto.getPorIva().equals("")) { where.append(" and A.PorIva like '" + objeto.getPorIva() + "%'"); entro = true;}
				if(!objeto.getIva().equals("")) { where.append(" and A.Iva like '" + objeto.getIva() + "%'"); entro = true;}
				if(!objeto.getIvaRetenido().equals("")) { where.append(" and A.IvaRetenido like '" + objeto.getIvaRetenido() + "%'"); entro = true;}
				if(!objeto.getIsrRetenido().equals("")) { where.append(" and A.IsrRetenido like '" + objeto.getIsrRetenido() + "%'"); entro = true;}
				if(!objeto.getTotal().equals("")) { where.append(" and A.Total like '" + objeto.getTotal() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from OrdenesCompraConceptos as A" + whereInicio + where.toString());
				ArrayList<OrdenesCompraConceptos> info = new ArrayList<OrdenesCompraConceptos>();
				while(resultados.next()) {
					objeto = new OrdenesCompraConceptos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setLlave(resultados.getString("Llave"));
					objeto.setArticulo(resultados.getString("Articulo"));
					objeto.setCantidad(resultados.getString("Cantidad"));
					objeto.setUnidad(resultados.getString("Unidad"));
					objeto.setPrecio(resultados.getString("Precio"));
					objeto.setImporte(resultados.getString("Importe"));
					objeto.setPorIva(resultados.getString("PorIva"));
					objeto.setIva(resultados.getString("Iva"));
					objeto.setIvaRetenido(resultados.getString("IvaRetenido"));
					objeto.setIsrRetenido(resultados.getString("IsrRetenido"));
					objeto.setTotal(resultados.getString("Total"));
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
						eDB.setQuery("insert into OrdenesCompraConceptosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Llave,Articulo,Cantidad,Unidad,Precio,Importe,PorIva,Iva,IvaRetenido,IsrRetenido,Total) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Llave,Articulo,Cantidad,Unidad,Precio,Importe,PorIva,Iva,IvaRetenido,IsrRetenido,Total from OrdenesCompraConceptos where Id = '" + id[i] + "'");
						eDB.setQuery("delete from OrdenesCompraConceptos where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new OrdenesCompraConceptos();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from OrdenesCompraConceptos as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new OrdenesCompraConceptos();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setLlave(resultados.getString("Llave"));
					objeto.setArticulo(resultados.getString("Articulo"));
					objeto.setCantidad(resultados.getString("Cantidad"));
					objeto.setUnidad(resultados.getString("Unidad"));
					objeto.setPrecio(resultados.getString("Precio"));
					objeto.setImporte(resultados.getString("Importe"));
					objeto.setPorIva(resultados.getString("PorIva"));
					objeto.setIva(resultados.getString("Iva"));
					objeto.setIvaRetenido(resultados.getString("IvaRetenido"));
					objeto.setIsrRetenido(resultados.getString("IsrRetenido"));
					objeto.setTotal(resultados.getString("Total"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update OrdenesCompraConceptos set Llave='" + request.getParameter("Llave") + "',Articulo='" + request.getParameter("Articulo") + "',Cantidad='" + traducciones.getDecimal(request.getParameter("Cantidad")) + "',Unidad='" + request.getParameter("Unidad") + "',Precio='" + traducciones.getDecimal(request.getParameter("Precio")) + "',Importe='" + traducciones.getDecimal(request.getParameter("Importe")) + "',PorIva='" + traducciones.getEntero(request.getParameter("PorIva")) + "',Iva='" + traducciones.getDecimal(request.getParameter("Iva")) + "',IvaRetenido='" + traducciones.getDecimal(request.getParameter("IvaRetenido")) + "',IsrRetenido='" + traducciones.getDecimal(request.getParameter("IsrRetenido")) + "',Total='" + traducciones.getDecimal(request.getParameter("Total")) + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into OrdenesCompraConceptosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Llave,Articulo,Cantidad,Unidad,Precio,Importe,PorIva,Iva,IvaRetenido,IsrRetenido,Total) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Llave,Articulo,Cantidad,Unidad,Precio,Importe,PorIva,Iva,IvaRetenido,IsrRetenido,Total from OrdenesCompraConceptos where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new OrdenesCompraConceptos();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setLlave(request.getParameter("Llave"));
					objeto.setArticulo(request.getParameter("Articulo"));
					objeto.setCantidad(request.getParameter("Cantidad"));
					objeto.setUnidad(request.getParameter("Unidad"));
					objeto.setPrecio(request.getParameter("Precio"));
					objeto.setImporte(request.getParameter("Importe"));
					objeto.setPorIva(request.getParameter("PorIva"));
					objeto.setIva(request.getParameter("Iva"));
					objeto.setIvaRetenido(request.getParameter("IvaRetenido"));
					objeto.setIsrRetenido(request.getParameter("IsrRetenido"));
					objeto.setTotal(request.getParameter("Total"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getOrdenesCompraConceptos")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from OrdenesCompraConceptos where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<OrdenesCompraConceptos> info = new ArrayList<OrdenesCompraConceptos>();
				while(resultados.next()) {
					objeto = new OrdenesCompraConceptos();
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
			objeto = new OrdenesCompraConceptos();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new OrdenesCompraConceptos();
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
	
	private void imprimeJson(HttpServletResponse response, OrdenesCompraConceptos objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<OrdenesCompraConceptos> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(OrdenesCompraConceptos objeto, Exception e) {
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
/* OrdenesCompraConceptosServlet */