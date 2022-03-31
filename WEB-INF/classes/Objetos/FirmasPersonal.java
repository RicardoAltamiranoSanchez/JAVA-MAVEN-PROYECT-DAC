package Objetos;

public class FirmasPersonal {

	private int id = 0;
	private String IdFirmas = "";
	private String IdEmpleados = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public FirmasPersonal() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setIdFirmas(String idfirmas) {
		this.IdFirmas = idfirmas;
	}

	public String getIdFirmas() {
		return this.IdFirmas;
	}

	public void setIdEmpleados(String idempleados) {
		this.IdEmpleados = idempleados;
	}

	public String getIdEmpleados() {
		return this.IdEmpleados;
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
