package Utilerias;

import java.text.DecimalFormat;

public class Cantidades {

	
	public double getDosDecimales(double valor) {
		valor = valor * 100;
		Math.round(valor);
		valor = valor / 100;
		return valor;
	}
	
	public static String formatoMonedaConSinDecimales(double numero) {
		String num = "";
		DecimalFormat formato = new DecimalFormat("###,###,###,###.##");
		num = formato.format(numero);
		return num;
	}
}
