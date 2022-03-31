package Objetos;

public class DocumEmpleadosGrupo {

	private int id = 0;
	private String TipoDocumento = "";
	private String Nombre = "";
	private String IdEmpleadosGrupo = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public DocumEmpleadosGrupo() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setTipoDocumento(String tipodocumento) {
		this.TipoDocumento = tipodocumento;
	}

	public String getTipoDocumento() {
		return this.TipoDocumento;
	}

	public void setNombre(String nombre) {
		this.Nombre = nombre;
	}

	public String getNombre() {
		return this.Nombre;
	}

	public void setIdEmpleadosGrupo(String idempleadosgrupo) {
		this.IdEmpleadosGrupo = idempleadosgrupo;
	}

	public String getIdEmpleadosGrupo() {
		return this.IdEmpleadosGrupo;
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