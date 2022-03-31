package Objetos;

public class MexReqPreAutorizar {

	private String id = "";
	private String Fecha = "";
	private String Alias = "";
	private String Nombre = "";
	private String Empresa = "";
	private String Area = "";
	private String Unidad = "";
	private String Principal = "";
	private String Soporte1 = "";
	private String Soporte2 = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public MexReqPreAutorizar() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setAlias(String alias) {
		this.Alias = alias;
	}

	public String getAlias() {
		return this.Alias;
	}

	public void setNombre(String nombre) {
		this.Nombre = nombre;
	}

	public String getNombre() {
		return this.Nombre;
	}

	public void setEmpresa(String empresa) {
		this.Empresa = empresa;
	}

	public String getEmpresa() {
		return this.Empresa;
	}

	public void setArea(String area) {
		this.Area = area;
	}

	public String getArea() {
		return this.Area;
	}

	public void setUnidad(String unidad) {
		this.Unidad = unidad;
	}

	public String getUnidad() {
		return this.Unidad;
	}

	public void setPrincipal(String principal) {
		this.Principal = principal;
	}

	public String getPrincipal() {
		return this.Principal;
	}

	public void setSoporte1(String soporte1) {
		this.Soporte1 = soporte1;
	}

	public String getSoporte1() {
		return this.Soporte1;
	}

	public void setSoporte2(String soporte2) {
		this.Soporte2 = soporte2;
	}

	public String getSoporte2() {
		return this.Soporte2;
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
//MexReqPreAutorizar