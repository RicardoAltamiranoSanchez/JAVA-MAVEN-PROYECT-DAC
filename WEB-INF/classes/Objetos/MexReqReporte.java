package Objetos;

public class MexReqReporte {

	private String id = "";
	private String IdReq = "";
	private String Fecha = "";
	private String Alias = "";
	private String Cantidad = "";
	private String Producto = "";
	private String Unidad = "";
	private String Precio = "";
	private String Importe = "";
	private String Principal = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public MexReqReporte() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdReq(String idreq) {
		this.IdReq = idreq;
	}

	public String getIdReq() {
		return this.IdReq;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setAlias(String alias) {
		this.Alias = alias;
	}

	public String getAlias() {
		return this.Alias;
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

	public void setPrincipal(String principal) {
		this.Principal = principal;
	}

	public String getPrincipal() {
		return this.Principal;
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
//MexReqReporte

