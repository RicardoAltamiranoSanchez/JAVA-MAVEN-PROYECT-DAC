package Objetos;

public class PermisosSinGoce {

	private int id = 0;
	private String Fecha = "";
	private String Nombre = "";
	private String Area = "";
	private String Puesto = "";
	private String Empresa = "";
	private String FechaIngreso = "";
	private String DiasTomar = "";
	private String FechaDiasTomar = "";
	private String IdGerente = "";
	private String AutorizacionGerente = "";
	private String AutorizacionRH = "";
	private String Estatus = "";
	private String Motivo = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public PermisosSinGoce() {

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

	public void setNombre(String nombre) {
		this.Nombre = nombre;
	}

	public String getNombre() {
		return this.Nombre;
	}

	public void setArea(String area) {
		this.Area = area;
	}

	public String getArea() {
		return this.Area;
	}

	public void setPuesto(String puesto) {
		this.Puesto = puesto;
	}

	public String getPuesto() {
		return this.Puesto;
	}

	public void setEmpresa(String empresa) {
		this.Empresa = empresa;
	}

	public String getEmpresa() {
		return this.Empresa;
	}

	public void setFechaIngreso(String fechaingreso) {
		this.FechaIngreso = fechaingreso;
	}

	public String getFechaIngreso() {
		return this.FechaIngreso;
	}

	public void setDiasTomar(String diastomar) {
		this.DiasTomar = diastomar;
	}

	public String getDiasTomar() {
		return this.DiasTomar;
	}

	public void setFechaDiasTomar(String fechadiastomar) {
		this.FechaDiasTomar = fechadiastomar;
	}

	public String getFechaDiasTomar() {
		return this.FechaDiasTomar;
	}
	
	public void setIdGerente(String idgerente){
		this.IdGerente = idgerente;
	}

	public String getIdGerente(){
		return this.IdGerente;
	}
	
	public void setAutorizacionGerente(String autorizaciongerente) {
		this.AutorizacionGerente = autorizaciongerente;
	}

	public String getAutorizacionGerente() {
		return this.AutorizacionGerente;
	}

	public void setAutorizacionRH(String autorizacionrh) {
		this.AutorizacionRH = autorizacionrh;
	}

	public String getAutorizacionRH() {
		return this.AutorizacionRH;
	}

	public void setEstatus(String estatus) {
		this.Estatus = estatus;
	}

	public String getEstatus() {
		return this.Estatus;
	}
	
	public void setMotivo(String motivo){
		this.Motivo = motivo;
	}
	
	public String getMotivo(){
		return this.Motivo;
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
