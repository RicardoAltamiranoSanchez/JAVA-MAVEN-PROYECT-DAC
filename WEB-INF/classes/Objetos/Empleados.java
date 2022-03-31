package Objetos;

public class Empleados {

	private int id = 0;
	private String IdUsuario = "";
	private String NumeroEmpleado = "";
	private String NombreCompleto = "";
	private String CorreoElectronico = "";
	private String IdAreasLaborales = "";
	private String Puesto = "";
	private String Division = "";
	private String Estacion = "";
	private String NSS = "";
	private String CURP = "";
	private String FechaIngreso = "";
	private String Estatus = "";
	private String Vacaciones = "";
	private String NoDisfrutadosPeriodoAnterior = "";
	private String IdJefeDirecto = "";
	private String DescripcionPuesto = "";
	private String Observaciones = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Empleados() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setIdUsuario(String idusuario) {
		this.IdUsuario = idusuario;
	}

	public String getIdUsuario() {
		return this.IdUsuario;
	}

	public void setNumeroEmpleado(String numeroempleado) {
		this.NumeroEmpleado = numeroempleado;
	}

	public String getNumeroEmpleado() {
		return this.NumeroEmpleado;
	}

	public void setNombreCompleto(String nombrecompleto) {
		this.NombreCompleto = nombrecompleto;
	}

	public String getNombreCompleto() {
		return this.NombreCompleto;
	}
	
	public void setCorreoElectronico(String correoElectronico) {
		this.CorreoElectronico = correoElectronico;
	}

	public String getCorreoElectronico() {
		return this.CorreoElectronico;
	}
	
	public void setIdAreasLaborales(String idAreasLaborales) {
		this.IdAreasLaborales = idAreasLaborales;
	}

	public String getIdAreasLaborales() {
		return this.IdAreasLaborales;
	}

	public void setPuesto(String puesto) {
		this.Puesto = puesto;
	}

	public String getPuesto() {
		return this.Puesto;
	}

	public void setDivision(String division) {
		this.Division = division;
	}

	public String getDivision() {
		return this.Division;
	}

	public void setEstacion(String estacion) {
		this.Estacion = estacion;
	}

	public String getEstacion() {
		return this.Estacion;
	}

	public void setNSS(String nss) {
		this.NSS = nss;
	}

	public String getNSS() {
		return this.NSS;
	}

	public void setCURP(String curp) {
		this.CURP = curp;
	}

	public String getCURP() {
		return this.CURP;
	}

	public void setFechaIngreso(String fechaingreso) {
		this.FechaIngreso = fechaingreso;
	}

	public String getFechaIngreso() {
		return this.FechaIngreso;
	}

	public void setEstatus(String estatus) {
		this.Estatus = estatus;
	}

	public String getEstatus() {
		return this.Estatus;
	}

	public void setVacaciones(String vacaciones) {
		this.Vacaciones = vacaciones;
	}

	public String getVacaciones() {
		return this.Vacaciones;
	}
	
	public void setNoDisfrutadosPeriodoAnterior(String nodisfrutadosperiodoanterior) {
		this.NoDisfrutadosPeriodoAnterior = nodisfrutadosperiodoanterior;
	}

	public String getNoDisfrutadosPeriodoAnterior() {
		return this.NoDisfrutadosPeriodoAnterior;
	}
	
	public void setIdJefeDirecto(String idjefedirecto) {
		this.IdJefeDirecto = idjefedirecto;
	}

	public String getIdJefeDirecto() {
		return this.IdJefeDirecto;
	}
	
	public void setDescripcionPuesto(String descripcionpuesto) {
		this.DescripcionPuesto = descripcionpuesto;
	}

	public String getDescripcionPuesto() {
		return this.DescripcionPuesto;
	}
	
	public void setObservaciones(String observaciones) {
		this.Observaciones = observaciones;
	}

	public String getObservaciones() {
		return this.Observaciones;
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