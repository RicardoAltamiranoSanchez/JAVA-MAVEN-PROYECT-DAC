package Objetos;

public class InventarioSistemasRep {

	private String id = "";
	private String IdInventarioSistemas = "";
	private String Fecha = "";
	private String Reparacion = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public InventarioSistemasRep() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdInventarioSistemas(String idinventariosistemas) {
		this.IdInventarioSistemas = idinventariosistemas;
	}

	public String getIdInventarioSistemas() {
		return this.IdInventarioSistemas;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setReparacion(String reparacion) {
		this.Reparacion = reparacion;
	}

	public String getReparacion() {
		return this.Reparacion;
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
	public void setBloquear(boolean bloquear) {
		this.bloquear = bloquear;
	}
	
	public boolean getBloquear() {
		return this.bloquear;
	}
}
//InventarioSistemasRep

