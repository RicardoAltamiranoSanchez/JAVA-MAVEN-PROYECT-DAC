package Procesamiento;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import Configuraciones.Generales;
import Libreria.MysqlPool;
import Objetos.FirmasBanners;

public class SubirFirmasBannersServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -769216041118322885L;
	private HttpSession session;
	private Generales generales;
	private String directorioDestino2 = "/banners";
	private String directorioDestino = "/";
	private File archivoTemporal;
	private File archivoDestino, archivoDestino2;
	
	private String nombreArchivo="";	
	
	private FirmasBanners objeto;
	
	private MysqlPool eDB;
	private ResultSet resultados;
	
	public SubirFirmasBannersServlet() {
		super();
	}


	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		validar(request,response);
		
		response.setContentType("text/json");
		PrintWriter out = response.getWriter();
	
		DiskFileItemFactory  fileItemFactory = new DiskFileItemFactory ();
		fileItemFactory.setSizeThreshold(1*1024*1024); //1 MB
		fileItemFactory.setRepository(archivoTemporal);
		ServletFileUpload uploadHandler = new ServletFileUpload(fileItemFactory);
		
		try {
			List items = uploadHandler.parseRequest(request);
			Iterator itr = items.iterator();
			
			//String realPath = getServletContext().getRealPath(directorioDestino);
			String realPath = "/petronovich/sitios/www/banners.mcs-holding"; //PRODUCTIVO			
			//String realPath = "C:/Temp/"; //LOCAL
			String realPath2 = getServletContext().getRealPath(directorioDestino2);; //LOCAL NO USADO
			archivoDestino = new File(realPath);
			archivoDestino2 = new File(realPath2); //LOCAL NO USADO
			
			if(!archivoDestino.isDirectory()) {
				throw new ServletException(directorioDestino + " no es un directorio.");
			}

			
			
			String llave = "";
			while(itr.hasNext()) {
				FileItem item = (FileItem) itr.next();
				if(item.isFormField() & item.getFieldName().equals("Llave")) {
					llave = item.getString();
					System.out.println("Entré al If Llave y el valor es "+llave);
				}
			}
			
//			itr = items.iterator();
//			while(itr.hasNext()) {
//				FileItem item = (FileItem) itr.next();
//				String nombre = "";
//				if(!item.isFormField()) {
//					nombre = item.getName();
//					nombre = nombre.replaceAll(" ","_");
//					if(nombre.endsWith("pdf") || nombre.endsWith("PDF")) {
//						File file = new File(archivoDestino, llave + "_" + nombre);
//						item.write(file);
//						out.println("{\"status\":\"server\"}");
//					} else {
//						out.println("{\"status\":\"server\"}");
//					}
//				}
//			}
			
			
			
//			eDB.setConexion();
//			resultados = eDB.getQuery("select GrupoEmpleados from FirmasGrupos where Id = '"+ llave +"'");
//			ArrayList<BannerCategoriaFirma> info = new ArrayList<BannerCategoriaFirma>();
//			while(resultados.next()) {
////				objeto = new BannerCategoriaFirma();
////				objeto.setId(resultados.getInt("Id"));
////				objeto.setValue(resultados.getString("<columna>"));
////				info.add(objeto);
//				
//				nombreArchivo = resultados.getString("GrupoEmpleados");
//				// System.out.println("El archivo se debe llamar: " + nombreArchivo); //DEBUG				
//			}
//			eDB.setCerrar(resultados);
//			eDB.setCerrar();
//			eDB.setCerrarConexion();
			
			
			//nombreArchivo = llave;
			
			itr = items.iterator();
			while(itr.hasNext()) {
				FileItem item = (FileItem) itr.next();
				String nombre = "";
				
				if(!item.isFormField()) {
					//nombre = nombreArchivo+".png";
					nombre = item.getName();
					// System.out.println("Cambié el nombre del archivo por "+nombre); //DEBUG
					//nombre = nombre.replaceAll(" ","_");
				
					File file = new File(archivoDestino,nombre);
					File file2 = new File(archivoDestino2,nombre);
					item.write(file);
					item.write(file2);
					out.println("{\"status\":\"server\"}");
				}
			}
			out.close();
			
			//limpiar directorio
			directorioDestino = "../../www/banners.mcs-holding";
		} catch(FileUploadException ex) {
			System.out.println("Error encountered while parsing the request: " + ex);
			ex.printStackTrace(System.out);
			out.println("{ status: 'error'}");
			out.close();
		} catch(Exception ex) {
			System.out.println("Error encountered while uploading file: " + ex);
			ex.printStackTrace(System.out);
			out.println("{ status: 'error'}");
			out.close();
		}
	}

	public void init() throws ServletException {
		// Put your code here
		try {
			eDB = new MysqlPool();
			generales = new Generales();
		} catch(Exception e) {
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

}
