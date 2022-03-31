package Procesamiento;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import java.awt.Color;

import Configuraciones.Generales;
import Libreria.MysqlPool;

public class GenerarDiplomaMAMServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Generales generales;
	private HttpSession session;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int RA = 0,GA = 0, BA = 0;
	/**
	 * Constructor of the object.
	 */
	public GenerarDiplomaMAMServlet() {
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
validar(request,response);
		
		//Variables que contienen la carpeta, la imagen y la ruta de la imagen
		 String Ruta = "", CarpetaCredenciales = "credenciales", CarpetaFotos =  "formatos";
		 Image ImagenFrente, ImagenAtras,Imagen;
		 //variables del contenido del diploma
		 String Tipo="",NombreAlumno="",NombreCurso="",DescripcionCurso="",NombreEmpresa="",Imparticion="",ResponsableUno="",PuestoResponsableUno="",ResponsableDos="",PuestoResponsableDos="",Certificado="",Titulo="";
		 ///variable donde se almacena el nombre del archivo
		 String NombreArchivo = "FORMATO DIPLOMA MAM";
		 //variables donde esta el contenido
		 //////////////
		 Document document = new Document(new Rectangle(600, 800),0,0,50,0);
		 Ruta = generales.getUrlLogout();
		 Font[] fonts = new Font[6];
		 	fonts[0] = new Font(Font.ITALIC, 9, Font.NORMAL);
			fonts[1] = new Font(Font.HELVETICA, 12, Font.NORMAL);
			fonts[2] = new Font(Font.HELVETICA, 14, Font.NORMAL);
			fonts[3] = new Font(Font.HELVETICA, 17, Font.BOLD);
			fonts[4] = new Font(Font.HELVETICA, 20, Font.BOLD);
			fonts[5] = new Font(Font.HELVETICA, 22, Font.BOLD);
			
			 response.setContentType("application/pdf");
			 response.setHeader("Content-Disposition","attachment;filename=" + NombreArchivo + ".pdf");
			 response.setHeader("Pragma","no-cache");
			 response.setHeader("Expires","-");
			try{
  				PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
				document.open();
				document.setPageSize(new Rectangle(600, 800));
				PdfContentByte pdf = writer.getDirectContent();
				PdfPCell Celda = new PdfPCell();
				Paragraph Frase = new Paragraph();
				BaseFont TextoNegro = BaseFont.createFont();
				PdfPTable TablaEncabezado = new PdfPTable(2);
				PdfPTable TablaEncabezado2 = new PdfPTable(2);
				
				//imagen
				Imagen = Image.getInstance(Ruta + CarpetaFotos + "/20150511_Diploma_MAM.png");
				Imagen.setAlignment(Element.ALIGN_LEFT);
				Imagen.setBorder(Rectangle.NO_BORDER);
				Imagen.scaleAbsolute(600, 800);
				//////
				pdf.beginText(); 
					pdf.addImage(Imagen, 600,0f,0f,800,0f,0f); //ANCHO, SABE, SABE, ALTO, DERECHA, ABAJO 600 x 777
				pdf.endText();
				//Espacios en blanco
				for(int x = 0; x < 8; x++){
					CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				}
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 20,Font.BOLD), TablaEncabezado, 2, 1, Tipo, "Centro", "", "Ninguno", false);
				//Espacios en blanco
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 14), TablaEncabezado, 2, 1, "Otorgado a:", "Centro", "", "Ninguno", false);
				//Espacios en blanco
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 22,Font.BOLD), TablaEncabezado, 2, 1, NombreAlumno, "Centro", "", "Ninguno", false);
				//Espacios en blanco
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 14), TablaEncabezado, 2, 1, "Por haber completado de forma exitosa", "Centro", "", "Ninguno", false);
				//Espacios en blanco
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 17,Font.BOLD), TablaEncabezado, 2, 1, NombreCurso, "Centro", "", "Ninguno", false);
				//Espacios en blanco
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 14), TablaEncabezado, 2, 1, DescripcionCurso, "Centro", "", "Ninguno", false);
				//Espacios en blanco
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 14), TablaEncabezado, 2, 1, "Impartido por:", "Centro", "", "Ninguno", false);
				//Espacios en blanco
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 17,Font.BOLD), TablaEncabezado, 2, 1, NombreEmpresa, "Centro", "", "Ninguno", false);
				//Espacios en blanco
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 14), TablaEncabezado, 2, 1, Imparticion, "Centro", "", "Ninguno", false);
				//Espacios en blanco
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				//Espacios en blanco
				for(int x = 0; x < 3; x++){
					CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				}
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 12), TablaEncabezado, 1, 1, ResponsableUno, "Centro", "", "Ninguno", false);
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 12), TablaEncabezado, 1, 1, PuestoResponsableUno, "Centro", "", "Ninguno", false);
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 12), TablaEncabezado, 1, 1, ResponsableDos, "Centro", "", "Ninguno", false);
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 12), TablaEncabezado, 1, 1, PuestoResponsableDos, "Centro", "", "Ninguno", false);
				//Espacios en blanco
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				CrearCeldaVacia(Celda, Frase, TablaEncabezado, 2, 1, "Ninguno", false);
				//
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 9), TablaEncabezado, 2, 1, "Certificado Núm: " + Certificado, "Izquierda", "", "Ninguno", false);
				//agregar tabla al documento
		        document.add(TablaEncabezado);
				///linea continua 1
				pdf.saveState();
		        pdf.setLineCap(PdfContentByte.LINE_CAP_ROUND);
		        pdf.setLineDash(0, 0);
		        pdf.moveTo(75, 170);
		        pdf.lineTo(285, 170);
		        pdf.stroke();
		        pdf.restoreState();
		        ///linea continua 2
		        pdf.saveState();
		        pdf.setLineCap(PdfContentByte.LINE_CAP_ROUND);
		        pdf.setLineDash(0, 0);
		        pdf.moveTo(320, 170);
		        pdf.lineTo(530, 170);
		        pdf.stroke();
		        pdf.restoreState();
				//creamos otra pagina
				document.newPage();
				//agregamos la otra imagen
				//imagen
				Imagen = Image.getInstance(Ruta + CarpetaFotos + "/Formato_MCS_2.png");
				Imagen.setAlignment(Element.ALIGN_LEFT);
				Imagen.setBorder(Rectangle.NO_BORDER);
				Imagen.scaleAbsolute(600, 800);
				//////
				pdf.beginText(); 
					pdf.addImage(Imagen, 600,0f,0f,800,0f,0f); //ANCHO, SABE, SABE, ALTO, DERECHA, ABAJO 600 x 777
				pdf.endText();
				///
				CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 20,Font.BOLD), TablaEncabezado2, 2, 1, "Titulo", "Centro", "", "Ninguno", false);
				//Espacio en blanco
				CrearCeldaVacia(Celda, Frase, TablaEncabezado2, 2, 1, "Ninguno", false);
				String dato[] = Titulo.split("\n");
				for(int x = 0; x < dato.length; x++){
					if(dato[x].equals("")){
						CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 14), TablaEncabezado2, 2, 1, dato[x], "Izquierda", "", "Ninguno", false);
					}else{
						CrearCelda(Celda, Frase, FontFactory.getFont("Arial", 14), TablaEncabezado2, 2, 1, "-" + dato[x], "Izquierda", "", "Ninguno", false);
					}
				}
				//agregar tabla al documento
		        document.add(TablaEncabezado2);
				//cerramos documento
				document.close();
		} catch (DocumentException e1) {
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
		// Put your code here
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
	
	private void CrearCeldaVacia(PdfPCell Celda, Paragraph Frase, PdfPTable Tabla, int Columna, int Fila, String Borde, boolean Fondo){
		Frase = new Paragraph(" ");
        Celda = new PdfPCell(Frase);
        Celda.setColspan(Columna);
        Celda.setRowspan(Fila);
        //Colocar un borde
        if(Borde.equals("Arriba"))
        	Celda.setBorder(Rectangle.TOP);
        else if(Borde.equals("Abajo"))
        	Celda.setBorder(Rectangle.BOTTOM);
        else if(Borde.equals("Izquierda"))
        	Celda.setBorder(Rectangle.LEFT);
        else if(Borde.equals("Derecha"))
        	Celda.setBorder(Rectangle.RIGHT);
        else if(Borde.equals("Ninguno"))
        	Celda.setBorder(Rectangle.NO_BORDER);
        //Color de la celda
        if(Fondo)
        	Celda.setBackgroundColor(new Color(RA, GA, BA));
        Tabla.addCell(Celda);
	}
	private void CrearCeldaImagen(PdfPCell Celda, Image Frase, PdfPTable Tabla, int Columna, int Fila, String AlineacionHorizontal, String AlineacionVertical, String Borde, boolean Fondo){
        Celda = new PdfPCell(Frase);
        Celda.setColspan(Columna);
        Celda.setRowspan(Fila);
        //Colocar un borde
        if(Borde.equals("Arriba"))
        	Celda.setBorder(Rectangle.TOP);
        else if(Borde.equals("Abajo"))
        	Celda.setBorder(Rectangle.BOTTOM);
        else if(Borde.equals("Izquierda"))
        	Celda.setBorder(Rectangle.LEFT);
        else if(Borde.equals("Derecha"))
        	Celda.setBorder(Rectangle.RIGHT);
        else if(Borde.equals("Ninguno"))
        	Celda.setBorder(Rectangle.NO_BORDER);
        //Alinearlo de manera horizontal
        if(AlineacionHorizontal.equals("Derecha"))
        	Celda.setHorizontalAlignment(Element.ALIGN_RIGHT);
        else if(AlineacionHorizontal.equals("Izquierda"))
        	Celda.setHorizontalAlignment(Element.ALIGN_LEFT);
        else if(AlineacionHorizontal.equals("Centro"))
        	Celda.setHorizontalAlignment(Element.ALIGN_CENTER);
        //Alinearlo de manera vertical
        if(AlineacionVertical.equals("Arriba"))
        	Celda.setVerticalAlignment(Element.ALIGN_TOP);
        else if(AlineacionVertical.equals("Abajo"))
        	Celda.setVerticalAlignment(Element.ALIGN_BOTTOM);
        else if(AlineacionVertical.equals("Centro"))
        	Celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
        //Color de la celda
        if(Fondo)
        	Celda.setBackgroundColor(new Color(RA, GA, BA));
        Tabla.addCell(Celda);
	}
	private void CrearCelda(PdfPCell Celda, Paragraph Frase, Font Fuente, PdfPTable Tabla, int Columna, int Fila, String Mensaje, String AlineacionHorizontal, String AlineacionVertical, String Borde, boolean Fondo){
		Frase = new Paragraph();
        Frase.add(new Chunk(Mensaje, Fuente));
        Celda = new PdfPCell(Frase);
        Celda.setColspan(Columna);
        Celda.setRowspan(Fila);
        //Colocar un borde
        if(Borde.equals("Arriba"))
        	Celda.setBorder(Rectangle.TOP);
        else if(Borde.equals("Abajo"))
        	Celda.setBorder(Rectangle.BOTTOM);
        else if(Borde.equals("Izquierda"))
        	Celda.setBorder(Rectangle.LEFT);
        else if(Borde.equals("Derecha"))
        	Celda.setBorder(Rectangle.RIGHT);
        else if(Borde.equals("Ninguno"))
        	Celda.setBorder(Rectangle.NO_BORDER);
        //Alinearlo de manera horizontal
        if(AlineacionHorizontal.equals("Derecha"))
        	Celda.setHorizontalAlignment(Element.ALIGN_RIGHT);
        else if(AlineacionHorizontal.equals("Izquierda"))
        	Celda.setHorizontalAlignment(Element.ALIGN_LEFT);
        else if(AlineacionHorizontal.equals("Centro"))
        	Celda.setHorizontalAlignment(Element.ALIGN_CENTER);
        //Alinearlo de manera vertical
        if(AlineacionVertical.equals("Arriba"))
        	Celda.setVerticalAlignment(Element.ALIGN_TOP);
        else if(AlineacionVertical.equals("Abajo"))
        	Celda.setVerticalAlignment(Element.ALIGN_BOTTOM);
        else if(AlineacionVertical.equals("Centro"))
        	Celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
        //Color de la celda
        if(Fondo)
        	Celda.setBackgroundColor(new Color(RA, GA, BA));
        Tabla.addCell(Celda);
	}
	private void CrearCeldaTabla(PdfPCell Celda, PdfPTable Tabla, int Columna, int Fila, PdfPTable Mensaje, String AlineacionHorizontal, String AlineacionVertical, String Borde, boolean Fondo){
        Celda = new PdfPCell(Mensaje);
        Celda.setColspan(Columna);
        Celda.setRowspan(Fila);
        //Colocar un borde
        if(Borde.equals("Arriba"))
        	Celda.setBorder(Rectangle.TOP);
        else if(Borde.equals("Abajo"))
        	Celda.setBorder(Rectangle.BOTTOM);
        else if(Borde.equals("Izquierda"))
        	Celda.setBorder(Rectangle.LEFT);
        else if(Borde.equals("Derecha"))
        	Celda.setBorder(Rectangle.RIGHT);
        else if(Borde.equals("Ninguno"))
        	Celda.setBorder(Rectangle.NO_BORDER);
        //Alinearlo de manera horizontal
        if(AlineacionHorizontal.equals("Derecha"))
        	Celda.setHorizontalAlignment(Element.ALIGN_RIGHT);
        else if(AlineacionHorizontal.equals("Izquierda"))
        	Celda.setHorizontalAlignment(Element.ALIGN_LEFT);
        else if(AlineacionHorizontal.equals("Centro"))
        	Celda.setHorizontalAlignment(Element.ALIGN_CENTER);
        //Alinearlo de manera vertical
        if(AlineacionVertical.equals("Arriba"))
        	Celda.setVerticalAlignment(Element.ALIGN_TOP);
        else if(AlineacionVertical.equals("Abajo"))
        	Celda.setVerticalAlignment(Element.ALIGN_BOTTOM);
        else if(AlineacionVertical.equals("Centro"))
        	Celda.setVerticalAlignment(Element.ALIGN_MIDDLE);
        //Color de la celda
        if(Fondo)
        	Celda.setBackgroundColor(new Color(RA, GA, BA));
        Tabla.addCell(Celda);
	}

}
