package Objetos;

public class MexSalidas {

	private String id = "";
	private String IdEntradas = "";
	private String Fecha = "";
	private String Cantidad = "";
	private String Producto = "";
	private String Unidad = "";
	private String Aplicacion = "";
	private String Comentarios = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public MexSalidas() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdEntradas(String identradas) {
		this.IdEntradas = identradas;
	}

	public String getIdEntradas() {
		return this.IdEntradas;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setCantidad(String cantidad) {
		this.Cantidad = cantidad;
	}

	public String getCantidad() {
		return this.Cantidad;
	}

	public void setProducto(String producto) {
		this.Producto = producto;
	}

	public String getProducto() {
		return this.Producto;
	}

	public void setUnidad(String unidad) {
		this.Unidad = unidad;
	}

	public String getUnidad() {
		return this.Unidad;
	}

	public void setAplicacion(String aplicacion) {
		this.Aplicacion = aplicacion;
	}

	public String getAplicacion() {
		return this.Aplicacion;
	}

	public void setComentarios(String comentarios) {
		this.Comentarios = comentarios;
	}

	public String getComentarios() {
		return this.Comentarios;
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
//MexSalidas

