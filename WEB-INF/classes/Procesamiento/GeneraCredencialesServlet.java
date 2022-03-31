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
import Objetos.Credenciales;
import Libreria.MysqlPool;

public class GeneraCredencialesServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6039539493618586501L;
	//Variables de uso general
	private Generales generales;
	private HttpSession session;
	private MysqlPool eDB;
	private ResultSet resultados;
	private Credenciales objeto;
	/**
	 * Constructor of the object.
	 */
	public GeneraCredencialesServlet() {
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
		 String Ruta = "", CarpetaCredenciales = "credenciales",CarpetaFotos =  "fotos";
		 Image ImagenFrente, ImagenAtras,Imagen;
		 ///variable donde se almacena el nombre del archivo
		 String NombreArchivo = request.getParameter("Id");
		 //variables donde esta el contenido
		 //////////////
		 Document document = new Document(new Rectangle(212, 338),0,0,0,0);
		 Ruta = generales.getUrlLogout();
		 Font[] fonts = new Font[4];
			fonts[0] = new Font(Font.HELVETICA, 5, Font.NORMAL);
			fonts[1] = new Font(Font.HELVETICA, 5, Font.BOLD);
			fonts[2] = new Font(Font.HELVETICA, 8, Font.NORMAL);
			fonts[3] = new Font(Font.HELVETICA, 6, Font.BOLD, Color.WHITE);
			
			 response.setContentType("application/pdf");
			 response.setHeader("Content-Disposition","attachment;filename=" + NombreArchivo + ".pdf");
			 response.setHeader("Pragma","no-cache");
			 response.setHeader("Expires","-");
			try{
  				PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
				document.open();
				document.setPageSize(new Rectangle(212, 338));
				PdfContentByte pdf = writer.getDirectContent();
				BaseFont TextoNegro = BaseFont.createFont();
				PdfPCell cell = new PdfPCell();
				Paragraph Frase = new Paragraph();
				eDB.setConexion();
				resultados = eDB.getQuery("select C.*,TC.Archivo as Frente, T.Archivo as Atras from Credenciales as C left join TiposCredenciales as TC on(TC.Id = C.IdImagenAdelante) left join TiposCredenciales as T on(T.Id = C.IdImagenAtras) where C.Id = '" + NombreArchivo + "'");
				while(resultados.next()){
					 objeto = new Credenciales();
					 objeto.setId(resultados.getInt("Id"));
					 objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					 objeto.setPuesto(resultados.getString("Puesto"));
					 objeto.setEmpresa(resultados.getString("Empresa"));
					 objeto.setEstacion(resultados.getString("Estacion"));
					 objeto.setIMSS(resultados.getString("IMSS"));
					 objeto.setCURP(resultados.getString("CURP"));
					 objeto.setAntiguedad(resultados.getString("Antiguedad"));
					 objeto.setDivision(resultados.getString("Division"));
					 objeto.setNivel(resultados.getString("Nivel"));
					 objeto.setFechaEmision(resultados.getString("FechaEmision"));
					 objeto.setFechaVigencia(resultados.getString("FechaVigencia"));
					 objeto.setImagen(resultados.getString("Imagen"));
					 objeto.setIdImagenAdelante(resultados.getString("Frente"));
					 objeto.setIdImagenAtras(resultados.getString("Atras"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				///variables para separar en caso de que sea un nombre muy grande
				///si el nombre es muy grance
				String[] nombre = {""};
				String Nombre = "";
				String Apellidos = "";
				int tamaño = 0;
				if(objeto.getNombreCompleto().length() > 30){
					nombre = objeto.getNombreCompleto().split(" ");
					tamaño = nombre.length;
					Apellidos = nombre[tamaño-2];
					Apellidos += " " + nombre[tamaño-1];
					for(int x = 0; x < tamaño-2;x++){
						Nombre += nombre[x] + " ";
					}
				}else{
					Nombre = objeto.getNombreCompleto();
					Apellidos = "";
				}
				
				//Imagen principal
				///depende de sus datos sera la imagen que cargara
				ImagenFrente = Image.getInstance(Ruta + CarpetaCredenciales + "/" + objeto.getIdImagenAdelante());
				ImagenFrente.setAlignment(Element.ALIGN_LEFT);
				ImagenFrente.setBorder(Rectangle.NO_BORDER);
				ImagenFrente.scaleAbsolute(212, 338);
				ImagenAtras = Image.getInstance(Ruta + CarpetaCredenciales + "/" + objeto.getIdImagenAtras());
				ImagenAtras.setAlignment(Element.ALIGN_LEFT);
				ImagenAtras.setBorder(Rectangle.NO_BORDER);
				ImagenFrente.scaleAbsolute(212, 338);
				Imagen = Image.getInstance(Ruta + CarpetaFotos + "/" + objeto.getImagen());
				Imagen.setAlignment(Element.ALIGN_LEFT);
				Imagen.setBorder(Rectangle.NO_BORDER);
				Imagen.scaleAbsolute(50f, 100f);
				pdf.beginText(); 
					pdf.addImage(ImagenFrente, 212,0f,0f,338,0f,0f); //ANCHO, SABE, SABE, ALTO, DERECHA, ABAJO 600 x 777
				pdf.endText();
				pdf.beginText(); 
					pdf.addImage(Imagen, 50,0f,0f,100,50f,150f); //ANCHO, SABE, SABE, ALTO, DERECHA, ABAJO 600 x 777
				pdf.endText();
				pdf.beginText(); 
					pdf.setFontAndSize(TextoNegro, 45);
		        	pdf.showTextAligned(Element.ALIGN_CENTER, objeto.getEstacion(), 285, 300, 0);
		        pdf.endText();
		        if(Apellidos.equals("")){
		        	pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 23);
	        			pdf.showTextAligned(Element.ALIGN_CENTER, objeto.getNombreCompleto(), 285, 260, 0);
	        		pdf.endText();
	        		pdf.beginText();
	        			pdf.setFontAndSize(TextoNegro, 20);
	        			if(objeto.getNivel().equals("")){
	        				pdf.showTextAligned(Element.ALIGN_CENTER, objeto.getPuesto(), 285, 230, 0);
	        			}else{
	        				pdf.showTextAligned(Element.ALIGN_CENTER, objeto.getPuesto() + " - " + objeto.getNivel(), 285, 230, 0);
	        			}
	        		pdf.endText();
	        		pdf.beginText();
        				pdf.setFontAndSize(TextoNegro, 23);
        				pdf.setColorFill(Color.RED);
    					pdf.showTextAligned(Element.ALIGN_CENTER, "VIGENCIA: " + objeto.getFechaVigencia(), 285, 170, 0);
    				pdf.endText();
		        }else{
		        	pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 23);
        				pdf.showTextAligned(Element.ALIGN_CENTER, Nombre, 285, 260, 0);
        			pdf.endText();
        			pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 23);
    					pdf.showTextAligned(Element.ALIGN_CENTER, Apellidos, 285, 230, 0);
    				pdf.endText();
        			pdf.beginText();
        				pdf.setFontAndSize(TextoNegro, 23);
        				pdf.showTextAligned(Element.ALIGN_CENTER, objeto.getPuesto() + " - " + objeto.getNivel(), 285, 200, 0);
        			pdf.endText();
        			pdf.beginText();
    					pdf.setFontAndSize(TextoNegro, 23);
    					pdf.setColorFill(Color.RED);
						pdf.showTextAligned(Element.ALIGN_CENTER, "VIGENCIA: " + objeto.getFechaVigencia(), 285, 160, 0);
					pdf.endText();
		        }
                ///agregamos las tablas al documento
				document.newPage();
				pdf.beginText(); 
					pdf.addImage(ImagenAtras, 212,0f,0f,338,0f,0f); //ANCHO, SABE, SABE, ALTO, DERECHA, ABAJO 600 x 777
				pdf.endText();
				if(Apellidos.equals("")){
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, objeto.getNombreCompleto(), 10, 350, 0);
	        		pdf.endText();
	        		pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, "IMSS: " + objeto.getIMSS(), 10, 320, 0);
					pdf.endText();
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, "CURP: " + objeto.getCURP(), 10, 290, 0);
					pdf.endText();
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, "ANTIGÜEDAD: " + objeto.getAntiguedad(), 10, 260, 0);
					pdf.endText();
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, "FECHA EMISIÓN: " + objeto.getFechaEmision(), 10, 230, 0);
					pdf.endText();
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, "PUESTO: " + objeto.getPuesto(), 10, 200, 0);
					pdf.endText();
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, objeto.getNivel(), 10, 170, 0);
					pdf.endText();
				}else{
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
	    				pdf.showTextAligned(Element.ALIGN_LEFT, Nombre, 10, 350, 0);
	    			pdf.endText();
	    			pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, Apellidos, 10, 325, 0);
					pdf.endText();
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, "IMSS: " + objeto.getIMSS(), 10, 300, 0);
					pdf.endText();
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, "CURP: " + objeto.getCURP(), 10, 275, 0);
					pdf.endText();
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, "ANTIGÜEDAD: " + objeto.getAntiguedad(), 10, 250, 0);
					pdf.endText();
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, "FECHA EMISIÓN: " + objeto.getFechaEmision(), 10, 225, 0);
					pdf.endText();
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, "PUESTO: " + objeto.getPuesto(), 10, 200, 0);
					pdf.endText();
					pdf.beginText(); 
						pdf.setFontAndSize(TextoNegro, 20);
						pdf.showTextAligned(Element.ALIGN_LEFT, objeto.getNivel(), 10, 175, 0);
					pdf.endText();
				}
				//cerramos el documento
				document.close();
			} catch (DocumentException e1) {
				// TODO Auto-generated catch block
				System.err.println("Ocurrio un error al crear el archivo");
                System.out.println("Driver: " + e1);
                //System.exit(-1);
			}catch(SQLException e) {
				System.out.println("Driver: " + e);
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
