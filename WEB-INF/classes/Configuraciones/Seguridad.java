package Configuraciones;

import javax.servlet.http.HttpSession;

public class Seguridad {
	
	public Seguridad() {
		
	}
	
	public String getNivel(int nivel, HttpSession session, String[] argumentos) {
		String argumento = "";
		switch(nivel) {
			case 0: argumento = "A.Id > 0"; break;
			case 1:	argumento = "A.E = '" + session.getAttribute("IdEmpresas") + "'"; break;
			case 3: argumento = "A.U = '" + session.getAttribute("IdUsuario") + "'"; break;
			case 10: argumento = "A.IdPara = '" + session.getAttribute("IdUsuario") + "'"; break;
			case 11: argumento = "(A.U = '" + session.getAttribute("IdUsuario") + "' or A.IdPara = '" + session.getAttribute("IdUsuario") + "')"; break;
		}
		return argumento;
	}

}
