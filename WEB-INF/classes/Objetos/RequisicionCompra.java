package Objetos;

public class RequisicionCompra {

	private int id = 0;
	private String Fecha = "";
	private String Nombre = "";
	private String Area = "";
	private String Cantidad = "";
	private String Descripcion = "";
	private String IdGerente = "";
	private String AutorizacionDirector = "";
	private String AutorizacionFinanzas = "";
	private String Estatus = "";
	private String Motivo = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public RequisicionCompra() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setNombre(String nombre) {
		this.Nombre = nombre;
	}

	public String getNombre() {
		return this.Nombre;
	}

	public void setArea(String area) {
		this.Area = area;
	}

	public String getArea() {
		return this.Area;
	}

	public void setCantidad(String cantidad) {
		this.Cantidad = cantidad;
	}

	public String getCantidad() {
		return this.Cantidad;
	}

	public void setDescripcion(String descripcion) {
		this.Descripcion = descripcion;
	}

	public String getDescripcion() {
		return this.Descripcion;
	}
	
	public void setIdGerente(String idgerente){
		this.IdGerente = idgerente;
	}

	public String getIdGerente(){
		return this.IdGerente;
	}

	public void setAutorizacionDirector(String autorizaciondirector) {
		this.AutorizacionDirector = autorizaciondirector;
	}

	public String getAutorizacionDirector() {
		return this.AutorizacionDirector;
	}

	public void setAutorizacionFinanzas(String autorizacionfinanzas) {
		this.AutorizacionFinanzas = autorizacionfinanzas;
	}

	public String getAutorizacionFinanzas() {
		return this.AutorizacionFinanzas;
	}

	public void setEstatus(String estatus) {
		this.Estatus = estatus;
	}

	public String getEstatus() {
		return this.Estatus;
	}
	
	public void setMotivo(String motivo){
		this.Motivo = motivo;
	}
	
	public String getMotivo(){
		return this.Motivo;
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
}