package Objetos;

public class DocumActivos {

	private int id = 0;
	private String Nombre = "";
	private String Factura = "";
	private String IdInventario = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public DocumActivos() {

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

	public void setFactura(String factura) {
		this.Factura = factura;
	}

	public String getFactura() {
		return this.Factura;
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