package Objetos;

public class PresupuestoCuentas {

	private String id = "";
	private String Indice = "";
	private String Tipo = "";
	private String Concepto = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public PresupuestoCuentas() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIndice(String indice) {
		this.Indice = indice;
	}

	public String getIndice() {
		return this.Indice;
	}

	public void setTipo(String tipo) {
		this.Tipo = tipo;
	}

	public String getTipo() {
		return this.Tipo;
	}

	public void setConcepto(String concepto) {
		this.Concepto = concepto;
	}

	public String getConcepto() {
		return this.Concepto;
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
//PresupuestoCuentas