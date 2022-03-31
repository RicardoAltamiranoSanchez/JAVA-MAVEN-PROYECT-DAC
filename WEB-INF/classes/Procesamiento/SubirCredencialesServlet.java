package Procesamiento;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
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

public class SubirCredencialesServlet extends HttpServlet {


	/**
	 * 
	 */
	private static final long serialVersionUID = 8804106025753941348L;
	/**
	 * 
	 */
	private HttpSession session;
	private Generales generales;
	private String directorioDestino = "/fotos";
	private File archivoTemporal;
	private File archivoDestino;
	
	
	public SubirCredencialesServlet() {
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
			
			String realPath = getServletContext().getRealPath(directorioDestino);
			archivoDestino = new File(realPath);
			
			if(!archivoDestino.isDirectory()) {
				throw new ServletException(directorioDestino + " no es un directorio.");
			}
			
			itr = items.iterator();
			while(itr.hasNext()) {
				FileItem item = (FileItem) itr.next();
				String nombre = "";
				
				if(!item.isFormField()) {
					nombre = item.getName();
					nombre = nombre.replaceAll(" ","_");
					nombre = nombre.replaceAll("á","a");
					nombre = nombre.replaceAll("é","e");
					nombre = nombre.replaceAll("í","i");
					nombre = nombre.replaceAll("ó","o");
					nombre = nombre.replaceAll("ú","u");
					nombre = nombre.replaceAll("Á","A");
					nombre = nombre.replaceAll("É","E");
					nombre = nombre.replaceAll("Í","I");
					nombre = nombre.replaceAll("Ó","O");
					nombre = nombre.replaceAll("Ú","U");
					nombre = nombre.replaceAll("ñ","n");
					nombre = nombre.replaceAll("Ñ","N");
					nombre = nombre.replaceAll("ü","u");
					nombre = nombre.replaceAll("Ü","U");
				
					File file = new File(archivoDestino,nombre);
					item.write(file);
					out.println("{ status: 'server'}");
				}
			}
			out.close();
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
