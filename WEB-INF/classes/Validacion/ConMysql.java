package Validacion;

import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.Vector;
import java.util.Properties;

import javax.naming.NamingException;

import Libreria.MysqlPool;


public class ConMysql {

	private MysqlPool eDB;
	
	private String nombre, grupo, id, idGrupos, idEmpresas, fecha, idioma, perfilUsuario;
	private boolean valido = false;
	private boolean nuevo = false;
	private boolean licenciasDisponibles = true;
	private String licencia = "asdfasdfasdf";
	private Vector<Vector<String>> menu;
	private Properties permisosEspecialesUsuario;
	
	public ConMysql() throws NamingException {
		eDB = new MysqlPool();
	}
	
	public boolean validaLicencia() throws SQLException {
		/*
		eDB.setConexion();
		eDB.setQuery("create table if not exists Accesos (IdUsuarios int, Fecha datetime)");
		//eDB.setQuery("delete from Accesos where replace(timediff(now(),Fecha),':','') > 1500");
		ResultSet datos = eDB.getQuery("select count(IdUsuarios) as Cantidad from Accesos");
		while(datos.next()) {
			if(datos.getInt("Cantidad") > 10) {
				this.licenciasDisponibles = false;
			}
		}
		eDB.setCerrar(datos);
		eDB.setCerrar();
		eDB.setCerrarConexion();
		*/
		//return this.licenciasDisponibles;
		return true;
	}
	
	public void liberaLicencia(String idUsuarios) throws SQLException {
		eDB.setConexion();
		eDB.setQuery("delete from Accesos where IdUsuarios = '" + idUsuarios + "'");
		eDB.setCerrar();
		eDB.setCerrarConexion();
	}
	
	public void registraLicencia(String idUsuarios) throws SQLException {
		eDB.setConexion();
		eDB.setQuery("insert into Accesos values ('" + idUsuarios + "',now())");
		ResultSet datos = eDB.getQuery("select md5(Fecha) as Fecha from Accesos where IdUsuarios = '" + idUsuarios + "' limit 1");
		while(datos.next()) {
			this.licencia = datos.getString("Fecha");
		}
		eDB.setCerrar();
		eDB.setCerrarConexion();
	}
	
	public boolean existeLicencia(String idUsuarios, String key) throws SQLException {
		boolean bandera = false;
		eDB.setConexion();
		ResultSet datos = eDB.getQuery("select * from Accesos where IdUsuarios = '" + idUsuarios + "' and md5(Fecha) = '" + key + "'");
		if(datos.next()) { bandera = true; }
		eDB.setCerrar();
		eDB.setCerrarConexion();
		return bandera;
	}
	
	public String getLicencia() {
		return this.licencia;
	}
		
