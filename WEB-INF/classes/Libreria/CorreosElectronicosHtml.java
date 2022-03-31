package Libreria;

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpSession;

import Configuraciones.Propiedades;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.Email;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;
import org.apache.commons.mail.HtmlEmail;

public class CorreosElectronicosHtml {
	
	private Propiedades propiedades;
	private HtmlEmail email;

	public CorreosElectronicosHtml() {
		propiedades = new Propiedades();
		email = new HtmlEmail();
		email.setHostName(propiedades.getServidorCorreo());
		email.setSmtpPort(Integer.parseInt(propiedades.getPuertoCorreo()));
		email.setAuthenticator(new DefaultAuthenticator(propiedades.getCuentaCorreo(),propiedades.getPasswordCorreo()));
		
		email.setStartTLSEnabled(true);
		email.setStartTLSRequired(true);
		
		try {
			email.setFrom(propiedades.getCuentaCorreo());
		} catch (EmailException e) {
			e.printStackTrace();
		}				
	}
	
	public void setA(String[] enviarA) {
		for(String enviar: enviarA) { if(!enviar.equals("")) { try {
			email.addTo(enviar);
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} } }
	}
	
	public void setCC(String[] enviarCC) {
		for(String enviar: enviarCC) { if(!enviar.equals("")) { try {
			email.addCc(enviar);
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} } }
	}
	
	public void setBCC(String[] enviarBCC) {
		for(String enviar: enviarBCC) { if(!enviar.equals("")) {try {
			email.addBcc(enviar);
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} } }
	}
	
	public void setTitulo(String titulo) {
		email.setSubject(titulo);
	}
	
