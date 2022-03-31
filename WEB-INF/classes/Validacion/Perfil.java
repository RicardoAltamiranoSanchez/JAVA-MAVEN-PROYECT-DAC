package Validacion;

import java.util.Properties;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import Libreria.MysqlPool;

public class Perfil {
	
	private ResultSet datos;
	private HttpSession session;
	private String idioma = "Esp"; // Esp - Ingles
	private Properties privilegiosEspeciales;
	
	public void setAPropiedades(MysqlPool eDB, String idEmpresas, HttpServletRequest request) throws SQLException {
		session = request.getSession();
		
		//datos = eDB.getQuery("select E.*,PE.Perfil, A.Prefijo, A.Awb, A.CC, A.Manifiesto from SistemaEmpresas as E left join PerfilesEmpresas as PE on (PE.Id = E.IdPerfilesEmpresas), Aerolineas as A where E.Id = '" + idEmpresas + "' and A.Id = E.IdAerolineas");
		datos = eDB.getQuery("select E.*, PE.Perfil, PE.ModoOperacion, A.Prefijo, A.CC from SistemaEmpresas as E left join PerfilesEmpresas as PE on (PE.Id = E.IdPerfilesEmpresas), Aerolineas as A where E.Id = '" + idEmpresas + "' and A.Id = E.IdAerolineas");
		
		while(datos.next()) {
			session.setAttribute("PrefijoUsuario", datos.getString("Prefijo"));
			session.setAttribute("NombreEmpresa", datos.getString("Codigo")+"-"+datos.getString("Empresa"));
			session.setAttribute("CodigoEmpresa", datos.getString("Codigo"));
			session.setAttribute("AerolineaCC", datos.getString("CC"));
			session.setAttribute("IdClientes", datos.getString("IdClientes"));
			session.setAttribute("IdPerfilesEmpresas", datos.getString("IdPerfilesEmpresas"));
			session.setAttribute("PerfilEmpresa", datos.getString("Perfil"));
			session.setAttribute("EmbarcadorAbierto", datos.getString("EmbarcadorAbierto"));
			session.setAttribute("EmbarcadorFijo", datos.getString("EmbarcadorFijo"));
			session.setAttribute("ModoOperacion", datos.getString("ModoOperacion"));
		}
		
		datos = eDB.getQuery("select PU.Perfil, U.Estacion, U.IdPerfilesUsuarios, U.OtrasEstaciones from PerfilesUsuarios as PU, SistemaUsuarios as U where U.Id = '" + session.getAttribute("IdUsuario") + "' and PU.Id = U.IdPerfilesUsuarios");
		while(datos.next()) {
			session.setAttribute("PerfilUsuario", datos.getString("Perfil"));
			session.setAttribute("IdPerfilUsuario", datos.getString("IdPerfilesUsuarios"));
			session.setAttribute("EstacionUsuario", datos.getString("Estacion"));
			session.setAttribute("OtrasEstaciones", datos.getString("OtrasEstaciones"));
		}
		
		datos = eDB.getQuery("select Idioma from ConfiguracionIdioma where IdUsuarios = '" + session.getAttribute("IdUsuario") + "'");
		while(datos.next()) {
			idioma = datos.getString("Idioma");
		}
		session.setAttribute("Idioma", idioma);
		
		privilegiosEspeciales = new Properties();
		datos = eDB.getQuery("select PermisoEspecial, NombrePermiso from PerfilesPermisosEspeciales as P, SistemaUsuarios as S, PermisosEspeciales as PE where S.Id = '" + session.getAttribute("IdUsuario") + "' and P.IdPerfilesUsuarios = S.IdPerfilesUsuarios and PE.Codigo = P.PermisoEspecial");
		while(datos.next()) {
			privilegiosEspeciales.setProperty(datos.getString("PermisoEspecial"), datos.getString("NombrePermiso"));
		}
		session.setAttribute("PermisosEspeciales", privilegiosEspeciales);
		
	}

}
