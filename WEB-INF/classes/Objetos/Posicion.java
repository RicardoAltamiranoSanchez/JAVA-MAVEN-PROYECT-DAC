package Objetos;

public class Posicion {

	private int id = 0;
	private String Posicion = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Posicion() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setPosicion(String posicion) {
		this.Posicion = posicion;
	}

	public String getPosicion() {
		return this.Posicion;
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