package Objetos;

public class RequisicionesArchivosPagos {

	private String id = "";
	private String IdRequisiciones = "";
	private String Pago = "";
	private String MontoPago = "";
	private String Archivo = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public RequisicionesArchivosPagos() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdRequisiciones(String idrequisiciones) {
		this.IdRequisiciones = idrequisiciones;
	}

	public String getIdRequisiciones() {
		return this.IdRequisiciones;
	}

	public void setPago(String pago) {
		this.Pago = pago;
	}

	public String getPago() {
		return this.Pago;
	}
	
	public void setMontoPago(String montopago) {
		this.MontoPago = montopago;
	}

	public String getMontoPago() {
		return this.MontoPago;
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
//RequisicionesArchivos

