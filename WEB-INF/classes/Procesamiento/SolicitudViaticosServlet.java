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
import Libreria.CorreosElectronicosHtml;
import Libreria.MysqlPool;
import Utilerias.Fechas;
import Utilerias.TraduccionesSQL;
import Objetos.SolicitudViaticos;

import com.google.gson.Gson;

public class SolicitudViaticosServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3442665006649773290L;
	private HttpSession session;
	private Generales generales;
	private MysqlPool eDB;
	private ResultSet resultados;
	private int ultimoId;
	private SolicitudViaticos objeto;
	private Gson gson;
	private Fechas fechas;
	private TraduccionesSQL traducciones;

	public SolicitudViaticosServlet() {
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
		
		validar(request,response);
		
		try {
			if(request.getParameter("Accion").equals("Guardar")) {
				eDB.setConexion();
				eDB.setQuery("insert into SolicitudViaticos (U,G,E,Fecha,Gerente,Nombre,Puesto,Motivo,FacturarA,ViajeDesde,ViajeHasta,Itinerario,Estacion,Hospedaje,Alimentos,Taxi,RentaAutomovil,Avion,Transporte,Total,Autorizacion) values ('" + session.getAttribute("IdUsuario") + "','" + session.getAttribute("IdGrupos") + "','" + session.getAttribute("IdEmpresas") + "','" + traducciones.getFecha(request.getParameter("Fecha")) + "','" + traducciones.getEntero(request.getParameter("Gerente")) + "','" + request.getParameter("Nombre") + "','" + request.getParameter("Puesto") + "','" + request.getParameter("Motivo") + "',(select RFC from EmpresasGrupo where Id ='" + request.getParameter("FacturarA") + "'),'" + traducciones.getFecha(request.getParameter("ViajeDesde")) + "','" + traducciones.getFecha(request.getParameter("ViajeHasta")) + "','" + request.getParameter("Itinerario") + "','" + request.getParameter("Estacion") + "','" + traducciones.getDecimal(request.getParameter("Hospedaje")) + "','" + traducciones.getDecimal(request.getParameter("Alimentos")) + "','" + traducciones.getDecimal(request.getParameter("Taxi")) + "','" + traducciones.getDecimal(request.getParameter("RentaAutomovil")) + "','" + traducciones.getDecimal(request.getParameter("Avion")) + "','" + traducciones.getDecimal(request.getParameter("Transporte")) + "','" + traducciones.getDecimal(request.getParameter("Total")) + "','" + request.getParameter("Autorizacion") + "')");
				ultimoId = eDB.getUltimoId();
				eDB.setQuery("insert into SolicitudViaticosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Gerente,Nombre,Puesto,Motivo,FacturarA,ViajeDesde,ViajeHasta,Itinerario,Estacion,Hospedaje,Alimentos,Taxi,RentaAutomovil,Avion,Transporte,Total,Autorizacion) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Gerente,Nombre,Puesto,Motivo,FacturarA,ViajeDesde,ViajeHasta,Itinerario,Estacion,Hospedaje,Alimentos,Taxi,RentaAutomovil,Avion,Transporte,Total,Autorizacion from SolicitudViaticos where Id = '" + ultimoId + "'");
				
				
				objeto = new SolicitudViaticos();
				objeto.setId(ultimoId);
				objeto.setFecha(request.getParameter("Fecha"));
				objeto.setGerente(request.getParameter("Gerente"));
				objeto.setNombre(request.getParameter("Nombre"));
				objeto.setPuesto(request.getParameter("Puesto"));
				objeto.setMotivo(request.getParameter("Motivo"));
				objeto.setFacturarA(request.getParameter("FacturarA"));
				objeto.setViajeDesde(request.getParameter("ViajeDesde"));
				objeto.setViajeHasta(request.getParameter("ViajeHasta"));
				objeto.setItinerario(request.getParameter("Itinerario"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setHospedaje(request.getParameter("Hospedaje"));
				objeto.setAlimentos(request.getParameter("Alimentos"));
				objeto.setTaxi(request.getParameter("Taxi"));
				objeto.setRentaAutomovil(request.getParameter("RentaAutomovil"));
				objeto.setAvion(request.getParameter("Avion"));
				objeto.setTransporte(request.getParameter("Transporte"));
				objeto.setTotal(request.getParameter("Total"));
				objeto.setAutorizacion(request.getParameter("Autorizacion"));
				
				imprimeJson(response,objeto);
				
				CorreosElectronicosHtml email = new CorreosElectronicosHtml();
				email.correoSolicitudViaticos(eDB, "" + ultimoId);
				
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
			}
			else if(request.getParameter("Accion").equals("Buscar")) {
				StringBuffer where = new StringBuffer();
				String whereInicio = " where A.Id < 0";
				boolean entro = false;
				
				eDB.setConexion();
				objeto = new SolicitudViaticos();
				//objeto.setFecha(request.getParameter("Fecha"));
				//objeto.setGerente(request.getParameter("Gerente"));
				objeto.setNombre(request.getParameter("Nombre"));
				/*objeto.setPuesto(request.getParameter("Puesto"));
				objeto.setMotivo(request.getParameter("Motivo"));
				objeto.setFacturarA(request.getParameter("FacturarA"));
				objeto.setViajeDesde(request.getParameter("ViajeDesde"));
				objeto.setViajeHasta(request.getParameter("ViajeHasta"));
				objeto.setItinerario(request.getParameter("Itinerario"));
				objeto.setEstacion(request.getParameter("Estacion"));
				objeto.setHospedaje(request.getParameter("Hospedaje"));
				objeto.setAlimentos(request.getParameter("Alimentos"));
				objeto.setTaxi(request.getParameter("Taxi"));
				objeto.setRentaAutomovil(request.getParameter("RentaAutomovil"));
				objeto.setAvion(request.getParameter("Avion"));
				objeto.setTransporte(request.getParameter("Transporte"));
				objeto.setTotal(request.getParameter("Total"));
				objeto.setAutorizacion(request.getParameter("Autorizacion"));
				*/
				
				if(!objeto.getFecha().equals("")) { where.append(" and A.Fecha like '" + objeto.getFecha() + "%'"); entro = true;}
				if(!objeto.getGerente().equals("")) { where.append(" and A.Gerente like '" + objeto.getGerente() + "%'"); entro = true;}
				if(!objeto.getNombre().equals("")) { where.append(" and A.Nombre like '" + objeto.getNombre() + "%'"); entro = true;}
				if(!objeto.getPuesto().equals("")) { where.append(" and A.Puesto like '" + objeto.getPuesto() + "%'"); entro = true;}
				if(!objeto.getMotivo().equals("")) { where.append(" and A.Motivo like '" + objeto.getMotivo() + "%'"); entro = true;}
				if(!objeto.getFacturarA().equals("")) { where.append(" and A.FacturarA like '" + objeto.getFacturarA() + "%'"); entro = true;}
				if(!objeto.getViajeDesde().equals("")) { where.append(" and A.ViajeDesde like '" + objeto.getViajeDesde() + "%'"); entro = true;}
				if(!objeto.getViajeHasta().equals("")) { where.append(" and A.ViajeHasta like '" + objeto.getViajeHasta() + "%'"); entro = true;}
				if(!objeto.getItinerario().equals("")) { where.append(" and A.Itinerario like '" + objeto.getItinerario() + "%'"); entro = true;}
				if(!objeto.getEstacion().equals("")) { where.append(" and A.Estacion like '" + objeto.getEstacion() + "%'"); entro = true;}
				if(!objeto.getHospedaje().equals("")) { where.append(" and A.Hospedaje like '" + objeto.getHospedaje() + "%'"); entro = true;}
				if(!objeto.getAlimentos().equals("")) { where.append(" and A.Alimentos like '" + objeto.getAlimentos() + "%'"); entro = true;}
				if(!objeto.getTaxi().equals("")) { where.append(" and A.Taxi like '" + objeto.getTaxi() + "%'"); entro = true;}
				if(!objeto.getRentaAutomovil().equals("")) { where.append(" and A.RentaAutomovil like '" + objeto.getRentaAutomovil() + "%'"); entro = true;}
				if(!objeto.getAvion().equals("")) { where.append(" and A.Avion like '" + objeto.getAvion() + "%'"); entro = true;}
				if(!objeto.getTransporte().equals("")) { where.append(" and A.Transporte like '" + objeto.getTransporte() + "%'"); entro = true;}
				if(!objeto.getTotal().equals("")) { where.append(" and A.Total like '" + objeto.getTotal() + "%'"); entro = true;}
				if(!objeto.getAutorizacion().equals("")) { where.append(" and A.Autorizacion like '" + objeto.getAutorizacion() + "%'"); entro = true;}
				if(entro) { whereInicio = " where A.Id > 0"; }
				
				resultados = eDB.getQuery("select A.* from SolicitudViaticos as A" + whereInicio + where.toString());
				ArrayList<SolicitudViaticos> info = new ArrayList<SolicitudViaticos>();
				while(resultados.next()) {
					objeto = new SolicitudViaticos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setGerente(resultados.getString("Gerente"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setMotivo(resultados.getString("Motivo"));
					objeto.setFacturarA(resultados.getString("FacturarA"));
					objeto.setViajeDesde(resultados.getString("ViajeDesde"));
					objeto.setViajeHasta(resultados.getString("ViajeHasta"));
					objeto.setItinerario(resultados.getString("Itinerario"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setHospedaje(resultados.getString("Hospedaje"));
					objeto.setAlimentos(resultados.getString("Alimentos"));
					objeto.setTaxi(resultados.getString("Taxi"));
					objeto.setRentaAutomovil(resultados.getString("RentaAutomovil"));
					objeto.setAvion(resultados.getString("Avion"));
					objeto.setTransporte(resultados.getString("Transporte"));
					objeto.setTotal(resultados.getString("Total"));
					objeto.setAutorizacion(resultados.getString("Autorizacion"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("BuscarAutorizar")) {

				eDB.setConexion();
				
				resultados = eDB.getQuery("select A.* from SolicitudViaticos as A where A.Gerente = '" + session.getAttribute("IdUsuario") + "'");
				ArrayList<SolicitudViaticos> info = new ArrayList<SolicitudViaticos>();
				while(resultados.next()) {
					objeto = new SolicitudViaticos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setGerente(resultados.getString("Gerente"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setMotivo(resultados.getString("Motivo"));
					objeto.setFacturarA(resultados.getString("FacturarA"));
					objeto.setViajeDesde(resultados.getString("ViajeDesde"));
					objeto.setViajeHasta(resultados.getString("ViajeHasta"));
					objeto.setItinerario(resultados.getString("Itinerario"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setHospedaje(resultados.getString("Hospedaje"));
					objeto.setAlimentos(resultados.getString("Alimentos"));
					objeto.setTaxi(resultados.getString("Taxi"));
					objeto.setRentaAutomovil(resultados.getString("RentaAutomovil"));
					objeto.setAvion(resultados.getString("Avion"));
					objeto.setTransporte(resultados.getString("Transporte"));
					objeto.setTotal(resultados.getString("Total"));
					objeto.setAutorizacion(resultados.getString("Autorizacion"));
					info.add(objeto);
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,info);
			}
			else if(request.getParameter("Accion").equals("BuscarTodos")) {

				eDB.setConexion();
				
				// ANTES DIVISION resultados = eDB.getQuery("select A.* from SolicitudViaticos as A where A.Autorizacion = 'AUTORIZADO' order by Fecha desc, Id desc");
				resultados = eDB.getQuery("select A.*, EG.Admon as Admon from SolicitudViaticos as A left join Usuarios as U on (U.Nombre = A.Nombre) left join Empleados as E on (U.Id = E.IdUsuario) left join EmpresasGrupo as EG on (E.Division = EG.Id) where A.Autorizacion = 'AUTORIZADO' and EG.Admon =(select Admon from EmpresasGrupo where Id = (select Division from Empleados where IdUsuario = '" + session.getAttribute("IdUsuario") + "')) order by Fecha desc, Id desc");
				ArrayList<SolicitudViaticos> info = new ArrayList<SolicitudViaticos>();
				
				int i=0;
				
				while(resultados.next()) {
					objeto = new SolicitudViaticos();
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setGerente(resultados.getString("Gerente"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setMotivo(resultados.getString("Motivo"));
					objeto.setFacturarA(resultados.getString("FacturarA"));
					objeto.setViajeDesde(resultados.getString("ViajeDesde"));
					objeto.setViajeHasta(resultados.getString("ViajeHasta"));
					objeto.setItinerario(resultados.getString("Itinerario"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setHospedaje(resultados.getString("Hospedaje"));
					objeto.setAlimentos(resultados.getString("Alimentos"));
					objeto.setTaxi(resultados.getString("Taxi"));
					objeto.setRentaAutomovil(resultados.getString("RentaAutomovil"));
					objeto.setAvion(resultados.getString("Avion"));
					objeto.setTransporte(resultados.getString("Transporte"));
					objeto.setTotal(resultados.getString("Total"));
					objeto.setAutorizacion(resultados.getString("Autorizacion"));
					
					while (i==0){
						System.out.println("Las Solicitudes de Viaticos Autorizados considerados para el Reporte son de "+resultados.getString("Admon"));
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
						eDB.setQuery("insert into SolicitudViaticosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,Gerente,Nombre,Puesto,Motivo,FacturarA,ViajeDesde,ViajeHasta,Itinerario,Estacion,Hospedaje,Alimentos,Taxi,RentaAutomovil,Avion,Transporte,Total,Autorizacion) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,Gerente,Nombre,Puesto,Motivo,FacturarA,ViajeDesde,ViajeHasta,Itinerario,Estacion,Hospedaje,Alimentos,Taxi,RentaAutomovil,Avion,Transporte,Total,Autorizacion from SolicitudViaticos where Id = '" + id[i] + "'");
						eDB.setQuery("delete from SolicitudViaticos where Id = '" + id[i] + "'");
					}
				}
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				objeto = new SolicitudViaticos();
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Autorizar")) {
				eDB.setConexion();
				eDB.setQuery("update SolicitudViaticos set Autorizacion = 'AUTORIZADO' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into SolicitudViaticosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,Gerente,Nombre,Puesto,Motivo,FacturarA,ViajeDesde,ViajeHasta,Itinerario,Estacion,Hospedaje,Alimentos,Taxi,RentaAutomovil,Avion,Transporte,Total,Autorizacion) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,Gerente,Nombre,Puesto,Motivo,FacturarA,ViajeDesde,ViajeHasta,Itinerario,Estacion,Hospedaje,Alimentos,Taxi,RentaAutomovil,Avion,Transporte,Total,Autorizacion from SolicitudViaticos where Id = '" + request.getParameter("id") + "'");
								
				objeto = new SolicitudViaticos();
				imprimeJson(response,objeto);
				
				CorreosElectronicosHtml email = new CorreosElectronicosHtml();
				email.correoViaticosAutorizados(eDB, "" + request.getParameter("id"),session.getAttribute("IdUsuario").toString());
				eDB.setCerrar();
				eDB.setCerrarConexion();

				
			}
			else if(request.getParameter("Accion").equals("Rechazar")) {
				eDB.setConexion();
				eDB.setQuery("update SolicitudViaticos set Autorizacion = 'RECHAZADO' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into SolicitudViaticosApoyo (Quien,Registro,Borrar,IdOrigen,U,G,E,BM,BE,Fecha,Gerente,Nombre,Puesto,Motivo,FacturarA,ViajeDesde,ViajeHasta,Itinerario,Estacion,Hospedaje,Alimentos,Taxi,RentaAutomovil,Avion,Transporte,Total,Autorizacion) select '" + session.getAttribute("IdUsuario") + "',now(),'Si',Id,U,G,E,BM,BE,Fecha,Gerente,Nombre,Puesto,Motivo,FacturarA,ViajeDesde,ViajeHasta,Itinerario,Estacion,Hospedaje,Alimentos,Taxi,RentaAutomovil,Avion,Transporte,Total,Autorizacion from SolicitudViaticos where Id = '" + request.getParameter("id") + "'");
				
				objeto = new SolicitudViaticos();
				imprimeJson(response,objeto);
				
				CorreosElectronicosHtml email = new CorreosElectronicosHtml();
				email.correoViaticosRechazados(eDB, "" + request.getParameter("id"));
				eDB.setCerrar();
				eDB.setCerrarConexion();
			}
			else if(request.getParameter("Accion").equals("Consultar")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select A.* from SolicitudViaticos as A where A.Id = '" + request.getParameter("id") + "'");
				objeto = new SolicitudViaticos();
				while(resultados.next()) {
					objeto.setId(resultados.getInt("Id"));
					objeto.setFecha(resultados.getString("Fecha"));
					objeto.setGerente(resultados.getString("Gerente"));
					objeto.setNombre(resultados.getString("Nombre"));
					objeto.setPuesto(resultados.getString("Puesto"));
					objeto.setMotivo(resultados.getString("Motivo"));
					objeto.setFacturarA(resultados.getString("FacturarA"));
					objeto.setViajeDesde(resultados.getString("ViajeDesde"));
					objeto.setViajeHasta(resultados.getString("ViajeHasta"));
					objeto.setItinerario(resultados.getString("Itinerario"));
					objeto.setEstacion(resultados.getString("Estacion"));
					objeto.setHospedaje(resultados.getString("Hospedaje"));
					objeto.setAlimentos(resultados.getString("Alimentos"));
					objeto.setTaxi(resultados.getString("Taxi"));
					objeto.setRentaAutomovil(resultados.getString("RentaAutomovil"));
					objeto.setAvion(resultados.getString("Avion"));
					objeto.setTransporte(resultados.getString("Transporte"));
					objeto.setTotal(resultados.getString("Total"));
					objeto.setAutorizacion(resultados.getString("Autorizacion"));
				}
				eDB.setCerrar(resultados);
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
				imprimeJson(response,objeto);
			}
			else if(request.getParameter("Accion").equals("Modificar")) {
				eDB.setConexion();
				eDB.setQuery("update SolicitudViaticos set Fecha='" + traducciones.getFecha(request.getParameter("Fecha")) + "',Gerente='" + traducciones.getEntero(request.getParameter("Gerente")) + "',Nombre='" + request.getParameter("Nombre") + "',Puesto='" + request.getParameter("Puesto") + "',Motivo='" + request.getParameter("Motivo") + "',FacturarA=(select RFC from EmpresasGrupo where Id ='" + request.getParameter("FacturarA") + "'),ViajeDesde='" + traducciones.getFecha(request.getParameter("ViajeDesde")) + "',ViajeHasta='" + traducciones.getFecha(request.getParameter("ViajeHasta")) + "',Itinerario='" + request.getParameter("Itinerario") + "',Estacion='" + request.getParameter("Estacion") + "',Hospedaje='" + traducciones.getDecimal(request.getParameter("Hospedaje")) + "',Alimentos='" + traducciones.getDecimal(request.getParameter("Alimentos")) + "',Taxi='" + traducciones.getDecimal(request.getParameter("Taxi")) + "',RentaAutomovil='" + traducciones.getDecimal(request.getParameter("RentaAutomovil")) + "',Avion='" + traducciones.getDecimal(request.getParameter("Avion")) + "',Transporte='" + traducciones.getDecimal(request.getParameter("Transporte")) + "',Total='" + traducciones.getDecimal(request.getParameter("Total")) + "',Autorizacion='" + request.getParameter("Autorizacion") + "' where Id = '" + request.getParameter("id") + "'");
				eDB.setQuery("insert into SolicitudViaticosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,Fecha,Gerente,Nombre,Puesto,Motivo,FacturarA,ViajeDesde,ViajeHasta,Itinerario,Estacion,Hospedaje,Alimentos,Taxi,RentaAutomovil,Avion,Transporte,Total,Autorizacion) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,Fecha,Gerente,Nombre,Puesto,Motivo,FacturarA,ViajeDesde,ViajeHasta,Itinerario,Estacion,Hospedaje,Alimentos,Taxi,RentaAutomovil,Avion,Transporte,Total,Autorizacion from SolicitudViaticos where Id = '" + request.getParameter("id") + "'");

				
				objeto = new SolicitudViaticos();
				objeto.setId(Integer.parseInt(request.getParameter("id")));
					objeto.setFecha(request.getParameter("Fecha"));
					objeto.setGerente(request.getParameter("Gerente"));
					objeto.setNombre(request.getParameter("Nombre"));
					objeto.setPuesto(request.getParameter("Puesto"));
					objeto.setMotivo(request.getParameter("Motivo"));
					objeto.setFacturarA(request.getParameter("FacturarA"));
					objeto.setViajeDesde(request.getParameter("ViajeDesde"));
					objeto.setViajeHasta(request.getParameter("ViajeHasta"));
					objeto.setItinerario(request.getParameter("Itinerario"));
					objeto.setEstacion(request.getParameter("Estacion"));
					objeto.setHospedaje(request.getParameter("Hospedaje"));
					objeto.setAlimentos(request.getParameter("Alimentos"));
					objeto.setTaxi(request.getParameter("Taxi"));
					objeto.setRentaAutomovil(request.getParameter("RentaAutomovil"));
					objeto.setAvion(request.getParameter("Avion"));
					objeto.setTransporte(request.getParameter("Transporte"));
					objeto.setTotal(request.getParameter("Total"));
					objeto.setAutorizacion(request.getParameter("Autorizacion"));
				imprimeJson(response,objeto);
				
				CorreosElectronicosHtml email = new CorreosElectronicosHtml();
				email.correoSolicitudViaticos(eDB, "" + request.getParameter("id"));
				
				eDB.setCerrar();
				eDB.setCerrarConexion();
				
			}
			else if(request.getParameter("Accion").equals("getSolicitudViaticos")) {
				eDB.setConexion();
				resultados = eDB.getQuery("select Id, <columna> from SolicitudViaticos where <columna> like '" + request.getParameter("filter[value]") + "%'");
				ArrayList<SolicitudViaticos> info = new ArrayList<SolicitudViaticos>();
				while(resultados.next()) {
					objeto = new SolicitudViaticos();
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
			objeto = new SolicitudViaticos();
			armaLog(objeto,e);
			imprimeJson(response, objeto);
		} catch(NullPointerException e) {
			objeto = new SolicitudViaticos();
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
	
	private void imprimeJson(HttpServletResponse response, SolicitudViaticos objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void imprimeJson(HttpServletResponse response, ArrayList<SolicitudViaticos> objeto) throws IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		gson = new Gson();
		out.println(gson.toJson(objeto));
		out.flush();
		out.close();
	}
	
	private void armaLog(SolicitudViaticos objeto, Exception e) {
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
/* SolicitudViaticosServlet */
