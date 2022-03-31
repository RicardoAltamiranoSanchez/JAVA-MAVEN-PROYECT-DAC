package Html;

import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.Properties;

import javax.naming.NamingException;

import Libreria.MysqlPool;

public class Idioma {
	
	private MysqlPool eDB;
	
	public Idioma() throws NamingException {
		eDB = new MysqlPool();
	}
	
	public Properties getLenguaje(String idModulo, String IdIdioma) throws SQLException {
		Properties idioma = new Properties();
		eDB.setConexion();
		ResultSet datos = eDB.getQuery("select Campo, Texto from Traducciones where IdIdiomas = '" + IdIdioma + "' and IdModulos = '" + idModulo + "'");
		while(datos.next()) {
			idioma.setProperty(datos.getString("Campo"), datos.getString("Texto"));
		}
		eDB.setCerrar(datos);
		eDB.setCerrar();
		eDB.setCerrarConexion();
		return idioma;
	}
	
	public Properties getGenerales(String IdIdioma) throws SQLException {
		Properties idiomaGeneral = new Properties();
		eDB.setConexion();
		System.out.println("select Campo, Texto from Traducciones where IdIdiomas = '" + IdIdioma + "' and IdModulos = '1'");
		ResultSet datos = eDB.getQuery("select Campo, Texto from Traducciones where IdIdiomas = '" + IdIdioma + "' and IdModulos = '1'");
		while(datos.next()) {
			idiomaGeneral.setProperty(datos.getString("Campo"), datos.getString("Texto"));
		}
		eDB.setCerrar(datos);
		eDB.setCerrar();
		eDB.setCerrarConexion();
		return idiomaGeneral;
	}

}
