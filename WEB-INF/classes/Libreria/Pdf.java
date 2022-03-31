package Libreria;

import java.awt.Color;
import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

public class Pdf {
	
	private Color baseColor;
	private Document documento;
	
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
	
	public Pdf(boolean landscape,HttpServletResponse response) throws DocumentException, IOException {
		response.setContentType(getTipoDocumento());
		this.documento = new Document(PageSize.LETTER);
		if(landscape) {
			documento = new Document(PageSize.LETTER.rotate());
		}
		PdfWriter.getInstance(documento, response.getOutputStream());
		documento.setMargins(0,0,0,0);
		this.documento.open();
	}
	
	public void setPagina() {
		this.documento.newPage();
	}
	
	public void setFondo(int r, int g, int b) {
		baseColor = new Color(r,g,b);
	}
	
	public void setTabla(PdfPTable tabla) throws DocumentException {
		this.documento.add(tabla);
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
	public void setCelda(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Normal",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        tabla.addCell(celda);
	}
	public void setCeldaJustificado(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Normal",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        celda.setHorizontalAlignment(Justificado);
        tabla.addCell(celda);
	}
	public void setCeldaNegrita(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Negrita",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        tabla.addCell(celda);
	}
	public void setCeldaNegritaCentrado(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Negrita",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setHorizontalAlignment(Centrado);
        celda.setBorder(NoBorder);
        tabla.addCell(celda);
	}
	public void setCeldaNegritaJustificado(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Negrita",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setHorizontalAlignment(Justificado);
        celda.setBorder(NoBorder);
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
	public void setCeldaTitulo(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Titulo",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        celda.setHorizontalAlignment(Centrado);
        tabla.addCell(celda);
	}
	public void setCeldaSubtitulo(PdfPTable tabla, String mensaje){
		Paragraph parrafo = new Paragraph();
		parrafo.add(new Chunk(mensaje,getFuente("Subtitulo",false)));
        PdfPCell celda = new PdfPCell(parrafo);
        celda.setBorder(NoBorder);
        celda.setHorizontalAlignment(Centrado);
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
	
	public String getTipoDocumento() {
		return "application/pdf";
	}
	
	private Color getColor() {
		return this.baseColor;
	}
	private Font getFuente(String tipo, boolean color) {
		Font fuente = new Font(Font.HELVETICA, 8, Font.NORMAL);
		if(tipo.equals("Negrita")) {
			fuente = (color)?new Font(Font.HELVETICA,8,Font.BOLD,getColor()):new Font(Font.HELVETICA,8,Font.BOLD);
		} else if(tipo.equals("Titulo")) {
			fuente = (color)?new Font(Font.HELVETICA,14,Font.BOLD,getColor()):new Font(Font.HELVETICA,14,Font.BOLD);
		} else if(tipo.equals("Subtitulo")) {
			fuente = (color)?new Font(Font.HELVETICA,11,Font.BOLD,getColor()):new Font(Font.HELVETICA,11,Font.BOLD);
		}
		return fuente;
	}
}
