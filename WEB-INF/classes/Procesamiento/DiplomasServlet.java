package Procesamiento;
import java.io.IOException;
import java.sql.SQLException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Configuraciones.Generales;
import Libreria.MysqlPool;
import Utilerias.Fechas;
import Utilerias.TraduccionesSQL;
import Objetos.Diplomas;

import com.google.gson.Gson;

public class DiplomasServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5600384900209120589L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Diplomas objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public DiplomasServlet() {
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
		request.setCharacterEncoding("UTF-8");
		validar(request,response);
		
		try {
			if(request.getParameter("Accion").equals("Guardar")) {
				eDB.setConexion();
				eDB.setQuery("insert into Diplomas (U,G,E,Tipo,NombreAlumno,NombreCurso,DescripcionCurso,NombreEmpresa,Imparticion,Certificado,ResponsableUno,PuestoResponsableUno,ResponsableDos,PuestoResponsableDos,Titulo) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + request.getParameter("Tipo") + "','" + request.getParameter("NombreAlumno") + "','" + request.getParameter("NombreCurso") + "','" + request.getParameter("DescripcionCurso") + "','" + request.getParameter("NombreEmpresa") + "','" + request.getParameter("Imparticion") + "','" + traducciones.getEntero(request.getParameter("Certificado")) + "','" + request.getParameter("ResponsableUno") + "','" + request.getParameter("PuestoResponsableUno") + "','" + request.getParameter("ResponsableDos") + "','" + request.getParameter("PuestoResponsableDos") + "','" + request.getParameter("Titulo") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into DiplomasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Tipo,NombreAlumno,NombreCurso,DescripcionCurso,NombreEmpresa,Imparticion,Certificado,ResponsableUno,PuestoResponsableUno,ResponsableDos,PuestoResponsableDos,Titulo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Tipo,NombreAlumno,NombreCurso,DescripcionCurso,NombreEmpresa,Imparticion,Certificado,ResponsableUno,PuestoResponsableUno,ResponsableDos,PuestoResponsableDos,Titulo from Diplomas where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Diplomas();
				objeto.setId(ultimoId);
				objeto.setTipo(request.getParameter("Tipo"));
				objeto.setNombreAlumno(request.getParameter("NombreAlumno"));
				objeto.setNombreCurso(request.getParameter("NombreCurso"));
				objeto.setDescripcionCurso(request.getParameter("DescripcionCurso"));
				objeto.setNombreEmpresa(request.getParameter("NombreEmpresa"));
				objeto.setImparticion(request.getParameter("Imparticion"));
				objeto.setCertificado(request.getParameter("Certificado"));
				objeto.setResponsableUno(request.getParameter("ResponsableUno"));
				objeto.setPuestoResponsableUno(request.getParameter("PuestoResponsableUno"));
				objeto.setResponsableDos(request.getParameter("ResponsableDos"));
				objeto.setPuestoResponsableDos(request.getParameter("PuestoResponsableDos"));
				objeto.setTitulo(request.getParameter("Titulo"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Diplomas();
				objeto.setTipo(request.getParameter("Tipo"));
				objeto.setNombreAlumno(request.getParameter("NombreAlumno"));
				objeto.setNombreCurso(request.getParameter("NombreCurso"));
				objeto.setDescripcionCurso(request.getParameter("DescripcionCurso"));
				objeto.setNombreEmpresa(request.getParameter("NombreEmpresa"));
				objeto.setImparticion(request.getParameter("Imparticion"));
				objeto.setCertificado(request.getParameter("Certificado"));
				objeto.setResponsableUno(request.getParameter("ResponsableUno"));
				objeto.setPuestoResponsableUno(request.getParameter("PuestoResponsableUno"));
				objeto.setResponsableDos(request.getParameter("ResponsableDos"));
				objeto.setPuestoResponsableDos(request.getParameter("PuestoResponsableDos"));
				objeto.setTitulo(request.getParameter("Titulo"));

				if(!objeto.getTipo().equals("")) { where.append(" and A.Tipo like '" + objeto.getTipo() + "%'"); entro = true;}
				if(!objeto.getNombreAlumno().equals("")) { where.append(" and A.NombreAlumno like '" + objeto.getNombreAlumno() + "%'"); entro = true;}
				if(!objeto.getNombreCurso().equals("")) { where.append(" and A.NombreCurso like '" + objeto.getNombreCurso() + "%'"); entro = true;}
				if(!objeto.getDescripcionCurso().equals("")) { where.append(" and A.DescripcionCurso like '" + objeto.getDescripcionCurso() + "%'"); entro = true;}
				if(!objeto.getNombreEmpresa().equals("")) { where.append(" and A.NombreEmpresa like '" + objeto.getNombreEmpresa() + "%'"); entro = true;}
				if(!objeto.getImparticion().equals("")) { where.append(" and A.Imparticion like '" + objeto.getImparticion() + "%'"); entro = true;}
				if(!objeto.getCertificado().equals("")) { where.append(" and A.Certificado like '" + objeto.getCertificado() + "%'"); entro = true;}
				if(!objeto.getResponsableUno().equals("")) { where.append(" and A.ResponsableUno like '" + objeto.getResponsableUno() + "%'"); entro = true;}
				if(!objeto.getPuestoResponsableUno().equals("")) { where.append(" and A.PuestoResponsableUno like '" + objeto.getPuestoResponsableUno() + "%'"); entro = true;}
				if(!objeto.getResponsableDos().equals("")) { where.append(" and A.ResponsableDos like '" + objeto.getResponsableDos() + "%'"); entro = true;}
				if(!objeto.getPuestoResponsableDos().equals("")) { where.append(" and A.PuestoResponsableDos like '" + objeto.getPuestoResponsableDos() + "%'"); entro = true;}
				if(!objeto.getTitulo().equals("")) { where.append(" and A.Titulo like '" + objeto.getTitulo() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from Diplomas as A" + whereInicio + where.toString());
				ArrayList<Diplomas> info = new ArrayList<Diplomas>();
				while(resultados.next()) {
					objeto = new Diplomas();
					objeto.setId(resultados.getInt("Id"));
					objeto.setTipo(resultados.getString("Tipo"));
					objeto.setNombreAlumno(resultados.getString("NombreAlumno"));
					objeto.setNombreCurso(resultados.getString("NombreCurso"));
					objeto.setDescripcionCurso(resultados.getString("DescripcionCurso"));
					objeto.setNombreEmpresa(resultados.getString("NombreEmpresa"));
					objeto.setImparticion(resultados.getString("Imparticion"));
					objeto.setCertificado(resultados.getString("Certificado"));
					objeto.setResponsableUno(resultados.getString("ResponsableUno"));
					objeto.setPuestoResponsableUno(resultados.getString("PuestoResponsableUno"));
					objeto.setResponsableDos(resultados.getString("ResponsableDos"));
					objeto.setPuestoResponsableDos(resultados.getString("PuestoResponsableDos"));
					objeto.setTitulo(resultados.getString("Titulo"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("Borrar")) {
				eDB.setConexion();
				String ids = request.getParameter("Ids");
				String[] id = ids.split(",");
				for(int i = 0; i < id.length; i++) {
					if(!id[i].equals("")) {
						eDB.setQuery("insert into DiplomasApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Tipo,NombreAlumno,NombreCurso,DescripcionCurso,NombreEmpresa,Imparticion,Certificado,ResponsableUno,PuestoResponsableUno,ResponsableDos,PuestoResponsableDos,Titulo) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Tipo,NombreAlumno,NombreCurso,DescripcionCurso,NombreEmpresa,Imparticion,Certificado,ResponsableUno,PuestoResponsableUno,ResponsableDos,PuestoResponsableDos,Titulo from Diplomas where Id = '" + id[i] + "'");
						eDB.setQuery("delete from Diplomas where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Diplomas();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from Diplomas as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new Diplomas();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setTipo(resultados.getString("Tipo"));
					objeto.setNombreAlumno(resultados.getString("NombreAlumno"));
					objeto.setNombreCurso(resultados.getString("NombreCurso"));
					objeto.setDescripcionCurso(resultados.getString("DescripcionCurso"));
					objeto.setNombreEmpresa(resultados.getString("NombreEmpresa"));
					objeto.setImparticion(resultados.getString("Imparticion"));
					objeto.setCertificado(resultados.getString("Certificado"));
					objeto.setResponsableUno(resultados.getString("ResponsableUno"));
					objeto.setPuestoResponsableUno(resultados.getString("PuestoResponsableUno"));
					objeto.setResponsableDos(resultados.getString("ResponsableDos"));
					objeto.setPuestoResponsableDos(resultados.getString("PuestoResponsableDos"));
					objeto.setTitulo(resultados.getString("Titulo"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update Diplomas set Tipo='" + request.getParameter("Tipo") + "',NombreAlumno='" + request.getParameter("NombreAlumno") + "',NombreCurso='" + request.getParameter("NombreCurso") + "',DescripcionCurso='" + request.getParameter("DescripcionCurso") + "',NombreEmpresa='" + request.getParameter("NombreEmpresa") + "',Imparticion='" + request.getParameter("Imparticion") + "',Certificado='" + traducciones.getEntero(request.getParameter("Certificado")) + "',ResponsableUno='" + request.getParameter("ResponsableUno") + "',PuestoResponsableUno='" + request.getParameter("PuestoResponsableUno") + "',ResponsableDos='" + request.getParameter("ResponsableDos") + "',PuestoResponsableDos='" + request.getParameter("PuestoResponsableDos") + "',Titulo='" + request.getParameter("Titulo") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into DiplomasApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Tipo,NombreAlumno,NombreCurso,DescripcionCurso,NombreEmpresa,Imparticion,Certificado,ResponsableUno,PuestoResponsableUno,ResponsableDos,PuestoResponsableDos,Titulo) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Tipo,NombreAlumno,NombreCurso,DescripcionCurso,NombreEmpresa,Imparticion,Certificado,ResponsableUno,PuestoResponsableUno,ResponsableDos,PuestoResponsableDos,Titulo from Diplomas where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Diplomas();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setTipo(request.getParameter("Tipo"));
					objeto.setNombreAlumno(request.getParameter("NombreAlumno"));
					objeto.setNombreCurso(request.getParameter("NombreCurso"));
					objeto.setDescripcionCurso(request.getParameter("DescripcionCurso"));
					objeto.setNombreEmpresa(request.getParameter("NombreEmpresa"));
					objeto.setImparticion(request.getParameter("Imparticion"));
					objeto.setCertificado(request.getParameter("Certificado"));
					objeto.setResponsableUno(request.getParameter("ResponsableUno"));
					objeto.setPuestoResponsableUno(request.getParameter("PuestoResponsableUno"));
					objeto.setResponsableDos(request.getParameter("ResponsableDos"));
					objeto.setPuestoResponsableDos(request.getParameter("PuestoResponsableDos"));
					objeto.setTitulo(request.getParameter("Titulo"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getDiplomas")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from Diplomas where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<Diplomas> info = new ArrayList<Diplomas>();
				while(resultados.next()) {
					objeto = new Diplomas();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
		} catch(SQLException e) {
			objeto = new Diplomas();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new Diplomas();
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
		} catch(NamingException e) {
			System.out.println("Driver: " + e);
		}
	}
	
	private void validar(HttpServletRequest request, HttpServletResponse response) throws IOException {
		session = request.getSession();
		try {
			try {
				session.getAttribute("Usuario").equals("");
				if(session.getAttribute("Usuario").equals("")) {
					response.sendRedirect("/" + generales.getDirectorio() + "/index.jsp");
				}
			} catch(NullPointerException e) {
				response.sendRedirect("/" + generales.getDirectorio() + "/index.jsp");
			}
		} catch(IllegalStateException e) {
			response.setHeader("Location","/" + generales.getDirectorio() + "/index.jsp");
		}
	}
	
	private void imprimeJson(HttpServletResponse response, Diplomas objeto) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("ISO-8859-1");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Diplomas> objeto) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("ISO-8859-1");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(Diplomas objeto, Exception e) {
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
}
/* DiplomasServlet */
