package Objetos;

public class Formatos {

	private int id = 0;
	private String Nombre = "";
	private String Seccion = "";
	private String Archivo = "";
	private String Ocultar = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Formatos() {

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

	public void setSeccion(String seccion) {
		this.Seccion = seccion;
	}

	public String getSeccion() {
		return this.Seccion;
	}

	public void setArchivo(String archivo) {
		this.Archivo = archivo;
	}

	public String getArchivo() {
		return this.Archivo;
	}

	public void setOcultar(String ocultar) {
		this.Ocultar = ocultar;
	}

	public String getOcultar() {
		return this.Ocultar;
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
