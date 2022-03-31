package Objetos;

public class Directorio {

	private int id = 0;
	private String Nombre = "";
	private String Puesto = "";
	private String Division = "";
	private String Estacion = "";
	private String Telefono = "";
	private String Nextel = "";
	private String IdNextel = "";
	private String Correo = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Directorio() {

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

	public void setTelefono(String telefono) {
		this.Telefono = telefono;
	}

	public String getTelefono() {
		return this.Telefono;
	}

	public void setNextel(String nextel) {
		this.Nextel = nextel;
	}

	public String getNextel() {
		return this.Nextel;
	}

	public void setIdNextel(String idnextel) {
		this.IdNextel = idnextel;
	}

	public String getIdNextel() {
		return this.IdNextel;
	}

	public void setCorreo(String correo) {
		this.Correo = correo;
	}

	public String getCorreo() {
		return this.Correo;
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
