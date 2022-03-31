<%@ page import="Libreria.Pdf" %>
<%@ page import="Configuraciones.Generales" %>
<%@ page import="Libreria.MysqlPool" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Utilerias.Cantidades" %>
<%@ page import="com.lowagie.text.DocumentException" %>
<%@ page import="com.lowagie.text.Element" %>
<%@ page import="com.lowagie.text.Image" %>
<%@ page import="com.lowagie.text.Rectangle" %>
<%@ page import="com.lowagie.text.pdf.PdfPTable" %>
<%
	Generales generales = new Generales();
	MysqlPool eDB = new MysqlPool();
	MysqlPool eDB2 = new MysqlPool();
	
	eDB.setConexion();
	
	ResultSet datos = eDB.getQuery("select * from SolicitudViaticos where Id = '" + request.getParameter("Id") + "'");
	while(datos.next()) {
	
		eDB2.setConexion();
		response.setHeader("Content-Disposition", "attachment; filename=SolicitudViaticosAdmon_" + request.getParameter("Id") + ".pdf");
		Pdf pdf = new Pdf(false,response);
		pdf.setFondo(255, 255, 255);
		
		PdfPTable encabezado = new PdfPTable(3);
		encabezado.setWidthPercentage(80);	
		
		String ruta = generales.getUrlLogout() + "imagenes/201609_MCS_Grupo_Azul.png";
		System.out.println(ruta);
		Image imagen = Image.getInstance(ruta);
		imagen.scalePercent(8);
		imagen.setBorder(Rectangle.NO_BORDER);
		
		pdf.setCeldaVacia(encabezado, 3);
		pdf.setCeldaVacia(encabezado, 3);
		pdf.setCeldaVacia(encabezado, 3);
		
		pdf.setCeldaImagen(encabezado, imagen, 0, 3, Pdf.Izquierda , Pdf.Arriba, Pdf.NoBorder, false);
		pdf.setCeldaVacia(encabezado,1);
		pdf.setCeldaTitulo(encabezado,"SOLICITUD DE VIATICOS");
		
		pdf.setCeldaVacia(encabezado,2);
		pdf.setCeldaSubtitulo(encabezado, "FOLIO: " + datos.getString("Id"));
		
		pdf.setCeldaVacia(encabezado, 3);
		pdf.setCeldaVacia(encabezado, 3);
		pdf.setCeldaVacia(encabezado, 3);
		
		pdf.setTabla(encabezado);
		
		
		PdfPTable contenido = new PdfPTable(2);
		contenido.setWidthPercentage(80);
		float[] anchos = {20,80};
		contenido.setWidths(anchos);
		
		pdf.setCeldaNegrita(contenido, "Nombre:");
		pdf.setCelda(contenido, datos.getString("Nombre"));
		
		pdf.setCeldaNegrita(contenido, "Puesto:");
		pdf.setCelda(contenido, datos.getString("Puesto"));
		
		pdf.setCeldaNegrita(contenido, "Facturar A:");
		
		PdfPTable facturarA = new PdfPTable(2);
		facturarA.setWidths(anchos);
		
		ResultSet datos2 = eDB2.getQuery("select * from Emisor where Rfc = '" + datos.getString("FacturarA") + "'");
		while(datos2.next()) {
			pdf.setCelda(facturarA, datos2.getString("RazonSocial"), 2, 1, Pdf.Izquierda, Pdf.Arriba, Pdf.NoBorder, Pdf.Normal, false, false);
			pdf.setCeldaNegrita(facturarA, "RFC:");
			pdf.setCelda(facturarA, datos2.getString("Rfc"));
			pdf.setCeldaNegrita(facturarA, "Calle:");
			pdf.setCelda(facturarA, datos2.getString("Calle"));
			pdf.setCeldaNegrita(facturarA, "No Exterior:");
			pdf.setCelda(facturarA, datos2.getString("NoExterior"));
			pdf.setCeldaNegrita(facturarA, "No Interior:");
			pdf.setCelda(facturarA, datos2.getString("NoInterior"));
			pdf.setCeldaNegrita(facturarA, "Codigo Postal:");
			pdf.setCelda(facturarA, datos2.getString("CodigoPostal"));
			pdf.setCeldaNegrita(facturarA, "Colonia:");
			pdf.setCelda(facturarA, datos2.getString("Colonia"));
			pdf.setCeldaNegrita(facturarA, "Localidad:");
			pdf.setCelda(facturarA, datos2.getString("Localidad"));
			pdf.setCeldaNegrita(facturarA, "Municipio:");
			pdf.setCelda(facturarA, datos2.getString("Municipio"));
			pdf.setCeldaNegrita(facturarA, "Estado:");
			pdf.setCelda(facturarA, datos2.getString("Estado"));
			pdf.setCeldaNegrita(facturarA, "Pais:");
			pdf.setCelda(facturarA, datos2.getString("Pais"));
		}
		pdf.setCeldaTabla(contenido, facturarA, 1, 1, Pdf.Izquierda, Pdf.Arriba, Pdf.NoBorder, false);
		
		
		pdf.setCeldaNegrita(contenido, "Viaje Desde:");
		pdf.setCelda(contenido, datos.getString("ViajeDesde"));
		
		pdf.setCeldaNegrita(contenido, "Viaje Hasta:");
		pdf.setCelda(contenido, datos.getString("ViajeHasta"));
		
		pdf.setCeldaNegrita(contenido, "Motivo:");
		pdf.setCelda(contenido, datos.getString("Motivo"));
		
		pdf.setCeldaNegrita(contenido, "Itinerario:");
		pdf.setCelda(contenido, datos.getString("Itinerario"));
		
		pdf.setCeldaNegrita(contenido, "Autorizó:");
		
		if(datos.getString("Autorizacion").equals("AUTORIZADO")) {
			datos2 = eDB2.getQuery("select Nombre from Usuarios where Id = '" + datos.getString("Gerente") + "'");
			while(datos2.next()) {
				pdf.setCelda(contenido, datos2.getString("Nombre"));
			}
		} else {
			pdf.setCelda(contenido, datos.getString("Autorizacion"));
		}
		
		pdf.setCeldaNegrita(contenido, "1. Hospedaje:");
		pdf.setCelda(contenido, "$ " + Cantidades.formatoMonedaConSinDecimales(datos.getDouble("Hospedaje")));
		
		pdf.setCeldaNegrita(contenido, "2. Alimentos:");
		pdf.setCelda(contenido, "$ " +Cantidades.formatoMonedaConSinDecimales(datos.getDouble("Alimentos")));
		
		pdf.setCeldaNegrita(contenido, "3. Transporte:");
		pdf.setCeldaVacia(contenido, 1);
		
		pdf.setCelda(contenido, "Taxi");
		pdf.setCelda(contenido, "$ " + Cantidades.formatoMonedaConSinDecimales(datos.getDouble("Taxi")));
		
		pdf.setCelda(contenido, "RentaAutomovil");
		pdf.setCelda(contenido, "$ " + Cantidades.formatoMonedaConSinDecimales(datos.getDouble("RentaAutomovil")));
		
		pdf.setCelda(contenido, "Avion");
		pdf.setCelda(contenido, "$ " + Cantidades.formatoMonedaConSinDecimales(datos.getDouble("Avion")));
		
		pdf.setCeldaVacia(contenido, 1);
		pdf.setCelda(contenido, "$ " + Cantidades.formatoMonedaConSinDecimales(datos.getDouble("Transporte")));
		
		pdf.setCeldaNegrita(contenido, "TOTAL");
		pdf.setCeldaNegrita(contenido, "$ " + Cantidades.formatoMonedaConSinDecimales(datos.getDouble("Total")));
		
		pdf.setTabla(contenido);
		
		pdf.setCerrar();
		eDB2.setCerrarConexion();
	}
	eDB.setCerrarConexion();
%>