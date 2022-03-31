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
import Objetos.Empleados;

import com.google.gson.Gson;

public class EmpleadosServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3970070953796042644L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private Empleados objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public EmpleadosServlet() {
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
				//falta query donde se ingrese los dias que le corresponden
				eDB.setQuery("insert into Empleados (U,G,E,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,IdJefeDirecto,Observaciones) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + traducciones.getEntero(request.getParameter("IdUsuario")) + "','" + traducciones.getEntero(request.getParameter("NumeroEmpleado")) + "','" + request.getParameter("NombreCompleto") + "','" + request.getParameter("IdAreasLaborales") + "','" + request.getParameter("Puesto") + "','" + request.getParameter("Division") + "','" + request.getParameter("Estacion") + "','" + request.getParameter("NSS") + "','" + request.getParameter("CURP") + "','" + traducciones.getFecha(request.getParameter("FechaIngreso")) + "','" + request.getParameter("Estatus") + "','0','" + request.getParameter("IdJefeDirecto") + "','" + request.getParameter("Observaciones") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into EmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones from Empleados where Id = '" + ultimoId + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Empleados();
				objeto.setId(ultimoId);
				objeto.setIdUsuario(request.getParameter("IdUsuario"));
				objeto.setNumeroEmpleado(request.getParameter("NumeroEmpleado"));
				objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
				objeto.setIdAreasLaborales(request.getParameter("IdAreasLaborales"));
				objeto.setPuesto(request.getParameter("Puesto"));
				objeto.setDivision(request.getParameter("Division"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setNSS(request.getParameter("NSS"));
				objeto.setCURP(request.getParameter("CURP"));
				objeto.setFechaIngreso(request.getParameter("FechaIngreso"));
				objeto.setEstatus(request.getParameter("Estatus"));
				objeto.setVacaciones(request.getParameter("Vacaciones"));
				objeto.setIdJefeDirecto(request.getParameter("IdJefeDirecto"));
				objeto.setObservaciones(request.getParameter("Observaciones"));
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " and A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new Empleados();
				objeto.setIdUsuario(request.getParameter("IdUsuario"));
				objeto.setNumeroEmpleado(request.getParameter("NumeroEmpleado"));
				objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
				objeto.setIdAreasLaborales(request.getParameter("IdAreasLaborales"));
				objeto.setPuesto(request.getParameter("Puesto"));
				objeto.setDivision(request.getParameter("Division"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setNSS(request.getParameter("NSS"));
				objeto.setCURP(request.getParameter("CURP"));
				objeto.setFechaIngreso(request.getParameter("FechaIngreso"));
				objeto.setEstatus(request.getParameter("Estatus"));
				objeto.setVacaciones(request.getParameter("Vacaciones"));
				objeto.setIdJefeDirecto(request.getParameter("IdJefeDirecto"));
				objeto.setObservaciones(request.getParameter("Observaciones"));

				//if(!objeto.getIdUsuario().equals("")) { where.append(" and A.IdUsuario like '" + objeto.getIdUsuario() + "%'"); entro = true;}
				if(!objeto.getNumeroEmpleado().equals("")) { where.append(" and A.NumeroEmpleado = '" + objeto.getNumeroEmpleado() + "'"); entro = true;}
				if(!objeto.getNombreCompleto().equals("")) { where.append(" and A.NombreCompleto like '" + objeto.getNombreCompleto() + "%'"); entro = true;}
				if(!objeto.getPuesto().equals("")) { where.append(" and A.Puesto like '" + objeto.getPuesto() + "%'"); entro = true;}
				if(!objeto.getDivision().equals("")) { where.append(" and A.Division like '" + objeto.getDivision() + "%'"); entro = true;}
				if(!objeto.getEstacion().equals("")) { where.append(" and A.Estacion like '" + objeto.getEstacion() + "%'"); entro = true;}
				if(!objeto.getNSS().equals("")) { where.append(" and A.NSS like '" + objeto.getNSS() + "%'"); entro = true;}
				if(!objeto.getCURP().equals("")) { where.append(" and A.CURP like '" + objeto.getCURP() + "%'"); entro = true;}
				if(!objeto.getFechaIngreso().equals("")) { where.append(" and A.FechaIngreso = '" + objeto.getFechaIngreso() + "'"); entro = true;}
				if(!objeto.getEstatus().equals("")) { where.append(" and A.Estatus = '" + objeto.getEstatus() + "'"); entro = true;}
				//if(!objeto.getVacaciones().equals("")) { where.append(" and A.Vacaciones like '" + objeto.getVacaciones() + "%'"); entro = true;}
				if(!objeto.getIdJefeDirecto().equals("")){ where.append(" and A.IdJefeDirecto = '" + objeto.getIdJefeDirecto() + "'"); entro  = true; }
				if(entro) { whereInicio = " "; }
				
				
				//ANTES DIVISION resultados = eDB.getQuery("select A.*, E.Nombre as Empresa, if(U.Id is null,'',U.Nombre) as Jefe, if(U1.Id is null,'',U1.Nombre) as Usuario from Empleados as A left join Usuarios as U on (U.Id = A.IdJefeDirecto) left join Usuarios as U1 on (U1.Id = A.IdUsuario), EmpresasGrupo as E where E.Id = A.Division " + whereInicio + where.toString() + " order by A.Division,A.NumeroEmpleado");
				resultados = eDB.getQuery("select A.*, (select ED.Archivo where ED.Tipo = 'DESCRIPCION DEL PUESTO') as Archivo, E.Nombre as Empresa, E.Admon as Admon, if(U.Id is null,'',U.Nombre) as Jefe, if(U1.Id is null,'',U1.Nombre) as Usuario " + 
						"from Empleados as A left join Usuarios as U on (U.Id = A.IdJefeDirecto) left join Usuarios as U1 on (U1.Id = A.IdUsuario) left join EmpleadosDocumentos as ED on (A.Id = ED.IdEmpleados), EmpresasGrupo as E " + 
						"where E.Id = A.Division " + whereInicio + where.toString()+ "and E.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "')) order by A.Division,A.NumeroEmpleado");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				
				int i = 0;
				
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("Usuario"));
					objeto.setNumeroEmpleado(resultados.getString("NumeroEmpleado"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setIdAreasLaborales(resultados.getString("IdAreasLaborales"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setDivision(resultados.getString("Empresa"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setNSS(resultados.getString("NSS"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setFechaIngreso(resultados.getString("FechaIngreso"));
					objeto.setEstatus(resultados.getString("Estatus"));
					objeto.setVacaciones(resultados.getString("Vacaciones"));
					objeto.setNoDisfrutadosPeriodoAnterior(resultados.getString("NoDisfrutadosPeriodoAnterior"));
					objeto.setIdJefeDirecto(resultados.getString("Jefe"));
					objeto.setObservaciones(resultados.getString("Observaciones"));
					objeto.setDescripcionPuesto(resultados.getString("Archivo"));
					while (i==0){
						//DEBUGSystem.out.println("Las Vacaciones a Buscar son Empleados de "+resultados.getString("Admon"));
						i++;
					}											
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
						eDB.setQuery("insert into EmpleadosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones from Empleados where Id = '" + id[i] + "'");
						eDB.setQuery("delete from Empleados where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Empleados();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from Empleados as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new Empleados();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setIdUsuario(resultados.getString("IdUsuario"));
					objeto.setNumeroEmpleado(resultados.getString("NumeroEmpleado"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setIdAreasLaborales(resultados.getString("IdAreasLaborales"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setDivision(resultados.getString("Division"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setNSS(resultados.getString("NSS"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setFechaIngreso(resultados.getString("FechaIngreso"));
					objeto.setEstatus(resultados.getString("Estatus"));
					objeto.setVacaciones(resultados.getString("Vacaciones"));
					objeto.setIdJefeDirecto(resultados.getString("IdJefeDirecto"));
					objeto.setObservaciones(resultados.getString("Observaciones"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update Empleados set IdUsuario='" + traducciones.getEntero(request.getParameter("IdUsuario")) + "',NumeroEmpleado='" + traducciones.getEntero(request.getParameter("NumeroEmpleado")) + "',NombreCompleto='" + request.getParameter("NombreCompleto") + "',IdAreasLaborales='" + request.getParameter("IdAreasLaborales") + "',Puesto='" + request.getParameter("Puesto") + "',Division='" + request.getParameter("Division") + "',Estacion='" + request.getParameter("Estacion") + "',NSS='" + request.getParameter("NSS") + "',CURP='" + request.getParameter("CURP") + "',FechaIngreso='" + traducciones.getFecha(request.getParameter("FechaIngreso")) + "',Estatus='" + request.getParameter("Estatus") + "',Vacaciones='" + traducciones.getEntero(request.getParameter("Vacaciones")) + "',IdJefeDirecto='" + request.getParameter("IdJefeDirecto") + "',Observaciones='" + request.getParameter("Observaciones") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into EmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones from Empleados where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Empleados();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setIdUsuario(request.getParameter("IdUsuario"));
					objeto.setNumeroEmpleado(request.getParameter("NumeroEmpleado"));
					objeto.setNombreCompleto(request.getParameter("NombreCompleto"));
					objeto.setIdAreasLaborales(request.getParameter("IdAreasLaborales"));
					objeto.setPuesto(request.getParameter("Puesto"));
					objeto.setDivision(request.getParameter("Division"));
					objeto.setEstacion(request.getParameter("Estacion"));
					objeto.setNSS(request.getParameter("NSS"));
					objeto.setCURP(request.getParameter("CURP"));
					objeto.setFechaIngreso(request.getParameter("FechaIngreso"));
					objeto.setEstatus(request.getParameter("Estatus"));
					objeto.setVacaciones(request.getParameter("Vacaciones"));
					objeto.setIdJefeDirecto(request.getParameter("IdJefeDirecto"));
					objeto.setObservaciones(request.getParameter("Observaciones"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getEmpleados")) {
				eDB.setConexion();
							
				// ANTES DIVISION resultados = eDB.getQuery("select Id, NombreCompleto from Empleados where NombreCompleto like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO'");
				resultados = eDB.getQuery("select E.Id, EG.Admon as Admon, E.NombreCompleto from Empleados as E left join EmpresasGrupo as EG on (EG.Id = E.Division) "
						+ "where E.NombreCompleto like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO' and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'))");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				
				int i=0;
				
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("NombreCompleto"));					
					while (i==0){
						//DEBUGSystem.out.println("Los Empleados considerados para llenar la lista del combo son de "+resultados.getString("Admon"));
						i++;
					}
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getEmpleadosDatosOcs")) {
				eDB.setConexion();
				
				// SOLO EMPLEADOS DE OCS, CREADO PARA SU M�DULO DE CREDENCIALES
				resultados = eDB.getQuery("select E.*, EG.Codigo as Empresa, EG.Admon as Admon from Empleados as E left join EmpresasGrupo as EG on (EG.Id = E.Division) "
						+ "where E.NombreCompleto like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO' and EG.Id = '16' and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'))");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				
				int i=0;
				
				while(resultados.next()) {
					String[] Antiguedad;
					Antiguedad = resultados.getString("FechaIngreso").split("-");
					objeto = new Empleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("NombreCompleto"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setDivision(resultados.getString("Empresa"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setNSS(resultados.getString("NSS"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setFechaIngreso(Antiguedad[0]);
					while (i==0){
						//System.out.println("Son Empleados de OCS considerados en la lista combo de "+resultados.getString("Admon"));
						i++;
					}
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getEmpleadosDatos")) { //USADO EN CREDENCIALES 
				eDB.setConexion();
							
				// ANTES DIVISION resultados = eDB.getQuery("select Id, NombreCompleto from Empleados where NombreCompleto like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO'");
				resultados = eDB.getQuery("select E.*, EG.Codigo as Empresa, EG.Admon as Admon from Empleados as E left join EmpresasGrupo as EG on (EG.Id = E.Division) "
						+ "where E.NombreCompleto like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO' and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'))");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				
				int i=0;
				
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("NombreCompleto"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setDivision(resultados.getString("Empresa"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setNSS(resultados.getString("NSS"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setFechaIngreso(resultados.getString("FechaIngreso"));
					while (i==0){
						//System.out.println("Los Empleados considerados para llenar la lista del combo son de "+resultados.getString("Admon"));
						i++;
					}
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getEmpleadosDatosCorreo")) { //USADO EN CREDENCIALES PARA MEX 
				eDB.setConexion();
							
				// ANTES DIVISION resultados = eDB.getQuery("select Id, NombreCompleto from Empleados where NombreCompleto like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO'");
//		DEBUG		System.out.println("select E.*, EG.Codigo as Empresa, EG.Admon as Admon, LOWER(U.Email) as CorreoElectronico from Usuarios as U, Empleados as E left join EmpresasGrupo as EG on (EG.Id = E.Division) "
//						+ "where E.IdUsuario = U.Id and E.NombreCompleto like '" + request.getParameter("filter[value]") + "%' and E.Estatus = 'ACTIVO' and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'))");
				resultados = eDB.getQuery("select E.*, EG.Codigo as Empresa, EG.Admon as Admon, LOWER(U.Email) as CorreoElectronico from Usuarios as U, Empleados as E left join EmpresasGrupo as EG on (EG.Id = E.Division) "
						+ "where E.IdUsuario = U.Id and E.NombreCompleto like '" + request.getParameter("filter[value]") + "%' and E.Estatus = 'ACTIVO' and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'))");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				
				int i=0;
				
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("NombreCompleto"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setCorreoElectronico(resultados.getString("CorreoElectronico"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setDivision(resultados.getString("Empresa"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setNSS(resultados.getString("NSS"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setFechaIngreso(resultados.getString("FechaIngreso"));
					while (i==0){
						//System.out.println("Los Empleados considerados para llenar la lista del combo son de "+resultados.getString("Admon"));
						i++;
					}
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getEmpleadosCredencialesGdl")) { //USADO EN CREDENCIALES 
				eDB.setConexion();
							
				// ANTES DIVISION resultados = eDB.getQuery("select Id, NombreCompleto from Empleados where NombreCompleto like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO'");
				resultados = eDB.getQuery("select E.*, EG.Codigo as Empresa, EG.Admon as Admon from Empleados as E left join EmpresasGrupo as EG on (EG.Id = E.Division) "
						+ "where E.NombreCompleto like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO' and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'))");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				
				int i=0;
				
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("NombreCompleto"));
					objeto.setNombreCompleto(resultados.getString("NombreCompleto"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setDivision(resultados.getString("Empresa"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setNumeroEmpleado(resultados.getString("NumeroEmpleado"));
					objeto.setNSS(resultados.getString("NSS"));
					objeto.setCURP(resultados.getString("CURP"));
					objeto.setFechaIngreso(resultados.getString("FechaIngreso"));
					while (i==0){
						//System.out.println("Los Empleados considerados para llenar la lista del combo son de "+resultados.getString("Admon"));
						i++;
					}
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getEmpleadosPatronEstacion")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, NombreCompleto, (select Codigo from EmpresasGrupo where Id = Division) as Patron, Estacion from Empleados where NombreCompleto like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO' and Not Id In (Select IdEmpleados from AgrupadorEmpleados)");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("NombreCompleto")+" "+"("+" "+resultados.getString("Patron")+" "+resultados.getString("Estacion")+")");
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getUsuarios")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, Nombre from Usuarios where Nombre like '" + request.getParameter("filter[value]") + "%' and (Estatus = 'ACTIVO' or Estatus = 'NUEVO')");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("Nombre"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getUsuariosDiv")) {
				eDB.setConexion();
							
				resultados = eDB.getQuery("select E.Id, E.IdUsuario as IdUsuarios, EG.Admon as Admon, E.NombreCompleto from Empleados as E left join EmpresasGrupo as EG on (EG.Id = E.Division) "
						+ "where E.NombreCompleto like '" + request.getParameter("filter[value]") + "%' and Estatus = 'ACTIVO' and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "'))");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				
				int i=0;
				
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("IdUsuarios"));
					objeto.setValue(resultados.getString("NombreCompleto"));					
					while (i==0){
						//DEBUGSystem.out.println("Los Empleados considerados para llenar la lista del combo son de "+resultados.getString("Admon"));
						i++;
					}
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getUsuariosPorAreasLaborales")) {
				
				String valorFiltrado = request.getParameter("filter[value]");
				String whereNombreCompleto = "like '%%' or E.IdAreasLaborales is null";
				
				if (!valorFiltrado.equals("")) {
					whereNombreCompleto = "= '"+request.getParameter("filter[value]")+"'";
				}
				
				eDB.setConexion();
							
				resultados = eDB.getQuery("select E.Id, E.IdUsuario as IdUsuarios, EG.Admon as Admon, E.NombreCompleto from Empleados as E left join EmpresasGrupo as EG on (EG.Id = E.Division) "
						+ "where E.IdAreasLaborales "+whereNombreCompleto+" and Estatus = 'ACTIVO' and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "')) order by NombreCompleto");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				
				int i=0;
				
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("IdUsuarios"));
					objeto.setValue(resultados.getString("NombreCompleto"));					
					while (i==0){
						//DEBUGSystem.out.println("Los Empleados considerados para llenar la lista del combo son de "+resultados.getString("Admon"));
						i++;
					}
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getUsuariosDivSeguridad")) {
				eDB.setConexion();
				//DEBUGSystem.out.println("voy a hacer consulta");
				resultados = eDB.getQuery("select E.Id, E.IdUsuario as IdUsuarios, EG.Admon as Admon, E.NombreCompleto from DivisionesEmpleados as DE, DivisionesAsignacion as DA, Empleados as E left join EmpresasGrupo as EG on (EG.Id = E.Division) "
						+ "where E.NombreCompleto like '" + request.getParameter("filter[value]") + "%' and DE.Nombre = 'SEGURIDAD' and DA.IdEmpleados = E.Id and DA.IdDivisionesEmpleados = DE.Id and Estatus = 'ACTIVO' and EG.Admon = (select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "')) order by NombreCompleto");
				//DEBUGSystem.out.println("ya la hice");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				
				int i=0;
				
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("IdUsuarios"));
					objeto.setValue(resultados.getString("NombreCompleto"));					
					while (i==0){
						//DEBUGSystem.out.println("Los Empleados considerados para llenar la lista del combo son de "+resultados.getString("Admon"));
						i++;
					}
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("getNombreEmpleado")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, Nombre from Usuarios where Nombre like '" + request.getParameter("filter[value]") + "%' and (Estatus = 'ACTIVO' or Estatus = 'NUEVO')");
				ArrayList<Empleados> info = new ArrayList<Empleados>();
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("Id"));
					objeto.setValue(resultados.getString("Nombre"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("AjustaVacaciones")) {
				eDB.setConexion();
				eDB.setQuery("update Empleados set Vacaciones='" + traducciones.getEntero(request.getParameter("Vacaciones")) + "' where Id = '" + request.getParameter("IdUsuario") + "'");
				eDB.setQuery("insert into EmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones from Empleados where Id = '" + request.getParameter("id") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Empleados();
				objeto.setId(Integer.parseInt(request.getParameter("IdUsuario")));
					objeto.setIdUsuario(request.getParameter("IdUsuario"));
					objeto.setVacaciones(request.getParameter("Vacaciones"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("AjustaNoDisfrutadosPeriodoAnterior")) {
				eDB.setConexion();
				//DEBUGSystem.out.println("insert into EmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones from Empleados where Id = '" + request.getParameter("IdUsuario") + "'");
				eDB.setQuery("insert into EmpleadosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdUsuario,NumeroEmpleado,NombreCompleto,IdAreasLaborales,Puesto,Division,Estacion,NSS,CURP,FechaIngreso,Estatus,Vacaciones,NoDisfrutadosPeriodoAnterior,IdJefeDirecto,Observaciones from Empleados where Id = '" + request.getParameter("IdUsuario") + "'");
				eDB.setQuery("update Empleados set NoDisfrutadosPeriodoAnterior='" + traducciones.getEntero(request.getParameter("NoDisfrutadosPeriodoAnterior")) + "' where Id = '" + request.getParameter("IdUsuario") + "'");
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new Empleados();
				objeto.setId(Integer.parseInt(request.getParameter("IdUsuario")));
					objeto.setIdUsuario(request.getParameter("IdUsuario"));
					objeto.setNoDisfrutadosPeriodoAnterior(request.getParameter("NoDisfrutadosPeriodoAnterior"));
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getUsuario")) {
				eDB.setConexion();
				resultados = eDB.getQuery("SELECT Usuarios.Id, Usuarios.Usuario as Usuario FROM Usuarios INNER JOIN Empleados ON Usuarios.Id = Empleados.IdUsuario where Empleados.Id = '" + request.getParameter("IdUsuario") + "'");
				// SE RETIRA PARA NO PODER UN ARREGLO DENTRO DE OTRO ARREGLO ArrayList<Empleados> info = new ArrayList<Empleados>();
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("Usuarios.Id"));
					objeto.setValue(resultados.getString("Usuario")); // DEBUG System.out.println("Estoy en Usuario");
					//SE RETIRA info.add(objeto);
					// DEBUG System.out.println(resultados.getString("Usuario"));
					// DEBUG System.out.println(objeto.getNombreCompleto());
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				//DEBUG System.out.println("Voy a imprimir Json");
				//DEBUG System.out.println(objeto.getNombreCompleto());
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("getUsuario2")) {
				eDB.setConexion();
				resultados = eDB.getQuery("SELECT Usuarios.Id, Usuarios.Usuario as Usuario FROM Usuarios INNER JOIN Empleados ON Usuarios.Id = Empleados.IdUsuario where Empleados.Id = '" + request.getParameter("NombreEmpleado") + "'");
				// SE RETIRA PARA NO PODER UN ARREGLO DENTRO DE OTRO ARREGLO ArrayList<Empleados> info = new ArrayList<Empleados>();
				while(resultados.next()) {
					objeto = new Empleados();
					objeto.setId(resultados.getInt("Usuarios.Id"));
					objeto.setValue(resultados.getString("Usuario")); // DEBUG System.out.println("Estoy en Usuario");
					//SE RETIRA info.add(objeto);
					// DEBUG System.out.println(resultados.getString("Usuario"));
					// DEBUG System.out.println(objeto.getNombreCompleto());
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				//DEBUG System.out.println("Voy a imprimir Json");
				//DEBUG System.out.println(objeto.getNombreCompleto());
				imprimeJson(response,objeto);
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
	
	private void imprimeJson(HttpServletResponse response, Empleados objeto) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("ISO-8859-1");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<Empleados> objeto) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("ISO-8859-1");
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
}
/* EmpleadosServlet */
