<%@ page import="Configuraciones.Generales"%>
<%@ page import="Libreria.MysqlPool" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.lowagie.text.*"%>
<%@ page import="com.lowagie.text.pdf.*"%>
<%@ page import="java.awt.Color" %>
<%@ page import="Objetos.Credenciales" %>

<%
	response.setContentType("application/pdf");

	Generales generales = new Generales();
	Document document = new Document(new Rectangle(540,850), 0, 0, 0, 0);
	MysqlPool eDB = new MysqlPool();
	Credenciales objeto = new Credenciales();
	ResultSet resultados;
	PdfWriter writer;
	PdfPCell cell;
	PdfContentByte cb;
	String NombreArchivo = request.getParameter("Id");
	eDB.setConexion();

	resultados = eDB.getQuery("select C.*,TC.Archivo as Frente, T.Archivo as Atras from Credenciales as C left join TiposCredenciales as TC on(TC.Id = C.IdImagenAdelante) left join TiposCredenciales as T on(T.Id = C.IdImagenAtras) where C.Id = '" + NombreArchivo + "'");
				while(resultados.next()){
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
				
	writer = PdfWriter.getInstance(document, response.getOutputStream());
	document.setPageSize(new Rectangle(540,850));

	document.open();
	
	String Ruta = "", CarpetaCredenciales = "credenciales",CarpetaFotos =  "fotos";
	Image ImagenFrente, ImagenAtras, Imagen;
	Ruta = generales.getUrlLogout();
	
	ImagenFrente = Image.getInstance(Ruta + CarpetaCredenciales + "/" + objeto.getIdImagenAdelante());
	ImagenFrente.setAlignment(Element.ALIGN_LEFT);
	ImagenFrente.setBorder(Rectangle.NO_BORDER);
	ImagenFrente.scaleAbsolute(540,850);
	ImagenAtras = Image.getInstance(Ruta + CarpetaCredenciales + "/" + objeto.getIdImagenAtras());
	ImagenAtras.setAlignment(Element.ALIGN_LEFT);
	ImagenAtras.setBorder(Rectangle.NO_BORDER);
	ImagenAtras.scaleAbsolute(540,850);
	Imagen = Image.getInstance(Ruta + CarpetaFotos + "/" + objeto.getImagen());
	Imagen.setAlignment(Element.ALIGN_LEFT);
	Imagen.setBorder(Rectangle.NO_BORDER);
	Imagen.scaleAbsolute(250, 300);
	

	Font[] fonts = new Font[6];
	fonts[0] = new Font(Font.HELVETICA, 2, Font.NORMAL);
	fonts[1] = new Font(Font.HELVETICA, 6, Font.BOLD); // encabezado
	fonts[2] = new Font(Font.HELVETICA, 6, Font.BOLD); // direccion escuela
	fonts[3] = new Font(Font.HELVETICA, 11, Font.BOLD); // nombre principal
	fonts[4] = new Font(Font.HELVETICA, 10, Font.BOLD); // apellidos
	fonts[5] = new Font(Font.HELVETICA, 7, Font.BOLD); // turno y grado
	  
	PdfPTable datosEncabezado = new PdfPTable(1);
	datosEncabezado.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	cell = new PdfPCell(ImagenFrente);
	cell.setBorder(0);
	double pading = -54.50;
	cell.setPaddingLeft((float) pading);
	datosEncabezado.addCell(cell);
	
	cell = new PdfPCell(Imagen);
	cell.setBorder(0);
	cell.setPaddingTop(-710);
	cell.setPaddingLeft(95);
	datosEncabezado.addCell(cell);
	
	document.add(datosEncabezado);
	document.newPage();
	
	PdfPTable tablaDatos = new PdfPTable(1);
	tablaDatos.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	cell = new PdfPCell(ImagenAtras);
	cell.setBorder(0);
	cell.setPaddingLeft((float) pading);
	tablaDatos.addCell(cell);

	document.add(tablaDatos);
	
	document.close();

	eDB.setCerrarConexion();
%>