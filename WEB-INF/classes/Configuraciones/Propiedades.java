package Configuraciones;

public class Propiedades {
	
	final private String titulo = "Intranet MCS Holding";
	final private String servidorCorreo = "madrid.enlacenet.net";
	final private String cuentaCorreo = "noreply@mcs-holding.com";
	final private String passwordCorreo = "noSeCarajo.2015";
	final private String puertoCorreo = "587";
	
	public Propiedades() {
	}
	
	public String getTitulo() {
		return this.titulo;
	}
	
	public String getServidorCorreo() { return this.servidorCorreo; }
	public String getCuentaCorreo() { return this.cuentaCorreo; }
	public String getPasswordCorreo() { return this.passwordCorreo; }
	public String getPuertoCorreo() { return this.puertoCorreo; }
}
