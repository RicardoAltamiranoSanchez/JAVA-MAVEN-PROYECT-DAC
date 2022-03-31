package Validacion;

public class PrivilegiosLogin {

	private int Usuario,Grupo,Empresa,Global;
	
	public void setUsuario(int valor) {
		this.Usuario = valor;
	}
	
	public void setGrupo(int valor) {
		this.Grupo = valor;
	}
	
	public void setEmpresa(int valor) {
		this.Empresa = valor;
	}
	
	public void setGlobal(int valor) {
		this.Global = valor;
	}
	
	public int getUsuario() {
		return this.Usuario;
	}
	
	public int getGrupo() {
		return this.Grupo;
	}
	
	public int getEmpresa() {
		return this.Empresa;
	}
	
	public int getGlobal() {
		return this.Global;
	}
	
}
