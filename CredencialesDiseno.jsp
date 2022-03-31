<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  </head>
  <body>
<%
if(request.getParameter("CredencialDiseno").equals("Blanco")) {
%>
	<img src="credenciales/BaseCrede.jpg" width="60%" border="1">
<%
} else if(request.getParameter("CredencialDiseno").equals("CenefaSupMCS")){
%>
	<img src="credenciales/MCSCenefaCrede.jpg" width="60%" border="1">
<%
}
%>    
  </body>
</html>
