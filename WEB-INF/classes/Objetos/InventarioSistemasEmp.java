package Objetos;

public class InventarioSistemasEmp {

	private String id = "";
	private String IdInventarioSistemas = "";
	private String Fecha = "";
	private String IdEmpleado = "";
	private String Empleado = "";
	private String Division = "";
	private String IdResponsable = "";
	private String Responsable = "";
	private String Localizacion = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public InventarioSistemasEmp() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdInventarioSistemas(String idinventariosistemas) {
		this.IdInventarioSistemas = idinventariosistemas;
	}

	public String getIdInventarioSistemas() {
		return this.IdInventarioSistemas;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setIdEmpleado(String idempleado) {
		this.IdEmpleado = idempleado;
	}

	public String getIdEmpleado() {
		return this.IdEmpleado;
	}
	
	public String getEmpleado() {
		return Empleado;
	}

	public void setEmpleado(String empleado) {
		Empleado = empleado;
	}

	public String getDivision() {
		return Division;
	}

	public void setDivision(String division) {
		Division = division;
	}
	
	public String getIdResponsable() {
		return IdResponsable;
	}

	public void setIdResponsable(String idResponsable) {
		IdResponsable = idResponsable;
	}

	public String getResponsable() {
		return Responsable;
	}

	public void setResponsable(String responsable) {
		Responsable = responsable;
	}

	public String getLocalizacion() {
		return Localizacion;
	}

	public void setLocalizacion(String localizacion) {
		Localizacion = localizacion;
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
//InventarioSistemasEmp

