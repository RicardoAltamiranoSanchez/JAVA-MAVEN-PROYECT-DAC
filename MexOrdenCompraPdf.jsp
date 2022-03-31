<%@page import="java.io.StringReader" %>
<%@page import="java.util.Properties" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.SQLException" %>
<%@page import="Configuraciones.Generales" %>
<%@page import="Libreria.Pdf5" %>
<%@page import="Libreria.MysqlPool" %>
<%@page import="com.itextpdf.text.DocumentException" %>
<%@page import="com.itextpdf.text.Element" %>
<%@page import="com.itextpdf.text.Image" %>
<%@page import="com.itextpdf.text.Rectangle" %>
<%@page import="com.itextpdf.text.Paragraph" %>
<%@page import="com.itextpdf.text.Chunk" %>
<%@page import="com.itextpdf.text.pdf.PdfPTable" %>
<%@page import="com.itextpdf.text.pdf.PdfPCell" %>
<%
MysqlPool eDB = new MysqlPool();
Pdf5 pdf = new Pdf5(false,response);
Generales generales = new Generales();

eDB.setConexion();
pdf.setFondo(255, 255, 255);

// encabezado
PdfPTable encabezado = new PdfPTable(2);
encabezado.setWidthPercentage(85);
float[] anchos = {0.80f,0.20f};
encabezado.setWidths(anchos);

String titulo = "ORDEN DE COMPRA " + request.getParameter("Id");

String ruta = generales.getUrlLogout() + "imagenes/";
Image imagen = Image.getInstance(ruta + "201609_MCS_Grupo_Azul.png");
imagen.setAlignment(Element.ALIGN_CENTER);
imagen.setBorder(Rectangle.NO_BORDER);
imagen.scaleAbsoluteWidth(132);
imagen.scaleAbsoluteHeight(40);

pdf.setCeldaVacia(encabezado,2);
pdf.setCeldaSubtitulo(encabezado,titulo);
pdf.setCeldaImagen(encabezado, imagen, 1, 1, Pdf5.Derecha , Pdf5.Arriba, Pdf5.NoBorder, false);
pdf.setCeldaVacia(encabezado,2);
pdf.setCeldaVacia(encabezado,2);
pdf.setTabla(encabezado);

PdfPTable tabla = new PdfPTable(2);
tabla.setWidthPercentage(85);
float[] anchosTabla = {0.30f,0.70f};
tabla.setWidths(anchosTabla);

/* ResultSet datos = eDB.getQuery("select R.Id, R.Fecha, P.Nombre, P.Rfc as RfcProveedor, R.FormaPago, R.InstruccionesPago," + 
	"P.Ciudad, P.Estado, P.Telefono, E.Empresa, E.Rfc, A.Area, U.Unidad " + 
	"from MexRequerimientos R, MexProveedores P, MexEmpresas E, MexEmpresasAreas A, MexEmpresasUnidades U " + 
	"where R.Id = '" + request.getParameter("Id") + "' and P.Id = R.IdPRoveedores and E.Id = R.IdEmpresas and A.Id = R.IdAreas and U.Id = R.IdUnidades"); */
	
ResultSet datos = eDB.getQuery("SELECT R.Id, R.Fecha, P.Nombre, P.Rfc AS RfcProveedor, R.FormaPago, R.InstruccionesPago, P.Ciudad, P.Estado, P.Telefono, E.Empresa, E.Rfc, A.Area, U.Unidad " +
		"FROM MexProveedores P, MexEmpresas E, MexEmpresasAreas A, MexRequerimientos R " +
		"LEFT JOIN MexEmpresasUnidades U ON ( U.Id = R.IdUnidades ) " +
		"WHERE R.Id = '" + request.getParameter("Id") + "' " +
		"AND P.Id = R.IdPRoveedores " +
		"AND E.Id = R.IdEmpresas " +
		"AND A.Id = R.IdAreas");
	
