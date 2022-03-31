package Objetos;

public class BannerCategoriaFirma {

	private int id = 0;
	private String CategoriaFirma = "";
	private String GrupoEmpleados = "";
	private String Archivo = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public BannerCategoriaFirma() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setCategoriaFirma(String categoriafirma) {
		this.CategoriaFirma = categoriafirma;
	}

	public String getCategoriaFirma() {
		return this.CategoriaFirma;
	}
	
	public void setGrupoEmpleados(String grupoempleados) {
		this.GrupoEmpleados = grupoempleados;
	}

	public String getGrupoEmpleados() {
		return this.GrupoEmpleados;
	}
	
	public void setArchivo(String archivo) {
		this.Archivo = archivo;
	}

	public String getArchivo() {
		return this.Archivo;
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
