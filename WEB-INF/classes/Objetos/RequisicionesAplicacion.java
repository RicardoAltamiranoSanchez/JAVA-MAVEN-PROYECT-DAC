package Objetos;

public class RequisicionesAplicacion {

	private String id = "";
	private String IdRequisiciones = "";
	private String Requisiciones = "";
	private String IdCentroCostos = "";
	private String CentroCostos = "";
	private String IdCuentas = "";
	private String Cuentas = "";
	private String Importe = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public RequisicionesAplicacion() {

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

	public void setRequisiciones(String requisiciones) {
		this.Requisiciones = requisiciones;
	}

	public String getRequisiciones() {
		return this.Requisiciones;
	}

	public void setIdCentroCostos(String idcentrocostos) {
		this.IdCentroCostos = idcentrocostos;
	}

	public String getIdCentroCostos() {
		return this.IdCentroCostos;
	}

	public void setCentroCostos(String centrocostos) {
		this.CentroCostos = centrocostos;
	}

	public String getCentroCostos() {
		return this.CentroCostos;
	}

	public void setIdCuentas(String idcuentas) {
		this.IdCuentas = idcuentas;
	}

	public String getIdCuentas() {
		return this.IdCuentas;
	}

	public void setCuentas(String cuentas) {
		this.Cuentas = cuentas;
	}

	public String getCuentas() {
		return this.Cuentas;
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
//RequisicionesAplicacionObjeto

