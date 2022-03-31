package Objetos;

public class OrdenesCompraConceptos {

	private int id = 0;
	private String Llave = "";
	private String Articulo = "";
	private String Cantidad = "";
	private String Unidad = "";
	private String Precio = "";
	private String Importe = "";
	private String PorIva = "";
	private String Iva = "";
	private String IvaRetenido = "";
	private String IsrRetenido = "";
	private String Total = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public OrdenesCompraConceptos() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setLlave(String llave) {
		this.Llave = llave;
	}

	public String getLlave() {
		return this.Llave;
	}

	public void setArticulo(String articulo) {
		this.Articulo = articulo;
	}

	public String getArticulo() {
		return this.Articulo;
	}

	public void setCantidad(String cantidad) {
		this.Cantidad = cantidad;
	}

	public String getCantidad() {
		return this.Cantidad;
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

	public void setPorIva(String poriva) {
		this.PorIva = poriva;
	}

	public String getPorIva() {
		return this.PorIva;
	}

	public void setIva(String iva) {
		this.Iva = iva;
	}

	public String getIva() {
		return this.Iva;
	}

	public void setIvaRetenido(String ivaretenido) {
		this.IvaRetenido = ivaretenido;
	}

	public String getIvaRetenido() {
		return this.IvaRetenido;
	}

	public void setIsrRetenido(String isrretenido) {
		this.IsrRetenido = isrretenido;
	}

	public String getIsrRetenido() {
		return this.IsrRetenido;
	}

	public void setTotal(String total) {
		this.Total = total;
	}

	public String getTotal() {
		return this.Total;
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