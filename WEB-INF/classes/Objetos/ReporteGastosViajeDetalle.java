package Objetos;

public class ReporteGastosViajeDetalle {

	private int id = 0;
	private String IdReporteGastosViaje = "";
	private String Fecha = "";
	private String Documento = "";
	private String Proveedor = "";
	private String DetalleGasto = "";
	private String ImporteSinIva = "";
	private String ImporteConIva = "";
	private String Iva = "";
	private String GastosComprobados = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public ReporteGastosViajeDetalle() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setIdReporteGastosViaje(String idreportegastosviaje) {
		this.IdReporteGastosViaje = idreportegastosviaje;
	}

	public String getIdReporteGastosViaje() {
		return this.IdReporteGastosViaje;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setDocumento(String documento) {
		this.Documento = documento;
	}

	public String getDocumento() {
		return this.Documento;
	}

	public void setProveedor(String proveedor) {
		this.Proveedor = proveedor;
	}

	public String getProveedor() {
		return this.Proveedor;
	}

	public void setDetalleGasto(String detallegasto) {
		this.DetalleGasto = detallegasto;
	}

	public String getDetalleGasto() {
		return this.DetalleGasto;
	}

	public void setImporteSinIva(String importesiniva) {
		this.ImporteSinIva = importesiniva;
	}

	public String getImporteSinIva() {
		return this.ImporteSinIva;
	}

	public void setImporteConIva(String importeconiva) {
		this.ImporteConIva = importeconiva;
	}

	public String getImporteConIva() {
		return this.ImporteConIva;
	}

	public void setIva(String iva) {
		this.Iva = iva;
	}

	public String getIva() {
		return this.Iva;
	}

	public void setGastosComprobados(String gastoscomprobados) {
		this.GastosComprobados = gastoscomprobados;
	}

	public String getGastosComprobados() {
		return this.GastosComprobados;
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