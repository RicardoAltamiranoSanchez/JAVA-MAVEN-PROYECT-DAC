package Objetos;

public class TiposCredenciales {

	private int id = 0;
	private String Nombre = "";
	private String Archivo = "";
	private String Admon = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public TiposCredenciales() {

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

	public void setArchivo(String archivo) {
		this.Archivo = archivo;
	}

	public String getArchivo() {
		return this.Archivo;
	}
	
	public void setAdmon(String admon) {
		this.Admon = admon;
	}

	public String getAdmon() {
		return this.Admon;
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