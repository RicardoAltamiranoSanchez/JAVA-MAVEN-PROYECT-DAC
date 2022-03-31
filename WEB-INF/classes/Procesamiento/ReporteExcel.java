package Procesamiento;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Generadores.ExcelWriter;

public class ReporteExcel extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3922646282663931177L;

	public ReporteExcel() {
		super();
	}

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

		String xml = request.getParameter("grid_xml");
		xml = URLDecoder.decode(xml, "UTF-8");
		(new ExcelWriter()).generate(xml, response);
	}

	public void init() throws ServletException {
		// Put your code here
	}

}
