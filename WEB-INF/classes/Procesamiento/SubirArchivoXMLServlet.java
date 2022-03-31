package Procesamiento;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import Configuraciones.Generales;
import Libreria.MysqlPool;

public class SubirArchivoXMLServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2542499677218329378L;
	private HttpSession session;
	private Generales generales;
	
	private File archivoTemporal;
	private String directorioDestino ="/xml";
	private String directorioDestinoPdf ="/pdf";
	private File archivoDestino;
	private File archivoDestinoPdf;
	
	private MysqlPool eDB;

	public SubirArchivoXMLServlet() {
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
			try {
				eDB.getQuery("select 1");
			} catch(NullPointerException e123) {
				eDB.setConexion();
			}
			
			String realPath = getServletContext().getRealPath(directorioDestino);
			archivoDestino = new File(realPath);
			
			realPath = getServletContext().getRealPath(directorioDestinoPdf);
			archivoDestinoPdf = new File(realPath);
			
			if(!archivoDestino.isDirectory()) {
				throw new ServletException(directorioDestino + " no es un directorio.");
			}
			
			if(!archivoDestinoPdf.isDirectory()) {
				throw new ServletException(directorioDestinoPdf + " no es un directorio.");
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
					if(nombre.endsWith("xml") || nombre.endsWith("XML")) {
						
						File file = new File(archivoDestino, llave + "_" + nombre);
						item.write(file);
						analiza(eDB,llave,archivoDestino.toString() + "/",llave + "_" + nombre);
						out.println("{\"status\":\"server\"}");
					} 
					else if(nombre.endsWith("pdf") || nombre.endsWith("PDF")) {
						
						File file = new File(archivoDestinoPdf, llave + "_" + nombre);
						item.write(file);
						eDB.setQuery("insert ignore into ReporteGastosViajePdf (U,G,E,IdReporteGastosViaje,Archivo) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + llave + "','" + nombre + "')");
						out.println("{\"status\":\"server\"}");
					}
					else {
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
		try { eDB = new MysqlPool(); generales = new Generales(); } catch(Exception e) { e.printStackTrace(System.out);}
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
	
	private void analiza(MysqlPool eDB, String llave, String directorio, String archivo) throws ParserConfigurationException, SQLException, SAXException, IOException {
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		Document doc = docBuilder.parse(directorio + archivo);

		Node comprobante, receptor, emisor, impuestos, concepto;
		
		String fecha = "", tipoDocumento = "", serie = "", folio = ""; 
		String subtotal = "0", descuento = "0", iva = "0", isr = "0", ivaRetenido = "0", total = "0";
		String rfc = "", razonSocial = "", rfcEmisor = "", razonSocialEmisor = "";
		String detalle = "";

		comprobante = doc.getElementsByTagName("cfdi:Comprobante").item(0);
		receptor = doc.getElementsByTagName("cfdi:Receptor").item(0);
		emisor = doc.getElementsByTagName("cfdi:Emisor").item(0);
		impuestos = doc.getElementsByTagName("cfdi:Impuestos").item(0);
		concepto = doc.getElementsByTagName("cfdi:Concepto").item(0);

		NamedNodeMap attrComprobante = comprobante.getAttributes();
		NamedNodeMap attrReceptor = receptor.getAttributes();
		NamedNodeMap attrEmisor = emisor.getAttributes();
		NamedNodeMap attrImpuestos = impuestos.getAttributes();
		NamedNodeMap attrConceptos = concepto.getAttributes();
		
		fecha = attrComprobante.getNamedItem("fecha").getNodeValue();
		String[] vFecha = fecha.split("T");
		
		tipoDocumento = attrComprobante.getNamedItem("tipoDeComprobante").getNodeValue();
		
		try { subtotal = attrComprobante.getNamedItem("subtotal").getNodeValue();}catch(NullPointerException e){try{
		subtotal = attrComprobante.getNamedItem("subTotal").getNodeValue();}catch(NullPointerException e1){}}
		
		total = attrComprobante.getNamedItem("total").getNodeValue();
		
		try { serie = attrComprobante.getNamedItem("serie").getNodeValue();}catch(NullPointerException e){}
		
		try { folio = attrComprobante.getNamedItem("folio").getNodeValue();}catch(NullPointerException e){}
		
		try { descuento = attrComprobante.getNamedItem("Descuento").getNodeValue();}catch(NullPointerException e){}
		
		rfc = attrReceptor.getNamedItem("rfc").getNodeValue();
		
		try {razonSocial = attrReceptor.getNamedItem("nombre").getNodeValue();}catch(NullPointerException e){}
			
		rfcEmisor = attrEmisor.getNamedItem("rfc").getNodeValue();
		
		try { razonSocialEmisor = attrEmisor.getNamedItem("nombre").getNodeValue();}catch(NullPointerException e){}
		
		try { iva = attrImpuestos.getNamedItem("totalImpuestosTrasladados").getNodeValue();}catch(NullPointerException e){}	
		
		try { isr = attrImpuestos.getNamedItem("totalImpuestosRetenidos").getNodeValue();}catch(NullPointerException e){}
		
		try { detalle = attrConceptos.getNamedItem("descripcion").getNodeValue();}catch(NullPointerException e){}
			
		String sSerie = "";
		if(serie != null) { sSerie = serie; }
		
		String sFolio = "";
		if(folio != null) { sFolio = folio; }			
			
		eDB.setQuery("insert ignore into ReporteGastosViajeDetalle (U,G,E,IdReporteGastosViaje,Fecha,Documento,Proveedor,DetalleGasto,ImporteSinIva,ImporteConIva,Iva,GastosComprobados,ArchivoXML) values ('" + 
					session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + 
					llave + "','" + fecha + "','" + serie + " " + folio + "','" + razonSocialEmisor + "','" + detalle + "','" + descuento + "','" + subtotal + "','" + iva + "','" + total + "','" + archivo + "')");	
		
	}

}
