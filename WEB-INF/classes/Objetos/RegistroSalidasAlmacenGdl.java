package Objetos;

public class RegistroSalidasAlmacenGdl {

	private String id = "";
	private String IdRegistroEntradasAlmacenGdl = "";
	private String Prefijo = "";
	private String Awb = "";
	private String Observaciones = "";
	private String FechaHora = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public RegistroSalidasAlmacenGdl() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdRegistroEntradasAlmacenGdl(String idregistroentradasalmacengdl) {
		this.IdRegistroEntradasAlmacenGdl = idregistroentradasalmacengdl;
	}

	public String getIdRegistroEntradasAlmacenGdl() {
		return this.IdRegistroEntradasAlmacenGdl;
	}

	public void setPrefijo(String prefijo) {
		this.Prefijo = prefijo;
	}

	public String getPrefijo() {
		return this.Prefijo;
	}

	public void setAwb(String awb) {
		this.Awb = awb;
	}

	public String getAwb() {
		return this.Awb;
	}

	public void setObservaciones(String observaciones) {
		this.Observaciones = observaciones;
	}

	public String getObservaciones() {
		return this.Observaciones;
	}
	
	public void setFechaHora(String fechahora) {
		this.FechaHora = fechahora;
	}

	public String getFechaHora() {
		return this.FechaHora;
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

