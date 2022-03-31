package Objetos;

public class ReporteGastosViaje {

	private int id = 0;
	private String Fecha = "";
	private String Departamento = "";
	private String PeriodoDe = "";
	private String PeriodoA = "";
	private String Estacion = "";
	private String MotivoViaje = "";
	private String Partida = "";
	private String ViaticosEntregados = "";
	private String FacturadoDirectoEmpresa = "";
	private String NetoCargoFavor = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public ReporteGastosViaje() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setDepartamento(String departamento) {
		this.Departamento = departamento;
	}

	public String getDepartamento() {
		return this.Departamento;
	}

	public void setPeriodoDe(String periodode) {
		this.PeriodoDe = periodode;
	}

	public String getPeriodoDe() {
		return this.PeriodoDe;
	}

	public void setPeriodoA(String periodoa) {
		this.PeriodoA = periodoa;
	}

	public String getPeriodoA() {
		return this.PeriodoA;
	}

	public void setEstacion(String estacion) {
		this.Estacion = estacion;
	}

	public String getEstacion() {
		return this.Estacion;
	}

	public void setMotivoViaje(String motivoviaje) {
		this.MotivoViaje = motivoviaje;
	}

	public String getMotivoViaje() {
		return this.MotivoViaje;
	}

	public void setPartida(String partida) {
		this.Partida = partida;
	}

	public String getPartida() {
		return this.Partida;
	}

	public void setViaticosEntregados(String viaticosentregados) {
		this.ViaticosEntregados = viaticosentregados;
	}

	public String getViaticosEntregados() {
		return this.ViaticosEntregados;
	}

	public void setFacturadoDirectoEmpresa(String facturadodirectoempresa) {
		this.FacturadoDirectoEmpresa = facturadodirectoempresa;
	}

	public String getFacturadoDirectoEmpresa() {
		return this.FacturadoDirectoEmpresa;
	}

	public void setNetoCargoFavor(String netocargofavor) {
		this.NetoCargoFavor = netocargofavor;
	}

	public String getNetoCargoFavor() {
		return this.NetoCargoFavor;
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