package Objetos;

public class VacacionesDias {

	private int id = 0;
	private String IdUsuario = "";
	private String Dias = "";
	private String Llave = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public VacacionesDias() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setIdUsuario(String idusuario) {
		this.IdUsuario = idusuario;
	}

	public String getIdUsuario() {
		return this.IdUsuario;
	}

	public void setDias(String dias) {
		this.Dias = dias;
	}

	public String getDias() {
		return this.Dias;
	}

	public void setLlave(String llave) {
		this.Llave = llave;
	}

	public String getLlave() {
		return this.Llave;
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
