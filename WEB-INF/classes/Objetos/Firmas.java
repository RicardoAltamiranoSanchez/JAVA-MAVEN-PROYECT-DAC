package Objetos;

public class Firmas {

	private int id = 0;
	private String NombreFirma = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Firmas() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setNombreFirma(String nombrefirma) {
		this.NombreFirma = nombrefirma;
	}

	public String getNombreFirma() {
		return this.NombreFirma;
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
