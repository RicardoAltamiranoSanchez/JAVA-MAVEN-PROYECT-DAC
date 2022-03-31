<%@ page import="java.util.Properties"%><%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/<%=session.getAttribute("Idioma")%>.js"></script>
<script>
//var servlet='servlet/PresupuestoReporteReporteServlet';
var servlet='PresupuestoReporteServlet.jsp';
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
out.print(",{campo:'Ao',valor:'2018'}");
out.print(",{campo:'IdUsuario',valor:'" + session.getAttribute("IdUsuario") + "'}");
out.println("];");%>

var Ao = 'Ao';
var Tipo = 'Tipo';
var Concepto = 'Concepto';
var M1 = 'Enero';
var R1 = 'Ene.Real';
var D1 = 'Dif.Ene';
var S1 = '';
var M2 = 'Febrero';
var R2 = 'Feb.Real';
var D2 = 'Dif.Feb';
var S2 = '';
var M3 = 'Marzo';
var R3 = 'Mar.Real';
var D3 = 'Dif.Mar';
var S3 = '';
var M4 = 'Abril';
var R4 = 'Abr.Real';
var D4 = 'Dif.Abr';
var S4 = '';
var M5 = 'Mayo';
var R5 = 'May.Real';
var D5 = 'Dif.May';
var S5 = '';
var M6 = 'Junio';
var R6 = 'Jun.Real';
var D6 = 'Dif.Jun';
var S6 = '';
var M7 = 'Julio';
var R7 = 'Jul.Real';
var D7 = 'Dif.Jul';
var S7 = '';
var M8 = 'Agosto';
var R8 = 'Ago.Real';
var D8 = 'Dif.Ago';
var S8 = '';
var M9 = 'Septiembre';
var R9 = 'Sep.Real';
var D9 = 'Dif.Sep';
var S9 = '';
var M10 = 'Octubre';
var R10 = 'Oct.Real';
var D10 = 'Dif.Oct';
var S10 = '';
var M11 = 'Noviembre';
var R11 = 'Nov.Real';
var D11 = 'Dif.Nov';
var S11 = '';
var M12 = 'Diciembre';
var R12 = 'Dic.Real';
var D12 = 'Dif.Dic';


var forma={view:'form',id:'Forma',width:200,height:'100%',elements:[
	{view:'text',id:'Ao',name:'Ao',value:'',placeholder:Ao,label:Ao,labelWidth:100,labelPosition:'left',required:true},
	{view:'text',id:'IdUsuario',name:'IdUsuario',value:'',hidden:true},
{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonNuevo',value:etiquetaBotonNuevo,width:85, click:'nuevo'},{view:'button',id:'BotonBuscar',value:etiquetaBotonBuscar,width:85,click:'buscar'}]},
//{view:'iframe',id:'FrameSubforma',width:'80%',src:archivo},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[
{view:'toolbar',cols:[{},{view:'button',id:'BotonPdf',value:'PDF',width:85, click:'pdf',hidden:true},{view:'button',id:'BotonExcel',value:'EXCEL',width:85, click:'excel'}]},
{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,leftSplit:2,columns:[
	{id:'Tipo',header:Tipo,sort:'string',width:70},
	{id:'Concepto',header:Concepto,sort:'string',fillspace:true,sort:'string',minWidth:150},
	{id:'M1',header:M1,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R1',header:R1,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D1',header:D1,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'S1',header:S1,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:10},
	{id:'M2',header:M2,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R2',header:R2,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D2',header:D2,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'S2',header:S2,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:10},
	{id:'M3',header:M3,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R3',header:R3,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D3',header:D3,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'S3',header:S3,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:10},
	{id:'M4',header:M4,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R4',header:R4,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D4',header:D4,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'S4',header:S4,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:10},
	{id:'M5',header:M5,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R5',header:R5,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D5',header:D5,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'S5',header:S5,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:10},
	{id:'M6',header:M6,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R6',header:R6,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D6',header:D6,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'S6',header:S6,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:10},
	{id:'M7',header:M7,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R7',header:R7,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D7',header:D7,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'S7',header:S7,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:10},
	{id:'M8',header:M8,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R8',header:R8,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D8',header:D8,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'S8',header:S8,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:10},
	{id:'M9',header:M9,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R9',header:R9,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D9',header:D9,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'S9',header:S9,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:10},
	{id:'M10',header:M10,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R10',header:R10,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D10',header:D10,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'S10',header:S10,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:10},
	{id:'M11',header:M11,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R11',header:R11,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D11',header:D11,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'S11',header:S11,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:10},
	{id:'M12',header:M12,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'R12',header:R12,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80},
	{id:'D12',header:D12,sort:'string',format:webix.i18n.numberFormat,css:{"text-align":"right"},width:80}
]}]};
var vacio={id:'Vacio'};

webix.ui({id:'principal',type:'space',rows:[{view:'accordion',type:'wide',multi:true,height:'100%',cols:[{body:tabla},{header:' ',body:forma}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){$$('FrameSubforma').hide();}}
function nuevo(){$$('Forma').clear();$$('Tabla').clearSelection();$$('Mensaje').setValue(nada);inicial();}
function buscar(){$$('Forma').setValues({Accion:'Buscar'},true);enviar(resultadosEncontrados,'Buscar');}
function enviar(mensaje,accion){var valores=$$('Forma').getValues();webix.ajax().post(servlet,valores,{error:function(text,xml,XmlHttpRequest){webix.message(errorDeComunicacion);$$('Mensaje').setValue('<font color="red"><strong>'+errorDeComunicacion+'</strong></font>');},success:function(text,data,XmlHttpRequest){if(data.json().error){webix.message(errorEnProcesamiento);$$('Mensaje').setValue('<font color="red"><strong>'+errorEnProcesamiento+'</strong></font>');webix.message(data.json().log);}else{$$('Mensaje').setValue('<font color="white"><strong>'+mensaje+'</strong></font>');$$('PanelTabla').show();$$('Tabla').clearAll();$$('Tabla').parse(data.json());}}});}


function pdf() {

}

function excel() {
	webix.toExcel($$("Tabla"));
}

function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();
buscar();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//PresupuestoReporteReporte.jsp
%>