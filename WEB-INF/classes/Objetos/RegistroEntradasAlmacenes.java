package Objetos;

public class RegistroEntradasAlmacenes {

	private String id = "";
	private String Nombre = "";
	private String Gafete = "";
	private String Estatus = "";
	private String FechaHora = "";
	private String Estacion = "";
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

	public RegistroEntradasAlmacenes() {

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
	
	public void setEstacion(String estacion) {
		this.Estacion = estacion;
	}

	public String getEstacion() {
		return this.Estacion;
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
	
	
	
	
}
//TrainingCursos