package Objetos;

public class MexReqProductos {

	private String id = "";
	private String IdRequerimientos = "";
	private String Cantidad = "";
	private String Producto = "";
	private String Unidad = "";
	private String Precio = "";
	private String Estatus = "";
	private String IdOrdenCompra = "";
	private String Iva = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public MexReqProductos() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdRequerimientos(String idrequerimientos) {
		this.IdRequerimientos = idrequerimientos;
	}

	public String getIdRequerimientos() {
		return this.IdRequerimientos;
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

	public void setEstatus(String estatus) {
		this.Estatus = estatus;
	}

	public String getEstatus() {
		return this.Estatus;
	}

	public void setIdOrdenCompra(String idordencompra) {
		this.IdOrdenCompra = idordencompra;
	}

	public String getIdOrdenCompra() {
		return this.IdOrdenCompra;
	}
	
	public String getIva() {
		return Iva;
	}

	public void setIva(String iva) {
		Iva = iva;
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
//MexReqProductos

