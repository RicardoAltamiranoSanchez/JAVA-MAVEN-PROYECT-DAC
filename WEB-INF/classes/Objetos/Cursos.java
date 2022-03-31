package Objetos;

public class Cursos {

	private int id = 0;
	private String Clave = "";
	private String Curso = "";
	private String HorasCurso = "";
	private String HorarioCurso = "";
	private String TipoCurso = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Cursos() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setClave(String clave) {
		this.Clave = clave;
	}

	public String getClave() {
		return this.Clave;
	}

	public void setCurso(String curso) {
		this.Curso = curso;
	}

	public String getCurso() {
		return this.Curso;
	}

	public void setHorasCurso(String horascurso) {
		this.HorasCurso = horascurso;
	}

	public String getHorasCurso() {
		return this.HorasCurso;
	}

	public void setHorarioCurso(String horariocurso) {
		this.HorarioCurso = horariocurso;
	}

	public String getHorarioCurso() {
		return this.HorarioCurso;
	}

	public void setTipoCurso(String tipocurso){
		this.TipoCurso = tipocurso;
	}
	
	public String getTipoCurso(){
		return this.TipoCurso;
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
