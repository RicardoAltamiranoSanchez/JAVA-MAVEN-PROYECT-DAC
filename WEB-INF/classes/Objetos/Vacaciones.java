package Objetos;

public class Vacaciones {

	private int id = 0;
	private String IdUsuario = "";
	private String FechaSolicitud = "";
	private String Estatus = "";
	private String Gerente = "";
	private String Jefe = "";
	private String Llave = "";
	private String Tipo = "";
	private String NombreCompleto = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Vacaciones() {

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

	public void setFechaSolicitud(String fechasolicitud) {
		this.FechaSolicitud = fechasolicitud;
	}

	public String getFechaSolicitud() {
		return this.FechaSolicitud;
	}

	public void setEstatus(String estatus) {
		this.Estatus = estatus;
	}

	public String getEstatus() {
		return this.Estatus;
	}

	public void setGerente(String gerente) {
		this.Gerente = gerente;
	}

	public String getGerente() {
		return this.Gerente;
	}

	public void setJefe(String jefe) {
		this.Jefe = jefe;
	}

	public String getJefe() {
		return this.Jefe;
	}

	public void setLlave(String llave) {
		this.Llave = llave;
	}

	public String getLlave() {
		return this.Llave;
	}
	
	public void setTipo(String tipo) {
		this.Tipo = tipo;
	}

	public String getTipo() {
		return this.Tipo;
	}
	
	public void setNombreCompleto(String nombrecompleto) {
		this.NombreCompleto = nombrecompleto;
	}

	public String getNombreCompleto() {
		return this.NombreCompleto;
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