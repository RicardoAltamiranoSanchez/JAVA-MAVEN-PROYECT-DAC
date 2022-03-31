package Procesamiento;

import java.awt.Color;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Configuraciones.Generales;
import Libreria.MysqlPool;
import Objetos.Credenciales;
import Utilerias.TraduccionesSQL;



//import com.lowagie.text.Chunk;
//import com.lowagie.text.Document;
//import com.lowagie.text.DocumentException;
//import com.lowagie.text.Element;
//import com.lowagie.text.Font;
//import com.lowagie.text.Image;
//import com.lowagie.text.PageSize;
//import com.lowagie.text.Paragraph;
//import com.lowagie.text.Rectangle;
//import com.lowagie.text.pdf.PdfContentByte;
//import com.lowagie.text.pdf.PdfPCell;
//import com.lowagie.text.pdf.PdfPTable;
//import com.lowagie.text.pdf.PdfWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Configuraciones.Generales;
import Libreria.MysqlPool;
import Objetos.Credenciales;
import Utilerias.TraduccionesSQL;

//import com.lowagie.text.Chunk;
//import com.lowagie.text.Document;
//import com.lowagie.text.DocumentException;
//import com.lowagie.text.Element;
//import com.lowagie.text.Font;
//import com.lowagie.text.Image;
//import com.lowagie.text.Paragraph;
//import com.lowagie.text.Rectangle;
//import com.lowagie.text.pdf.PdfContentByte;
//import com.lowagie.text.pdf.PdfPCell;
//import com.lowagie.text.pdf.PdfPTable;
//import com.lowagie.text.pdf.PdfWriter;



import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Image;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.tool.xml.XMLWorkerHelper;
import com.itextpdf.tool.xml.ElementList;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.BaseColor;


public class GenerarCredencialesTextoServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 6475573165375108172L;
	//Variables de uso general
	private Generales generales;
	private HttpSession session;
	private MysqlPool eDB;
	private ResultSet resultados;
	private Credenciales objeto;
	private TraduccionesSQL traducciones;
	private int RN = 0,GN = 0, BN = 0;
	private int RA = 0,GA = 0, BA = 0;
	private Date FECHA = new Date ();
	/**
	 * Constructor of the object.
	 */
	public GenerarCredencialesTextoServlet() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doPost(request,response);
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		//validamos la sesion
		validar(request,response);
		//variables de uso general
		String Ruta = "", CarpetaFotos = "fotos", CarpetaCredenciales = "credenciales", NombreArchivo = ((request.getParameter("Diseno")).replaceAll(" ", "") + request.getParameter("TamanoFuente"));
		Image Imagen, ImagenFrente = null, ImagenAtras;
		//creamos el documento
		Document documento = new Document(new Rectangle(212, 338),0,0,0,0);
		//Ruta de donde se encuentra la imagen
		objeto = new Credenciales();
		Ruta = generales.getUrlLogout(); //PRODUCTIVO
		//Ruta = "C:/Temp/"; //LOCAL
		try{
			//tipo de archivos
			response.setContentType("application/pdf; charset=UTF-8");
 			response.setHeader("Content-Disposition","attachment;filename=" + NombreArchivo + ".pdf");
 			response.setCharacterEncoding("UTF-8");
 			response.setHeader("Pragma","no-cache");
 			response.setHeader("Expires","-");
			
			//tipos de letras
			//Font[] fonts = new Font[5];
//			fonts[0] = new Font(Font.HELVETICA, 9, Font.BOLD);
//			fonts[1] = new Font(Font.HELVETICA, 25, Font.BOLD);
//			fonts[2] = new Font(Font.HELVETICA, 11, Font.BOLD, Color.RED);
			//fonts[3] = new Font(Font.HELVETICA, 7, Font.BOLD);
			
			
			//Font font = new Font(FontFamily.HELVETICA, Integer.parseInt(request.getParameter("TamanoFuente")), Font.NORMAL, BaseColor.BLACK);
						
//			fonts[3] = new Font(Font.HELVETICA, Integer.parseInt(request.getParameter("TamanoFuente")), Font.NORMAL);
			
 			
        	//variable
        		PdfWriter writer = PdfWriter.getInstance(documento, response.getOutputStream());
        		//abrir documento
				documento.open();
				
				XMLWorkerHelper worker = XMLWorkerHelper.getInstance();
				StringBuffer cadena = new StringBuffer();
				cadena.append(".right {\n");
				cadena.append("	text-align: right;\n");
				cadena.append("}\n");
				cadena.append(".left {\n");
				cadena.append("	text-align: left;\n");
				cadena.append("}\n");
				cadena.append(".center {\n");
				cadena.append("	text-align: center;\n");
				cadena.append("}\n");
				cadena.append(".full {\n");
				cadena.append("	text-align: justify;\n");
				cadena.append("}\n");
				cadena.append(".bold {\n");
				cadena.append("	font-weight: bold;\n");
				cadena.append("}\n");
				cadena.append(".italic {\n");
				cadena.append("	font-style: italic;\n");
				cadena.append("}\n");
				cadena.append(".underline {\n");
				cadena.append("	text-decoration: underline;\n");
				cadena.append("}\n");
				cadena.append(".mytablerow {\n");
				cadena.append("	background-color: teal;\n");
				cadena.append("}\n");
				
				//tamaño de hoja
				documento.setPageSize(new Rectangle(212, 338));
				//contenido del documento
				com.itextpdf.text.pdf.PdfContentByte pdf = writer.getDirectContent();
				PdfPCell celda = new PdfPCell();
				Paragraph Frase = new Paragraph();
				//Imagenes
				///depende de sus datos sera la imagen que cargara
				
				if (request.getParameter("Diseno").equals("BLANCO")){
					// DEBUG System.out.println("Soy Blanco");
					ImagenFrente = Image.getInstance(Ruta + CarpetaCredenciales + "/BaseCrede.jpg");
					ImagenFrente.setAlignment(Element.ALIGN_JUSTIFIED_ALL);
					ImagenFrente.setBorder(Rectangle.NO_BORDER);
					ImagenFrente.scaleAbsolute(212, 338);
				} else if (request.getParameter("Diseno").equals("CENEFA SUPERIOR MCS")){
					// DEBUG System.out.println("Soy CENEFA Superior");
					ImagenFrente = Image.getInstance(Ruta + CarpetaCredenciales + "/MCSCenefaCrede.jpg");
					ImagenFrente.setAlignment(Element.ALIGN_JUSTIFIED_ALL);
					ImagenFrente.setBorder(Rectangle.NO_BORDER);
					ImagenFrente.scaleAbsolute(212, 338);
				}
				
//				ImagenFrente = Image.getInstance(Ruta + CarpetaCredenciales + "/" + objeto.getIdImagenAdelante());
//				ImagenFrente.setAlignment(Element.ALIGN_LEFT);
//				ImagenFrente.setBorder(Rectangle.NO_BORDER);
//				ImagenFrente.scaleAbsolute(212, 338);
//				ImagenAtras = Image.getInstance(Ruta + CarpetaCredenciales + "/" + objeto.getIdImagenAtras());
//				ImagenAtras.setAlignment(Element.ALIGN_LEFT);
//				ImagenAtras.setBorder(Rectangle.NO_BORDER);
//				ImagenAtras.scaleAbsolute(212, 338);
//				Imagen = Image.getInstance(Ruta + CarpetaFotos + "/" + objeto.getImagen());
//				Imagen.setAlignment(Element.ALIGN_LEFT);
//				Imagen.setBorder(Rectangle.NO_BORDER);
//				Imagen.scaleAbsolute(95f, 120f);
				
				//creamos las tablas
				PdfPTable TablaFrente = new PdfPTable(2);
//				PdfPTable TablaAtras = new PdfPTable(1);
				//tabla frente
				celda = new PdfPCell(ImagenFrente);
				celda.setBorder(0);
				celda.setPaddingLeft(-20); // ajusta que la ImagenFrente quede alineada
				//double pading = -21.5;
				//celda.setPaddingLeft((float) pading);
				TablaFrente.addCell(celda);
				
				//tabla imagen
//				celda = new PdfPCell(Imagen);
//				celda.setBorder(0);
//				celda.setPaddingRight(80);
//				celda.setPaddingLeft(-48);
//				celda.setPaddingTop(60);
//				TablaFrente.addCell(celda);
				
				
				String css = cadena.toString();

				cadena = new StringBuffer();
				cadena.append(request.getParameter("TextoCredencial"));
				
				PdfPTable tabla = new PdfPTable(1);
				tabla.setWidthPercentage(100);
				
				ElementList list = XMLWorkerHelper.parseToElementList(cadena.toString(), css);
				
				//estacion
//				Frase = new Paragraph();
//				Frase.add(new Chunk(request.getParameter("TextoCredencial"), font));
//				Frase.setAlignment(Element.ALIGN_JUSTIFIED_ALL);
//				celda = new PdfPCell(Frase);
				
				for (Element element : list) {
					PdfPCell celda2 = new PdfPCell();
					   celda.addElement(element);
					   celda.setBorder(Rectangle.NO_BORDER);
					   tabla.addCell(celda2);
					}
				
				celda.setBorder(0);
				//celda.setColspan(2);
				celda.setPaddingLeft(-100);
				celda.setPaddingRight(-19);
				if (request.getParameter("Diseno").equals("BLANCO")){
					System.out.println("Soy Blanco");
					celda.setPaddingTop(0);
				} else if (request.getParameter("Diseno").equals("CENEFA SUPERIOR MCS")){
					System.out.println("Soy CENEFA Superior");
					celda.setPaddingTop(22);
				}
				TablaFrente.addCell(celda);
				//nombre
//				if(objeto.getNombreCompleto().length() > 30){
//					//nombre
//					Frase = new Paragraph();
//					Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[0]));
//					celda = new PdfPCell(Frase);
//					celda.setBorder(0);
//					celda.setColspan(2);
//					celda.setHorizontalAlignment(Element.ALIGN_CENTER);
//					celda.setPaddingTop(-125);
//					celda.setPaddingLeft(0);
//					TablaFrente.addCell(celda);
//				}else if(objeto.getNombreCompleto().length() <= 30){
//					Frase = new Paragraph();
//					Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[0]));
//					celda = new PdfPCell(Frase);
//					celda.setBorder(0);
//					celda.setColspan(2);
//					celda.setHorizontalAlignment(Element.ALIGN_CENTER);
//					celda.setPaddingTop(-120);
//					celda.setPaddingLeft(0);
//					TablaFrente.addCell(celda);
//				}
				//puesto
//				Frase = new Paragraph();
//				if(objeto.getNivel().equals("")){
//					Frase.add(new Chunk(objeto.getPuesto(), fonts[0]));
//					celda = new PdfPCell(Frase);
//					celda.setBorder(0);
//					celda.setColspan(2);
//					celda.setHorizontalAlignment(Element.ALIGN_CENTER);
//					celda.setPaddingTop(-100);
//					TablaFrente.addCell(celda);
//				}else{
//					Frase.add(new Chunk(objeto.getPuesto() + " - " + objeto.getNivel(), fonts[0]));
//					celda = new PdfPCell(Frase);
//					celda.setBorder(0);
//					celda.setColspan(2);
//					celda.setPaddingLeft(-8);
//					celda.setHorizontalAlignment(Element.ALIGN_CENTER);
//					celda.setPaddingTop(-100);
//					TablaFrente.addCell(celda);
//				}
				
				//vigencia
//				Frase = new Paragraph();
//				Frase.add(new Chunk("VIGENCIA: " + objeto.getFechaVigencia(), fonts[2]));
//				celda = new PdfPCell(Frase);
//				celda.setBorder(0);
//				celda.setColspan(2);
//				celda.setPaddingLeft(30);
//				celda.setPaddingTop(-80);
//				TablaFrente.addCell(celda);
				//agregamos tablas al documento
				documento.add(TablaFrente);
				//nueva pagina
//				documento.newPage();
				//tabla atras
//				celda = new PdfPCell(ImagenAtras);
//				celda.setBorder(0);
//				celda.setPaddingLeft((float) pading);
//				TablaAtras.addCell(celda);
//				if(objeto.getNivel().equals("")){
//					if(objeto.getNombreCompleto().length() > 30){
						//nombre
//						Frase = new Paragraph();
//						Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setHorizontalAlignment(Element.ALIGN_LEFT);
//						celda.setPaddingTop(-150);
//						celda.setPaddingLeft(0);
//						TablaAtras.addCell(celda);
						//imss
//						Frase = new Paragraph();
//						Frase.add(new Chunk("IMSS: " + objeto.getIMSS(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-132);
//						TablaAtras.addCell(celda);
						//curp
//						Frase = new Paragraph();
//						Frase.add(new Chunk("CURP: " + objeto.getCURP(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-122);
//						TablaAtras.addCell(celda);
						//antiguedad
//						Frase = new Paragraph();
//						Frase.add(new Chunk("ANTIGÜEDAD: " + objeto.getAntiguedad(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-112);
//						TablaAtras.addCell(celda);
						//TablaAtras emision
//						Frase = new Paragraph();
//						Frase.add(new Chunk("FECHA EMISIÓN: " + objeto.getFechaEmision(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-102);
//						TablaAtras.addCell(celda);
						//puesto
//						Frase = new Paragraph();
//						Frase.add(new Chunk("PUESTO: " + objeto.getPuesto(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-92);
//						TablaAtras.addCell(celda);
//					}else if(objeto.getNombreCompleto().length() <= 30){
						//nombre
//						Frase = new Paragraph();
//						Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-140);
//						TablaAtras.addCell(celda);
						//imss
//						Frase = new Paragraph();
//						Frase.add(new Chunk("IMSS: " + objeto.getIMSS(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-130);
//						TablaAtras.addCell(celda);
						//curp
//						Frase = new Paragraph();
//						Frase.add(new Chunk("CURP: " + objeto.getCURP(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-120);
//						TablaAtras.addCell(celda);
						//antiguedad
//						Frase = new Paragraph();
//						Frase.add(new Chunk("ANTIGÜEDAD: " + objeto.getAntiguedad(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-110);
//						TablaAtras.addCell(celda);
						//TablaAtras emision
//						Frase = new Paragraph();
//						Frase.add(new Chunk("FECHA EMISIÓN: " + objeto.getFechaEmision(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-100);
//						TablaAtras.addCell(celda);
						//puesto
//						Frase = new Paragraph();
//						Frase.add(new Chunk("PUESTO: " + objeto.getPuesto(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-90);
//						TablaAtras.addCell(celda);
//					}
//				}else{
//					if(objeto.getNombreCompleto().length() < 30){
						//nombre
//						Frase = new Paragraph();
//						Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setHorizontalAlignment(Element.ALIGN_LEFT);
//						celda.setPaddingTop(-149);
//						celda.setPaddingLeft(0);
//						TablaAtras.addCell(celda);
						//imss
//						Frase = new Paragraph();
//						Frase.add(new Chunk("IMSS: " + objeto.getIMSS(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-132);
//						TablaAtras.addCell(celda);
						//curp
//						Frase = new Paragraph();
//						Frase.add(new Chunk("CURP: " + objeto.getCURP(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-122);
//						TablaAtras.addCell(celda);
						//antiguedad
//						Frase = new Paragraph();
//						Frase.add(new Chunk("ANTIGÜEDAD: " + objeto.getAntiguedad(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-112);
//						TablaAtras.addCell(celda);
						//TablaAtras emision
//						Frase = new Paragraph();
//						Frase.add(new Chunk("FECHA EMISIÓN: " + objeto.getFechaEmision(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-102);
//						TablaAtras.addCell(celda);
						//puesto
//						Frase = new Paragraph();
//						Frase.add(new Chunk("PUESTO: " + objeto.getPuesto(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-92);
//						TablaAtras.addCell(celda);
						//nivel
//						Frase = new Paragraph();
//						Frase.add(new Chunk(objeto.getNivel(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-82);
//						TablaAtras.addCell(celda);
//					}else if(objeto.getNombreCompleto().length() > 30){
						//nombre
//						Frase = new Paragraph();
//						Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-140);
//						TablaAtras.addCell(celda);
						//imss
//						Frase = new Paragraph();
//						Frase.add(new Chunk("IMSS: " + objeto.getIMSS(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-130);
//						TablaAtras.addCell(celda);
						//curp
//						Frase = new Paragraph();
//						Frase.add(new Chunk("CURP: " + objeto.getCURP(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-120);
//						TablaAtras.addCell(celda);
						//antiguedad
//						Frase = new Paragraph();
//						Frase.add(new Chunk("ANTIGÜEDAD: " + objeto.getAntiguedad(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-110);
//						TablaAtras.addCell(celda);
						//TablaAtras emision
//						Frase = new Paragraph();
//						Frase.add(new Chunk("FECHA EMISIÓN: " + objeto.getFechaEmision(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-100);
//						TablaAtras.addCell(celda);
						//puesto
//						Frase = new Paragraph();
//						Frase.add(new Chunk("PUESTO: " + objeto.getPuesto(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-90);
//						TablaAtras.addCell(celda);
					    //nivel
//						Frase = new Paragraph();
//						Frase.add(new Chunk(objeto.getNivel(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-80);
//						TablaAtras.addCell(celda);
//					}
//				}
				//agregamos tabla al documento
//				documento.add(TablaAtras);
				//cerramos documento
				documento.close();
		}catch (DocumentException e1) {
			// TODO Auto-generated catch block
			System.err.println("Ocurrio un error al crear el archivo");
            System.out.println("Driver: " + e1);
            //System.exit(-1);
		}
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		try {
			eDB = new MysqlPool();
			generales = new Generales();

		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace(System.out);
			System.out.println("Drivers: " + e);
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