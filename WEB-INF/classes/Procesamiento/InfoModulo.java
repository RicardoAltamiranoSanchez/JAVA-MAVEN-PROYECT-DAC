package Procesamiento;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Configuraciones.Generales;
import Validacion.ConMysql;
import Html.Idioma;

public class InfoModulo extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6064440874923378370L;
	private HttpSession session;
	private Generales generales;
	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		validar(request,response);
		
		try {
			ConMysql valida = new ConMysql();
			session = request.getSession();
			//if(valida.existeLicencia(session.getAttribute("IdUsuario").toString(),session.getAttribute("Licencia").toString())) {
				session.setAttribute("Accion","Guardar");
				session.setAttribute("Mensaje","");
				session.setAttribute("BuscadorCampo", "");
				session.setAttribute("BuscadorCampo1", "");
				session.setAttribute("BuscadorValor", "");
				session.setAttribute("BuscadorValor1", "");
				session.setAttribute("Seccion", request.getParameter("Seccion"));
				session.setAttribute("Modulo", request.getParameter("Modulo"));
				session.setAttribute("IdModulos", request.getParameter("IdModulos"));
				
				if(!request.getParameter("Seccion").equals("Salir")) {
					Idioma idioma = new Idioma();
					session.setAttribute(request.getParameter("IdModulos"), idioma.getLenguaje(request.getParameter("IdModulos"), session.getAttribute("Idioma").toString()));
				}
				
				try {
					response.sendRedirect("/" + generales.getDirectorio() + "/" + request.getParameter("Link"));
				} catch(IllegalStateException e) {
					e.printStackTrace(System.out);
					response.setHeader("Location","/" + generales.getDirectorio() + "/logout.jsp");
				}
			//} else {
			//	response.sendRedirect("/" + generales.getDirectorio() + "/logout.jsp?1000");
			//}
		} catch(Exception e123) {
			e123.printStackTrace(System.out);
			response.setHeader("Location","/" + generales.getDirectorio() + "/logout.jsp");
		}
	}
	
	public void init() throws ServletException {
		// Put your code here
		generales = new Generales();
	}
	
	private void validar(HttpServletRequest request, HttpServletResponse response) throws IOException {
		session = request.getSession();
		try {
			try {
				session.getAttribute("Usuario").equals("");
				if(session.getAttribute("Usuario").equals("")) {
					response.sendRedirect("/" + generales.getDirectorio() + "/logout.jsp?1");
				}
			} catch(NullPointerException e) {
				response.sendRedirect("/" + generales.getDirectorio() + "/logout.jsp?2");
			}
		} catch(IllegalStateException e) {
			response.setHeader("Location","/" + generales.getDirectorio() + "/logout.jsp?3");
		}
	}

}
