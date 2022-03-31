<%@ page import="java.sql.ResultSet" %>
<%@ page import="Libreria.MysqlPool" %>
<%
MysqlPool eDB = new MysqlPool();
eDB.setConexion();
String query = "insert ignore into MexReporteRegistroVisitas " + 
		"select " + 
		"  A.Id, A.Nombre, A.Gafete, A.FechaHora as FechaHoraEntrada," + 
		"  (select FechaHora from MexRegistroRecepcion where Gafete = A.Gafete and FechaHora > A.FechaHora and FechaHora < B.FechaHora order by Id limit 1) Recepcion," + 
		"  (select FechaHora from MexRegistroFila where Gafete = A.Gafete and FechaHora > A.FechaHora and FechaHora < B.FechaHora order by Id limit 1) Fila," + 
		"  (select FechaHora from MexRegistroDocumentacion where Gafete = A.Gafete and FechaHora > A.FechaHora and FechaHora < B.FechaHora order by Id limit 1) Documentacion, " + 
		"  B.Prefijo, B.Awb, B.Observaciones, B.FechaHora as FechaHoraSalida, CONCAT(Timediff(B.FechaHora,A.FechaHora),'') as TiempoAlmacen " + 
		"from " + 
		"  MexRegistroEntradasAlmacen as A, MexRegistroSalidasAlmacen as B " + 
		"where " + 
		"  A.FechaHora > date_sub(now(),interval 12 hour)" + 
		"  and B.IdMexRegistroEntradasAlmacen = A.Id  ";

eDB.setQuery(query);
eDB.setCerrarConexion();
%>