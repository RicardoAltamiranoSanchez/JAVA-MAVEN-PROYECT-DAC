package Objetos;

public class TrainingCursos {

	private String id = "";
	private String Nombre = "";
	private String Tipo = "";
	private String DiasNotificacion = "";
	private String DiasVigencia = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public TrainingCursos() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setNombre(String nombre) {
		this.Nombre = nombre;
	}

	public String getNombre() {
		return this.Nombre;
	}

	public void setTipo(String tipo) {
		this.Tipo = tipo;
	}

	public String getTipo() {
		return this.Tipo;
	}

	public void setDiasNotificacion(String diasnotificacion) {
		this.DiasNotificacion = diasnotificacion;
	}

	public String getDiasNotificacion() {
		return this.DiasNotificacion;
	}

	public void setDiasVigencia(String diasvigencia) {
		this.DiasVigencia = diasvigencia;
	}

	public String getDiasVigencia() {
		return this.DiasVigencia;
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
//TrainingCursos

