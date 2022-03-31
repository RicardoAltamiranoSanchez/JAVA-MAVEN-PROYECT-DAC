package Html;

import Configuraciones.Parametros;

public class EncabezadoPie {

	private static StringBuffer out;
	
	public static String getEncabezado(String titulo) {
		out = new StringBuffer();
		out.append("<!doctype html>\n");
		out.append("<html>\n");
		out.append("<head>\n");
		out.append("	<title>" + titulo + "</title>\n");
		out.append("	<meta http-equiv=\"pragma\" content=\"no-cache\">\n");
		out.append("	<meta http-equiv=\"cache-control\" content=\"no-cache\">\n");
		out.append("	<meta http-equiv=\"expires\" content=\"0\">\n");
		out.append("	<link rel=\"stylesheet\" href=\"css/webix.css\" type=\"text/css\"> \n");
		out.append("	<script src=\"js/webix.js\" type=\"text/javascript\"></script>\n");
		out.append("</head>\n");
		out.append("<body>\n");
		return out.toString();
	}
	
	public static String getEncabezado() {
		out = new StringBuffer();
		out.append("<!doctype html>\n");
		out.append("<html>\n");
		out.append("<head>\n");
		out.append("	<title>" + Parametros.TITULO + "</title>\n");
		out.append("	<meta http-equiv=\"pragma\" content=\"no-cache\">\n");
		out.append("	<meta http-equiv=\"cache-control\" content=\"no-cache\">\n");
		out.append("	<meta http-equiv=\"expires\" content=\"0\">\n");
		out.append("	<link rel=\"stylesheet\" href=\"css/webix.css\" type=\"text/css\"> \n");
		out.append("	<script src=\"js/webix345.js\" type=\"text/javascript\"></script>\n");
		out.append("</head>\n");
		out.append("<body>\n");
		return out.toString();
	}
	
	public static String getEncabezadoWebix503() {
		out = new StringBuffer();
		out.append("<!doctype html>\n");
		out.append("<html>\n");
		out.append("<head>\n");
		out.append("	<title></title>\n");
		out.append("	<meta http-equiv=\"pragma\" content=\"no-cache\">\n");
		out.append("	<meta http-equiv=\"cache-control\" content=\"no-cache\">\n");
		out.append("	<meta http-equiv=\"expires\" content=\"0\">\n");
		out.append("	<link rel=\"stylesheet\" href=\"codebase/webix.css\" type=\"text/css\"> \n");
		out.append("	<script src=\"codebase/webix.js\" type=\"text/javascript\"></script>\n");
		out.append("</head>\n");
		out.append("<body>\n");
		return out.toString();
	}
	
	public static String getEncabezadoPrototype(String titulo) {
		out = new StringBuffer();
		out.append("<!DOCTYPE html>\n");
		out.append("<html>\n");
		out.append("<head>\n");
		out.append("<title>" + titulo + "</title>\n");
		out.append("<meta http-equiv=\"pragma\" content=\"no-cache\">\n");
		out.append("<meta http-equiv=\"cache-control\" content=\"no-cache\">\n");
		out.append("<meta http-equiv=\"expires\" content=\"0\">\n");
		out.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\">\n");	
		out.append("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n");
		out.append("<link rel=\"shortcut icon\" href=\"images/favicon.ico\">\n");
		out.append("<script src=\"js/prototype.js\"></script>\n");
		out.append("</head>\n");
		return out.toString();
	}

	public static String getPie() {
		out = new StringBuffer();
		out.append("</body>\n");
		out.append("</html>\n");
		return out.toString();
	}
}
