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

import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

public class GenerarCredencialServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3881536679172399802L;
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
	public GenerarCredencialServlet() {
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
		request.setCharacterEncoding("UTF-8");
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
		String Ruta = "", CarpetaFotos = "fotos", CarpetaCredenciales = "credenciales", NombreArchivo = request.getParameter("Id");
		Image Imagen, ImagenFrente, ImagenAtras;
		//creamos el documento
		Document documento = new Document(new Rectangle(212, 338),0,0,0,0);
		//Ruta de donde se encuentra la imagen
		objeto = new Credenciales();
		Ruta = generales.getUrlLogout(); //PRODUCTIVO
		//Ruta = "D:/Temp/"; //LOCAL
		
		
		try{
			//tipo de archivos
			response.setContentType("application/pdf; charset=UTF-8");
 			response.setHeader("Content-Disposition","attachment;filename=" + NombreArchivo + ".pdf");
 			response.setCharacterEncoding("UTF-8");
 			response.setHeader("Pragma","no-cache");
 			response.setHeader("Expires","-");
			//conexion base de datos
			eDB.setConexion();
			//query
			resultados = eDB.getQuery("select C.*,TC.Archivo as Frente, T.Archivo as Atras from " + request.getParameter("Tabla") + " as C left join TiposCredenciales as TC on(TC.Id = C.IdImagenAdelante) left join TiposCredenciales as T on(T.Id = C.IdImagenAtras) where C.Id = '" + NombreArchivo + "'");
			while(resultados.next()){
				 objeto.setId(resultados.getInt("Id"));
				 objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
				 
				 if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
					 objeto.setCorreoElectronico(resultados.getString("CorreoElectronico"));
					 objeto.setTelefono(resultados.getString("Telefono"));
					 objeto.setDomicilio(resultados.getString("Domicilio"));
					 objeto.setPaginaWeb(resultados.getString("PaginaWeb"));
				 }
				 
				 objeto.setPuesto(resultados.getString("Puesto"));
				 objeto.setEmpresa(resultados.getString("Empresa"));
				 objeto.setEstacion(resultados.getString("Estacion"));
				 objeto.setIMSS(resultados.getString("IMSS"));
				 objeto.setCURP(resultados.getString("CURP"));
				 objeto.setAntiguedad(resultados.getString("Antiguedad"));
				 //objeto.setDivision(resultados.getString("Division"));
				 //objeto.setNivel(resultados.getString("Nivel"));
				 //objeto.setFechaEmision(resultados.getString("FechaEmision"));
				 objeto.setFechaVigencia(resultados.getString("FechaVigencia"));
				 objeto.setImagen(resultados.getString("Imagen"));
				 objeto.setIdImagenAdelante(resultados.getString("Frente"));
				 objeto.setIdImagenAtras(resultados.getString("Atras"));
			}
			//cerramos la conexion con la base de datos
			eDB.setCerrar(resultados);
			eDB.setCerrar();
			eDB.setCerrarConexion();
			//tipos de letras
			Font[] fonts = new Font[9];
			fonts[0] = new Font(Font.HELVETICA, 9, Font.BOLD, Color.WHITE);
			fonts[1] = new Font(Font.HELVETICA, 25, Font.BOLD, Color.WHITE);
			fonts[2] = new Font(Font.HELVETICA, 11, Font.BOLD, Color.RED);
			fonts[3] = new Font(Font.HELVETICA, 7, Font.BOLD, Color.WHITE);
			fonts[4] = new Font(Font.HELVETICA, 10, Font.BOLD, Color.WHITE);
			fonts[5] = new Font(Font.HELVETICA, 9, Font.NORMAL, Color.WHITE);
			fonts[6] = new Font(Font.HELVETICA, 7, Font.NORMAL, Color.WHITE);
			fonts[7] = new Font(Font.HELVETICA, 5, Font.NORMAL, Color.WHITE);
			
 			
        	//variable
        		PdfWriter writer = PdfWriter.getInstance(documento, response.getOutputStream());
        		//abrir documento
				documento.open();
				//tamaÃ±o de hoja
				documento.setPageSize(new Rectangle(212, 338));//212, 338
				//contenido del documento
				PdfContentByte pdf = writer.getDirectContent();
				PdfPCell celda = new PdfPCell();
				Paragraph Frase = new Paragraph();
				//Imagenes
				///depende de sus datos sera la imagen que cargara
				ImagenFrente = Image.getInstance(Ruta + CarpetaCredenciales + "/" + objeto.getIdImagenAdelante());
				ImagenFrente.setAlignment(Element.ALIGN_LEFT);
				ImagenFrente.setBorder(Rectangle.NO_BORDER);
				ImagenFrente.scaleAbsolute(212, 338);
				ImagenAtras = Image.getInstance(Ruta + CarpetaCredenciales + "/" + objeto.getIdImagenAtras());
				ImagenAtras.setAlignment(Element.ALIGN_LEFT);
				ImagenAtras.setBorder(Rectangle.NO_BORDER);
				ImagenAtras.scaleAbsolute(212, 338);
				Imagen = Image.getInstance(Ruta + CarpetaFotos + "/" + objeto.getImagen());
				Imagen.setAlignment(Element.ALIGN_LEFT);
				Imagen.setBorder(Rectangle.NO_BORDER);
				Imagen.scaleAbsolute(90f, 95f);//ANTES 95f,120f
				//creamos las tablas
				PdfPTable TablaFrente = new PdfPTable(2);
				PdfPTable TablaAtras = new PdfPTable(1);
				//tabla frente
				celda = new PdfPCell(ImagenFrente);
				celda.setBorder(0);
				double pading = -21.5;
				celda.setPaddingLeft((float) pading);
				TablaFrente.addCell(celda);
				//tabla imagen
				celda = new PdfPCell(Imagen);
				celda.setBorder(0);
				if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
					celda.setPaddingRight(80);//80
					celda.setPaddingLeft(-48);//-48
					celda.setPaddingTop(90);//60
				 }else {
					celda.setPaddingRight(70);//80
					celda.setPaddingLeft(-45);//-48
					celda.setPaddingTop(95);//90
				 }
				TablaFrente.addCell(celda);
				//estacion
				//Frase = new Paragraph();
				//Frase.add(new Chunk(objeto.getEstacion(), fonts[1]));
				//celda = new PdfPCell(Frase);
				//celda.setBorder(0);
				//celda.setColspan(2);
				//celda.setPaddingLeft(60);
				//celda.setPaddingTop(-155);
				//TablaFrente.addCell(celda);
				//nombre
				if(objeto.getNombreCompleto().length() > 26){
					//nombre
					Frase = new Paragraph();
					Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[4]));
					celda = new PdfPCell(Frase);
					celda.setBorder(0);
					celda.setColspan(2);
					celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
						celda.setPaddingTop(-135);//-125
						celda.setPaddingLeft(0);
					 }else {
						celda.setPaddingTop(-122);//-125
						celda.setPaddingLeft(0);
					 }
					TablaFrente.addCell(celda);
				}else if(objeto.getNombreCompleto().length() <= 26){
					Frase = new Paragraph();
					Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[4]));
					celda = new PdfPCell(Frase);
					celda.setBorder(0);
					celda.setColspan(2);
					celda.setHorizontalAlignment(Element.ALIGN_CENTER);
					if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
						celda.setPaddingTop(-130);//120
						celda.setPaddingLeft(0);
					 }else {
						celda.setPaddingTop(-120);//130
						celda.setPaddingLeft(0);
					 }
					TablaFrente.addCell(celda);
				}
				//puesto
				Frase = new Paragraph();
				if(objeto.getNivel().equals("")){
					if(objeto.getPuesto().length() > 26){
						Frase.add(new Chunk(objeto.getPuesto(), fonts[5]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setColspan(2);
						//HACIENDO MÁS PEQUEÑA LA CELDA QUE CONTIENE LA IMPRESIÓN DE EMPLEO
						celda.setPaddingRight(10);//80
						celda.setPaddingLeft(10);//-48
						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							celda.setPaddingTop(-105);
						 }else {
							celda.setPaddingTop(-103);
						 }
						TablaFrente.addCell(celda);
					}else if(objeto.getPuesto().length() <= 26){
						Frase.add(new Chunk(objeto.getPuesto(), fonts[5]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setColspan(2);
						//HACIENDO MÁS PEQUEÑA LA CELDA QUE CONTIENE LA IMPRESIÓN DE EMPLEO
						celda.setPaddingRight(10);//80
						celda.setPaddingLeft(10);//-48
						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setPaddingTop(-100);
						TablaFrente.addCell(celda);
					}
				}else{
					if(objeto.getPuesto().length() > 26){
						Frase.add(new Chunk(objeto.getPuesto() + " - " + objeto.getNivel(), fonts[5]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setColspan(2);
						celda.setPaddingLeft(-8);
						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setPaddingTop(-105);
						TablaFrente.addCell(celda);
					}else if(objeto.getPuesto().length() <= 26){
						Frase.add(new Chunk(objeto.getPuesto() + " - " + objeto.getNivel(), fonts[5]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setColspan(2);
						celda.setPaddingLeft(-8);
						celda.setHorizontalAlignment(Element.ALIGN_CENTER);
						celda.setPaddingTop(-100);
						TablaFrente.addCell(celda);
					}
				}
				
				//vigencia
				//Frase = new Paragraph();
				//Frase.add(new Chunk("VIGENCIA: " + objeto.getFechaVigencia(), fonts[2]));
				//celda = new PdfPCell(Frase);
				//celda.setBorder(0);
				//celda.setColspan(2);
				//celda.setPaddingLeft(30);
				//celda.setPaddingTop(-80);
				//TablaFrente.addCell(celda);
				//agregamos tablas al documento
				documento.add(TablaFrente);
				//nueva pagina
				documento.newPage();
				//tabla atras
				celda = new PdfPCell(ImagenAtras);
				celda.setBorder(0);
				celda.setPaddingLeft((float) pading);
				TablaAtras.addCell(celda);
				if(objeto.getNivel().equals("")){
					if(objeto.getNombreCompleto().length() > 30){
						//CUANDO EL TAMAÑO DEL NOMBRE SI IMPORTABA
//						//nombre
//						Frase = new Paragraph();
//						Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[6]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setHorizontalAlignment(Element.ALIGN_LEFT);
//						celda.setPaddingTop(-153);//-150
//						celda.setPaddingLeft(-1);//0
//						TablaAtras.addCell(celda);
//						//imss
//						Frase = new Paragraph();
//						Frase.add(new Chunk(" " + objeto.getIMSS(), fonts[6]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(18);//0
//						celda.setPaddingTop(-135);//-132
//						TablaAtras.addCell(celda);
//						//curp
//						Frase = new Paragraph();
//						Frase.add(new Chunk(" " + objeto.getCURP(), fonts[6]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(21);//0
//						celda.setPaddingTop(-126);//-122
//						TablaAtras.addCell(celda);
//						//antiguedad
//						Frase = new Paragraph();
//						Frase.add(new Chunk(" " + objeto.getAntiguedad(), fonts[6]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(51);//0
//						celda.setPaddingTop(-117);//-112
//						TablaAtras.addCell(celda);
////						
////						//TablaAtras emision
////						Frase = new Paragraph();
////						Frase.add(new Chunk("FECHA EMISIÓN: " + objeto.getFechaEmision(), fonts[3]));
////						celda = new PdfPCell(Frase);
////						celda.setBorder(0);
////						celda.setPaddingLeft(0);
////						celda.setPaddingTop(-102);
////						TablaAtras.addCell(celda);
////						
//						//puesto
//						Frase = new Paragraph();
//						Frase.add(new Chunk(" " + objeto.getPuesto(), fonts[6]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(30);//0
//						celda.setPaddingTop(-108);//ANTES -92//NUEVO ANTES -102
//						TablaAtras.addCell(celda);
						
						
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//nombre
							Frase = new Paragraph();
							Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setPaddingLeft(-1);//0
							celda.setPaddingTop(-143);//-140
							TablaAtras.addCell(celda);
						 }else {
							
						 }
						
						//imss
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getIMSS(), fonts[6]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(18);//0
						celda.setPaddingTop(-133);//-130
						TablaAtras.addCell(celda);
						//curp
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getCURP(), fonts[6]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(21);//0
						celda.setPaddingTop(-124);//-120
						TablaAtras.addCell(celda);
						
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//antiguedad
							Frase = new Paragraph();
							Frase.add(new Chunk(" " + objeto.getAntiguedad(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setPaddingLeft(51);//0
							celda.setPaddingTop(-115);//-110
							TablaAtras.addCell(celda);
						 }else {
							
						 }
//						
//						//TablaAtras emision
//						Frase = new Paragraph();
//						Frase.add(new Chunk("FECHA EMISIÓN: " + objeto.getFechaEmision(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-100);
//						TablaAtras.addCell(celda);
//						
						
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//puesto
							Frase = new Paragraph();
							Frase.add(new Chunk(" " + objeto.getPuesto(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setPaddingLeft(30);//0
							celda.setPaddingTop(-106);//ANTES -90//NUEVO ANTES -100
							TablaAtras.addCell(celda);
						 }else {
							
						 }
						
						//correo
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getCorreoElectronico(), fonts[7]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(14);//0
						celda.setPaddingTop(-63);//
						TablaAtras.addCell(celda);
						
						//telefono
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getTelefono(), fonts[7]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(118);//0
						celda.setPaddingTop(-63);//
						TablaAtras.addCell(celda);
						
						//domicilio
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getDomicilio(), fonts[7]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(14);//0
						celda.setPaddingTop(-50);//
						TablaAtras.addCell(celda);
						
						//pagina web
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getPaginaWeb(), fonts[7]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(118);//0
						celda.setPaddingTop(-50);//
						TablaAtras.addCell(celda);
					}else if(objeto.getNombreCompleto().length() <= 30){
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//nombre
							Frase = new Paragraph();
							Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setPaddingLeft(-1);//0
							celda.setPaddingTop(-143);//-140
							TablaAtras.addCell(celda);
						 }else {
							
						 }
						
						//imss
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getIMSS(), fonts[6]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(18);//0
						celda.setPaddingTop(-133);//-130
						TablaAtras.addCell(celda);
						//curp
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getCURP(), fonts[6]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(21);//0
						celda.setPaddingTop(-124);//-120
						TablaAtras.addCell(celda);
						
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//antiguedad
							Frase = new Paragraph();
							Frase.add(new Chunk(" " + objeto.getAntiguedad(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setPaddingLeft(51);//0
							celda.setPaddingTop(-115);//-110
							TablaAtras.addCell(celda);
						 }else {
							
						 }
						
//						
//						//TablaAtras emision
//						Frase = new Paragraph();
//						Frase.add(new Chunk("FECHA EMISIÓN: " + objeto.getFechaEmision(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-100);
//						TablaAtras.addCell(celda);
//						
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//puesto
							Frase = new Paragraph();
							Frase.add(new Chunk(" " + objeto.getPuesto(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setPaddingLeft(30);//0
							celda.setPaddingTop(-106);//ANTES -90//NUEVO ANTES -100
							TablaAtras.addCell(celda);
						 }else {
							
						 }

						
						//correo
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getCorreoElectronico(), fonts[7]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(14);//0
						celda.setPaddingTop(-63);//
						TablaAtras.addCell(celda);
						
						//telefono
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getTelefono(), fonts[7]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(118);//0
						celda.setPaddingTop(-63);//
						TablaAtras.addCell(celda);
						
						//domicilio
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getDomicilio(), fonts[7]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(14);//0
						celda.setPaddingTop(-50);//
						TablaAtras.addCell(celda);
						
						//pagina web
						Frase = new Paragraph();
						Frase.add(new Chunk(" " + objeto.getPaginaWeb(), fonts[7]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(118);//0
						celda.setPaddingTop(-50);//
						TablaAtras.addCell(celda);
					}
				}else{
					if(objeto.getNombreCompleto().length() < 30){
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//nombre
							Frase = new Paragraph();
							Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setHorizontalAlignment(Element.ALIGN_LEFT);
							celda.setPaddingTop(-149);
							celda.setPaddingLeft(0);
							TablaAtras.addCell(celda);
						 }else {
							
						 }

						//imss
						Frase = new Paragraph();
						Frase.add(new Chunk("IMSS: " + objeto.getIMSS(), fonts[6]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(0);
						celda.setPaddingTop(-132);
						TablaAtras.addCell(celda);
						//curp
						Frase = new Paragraph();
						Frase.add(new Chunk("CURP: " + objeto.getCURP(), fonts[6]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(0);
						celda.setPaddingTop(-122);
						TablaAtras.addCell(celda);
						
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//antiguedad
							Frase = new Paragraph();
							Frase.add(new Chunk("ANTIGÜEDAD: " + objeto.getAntiguedad(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setPaddingLeft(0);
							celda.setPaddingTop(-112);
							TablaAtras.addCell(celda);
						 }else {
							
						 }

//						
//						//TablaAtras emision
//						Frase = new Paragraph();
//						Frase.add(new Chunk("FECHA EMISIÓN: " + objeto.getFechaEmision(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-102);
//						TablaAtras.addCell(celda);
//						
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//puesto
							Frase = new Paragraph();
							Frase.add(new Chunk("PUESTO: " + objeto.getPuesto(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setPaddingLeft(0);
							celda.setPaddingTop(-102);//ANTES -92
							TablaAtras.addCell(celda);
						 }else {
							
						 }

						//nivel
						Frase = new Paragraph();
						Frase.add(new Chunk(objeto.getNivel(), fonts[6]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(0);
						celda.setPaddingTop(-82);
						TablaAtras.addCell(celda);
					}else if(objeto.getNombreCompleto().length() > 30){
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//nombre
							Frase = new Paragraph();
							Frase.add(new Chunk(objeto.getNombreCompleto(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setPaddingLeft(0);
							celda.setPaddingTop(-140);
							TablaAtras.addCell(celda);
						 }else {
							
						 }

						//imss
						Frase = new Paragraph();
						Frase.add(new Chunk("IMSS: " + objeto.getIMSS(), fonts[6]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(0);
						celda.setPaddingTop(-130);
						TablaAtras.addCell(celda);
						//curp
						Frase = new Paragraph();
						Frase.add(new Chunk("CURP: " + objeto.getCURP(), fonts[6]));
						celda = new PdfPCell(Frase);
						celda.setBorder(0);
						celda.setPaddingLeft(0);
						celda.setPaddingTop(-120);
						TablaAtras.addCell(celda);
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//antiguedad
							Frase = new Paragraph();
							Frase.add(new Chunk("ANTIGÜEDAD: " + objeto.getAntiguedad(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setPaddingLeft(0);
							celda.setPaddingTop(-110);
							TablaAtras.addCell(celda);
						 }else {
							
						 }

//						
//						//TablaAtras emision
//						Frase = new Paragraph();
//						Frase.add(new Chunk("FECHA EMISIÓN: " + objeto.getFechaEmision(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-100);
//						TablaAtras.addCell(celda);
//						
						if(!request.getParameter("Tabla").equals("CredencialesExternos")) {
							//puesto
							Frase = new Paragraph();
							Frase.add(new Chunk("PUESTO: " + objeto.getPuesto(), fonts[6]));
							celda = new PdfPCell(Frase);
							celda.setBorder(0);
							celda.setPaddingLeft(0);
							celda.setPaddingTop(-100);//ANTES -90
							TablaAtras.addCell(celda);
						 }else {
							
						 }

//						
//					    //nivel
//						Frase = new Paragraph();
//						Frase.add(new Chunk(objeto.getNivel(), fonts[3]));
//						celda = new PdfPCell(Frase);
//						celda.setBorder(0);
//						celda.setPaddingLeft(0);
//						celda.setPaddingTop(-80);
//						TablaAtras.addCell(celda);
//						
					}
				}
				//agregamos tabla al documento
				documento.add(TablaAtras);
				//cerramos documento
				documento.close();
		}catch (DocumentException e1) {
			// TODO Auto-generated catch block
			System.err.println("Ocurrio un error al crear el archivo");
            System.out.println("Driver: " + e1);
            //System.exit(-1);
		}catch(SQLException e1){
			System.out.println("Formato Guia: " + e1);
			e1.printStackTrace(System.out);
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