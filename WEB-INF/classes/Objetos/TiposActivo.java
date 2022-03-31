package Objetos;

public class TiposActivo {

	private int id = 0;
	private String Nombre = "";
	private String IdClasificacionActivos = "";
	private String Plantilla = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public TiposActivo() {

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

	public void setIdClasificacionActivos(String idclasificacionactivos) {
		this.IdClasificacionActivos = idclasificacionactivos;
	}

	public String getIdClasificacionActivos() {
		return this.IdClasificacionActivos;
	}

	public void setPlantilla(String plantilla) {
		this.Plantilla = plantilla;
	}

	public String getPlantilla() {
		return this.Plantilla;
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