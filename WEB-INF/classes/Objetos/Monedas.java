package Objetos;

public class Monedas {

	private String id = "";
	private String Moneda = "";
	private String Clave = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public Monedas() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setMoneda(String moneda) {
		this.Moneda = moneda;
	}

	public String getMoneda() {
		return this.Moneda;
	}

	public void setClave(String clave) {
		this.Clave = clave;
	}

	public String getClave() {
		return this.Clave;
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
	public void setBloquear(boolean bloquear) {
		this.bloquear = bloquear;
	}
	
	public boolean getBloquear() {
		return this.bloquear;
	}
}
//Monedas