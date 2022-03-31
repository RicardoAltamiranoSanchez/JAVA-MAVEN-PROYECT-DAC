package Objetos;

public class Requisiciones {

	private String id = "";
	private String De = "";
	private String Fecha = "";
	private String IdProveedores = "";
	private String Proveedores = "";
	private String IdEmpresas = "";
	private String Empresas = "";
	private String IdPara = "";
	private String Para = "";
	private String FormaPago = "";
	private String InstruccionesPago = "";
	private String Descripcion = "";
	private String Importe = "";
	private String Iva = "";
	private String Total = "";
	private String Estatus = "";
	private String MotivoRechazo = "";
	private String FacturaFolio = "";
	private String FacturaMontoTotal = "";
	private String FacturaFechaIdealPago = "";
	private String FacturaObservaciones = "";
	private String Moneda = "";
	private String EstatusPago = "";
	private String RestantePago = "";
	private String ArchivoPagos = "";
	private String FechaSolicitud = "";
	private String FechaAutorizacion = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public Requisiciones() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}
	
	public String getDe() {
		return De;
	}

	public void setDe(String de) {
		De = de;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setIdProveedores(String idproveedores) {
		this.IdProveedores = idproveedores;
	}

	public String getIdProveedores() {
		return this.IdProveedores;
	}

	public void setProveedores(String proveedores) {
		this.Proveedores = proveedores;
	}

	public String getProveedores() {
		return this.Proveedores;
	}

	public void setIdEmpresas(String idempresas) {
		this.IdEmpresas = idempresas;
	}

	public String getIdEmpresas() {
		return this.IdEmpresas;
	}

	public void setEmpresas(String empresas) {
		this.Empresas = empresas;
	}

	public String getEmpresas() {
		return this.Empresas;
	}

	public void setIdPara(String idpara) {
		this.IdPara = idpara;
	}

	public String getIdPara() {
		return this.IdPara;
	}

	public void setPara(String para) {
		this.Para = para;
	}

	public String getPara() {
		return this.Para;
	}

	public void setFormaPago(String formapago) {
		this.FormaPago = formapago;
	}

	public String getFormaPago() {
		return this.FormaPago;
	}

	public void setInstruccionesPago(String instruccionespago) {
		this.InstruccionesPago = instruccionespago;
	}

	public String getInstruccionesPago() {
		return this.InstruccionesPago;
	}

	public void setDescripcion(String descripcion) {
		this.Descripcion = descripcion;
	}

	public String getDescripcion() {
		return this.Descripcion;
	}

	public void setImporte(String importe) {
		this.Importe = importe;
	}

	public String getImporte() {
		return this.Importe;
	}

	public void setIva(String iva) {
		this.Iva = iva;
	}

	public String getIva() {
		return this.Iva;
	}

	public void setTotal(String total) {
		this.Total = total;
	}

	public String getTotal() {
		return this.Total;
	}

	public void setEstatus(String estatus) {
		this.Estatus = estatus;
	}

	public String getEstatus() {
		return this.Estatus;
	}

	public void setMotivoRechazo(String motivorechazo) {
		this.MotivoRechazo = motivorechazo;
	}

	public String getMotivoRechazo() {
		return this.MotivoRechazo;
	}

	public void setFacturaFolio(String facturafolio) {
		this.FacturaFolio = facturafolio;
	}

	public String getFacturaFolio() {
		return this.FacturaFolio;
	}
	
	public void setFacturaMontoTotal(String facturamontototal) {
		this.FacturaMontoTotal = facturamontototal;
	}

	public String getFacturaMontoTotal() {
		return this.FacturaMontoTotal;
	}
	public void setFacturaFechaIdealPago(String facturafechaidealpago) {
		this.FacturaFechaIdealPago = facturafechaidealpago;
	}

	public String getFacturaFechaIdealPago() {
		return this.FacturaFechaIdealPago;
	}
	
	public void setFacturaObservaciones(String facturaobservaciones) {
		this.FacturaObservaciones = facturaobservaciones;
	}

	public String getFacturaObservaciones() {
		return this.FacturaObservaciones;
	}
	
	public void setMoneda(String moneda) {
		this.Moneda = moneda;
	}

	public String getMoneda() {
		return this.Moneda;
	}
	
	public void setEstatusPago(String estatuspago) {
		this.EstatusPago = estatuspago;
	}

	public String getEstatusPago() {
		return this.EstatusPago;
	}
	
	public void setRestantePago(String restantepago) {
		this.RestantePago = restantepago;
	}

	public String getRestantePago() {
		return this.RestantePago;
	}
	
	public void setArchivoPagos(String archivopagos) {
		this.ArchivoPagos = archivopagos;
	}

	public String getArchivoPagos() {
		return this.ArchivoPagos;
	}
	
	public void setFechaSolicitud(String fechasolicitud) {
		this.FechaSolicitud = fechasolicitud;
	}

	public String getFechaSolicitud() {
		return this.FechaSolicitud;
	}
	
	public void setFechaAutorizacion(String fechaautorizacion) {
		this.FechaAutorizacion = fechaautorizacion;
	}

	public String getFechaAutorizacion() {
		return this.FechaAutorizacion;
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
//RequisicionesObjeto