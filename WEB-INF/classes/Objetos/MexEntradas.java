package Objetos;

public class MexEntradas {

	private String id = "";
	private String IdReqProductos = "";
	private String Fecha = "";
	private String Cantidad = "";
	private String Producto = "";
	private String Unidad = "";
	private String Precio = "";
	private String Importe = "";
	private String Ubicacion = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public MexEntradas() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdReqProductos(String idreqproductos) {
		this.IdReqProductos = idreqproductos;
	}

	public String getIdReqProductos() {
		return this.IdReqProductos;
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

	public void setPrecio(String precio) {
		this.Precio = precio;
	}

	public String getPrecio() {
		return this.Precio;
	}

	public void setImporte(String importe) {
		this.Importe = importe;
	}

	public String getImporte() {
		return this.Importe;
	}

	public void setUbicacion(String ubicacion) {
		this.Ubicacion = ubicacion;
	}

	public String getUbicacion() {
		return this.Ubicacion;
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
//MexEntradas

