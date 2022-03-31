package Objetos;

public class PersonasGeneral {

	private int id = 0;
	private String Empleado = "";
	private String NumEmpleado = "";
	private String NombreCompleto = "";
	private String NSS = "";
	private String RFC = "";
	private String CURP = "";
	private String IdUbicacionesGrupo = "";
	private String IdAreasGrupo = "";
	private String IdPuestosGrupo = "";
	private String IdEmpleadosGrupo = "";
	private String IdEmpresasGrupo = "";
	private String SueldoBruto = "";
	private String FechIngreso = "";
	private String FechaCump = "";
	private String DiaCumple = "";
	private String MesCumple = "";
	private String EstatusEmpGpo = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public PersonasGeneral() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setEmpleado(String empleado) {
		this.Empleado = empleado;
	}

	public String getEmpleado() {
		return this.Empleado;
	}

	public void setNumEmpleado(String numempleado) {
		this.NumEmpleado = numempleado;
	}

	public String getNumEmpleado() {
		return this.NumEmpleado;
	}

	public void setNombreCompleto(String nombrecompleto) {
		this.NombreCompleto = nombrecompleto;
	}

	public String getNombreCompleto() {
		return this.NombreCompleto;
	}

	public void setNSS(String nss) {
		this.NSS = nss;
	}

	public String getNSS() {
		return this.NSS;
	}

	public void setRFC(String rfc) {
		this.RFC = rfc;
	}

	public String getRFC() {
		return this.RFC;
	}

	public void setCURP(String curp) {
		this.CURP = curp;
	}

	public String getCURP() {
		return this.CURP;
	}

	public void setIdUbicacionesGrupo(String idubicacionesgrupo) {
		this.IdUbicacionesGrupo = idubicacionesgrupo;
	}

	public String getIdUbicacionesGrupo() {
		return this.IdUbicacionesGrupo;
	}

	public void setIdAreasGrupo(String idareasgrupo) {
		this.IdAreasGrupo = idareasgrupo;
	}

	public String getIdAreasGrupo() {
		return this.IdAreasGrupo;
	}

	public void setIdPuestosGrupo(String idpuestosgrupo) {
		this.IdPuestosGrupo = idpuestosgrupo;
	}

	public String getIdPuestosGrupo() {
		return this.IdPuestosGrupo;
	}

	public void setIdEmpleadosGrupo(String idempleadosgrupo) {
		this.IdEmpleadosGrupo = idempleadosgrupo;
	}

	public String getIdEmpleadosGrupo() {
		return this.IdEmpleadosGrupo;
	}

	public void setIdEmpresasGrupo(String idempresasgrupo) {
		this.IdEmpresasGrupo = idempresasgrupo;
	}

	public String getIdEmpresasGrupo() {
		return this.IdEmpresasGrupo;
	}

	public void setSueldoBruto(String sueldobruto) {
		this.SueldoBruto = sueldobruto;
	}

	public String getSueldoBruto() {
		return this.SueldoBruto;
	}

	public void setFechIngreso(String fechingreso) {
		this.FechIngreso = fechingreso;
	}

	public String getFechIngreso() {
		return this.FechIngreso;
	}

	public void setFechaCump(String fechacump) {
		this.FechaCump = fechacump;
	}

	public String getFechaCump() {
		return this.FechaCump;
	}
	
	// CAMPO COMPUESTO POR COMBOS se agregan los dos objetos para que en el metodo consultar del servlet puedan obtener información a cargar en su combo al modificar
		public void setDiaCumple(String diacumple) {
			this.DiaCumple = diacumple;
		}

		public String getDiaCumple() {
			return this.DiaCumple;
		}
	
		public void setMesCumple(String mescumple) {
			this.MesCumple = mescumple;
		}

		public String getMesCumple() {
			return this.MesCumple;
		}
	//
		
	public void setEstatusEmpGpo(String estatusempgpo) {
		this.EstatusEmpGpo = estatusempgpo;
	}

	public String getEstatusEmpGpo() {
		return this.EstatusEmpGpo;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getValue() {
		return this.value;
	}

	public void setLog(String log) {
		this.log = log;
	}

	public String getLog() {
		return this.log;
	}

	public void setError(boolean error) {
		this.error = error;
	}
	
	public boolean getError() {
		return this.error;
	}
}
