package Objetos;

public class MexAplicaciones {

	private String id = "";
	private String Aplicacion = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public MexAplicaciones() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setAplicacion(String aplicacion) {
		this.Aplicacion = aplicacion;
	}

	public String getAplicacion() {
		return this.Aplicacion;
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
//MexAplicaciones

