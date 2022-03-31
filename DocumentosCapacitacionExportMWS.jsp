<%@ page import="java.util.Properties"%>
<%@page import="java.io.IOException" %>
<%@page import="java.io.File" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@page import="org.apache.commons.fileupload.FileUploadException" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="Html.EncabezadoPie"%><%@ include file="valida.jsp" %><%=EncabezadoPie.getEncabezado()%><%try{%>
<script src="js/1.js"></script>
<script>
var nada='';var valoresBusqueda='';var idGenerado='';var archivo='Archivo.jsp';var modoSubforma=false;
<%out.print("var variablesFijas = [{campo:'campoTest', valor:'valorTest'}");
//out.print(",{campo:'',valor:'" + request.getParameter("") + "'}");
out.println("];");%>

//HASTA AQUI TODO BIEN

<%!
File archivoDestino;
String directorioDestino ="/pdf"; //PRODUCTIVO
//String directorioDestino = "D:/Temp/adenda"; //LOCAL
%>
<%
String realPath = getServletContext().getRealPath(directorioDestino);
archivoDestino = new File(realPath);
%>


var IdEmpresas = 'IdEmpresas';
var Usuario = 'Usuario';
var Email = 'Email';
var Xml = 'Xml';
var Numero = 'Numero';
var Operativo = 'Operativo';
var UltimoLogin = 'UltimoLogin';
var UltimoPassword = 'UltimoPassword';

//etiquetas Botones
var etiquetaBotonNuevo = 'Nuevo';
var etiquetaBotonGenera = 'Genera';
var etiquetaBotonModificar = 'Modificar';
var etiquetaBotonBorrar = 'Borrar';
var etiquetaBotonBuscar = 'Buscar';

var path='<%=realPath%>';


var forma={view:'form',id:'Forma',width:400,height:'100%',elements:[
	
	//NO FUNCIONÓ, CAMBIA CARACTERES Y O TIENE BARRAS LATERALES, REQUIERE HTML5 (No funciona con Mozilla)
	/* webix.ui({
	      
	      rows:[
	    	{ view:'pdfbar', id:'toolbar' },
	    	//{ view:'pdfviewer', id:'pdf', toolbar:'toolbar', url:'http://intranet.mcs-holding.com/MCSNetJIntranet/pdf/201909RevisionExportacion.pdf'}
	    	{ view:'pdfviewer', id:'pdf', toolbar:'toolbar', url:'http://localhost:8080/MCSNetJIntranet/pdf/201909RevisionExportacion.pdf'}
	    	//{ view:'pdfviewer', id:'pdf', toolbar:'toolbar', url:'http://www.titulacion.uady.mx/formatos/CARTA-PODER_1.pdf'}
	      ]
	    }), */
	
	
{view:'toolbar', cols:[{view:'label',id:'Mensaje',label:'',align:'center'},{},{view:'button',id:'BotonGenera',value:etiquetaBotonGenera,width:85,click:'genera'},{view:'button',id:'BotonModificar',value:etiquetaBotonModificar,width:85,click:'modificar',hidden:true}]},
//{view:'iframe',id:'FrameSubforma',width:'80%',src:archivo},
]};
var tabla={id:'PanelTabla',height:'100%',rows:[{view:'datatable',id:'Tabla',width:'100%',select:'row',multiselect:true,resizeColumn:true,columns:[
	{id:'NombreArchivo',header:'Documento',sort:'string',width:250},
	{id:'Archivo',header:'Archivo',sort:'string',fillspace:true,sort:'string',template:'<a href="http://intranet.dac-cargo.com/MCSNetJDacIntra/pdf/201909RevisionExportacion.pdf">DESCARGA</a>',minWidth:150}
],
	data:[
		{ id:1, NombreArchivo:"Revisión Exportación 201909", Archivo:'<a href="http://intranet.dac-cargo.com/MCSNetJDacIntra/pdf/201909RevisionExportacion.pdf">DESCARGA</a>'}
	]

}]};
var vacio={id:'Vacio'};



webix.ui({id:'principal',type:'space',rows:[{view:'accordion',type:'wide',multi:true,height:300,cols:[{body:tabla},{header:' ',body:forma}]}]});
function inicial(){for(var i=1;i<variablesFijas.length;i++){$$(variablesFijas[i].campo).setValue(variablesFijas[i].valor);}if(modoSubforma){$$('FrameSubforma').hide();}}

//NO FUNCIONÓ, CAMBIA CARACTERES Y O TIENE BARRAS LATERALES, REQUIERE HTML5 (No funciona con Mozilla)
/* function carga(){        
    $$('pdf').clear();
    $$('pdf').define('scale', 'page-width');
    //$$('pdf').load('http://intranet.mcs-holding.com/MCSNetJIntranet/pdf/201909RevisionExportacion.pdf');
    $$('pdf').load('http://localhost:8080/MCSNetJIntranet/pdf/201909RevisionExportacion.pdf');
    //$$('pdf').load('http://www.titulacion.uady.mx/formatos/CARTA-PODER_1.pdf');
  } */

//$$('PanelTabla').hide();
$$('Forma').hide();


function setSubforma(){$$('FrameSubforma').show();$$('FrameSubforma').load(archivo+'?IdGenerado='+idGenerado);}
inicial();
//carga();
</script>
<%} catch(NullPointerException e) { }
out.println(EncabezadoPie.getPie());
//SistemaUsuarios.jsp
%>