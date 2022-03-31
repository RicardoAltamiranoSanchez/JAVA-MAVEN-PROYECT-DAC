package Objetos;

public class MexRegistroEntradasAlmacen {

	private String id = "";
	private String Nombre = "";
	private String Gafete = "";
	private String Estatus = "";
	private String FechaHora = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;
	
	private String FechaHoraEntrada = "";
	private String Prefijo = "";
	private String Awb = "";
	private String Observaciones = "";
	private String FechaHoraSalida = "";
	private String TiempoAlmacen = "";
	private String Documentacion = "";
	private String Fila = "";
	private String Recibo = "";

	public MexRegistroEntradasAlmacen() {

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

	public void setGafete(String gafete) {
		this.Gafete = gafete;
	}

	public String getGafete() {
		return this.Gafete;
	}

	public void setEstatus(String estatus) {
		this.Estatus = estatus;
	}

	public String getEstatus() {
		return this.Estatus;
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
	
	
	
	
	public void setFechaHoraEntrada (String fechahoraentrada) {
		this.FechaHoraEntrada = fechahoraentrada;
	}

	public String getFechaHoraEntrada () {
		return this.FechaHoraEntrada ;
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
	
	public void setFechaHoraSalida(String fechahorasalida) {
		this.FechaHoraSalida = fechahorasalida;
	}

	public String getFechaHoraSalida() {
		return this.FechaHoraSalida;
	}
	
	public void setTiempoAlmacen(String tiempoalmacen) {
		this.TiempoAlmacen = tiempoalmacen;
	}

	public String getTiempoAlmacen() {
		return this.TiempoAlmacen;
	}

	public String getDocumentacion() {
		return Documentacion;
	}

	public void setDocumentacion(String documentacion) {
		Documentacion = documentacion;
	}
	
	public String getFila() {
		return Fila;
	}

	public void setFila(String fila) {
		Fila = fila;
	}

	public String getRecibo() {
		return Recibo;
	}

	public void setRecibo(String recibo) {
		Recibo = recibo;
	}	
	
	
}

