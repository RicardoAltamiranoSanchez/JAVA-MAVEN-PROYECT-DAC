<%@ page import="Configuraciones.Generales"%><%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%>
<%@ page import="Libreria.MysqlPool" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ include file="valida.jsp" %>
<%
	Generales generales = new Generales();
	Propiedades propiedades = new Propiedades();
	MysqlPool eDB = new MysqlPool();

	ResultSet resultados, datos;

	String mensaje = "";
	String error = "";
	String colorFila = "bgcolor=\"#EBEBEB\"";
	String fondoFila = "";
	
	try {
		request.getParameter("Accion").equals("");
		eDB.setConexion();
		resultados = eDB.getQuery("select if(Password = md5('" + request.getParameter("Anterior1") + "'),'Si','No') as Mismo from Usuarios where Id = '" + session.getAttribute("IdUsuario") + "'");
		while(resultados.next()) {
			if(resultados.getString("Mismo").equals("Si")) {
				datos = eDB.getQuery("select * from (select Registro, Usuario, Password from UsuariosApoyo where IdOrigen = '" + session.getAttribute("IdUsuario") + "' order by Registro desc limit 5) as A where A.Password = md5('" + request.getParameter("Nuevo1") + "')");
				if(datos.next()) {
					error = "<font color=red>EL PASSWORD NO DEBE SER IGUAL A LOS 5 ANTERIORES.</font>";
					out.println(mensaje);
				} else {
					eDB.setQuery("update Usuarios set Password = md5('" + request.getParameter("Nuevo1") + "'), UltimoPassword = curdate() where Id = '" + session.getAttribute("IdUsuario") + "'");
					eDB.setQuery("insert into UsuariosApoyo (Quien,Registro,IdOrigen,U,G,E,BM,BE,IdGrupos,IdEmpresas,IdPerfilesUsuarios,Usuario,Nombre,Password,Estacion,OtrasEstaciones,Email,EmailAlternativo,Estatus,MotivoEstatus,UltimoLogin,UltimoPassword) select '" + session.getAttribute("IdUsuario") + "',now(),Id,U,G,E,BM,BE,IdGrupos,IdEmpresas,IdPerfilesUsuarios,Usuario,Nombre,Password,Estacion,OtrasEstaciones,Email,EmailAlternativo,Estatus,MotivoEstatus,UltimoLogin,UltimoPassword from Usuarios where Id = '" + session.getAttribute("IdUsuario") + "'");
					error = "CAMBIO REALIZADO.";
					if(request.getParameter("Estatus").equals("Nuevo")) {
						eDB.setQuery("update Usuarios set Estatus = 'ACTIVO' where Id = '" + session.getAttribute("IdUsuario") + "'");
						response.sendRedirect(generales.getProtocolo() + "://" + request.getServerName() + generales.getPuerto() +  "/" + generales.getDirectorio() + "/sistema.jsp");
					}	
				}	
			} else {
				error = "<font color=red>EL PASSWORD ANTERIOR NO COINCIDE.</font>";
			}
		}
		eDB.setCerrarConexion();
	} catch(Exception e) {
	}
	
	
	String[] idioma3 = {
	"",
	"CONTRASEÑA RECIBIDA",
	"DEFINA UNA NUEVA",
	"CONFIRME LA NUEVA",
	"DATO REQUERIDO",
	"PASSWORD NO COINCIDEN"
	};
	
	String[] idioma3Ingles = {
	"",
	"PASSWORD RECEIVED",
	"CREATE NEW PASSWORD",
	"CONFIRM NEW PASSWORD",
	"INSERT DATA",
	"PASSWORD MISMATCH"
	};	

	try {
		if(session.getAttribute("Idioma").equals("Ingles")) { idioma3 = idioma3Ingles; }
	} catch(NullPointerException e) {
	}	
	
	String[] idiomaBoton = { "CAMBIAR" };
	
	String[] idiomaBotonIng = { "CHANGE" };		
	
	try {
		if(session.getAttribute("Idioma").equals("Ingles")) { idiomaBoton = idiomaBotonIng; }
	} catch(NullPointerException e) {
	}		
	

	int tabindex = 1;
	
	String estatus = "";
	
	try {
		request.getParameter("Estatus").equals("");
		if(request.getParameter("Estatus").equals("Nuevo")) {
			mensaje = "FAVOR DE CAMBIAR TU CONTRASEÑA.";
			estatus = "Nuevo";
		}
	} catch(NullPointerException e1) {
	}
	
