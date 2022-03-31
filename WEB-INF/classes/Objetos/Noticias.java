package Objetos;

public class Noticias {

	private int id = 0;
	private String Fecha = "";
	private String Titulo = "";
	private String Archivo = "";
	private String Resumen = "";
	private String Noticia = "";
	private String Ocultar = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Noticias() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setTitulo(String titulo) {
		this.Titulo = titulo;
	}

	public String getTitulo() {
		return this.Titulo;
	}

	public void setArchivo(String archivo) {
		this.Archivo = archivo;
	}

	public String getArchivo() {
		return this.Archivo;
	}

	public void setResumen(String resumen) {
		this.Resumen = resumen;
	}

	public String getResumen() {
		return this.Resumen;
	}

	public void setNoticia(String noticia) {
		this.Noticia = noticia;
	}

	public String getNoticia() {
		return this.Noticia;
	}

	public void setOcultar(String ocultar) {
		this.Ocultar = ocultar;
	}

	public String getOcultar() {
		return this.Ocultar;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getValue() {
		return this.value;
	}

	public void setLog(String log) {
		this.log = log;
	}

	public String getLog() {
		return this.log;
	}

	public void setError(boolean error) {
		this.error = error;
	}
	
	public boolean getError() {
		return this.error;
	}
}
