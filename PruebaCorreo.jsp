<%@ page import="Libreria.MysqlPool"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="Configuraciones.Propiedades"%>
<%@ page import="org.apache.commons.mail.DefaultAuthenticator"%>
<%@ page import="org.apache.commons.mail.Email"%>
<%@ page import="org.apache.commons.mail.EmailException"%>
<%@ page import="org.apache.commons.mail.SimpleEmail"%>
<%@ page import="org.apache.commons.mail.HtmlEmail"%>
<%
Propiedades propiedades = new Propiedades();
HtmlEmail email = new HtmlEmail();
email.setHostName(propiedades.getServidorCorreo());
email.setSmtpPort(Integer.parseInt(propiedades.getPuertoCorreo()));
email.setAuthenticator(new DefaultAuthenticator(propiedades.getCuentaCorreo(),propiedades.getPasswordCorreo()));

email.setStartTLSEnabled(true);
email.setStartTLSRequired(true);

email.addTo("rrodriguez@mcs-holding.com");
email.setFrom(propiedades.getCuentaCorreo());
email.setSubject("Solicitud de FUNCIONAMIENTO de TODO EL MUNDO");

StringBuffer mensaje = new StringBuffer();
	mensaje.append("<p> Hola<br/>");
	mensaje.append("   Robert <br/>");
	mensaje.append("<br/>");
	mensaje.append("Tienes una nueva solicitud de: LOS MORTALES <br/>");
	mensaje.append("<br/>");
	mensaje.append("Por los dias: DE SUS VACACIONES <br/>");
	mensaje.append("<br/>");
	mensaje.append("Para autorizar, entrar a Intranet -> RH -> Autorizar <br/>");
	mensaje.append("<br/> </p>");

email.setMsg(mensaje.toString());

email.send();
%>