<%@page import="java.io.File" %>
<%@page import="java.io.IOException" %>
<%@page import="java.io.PrintWriter" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.util.List" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@page import="org.apache.commons.fileupload.FileUploadException" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@page import="Configuraciones.Generales" %>
<%!
HttpSession session;
Generales generales;

File archivoTemporal;
String directorioDestino ="/documentosGeneral"; //PRODUCTIVO
//String directorioDestino = "D:/Temp/documentosGeneral"; //LOCAL

File archivoDestino;

public void jspInit() {
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
%>
<%
validar(request,response);
response.setContentType("text/json");

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
	
	List<FileItem> items = uploadHandler.parseRequest(request);
	Iterator<FileItem> itr = items.iterator();
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
			nombre = nombre.replaceAll("�","a");
			nombre = nombre.replaceAll("�","e");
			nombre = nombre.replaceAll("�","i");
			nombre = nombre.replaceAll("�","o");
			nombre = nombre.replaceAll("�","u");
			nombre = nombre.replaceAll("�","A");
			nombre = nombre.replaceAll("�","E");
			nombre = nombre.replaceAll("�","I");
			nombre = nombre.replaceAll("�","O");
			nombre = nombre.replaceAll("�","U");
			nombre = nombre.replaceAll("�","n");
			nombre = nombre.replaceAll("�","N");
			nombre = nombre.replaceAll("�","u");
			nombre = nombre.replaceAll("�","U");
		
			File file = new File(archivoDestino, nombre);
			item.write(file);
			out.println("{\"status\":\"server\"}");
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

%>