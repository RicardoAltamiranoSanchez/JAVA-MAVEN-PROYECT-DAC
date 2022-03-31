package Validacion;

import java.util.Hashtable;

public class PrivilegiosCheck {
	
	private PrivilegiosLogin privilegio;

	public PrivilegiosCheck(Object privilegios, Object modulo, Object grupo, Object empresa) {
		privilegio = ((Hashtable<String, PrivilegiosLogin>)privilegios).get(modulo.toString() + "|" + grupo.toString() + "|" + empresa.toString());
	}
	
	public int getPrivUsuario() {
		return privilegio.getUsuario();
	}
	
	public int getPrivGrupo() {
		return privilegio.getGrupo();
	}
	
	public int getPrivEmpresa() {
		return privilegio.getEmpresa();
	}

	public int getPrivGlobal() {
		return privilegio.getGlobal();
	}
	
	public boolean getCaptura() {
		boolean bandera = false;
		if(privilegio.getUsuario() > 1) {
			bandera = true;
		}
		return bandera;
	}
	
	public String getModificar(Object idUsuarios, Object idGrupos, Object idEmpresas) {
		String modificar = ",false as Modificar";
		if(privilegio.getGlobal() > 2) {
			modificar = ",if(A.BM = 'False',true,false) as Modificar";
		}
		else if(privilegio.getEmpresa() > 2) {
			modificar = ",if(A.BM = 'False' and A.E='" + idEmpresas + "',true,false) as Modificar";
		}
		else if(privilegio.getGrupo() > 2) {
			modificar = ",if(A.BM = 'False' and A.E='" + idEmpresas + "' and A.G='" + idGrupos + "',true,false) as Modificar";
		}
		else if(privilegio.getUsuario() > 3) {
			modificar = ",if(A.BM = 'False' and A.U='" + idUsuarios + "',true,false) as Modificar";
		}
		return modificar;
	}
	
	public String getEliminar(Object idUsuarios, Object idGrupos, Object idEmpresas) {
		String eliminar = ",false as Eliminar";
		if(privilegio.getGlobal() == 4) {
			eliminar = ",if(A.BE = 'False',true,false) as Eliminar";
		}
		else if(privilegio.getEmpresa() == 4) {
			eliminar = ",if(A.BE = 'False' and A.E='" + idEmpresas + "',true,false) as Eliminar";
		}
		else if(privilegio.getGrupo() == 4) {
			eliminar = ",if(A.BE = 'False' and A.E='" + idEmpresas + "' and A.G='" + idGrupos + "',true,false) as Eliminar";
		}
		else if(privilegio.getUsuario() == 5) {
			eliminar = ",if(A.BE = 'False' and A.U='" + idUsuarios + "',true,false) as Eliminar";
		}
		
		return eliminar;
	}
	
	public String getLectura(Object idUsuarios, Object idGrupos, Object idEmpresas) {
		String lectura = "and A.U = '0'";
		if(privilegio.getGlobal() > 1) {
			lectura = "";
		}
		else if(privilegio.getEmpresa() > 1) {
			lectura = "and A.E = '" + idEmpresas + "'";
		}
		else if(privilegio.getGrupo() > 1) {
			lectura = "and A.G = '" + idGrupos + "'";
		}
		else if(privilegio.getUsuario() > 2) {
			lectura = "and A.U = '" + idUsuarios + "'";
		}
		return lectura;
	}
	
}
