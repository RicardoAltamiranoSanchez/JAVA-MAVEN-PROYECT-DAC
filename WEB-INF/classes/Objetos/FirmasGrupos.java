package Objetos;

public class FirmasGrupos {

	private int id = 0;
	private String GrupoEmpleados = "";
	private String Firma = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public FirmasGrupos() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setGrupoEmpleados(String grupoempleados) {
		this.GrupoEmpleados = grupoempleados;
	}

	public String getGrupoEmpleados() {
		return this.GrupoEmpleados;
	}

	public void setFirma(String firma) {
		this.Firma = firma;
	}

	public String getFirma() {
		return this.Firma;
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