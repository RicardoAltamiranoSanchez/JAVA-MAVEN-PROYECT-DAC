<%@ page import="java.sql.ResultSet" %>
<%@ page import="Libreria.MysqlPool" %>
<%@ page import="Libreria.CorreosElectronicos" %>
<%
MysqlPool eDB = new MysqlPool();
MysqlPool eDB2 = new MysqlPool();
eDB.setConexion();
eDB2.setConexion();
String hoy = "curdate()";
String query = "select E.Id,E.Division,EG.Admon as Admon,E.NombreCompleto,E.FechaIngreso,E.Vacaciones,E.Estatus," + 
					"floor(datediff(" + hoy + ",E.FechaIngreso)/365) as Ao, " +  
					"(V.DiasLey + V.DiasExtra) as TotalDias " + 
				"from Empleados as E inner join EmpresasGrupo as EG on (E.Division = EG.Id), EmpresasVacaciones as V " + 
				"where V.IdEmpresasGrupo = E.Division " + 
					"and E.Estatus = 'ACTIVO' " +  
					"and V.Ao = floor(datediff(" + hoy + ",E.FechaIngreso)/365) " + 
					"and substring(E.FechaIngreso,6,5) = substring(" + hoy + ",6,5)";
//out.println(query);
/*
+----+----------+------+------------+-----------+
| Id | Division | Ao   | Diferencia | TotalDias |
+----+----------+------+------------+-----------+
|  1 | 4        |    1 |     0.0000 |        10 |
+----+----------+------+------------+-----------+
*/

ResultSet datos = eDB.getQuery(query);
StringBuffer mensajeMex = new StringBuffer();
StringBuffer mensajeGdl = new StringBuffer();
mensajeMex.append("Los siguientes Trabajadores fueron renovados:\n");
mensajeMex.append("\n");
mensajeGdl.append("Los siguientes Trabajadores fueron renovados:\n");
mensajeGdl.append("\n");
while(datos.next()) {
	if (datos.getString("Admon").equals("MEX")){
		mensajeMex.append("Nombre: " + datos.getString("NombreCompleto"));
		mensajeMex.append("\n");
		mensajeMex.append("FechaIngreso: " + datos.getString("FechaIngreso"));
		mensajeMex.append("\n");
		mensajeMex.append("Dias Anteriores: " + datos.getString("Vacaciones"));
		mensajeMex.append("\n");
		mensajeMex.append("Dias: " + datos.getString("TotalDias"));
		mensajeMex.append("\n");
		mensajeMex.append("\n");
	}else{
		mensajeGdl.append("Nombre: " + datos.getString("NombreCompleto"));
		mensajeGdl.append("\n");
		mensajeGdl.append("FechaIngreso: " + datos.getString("FechaIngreso"));
		mensajeGdl.append("\n");
		mensajeGdl.append("Dias Anteriores: " + datos.getString("Vacaciones"));
		mensajeGdl.append("\n");
		mensajeGdl.append("Dias: " + datos.getString("TotalDias"));
		mensajeGdl.append("\n");
		mensajeGdl.append("\n");
	}
		
	if(datos.getInt("Vacaciones") < 0) {
		eDB2.setQuery("update Empleados set Vacaciones = Vacaciones + '" + datos.getString("TotalDias") + "' where Id = '" + datos.getString("Id") + "'");
	} else {
		eDB2.setQuery("update Empleados set Vacaciones = '" + datos.getString("TotalDias") + "' where Id = '" + datos.getString("Id") + "'");
	}
}

CorreosElectronicos emailMex = new CorreosElectronicos();
CorreosElectronicos emailGdl = new CorreosElectronicos();
String[] Mex = {"tigdl@mcs-holding.com","pgarza@mcs-holding.com"};
String[] Gdl = {"tigdl@mcs-holding.com","ralessi@mcs-holding.com"}; 
//String[] a = {"tigdl@mcs-holding.com"};
emailMex.setA(Mex);
emailGdl.setA(Gdl);
emailMex.setTitulo("Renovacion de Vacaciones");
emailGdl.setTitulo("Renovacion de Vacaciones");
emailMex.setMensaje(mensajeMex.toString());
emailGdl.setMensaje(mensajeGdl.toString());
emailMex.enviar();
emailGdl.enviar();


eDB2.setCerrarConexion();
eDB.setCerrarConexion();

%>