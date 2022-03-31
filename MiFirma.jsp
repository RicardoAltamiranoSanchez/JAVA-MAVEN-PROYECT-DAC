<%@ page import="Configuraciones.Propiedades"%><%@ page import="Html.EncabezadoPie"%><%@ page import="java.util.Properties"%><%@ page import="java.io.FileWriter" %>
<%@ include file="valida.jsp" %>
<%Propiedades propiedades = new Propiedades();
String moduloIdioma = "331";
Properties idioma = (Properties)session.getAttribute("IdiomaGeneral");
Properties idiomaModulo = (Properties)session.getAttribute(moduloIdioma);%>
<%=EncabezadoPie.getEncabezado(propiedades.getTitulo())%>
<script>
var errorComunicacion='<%=idioma.getProperty("errorComunicacion") %>';
var errorEjecutarAccion='<%=idioma.getProperty("errorEjecutarAccion") %>';
var registroGuardado='<%=idioma.getProperty("registroGuardado") %>';
var registroModificado='<%=idioma.getProperty("registroModificado") %>';
var tituloEliminado='<%=idioma.getProperty("tituloEliminado") %>';
var registroEliminado='<%=idioma.getProperty("registroEliminado") %>';
var seguroDeseaEliminar='<%=idioma.getProperty("seguroDeseaEliminar") %>';
var busquedaFinalizada='<%=idioma.getProperty("busquedaFinalizada") %>';
var unRegistro='<%=idioma.getProperty("unRegistro") %>';
var soloUnRegistro='<%=idioma.getProperty("soloUnRegistro") %>';
var id='';
var si='<%=idioma.getProperty("si") %>';
var no='<%=idioma.getProperty("no") %>';
var nada='';
var guardado='<%=idioma.getProperty("guardado") %>';
var modificado='<%=idioma.getProperty("modificado") %>';
var etiquetaNuevo = '<%=idioma.getProperty("etiquetaNuevo") %>';
var etiquetaGuardar = '<%=idioma.getProperty("etiquetaGuardar") %>';
var etiquetaModificar = '<%=idioma.getProperty("etiquetaModificar") %>';
var etiquetaBuscar = '<%=idioma.getProperty("etiquetaBuscar") %>';
var etiquetaBorrar = '<%=idioma.getProperty("etiquetaBorrar") %>';

var IdUsuario = 'Id Usuario';
var Nombre = 'Nombre';
var Titulo = 'Titulo';
var Email = 'Email';
var Nextel = 'Cel';
var NextelId = 'Nextel Id';
var FirmaGrupoHtml = 'Firma del Grupo';
var value = 'Value';

//var MiIdUsuario= webix.storage.session.get('IdUsuario');

<%
out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");
%>

