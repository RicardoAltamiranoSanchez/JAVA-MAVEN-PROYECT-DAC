package Procesamiento;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletConfig;
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

public class SubirArchivoPDFServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4013100062506326305L;
	private HttpSession session;
	private Generales generales;
	
	private File archivoTemporal;
	private String directorioDestino ="/pdf";
	private File archivoDestino;

	public SubirArchivoPDFServlet() {
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
		
		response.setContentType("text/json");
		PrintWriter out = response.getWriter();
	
		DiskFileItemFactory  fileItemFactory = new DiskFileItemFactory ();
		fileItemFactory.setSizeThreshold(1*1024*1024); //1 MB
		fileItemFactory.setRepository(archivoTemporal);
		ServletFileUpload uploadHandler = new ServletFileUpload(fileItemFactory);
		
		try {
			
			String realPath = getServletContext().getRealPath(directorioDestino);
			archivoDestino = new File(realPath);
			
			if(!archivoDestino.isDirectory()) {
				throw new ServletException(directorioDestino + " no es un directorio.");
			}
			
			List items = uploadHandler.parseRequest(request);
			Iterator itr = items.iterator();
			String llave = "";
			while(itr.hasNext()) {
				FileItem item = (FileItem) itr.next();
				if(item.isFormField() & item.getFieldName().equals("Llave")) {
					llave = item.getString();
				}
			}
			
			itr = items.iterator();
			while(itr.hasNext()) {
				FileItem item = (FileItem) itr.next();
				String nombre = "";
				if(!item.isFormField()) {
					nombre = item.getName();
					nombre = nombre.replaceAll(" ","_");
					if(nombre.endsWith("pdf") || nombre.endsWith("PDF")) {
						File file = new File(archivoDestino, llave + "_" + nombre);
						item.write(file);
						out.println("{\"status\":\"server\"}");
					} else {
						out.println("{\"status\":\"server\"}");
					}
				}
			}
			out.close();
		} catch(FileUploadException ex) {
			System.out.println("Error encountered while parsing the request:" + ex);
			out.println("{\"status\":\"server\"}");
			out.close();
		} catch(Exception ex) {
			System.out.println("Error encountered while uploading file:" + ex);
			out.println("{\"status\":\"server\"}");
			out.close();
		}

	}

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		try { generales = new Generales(); } catch(Exception e) { e.printStackTrace(System.out);}
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
