package Objetos;

public class AreasGrupo {

	private int id = 0;
	private String Nombre = "";
	private String Clave = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public AreasGrupo() {

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

	public void setClave(String clave) {
		this.Clave = clave;
	}

	public String getClave() {
		return this.Clave;
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