%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<script>

    
webix.ui({id:'principal',type:'space',rows:[
    {type:'header', template:'<%=mensaje%>'},
    {view:'form',id:'Forma',width:400,elements:[
    	{view:'text',id:'Anterior1',name:'Anterior1',type:'password',value:'',placeholder:'<%=idioma3[1]%>',label:'<%=idioma3[1]%>',labelWidth:140,required:true},
		{view:'text',id:'Nuevo1',name:'Nuevo1',type:'password',value:'',placeholder:'<%=idioma3[2]%>',label:'<%=idioma3[2]%>',labelWidth:125,required:true},
		{view:'text',id:'Nuevo2',name:'Nuevo2',type:'password',value:'',placeholder:'<%=idioma3[3]%>',label:'<%=idioma3[3]%>',labelWidth:125,required:true},
		{view:'text',id:'Accion',name:'Accion',value:'Cambiar',placeholder:'',label:'',hidden:true},
		{view:'text',id:'Estatus',name:'Estatus',value:'<%=estatus %>',placeholder:'',label:'',hidden:true},
		{view:'label',id:'Mensaje',label:'<%=error%>',align:'center'},{view:'toolbar', cols:[{},{view:'button',value:'<%=idiomaBoton[0] %>',width:85, click:'cambiar'}]}]}
    ]});

function iguales() {
	var enviar = false;
	var error = '<span class="txt11"><font color=red><%=idioma3[5]%></font></span>';
	var error1 = '<span class="txt11"><font color=red>LONGITUD MINIMA DE 8 CARACTERES</font></span>';
	var error2 = '<span class="txt11"><font color=red>USAR CARACTERES ALFANUMERICOS</font></span>';
	
	var uno = $$('Nuevo1').getValue();
	var dos = $$('Nuevo2').getValue();
	
	if(uno != '' & dos != '') {
		
	
		if(uno == dos) {
			enviar = true
			$$('Mensaje').setValue('');
		} else {
			webix.message(error);
			$$('Mensaje').setValue(error);
		}
		
		if(uno != '') { 
			if(uno.length < 8) { enviar = false; webix.message(error1); $$('Mensaje').setValue(error1); } else { $$('Mensaje').setValue(''); }
			if(!checkAlphaNumerics(uno)) { enviar = false; webix.message(error2); $$('Mensaje').setValue(error2); }
			if(!checkAlphaNumerics1(uno)) { enviar = false; webix.message(error2); $$('Mensaje').setValue(error2); }
			if(!checkAlphaNumerics2(uno)) { enviar = false; webix.message(error2); $$('Mensaje').setValue(error2); }
		}
		
	}
	return enviar;
}

$$('Nuevo1').attachEvent('onChange',function(nuevo, anterior){ iguales(); });
$$('Nuevo2').attachEvent('onChange',function(nuevo, anterior){ iguales(); });

function checkAlphaNumerics(checkString) {
  var regExp = /^[A-Za-z0-9]$/;
  if(checkString!= null && checkString!= "")
        {
          for(var i = 0; i < checkString.length; i++)
          {
            if (!checkString.charAt(i).match(regExp))
            {
              return false;
            }
          }
        }
        else
        {
          return false;
        }
        return true;
}

function checkAlphaNumerics1(checkString) {
    var regExp = /^[A-Za-z]$/;
    var pasa = false;
	if(checkString!= null && checkString!= "") {
          for(var i = 0; i < checkString.length; i++) {
            if (checkString.charAt(i).match(regExp)) {
              pasa = true;
            }
          }
    } 
    return pasa;
}

function checkAlphaNumerics2(checkString) {
    var regExp = /^[0-9]$/;
    var pasa = false;
	if(checkString!= null && checkString!= "") {
          for(var i = 0; i < checkString.length; i++) {
            if (checkString.charAt(i).match(regExp)) {
              pasa = true;
            }
          }
    } 
    return pasa;
}

function validar() {
	var enviar = true;
	enviar = iguales();
	return enviar;
}

function cambiar() {
	if(validar()) {
		if($$('Forma').validate()) {
			var valores=$$('Forma').getValues();
			webix.send("Password.jsp",valores, "POST");
		}
	}
}

</script>