package Objetos;

public class MktArchivos {

	private String id = "";
	private String Archivo = "";
	private String IdMktTipoArchivo = "";
	private String VistaPrevia = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public MktArchivos() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setArchivo(String archivo) {
		this.Archivo = archivo;
	}

	public String getArchivo() {
		return this.Archivo;
	}

	public void setIdMktTipoArchivo(String idmkttipoarchivo) {
		this.IdMktTipoArchivo = idmkttipoarchivo;
	}

	public String getIdMktTipoArchivo() {
		return this.IdMktTipoArchivo;
	}

	public void setVistaPrevia(String vistaprevia) {
		this.VistaPrevia = vistaprevia;
	}

	public String getVistaPrevia() {
		return this.VistaPrevia;
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