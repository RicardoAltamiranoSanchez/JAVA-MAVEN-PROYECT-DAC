package Procesamiento;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
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
import Objetos.FirmasBanners;

import com.google.gson.Gson;

public class FirmasBannersServlet extends HttpServlet {



	/**
	 * 
	 */
	private static final long serialVersionUID = -7852293279480255081L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private FirmasBanners objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;
	
	String realPath = "/petronovich/sitios/www/banners.mcs-holding/"; //PRODUCTIVO
	//String realPath = "C:/Temp/"; //LOCAL
	
	public FirmasBannersServlet() {
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
				if(request.getParameter("EstatusBannerFirma").equals("ACTIVO")){
					eDB.setQuery("update FirmasBanners set EstatusBannerFirma ='INACTIVO' where IdFirmas = '"+request.getParameter("IdFirmas")+"'");
				}
				eDB.setQuery("insert into FirmasBanners (U,G,E,IdFirmas,ArchivoBannerFirma,EstatusBannerFirma) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("IdFirmas") + "','" + request.getParameter("ArchivoBannerFirma") + "','" + request.getParameter("EstatusBannerFirma") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into FirmasBannersApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdFirmas,ArchivoBannerFirma,EstatusBannerFirma) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdFirmas,ArchivoBannerFirma,EstatusBannerFirma from FirmasBanners where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				//
				if(request.getParameter("EstatusBannerFirma").equals("ACTIVO")){
					File original = new File(realPath + request.getParameter("ArchivoBannerFirma"));
					//DEBUG System.out.println("Original "+realPath + request.getParameter("ArchivoBannerFirma"));
					File destino = new File(realPath + request.getParameter("IdFirmas") + ".png");
					//DEBUG System.out.println("Destino "+realPath + request.getParameter("IdFirmas") + ".png");
					copiar(original,destino);					
				}
				
				objeto = new FirmasBanners();
				objeto.setId(ultimoId);
				objeto.setIdFirmas(request.getParameter("IdFirmas"));
				objeto.setArchivoBannerFirma(request.getParameter("ArchivoBannerFirma"));
				objeto.setEstatusBannerFirma(request.getParameter("EstatusBannerFirma"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new FirmasBanners();
				objeto.setIdFirmas(request.getParameter("IdFirmas"));
				objeto.setArchivoBannerFirma(request.getParameter("ArchivoBannerFirma"));
				objeto.setEstatusBannerFirma(request.getParameter("EstatusBannerFirma"));

				//if(!objeto.getIdFirmas().equals("")) { where.append(" and A.IdFirmas like '" + objeto.getIdFirmas() + "%'"); entro = true;}
				if(!objeto.getIdFirmas().equals("")) { where.append(" and A.IdFirmas like '" + objeto.getIdFirmas() + "'"); entro = true;}
				if(!objeto.getArchivoBannerFirma().equals("")) { where.append(" and A.ArchivoBannerFirma like '" + objeto.getArchivoBannerFirma() + "%'"); entro = true;}
				if(!objeto.getEstatusBannerFirma().equals("")) { where.append(" and A.EstatusBannerFirma like '" + objeto.getEstatusBannerFirma() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.*, F.Id IdDelaFirma, F.NombreFirma as Firma from FirmasBanners as A left join Firmas as F on (F.Id = A.IdFirmas)" + whereInicio + where.toString());
				ArrayList<FirmasBanners> info = new ArrayList<FirmasBanners>();
				while(resultados.next()) {
					objeto = new FirmasBanners();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdFirmas(resultados.getString("Firma"));
					objeto.setLog(resultados.getString("IdDelaFirma"));
//					template:"<img src='.imgs/#id#.jpg'/>"
//					objeto.setArchivoBannerFirma("{view:'iframe', id:'MostrarDiseno',height:320,src:'\"C:/Temp/"+resultados.getString("ArchivoBannerFirma")+"\" width=\"60%\" border=\"1\"'},");
//					objeto.setArchivoBannerFirma("<img src=\"C:/Temp/"+resultados.getString("ArchivoBannerFirma")+"\" width=\"60%\" border=\"1\">");
					//objeto.setArchivoBannerFirma("template:\"<img src='C:/Temp/"+resultados.getString("ArchivoBannerFirma")+"'>\"");
					objeto.setArchivoBannerFirma(resultados.getString("ArchivoBannerFirma"));

					objeto.setEstatusBannerFirma(resultados.getString("EstatusBannerFirma"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("Borrar")) {
				//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 				String archivoInactivo = "";
				//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 				String archivoActivo = "";
				eDB.setConexion();
				String ids = request.getParameter("Ids");
				String[] id = ids.split(",");
				for(int i = 0; i < id.length; i++) {
					//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 					System.out.println("El Id a Revisar es "+id[i]);
					//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 					resultados = eDB.getQuery("select ArchivoBannerFirma as inactivo,IdFirmas as activo from FirmasBanners where Id = '"+id[i]+"'");					
					//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 					resultados.next();
					//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 					System.out.println("despues del next "+resultados.getString("inactivo"));
					//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 					System.out.println("despues del next "+resultados.getString("activo"));
					//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 					archivoInactivo = resultados.getString("inactivo");
					//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 					archivoActivo = resultados.getString("activo");
					if(!id[i].equals("")) {
						eDB.setQuery("insert into FirmasBannersApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdFirmas,ArchivoBannerFirma,EstatusBannerFirma) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdFirmas,ArchivoBannerFirma,EstatusBannerFirma from FirmasBanners where Id = '" + id[i] + "'");
						eDB.setQuery("delete from FirmasBanners where Id = '" + id[i] + "'");
						
						//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 						File activo = new File(realPath +archivoActivo+".png");
						//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 						File inactivo = new File(realPath + archivoInactivo);
						//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 						 if (activo.exists()){
						//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 							 System.out.println("Si existe activo");
						//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 						     activo.delete();
						//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 						 }
						//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 						 if (inactivo.exists()){
						//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 							 System.out.println("Si existe inactivo");
						//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 						     inactivo.delete();
						//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 						 }
					}					
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();				
				
				objeto = new FirmasBanners();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from FirmasBanners as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new FirmasBanners();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdFirmas(resultados.getString("IdFirmas"));
					objeto.setArchivoBannerFirma(resultados.getString("ArchivoBannerFirma"));
					objeto.setEstatusBannerFirma(resultados.getString("EstatusBannerFirma"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update FirmasBanners set IdFirmas='" + request.getParameter("IdFirmas") + "',ArchivoBannerFirma='" + request.getParameter("ArchivoBannerFirma") + "',EstatusBannerFirma='" + request.getParameter("EstatusBannerFirma") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into FirmasBannersApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdFirmas,ArchivoBannerFirma,EstatusBannerFirma) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdFirmas,ArchivoBannerFirma,EstatusBannerFirma from FirmasBanners where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				//
				if(request.getParameter("EstatusBannerFirma").equals("ACTIVO")){
					File original = new File(realPath + request.getParameter("ArchivoBannerFirma"));
					File destino = new File(realPath + request.getParameter("IdFirmas") + ".png");
					copiar(original,destino);
				}//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR else{					
				//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 					File activo = new File(realPath + request.getParameter("IdFirmas")+".png");
				//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 					 if (activo.exists()){
				//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 						 System.out.println("Si existe");
				//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 					     activo.delete();
				//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 					 }
				//ESTE C�DIGO FUNCIONA SI QUEREMOS ELIMINAR ARCHIVOS DEL SERVIDOR 				}
					eDB.setConexion();
					eDB.setQuery("update FirmasBanners set EstatusBannerFirma ='INACTIVO' where IdFirmas = '"+request.getParameter("IdFirmas")+"' and Id <> '" + request.getParameter("id") + "'");
					eDB.setQuery("insert into FirmasBannersApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdFirmas,ArchivoBannerFirma,EstatusBannerFirma) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdFirmas,ArchivoBannerFirma,EstatusBannerFirma from FirmasBanners where Id = '" + request.getParameter("id") + "'");
					eDB.setCerrar();
					eDB.setCerrarConexion();
				
				objeto = new FirmasBanners();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setIdFirmas(request.getParameter("IdFirmas"));
					objeto.setArchivoBannerFirma(request.getParameter("ArchivoBannerFirma"));
					objeto.setEstatusBannerFirma(request.getParameter("EstatusBannerFirma"));
				imprimeJson(response,objeto);
			}
			// COMBO acci�n que hace consulta para llenar combo
			else if(request.getParameter("Accion").equals("getFirmasBanners")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, IdFirmas,ArchivoBannerFirma,EstatusBannerFirma from FirmasBanners where IdFirmas like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<FirmasBanners> info = new ArrayList<FirmasBanners>();
				while(resultados.next()) {
					objeto = new FirmasBanners();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("IdFirmas"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new FirmasBanners();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new FirmasBanners();
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
	
	private void imprimeJson(HttpServletResponse response, FirmasBanners objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<FirmasBanners> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(FirmasBanners objeto, Exception e) {
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
	
	private static void copiar(File source, File dest) throws IOException {
	    InputStream is = null;
	    OutputStream os = null;
	    try {
	        is = new FileInputStream(source);
	        os = new FileOutputStream(dest);
	        byte[] buffer = new byte[1024];
	        int length;
	        while ((length = is.read(buffer)) > 0) {
	            os.write(buffer, 0, length);
	        }
	    } finally {
	        is.close();
	        os.close();
	    }
	}
}
/* FirmasBannersServlet */