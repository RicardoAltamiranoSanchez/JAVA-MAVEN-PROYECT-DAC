package Libreria;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

public class Pdf5 {
	
	private BaseColor baseColor;
	private Document documento;
	private PdfWriter pdfWriter;
	
	public static int NoBorder = Rectangle.NO_BORDER;
	public static int BorderCompleto = Rectangle.BOX;
	public static int BorderSuperior = Rectangle.TOP;
	public static int BorderInferior = Rectangle.BOTTOM;
	public static int BorderIzquierda = Rectangle.LEFT;
	public static int BorderDerecha = Rectangle.RIGHT;
	
	public static int Izquierda = Element.ALIGN_LEFT;
	public static int Derecha = Element.ALIGN_RIGHT;
	public static int Centrado = Element.ALIGN_CENTER;
	public static int Arriba = Element.ALIGN_TOP;
	public static int Enmedio = Element.ALIGN_MIDDLE;
	public static int Abajo = Element.ALIGN_BOTTOM;
	public static int Justificado = Element.ALIGN_JUSTIFIED;
	
	public static String Negrita = "Negrita";
	public static String Titulo = "Titulo";
	public static String Subtitulo = "Subtitulo";
	public static String Normal = "Normal";
	
	public Pdf5(boolean landscape,HttpServletResponse response) throws DocumentException, IOException {
		response.setContentType(getTipoDocumento());
		this.documento = new Document(PageSize.LETTER);
		if(landscape) {
			documento = new Document(PageSize.LETTER.rotate());
		}
		this.pdfWriter = PdfWriter.getInstance(documento, response.getOutputStream());
		documento.setMargins(36,36,36,36);
		this.documento.open();
	}
	
	public Pdf5(boolean landscape, HttpServletResponse response, float[] margenes) throws DocumentException, IOException {
		response.setContentType(getTipoDocumento());
		this.documento = new Document(PageSize.LETTER);
		if(landscape) {
			documento = new Document(PageSize.LETTER.rotate());
		}
		this.pdfWriter = PdfWriter.getInstance(documento, response.getOutputStream());
		documento.setMargins(margenes[0],margenes[1],margenes[2],margenes[3]);
		this.documento.open();
	}
	
	public void setPagina() {
		this.documento.newPage();
	}
	
	public void setFondo(int r, int g, int b) {
		baseColor = new BaseColor(r,g,b);
	}
	
	public void setTabla(PdfPTable tabla) throws DocumentException {
		this.documento.add(tabla);
	}
	
	public void setElemento(Element elemento) throws DocumentException {
		this.documento.add(elemento);
	}
	
