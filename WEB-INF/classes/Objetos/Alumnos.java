package Objetos;

public class Alumnos {

	private int id = 0;
	private String Nombre = "";
	private String Telefono = "";
	private String Empresa = "";
	private String Estacion = "";
	private String Departamento = "";
	private String Puesto = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Alumnos() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setNombre(String nombre) {
		this.Nombre = nombre;
	}

	public String getNombre() {
		return this.Nombre;
	}

	public void setTelefono(String telefono) {
		this.Telefono = telefono;
	}

	public String getTelefono() {
		return this.Telefono;
	}

	public void setEmpresa(String empresa) {
		this.Empresa = empresa;
	}

	public String getEmpresa() {
		return this.Empresa;
	}

	public void setEstacion(String estacion) {
		this.Estacion = estacion;
	}

	public String getEstacion() {
		return this.Estacion;
	}

	public void setDepartamento(String departamento) {
		this.Departamento = departamento;
	}

	public String getDepartamento() {
		return this.Departamento;
	}

	public void setPuesto(String puesto) {
		this.Puesto = puesto;
	}

	public String getPuesto() {
		return this.Puesto;
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