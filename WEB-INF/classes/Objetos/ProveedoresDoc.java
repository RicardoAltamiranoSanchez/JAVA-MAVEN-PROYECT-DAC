package Objetos;

public class ProveedoresDoc {

	private String id = "";
	private String IdProveedores = "";
	private String Documento = "";
	private String Archivo = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public ProveedoresDoc() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdProveedores(String idproveedores) {
		this.IdProveedores = idproveedores;
	}

	public String getIdProveedores() {
		return this.IdProveedores;
	}

	public void setDocumento(String documento) {
		this.Documento = documento;
	}

	public String getDocumento() {
		return this.Documento;
	}

	public void setArchivo(String archivo) {
		this.Archivo = archivo;
	}

	public String getArchivo() {
		return this.Archivo;
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
//MexProveedoresDoc