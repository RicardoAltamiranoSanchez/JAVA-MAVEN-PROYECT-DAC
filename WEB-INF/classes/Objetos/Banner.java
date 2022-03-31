package Objetos;

public class Banner {

	private int id = 0;
	private String Sitio = "";
	private String Posicion = "";
	private String Archivo = "";
	private String Ocultar = "";
	private String Link = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Banner() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setSitio(String sitio) {
		this.Sitio = sitio;
	}

	public String getSitio() {
		return this.Sitio;
	}

	public void setPosicion(String posicion) {
		this.Posicion = posicion;
	}

	public String getPosicion() {
		return this.Posicion;
	}

	public void setArchivo(String archivo) {
		this.Archivo = archivo;
	}

	public String getArchivo() {
		return this.Archivo;
	}

	public void setOcultar(String ocultar) {
		this.Ocultar = ocultar;
	}

	public String getOcultar() {
		return this.Ocultar;
	}
	
	public void setLink(String link) {
		this.Link = link;
	}

	public String getLink() {
		return this.Link;
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
