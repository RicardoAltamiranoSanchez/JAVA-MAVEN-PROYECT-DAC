package Objetos;

public class MexEmpresasUnidades {

	private String id = "";
	private String IdAreas = "";
	private String Areas = "";
	private String Unidad = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public MexEmpresasUnidades() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setIdAreas(String idareas) {
		this.IdAreas = idareas;
	}

	public String getIdAreas() {
		return this.IdAreas;
	}

	public void setAreas(String areas) {
		this.Areas = areas;
	}

	public String getAreas() {
		return this.Areas;
	}

	public void setUnidad(String unidad) {
		this.Unidad = unidad;
	}

	public String getUnidad() {
		return this.Unidad;
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
//MexEmpresasUnidadesObjeto

