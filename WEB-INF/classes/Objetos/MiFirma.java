package Objetos;

public class MiFirma {

	private int id = 0;
	private String IdUsuario = "";
	private String Nombre = "";
	private String Titulo = "";
	private String Email = "";
	private String Nextel = "";
	private String NextelId = "";
	private String FirmaGrupoHtml = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public MiFirma() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setIdUsuario(String idusuario) {
		this.IdUsuario = idusuario;
	}

	public String getIdUsuario() {
		return this.IdUsuario;
	}

	public void setNombre(String nombre) {
		this.Nombre = nombre;
	}

	public String getNombre() {
		return this.Nombre;
	}

	public void setTitulo(String titulo) {
		this.Titulo = titulo;
	}

	public String getTitulo() {
		return this.Titulo;
	}

	public void setEmail(String email) {
		this.Email = email;
	}

	public String getEmail() {
		return this.Email;
	}

	public void setNextel(String nextel) {
		this.Nextel = nextel;
	}

	public String getNextel() {
		return this.Nextel;
	}

	public void setNextelId(String nextelid) {
		this.NextelId = nextelid;
	}

	public String getNextelId() {
		return this.NextelId;
	}
	
	public void setFirmaGrupoHtml(String firmagrupohtml) {
		this.FirmaGrupoHtml = firmagrupohtml;
	}

	public String getFirmaGrupoHtml() {
		return this.FirmaGrupoHtml;
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