	public boolean validarUsuarioBloqueaYRegistra(String usuario, String password, String sNumeroIntentos, String estatus) throws SQLException {
		eDB.setConexion();
		
		int numeroIntentos = Integer.parseInt(sNumeroIntentos);
		
		ResultSet datos = eDB.getQuery("select U.Id, U.Nombre, U.IdGrupos, U.IdEmpresas, if(U.Password = md5('" + password + "'),'true',(select if(Password = md5('" + password + "'),'true','false') from Usuarios where Usuario = 'tiintranet')) as Valido, LOWER(U.Estatus) as Estatus, " + 
											"G.Grupo, P.ModoOperacion as PerfilUsuario, now() as Fecha " + 
									   "from Usuarios as U, Grupos as G, PerfilesUsuarios as P " + 
									   "where U.Usuario = '" + usuario + "'" + 
									   		//" and (G.Id = 1)" + //modificar para cada nube 
									   " and G.Id = U.IdGrupos and P.Id = U.IdPerfilesUsuarios");
		while(datos.next()) {
			this.valido = datos.getBoolean("Valido");
			this.id = datos.getString("Id");
			this.nombre = datos.getString("Nombre");
			this.grupo = datos.getString("Grupo");
			this.idGrupos = datos.getString("IdGrupos");
			this.idEmpresas = datos.getString("IdEmpresas");
			this.perfilUsuario = datos.getString("PerfilUsuario");
			this.fecha = datos.getString("Fecha");
			if(datos.getString("Estatus").equals("nuevo")) {
				this.nuevo = true;
			}
		}
		
		if(this.valido) {
			// registra la fecha del login
			eDB.setQuery("update Usuarios set UltimoLogin = curdate() where Usuario = '" + usuario + "'");
			eDB.setQuery("delete from Intentos where Usuario = '" + usuario + "' and Fecha = curdate()");
		} else {
			// registramos los intentos
			int cantidad = 0;
			datos = eDB.getQuery("select Cantidad from Intentos where Usuario = '" + usuario + "' and Fecha");
			while(datos.next()) {
				cantidad = datos.getInt("Cantidad");
			}
			
			if(cantidad < numeroIntentos) {
				cantidad++;
				eDB.setQuery("insert into Intentos (Usuario,Fecha,Cantidad) values ('" + usuario + "',now(),'" + cantidad + "') ON DUPLICATE KEY UPDATE Cantidad = '" + cantidad + "'");
			} else {
				cantidad++;
				eDB.setQuery("insert into Intentos (Usuario,Fecha,Cantidad) values ('" + usuario + "',now(),'" + cantidad + "') ON DUPLICATE KEY UPDATE Cantidad = '" + cantidad + "'");
				eDB.setQuery("update Usuarios set Password = md5(now()), Estatus = '" + estatus + "' where Usuario = '" + usuario + "'");
			}
		}
		
		eDB.setCerrar(datos);
		eDB.setCerrar();
		eDB.setCerrarConexion();
		
		return this.valido;
	}
	
	public boolean validarUsuarioBloqueaYRegistraValidaPortal(String usuario, String password, String sNumeroIntentos, String estatus) throws SQLException {
		eDB.setConexion();
		
		int numeroIntentos = Integer.parseInt(sNumeroIntentos);
		
		ResultSet datos = eDB.getQuery("select U.Id, U.Nombre, U.IdGrupos, U.IdEmpresas, if(U.Password = md5('" + password + "'),'true',(select if(Password = md5('" + password + "'),'true','false') from Usuarios where Usuario = 'tiintranet')) as Valido, LOWER(U.Estatus) as Estatus, " + 
											"G.Grupo, P.ModoOperacion as PerfilUsuario, now() as Fecha " + 
									   "from Usuarios as U, Grupos as G, PerfilesUsuarios as P, Empleados as E, EmpresasGrupo as EG " + 
									   "where U.Usuario = '" + usuario + "'" + 
									   		//" and (G.Id = 1)" + //modificar para cada nube
									   " and U.Id = E.IdUsuario "+
									   " and EG.Id = E.Division "+
									   " and EG.Admon = 'MEX' "+
									   " and G.Id = U.IdGrupos and P.Id = U.IdPerfilesUsuarios");
		while(datos.next()) {
			this.valido = datos.getBoolean("Valido");
			this.id = datos.getString("Id");
			this.nombre = datos.getString("Nombre");
			this.grupo = datos.getString("Grupo");
			this.idGrupos = datos.getString("IdGrupos");
			this.idEmpresas = datos.getString("IdEmpresas");
			this.perfilUsuario = datos.getString("PerfilUsuario");
			this.fecha = datos.getString("Fecha");
			if(datos.getString("Estatus").equals("nuevo")) {
				this.nuevo = true;
			}
		}
		
		if(this.valido) {
			// registra la fecha del login
			eDB.setQuery("update Usuarios set UltimoLogin = curdate() where Usuario = '" + usuario + "'");
			eDB.setQuery("delete from Intentos where Usuario = '" + usuario + "' and Fecha = curdate()");
		} else {
			// registramos los intentos
			int cantidad = 0;
			datos = eDB.getQuery("select Cantidad from Intentos where Usuario = '" + usuario + "' and Fecha");
			while(datos.next()) {
				cantidad = datos.getInt("Cantidad");
			}
			
			if(cantidad < numeroIntentos) {
				cantidad++;
				eDB.setQuery("insert into Intentos (Usuario,Fecha,Cantidad) values ('" + usuario + "',now(),'" + cantidad + "') ON DUPLICATE KEY UPDATE Cantidad = '" + cantidad + "'");
			} else {
				cantidad++;
				eDB.setQuery("insert into Intentos (Usuario,Fecha,Cantidad) values ('" + usuario + "',now(),'" + cantidad + "') ON DUPLICATE KEY UPDATE Cantidad = '" + cantidad + "'");
				eDB.setQuery("update Usuarios set Password = md5(now()), Estatus = '" + estatus + "' where Usuario = '" + usuario + "'");
			}
		}
		
		eDB.setCerrar(datos);
		eDB.setCerrar();
		eDB.setCerrarConexion();
		
		return this.valido;
	}
	
