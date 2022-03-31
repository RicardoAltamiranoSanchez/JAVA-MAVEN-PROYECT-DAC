package Objetos;

public class UbicacionesGrupo {

	private int id = 0;
	private String Pais = "";
	private String CodigoPais = "";
	private String Estado = "";
	private String Ciudad = "";
	private String CodigoCiudad = "";
	private String Sucursal = "";
	private String DomicilioSuc = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public UbicacionesGrupo() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setPais(String pais) {
		this.Pais = pais;
	}

	public String getPais() {
		return this.Pais;
	}

	public void setCodigoPais(String codigopais) {
		this.CodigoPais = codigopais;
	}

	public String getCodigoPais() {
		return this.CodigoPais;
	}

	public void setEstado(String estado) {
		this.Estado = estado;
	}

	public String getEstado() {
		return this.Estado;
	}

	public void setCiudad(String ciudad) {
		this.Ciudad = ciudad;
	}

	public String getCiudad() {
		return this.Ciudad;
	}

	public void setCodigoCiudad(String codigociudad) {
		this.CodigoCiudad = codigociudad;
	}

	public String getCodigoCiudad() {
		return this.CodigoCiudad;
	}

	public void setSucursal(String sucursal) {
		this.Sucursal = sucursal;
	}

	public String getSucursal() {
		return this.Sucursal;
	}

	public void setDomicilioSuc(String domiciliosuc) {
		this.DomicilioSuc = domiciliosuc;
	}

	public String getDomicilioSuc() {
		return this.DomicilioSuc;
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