while(datos.next()) {
	pdf.setCeldaNegrita(tabla, "Orden Compra:");
	pdf.setCelda(tabla, datos.getString("Id"));
	pdf.setCeldaNegrita(tabla, "Fecha:");
	pdf.setCelda(tabla, datos.getString("Fecha"));
	pdf.setCeldaNegrita(tabla, "Empresa:");
	pdf.setCelda(tabla, datos.getString("Empresa"));
	pdf.setCeldaNegrita(tabla, "RFC:");
	pdf.setCelda(tabla, datos.getString("Rfc"));
	pdf.setCeldaNegrita(tabla, "Area:");
	pdf.setCelda(tabla, datos.getString("Area"));
	pdf.setCeldaNegrita(tabla, "SubArea:");
	if (datos.getString("Unidad") == null){
		pdf.setCelda(tabla, "SIN SUBAREA");
	}else {
		pdf.setCelda(tabla, datos.getString("Unidad"));	
	}
	
	
	pdf.setCeldaVacia(tabla,2);
	pdf.setCeldaNegrita(tabla, "Proveedor:");
	pdf.setCelda(tabla, datos.getString("Nombre"));
	pdf.setCeldaNegrita(tabla, "RFC:");
	pdf.setCelda(tabla, datos.getString("RfcProveedor"));
	pdf.setCeldaNegrita(tabla, "Ciudad:");
	pdf.setCelda(tabla, datos.getString("Ciudad"));
	pdf.setCeldaNegrita(tabla, "Estado:");
	pdf.setCelda(tabla, datos.getString("Estado"));
	pdf.setCeldaNegrita(tabla, "Telefono:");
	pdf.setCelda(tabla, datos.getString("Telefono"));
	
	pdf.setCeldaVacia(tabla,2);
	pdf.setCeldaNegrita(tabla, "Forma de Pago:");
	pdf.setCelda(tabla, datos.getString("FormaPago"));
	pdf.setCeldaNegrita(tabla, "Instrucciones de Pago:");
	pdf.setCelda(tabla, datos.getString("InstruccionesPago"));
	
	pdf.setCeldaVacia(tabla,2);
}
pdf.setTabla(tabla);

PdfPTable productos = new PdfPTable(6);
productos.setWidthPercentage(85);
float[] anchosProductos = {0.15f,0.40f,0.15f,0.10f,0.05f,0.15f};
productos.setWidths(anchosProductos);

pdf.setCeldaNegrita(productos, "Cantidad");
pdf.setCeldaNegrita(productos, "Producto");
pdf.setCeldaNegrita(productos, "Unidad");
pdf.setCeldaNegrita(productos, "P.Unitario");
pdf.setCeldaNegrita(productos, "Iva");
pdf.setCeldaNegrita(productos, "Importe");

datos = eDB.getQuery("select *, format(Cantidad * Precio,2) as Importe from MexReqProductos where IdRequerimientos = '" + request.getParameter("Id") + "'");

while(datos.next()) {
	pdf.setCelda(productos, datos.getString("Cantidad"));
	pdf.setCelda(productos, datos.getString("Producto"));
	if (datos.getString("Unidad") == null){
		pdf.setCelda(productos, "SIN SUBAREA");
	}else {
		pdf.setCelda(productos, datos.getString("Unidad"));	
	}
	pdf.setCeldaNumero(productos, datos.getString("Precio"));
	pdf.setCeldaNumero(productos, datos.getString("Iva"));
	pdf.setCeldaNumero(productos, datos.getString("Importe"));
}

datos = eDB.getQuery("select format(sum(Cantidad * Precio),2) as Subtotal, format(sum(Cantidad * Precio * (Iva/100)),2) as Iva, format(sum(Cantidad * Precio * (1 + (Iva/100))),2) as Total from MexReqProductos where IdRequerimientos = '" + request.getParameter("Id") + "'");
while(datos.next()) {

	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegritaNumero(productos, "Subtotal");
	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegritaNumero(productos, datos.getString("Subtotal"));

	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegritaNumero(productos, "IVA");
	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegritaNumero(productos, datos.getString("Iva"));

	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegritaNumero(productos, "Total");
	pdf.setCeldaNegrita(productos, "");
	pdf.setCeldaNegritaNumero(productos, datos.getString("Total"));
	
}

pdf.setTabla(productos);

eDB.setCerrarConexion();
pdf.setCerrar();
%>