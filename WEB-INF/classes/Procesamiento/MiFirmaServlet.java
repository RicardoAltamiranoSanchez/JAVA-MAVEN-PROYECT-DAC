package Procesamiento;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import Configuraciones.Generales;
import Configuraciones.BaseDeDatosPool;
import Utilerias.Fechas;
import Utilerias.TraduccionesSQL;
import Objetos.MiFirma;

import com.google.gson.Gson;

public class MiFirmaServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1593808445140258847L;
	private HttpSession session;
	private DataSource datasource = null;
	private Generales generales;
	private int ultimoId;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;
	private BaseDeDatosPool dbConf;
	
	public MiFirmaServlet() {
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
		Connection conexion = null;
		Statement sentencia = null;
		ResultSet resultados = null, resultados2 = null;
		MiFirma objeto;
		
		try {
			conexion = datasource.getConnection();
			sentencia = conexion.createStatement();
			if(request.getParameter("Accion").equals("Guardar")) {
				sentencia.executeUpdate("insert into MiFirma (U,G,E,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId) values ('" + 
						session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + 
						traducciones.getEntero(request.getParameter("IdUsuario")) + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Titulo") + "','" + 
						request.getParameter("Email") + "','" + request.getParameter("Nextel") + "','" + request.getParameter("NextelId") + "') " +
						"on duplicate key update Nombre = '" + request.getParameter("Nombre") + "', Titulo = '" + request.getParameter("Titulo") + "', Email = '" + request.getParameter("Email") + "', Nextel = '" + request.getParameter("Nextel") + "', NextelId = '" + request.getParameter("NextelId") + "'",Statement.RETURN_GENERATED_KEYS);
				ResultSet indice = sentencia.getGeneratedKeys();
				while(indice.next()) {
					ultimoId = indice.getInt(1);
				}
				try { if(null!=indice)indice.close();} catch (SQLException e) {;}
				sentencia.executeUpdate("insert into MiFirmaApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId from MiFirma where Id = '" + ultimoId + "'");
				
				objeto = new MiFirma();
				objeto.setId(ultimoId);
				objeto.setIdUsuario(request.getParameter("IdUsuario"));
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setTitulo(request.getParameter("Titulo"));
				objeto.setEmail(request.getParameter("Email"));
				objeto.setNextel(request.getParameter("Nextel"));
				objeto.setNextelId(request.getParameter("NextelId"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				objeto = new MiFirma();
				objeto.setIdUsuario(request.getParameter("IdUsuario"));
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setTitulo(request.getParameter("Titulo"));
				objeto.setEmail(request.getParameter("Email"));
				objeto.setNextel(request.getParameter("Nextel"));
				objeto.setNextelId(request.getParameter("NextelId"));

				if(!objeto.getIdUsuario().equals("")) { where.append(" and A.IdUsuario like '" + objeto.getIdUsuario() + "%'"); entro = true;}
				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getTitulo().equals("")) { where.append(" and A.Titulo like '" + objeto.getTitulo() + "%'"); entro = true;}
				if(!objeto.getEmail().equals("")) { where.append(" and A.Email like '" + objeto.getEmail() + "%'"); entro = true;}
				if(!objeto.getNextel().equals("")) { where.append(" and A.Nextel like '" + objeto.getNextel() + "%'"); entro = true;}
				if(!objeto.getNextelId().equals("")) { where.append(" and A.NextelId like '" + objeto.getNextelId() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = sentencia.executeQuery("select A.* from MiFirma as A" + whereInicio + where.toString());
				ArrayList<MiFirma> info = new ArrayList<MiFirma>();
				while(resultados.next()) {
					objeto = new MiFirma();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("IdUsuario"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setTitulo(resultados.getString("Titulo"));
					objeto.setEmail(resultados.getString("Email"));
					objeto.setNextel(resultados.getString("Nextel"));
					objeto.setNextelId(resultados.getString("NextelId"));
					info.add(objeto);
				}
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("BuscarMcsGdl")) {
				StringBuffer where = new StringBuffer();
				
				boolean entro = false;
				
				objeto = new MiFirma();
//				objeto.setIdUsuario(request.getParameter("IdUsuario"));
				objeto.setNombre(request.getParameter("Nombre"));
//				objeto.setTitulo(request.getParameter("Titulo"));
//				objeto.setEmail(request.getParameter("Email"));
//				objeto.setNextel(request.getParameter("Nextel"));
//				objeto.setNextelId(request.getParameter("NextelId"));
				
				String whereDivision = "";
				if(request.getParameter("IdDivisionesEmpleados").equals("")) {
					whereDivision= " and DA.IdDivisionesEmpleados like '%%' ";
				}else{
					whereDivision= " and DA.IdDivisionesEmpleados = '"+request.getParameter("IdDivisionesEmpleados")+"' ";
				}
				
				String whereInicio = " where A.Id > 0 and A.IdUsuario = U.Id and U.Id = E.IdUsuario and DA.IdEmpleados = E.Id and DA.IdDivisionesEmpleados = DE.Id and U.Estatus = 'ACTIVO'"+whereDivision;

//				if(!objeto.getIdUsuario().equals("")) { where.append(" and A.IdUsuario like '" + objeto.getIdUsuario() + "%'"); entro = true;}
				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '%" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getTitulo().equals("")) { where.append(" and A.Titulo like '" + objeto.getTitulo() + "%'"); entro = true;}
				if(!objeto.getEmail().equals("")) { where.append(" and A.Email like '" + objeto.getEmail() + "%'"); entro = true;}
				if(!objeto.getNextel().equals("")) { where.append(" and A.Nextel like '" + objeto.getNextel() + "%'"); entro = true;}
//				if(!objeto.getNextelId().equals("")) { where.append(" and A.NextelId like '" + objeto.getNextelId() + "%'"); entro = true;}
				//if(entro) { whereInicio = " where A.Id > 0 and A.IdUsuario = U.Id and U.Id = E.IdUsuario and FP.IdEmpleados = E.Id and FP.IdFirmas = F.Id and U.Estatus = 'ACTIVO' "; }
				if(entro) { whereInicio = " where A.Id > 0 and A.IdUsuario = U.Id and U.Id = E.IdUsuario and DA.IdEmpleados = E.Id and DA.IdDivisionesEmpleados = DE.Id and U.Estatus = 'ACTIVO' "+whereDivision; }
				
				//System.out.println("select A.*, F.NombreFirma from MiFirma as A, Usuarios as U, Firmas as F, FirmasPersonal as FP, Empleados as E " + whereInicio + where.toString());
				//resultados = sentencia.executeQuery("select A.*, F.NombreFirma from MiFirma as A, Usuarios as U, Firmas as F, FirmasPersonal as FP, Empleados as E " + whereInicio + where.toString());
				//DEBUGSystem.out.println("select A.*, DE.Nombre as Division from MiFirma as A, Usuarios as U, DivisionesEmpleados as DE, DivisionesAsignacion as DA, Empleados as E " + whereInicio + where.toString());
				resultados = sentencia.executeQuery("select A.*, DE.Nombre as Division from MiFirma as A, Usuarios as U, DivisionesEmpleados as DE, DivisionesAsignacion as DA, Empleados as E " + whereInicio + where.toString());
				ArrayList<MiFirma> info = new ArrayList<MiFirma>();
				while(resultados.next()) {
					objeto = new MiFirma();
					objeto.setId(resultados.getInt("Id"));
//					objeto.setIdUsuario(resultados.getString("IdUsuario"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setTitulo(resultados.getString("Titulo"));
					objeto.setEmail(resultados.getString("Email"));
					objeto.setNextel(resultados.getString("Nextel"));
//					objeto.setNextelId(resultados.getString("NextelId"));
					objeto.setValue(resultados.getString("Division"));
					info.add(objeto);
				}
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("Borrar")) {
				String ids = request.getParameter("Ids");
				String[] id = ids.split(",");
				for(int i = 0; i < id.length; i++) {
					if(!id[i].equals("")) {
						sentencia.executeUpdate("insert into MiFirmaApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId from MiFirma where Id = '" + id[i] + "'");
						sentencia.executeUpdate("delete from MiFirma where Id = '" + id[i] + "'");
					}
				}
				
				objeto = new MiFirma();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				resultados = sentencia.executeQuery("select A.* from MiFirma as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new MiFirma();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("IdUsuario"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setTitulo(resultados.getString("Titulo"));
					objeto.setEmail(resultados.getString("Email"));
					objeto.setNextel(resultados.getString("Nextel"));
					objeto.setNextelId(resultados.getString("NextelId"));
				}
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				sentencia.executeUpdate("update MiFirma set IdUsuario='" + traducciones.getEntero(request.getParameter("IdUsuario")) + "',Nombre='" + request.getParameter("Nombre") + "',Titulo='" + request.getParameter("Titulo") + "',Email='" + request.getParameter("Email") + "',Nextel='" + request.getParameter("Nextel") + "',NextelId='" + request.getParameter("NextelId") + "' where Id = '" + request.getParameter("id") + "'");
				sentencia.executeUpdate("insert into MiFirmaApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,Nombre,Titulo,Email,Nextel,NextelId from MiFirma where Id = '" + request.getParameter("id") + "'");
				
				objeto = new MiFirma();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setIdUsuario(request.getParameter("IdUsuario"));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setTitulo(request.getParameter("Titulo"));
					objeto.setEmail(request.getParameter("Email"));
					objeto.setNextel(request.getParameter("Nextel"));
					objeto.setNextelId(request.getParameter("NextelId"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getMiFirma")) {
				resultados = sentencia.executeQuery("select Id, <columna> from MiFirma where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<MiFirma> info = new ArrayList<MiFirma>();
				while(resultados.next()) {
					objeto = new MiFirma();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("<columna>"));
					info.add(objeto);
				}
				
				imprimeJson(response,info);
			} else if(request.getParameter("Accion").equals("LlenarValores")) {

				String Usuario = (session.getAttribute("IdUsuario").toString());
				//DEBUG System.out.println("El Usuario Id que revisaré es " + Usuario);
				
				// SE COMENTA PORQUE NO CONSULTA SI HAY DATOS EN MiFirma ANTES DE TRAER RESULTADOS DE EMPLEADOS
				//resultados = sentencia.executeQuery("Select Id, NombreCompleto as Nombre, Puesto as Titulo, (Select Email from Usuarios where Id = '"+Usuario+"') as Email, (Select IFNULL(Nextel,'') from MiFirma where IdUsuario = '"+Usuario+"') as Nextel, (Select IFNULL(NextelId,'') from MiFirma where IdUsuario = '"+Usuario+"') as NextelId from Empleados where IdUsuario = '"+Usuario+"'");
				
				//resultados = sentencia.executeQuery("select	(Select Firma from FirmasGrupos where GrupoEmpleados = (Select GrupoEmpleados from AgrupadorEmpleados where IdEmpleados = (Select Id From Empleados where IdUsuario ='"+Usuario+"'))) as FirmaGrupoHtml, (select GrupoEmpleados from AgrupadorEmpleados where IdEmpleados =(select Id from Empleados where IdUsuario = '"+Usuario+"')) as Value,if(MF.IdUsuario is null,E.Id,MF.Id) as Id, if(MF.IdUsuario is null,E.Nombre,MF.Nombre) as Nombre,	if(MF.IdUsuario is null,E.Titulo,MF.Titulo) as Titulo,	if(MF.IdUsuario is null,E.Email,MF.Email) as Email,	if(MF.IdUsuario is null,E.Nextel,MF.Nextel) as Nextel,	if(MF.IdUsuario is null,E.NextelId,MF.NextelId) as NextelId	from (Select Id, IdUsuario, NombreCompleto as Nombre, Puesto as Titulo, (Select Email from Usuarios where Id = '"+Usuario+"') as Email, (Select IFNULL(Nextel,'') from MiFirma where IdUsuario = '"+Usuario+"') as Nextel, (Select IFNULL(NextelId,'') from MiFirma where IdUsuario = '"+Usuario+"') as NextelId from Empleados where IdUsuario = '"+Usuario+"') as E left join MiFirma MF on (MF.IdUsuario = E.IdUsuario) where E.IdUsuario = '"+Usuario+"';");
				//DEBUGSystem.out.println("select	(Select FH.HtmlFirma from FirmasHtml as FH left join FirmasPersonal as FP on (FP.IdFirmas = FH.IdFirmas) left join Empleados as EM on (EM.Id = FP.IdEmpleados) where FP.IdEmpleados = (Select Id From Empleados where IdUsuario ='"+Usuario+"' and Estatus = 'ACTIVO')) as FirmaGrupoHtml, if((select FI.Id from Firmas as FI left join FirmasPersonal as FIP on (FIP.IdFirmas = FI.Id) left join Empleados as EMP on (EMP.Id = FIP.IdEmpleados) where FIP.IdEmpleados =(select Id from Empleados where IdUsuario = '"+Usuario+"' and Estatus = 'ACTIVO')) is null, '',(select FI.Id from Firmas as FI left join FirmasPersonal as FIP on (FIP.IdFirmas = FI.Id) left join Empleados as EMP on (EMP.Id = FIP.IdEmpleados) where FIP.IdEmpleados =(select Id from Empleados where IdUsuario = '"+Usuario+"' and Estatus = 'ACTIVO'))) as Value, if(MF.IdUsuario is null,E.Id,MF.Id) as Id, if(MF.IdUsuario is null,E.Nombre,MF.Nombre) as Nombre,	if(MF.IdUsuario is null,E.Titulo,MF.Titulo) as Titulo,	if(MF.IdUsuario is null,E.Email,MF.Email) as Email,	if(MF.IdUsuario is null,E.Nextel,MF.Nextel) as Nextel,	if(MF.IdUsuario is null,E.NextelId,MF.NextelId) as NextelId	from (Select Id, IdUsuario, NombreCompleto as Nombre, Puesto as Titulo, (Select Email from Usuarios where Id = '"+Usuario+"') as Email, (Select IFNULL(Nextel,'') from MiFirma where IdUsuario = '"+Usuario+"') as Nextel, (Select IFNULL(NextelId,'') from MiFirma where IdUsuario = '"+Usuario+"') as NextelId from Empleados where IdUsuario = '"+Usuario+"' and Estatus = 'ACTIVO') as E left join MiFirma MF on (MF.IdUsuario = E.IdUsuario) where E.IdUsuario = '"+Usuario+"';");
				resultados = sentencia.executeQuery("select	(Select FH.HtmlFirma from FirmasHtml as FH left join FirmasPersonal as FP on (FP.IdFirmas = FH.IdFirmas) left join Empleados as EM on (EM.Id = FP.IdEmpleados) where FP.IdEmpleados = (Select Id From Empleados where IdUsuario ='"+Usuario+"' and Estatus = 'ACTIVO')) as FirmaGrupoHtml, if((select FI.Id from Firmas as FI left join FirmasPersonal as FIP on (FIP.IdFirmas = FI.Id) left join Empleados as EMP on (EMP.Id = FIP.IdEmpleados) where FIP.IdEmpleados =(select Id from Empleados where IdUsuario = '"+Usuario+"' and Estatus = 'ACTIVO')) is null, '',(select FI.Id from Firmas as FI left join FirmasPersonal as FIP on (FIP.IdFirmas = FI.Id) left join Empleados as EMP on (EMP.Id = FIP.IdEmpleados) where FIP.IdEmpleados =(select Id from Empleados where IdUsuario = '"+Usuario+"' and Estatus = 'ACTIVO'))) as Value, if(MF.IdUsuario is null,E.Id,MF.Id) as Id, if(MF.IdUsuario is null,E.Nombre,MF.Nombre) as Nombre,	if(MF.IdUsuario is null,E.Titulo,MF.Titulo) as Titulo,	if(MF.IdUsuario is null,E.Email,MF.Email) as Email,	if(MF.IdUsuario is null,E.Nextel,MF.Nextel) as Nextel,	if(MF.IdUsuario is null,E.NextelId,MF.NextelId) as NextelId	from (Select Id, IdUsuario, NombreCompleto as Nombre, Puesto as Titulo, (Select Email from Usuarios where Id = '"+Usuario+"') as Email, (Select IFNULL(Nextel,'') from MiFirma where IdUsuario = '"+Usuario+"') as Nextel, (Select IFNULL(NextelId,'') from MiFirma where IdUsuario = '"+Usuario+"') as NextelId from Empleados where IdUsuario = '"+Usuario+"' and Estatus = 'ACTIVO') as E left join MiFirma MF on (MF.IdUsuario = E.IdUsuario) where E.IdUsuario = '"+Usuario+"';");
				//ES EL MISMO QUERY PERO CON ENTERS PARA QUE SEA MAS CLARO
//				select
//
//				if(MF.IdUsuario is null,E.Id,MF.Id) as Id,
//				if(MF.IdUsuario is null,E.Nombre,MF.Nombre) as Nombre, 
//				if(MF.IdUsuario is null,E.Titulo,MF.Titulo) as Titulo, 
//				if(MF.IdUsuario is null,E.Email,MF.Email) as Email, 
//				if(MF.IdUsuario is null,E.Nextel,MF.Nextel) as Nextel,
//				if(MF.IdUsuario is null,E.NextelId,MF.NextelId) as NextelId 
//
//				from (Select Id, IdUsuario, NombreCompleto as Nombre, Puesto as Titulo, (Select Email from Usuarios where Id = '"+Usuario+"') as Email, (Select IFNULL(Nextel,'') from MiFirma where IdUsuario = '"+Usuario+"') as Nextel, (Select IFNULL(NextelId,'') from MiFirma where IdUsuario = '"+Usuario+"') as NextelId from Empleados where IdUsuario = '"+Usuario+"') as E left join MiFirma MF on (MF.IdUsuario = E.IdUsuario) where E.IdUsuario = '"+Usuario+"';

				
				objeto = new MiFirma();

				objeto.setIdUsuario(session.getAttribute("IdUsuario").toString());
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setTitulo(request.getParameter("Titulo"));
				objeto.setEmail(request.getParameter("Email"));
				objeto.setNextel(request.getParameter("Nextel"));
				objeto.setNextelId(request.getParameter("NextelId"));
				objeto.setFirmaGrupoHtml(request.getParameter("FirmaGrupoHtml"));
				objeto.setValue(request.getParameter("Value"));

				while(resultados.next()) {
					objeto = new MiFirma();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(session.getAttribute("IdUsuario").toString());
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setTitulo(resultados.getString("Titulo"));
					objeto.setEmail(resultados.getString("Email").toLowerCase());
					objeto.setNextel(resultados.getString("Nextel"));
					objeto.setNextelId(resultados.getString("NextelId"));
					String CadenaFirma = resultados.getString("FirmaGrupoHtml");
					
					
					String NextelHtml;
					String NextelIdHtml;
					
					if (resultados.getString("Nextel") == "" || resultados.getString("NextelId") == null){
						NextelHtml = "</span>";
					}else{
						//NextelHtml = "/ </span><span style=\"color: rgb(5, 27, 63); display: inline;\" class=\"txt signature_mobilephone-target sig-hide\"><b>NEXTEL: </b>"+resultados.getString("Nextel");
						NextelHtml = "/ </span><span style=\"color: rgb(5, 27, 63); display: inline;\" class=\"txt signature_mobilephone-target sig-hide\"><b>Cel: </b>"+resultados.getString("Nextel");
					}
					
					if (resultados.getString("NextelId")== "" || resultados.getString("NextelId") == null){
						NextelIdHtml = "";
					}else{
						//NextelIdHtml = " / <b>ID: </b>"+resultados.getString("NextelId");
						NextelIdHtml = "<b></b>";
					}
					
					
					//String CadenaFirmaRemplazada = CadenaFirma.replaceAll("=NOMBRE=","'+NombreHtml+'").replaceAll("=TITULO=","'+TituloHtml+'").replaceAll("=EMAIL=","'+EmailHtml+'").replaceAll("=NEXTEL=NEXTELID=","'+NextelHtml+NextelIdHtml+'").replaceAll("=BANNER=","'+BannerHtml+'");
					try{
						String CadenaFirmaRemplazada = CadenaFirma.replaceAll("=NOMBRE=",resultados.getString("Nombre")).replaceAll("=TITULO=",resultados.getString("Titulo")).replaceAll("=EMAIL=",resultados.getString("Email")).replaceAll("=NEXTEL=NEXTELID=",NextelHtml+NextelIdHtml).replaceAll("=BANNER=",resultados.getString("Value"));
						objeto.setFirmaGrupoHtml(CadenaFirmaRemplazada);
						//objeto.setFirmaGrupoHtml(resultados.getString("FirmaGrupoHtml"));
						//DEBUG System.out.println("El Grupo es "+resultados.getString("Value"));
						objeto.setValue(resultados.getString("Value"));
					}catch(NullPointerException e){
						System.out.println("No se le ha asignado a un grupo de firmas");
						objeto.setFirmaGrupoHtml("No se le ha asignado a un grupo de firmas");
						objeto.setValue("No se le ha asignado a un grupo de firmas");
					}
				}
				
				imprimeJson(response,objeto);
			}
			conexion.close();
		} catch(SQLException e) {
			objeto = new MiFirma();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new MiFirma();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} finally {
			try {if (resultados != null) resultados.close();} catch (SQLException e) {;}
			try {if (sentencia != null) sentencia.close();} catch (SQLException e) {;}
			try {if (conexion != null) conexion.close();} catch (SQLException e) {;}
		}
	}

	public void init() throws ServletException {
		// Put your code here
		try {
			dbConf = new BaseDeDatosPool();
			Context initContext = new InitialContext();
			Context envContext = (Context)initContext.lookup("java:/comp/env");
			datasource = (DataSource)envContext.lookup(dbConf.getDatabase());
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
	
	private void imprimeJson(HttpServletResponse response, MiFirma objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<MiFirma> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(MiFirma objeto, Exception e) {
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
/* MiFirmaServlet */
