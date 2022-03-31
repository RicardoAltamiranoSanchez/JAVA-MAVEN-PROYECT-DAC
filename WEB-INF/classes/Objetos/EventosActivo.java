package Objetos;

public class EventosActivo {

	private int id = 0;
	private String Descripcion = "";
	private String FechEvento = "";
	private String IdInventario = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public EventosActivo() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setDescripcion(String descripcion) {
		this.Descripcion = descripcion;
	}

	public String getDescripcion() {
		return this.Descripcion;
	}

	public void setFechEvento(String fechevento) {
		this.FechEvento = fechevento;
	}

	public String getFechEvento() {
		return this.FechEvento;
	}

	public void setIdInventario(String idinventario) {
		this.IdInventario = idinventario;
	}

	public String getIdInventario() {
		return this.IdInventario;
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