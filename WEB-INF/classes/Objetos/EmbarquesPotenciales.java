package Objetos;

public class EmbarquesPotenciales {

	private String id = "";
	private String Fecha = "";
	private String Cliente = "";
	private String Telefono = "";
	private String Correo = "";
	private String Origen = "";
	private String Destino = "";
	private String Kilos = "";
	private String DescripcionProducto = "";
	private String value = "";
	private String log = "";
	private boolean error = false;
	private boolean bloquear = false;

	public EmbarquesPotenciales() {

	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return this.id;
	}

	public void setFecha(String fecha) {
		this.Fecha = fecha;
	}

	public String getFecha() {
		return this.Fecha;
	}

	public void setCliente(String cliente) {
		this.Cliente = cliente;
	}

	public String getCliente() {
		return this.Cliente;
	}

	public void setTelefono(String telefono) {
		this.Telefono = telefono;
	}

	public String getTelefono() {
		return this.Telefono;
	}

	public void setCorreo(String correo) {
		this.Correo = correo;
	}

	public String getCorreo() {
		return this.Correo;
	}

	public void setOrigen(String origen) {
		this.Origen = origen;
	}

	public String getOrigen() {
		return this.Origen;
	}

	public void setDestino(String destino) {
		this.Destino = destino;
	}

	public String getDestino() {
		return this.Destino;
	}

	public void setKilos(String kilos) {
		this.Kilos = kilos;
	}

	public String getKilos() {
		return this.Kilos;
	}

	public void setDescripcionProducto(String descripcionproducto) {
		this.DescripcionProducto = descripcionproducto;
	}

	public String getDescripcionProducto() {
		return this.DescripcionProducto;
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
	public void setBloquear(boolean bloquear) {
		this.bloquear = bloquear;
	}
	
	public boolean getBloquear() {
		return this.bloquear;
	}
}
//EmbarquesPotenciales