var forma={view:'form',id:'Forma',width:400,height:'100%',elements:[
	{view:'text',id:'IdUsuario',name:'IdUsuario',value:'',placeholder:IdUsuario,label:IdUsuario,required:true},
	{view:'text',id:'Nombre',name:'Nombre',value:'',placeholder:Nombre,label:'NOMBRE',required:true},
	{view:'text',id:'Titulo',name:'Titulo',value:'',placeholder:Titulo,label:'TITULO',required:true},
	{view:'text',id:'Email',name:'Email',value:'',placeholder:Email,label:'EMAIL',required:true},
	{view:'text',id:'Nextel',name:'Nextel',value:'',placeholder:Nextel,label:'CEL',required:false},
	{view:'text',id:'NextelId',name:'NextelId',value:'',placeholder:NextelId,label:'NEXTEL ID',required:false,hidden:true},
	{view:'label',id:'FirmaGrupoHtml',name:'FirmaGrupoHtml',value:'',placeholder:FirmaGrupoHtml,label:FirmaGrupoHtml,required:false,hidden:true},
	{view:'label',id:'value',name:'value',value:'',placeholder:value,label:value,required:false},
{view:'label',id:'Mensaje',label:'',align:'center'},{view:'toolbar', cols:[{view:'button',id:'BotonNuevo',value:etiquetaNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonGuardar',value:etiquetaGuardar,width:85,click:'guardar'},{view:'button',id:'BotonModificar',value:etiquetaModificar,width:85,click:'modificar',hidden:true},{view:'button',value:etiquetaBuscar,width:85,click:'buscar'},{view:'button',id:'BotonGenerarHtml',value:'Generar HTML',width:95,click:'generar',hidden:false}]}]};
var lista={view:'list',id:'Confirmacion',template:'#campo# : #value#'};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'toolbar',id:'TablaTools',cols:[{view:'button',value:etiquetaBorrar,width:85,click:'borrar'},{view:'button',value:etiquetaModificar,width:85,click:'consultar'}]},{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,columns:[
	{id:'IdUsuario',header:IdUsuario,fillspace:true,sort:'string'},
	{id:'Nombre',header:Nombre,sort:'string'},
	{id:'Titulo',header:Titulo,sort:'string'},
	{id:'Email',header:Email,sort:'string'},
	{id:'Nextel',header:Nextel,sort:'string'},
	{id:'NextelId',header:NextelId,sort:'string'}]}]};
var vacio={id:'Vacio'};
webix.ui({id:'principal',type:'space',rows:[{type:'header', template:'GENERAR MI FIRMA'},{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{header:' ',body:forma},{animate:{type:'flip'},cells:[vacio,lista,tabla]}]}]});	
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}}
function nuevo(){$$('BotonGuardar').show();$$('BotonModificar').hide();$$('Forma').clear();$$('Confirmacion').clearAll();$$('Tabla').clearAll();$$('Mensaje').setValue(nada);$$('Vacio').show();iniciales();}
function guardar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Guardar'},true); if($$('Forma').validate()) { enviar(registroGuardado,'Guardar'); $$('Confirmacion').show();}}
function guardarDespues(){/* $$('Forma').clear(); */inicial();}
function borrar(){webix.confirm({title:tituloEliminado,ok:si,cancel:no,type:'confirm-error',text:seguroDeseaEliminar,callback:function(result){if(result){var ids=$$('Tabla').getSelectedId();if(ids == null) {webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>' + unRegistro + '</strong></font>');}else{$$('Forma').setValues({Accion:'Borrar',Ids:ids},true);enviar(registroEliminado,'Borrar');}}else{$$('Tabla').clearSelection();}}});}
function borrarDespues(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(registroEliminado,'Buscar');}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(busquedaFinalizada,'Buscar');}

function llenarValores(){$$('Forma').setValues({Accion:'LlenarValores'},true);enviar(busquedaFinalizada,'LlenarValores');}

function consultar(){$$('BotonGuardar').hide();$$('BotonModificar').show();var ids=$$('Tabla').getSelectedId();if(ids==null){webix.message(unRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+unRegistro+'</strong></font>');}else{if(ids.length>1){webix.message(soloUnRegistro);$$('Mensaje').setValue('<font color="blue"><strong>'+soloUnRegistro+'</strong></font>');$$('Tabla').clearSelection();}else{$$('Forma').setValues({Accion:'Consultar',id:ids},true);enviar('','Consultar');}}}
function modificar(){$$('Confirmacion').clearAll();$$('Forma').setValues({Accion:'Modificar'},true);if($$('Forma').validate()){enviar(registroModificado,'Modificar');$$('Confirmacion').show();}}	
function modificarDespues(){}

function generar(){
	var NextelHtml; //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	var NextelIdHtml; //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	
	if ($$('Nextel').getValue() == ''){ //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
		NextelHtml = '</span>'; //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	}else{ //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
		NextelHtml = '/ </span><span style="color: rgb(5, 27, 63); display: inline;" class="txt signature_mobilephone-target sig-hide"><b>NEXTEL: </b>'+$$('Nextel').getValue(); //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	} //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	
	if ($$('NextelId').getValue() == ''){ //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
		NextelIdHtml = ''; //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	}else{ //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
		NextelIdHtml = ' / <b>ID: </b>'+$$('NextelId').getValue(); //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	} //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	
	var NombreHtml =$$('Nombre').getValue(); //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	var TituloHtml=$$('Titulo').getValue(); //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	var EmailHtml=$$('Email').getValue(); //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	var BannerHtml=$$('value').getValue(); //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	var FirmaHtml = $$('FirmaGrupoHtml').getValue(); //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES


	alert(FirmaHtml);
	//alert(FirmaHtml.replace("=NOMBRE=","'+NombreHtml+'").replace("=TITULO=","'+TituloHtml+'").replace("=EMAIL=","'+EmailHtml+'").replace("=NEXTEL=NEXTELID=","'+NextelHtml+NextelIdHtml+'").replace("=BANNER=","'+BannerHtml+'")); //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
	//alert('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional //EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> <html><body><div style="text-size-adjust: none !important; -ms-text-size-adjust: none !important; -webkit-text-size-adjust: none !important;"> <p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; margin-bottom: 10px;"> </p> <p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; color: rgb(33, 33, 33); margin-bottom: 10px;"> <span style="font-weight: bold; color: rgb(5, 27, 63); display: inline;" class="txt signature_name-target sig-hide"> '+NombreHtml+' </span> <span class="title-sep sep" style="display: inline;"> / </span> <span style="color: rgb(5, 27, 63); display: inline;" class="txt signature_jobtitle-target sig-hide">'+TituloHtml+'</span><span class="email-sep break" style="display: inline;"> <br> </span> <a class="link email signature_email-target sig-hide" href="mailto:'+EmailHtml+'" style="color: rgb(0, 90, 155); text-decoration: none; display: inline;">'+EmailHtml+'</a> <span class="signature_email-sep sep" style="display: inline;">'+NextelHtml+NextelIdHtml+'</span> </p> <p class="company-info" style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; margin-bottom: 10px;"><span style="font-weight: bold; color: rgb(5, 27, 63); display: inline;" class="txt signature_companyname-target sig-hide">MCS Cargo Sales</span><span class="company-sep break" style="display: inline;"><br></span><span style="color: rgb(5, 27, 63); display: inline;" class="txt signature_officephone-target sig-hide">+(5233) 3563 9790 /9791</span><span style="color: rgb(5, 27, 63);" class="txt signature_fax-target sig-hide"></span><span class="address2-sep break" style="display: inline;"><br></span> <span style="color: rgb(5, 27, 63);" class="txt signature_address2-target sig-hide"></span><span class="website-sep break" style="display: block;"></span><a class="link signature_website-target sig-hide" href="http://www.mcs-holding.com" style="color: rgb(0, 90, 155); text-decoration: none; display: inline;"><b>www.mcs-holding.com</b></a></p><p class="social-list" style="font-size: 0px; line-height: 0; font-family: Helvetica, Arial, sans-serif;"><a style="text-decoration: none; display: inline;" class="social signature_twitter-target sig-hide" href="https://htmlsig.com/t/000001CTEDDZ"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="twitter.png" src="https://s3.amazonaws.com/htmlsig-assets/round/twitter.png" alt="Twitter"></a><span style="white-space: nowrap; display: inline;" class="signature_twitter-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span><a style="text-decoration: none; display: inline;" class="social signature_facebook-target sig-hide" href="https://htmlsig.com/t/000001CWQR10"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="facebook.png" src="https://s3.amazonaws.com/htmlsig-assets/round/facebook.png" alt="Facebook"></a><span style="white-space: nowrap; display: inline;" class="signature_facebook-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span><a style="text-decoration: none; display: inline;" class="social signature_googleplus-target sig-hide" href="https://htmlsig.com/t/000001CWF4NS"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="googleplus.png" src="https://s3.amazonaws.com/htmlsig-assets/round/googleplus.png" alt="Google +"></a><span style="white-space: nowrap; display: inline;" class="signature_googleplus-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span><a style="text-decoration: none; display: inline;" class="social signature_linkedin-target sig-hide" href="https://htmlsig.com/t/000001CTNWZ3"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="linkedin.png" src="https://s3.amazonaws.com/htmlsig-assets/round/linkedin.png" alt="LinkedIn"></a><span style="white-space: nowrap; display: inline;" class="signature_linkedin-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span></p><p style="font-family: Helvetica, Arial, sans-serif; color: rgb(5, 27, 63); font-size: 9px; line-height: 12px;" class="txt signature_disclaimer-target">*** <b>Hora de corte reservación</b> Guía Master y House scan: <b>1730L</b><br>*** <b>Hora de corte entrega</b> de documentos originales <u>(Lunes a Viernes)</u>: <b>2000L</b><br>*** <b>Hora de corte entrega</b> de documentos originales <u>(Sábados y Domingos)</u>: <b>1400L</b><br>*** Favor de entregar <b>comprobante de peso por WTC</b><br>*** <b>NO contamos con buzón</b> para entrega de documentos, <u>favor de entregar a personal de <b>MCS</b></u><br><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OPERACIONES (AEROPUERTO GDL):</b> +(5233) 3688 8247 / CEL: +(521) 332 066 5270</p><p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; margin-bottom: 10px;"><img src="'+BannerHtml+'.png" alt="'+BannerHtml+'" border="0" width="545"></p></div></body></html>');

 
	//    var value = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional //EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> <html><body><div style="text-size-adjust: none !important; -ms-text-size-adjust: none !important; -webkit-text-size-adjust: none !important;"> <p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; margin-bottom: 10px;"> </p> <p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; color: rgb(33, 33, 33); margin-bottom: 10px;"> <span style="font-weight: bold; color: rgb(5, 27, 63); display: inline;" class="txt signature_name-target sig-hide"> '+NombreHtml+' </span> <span class="title-sep sep" style="display: inline;"> / </span> <span style="color: rgb(5, 27, 63); display: inline;" class="txt signature_jobtitle-target sig-hide">'+TituloHtml+'</span><span class="email-sep break" style="display: inline;"> <br> </span> <a class="link email signature_email-target sig-hide" href="mailto:'+EmailHtml+'" style="color: rgb(0, 90, 155); text-decoration: none; display: inline;">'+EmailHtml+'</a> <span class="signature_email-sep sep" style="display: inline;">'+NextelHtml+NextelIdHtml+'</span> </p> <p class="company-info" style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; margin-bottom: 10px;"><span style="font-weight: bold; color: rgb(5, 27, 63); display: inline;" class="txt signature_companyname-target sig-hide">MCS Cargo Sales</span><span class="company-sep break" style="display: inline;"><br></span><span style="color: rgb(5, 27, 63); display: inline;" class="txt signature_officephone-target sig-hide">+(5233) 3563 9790 /9791</span><span style="color: rgb(5, 27, 63);" class="txt signature_fax-target sig-hide"></span><span class="address2-sep break" style="display: inline;"><br></span> <span style="color: rgb(5, 27, 63);" class="txt signature_address2-target sig-hide"></span><span class="website-sep break" style="display: block;"></span><a class="link signature_website-target sig-hide" href="http://www.mcs-holding.com" style="color: rgb(0, 90, 155); text-decoration: none; display: inline;"><b>www.mcs-holding.com</b></a></p><p class="social-list" style="font-size: 0px; line-height: 0; font-family: Helvetica, Arial, sans-serif;"><a style="text-decoration: none; display: inline;" class="social signature_twitter-target sig-hide" href="https://htmlsig.com/t/000001CTEDDZ"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="twitter.png" src="https://s3.amazonaws.com/htmlsig-assets/round/twitter.png" alt="Twitter"></a><span style="white-space: nowrap; display: inline;" class="signature_twitter-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span><a style="text-decoration: none; display: inline;" class="social signature_facebook-target sig-hide" href="https://htmlsig.com/t/000001CWQR10"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="facebook.png" src="https://s3.amazonaws.com/htmlsig-assets/round/facebook.png" alt="Facebook"></a><span style="white-space: nowrap; display: inline;" class="signature_facebook-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span><a style="text-decoration: none; display: inline;" class="social signature_googleplus-target sig-hide" href="https://htmlsig.com/t/000001CWF4NS"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="googleplus.png" src="https://s3.amazonaws.com/htmlsig-assets/round/googleplus.png" alt="Google +"></a><span style="white-space: nowrap; display: inline;" class="signature_googleplus-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span><a style="text-decoration: none; display: inline;" class="social signature_linkedin-target sig-hide" href="https://htmlsig.com/t/000001CTNWZ3"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="linkedin.png" src="https://s3.amazonaws.com/htmlsig-assets/round/linkedin.png" alt="LinkedIn"></a><span style="white-space: nowrap; display: inline;" class="signature_linkedin-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span></p><p style="font-family: Helvetica, Arial, sans-serif; color: rgb(5, 27, 63); font-size: 9px; line-height: 12px;" class="txt signature_disclaimer-target">*** <b>Hora de corte reservación</b> Guía Master y House scan: <b>1730L</b><br>*** <b>Hora de corte entrega</b> de documentos originales <u>(Lunes a Viernes)</u>: <b>2000L</b><br>*** <b>Hora de corte entrega</b> de documentos originales <u>(Sábados y Domingos)</u>: <b>1400L</b><br>*** Favor de entregar <b>comprobante de peso por WTC</b><br>*** <b>NO contamos con buzón</b> para entrega de documentos, <u>favor de entregar a personal de <b>MCS</b></u><br><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OPERACIONES (AEROPUERTO GDL):</b> +(5233) 3688 8247 / CEL: +(521) 332 066 5270</p><p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; margin-bottom: 10px;"><img src="'+BannerHtml+'.png" alt="'+BannerHtml+'" border="0" width="545"></p></div></body></html>';
	//    var msg = value;
    	// assume that the filename will be also be constructed like msg as 
    	// as above.

	//    document.location = 'data:Application/octet-stream,' + encodeURIComponent(msg)
    
  					  /* var blob = new Blob([msg.toString()], { type: "application/html" });
						webix.html.download(blob, "myfile.html"); */

	//alert('Entré'+NextelHtml);
	
	
	
		function download(filename, text) {
		  var element = document.createElement('a');
  			element.setAttribute('href', 'data:html/plain;charset=utf-8,' + encodeURIComponent(text)); //EN data: se especifica el tipo de archivo a generar, ejemplo html, text, etx
  			element.setAttribute('download', filename);

		  element.style.display = 'none';
		  document.body.appendChild(element);
		
		  element.click();
		
		  document.body.removeChild(element);
		}

// Start file download.
//download("Firma "+NombreHtml+".html",'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional //EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> <html><body><div style="text-size-adjust: none !important; -ms-text-size-adjust: none !important; -webkit-text-size-adjust: none !important;"> <p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; margin-bottom: 10px;"> </p> <p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; color: rgb(33, 33, 33); margin-bottom: 10px;"> <span style="font-weight: bold; color: rgb(5, 27, 63); display: inline;" class="txt signature_name-target sig-hide"> '+NombreHtml+' </span> <span class="title-sep sep" style="display: inline;"> / </span> <span style="color: rgb(5, 27, 63); display: inline;" class="txt signature_jobtitle-target sig-hide">'+TituloHtml+'</span><span class="email-sep break" style="display: inline;"> <br> </span> <a class="link email signature_email-target sig-hide" href="mailto:'+EmailHtml+'" style="color: rgb(0, 90, 155); text-decoration: none; display: inline;">'+EmailHtml+'</a> <span class="signature_email-sep sep" style="display: inline;">'+NextelHtml+NextelIdHtml+'</span> </p> <p class="company-info" style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; margin-bottom: 10px;"><span style="font-weight: bold; color: rgb(5, 27, 63); display: inline;" class="txt signature_companyname-target sig-hide">MCS Cargo Sales</span><span class="company-sep break" style="display: inline;"><br></span><span style="color: rgb(5, 27, 63); display: inline;" class="txt signature_officephone-target sig-hide">+(5233) 3563 9790 /9791</span><span style="color: rgb(5, 27, 63);" class="txt signature_fax-target sig-hide"></span><span class="address2-sep break" style="display: inline;"><br></span> <span style="color: rgb(5, 27, 63);" class="txt signature_address2-target sig-hide"></span><span class="website-sep break" style="display: block;"></span><a class="link signature_website-target sig-hide" href="http://www.mcs-holding.com" style="color: rgb(0, 90, 155); text-decoration: none; display: inline;"><b>www.mcs-holding.com</b></a></p><p class="social-list" style="font-size: 0px; line-height: 0; font-family: Helvetica, Arial, sans-serif;"><a style="text-decoration: none; display: inline;" class="social signature_twitter-target sig-hide" href="https://htmlsig.com/t/000001CTEDDZ"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="twitter.png" src="https://s3.amazonaws.com/htmlsig-assets/round/twitter.png" alt="Twitter"></a><span style="white-space: nowrap; display: inline;" class="signature_twitter-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span><a style="text-decoration: none; display: inline;" class="social signature_facebook-target sig-hide" href="https://htmlsig.com/t/000001CWQR10"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="facebook.png" src="https://s3.amazonaws.com/htmlsig-assets/round/facebook.png" alt="Facebook"></a><span style="white-space: nowrap; display: inline;" class="signature_facebook-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span><a style="text-decoration: none; display: inline;" class="social signature_googleplus-target sig-hide" href="https://htmlsig.com/t/000001CWF4NS"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="googleplus.png" src="https://s3.amazonaws.com/htmlsig-assets/round/googleplus.png" alt="Google +"></a><span style="white-space: nowrap; display: inline;" class="signature_googleplus-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span><a style="text-decoration: none; display: inline;" class="social signature_linkedin-target sig-hide" href="https://htmlsig.com/t/000001CTNWZ3"><img width="16" style="margin-bottom:2px; border:none; display:inline;" height="16" data-filename="linkedin.png" src="https://s3.amazonaws.com/htmlsig-assets/round/linkedin.png" alt="LinkedIn"></a><span style="white-space: nowrap; display: inline;" class="signature_linkedin-sep social-sep"><img src="https://s3.amazonaws.com/htmlsig-assets/spacer.gif" width="2"></span></p><p style="font-family: Helvetica, Arial, sans-serif; color: rgb(5, 27, 63); font-size: 9px; line-height: 12px;" class="txt signature_disclaimer-target">*** <b>Hora de corte reservación</b> Guía Master y House scan: <b>1730L</b><br>*** <b>Hora de corte entrega</b> de documentos originales <u>(Lunes a Viernes)</u>: <b>2000L</b><br>*** <b>Hora de corte entrega</b> de documentos originales <u>(Sábados y Domingos)</u>: <b>1400L</b><br>*** Favor de entregar <b>comprobante de peso por WTC</b><br>*** <b>NO contamos con buzón</b> para entrega de documentos, <u>favor de entregar a personal de <b>MCS</b></u><br><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OPERACIONES (AEROPUERTO GDL):</b> +(5233) 3688 8247 / CEL: +(521) 332 066 5270</p><p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; line-height: 12px; margin-bottom: 10px;"><img src="'+BannerHtml+'.png" alt="'+BannerHtml+'" border="0" width="545"></p></div></body></html>');
//download("Firma "+NombreHtml+".html",FirmaHtml.replace("=NOMBRE=","'+NombreHtml+'").replace("=TITULO=","'+TituloHtml+'").replace("=EMAIL=","'+EmailHtml+'").replace("=NEXTEL=NEXTELID=","'+NextelHtml+NextelIdHtml+'").replace("=BANNER=","'+BannerHtml+'")); //NO ESTÁ APLICANDO PORQUE EL SERVLET ENVIA LA CADENA DE LA FIRMA Y YA REMPLAZÓ LOS VALORES
download("Firma "+NombreHtml+".html",FirmaHtml);
	
}

function enviar(mensaje,accion){
	var valores=$$('Forma').getValues();
	webix.ajax().post('servlet/MiFirmaServlet',valores,{
		error:function(text,xml,XmlHttpRequest){webix.message(errorComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorComunicacion+'</strong></font>');},
		success:function(text,data,XmlHttpRequest){
			if(accion=='Consultar'){$$('Forma').parse(data.json());webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');}
			else{
				if(data.json().error){webix.message(errorEjecutarAccion);$$('Mensaje').setValue('<font color="red"><strong>'+errorEjecutarAccion+'</strong></font>');webix.message(data.json().log);$$('Confirmacion').clearAll();$$('Confirmacion').add({campo:'ERROR',value: data.json().log});}
				else{
					webix.message(mensaje);$$('Mensaje').setValue('<font color="green"><strong>'+mensaje+'</strong></font>');
					if(accion=='Guardar'||accion=='Modificar'){$$('Confirmacion').clearAll();setConfirmacion(data.json());
						if(accion=='Guardar'){$$('Confirmacion').add({campo:'ESTATUS',value:guardado});guardarDespues();}
						else{$$('Confirmacion').add({campo:'ESTATUS',value:modificado});modificarDespues();}}
					else if(accion=='Borrar'){borrarDespues();}
					else if(accion=='LlenarValores'){
						//$$('IdUsuario').setValue(data.json().IdUsuario); // QUEREMOS TRAER ELEMENTOS INDEPENDIENTES DE LA FORMA (NECESITA NO SER ARREGLO)
						//$$('Nombre').setValue();
						//$$('Titulo').setValue();
						//$$('Email').setValue();
						//$$('Nextel').setValue();
						//$$('NextelId').setValue();
						
						$$('Forma').parse(data.json());
					}
					else if(accion=='Buscar'){$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());var altura=$$('PanelTabla').$height-$$('TablaTools').$height;$$('Tabla').define('height',altura);$$('Tabla').resize();}
				}}}});}
function setConfirmacion(info){
	$$('Confirmacion').add({campo:IdUsuario,value: info.IdUsuario});
	$$('Confirmacion').add({campo:Nombre,value: info.Nombre});
	$$('Confirmacion').add({campo:Titulo,value: info.Titulo});
	$$('Confirmacion').add({campo:Email,value: info.Email});
	$$('Confirmacion').add({campo:Nextel,value: info.Nextel});
	$$('Confirmacion').add({campo:NextelId,value: info.NextelId});
}

/* function insertaValores(){
		
	}; */

//$$('IdUsuario').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('IdUsuario').setValue(nuevo); });
//$$('Nombre').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Nombre').setValue(nuevo); });
//$$('Titulo').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Titulo').setValue(nuevo); });
//$$('Email').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Email').setValue(nuevo); });
//$$('Nextel').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('Nextel').setValue(nuevo); });
//$$('NextelId').attachEvent('onChange',function(nuevo, anterior){ nuevo = nuevo.toUpperCase(); $$('NextelId').setValue(nuevo); });

$$('IdUsuario').disable();
//$$('Nombre').disable();
//$$('Titulo').disable();
$$('Email').disable();

$$('BotonNuevo').hide();

//alert('Mi Id ',MiIdUsuario);

llenarValores();
//insertaValores();



function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}inicial();
</script>
<%=EncabezadoPie.getPie()%>
<% //MiFirma.jsp %>
