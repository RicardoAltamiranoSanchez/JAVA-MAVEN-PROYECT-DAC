package Objetos;

public class MexReqPagos {

	private String id = "";
	private String IdRequerimientos = "";
	private String Archivo = "";
	private String Nombre = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public MexReqPagos() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdRequerimientos(String idrequerimientos) {
		this.IdRequerimientos = idrequerimientos;
	}

	public String getIdRequerimientos() {
		return this.IdRequerimientos;
	}

	public void setArchivo(String archivo) {
		this.Archivo = archivo;
	}

	public String getArchivo() {
		return this.Archivo;
	}

	public void setNombre(String nombre) {
		this.Nombre = nombre;
	}

	public String getNombre() {
		return this.Nombre;
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
//MexReqPagos