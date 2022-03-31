package Objetos;

public class EstatusActivos {

	private int id = 0;
	private String Estado = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public EstatusActivos() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setEstado(String estado) {
		this.Estado = estado;
	}

	public String getEstado() {
		return this.Estado;
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