<%@ page import="Configuraciones.Generales"%>
<%@ page import="Configuraciones.Propiedades"%>
<%@ page import="java.util.Properties"%>
<%@ page import="Html.EncabezadoPie" %>
<%@ include file="valida.jsp" %>
<% Propiedades propiedades = new Propiedades(); %>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo()) %>
<%
	Properties relacionIdModulos = (Properties)session.getAttribute("RelacionIdModulos");
	session.setAttribute("Modulo",request.getParameter("Modulo"));
	String id = relacionIdModulos.getProperty(request.getParameter("Archivo"));
	session.setAttribute("IdModulos",id);
 %>
<%=EncabezadoPie.getPie() %>