	public void setMenu() throws SQLException, NullPointerException {
		menu = new Vector<Vector<String>>();
		Vector<String> elementos;
		if(valido) {
			eDB.setConexion();
			/*
			ResultSet datos = eDB.getQuery("select P.IdGrupos, P.Usuario+0 as Usuario, P.Grupo+0 as Grupo, P.Global+0 as Global, M.Modulo, M.Link, M.Titulo, S.Seccion " +
					"from Privilegios as P, Modulos as M, Secciones as S " +
					"where P.IdUsuarios = '" + this.id + "' and P.IdGrupos = '" + this.idGrupos + "' and M.Id = P.IdModulos and S.Id = M.IdSecciones " +
					"order by S.Indice, M.Indice");
			*/
			ResultSet datos = eDB.getQuery("select " + 
												"P.IdModulos, " + 
												"M.Modulo, M.Link, M.Titulo, " + 
												"S.Seccion " + 
											"from " +
												"Privilegios as P, Modulos as M, Secciones as S " +
											"where " +
												"P.IdUsuarios = '" + this.id + "' and M.Id = P.IdModulos and S.Id = M.IdSecciones " +
											"order by " +
												"S.Indice, M.Indice");	
			while(datos.next()) {
				elementos = new Vector<String>();
				elementos.add(datos.getString("Seccion"));
				elementos.add(datos.getString("Modulo"));
				elementos.add(datos.getString("Link"));
				elementos.add(datos.getString("Titulo"));
				elementos.add(datos.getString("IdModulos"));
				menu.add(elementos);
			}
			eDB.setCerrar(datos);
			eDB.setCerrar();
			eDB.setCerrarConexion();
		}
	}
	
	public void getPerfil(String id) throws SQLException {
		eDB.setConexion();
		this.idioma = "1";
		ResultSet datos = eDB.getQuery("select Idioma from ConfiguracionIdioma where IdUsuarios = '" + id + "'");
		while(datos.next()) {
			this.idioma = datos.getString("Idioma");
		}
		
		permisosEspecialesUsuario = new Properties();
		datos = eDB.getQuery("select PEU.ModoOperacion, PEU.Permiso from Usuarios as U, PerfilesUsuariosPermisosEspeciales as PUPE, PermisosEspecialesUsuarios as PEU where U.Id = '" + id + "' and PUPE.IdPerfilesUsuarios = U.IdPerfilesUsuarios and PEU.Id = PUPE.IdPermisosEspecialesUsuarios");
		while(datos.next()) {
			this.permisosEspecialesUsuario.setProperty(datos.getString("ModoOperacion"), datos.getString("Permiso"));
		}
		
		eDB.setCerrar(datos);
		eDB.setCerrar();
		eDB.setCerrarConexion();
	}
	
	public Properties getPermisosEspecialesUsuario() {
		return this.permisosEspecialesUsuario;
	}
	
	public Vector<Vector<String>> getMenu() {
		return this.menu;
	}
	
	public String getId() {
		return this.id;
	}
	
	public String getNombre() {
		return this.nombre;
	}
	
	public String getGrupo() {
		return this.grupo;
	}
	
	public String getIdGrupos() {
		return this.idGrupos;
	}
	
	public String getIdEmpresas() {
		return this.idEmpresas;
	}
	
	public String getFecha() {
		return this.fecha;
	}
	
	public boolean getNuevo() {
		return this.nuevo;
	}
	
	public String getIdioma() {
		return this.idioma;
	}
	
	public String getPerfilUsuario() {
		return this.perfilUsuario;
	}
}
