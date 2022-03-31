package Objetos;

public class Diplomas {

	private int id = 0;
	private String Tipo = "";
	private String NombreAlumno = "";
	private String NombreCurso = "";
	private String DescripcionCurso = "";
	private String NombreEmpresa = "";
	private String Imparticion = "";
	private String Certificado = "";
	private String ResponsableUno = "";
	private String PuestoResponsableUno = "";
	private String ResponsableDos = "";
	private String PuestoResponsableDos = "";
	private String Titulo = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public Diplomas() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setTipo(String tipo) {
		this.Tipo = tipo;
	}

	public String getTipo() {
		return this.Tipo;
	}

	public void setNombreAlumno(String nombrealumno) {
		this.NombreAlumno = nombrealumno;
	}

	public String getNombreAlumno() {
		return this.NombreAlumno;
	}

	public void setNombreCurso(String nombrecurso) {
		this.NombreCurso = nombrecurso;
	}

	public String getNombreCurso() {
		return this.NombreCurso;
	}

	public void setDescripcionCurso(String descripcioncurso) {
		this.DescripcionCurso = descripcioncurso;
	}

	public String getDescripcionCurso() {
		return this.DescripcionCurso;
	}

	public void setNombreEmpresa(String nombreempresa) {
		this.NombreEmpresa = nombreempresa;
	}

	public String getNombreEmpresa() {
		return this.NombreEmpresa;
	}

	public void setImparticion(String imparticion) {
		this.Imparticion = imparticion;
	}

	public String getImparticion() {
		return this.Imparticion;
	}

	public void setCertificado(String certificado) {
		this.Certificado = certificado;
	}

	public String getCertificado() {
		return this.Certificado;
	}

	public void setResponsableUno(String responsableuno) {
		this.ResponsableUno = responsableuno;
	}

	public String getResponsableUno() {
		return this.ResponsableUno;
	}

	public void setPuestoResponsableUno(String puestoresponsableuno) {
		this.PuestoResponsableUno = puestoresponsableuno;
	}

	public String getPuestoResponsableUno() {
		return this.PuestoResponsableUno;
	}

	public void setResponsableDos(String responsabledos) {
		this.ResponsableDos = responsabledos;
	}

	public String getResponsableDos() {
		return this.ResponsableDos;
	}

	public void setPuestoResponsableDos(String puestoresponsabledos) {
		this.PuestoResponsableDos = puestoresponsabledos;
	}

	public String getPuestoResponsableDos() {
		return this.PuestoResponsableDos;
	}

	public void setTitulo(String titulo) {
		this.Titulo = titulo;
	}

	public String getTitulo() {
		return this.Titulo;
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
