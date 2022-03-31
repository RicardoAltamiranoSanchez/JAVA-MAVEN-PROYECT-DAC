package Objetos;

public class Sitio {

	private int id = 0;
	private String Sitio = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Sitio() {

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