	public void setMensaje(String mensaje) {
		try {
			email.setMsg(mensaje);
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void setMensajeHtml(String mensaje) {
		try {
			email.setHtmlMsg(mensaje);
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void enviar() {
		try {
			email.send();
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void correoSolicitudVacaciones(MysqlPool eDB, String id) throws SQLException {
		ResultSet datos = eDB.getQuery("select " + 
											"replace( replace ( replace  (replace( replace (replace (E.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' ) as NombreEmpleado, E.Email as CorreoEmpleado, " + 
											"if(G.Nombre is null,'',replace( replace ( replace  (replace( replace (replace (G.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' )) as NombreGerente, if(G.Email is null,'',G.Email) as CorreoGerente, " + 
											"if(J.Nombre is null,'',replace( replace ( replace  (replace( replace (replace (J.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' )) as NombreJefe, if(J.Email is null,'',J.Email) as CorreoJefe, " +
											"V.Llave, V.Tipo " +
										"from Vacaciones as V left join Usuarios as G on (G.Id = V.Gerente) left join Usuarios as J on (J.Id = V.Jefe), Usuarios as E " + 
										"where V.Id = '" + id + "' and E.Id = V.IdUsuario");
		String[] a = new String[2];
		String[] cc = new String[1];
		String[] nombres = new String[2];
		String[] nombre = new String[1];
		String llave = "";
		String tipo = "";
		while(datos.next()) {
			a[0] = datos.getString("CorreoGerente");
			a[1] = datos.getString("CorreoJefe");
			nombres[0] = datos.getString("NombreGerente");
			nombres[1] = datos.getString("NombreJefe");
			cc[0] = datos.getString("CorreoEmpleado");
			nombre[0] = datos.getString("NombreEmpleado");
			llave = datos.getString("Llave");
			tipo = datos.getString("Tipo");
		}
		this.setA(a);
		this.setCC(cc);
		nombre[0] = nombre[0].replaceAll("Á", "A");
		nombre[0] = nombre[0].replaceAll("É", "E");
		nombre[0] = nombre[0].replaceAll("Í", "I");
		nombre[0] = nombre[0].replaceAll("Ó", "O");
		nombre[0] = nombre[0].replaceAll("Ú", "U");
		//nombre[0] = nombre[0].replaceAll("Ñ", "N");
		this.setTitulo("Solicitud de " + tipo + " de " +  nombre[0]);
		StringBuffer mensaje = new StringBuffer();
		datos = eDB.getQuery("select group_concat(Dias) as Dias from VacacionesDias where Llave = '" + llave + "'");
		nombres[0] = nombres[0].replaceAll("Á", "A");
		nombres[0] = nombres[0].replaceAll("É", "E");
		nombres[0] = nombres[0].replaceAll("Í", "I");
		nombres[0] = nombres[0].replaceAll("Ó", "O");
		nombres[0] = nombres[0].replaceAll("Ú", "U");
		nombres[0] = nombres[0].replaceAll("Ñ", "N");
		nombres[1] = nombres[1].replaceAll("Á", "A");
		nombres[1] = nombres[1].replaceAll("É", "E");
		nombres[1] = nombres[1].replaceAll("Í", "I");
		nombres[1] = nombres[1].replaceAll("Ó", "O");
		nombres[1] = nombres[1].replaceAll("Ú", "U");
		nombres[1] = nombres[1].replaceAll("Ñ", "N");
		while(datos.next()) {
			mensaje.append("<p> Hola<br/>");
			mensaje.append("   " + nombres[0] + " <br/>");
			mensaje.append("   " + nombres[1] + " <br/>");
			mensaje.append("<br/>");
			mensaje.append("Tienes una nueva solicitud de: " + nombre[0] + " <br/>");
			mensaje.append("<br/>");
			mensaje.append("Por los dias: " + datos.getString("Dias") + " <br/>");
			mensaje.append("<br/>");
			mensaje.append("Para autorizar, entrar a Intranet -> RH -> Autorizar <br/>");
			mensaje.append("<br/> </p>");
		}
		this.setMensaje(mensaje.toString());
		this.enviar();
	}
	
	public void correoRechazoVacaciones(MysqlPool eDB, String id) throws SQLException {
		ResultSet datos = eDB.getQuery("select " + 
											"replace( replace ( replace  (replace( replace (replace (E.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' ) as NombreEmpleado, E.Email as CorreoEmpleado, " + 
											"if(G.Nombre is null,'',replace( replace ( replace  (replace( replace (replace (G.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' )) as NombreGerente, if(G.Email is null,'',G.Email) as CorreoGerente, " + 
											"if(J.Nombre is null,'',replace( replace ( replace  (replace( replace (replace (J.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' )) as NombreJefe, if(J.Email is null,'',J.Email) as CorreoJefe, " +
											"V.Llave, V.Tipo " +
										"from Vacaciones as V left join Usuarios as G on (G.Id = V.Gerente) left join Usuarios as J on (J.Id = V.Jefe), Usuarios as E " + 
										"where V.Id = '" + id + "' and E.Id = V.IdUsuario");
		String[] a = new String[2];
		String[] cc = new String[1];
		String[] nombres = new String[2];
		String[] nombre = new String[1];
		String llave = "";
		String tipo = "";
		while(datos.next()) {
			a[0] = datos.getString("CorreoGerente");
			a[1] = datos.getString("CorreoJefe");
			nombres[0] = datos.getString("NombreGerente");
			nombres[1] = datos.getString("NombreJefe");
			cc[0] = datos.getString("CorreoEmpleado");
			nombre[0] = datos.getString("NombreEmpleado");
			llave = datos.getString("Llave");
			tipo = datos.getString("Tipo");
		}
		this.setA(a);
		this.setCC(cc);
		nombre[0] = nombre[0].replaceAll("Á", "A");
		nombre[0] = nombre[0].replaceAll("É", "E");
		nombre[0] = nombre[0].replaceAll("Í", "I");
		nombre[0] = nombre[0].replaceAll("Ó", "O");
		nombre[0] = nombre[0].replaceAll("Ú", "U");
		nombre[0] = nombre[0].replaceAll("Ñ", "N");
		this.setTitulo("Rechazo Solicitud de " + tipo + " de " +  nombre[0]);
		StringBuffer mensaje = new StringBuffer();
		datos = eDB.getQuery("select group_concat(Dias) as Dias from VacacionesDiasRechazados where Llave = '" + llave + "'");
		while(datos.next()) {
			mensaje.append("Hola\n");
			mensaje.append("   " + nombre[0] + "\n");
			mensaje.append("\n");
			mensaje.append("Te informamos que tu solicitud de " + tipo + " fue rechazada.\n");
			mensaje.append("\n");
			mensaje.append("Por los dias: " + datos.getString("Dias") + "\n");
			mensaje.append("\n");
			mensaje.append("Cualquier aclaracion favor de revisarlo con tu jefe inmediato.\n");
			mensaje.append("\n");
		}
		this.setMensaje(mensaje.toString());
		this.enviar();
	}
	
	public void correoAutorizacionVacaciones(MysqlPool eDB, String id) throws SQLException {
//		ANTES DIVISION INTRANET
//		ResultSet datos = eDB.getQuery("select " + 
//											"E.Nombre as NombreEmpleado, E.Email as CorreoEmpleado, " + 
//											"if(G.Nombre is null,'',G.Nombre) as NombreGerente, if(G.Email is null,'',G.Email) as CorreoGerente, " + 
//											"if(J.Nombre is null,'',J.Nombre) as NombreJefe, if(J.Email is null,'',J.Email) as CorreoJefe, " +
//											"V.Llave, V.Tipo, " +
//											"if(@1:=(select Id from Gerentes where IdUsuario = V.IdUsuario) is null,'',@1) as Gerente " +
//										"from Vacaciones as V left join Usuarios as G on (G.Id = V.Gerente) left join Usuarios as J on (J.Id = V.Jefe), Usuarios as E " + 
//										"where V.Id = '" + id + "' and E.Id = V.IdUsuario");
		
		//QUERY Y PROCESO PARA QUE LLEGUEN COPIA A PABLO DE LAS PETICIONES AUTORIZADAS DE GERENTES EN MEX
		//ResultSet datos = eDB.getQuery("select E.Nombre as NombreEmpleado, EG.Admon as Division, E.Email as CorreoEmpleado, if(G.Nombre is null,'',G.Nombre) as NombreGerente, if(G.Email is null,'',G.Email) as CorreoGerente, if(J.Nombre is null,'',J.Nombre) as NombreJefe, if(J.Email is null,'',J.Email) as CorreoJefe, V.Llave, V.Tipo, if(@1:=(select Id from Gerentes where IdUsuario = V.IdUsuario) is null,'',@1) as Gerente from Vacaciones as V left join Usuarios as G on (G.Id = V.Gerente) left join Usuarios as J on (J.Id = V.Jefe), Usuarios as E, Empleados as EM, EmpresasGrupo as EG where V.Id = '" + id + "' and E.Id = V.IdUsuario and E.Id = EM.IdUsuario and EG.Id = EM.Division");
		
//		String[] a = new String[2];
//		String[] cc = new String[2];
//		String[] nombres = new String[2];
//		String[] nombre = new String[1];
//		String llave = "";
//		String tipo = "";
//		while(datos.next()) {
//			a[0] = datos.getString("CorreoGerente");
//			a[1] = datos.getString("CorreoJefe");
//			nombres[0] = datos.getString("NombreGerente");
//			nombres[1] = datos.getString("NombreJefe");
//			cc[0] = datos.getString("CorreoEmpleado");
//			cc[1] = "";
//			if (!datos.getString("Gerente").equals("")){
//				if (datos.getString("Division").equals("MEX")){
//					cc[1]="palcocer@mcs-holding.com";
//				}
//			}
//			nombre[0] = datos.getString("NombreEmpleado");
//			llave = datos.getString("Llave");
//			tipo = datos.getString("Tipo");
//		}
		
		
		//QUERY Y PROCESO PARA QUE LLEGUEN COPIA A PABLO DE LAS PETICIONES AUTORIZADAS DE LA LISTA ESPECIFICADA POR RH EN MEX
		ResultSet datos = eDB.getQuery("select replace( replace ( replace  (replace( replace (replace (E.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' ) as NombreEmpleado, if(NP.IdUsuarios is null,'',NP.IdUsuarios) as EnLista, EG.Admon as Division, E.Email as CorreoEmpleado, if(G.Nombre is null,'',replace( replace ( replace  (replace( replace (replace (G.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' )) as NombreGerente, if(G.Email is null,'',G.Email) as CorreoGerente, if(J.Nombre is null,'',replace( replace ( replace  (replace( replace (replace (J.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' )) as NombreJefe, if(J.Email is null,'',J.Email) as CorreoJefe, V.Llave, V.Tipo, if(@1:=(select Id from Gerentes where IdUsuario = V.IdUsuario) is null,'',@1) as Gerente from Vacaciones as V left join Usuarios as G on (G.Id = V.Gerente) left join Usuarios as J on (J.Id = V.Jefe), Usuarios as E, Empleados as EM left join NotificacionesPablo as NP on (EM.IdUsuario = NP.IdUsuarios), EmpresasGrupo as EG where V.Id = '" + id + "' and E.Id = V.IdUsuario and E.Id = EM.IdUsuario and EG.Id = EM.Division");
		
		String[] a = new String[2];
		String[] cc = new String[2];
		String[] nombres = new String[2];
		String[] nombre = new String[1];
		String llave = "";
		String tipo = "";
		while(datos.next()) {
			a[0] = datos.getString("CorreoGerente");
			a[1] = datos.getString("CorreoJefe");
			nombres[0] = datos.getString("NombreGerente");
			nombres[1] = datos.getString("NombreJefe");
			cc[0] = datos.getString("CorreoEmpleado");
			cc[1] = "";
			if (!datos.getString("EnLista").equals("")){
				if (datos.getString("Division").equals("MEX")){
					cc[1]="alertaspablo@mcs-holding.com";
				}
			}
			nombre[0] = datos.getString("NombreEmpleado");
			llave = datos.getString("Llave");
			tipo = datos.getString("Tipo");
		}
		this.setA(a);
		this.setCC(cc);
		nombre[0] = nombre[0].replaceAll("Á", "A");
		nombre[0] = nombre[0].replaceAll("É", "E");
		nombre[0] = nombre[0].replaceAll("Í", "I");
		nombre[0] = nombre[0].replaceAll("Ó", "O");
		nombre[0] = nombre[0].replaceAll("Ú", "U");
		nombre[0] = nombre[0].replaceAll("Ñ", "N");
		this.setTitulo("Autorizada tu Solicitud de " + tipo + " de " +  nombre[0]);
		StringBuffer mensaje = new StringBuffer();
		datos = eDB.getQuery("select group_concat(Dias) as Dias from VacacionesDias where Llave = '" + llave + "'");
		while(datos.next()) {
			mensaje.append("Hola\n");
			mensaje.append("   " + nombre[0] + "\n");
			mensaje.append("\n");
			mensaje.append("Te informamos que tu solicitud de " + tipo + " fue autorizada.\n");
			mensaje.append("\n");
			mensaje.append("Por los dias: " + datos.getString("Dias") + "\n");
			mensaje.append("\n");
			mensaje.append("Cualquier aclaracion favor de revisarlo con tu jefe inmediato.\n");
			mensaje.append("\n");
		}
		this.setMensaje(mensaje.toString());
		this.enviar();
	}
	
	public void correoSolicitudViaticos(MysqlPool eDB, String id) throws SQLException {
		ResultSet datos = eDB.getQuery("select " + 
											"replace( replace ( replace  (replace( replace (replace (E.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' ) as NombreEmpleado, E.Email as CorreoEmpleado, " + 
											"if(G.Nombre is null,'',replace( replace ( replace  (replace( replace (replace (G.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' )) as NombreGerente, if(G.Email is null,'',G.Email) as CorreoGerente, " + 
											"'Viaticos' as Tipo " +
										"from SolicitudViaticos as V left join Usuarios as G on (G.Id = V.Gerente), Usuarios as E " + 
										"where V.Id = '" + id + "' and E.Id = V.U");
		String[] a = new String[1];
		String[] cc = new String[1];
		String[] nombres = new String[1];
		String[] nombre = new String[1];
		String tipo = "";
		while(datos.next()) {
			a[0] = datos.getString("CorreoGerente");
			nombres[0] = datos.getString("NombreGerente");
			cc[0] = datos.getString("CorreoEmpleado");
			nombre[0] = datos.getString("NombreEmpleado");
			tipo = datos.getString("Tipo");
		}
		this.setA(a);
		this.setCC(cc);
		nombre[0] = nombre[0].replaceAll("Á", "A");
		nombre[0] = nombre[0].replaceAll("É", "E");
		nombre[0] = nombre[0].replaceAll("Í", "I");
		nombre[0] = nombre[0].replaceAll("Ó", "O");
		nombre[0] = nombre[0].replaceAll("Ú", "U");
		nombre[0] = nombre[0].replaceAll("Ñ", "N");
		nombres[0] = nombres[0].replaceAll("Á", "A");
		nombres[0] = nombres[0].replaceAll("É", "E");
		nombres[0] = nombres[0].replaceAll("Í", "I");
		nombres[0] = nombres[0].replaceAll("Ó", "O");
		nombres[0] = nombres[0].replaceAll("Ú", "U");
		nombres[0] = nombres[0].replaceAll("Ñ", "N");
		this.setTitulo("Solicitud de " + tipo + " de " +  nombre[0]);
		StringBuffer mensaje = new StringBuffer();
		mensaje.append("Hola\n");
		mensaje.append("   " + nombres[0] + "\n");
		mensaje.append("\n");
		mensaje.append("Tienes una nueva solicitud de: " + nombre[0] + "\n");
		mensaje.append("\n");
		mensaje.append("Para autorizar, entrar a Intranet -> RH -> Autorizar Viaticos\n");
		mensaje.append("\n");
		this.setMensaje(mensaje.toString());
		this.enviar();
	}
	
	public void correoViaticosAutorizados(MysqlPool eDB, String id,String IdUsuario) throws SQLException {
		ResultSet datos = eDB.getQuery("select " + 
											"replace( replace ( replace  (replace( replace (replace (E.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' ) as NombreEmpleado, E.Email as CorreoEmpleado, " + 
											"if(G.Nombre is null,'',replace( replace ( replace  (replace( replace (replace (G.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' )) as NombreGerente, if(G.Email is null,'',G.Email) as CorreoGerente, " + 
											"'Viaticos' as Tipo " +
										"from SolicitudViaticos as V left join Usuarios as G on (G.Id = V.Gerente), Usuarios as E " + 
										"where V.Id = '" + id + "' and E.Id = V.U"), 
				Region = eDB.getQuery("select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '"+IdUsuario+"')");
		
		Region.next();
		String Admon = Region.getString("Admon");
		
		if (Admon == "MEX"){ 
			String[] a = new String[1];
			String[] cc = new String[2];
			String[] nombres = new String[1];
			String[] nombre = new String[2];
			String tipo = "";
			while(datos.next()) {
				a[0] = datos.getString("CorreoGerente");
				nombres[0] = datos.getString("NombreGerente");
				cc[0] = datos.getString("CorreoEmpleado");
				nombre[0] = datos.getString("NombreEmpleado");
				tipo = datos.getString("Tipo");
				
//CON ALIAS
				cc[1] = "solicitudviaticosmex@mcs-holding.com";
				nombre[1] = "Grupo Viaticos Mex";
				
//ANTES DE ALIAS
//// PRODUCTIVO
////				cc[1] = "mvasquez@mcs-holding.com";
////				nombre[1] = "Manuel Vasquez";
////				cc[2] = "ssanchez@mcs-holding.com";
////				nombre[2] = "Severo Sanchez";
////				cc[3] = "pdelgado@mcs-holding.com";
////				nombre[3] = "Pamela Delgado";
////				cc[4] = "jalvarado@mcs-holding.com";
////				nombre[4] = "Jose Luis Alvarado";
//				
//// LOCAL
//				cc[1] = "aquezada@mcs-holding.com";
//				nombre[1] = "Prueba CC1 GDL aqu� va Manuel Vasquez";
//				cc[2] = "notificacionesti@mcs-holding.com";
//				nombre[2] = "Prueba CC2 GDL aqu� va Severo Sanchez";
//				cc[3] = "notificacionesti@mcs-holding.com";
//				nombre[3] = "Prueba CC3 GDL aqu� va Pamela Delgado";
//				cc[4] = "notificacionesti@mcs-holding.com";
//				nombre[4] = "Prueba CC4 GDL aqu� va Jose Luis Alvarado";
			}
			this.setA(cc);
			this.setCC(a);
			nombre[0] = nombre[0].replaceAll("Á", "A");
			nombre[0] = nombre[0].replaceAll("É", "E");
			nombre[0] = nombre[0].replaceAll("Í", "I");
			nombre[0] = nombre[0].replaceAll("Ó", "O");
			nombre[0] = nombre[0].replaceAll("Ú", "U");
			nombre[0] = nombre[0].replaceAll("Ñ", "N");
			this.setTitulo("Autorizada solicitud de " + tipo + " de " +  nombre[0]);
			StringBuffer mensaje = new StringBuffer();
			mensaje.append("Hola\n");
			mensaje.append("   " + nombre[0] + "\n");
			mensaje.append("\n");
			mensaje.append("Te informamos que tu solicitud de " + tipo + " fue autorizada.\n");
			mensaje.append("\n");
			mensaje.append("Para descargar tu formato para Panorama da click en la siguiente liga: http://intranet.dac-cargo.com/MCSNetJDacIntra/SolicitudViaticosPdf.jsp?Id=" + id + "\n");
			mensaje.append("\n");
			mensaje.append("Cualquier aclaracion favor de revisarlo con tu jefe inmediato.\n");
			mensaje.append("\n");
			mensaje.append("\n");
			mensaje.append("\n");
			mensaje.append("-----------------------------------------------------------------\n");
			mensaje.append("Para administracion:");
			mensaje.append("Formato administrativo http://intranet.dac-cargo.com/MCSNetJDacIntra/SolicitudViaticosAdmonPdf.jsp?Id=" + id + "\n");
			mensaje.append("\n");
			mensaje.append("-----------------------------------------------------------------\n");
			
			this.setMensaje(mensaje.toString());
			this.enviar();		
		} else {
			String[] a = new String[1];
			String[] cc = new String[2];
			String[] nombres = new String[1];
			String[] nombre = new String[2];
			String tipo = "";
			while(datos.next()) {
				a[0] = datos.getString("CorreoGerente");
				nombres[0] = datos.getString("NombreGerente");
				cc[0] = datos.getString("CorreoEmpleado");
				nombre[0] = datos.getString("NombreEmpleado");
				tipo = datos.getString("Tipo");
				
//CON ALIAS
				cc[1] = "solicitudviaticosgdl@mcs-holding.com";
				nombre[1] = "Grupo Viaticos Gdl";
				
//ANTES DE ALIAS		
//// PRODUCTIVO
////				cc[1] = "ralessi@mcs-holding.com";
////				nombre[1] = "Roberto Alessi";
////				cc[2] = "ebravo@mcs-holding.com";
////				nombre[2] = "Ernesto Bravo";
//				
//// LOCAL
//				cc[1] = "aquezada@mcs-holding.com";
//				nombre[1] = "Prueba CC1 GDL aqu� va Roberto Alessi";
//				cc[2] = "notificacionesti@mcs-holding.com";
//				nombre[2] = "Prueba CC2 GDL aqu� va Ernesto Bravo";
			}
			this.setA(cc);
			this.setCC(a);
			nombre[0] = nombre[0].replaceAll("Á", "A");
			nombre[0] = nombre[0].replaceAll("É", "E");
			nombre[0] = nombre[0].replaceAll("Í", "I");
			nombre[0] = nombre[0].replaceAll("Ó", "O");
			nombre[0] = nombre[0].replaceAll("Ú", "U");
			nombre[0] = nombre[0].replaceAll("Ñ", "N");
			this.setTitulo("Autorizada solicitud de " + tipo + " de " +  nombre[0]);
			StringBuffer mensaje = new StringBuffer();
			mensaje.append("Hola\n");
			mensaje.append("   " + nombre[0] + "\n");
			mensaje.append("\n");
			mensaje.append("Te informamos que tu solicitud de " + tipo + " fue autorizada.\n");
			mensaje.append("\n");
			mensaje.append("Para descargar tu formato para Panorama da click en la siguiente liga: http://intranet.dac-cargo.com/MCSNetJDacIntra/SolicitudViaticosPdf.jsp?Id=" + id + "\n");
			mensaje.append("\n");
			mensaje.append("Cualquier aclaracion favor de revisarlo con tu jefe inmediato.\n");
			mensaje.append("\n");
			mensaje.append("\n");
			mensaje.append("\n");
			mensaje.append("-----------------------------------------------------------------\n");
			mensaje.append("Para administracion:");
			mensaje.append("Formato administrativo http://intranet.dac-cargo.com/MCSNetJDacIntra/SolicitudViaticosAdmonPdf.jsp?Id=" + id + "\n");
			mensaje.append("\n");
			mensaje.append("-----------------------------------------------------------------\n");
			
			this.setMensaje(mensaje.toString());
			this.enviar();
		}
		
	}
	
	public void correoViaticosRechazados(MysqlPool eDB, String id) throws SQLException {
		ResultSet datos = eDB.getQuery("select " + 
											"replace( replace ( replace  (replace( replace (replace (E.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' ) as NombreEmpleado, E.Email as CorreoEmpleado, " + 
											"if(G.Nombre is null,'',replace( replace ( replace  (replace( replace (replace (G.Nombre, 'Ñ','N'), 'Á', 'A' ), 'É', 'E' ), 'Í', 'I' ), 'Ó', 'O' ), 'Ú', 'U' )) as NombreGerente, if(G.Email is null,'',G.Email) as CorreoGerente, " + 
											"'Viaticos' as Tipo " +
										"from SolicitudViaticos as V left join Usuarios as G on (G.Id = V.Gerente), Usuarios as E " + 
										"where V.Id = '" + id + "' and E.Id = V.U");
		String[] a = new String[1];
		String[] cc = new String[1];
		String[] nombres = new String[1];
		String[] nombre = new String[1];
		String tipo = "";
		while(datos.next()) {
			a[0] = datos.getString("CorreoGerente");
			nombres[0] = datos.getString("NombreGerente");
			cc[0] = datos.getString("CorreoEmpleado");
			nombre[0] = datos.getString("NombreEmpleado");
			tipo = datos.getString("Tipo");
		}
		this.setA(cc);
		this.setCC(a);
		nombre[0] = nombre[0].replaceAll("Á", "A");
		nombre[0] = nombre[0].replaceAll("É", "E");
		nombre[0] = nombre[0].replaceAll("Í", "I");
		nombre[0] = nombre[0].replaceAll("Ó", "O");
		nombre[0] = nombre[0].replaceAll("Ú", "U");
		nombre[0] = nombre[0].replaceAll("Ñ", "N");
		this.setTitulo("Rechazada tu solicitud de " + tipo + " de " +  nombre[0]);
		StringBuffer mensaje = new StringBuffer();
		mensaje.append("Hola\n");
		mensaje.append("   " + nombre[0] + "\n");
		mensaje.append("\n");
		mensaje.append("Te informamos que tu solicitud de " + tipo + " fue rechazada.\n");
		mensaje.append("\n");
		mensaje.append("Cualquier aclaracion favor de revisarlo con tu jefe inmediato.\n");
		mensaje.append("\n");
		this.setMensaje(mensaje.toString());
		this.enviar();
	}
	
}
