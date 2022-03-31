package Procesamiento;

import java.io.IOException;
import java.io.PrintWriter;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Configuraciones.Generales;
import Validacion.ConMysql;

import java.sql.SQLException;

import Html.Idioma;

public class Login extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1680403450581512173L;
	private HttpSession session;
	private Generales generales;
	
	/**
	 * Constructor of the object.
	 */
	public Login() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request,response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		
		try {
			request.getParameter("Usuario").equals("");
			ConMysql validar = new ConMysql();
			
			try {
				request.getParameter("BloqueaYRegistra");
				
				if(validar.validaLicencia()) {	
					if(validar.validarUsuarioBloqueaYRegistraValidaPortal(request.getParameter("Usuario"), request.getParameter("Password"), request.getParameter("NumeroIntentos"), request.getParameter("Estatus"))) {
						validar.setMenu();
						session = request.getSession();
						session.setAttribute("Usuario", request.getParameter("Usuario"));
						session.setAttribute("NombreUsuario", validar.getNombre());
						session.setAttribute("GrupoUsuario", validar.getGrupo());
						session.setAttribute("IdUsuario", validar.getId());
						session.setAttribute("IdGrupos", validar.getIdGrupos());
						session.setAttribute("IdEmpresas", validar.getIdEmpresas());
						session.setAttribute("FechaEntrada", validar.getFecha());
						session.setAttribute("Menu", validar.getMenu());
						session.setAttribute("PerfilUsuario", validar.getPerfilUsuario());
						validar.registraLicencia(validar.getId());
						session.setAttribute("Licencia", validar.getLicencia());
						
						validar.getPerfil(validar.getId());
						session.setAttribute("Idioma", validar.getIdioma());
						session.setAttribute("PermisosEspecialesUsuario", validar.getPermisosEspecialesUsuario());
						
						Idioma idioma = new Idioma();
						session.setAttribute("IdiomaGeneral", idioma.getGenerales(validar.getIdioma()));
						
						
						if(validar.getNuevo()) {
							out.println("{\"Valido\":true,\"Archivo\":\"Password.jsp?Estatus=Nuevo\"}");
						} else {
							out.println("{\"Valido\":true,\"Archivo\":\"sistema.jsp\"}");
						}
					} else {
						out.println("{\"Valido\":true,\"Archivo\":\"index.jsp?Mensaje=Usuario o Password Incorrecto\"}");
					}
				} else {
					out.println("{\"Valido\":true,\"Archivo\":\"index.jsp?Mensaje=Licencias no disponibles\"}");
				}
				
			} catch(NullPointerException e1) {
				
			}
		}
		catch(NullPointerException e) {
			e.printStackTrace(System.out);
			out.println("{\"Valido\":true,\"Archivo\":\"index.jsp\"}");
		}
		catch(SQLException e) {
			e.printStackTrace(System.out);
			out.println("{\"Valido\":true,\"Archivo\":\"index.jsp?Mensaje=Error de Base de datos:" + e + "\"}");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace(System.out);
			out.println("{\"Valido\":true,\"Archivo\":\"index.jsp\"}");
		}
		
		
		
	}

	public void init() throws ServletException {
		// Put your code here
		generales = new Generales();
	}

}
