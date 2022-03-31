package Procesamiento;

import Configuraciones.Generales;
import Libreria.MysqlPool;

import java.awt.Color;
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

public class GenerarFormatoSeguroServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7607778029950680143L;
	//Variables de uso general
	private Generales generales;
	private HttpSession session;
	private MysqlPool eDB;
	private ResultSet resultados;

	//Variables donde se contienen los colores dependiendo de la guia que se utiliza
	private int RN = 228,GN = 108, BN = 10;
	private int RA = 197,GA = 217, BA = 241;
	
	private boolean debug = false;
	
	/**
	 * Constructor of the object.
	 */
	public GenerarFormatoSeguroServlet() {
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
		doPost(request, response);
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
			try {	
				
				eDB.setConexion();
				/*resultados = eDB.getQuery("select A.*, if(A.Fecha = '0000-00-00',curdate(),A.Fecha) as FechaActual, TipoEnvio+0 as TipoEnvio2, TipoEntrega+0 as TipoEntrega2, Servicios+0 as Servicios2, E.Empresa " + 
						"from Reservacion as A left join Empresas as E on (E.Id = A.IdEmpresas) where A.Id = '" + request.getParameter("IdReservacion") + "'");
				Reservacion objeto = new Reservacion();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("FechaActual"));
					objeto.setGuia(resultados.getString("Guia"));
					objeto.setEstatus(resultados.getString("Estatus"));
					objeto.setCodigoEstatus(resultados.getString("CodigoEstatus"));
					objeto.setIdEmpresas(resultados.getString("IdEmpresas"));
					objeto.setEmpresa(resultados.getString("Empresa"));
					objeto.setRemitente(resultados.getString("Remitente"));
					objeto.setREmpresa(resultados.getString("REmpresa"));
					objeto.setRDireccion(resultados.getString("RDireccion"));
					objeto.setRColonia(resultados.getString("RColonia"));
					objeto.setRCiudad(resultados.getString("RCiudad"));
					objeto.setREstado(resultados.getString("REstado"));
					objeto.setRCodigoPostal(resultados.getString("RCodigoPostal"));
					objeto.setRTelefono(resultados.getString("RTelefono"));
					objeto.setDestinatario(resultados.getString("Destinatario"));
					objeto.setDEmpresa(resultados.getString("DEmpresa"));
					objeto.setDDireccion(resultados.getString("DDireccion"));
					objeto.setDColonia(resultados.getString("DColonia"));
					objeto.setDCiudad(resultados.getString("DCiudad"));
					objeto.setDEstado(resultados.getString("DEstado"));
					objeto.setDCodigoPostal(resultados.getString("DCodigoPostal"));
					objeto.setDTelefono(resultados.getString("DTelefono"));
					objeto.setTipoEnvio(resultados.getString("TipoEnvio"));
					objeto.setTipoEntrega(resultados.getString("TipoEntrega"));
					objeto.setTotalPaquetes(resultados.getString("TotalPaquetes"));
					objeto.setPeso(resultados.getString("Peso"));
					objeto.setContenido(resultados.getString("Contenido"));
					objeto.setVolumen(resultados.getString("Volumen"));
					objeto.setValorDeclarado(resultados.getString("ValorDeclarado"));
					objeto.setServicios(resultados.getString("Servicios"));
					objeto.setTipoPago(resultados.getString("TipoPago"));
					objeto.setArticulo(resultados.getString("Articulo"));
					objeto.setFolio(resultados.getString("Folio"));
					objeto.setSolicitud(resultados.getString("Solicitud"));
				}
				resultados = eDB.getQuery("select * from Importes where IdReservacion = '" + request.getParameter("IdReservacion") + "'");
				Importes Importes = new Importes();
				while(resultados.next()){
					if(session.getAttribute("PerfilUsuario").equals("PAQ_CLIENTE")){
						Importes.setId(resultados.getInt("Id"));
						Importes.setIdReservacion(resultados.getString("IdReservacion"));
						Importes.setFlete("0.00");
						Importes.setEntregaDomicilio("0.00");
						Importes.setRecoleccion("0.00");
						Importes.setSeguro("0.00");
						Importes.setCombustible("0.00");
						Importes.setServicioAdicional("0.00");
						Importes.setSubtotal("0.00");
						Importes.setIva("0.00");
						Importes.setTotal("0.00");
					}else{
						Importes.setId(resultados.getInt("Id"));
						Importes.setIdReservacion(resultados.getString("IdReservacion"));
						if(resultados.getString("Flete").equals("0.00"))
							Importes.setFlete("0.00");
						else
							Importes.setFlete(resultados.getString("Flete"));
						if(resultados.getString("EntregaDomicilio").equals("0.00"))
							Importes.setEntregaDomicilio("0.00");
						else
							Importes.setEntregaDomicilio(resultados.getString("EntregaDomicilio"));
						if(resultados.getString("Recoleccion").equals("0.00"))
							Importes.setRecoleccion("0.00");
						else
							Importes.setRecoleccion(resultados.getString("Recoleccion"));
						if(resultados.getString("Seguro").equals("0.00"))
							Importes.setSeguro("0.00");
						else
							Importes.setSeguro(resultados.getString("Seguro"));
						if(resultados.getString("Combustible").equals("0.00"))
							Importes.setCombustible("0.00");
						else
							Importes.setCombustible(resultados.getString("Combustible"));
						if(resultados.getString("ServicioAdicional").equals("0.00"))
							Importes.setServicioAdicional("0.00");
						else
							Importes.setServicioAdicional(resultados.getString("ServicioAdicional"));
						Importes.setSubtotal(resultados.getString("Subtotal"));
						Importes.setIva(resultados.getString("Iva"));
						Importes.setTotal(resultados.getString("Total"));
					}
				}*/
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				//Variables uso general
				String Ruta = "", Carpeta = "imagenes", NombreArchivo = "";
				String Fecha = "9/10/2015",Cliente = "Prueba MCS Holding", Beneficiario = "Prueba 2 MCS Holding", ValorAsegurado = "$6,655.00", Cobertura = "AMPLIA", Desde = "$1,000.00"; 
				String Hasta = "$10,000.00", ModoTransporte = "TERRESTRE";
				Image Imagen, Logo;
				
				Document document = new Document();
				Ruta = generales.getUrlLogout() + Carpeta + "/";
				
				NombreArchivo = "Seguro";
				
				Font[] fonts = new Font[5];
				fonts[0] = new Font(Font.HELVETICA, 5, Font.NORMAL);
				fonts[1] = new Font(Font.HELVETICA, 5, Font.BOLD);
				fonts[2] = new Font(Font.HELVETICA, 8, Font.BOLD, Color.RED);
				//fonts[3] = new Font(Font.HELVETICA, 8, Font.BOLD, new Color(RN,GN,BN));
				fonts[3] = new Font(Font.HELVETICA, 12, Font.NORMAL);
				fonts[4] = new Font(Font.HELVETICA, 6, Font.BOLD, Color.WHITE);
				
				response.setContentType("application/pdf");
     			/*response.setHeader("Content-Disposition","attachment;filename=" + NombreArchivo + ".pdf");
     			response.setHeader("Pragma","no-cache");
     			response.setHeader("Expires","-");*/
     			
            	try {
            		PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
					document.open();
					document.setPageSize(PageSize.LETTER);
					PdfContentByte pdf = writer.getDirectContent();
					//document.newPage();
	                PdfPCell cell = new PdfPCell();
	                PdfPTable TablaEncabezado = new PdfPTable(6);
	                TablaEncabezado.setWidthPercentage(100);
	                Paragraph Frase = new Paragraph();
	                //Imagen principal
	                Imagen = Image.getInstance(Ruta + "MCS_LATERAL.png");
	                Imagen.setAlignment(Element.ALIGN_LEFT);
	                Imagen.setBorder(Rectangle.NO_BORDER);
	                Imagen.scaleAbsolute(49f, 423f);
	                Logo = Image.getInstance(Ruta + "MCS_LOGO.png");
	                Logo.setAlignment(Element.ALIGN_RIGHT);
	                Logo.setBorder(Rectangle.NO_BORDER);
	                Logo.scaleAbsolute(126f, 86f);
	                
	                CrearCeldaImagen(cell,Imagen,TablaEncabezado,1,26,"Izquierda","","Ninguno",false);
	                CrearCeldaImagen(cell,Logo,TablaEncabezado,5,1,"Derecha","","Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,5,1,Fecha, "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,5,1,Cliente, "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,1,1,"Beneficiario:", "Izquierda", "", "Ninguno",false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,4,1,Beneficiario, "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,5,1,"Le informamos que su carga con la guía XXX viaja asegurada con Seguros Atlas S.A. bajo el número de póliza G00-2-2-7546 de Mexican Cargo Sales Representative S.A. de C.V", "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,5,1,"En caso de algún siniestro, es requisito indispensable que cuente con la factura de los bienes asegurados y descritos en la presente guía.", "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,5,1,"Dicho documento será indispensable para realizar cualquier reclamación ante la compañía de seguros.", "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,5,1,"Cualquier duda favor de contactarnos a: seguro@mcs-holding.com", "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,2,1,"Valor Asegurado:", "Izquierda", "", "Ninguno",false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,3,1,ValorAsegurado, "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,1,1,"Cobertura:", "Izquierda", "", "Ninguno",false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,4,1,Cobertura, "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,1,1,"Desde:", "Izquierda", "", "Ninguno",false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,4,1,Desde, "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,1,1,"Hasta:", "Izquierda", "", "Ninguno",false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,4,1,Hasta, "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,1,1,"Modo Transporte:", "Izquierda", "", "Ninguno",false);
	                CrearCelda(cell,Frase,fonts[3],TablaEncabezado,4,1,ModoTransporte, "Izquierda", "", "Ninguno",false);
	                CrearCeldaVacia(cell,Frase, TablaEncabezado, 5, 1, "Ninguno", false);
	                //agregar tabla al documento
	                document.add(TablaEncabezado);
	                
					document.close();
			} catch (DocumentException e1) {
				// TODO Auto-generated catch block
				System.err.println("Ocurrio un error al crear el archivo");
                System.out.println("Driver: " + e1);
                //System.exit(-1);
			}catch(Exception e) {
				System.out.println("Driver: " + e);
				e.printStackTrace(System.out);
			}
            	} catch(SQLException e1){
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
