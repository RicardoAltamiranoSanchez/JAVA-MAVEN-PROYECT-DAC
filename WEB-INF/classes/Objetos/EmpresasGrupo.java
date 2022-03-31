package Objetos;

public class EmpresasGrupo {

	private int id = 0;
	private String Nombre = "";
	private String Codigo = "";
	private String DomFiscal = "";
	private String RFC = "";
	private String Admon = "";			//DIVISION ADD
	private String value = "";
	private String log = "";
	private boolean error = false;

	public EmpresasGrupo() {

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

	public void setCodigo(String codigo) {
		this.Codigo = codigo;
	}

	public String getCodigo() {
		return this.Codigo;
	}

	public void setDomFiscal(String domfiscal) {
		this.DomFiscal = domfiscal;
	}

	public String getDomFiscal() {
		return this.DomFiscal;
	}

	public void setRFC(String rfc) {
		this.RFC = rfc;
	}

	public String getRFC() {
		return this.RFC;
	}
	
	public void setAdmon(String admon) {	//DIVISION ADD
		this.Admon = admon;
	}

	public String getAdmon() {				//DIVISION ADD
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