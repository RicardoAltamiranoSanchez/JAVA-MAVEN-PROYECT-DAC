package Objetos;

public class OrdenesCompra {

	private int id = 0;
	private String Fecha = "";
	private String IdEmpresasGrupo = "";
	private String IdProveedores = "";
	private String FechaEntrega = "";
	private String FechaPago = "";
	private String IdUsuarios = "";
	private String FechaAutorizacion = "";
	private String FechaFinanzas = "";
	private String Subtotal = "";
	private String Iva = "";
	private String IvaRetenido = "";
	private String IsrRetenido = "";
	private String Total = "";
	private String Llave = "";
	private String Factura = "";
	private String XmlFactura = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public OrdenesCompra() {

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

	public void setIdEmpresasGrupo(String idempresasgrupo) {
		this.IdEmpresasGrupo = idempresasgrupo;
	}

	public String getIdEmpresasGrupo() {
		return this.IdEmpresasGrupo;
	}

	public void setIdProveedores(String idproveedores) {
		this.IdProveedores = idproveedores;
	}

	public String getIdProveedores() {
		return this.IdProveedores;
	}

	public void setFechaEntrega(String fechaentrega) {
		this.FechaEntrega = fechaentrega;
	}

	public String getFechaEntrega() {
		return this.FechaEntrega;
	}

	public void setFechaPago(String fechapago) {
		this.FechaPago = fechapago;
	}

	public String getFechaPago() {
		return this.FechaPago;
	}

	public void setIdUsuarios(String idusuarios) {
		this.IdUsuarios = idusuarios;
	}

	public String getIdUsuarios() {
		return this.IdUsuarios;
	}

	public void setFechaAutorizacion(String fechaautorizacion) {
		this.FechaAutorizacion = fechaautorizacion;
	}

	public String getFechaAutorizacion() {
		return this.FechaAutorizacion;
	}

	public void setFechaFinanzas(String fechafinanzas) {
		this.FechaFinanzas = fechafinanzas;
	}

	public String getFechaFinanzas() {
		return this.FechaFinanzas;
	}

	public void setSubtotal(String subtotal) {
		this.Subtotal = subtotal;
	}

	public String getSubtotal() {
		return this.Subtotal;
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

	public void setLlave(String llave) {
		this.Llave = llave;
	}

	public String getLlave() {
		return this.Llave;
	}

	public void setFactura(String factura) {
		this.Factura = factura;
	}

	public String getFactura() {
		return this.Factura;
	}

	public void setXmlFactura(String xmlfactura) {
		this.XmlFactura = xmlfactura;
	}

	public String getXmlFactura() {
		return this.XmlFactura;
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
