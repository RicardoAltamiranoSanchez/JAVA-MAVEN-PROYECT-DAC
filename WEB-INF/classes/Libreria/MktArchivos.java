package Libreria;

import java.sql.SQLException;
import java.sql.ResultSet;

import javax.naming.NamingException;

public class MktArchivos {

	private MysqlPool eDB;
	private boolean debug = false;
	
	public MktArchivos() throws NamingException, SQLException {
		eDB = new MysqlPool();
		eDB.setConexion();
	}
	
	public ResultSet getTiposArchivo() throws SQLException {
		/*
		 * image_btn_lh / image_lh / LH
		 * image_btn_estafeta / image_estafeta / E7
		 * image_btn_qatar / image_qatar / QR
		 */
		String query = "select Id, Nombre from MktTipoArchivo";
		if(debug) { System.out.println(query); }
		return eDB.getQuery(query);
	}
	
	public ResultSet getArchivosyTipoNombre() throws SQLException {
		/*
		 * image_btn_lh / image_lh / LH
		 * image_btn_estafeta / image_estafeta / E7
		 * image_btn_qatar / image_qatar / QR
		 */
		String query = "select MA.Id, MA.Archivo, MT.Nombre as Categoria, MA.VistaPrevia from MktArchivos as MA, MktTipoArchivo as MT where MT.Id = MA.IdMktTipoArchivo";
		if(debug) { System.out.println(query); }
		return eDB.getQuery(query);
	}
	
	public ResultSet getArchivosyIdTipo() throws SQLException {
		/*
		 * image_btn_lh / image_lh / LH
		 */
		String query = "select Id, Archivo, IdMktTipoArchivo, VistaPrevia from MktArchivos";
		if(debug) { System.out.println(query); }
		return eDB.getQuery(query);
	}
	
	
	public void cerrar() throws SQLException {
		eDB.setCerrarConexion();
	}
	
}