	public void setCeldaImagen(PdfPTable tabla, Image imagen, int colspan, int rowspan, int align, int valign, int border, boolean fondo){
		PdfPCell celda = new PdfPCell(imagen);
        celda.setColspan(colspan);
        celda.setRowspan(rowspan);
        celda.setBorder(border);
        celda.setHorizontalAlignment(align);
        celda.setVerticalAlignment(valign);
        if(fondo){celda.setBackgroundColor(getColor());}
        tabla.addCell(celda);
	}
	public void setCeldaVacia(PdfPTable tabla, int colspan){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(" ",getFuente("Normal",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setColspan(colspan);
        celda.setBorder(NoBorder);
        tabla.addCell(celda);
	}
	public void setCeldaVaciaBorde(PdfPTable tabla, int colspan){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(" ",getFuente("Normal",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setColspan(colspan);
        celda.setBorder(BorderCompleto);
        tabla.addCell(celda);
	}
	public void setCelda(PdfPTable tabla, Element elemento) {
		PdfPCell celda = new PdfPCell();
		celda.addElement(elemento);
		celda.setBorder(NoBorder);
		tabla.addCell(celda);
	}
	public void setCelda(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Normal",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        tabla.addCell(celda);
	}
	public void setCelda(PdfPTable tabla, String mensaje, int colspan){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Normal",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setColspan(colspan);
        celda.setBorder(NoBorder);
        tabla.addCell(celda);
	}
	public void setCelda(PdfPTable tabla, String mensaje, int colspan, int rowspan, int align, int valign, int border, int sizeFuente){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje, getFuente(sizeFuente, false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setColspan(colspan);
        celda.setRowspan(rowspan);
        celda.setBorder(border);
        celda.setHorizontalAlignment(align);
        celda.setVerticalAlignment(valign);
        tabla.addCell(celda);
	}
	public void setCelda(PdfPTable tabla, String mensaje, int colspan, int rowspan, int align, int valign, int border, String tipoFuente, boolean fondo, boolean fuenteColor){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje, getFuente(tipoFuente,fuenteColor)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setColspan(colspan);
        celda.setRowspan(rowspan);
        celda.setBorder(border);
        celda.setHorizontalAlignment(align);
        celda.setVerticalAlignment(valign);
        if(fondo){celda.setBackgroundColor(getColor());}
        tabla.addCell(celda);
	}
	public void setCelda(PdfPTable tabla, Paragraph mensaje, int colspan, int rowspan, int align, int valign, int border){
		PdfPCell celda = new PdfPCell(mensaje);
        celda.setColspan(colspan);
        celda.setRowspan(rowspan);
        celda.setBorder(border);
        celda.setHorizontalAlignment(align);
        celda.setVerticalAlignment(valign);
        tabla.addCell(celda);
	}
	public void setCeldaNumero(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Normal",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        celda.setHorizontalAlignment(Derecha);
        tabla.addCell(celda);
	}
	public void setCeldaNegrita(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Negrita",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        tabla.addCell(celda);
	}
	public void setCeldaNegrita(PdfPTable tabla, String mensaje, int colspan){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Negrita",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        celda.setColspan(colspan);
        tabla.addCell(celda);
	}
	public void setCeldaNegrita(PdfPTable tabla, String mensaje, int colspan, int rowspan, int align, int valign, int border, int sizeFuente){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje, getFuenteNegrita(sizeFuente, false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setColspan(colspan);
        celda.setRowspan(rowspan);
        celda.setBorder(border);
        celda.setHorizontalAlignment(align);
        celda.setVerticalAlignment(valign);
        tabla.addCell(celda);
	}
	public void setCeldaNegritaNumero(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Negrita",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        celda.setHorizontalAlignment(Derecha);
        tabla.addCell(celda);
	}
	public void setCeldaEncabezado(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Negrita",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(BorderCompleto);
        celda.setHorizontalAlignment(Centrado);
        celda.setBackgroundColor(getColor());
        tabla.addCell(celda);
	}
	public void setCeldaEncabezado(PdfPTable tabla, String mensaje, int colspan){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Negrita",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setColspan(colspan);
        celda.setBorder(BorderCompleto);
        celda.setHorizontalAlignment(Centrado);
        celda.setBackgroundColor(getColor());
        tabla.addCell(celda);
	}
	public void setCeldaTitulo(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Titulo",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        celda.setHorizontalAlignment(Centrado);
        celda.setVerticalAlignment(Enmedio);
        tabla.addCell(celda);
	}
	public void setCeldaTitulo(PdfPTable tabla, String mensaje, int colspan, int rowspan){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Titulo",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        celda.setHorizontalAlignment(Centrado);
        celda.setVerticalAlignment(Enmedio);
        celda.setColspan(colspan);
        celda.setRowspan(rowspan);
        tabla.addCell(celda);
	}
	public void setCeldaSubtitulo(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Subtitulo",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        celda.setHorizontalAlignment(Centrado);
        celda.setVerticalAlignment(Enmedio);
        tabla.addCell(celda);
	}
	
	public void setCeldaTabla(PdfPTable tabla, PdfPTable subTabla, int colspan, int rowspan, int align, int valign, int border, boolean fondo){
		PdfPCell celda = new PdfPCell(subTabla);
        celda.setColspan(colspan);
        celda.setRowspan(rowspan);
        celda.setBorder(border);
        celda.setHorizontalAlignment(align);
        celda.setVerticalAlignment(valign);
        if(fondo){celda.setBackgroundColor(getColor());}
        tabla.addCell(celda);
	}
	public void setCerrar() throws DocumentException {
		this.documento.close();
	}
	
	public Document getDocumento() {
		return this.documento;
	}
	
	public PdfWriter getPdfWriter() {
		return this.pdfWriter;
	}
	
	public String getTipoDocumento() {
		return "application/pdf";
	}
	
	private BaseColor getColor() {
		return this.baseColor;
	}
	private Font getFuente(String tipo, boolean color) {
		Font fuente = new Font(FontFamily.HELVETICA, 8, Font.NORMAL);
		if(tipo.equals("Negrita")) {
			fuente = (color)?new Font(FontFamily.HELVETICA,8,Font.BOLD,getColor()):new Font(FontFamily.HELVETICA,8,Font.BOLD);
		} else if(tipo.equals("Titulo")) {
			fuente = (color)?new Font(FontFamily.HELVETICA,14,Font.BOLD,getColor()):new Font(FontFamily.HELVETICA,14,Font.BOLD);
		} else if(tipo.equals("Subtitulo")) {
			fuente = (color)?new Font(FontFamily.HELVETICA,11,Font.BOLD,getColor()):new Font(FontFamily.HELVETICA,11,Font.BOLD);
		}
		return fuente;
	}
	public Font getFuente(int size, boolean color) {
		Font fuente = (color)?new Font(FontFamily.HELVETICA,size,Font.NORMAL,getColor()):new Font(FontFamily.HELVETICA,size,Font.NORMAL);
		return fuente;
	}
	public Font getFuenteNegrita(int size, boolean color) {
		Font fuente = (color)?new Font(FontFamily.HELVETICA,size,Font.BOLD,getColor()):new Font(FontFamily.HELVETICA,size,Font.BOLD);
		return fuente;
	}
	public Font getFuenteSubrayado(int size, boolean color) {
		Font fuente = (color)?new Font(FontFamily.HELVETICA,size,Font.UNDERLINE,getColor()):new Font(FontFamily.HELVETICA,size,Font.UNDERLINE);
		return fuente;
	}
	
}
