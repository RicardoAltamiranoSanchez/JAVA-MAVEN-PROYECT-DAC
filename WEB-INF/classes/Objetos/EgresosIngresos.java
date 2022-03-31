package Objetos;

public class EgresosIngresos {

	private String id = "";
	private String IdUsuario = "";
	private String Fecha = "";
	private String IdCuentas = "";
	private String Concepto = "";
	private String Importe = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public EgresosIngresos() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdUsuario(String idusuario) {
		this.IdUsuario = idusuario;
	}

	public String getIdUsuario() {
		return this.IdUsuario;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setIdCuentas(String idcuentas) {
		this.IdCuentas = idcuentas;
	}

	public String getIdCuentas() {
		return this.IdCuentas;
	}

	public void setConcepto(String concepto) {
		this.Concepto = concepto;
	}

	public String getConcepto() {
		return this.Concepto;
	}

	public void setImporte(String importe) {
		this.Importe = importe;
	}

	public String getImporte() {
		return this.Importe;
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
//EgresosIngresos