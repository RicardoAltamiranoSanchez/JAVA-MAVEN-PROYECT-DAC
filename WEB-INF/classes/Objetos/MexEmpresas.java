package Objetos;

public class MexEmpresas {

	private String id = "";
	private String Empresa = "";
	private String Rfc = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public MexEmpresas() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setEmpresa(String empresa) {
		this.Empresa = empresa;
	}

	public String getEmpresa() {
		return this.Empresa;
	}

	public void setRfc(String rfc) {
		this.Rfc = rfc;
	}

	public String getRfc() {
		return this.Rfc;
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
//MexEmpresas

