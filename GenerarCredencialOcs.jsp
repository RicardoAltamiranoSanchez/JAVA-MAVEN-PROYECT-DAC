<%@ page import="Configuraciones.Generales"%>
<%@ page import="Libreria.MysqlPool" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.lowagie.text.*"%>
<%@ page import="com.lowagie.text.pdf.*"%>
<%@ page import="java.awt.Color" %>
<%@ page import="Objetos.CredencialesOcs" %>

<%
	response.setContentType("application/pdf");

	Generales generales = new Generales();
	Document document = new Document(new Rectangle(850,540), 0, 0, 0, 0);
	MysqlPool eDB = new MysqlPool();
	CredencialesOcs objeto = new CredencialesOcs();
	ResultSet resultados;
	PdfWriter writer;
	PdfPCell cell;
	PdfContentByte cb;
	String NombreArchivo = request.getParameter("Id");
	eDB.setConexion();

	//resultados = eDB.getQuery("select C.*,TC.Archivo as Frente, T.Archivo as Atras from CredencialesOcs as C left join TiposCredenciales as TC on(TC.Id = C.IdImagenAdelante) left join TiposCredenciales as T on(T.Id = C.IdImagenAtras) where C.Id = '" + NombreArchivo + "'");
	resultados = eDB.getQuery("select C.* from CredencialesOcs as C where C.Id = '" + NombreArchivo + "'");
				while(resultados.next()){
					 objeto.setId(resultados.getInt("Id"));
					 objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					 objeto.setPuesto(resultados.getString("Puesto"));
					 objeto.setIMSS(resultados.getString("IMSS"));
					 objeto.setCURP(resultados.getString("CURP"));
					 objeto.setAntiguedad(resultados.getString("Antiguedad"));
					 objeto.setFechaEmision(resultados.getString("FechaEmision"));
					 objeto.setFechaVigencia(resultados.getString("FechaVigencia"));
					 objeto.setImagen(resultados.getString("Imagen"));
					 //objeto.setIdImagenAdelante(resultados.getString("Frente"));
					 //objeto.setIdImagenAtras(resultados.getString("Atras"));
				}
				
	writer = PdfWriter.getInstance(document, response.getOutputStream());
	//document.setPageSize(new Rectangle(540,850));//vert
	document.setPageSize(new Rectangle(850,540));//horiz

	document.open();
	
	String Ruta = "", CarpetaCredenciales = "credenciales",CarpetaFotos =  "fotos";
	Image ImagenFrente, ImagenAtras, Imagen;
	Ruta = generales.getUrlLogout();	//PRODUCTIVO
	//Ruta = "D:/Temp/";					//LOCAL
	
	//ImagenFrente = Image.getInstance(Ruta + CarpetaCredenciales + "/" + objeto.getIdImagenAdelante());
	ImagenFrente = Image.getInstance(Ruta + CarpetaCredenciales + "/OcsFrente.png");
	ImagenFrente.setAlignment(Element.ALIGN_LEFT);
	ImagenFrente.setBorder(Rectangle.NO_BORDER);
	ImagenFrente.scaleAbsolute(1265,540);
	//ImagenAtras = Image.getInstance(Ruta + CarpetaCredenciales + "/" + objeto.getIdImagenAtras());
	ImagenAtras = Image.getInstance(Ruta + CarpetaCredenciales + "/OcsAtras.png");
	ImagenAtras.setAlignment(Element.ALIGN_LEFT);
	ImagenAtras.setBorder(Rectangle.NO_BORDER);
	ImagenAtras.scaleAbsolute(1265,540);
	Imagen = Image.getInstance(Ruta + CarpetaFotos + "/" + objeto.getImagen());
	Imagen.setAlignment(Element.ALIGN_LEFT);
	Imagen.setBorder(Rectangle.NO_BORDER);
	//Imagen.scaleAbsolute(250, 300);
	Imagen.scaleAbsolute(246, 300); //82%
	

	Font[] fonts = new Font[8];
	fonts[0] = new Font(Font.HELVETICA, 2, Font.NORMAL);
	fonts[1] = new Font(Font.HELVETICA, 6, Font.BOLD); // encabezado
	fonts[2] = new Font(Font.HELVETICA, 6, Font.BOLD); // direccion escuela
	fonts[3] = new Font(Font.HELVETICA, 11, Font.BOLD); // nombre principal
	fonts[4] = new Font(Font.HELVETICA, 10, Font.BOLD); // apellidos
	fonts[5] = new Font(Font.HELVETICA, 7, Font.BOLD); // turno y grado
	
	fonts[6] = new Font(Font.HELVETICA, 22, Font.BOLD); // Nombre y Puesto
	fonts[6].setColor(Color.WHITE);
	
	fonts[7] = new Font(Font.HELVETICA, 22, Font.BOLD); // Vigencia
	fonts[7].setColor(Color.BLACK);
	  
	PdfPTable datosEncabezado = new PdfPTable(1);
	datosEncabezado.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	cell = new PdfPCell(ImagenFrente);
	cell.setBorder(0);
	double pading = -90.0;
	cell.setPaddingLeft((float) pading);
	datosEncabezado.addCell(cell);

	//NOMBRE 
	String[] SepararNombre;
	SepararNombre = objeto.getNombreCompleto().split(" ");
	int CantidadNombre = SepararNombre.length;
	String SegundoNombre = "";
	String TercerNombre = "";
	String ApellidoPaterno = "";
	String ApellidoMaterno = "";
	
	//CONDICIONES DE RENGLÓN NOMBRE
	if(CantidadNombre < 3){
		ApellidoPaterno = SepararNombre[CantidadNombre-1];
		ApellidoMaterno = "";
	}else{
		ApellidoPaterno = SepararNombre[CantidadNombre-2];
		ApellidoMaterno = SepararNombre[CantidadNombre-1];
	}
	
	if(CantidadNombre > 3){
		SegundoNombre = SepararNombre[1];
		if (CantidadNombre > 4){
			TercerNombre = SepararNombre[2];
		}else{
			TercerNombre = "";
		}		
	}else{
		SegundoNombre = "";
	}
	
	//Paragraph Nombre = new Paragraph(objeto.getNombreCompleto()+"\n"+"OTRO \n "+objeto.getPuesto(),fonts[6]);
	Paragraph Nombre = new Paragraph(SepararNombre[0]+" "+SegundoNombre+" "+TercerNombre+"\n"+ApellidoPaterno+" "+ApellidoMaterno+"\n "+objeto.getPuesto(),fonts[6]);
	cell = new PdfPCell(Nombre);
	cell.setHorizontalAlignment(Paragraph.ALIGN_CENTER);
	cell.setPaddingTop(-340);
	cell.setPaddingLeft(-220);
	datosEncabezado.addCell(cell);
	
	//VIGENCIA
	String[] FechaVigencia = objeto.getFechaVigencia().split("-");
	Paragraph Vigencia = new Paragraph("VIGENCIA: "+FechaVigencia[2]+"/"+FechaVigencia[1]+"/"+FechaVigencia[0],fonts[7]);
	cell = new PdfPCell(Vigencia);
	cell.setHorizontalAlignment(Paragraph.ALIGN_RIGHT);
	cell.setPaddingTop(-50);
	cell.setPaddingRight(-30);
	datosEncabezado.addCell(cell);
	
	cell = new PdfPCell(Imagen);
	cell.setBorder(0);
	cell.setPaddingTop(-470); //ALTO FOTO
	cell.setPaddingLeft(470); //>Recorre la foto a la derecha
	datosEncabezado.addCell(cell);
	
	document.add(datosEncabezado);
	document.newPage();
	
	PdfPTable tablaDatos = new PdfPTable(1);
	tablaDatos.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	cell = new PdfPCell(ImagenAtras);
	cell.setBorder(0);
	cell.setPaddingLeft((float) pading);
	tablaDatos.addCell(cell);
	
	//Paragraph NombreCompleto = new Paragraph(SepararNombre[0]+" "+SegundoNombre+" "+TercerNombre+" "+ApellidoPaterno+" "+ApellidoMaterno,fonts[6]);
	Paragraph NombreCompleto = new Paragraph(objeto.getNombreCompleto(),fonts[6]);
	cell = new PdfPCell(NombreCompleto);
	cell.setHorizontalAlignment(Paragraph.ALIGN_LEFT);
	cell.setPaddingTop(-290);
	cell.setPaddingLeft(-20);
	tablaDatos.addCell(cell);
	
	Paragraph IMSS = new Paragraph("IMSS: "+objeto.getIMSS(),fonts[6]);
	cell = new PdfPCell(IMSS);
	cell.setHorizontalAlignment(Paragraph.ALIGN_LEFT);
	cell.setPaddingTop(-260);
	cell.setPaddingLeft(-20);
	tablaDatos.addCell(cell);

	Paragraph CURP = new Paragraph("CURP: "+objeto.getCURP(),fonts[6]);
	cell = new PdfPCell(CURP);
	cell.setHorizontalAlignment(Paragraph.ALIGN_LEFT);
	cell.setPaddingTop(-230);
	cell.setPaddingLeft(-20);
	tablaDatos.addCell(cell);
	
	Paragraph Antiguedad = new Paragraph("ANTIGÜEDAD: "+objeto.getAntiguedad(),fonts[6]);
	cell = new PdfPCell(Antiguedad);
	cell.setHorizontalAlignment(Paragraph.ALIGN_LEFT);
	cell.setPaddingTop(-200);
	cell.setPaddingLeft(-20);
	tablaDatos.addCell(cell);
	
	String[] FechaEmision = objeto.getFechaEmision().split("-");
	Paragraph Emision = new Paragraph("FECHA EMISIÓN: "+FechaEmision[2]+"/"+FechaEmision[1]+"/"+FechaEmision[0],fonts[6]);
	cell = new PdfPCell(Emision);
	cell.setHorizontalAlignment(Paragraph.ALIGN_LEFT);
	cell.setPaddingTop(-170);
	cell.setPaddingLeft(-20);
	tablaDatos.addCell(cell);
	
	Paragraph Puesto = new Paragraph("PUESTO: "+objeto.getPuesto(),fonts[6]);
	cell = new PdfPCell(Puesto);
	cell.setHorizontalAlignment(Paragraph.ALIGN_LEFT);
	cell.setPaddingTop(-140);
	cell.setPaddingLeft(-20);
	tablaDatos.addCell(cell);
	
	document.add(tablaDatos);
	
	document.close();

	eDB.setCerrarConexion();
%>