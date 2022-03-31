package Objetos;

public class DirectorioTelefonico {

	private int id = 0;
	private String IdCredenciales = "";
	private String FechaNacimiento = "";
	private String NombreCompleto = "";
	private String NextelId = "";
	private String NextelTel = "";
	private String Celular = "";
	private String Email = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public DirectorioTelefonico() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setIdCredenciales(String idcredenciales) {
		this.IdCredenciales = idcredenciales;
	}

	public String getIdCredenciales() {
		return this.IdCredenciales;
	}

	public void setFechaNacimiento(String fechanacimiento) {
		this.FechaNacimiento = fechanacimiento;
	}

	public String getFechaNacimiento() {
		return this.FechaNacimiento;
	}

	public void setNombreCompleto(String nombrecompleto) {
		this.NombreCompleto = nombrecompleto;
	}

	public String getNombreCompleto() {
		return this.NombreCompleto;
	}

	public void setNextelId(String nextelid) {
		this.NextelId = nextelid;
	}

	public String getNextelId() {
		return this.NextelId;
	}

	public void setNextelTel(String nexteltel) {
		this.NextelTel = nexteltel;
	}

	public String getNextelTel() {
		return this.NextelTel;
	}

	public void setCelular(String celular) {
		this.Celular = celular;
	}

	public String getCelular() {
		return this.Celular;
	}

	public void setEmail(String email) {
		this.Email = email;
	}

	public String getEmail() {
		return this.Email;
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