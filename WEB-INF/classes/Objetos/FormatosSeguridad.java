package Objetos;

public class FormatosSeguridad {

	private String id = "";
	private String Codigo = "";
	private String Nombre = "";
	private String NumRevision = "";
	private String FechaRevision = "";
	private String Archivo = "";
	private String IdsUsuariosLectura = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public FormatosSeguridad() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setCodigo(String codigo) {
		this.Codigo = codigo;
	}

	public String getCodigo() {
		return this.Codigo;
	}

	public void setNombre(String nombre) {
		this.Nombre = nombre;
	}

	public String getNombre() {
		return this.Nombre;
	}
	
	public void setNumRevision(String numRevision) {
		this.NumRevision = numRevision;
	}

	public String getNumRevision() {
		return this.NumRevision;
	}
	
	public void setFechaRevision(String fechaRevision) {
		this.FechaRevision = fechaRevision;
	}

	public String getFechaRevision() {
		return this.FechaRevision;
	}
	
	public void setArchivo(String archivo) {
		this.Archivo = archivo;
	}

	public String getArchivo() {
		return this.Archivo;
	}
	
	public void setIdsUsuariosLectura(String idsUsuariosLectura) {
		this.IdsUsuariosLectura = idsUsuariosLectura;
	}

	public String getIdsUsuariosLectura() {
		return this.IdsUsuariosLectura;
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
//MktArchivos