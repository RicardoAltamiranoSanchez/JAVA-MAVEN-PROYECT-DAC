package Objetos;

public class RequisicionesPara {

	private String id = "";
	private String IdUsuarios = "";
	private String Usuarios = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public RequisicionesPara() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdUsuarios(String idusuarios) {
		this.IdUsuarios = idusuarios;
	}

	public String getIdUsuarios() {
		return this.IdUsuarios;
	}

	public void setUsuarios(String usuarios) {
		this.Usuarios = usuarios;
	}

	public String getUsuarios() {
		return this.Usuarios;
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
//RequisicionesParaObjeto

