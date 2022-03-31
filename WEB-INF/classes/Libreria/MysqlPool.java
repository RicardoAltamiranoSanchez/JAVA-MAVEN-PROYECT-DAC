package Libreria;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

import javax.sql.DataSource;
import javax.sql.PooledConnection;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

public class MysqlPool {

	private Configuraciones.BaseDeDatosPool dbConf;
	
	private Connection conexion;
	private Statement sentencia;
	private DataSource datasource;
	
	private int ultimoIndice;
	
	public MysqlPool() throws NamingException {
		dbConf = new Configuraciones.BaseDeDatosPool();
		setDriver();
	}
	
	private void setDriver() throws NamingException {
		Context initContext = new InitialContext();
		Context envContext = (Context)initContext.lookup("java:/comp/env");
		datasource = (DataSource)envContext.lookup(dbConf.getDatabase());
	}
	
	public void setConexion() throws SQLException {
		conexion = datasource.getConnection();
	}
	
	public void setQuery(String accion) throws SQLException {
		sentencia = conexion.createStatement();
		sentencia.executeUpdate(accion,Statement.RETURN_GENERATED_KEYS);
		ResultSet indice = sentencia.getGeneratedKeys();
		ultimoIndice = -1;
		while(indice.next()) {
			ultimoIndice = indice.getInt(1);
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {e.printStackTrace();}
	}
	 
	public ResultSet getQuery(String accion) throws SQLException {
		sentencia = conexion.createStatement();
	    return sentencia.executeQuery(accion);
	}
			
	public void setQueryPreparado(PreparedStatement sentenciaPreparada) throws SQLException {
		sentenciaPreparada.executeUpdate();
		ResultSet indice = sentenciaPreparada.getGeneratedKeys();
		ultimoIndice = -1;
		while(indice.next()) {
		    ultimoIndice = indice.getInt(1);  
		}
		try { if(null!=indice)indice.close();} catch (SQLException e) {e.printStackTrace();}
		try { if(null!=sentenciaPreparada)sentenciaPreparada.close();} catch (SQLException e) {e.printStackTrace();}
	}
	
	public int getUltimoId() {
	    return ultimoIndice;
	}
	
	public void setCerrar(ResultSet datos) throws SQLException {
		try { if(null!=datos)datos.close();} catch (SQLException e) {e.printStackTrace();}
	}

	public void setCerrar() throws SQLException {
		try { if(null!=sentencia)sentencia.close();} catch (SQLException e) {e.printStackTrace();}
	}
	
	public void setCerrarConexion() throws SQLException {
		try { if(null!=conexion)conexion.close();} catch (SQLException e) {e.printStackTrace();}
	}
	
	public void setCerrarGlobal() {
        try { if(null!=sentencia)sentencia.close();} catch (SQLException e) {e.printStackTrace();}
        try { if(null!=conexion)conexion.close();} catch (SQLException e) {e.printStackTrace();}
	}

	public Boolean getCerrado() throws SQLException {
		return conexion.isClosed();
	}

}
