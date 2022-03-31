package Objetos;

public class CredencialesExternos {

	private int id = 0;
	private String NombreCompleto = "";
	private String Puesto = "";
	private String Empresa = "";
	private String Estacion = "";
	private String IMSS = "";
	private String CURP = "";
	private String Antiguedad = "";
	private String Division = "";
	private String Nivel = "";
	private String FechaEmision = "";
	private String FechaVigencia = "";
	private String Imagen = "";
	private String IdImagenAdelante = "";
	private String IdImagenAtras = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	
	public CredencialesExternos() {
		// TODO Auto-generated constructor stub
	}
	/////////////funciones para guardar el elemento 
	public void setId(int id){
		this.id = id;
	}
	
	public void setNombreCompleto(String nombrecompleto){
		this.NombreCompleto = nombrecompleto;
	}
	
	public void setPuesto(String puesto){
		this.Puesto = puesto;
	}
	
	public void setEmpresa(String empresa){
		this.Empresa = empresa;
	}
	
	public void setEstacion(String estacion){
		this.Estacion = estacion;
	}
	
	public void setIMSS(String imss){
		this.IMSS = imss;
	}
	
	public void setCURP(String curp){
		this.CURP = curp;
	}
	
	public void setAntiguedad(String antiguedad){
		this.Antiguedad = antiguedad;
	}
	
	public void setDivision(String division){
		this.Division = division;
	}
	
	public void setNivel(String nivel){
		this.Nivel = nivel;
	}
	
	public void setFechaEmision(String fechaemision){
		this.FechaEmision = fechaemision;
	}
	
	public void setFechaVigencia(String fechavigencia){
		this.FechaVigencia = fechavigencia;
	}
	
	public void setImagen(String imagen){
		this.Imagen = imagen;
	}
	
	public void setIdImagenAdelante(String idimagenadelante){
		this.IdImagenAdelante = idimagenadelante;
	}
	
	public void setIdImagenAtras(String idimagenatras){
		this.IdImagenAtras = idimagenatras;
	}
	
	public void setValue(String value) {
		this.value = value;
	}

	public void setLog(String log) {
		this.log = log;
	}

	public void setError(boolean error) {
		this.error = error;
	}
	////////////funciones para obtener el elemento guardado
	public int getId(){
		return this.id;
	}
	
	public String getNombreCompleto(){
		return this.NombreCompleto;
	}
	
	public String getPuesto(){
		return this.Puesto;
	}
	
	public String getEmpresa(){
		return this.Empresa;
	}
	
	public String getEstacion(){
		return this.Estacion;
	}
	
	public String getIMSS(){
		return this.IMSS;
	}
	
	public String getAntiguedad(){
		return this.Antiguedad;
	}
	
	public String getDivision(){
		return this.Division;
	}
	
	public String getNivel(){
		return this.Nivel;
	}
	
	public String getCURP(){
		return this.CURP;
	}
	
	public String getFechaEmision(){
		return this.FechaEmision;
	}
	
	public String getFechaVigencia(){
		return this.FechaVigencia;
	}
	
	public String getImagen(){
		return this.Imagen;
	}
	
	public String getIdImagenAdelante(){
		return this.IdImagenAdelante;
	}
	
	public String getIdImagenAtras(){
		return this.IdImagenAtras;
	}
	
	public String getValue() {
		return this.value;
	}

	public String getLog() {
		return this.log;
	}

	public boolean getError() {
		return this.error;
	}

}













