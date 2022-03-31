<!doctype html>
<html>
<head>
	<title>Intranet MCS Holding</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link href='http://fonts.googleapis.com/css?family=Alegreya+Sans+SC:500' rel='stylesheet' type='text/css'>
	<link href='http://fonts.googleapis.com/css?family=Hind:400,700' rel='stylesheet' type='text/css'>
	<link href='http://www.mcs-holding.com/css/fuentes.css' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" href="css/webix_anterior.css" type="text/css">
	<script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>
	<script src="js/webix_anterior.js" type="text/javascript"></script>
	<style>
		#encabezado {
			background-image: url('imagenes/1x150_BG_Superior_Intranet.png');
			height: 150px;
			top: 0px;
			left: 0px;
			position: absolute;
		}
		#contenido {
			background-image: url('imagenes/1x600_BG_LogIn_Azul-01.png');
			height: 600px;
			top: 150px;
			left: 0px;
			position: absolute;
		}
		#pie {
			background-image: url('imagenes/1x500_FondoMapaSitio_ABAJO-01.png');
			top:750px;
			left: 0px;
			height: 500px;
			position: absolute;
		}
		
	.webix_view.webix_form {
		background-color: transparent;
	}		
	.botonSuscribete {
		background-image: url('imagenes/250x45_BotonNewsletter-01.png');
		background-repeat: no-repeat;
		background-color: transparent;
		width: 250px;
		height: 45px; 
		border:	none;
		color: white;
		font-family: 'Hind', sans-serif;
		font-size: 24px;
	}

	</style>	
</head>
<body>
<div id="encabezado">
	<table width="100%" height=150">
		<tr><td align="center"><img src="imagenes/374x80_LOG_Intranet_Intranet.png"></td></tr>
	</table>
</div>
<div id="contenido">
<table width="100%">
<tr><td height="30"></td></tr>
<tr><td align="center">
  <table border=0 cellpadding="0" cellspacing="0" height="120" width="800">
  	<tr><td>
	  	<table border=0 cellpadding="0" cellspacing="0" height="120" width="564" background="imagenes/564x120_FondoLOG_Intranet_FondoLOG_Intranet.png">
				<tr height="100">
					<td width="20"></td>
					<td><img src="imagenes/100x80_ImagenLogIn-01.png"></td>
					<td width="40"></td>
					<td><div id="areaA"></div></td>
				</tr>
				<tr>
					<td colspan="4" align="right"><img src="imagenes/105x15_LOG_LogoCloud-01.png"></td>
				</tr>
		</table>
  	</td></tr>
  	<tr><td align="right">
  		<img src="imagenes/450x152_LogoDAC_Intranet_DAC.png">
  	</td></tr>
  </table>
</td></tr>
<tr>
	<td height="250" valign="bottom" align="left" class="texto-hindBlanco">Intranet Domestic<br>Derechos Reservados 2015</td>
</tr>
</table>
</div>
<%@ include file="mapa.html"%>
<script>
var form1 = [
	{ view:'text', id:'Usuario', name:'Usuario', value:'', height:25, placeholder:'USUARIO', label:'USUARIO', required:true },
	{ view:'text', id:'Password', name:'Password', type:'password', height:25, placeholder:'CLAVE', label:'CLAVE', required:true },
	{ cols:[
		{ view:'button', value:'CANCELAR', click:'limpiar()' },
		{ view:'button', value:'INGRESAR', type:'form', click:'enviar()' },
		{ view:'button', value:'RECUPERAR CUENTA', click:'recuperar()' }
	]}
];

var form2 = [
	{ view:'text', id:'Correo', name:'Correo', value:'', height:25, placeholder:'CORREO', label:'CORREO', required:true },
	{ cols:[
		{ view:'button', value:'REGRESAR', click:'regresar()' },
		{ view:'button', value:'ENVIAR', type:'form', click:'enviarCuenta()' }
	]}
];
	
webix.ui({
	container:'areaA',
	rows:[
			{ view:'form', id:'formaLogin', height:68, width:380, borderless:true, elements: form1},
			{ view:'form', id:'formaCuenta', height:68, width:380, borderless:true, elements: form2, hidden:true}
	]
});

function enviar() {
	if($$('formaLogin').validate()) {
		$$('formaLogin').setValues({NumeroIntentos:10, BloqueaYRegistra:''},true);
		var values = $$('formaLogin').getValues();
		webix.ajax().post('servlet/Login',values, function(text,data){ if(data.json().Valido) { document.location = data.json().Archivo;} else { } });
	}
}

function limpiar() {
	$$('formaLogin').clear();
	$$('formaCuenta').clear();
}

function recuperar(){
	$$('formaLogin').hide();
	$$('formaCuenta').show();
}

function regresar(){
	$$('formaCuenta').hide();
	$$('formaLogin').show();
	$$('formaCuenta').clear();
}

function enviarCuenta() {
	if($$('formaLogin').validate()) {
		$$('formaCuenta').setValues({Accion:'recuperarCuenta'},true);
		var values = $$('formaCuenta').getValues();
		webix.ajax().post('servlet/RecuperarCuentaServlet',values, {
			error:function(text,data,XmlHttpRequest){
					webix.message("ERROR DE COMUNICACION");$$('Mensaje').setValue('<font color="red"><strong>ERROR DE COMUNICACION	</strong></font>');
			},success:function(text,data,XmlHttpRequest){
					if(data.json().IdUsuario == ""){
						webix.message("CORREO NO REGISTRADO EN SISTEMA");
					}else{
						alert("SE ENVIARA UN CORREO CON SU CUENTA");
						document.location = "index.jsp";
					}
			} 
			
		});
	}
}

webix.ready(function(){
	document.getElementById('encabezado').style.width = window.innerWidth ;
	document.getElementById('contenido').style.width = window.innerWidth;
});	

$(document).ready(function(){
	$('#encabezado').width($(this).width());
	$('#contenido').width($(this).width());
	$('#pie').width($(this).width());
});
</script>
</body>
</html>