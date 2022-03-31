package Utilerias;

public class ValoresDefault {

	public ValoresDefault() {
		
	}
	
	public String getFecha(String fecha) {
		if(fecha.equals("")){ fecha = "0000-00-00"; }
		return fecha;
	}
	
	public String getDecimal(String decimal) {
		if(decimal.equals("")){ decimal = "0.00";}
		return decimal;
	}
	
	public String getEntero(String entero) {
		if(entero.equals("")){ entero = "0";}
		return entero;
	}
	
}
