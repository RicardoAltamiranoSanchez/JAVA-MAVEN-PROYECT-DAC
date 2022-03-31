<%@ page import="Configuraciones.Generales"%>
<%@ page import="Libreria.MysqlPool" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.lowagie.text.*"%>
<%@ page import="com.lowagie.text.pdf.*"%>
<%@ page import="java.awt.Color" %>
<%
	response.setContentType("application/pdf");

	Generales generales = new Generales();
	Document document = new Document(new Rectangle(212, 338), 0, 0, 0, 0);
	MysqlPool eDB = new MysqlPool();
	ResultSet resultados;
	PdfWriter writer;
	PdfPCell cell;
	PdfContentByte cb;
	
	Image fondo, benito, sec, firma, codigoBarras, foto;
	
	PdfPTable tablaEncabezado, datosEncabezado, tablaEscuela, datosEscuela, tablaPresente, tablaAlumno, datosAlumno, tablaFirma, datosDirectora, tablaDirectora, tablaDatos;
	
	String nombre1, nombre2, nombre3, imagen, turno, grupo, domicilio, telefono, tipoSangre, alergias, emergencia, vigencia;
	
	eDB.setConexion();
	
	
	
	nombre1 = ""; nombre2 = ""; nombre3 = ""; imagen = ""; turno = ""; grupo = ""; domicilio = ""; telefono = ""; tipoSangre = ""; alergias = ""; emergencia = "";
	vigencia = "01/09/2012 - 01/09/2013";
	resultados = eDB.getQuery("select * from Alumnos where Id = '" + request.getParameter("Id") + "'");
	while(resultados.next()) {
		nombre1 = resultados.getString("Nombre");
		nombre2 = resultados.getString("Paterno");
		nombre3 = resultados.getString("Materno");
		imagen = resultados.getString("Foto");
		turno = resultados.getString("Turno");
		grupo = resultados.getString("Grupo");
		domicilio = resultados.getString("Direccion");
		telefono = resultados.getString("Telefono");
		tipoSangre = resultados.getString("TipoSangre");
		alergias = resultados.getString("Alergia"); 
		emergencia = resultados.getString("CasoEmergencia"); 
	}
	
	
	writer = PdfWriter.getInstance(document, response.getOutputStream());
	document.setPageSize(new Rectangle(212, 338));

	document.open();
	
	fondo = Image.getInstance(generales.getProtocolo()
	+ "://" + request.getServerName() + generales.getPuerto()
	+ "/" + generales.getDirectorio()
	+ "/imagenes/fondo.jpg");

	benito = Image.getInstance(generales.getProtocolo()
	+ "://" + request.getServerName() + generales.getPuerto()
	+ "/" + generales.getDirectorio()
	+ "/imagenes/benito2.png");
	
	sec = Image.getInstance(generales.getProtocolo()
	+ "://" + request.getServerName() + generales.getPuerto()
	+ "/" + generales.getDirectorio()
	+ "/imagenes/sec_edu.jpg");
	
	firma = Image.getInstance(generales.getProtocolo()
	+ "://" + request.getServerName() + generales.getPuerto()
	+ "/" + generales.getDirectorio()
	+ "/imagenes/firmadirectora.png");
	
	foto = Image.getInstance(generales.getProtocolo()
	+ "://" + request.getServerName() + generales.getPuerto()
	+ "/" + generales.getDirectorio()
	+ "/fotos/" + imagen);
	
	codigoBarras = Image.getInstance(generales.getProtocolo() + "://" + request.getServerName() + generales.getPuerto() + "/" + "barbecue/barcode?data=Id" + request.getParameter("Id") + "&height=30&width=1&drawText=yes");
	

	Font[] fonts = new Font[6];
	fonts[0] = new Font(Font.HELVETICA, 2, Font.NORMAL);
	fonts[1] = new Font(Font.HELVETICA, 6, Font.BOLD); // encabezado
	fonts[2] = new Font(Font.HELVETICA, 6, Font.BOLD); // direccion escuela
	fonts[3] = new Font(Font.HELVETICA, 11, Font.BOLD); // nombre principal
	fonts[4] = new Font(Font.HELVETICA, 10, Font.BOLD); // apellidos
	fonts[5] = new Font(Font.HELVETICA, 7, Font.BOLD); // turno y grado

	float[] widths1 = { 0.35f, 0.15f, 0.3f, 0.2f };//percentage

	cb = writer.getDirectContent();
	cb.beginText(); 
	cb.addImage(fondo, 212f,0f,0f,338f,0f,0f); //ANCHO, SABE, SABE, ALTO, DERECHA, ABAJO 600 x 777
	cb.endText();
	  
	datosEncabezado = new PdfPTable(1);
	datosEncabezado.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	cell = new PdfPCell(new Paragraph("ESCUELA SECUNDARIA MIXTA No. 21", fonts[1]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosEncabezado.addCell(cell);
	
	cell = new PdfPCell(new Paragraph("Lic. Benito Pablo Juárez García", fonts[1]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosEncabezado.addCell(cell);
	
	cell = new PdfPCell(new Paragraph("CLAVE: 14EES0005N", fonts[1]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosEncabezado.addCell(cell);
	
	cell = new PdfPCell(new Paragraph("CICLO ESCOLAR 2012-2013", fonts[1]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosEncabezado.addCell(cell);
	

	float[] widthsEncabezado = { 0.3f, 0.7f };//percentage
	tablaEncabezado = new PdfPTable(widthsEncabezado);
	tablaEncabezado.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	tablaEncabezado.addCell("");
	tablaEncabezado.addCell("");
	
	tablaEncabezado.addCell("");
	tablaEncabezado.addCell("");
	
	tablaEncabezado.addCell("");
	tablaEncabezado.addCell("");
	
	tablaEncabezado.addCell(sec);
	tablaEncabezado.addCell(datosEncabezado);
	
	// seccion datos de escuela
	
	datosEscuela = new PdfPTable(1);
	datosEscuela.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	cell = new PdfPCell(new Paragraph("Encarnación Ortiz No. 501", fonts[1]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosEscuela.addCell(cell);
	
	cell = new PdfPCell(new Paragraph("Atemajac del Valle", fonts[1]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosEscuela.addCell(cell);
	
	cell = new PdfPCell(new Paragraph("Zapopan Jalisco", fonts[1]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosEscuela.addCell(cell);
	
	cell = new PdfPCell(new Paragraph("Tel: 36721995 - 38618216", fonts[1]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_TOP);
	cell.setPaddingTop(1);
	datosEscuela.addCell(cell);
	
	cell = new PdfPCell(datosEscuela);
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	
	float[] widthsEscuela = { 0.6f, 0.4f };//percentage
	tablaEscuela = new PdfPTable(widthsEscuela);
	tablaEscuela.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	tablaEscuela.addCell("");
	tablaEscuela.addCell("");
	
	tablaEscuela.addCell("");
	tablaEscuela.addCell("");
	
	tablaEscuela.addCell("");
	tablaEscuela.addCell("");
	
	tablaEscuela.addCell(cell);
	tablaEscuela.addCell(benito);
	
	tablaEscuela.addCell("");
	tablaEscuela.addCell("");
	
	tablaEscuela.addCell("");
	tablaEscuela.addCell("");

	// presente
	
	tablaPresente = new PdfPTable(1);
	tablaPresente.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	
	cell = new PdfPCell(new Paragraph("LA PRESENTE ACREDITA A:", fonts[2]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaPresente.addCell(cell);

	// datos alumno
	
	datosAlumno = new PdfPTable(1);
	datosAlumno.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	cell = new PdfPCell(new Paragraph(nombre1, fonts[3]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosAlumno.addCell(cell);
	
	cell = new PdfPCell(new Paragraph(nombre2, fonts[3]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosAlumno.addCell(cell);
	
	cell = new PdfPCell(new Paragraph(nombre3, fonts[3]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosAlumno.addCell(cell);
	
	datosAlumno.addCell("");
	
	cell = new PdfPCell(new Paragraph("TURNO: " + turno, fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosAlumno.addCell(cell);
	
	cell = new PdfPCell(new Paragraph("GRADO: " + grupo, fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	datosAlumno.addCell(cell);
	
	float[] widthsAlumno = { 0.45f, 0.55f };//percentage
	tablaAlumno = new PdfPTable(widthsAlumno);
	tablaAlumno.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	tablaAlumno.addCell("");
	tablaAlumno.addCell("");
	
	tablaAlumno.addCell("");
	tablaAlumno.addCell("");
	
	tablaAlumno.addCell("");
	tablaAlumno.addCell("");
	
	tablaAlumno.addCell(foto);
	tablaAlumno.addCell(datosAlumno);
	
	tablaAlumno.addCell("");
	tablaAlumno.addCell("");
	
	tablaAlumno.addCell("");
	tablaAlumno.addCell("");
	
	
	tablaDirectora = new PdfPTable(1);
	tablaDirectora.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	
	tablaDirectora.addCell(firma);
	
	cell = new PdfPCell(new Paragraph("Profa. CLARA LETICIA GONZALEZ CERVANTES", fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDirectora.addCell(cell);
	
	cell = new PdfPCell(new Paragraph("DIRECTORA", fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDirectora.addCell(cell);
	
	document.add(tablaEncabezado);
	document.add(tablaEscuela);
	document.add(tablaPresente);
	document.add(tablaAlumno);
	document.add(tablaDirectora);
	
	document.newPage();
	
	//float[] widthsDatos = { 0.2f, 0.8f };//percentage
	tablaDatos = new PdfPTable(1);
	tablaDatos.getDefaultCell().setBorder(Rectangle.NO_BORDER);
	
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("DATOS PERSONALES:", fonts[3]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("DOMICILIO:", fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("     " + domicilio, fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("TELEFONO:", fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("     " + telefono, fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("TIPO DE SANGRE:", fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("     " + tipoSangre, fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("ALERGIAS:", fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("     " + alergias, fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("EN CASO DE EMERGENCIA LLAMAR A:", fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("     " + emergencia, fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("VIGENCIA:", fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	
	cell = new PdfPCell(new Paragraph("     " + vigencia, fonts[5]));
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_LEFT);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	

	
	tablaDatos.addCell("");
	tablaDatos.addCell("");

	
	tablaDatos.addCell("");
	tablaDatos.addCell("");
	
	cell = new PdfPCell(codigoBarras);
	cell.setBorderWidthLeft(0.0f);
	cell.setBorderWidthBottom(0.0f);
	cell.setBorderWidthTop(0.0f);
	cell.setBorderWidthRight(0.0f);
	cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	cell.setPaddingTop(1);
	tablaDatos.addCell(cell);
	
	
	
	document.add(tablaDatos);
	
	document.close();

	eDB.setCerrarConexion();
%>