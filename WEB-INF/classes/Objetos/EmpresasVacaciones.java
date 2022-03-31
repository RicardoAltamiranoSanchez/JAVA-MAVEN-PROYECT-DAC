package Objetos;

public class EmpresasVacaciones {

	private int id = 0;
	private String IdEmpresasGrupo = "";
	private String Ao = "";
	private String DiasLey = "";
	private String DiasExtra = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public EmpresasVacaciones() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setIdEmpresasGrupo(String idempresasgrupo) {
		this.IdEmpresasGrupo = idempresasgrupo;
	}

	public String getIdEmpresasGrupo() {
		return this.IdEmpresasGrupo;
	}

	public void setAo(String ao) {
		this.Ao = ao;
	}

	public String getAo() {
		return this.Ao;
	}

	public void setDiasLey(String diasley) {
		this.DiasLey = diasley;
	}

	public String getDiasLey() {
		return this.DiasLey;
	}

	public void setDiasExtra(String diasextra) {
		this.DiasExtra = diasextra;
	}

	public String getDiasExtra() {
		return this.DiasExtra;
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