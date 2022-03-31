package Configuraciones;

import javax.servlet.http.HttpSession;

public class Generales {

	private final String version = "v4.3";
	private final String protocolo = "http";
	private final String directorio = "MCSNetJDacIntra";
	private final String tipoMenu = "Lista"; // Carpetas o Lista
	private final String tema = "CloudCargo";
	
	
	//local
	//private final String puerto = ":9080";
	//private final String url = "localhost";
	 
	
	//productivo
	private final String puerto = "";
	private final String url = "intranet.domestic-cargo.com";
	
	private final String urlLogout = protocolo + "://" + url + puerto + "/" + directorio + "/";

	public Generales() {
	}

	public String getVersion() {
		return this.version;
	}
	
	public String getDirectorio() {
		return this.directorio;
	}
	
	public String getProtocolo() {
		return this.protocolo;
	}
	
	public String getPuerto() {
		return this.puerto;
	}
	
	public String getUrlLogout() {
		return this.urlLogout;
	}
	
	public String getTipoMenu() {
		return this.tipoMenu;
	}
	
	public String getTema() {
		return this.tema;
	}
	
}