package Procesamiento;
import java.io.IOException;
import java.sql.SQLException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Properties;
import java.util.Random;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Configuraciones.Generales;
import Configuraciones.Propiedades;
import Libreria.MysqlPool;
import Objetos.Empleados;
import Utilerias.Fechas;
import Utilerias.TraduccionesSQL;

import com.google.gson.Gson;

public class RecuperarCuentaServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3358434024186621425L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Empleados objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;
	private Properties props;
	private Propiedades propiedades;

	public RecuperarCuentaServlet() {
		super();
	}

	public void destroy() {
		super.destroy();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {	
		props = new Properties();
	    props.setProperty("mail.smtp.host", propiedades.getServidorCorreo());
	    props.setProperty("mail.smtp.starttls.enable", "true");
	    props.setProperty("mail.smtp.port", propiedades.getPuertoCorreo());
		try {
			if(request.getParameter("Accion").equals("recuperarCuenta")) {
				String pass = getCadenaAlfanumAleatoria(8),email = request.getParameter("Correo");
				boolean entrar = false;
				eDB.setConexion();
				resultados = eDB.getQuery("select Usuario from Usuarios where Email = '" + email + "' and (Estatus = 'ACTIVO' or Estatus = 'NUEVO')");
				objeto = new Empleados();
				while(resultados.next()) {
					objeto.setIdUsuario(resultados.getString("Usuario"));
					eDB.setQuery("update Usuarios set Password = md5('" + pass + "'), Estatus = 'NUEVO' where Usuario = '" + objeto.getIdUsuario() + "' and Email = '" + email + "'");
					entrar = true;
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				
				if(entrar){
					try{
			            // Preparamos la sesion
			            Session session = Session.getDefaultInstance(props);
			            // Construimos el mensaje
			            MimeMessage message = new MimeMessage(session);
			            message.setFrom(new InternetAddress(propiedades.getCuentaCorreo()));
			            //ciclo donde se enviaran los correos
			            message.addRecipient(Message.RecipientType.TO,new InternetAddress(email));
			            message.addRecipient(Message.RecipientType.BCC,new InternetAddress("notificacionesti@mcs-holding.com"));
			            message.setSubject("RECUPERAR CUENTA SISTEMA INTRANET");
	
			            //contenido del mensaje
			            message.setText(new java.util.Date() + "\n\n\n Los datos actuales son:\n\n"
			            		+ "\tUsuario:\t\t" + objeto.getIdUsuario()
			            		+ "\n\tPassword:\t" + pass);
			            // Lo enviamos.
			            Transport t = session.getTransport("smtp");
			            t.connect(propiedades.getCuentaCorreo(), propiedades.getPasswordCorreo());
			            t.sendMessage(message, message.getAllRecipients());
			            // Cierre.
			            t.close();
			        }catch (Exception e){
			            e.printStackTrace();
			        }
				}
				
				imprimeJson(response, objeto);
			}
		} catch(SQLException e) {
			objeto = new Empleados();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Empleados();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		}
	}

	public void init() throws ServletException {
		// Put your code here
		try {
			eDB = new MysqlPool();
			generales = new Generales();
			traducciones = new TraduccionesSQL();
			propiedades = new Propiedades();
		} catch(NamingException e) {
			System.out.println("Driver: " + e);
		}
	}
	
	private void imprimeJson(HttpServletResponse response, Empleados objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Empleados> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Empleados objeto, Exception e) {
		objeto.setError(true);
		fechas = new Fechas();
		StringBuffer log = new StringBuffer();
		log.append("Serie:");
		log.append(serialVersionUID);
		log.append(" Evento:");
		log.append(fechas.getKey());
		log.append(" ");
		System.out.print(log.toString());
		e.printStackTrace(System.out);
		log.append(e.getMessage());
		objeto.setLog(log.toString());
	}
	
	//funcion para generar pass aleatoria
			private String getCadenaAlfanumAleatoria (int longitud){
				String cadenaAleatoria = "";
				long milis = new java.util.GregorianCalendar().getTimeInMillis();
				Random r = new Random(milis);
				int i = 0;
				while ( i < longitud){
					char c = (char)r.nextInt(255);
					if ( (c >= '0' && c <='9') || (c >='A' && c <='Z') ){
						cadenaAleatoria += c;
						i ++;
					}
				}
				return cadenaAleatoria;
			}
}
/* EmpleadosServlet */