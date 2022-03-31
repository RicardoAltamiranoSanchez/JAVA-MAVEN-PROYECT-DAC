package Objetos;

public class MexEmpresasAreas {

	private String id = "";
	private String Area = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public MexEmpresasAreas() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setArea(String area) {
		this.Area = area;
	}

	public String getArea() {
		return this.Area;
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
//MexEmpresasAreas

