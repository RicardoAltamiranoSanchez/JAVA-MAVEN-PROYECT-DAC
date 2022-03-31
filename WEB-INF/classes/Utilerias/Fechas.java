package Utilerias;

import java.util.Calendar;

/**
 * <code>Fechas</code>
 * <br>Utilerias de Html, JavaScript, Java, MySQL 
 * <br>
 * <br>Por: Roberto Rodriguez Rodriguez
 * <br>&nbsp;&nbsp;&nbsp;Integracion Profesional Corportativa SA de CV
 * <br>&nbsp;&nbsp;&nbsp;Division Enlacenet
 * @author Roberto Rodriguez Rodriguez
 */

public class Fechas {
	
	private int mes;
	private int dia;
	private int diaAo;
	private int ultimoDiaMes;
	private int ao;
	private int hora;
	private int minuto;
	private int segundo;
	private int semana;
	
	public String getReloj() {
		return getHora() + ":" + getMinuto() + ":" + getSegundo();
	}
	
	public String getKey() {
		return getAo() + getSMes() + getSDia() + getSHora() + getSMinuto() + getSSegundo(); 
	}
	
	public String getFechaMysql() {
		return getAo() + "-" + getSMes() + "-" + getSDia();
	}
	
	public String getFechaDDMMAAAAaMysql(String fechaDDMMAAAA, String separador) {
		String[] fecha = {};
		fecha = fechaDDMMAAAA.split(separador);
		return fecha[2] + "-" + fecha[1] + "-" + fecha[0];
	}
	
	public String getFechaSabreaMysql(String fechaDDMMMAA) {
		String dia = fechaDDMMMAA.substring(0, 2);
		String mes = fechaDDMMMAA.substring(2, 5);
		String ao = fechaDDMMMAA.substring(5, 7);
		return "20" + ao + "-" + getMesTresLetrasaNumero(mes) + "-" + dia;
	}
	
	public String getFechaMysqlaDDMMAAAA(String fechaAAAAMMDD, String separador) {
		String[] fecha = {};
		fecha = fechaAAAAMMDD.split("-");
		return fecha[2] + separador + fecha[1] + separador + fecha[0];
	}
	
	public String getFechaMysqlaMesCompleto(String fechaAAAAMMDD, String separador) {
		String[] fecha = {};
		fecha = fechaAAAAMMDD.split("-");
		String mes =  getMesCompleto(fecha[1]);
		return fecha[2] + separador + mes + separador + fecha[0];
	}
	
	public String getFechaMysqlaMesTresLetras(String fechaAAAAMMDD, String separador) {
		String[] fecha = {};
		fecha = fechaAAAAMMDD.split("-");
		String mes =  getMesTresLetras(fecha[1]);
		return fecha[2] + separador + mes + separador + fecha[0];
	}
	
	public String getFechaMysqlaLetra(String fechaAAAAMMDD) {
		String[] fecha = {};
		fecha = fechaAAAAMMDD.split("-");
		String mes =  getMesCompleto(fecha[1]);
		return fecha[2] + " de " + mes + " del " + fecha[0];
	}
	
	public String getMesTresLetras(String mes) {
		String iMes = "";
		if(mes.equals("01")) { iMes = "ENE"; }
		else if(mes.equals("02")) { iMes = "FEB"; }
		else if(mes.equals("03")) { iMes = "MAR"; }
		else if(mes.equals("04")) { iMes = "ABR"; }
		else if(mes.equals("05")) { iMes = "MAY"; }
		else if(mes.equals("06")) { iMes = "JUN"; }
		else if(mes.equals("07")) { iMes = "JUL"; }
		else if(mes.equals("08")) { iMes = "AGO"; }
		else if(mes.equals("09")) { iMes = "SEP"; }
		else if(mes.equals("10")) { iMes = "OCT"; }
		else if(mes.equals("11")) { iMes = "NOV"; }
		else if(mes.equals("12")) { iMes = "DIC"; }
		return iMes;
	}
	
	public String getMesCompleto(String mes) {
		String month = "";
		if(mes.equals("01")){ month="Enero"; }
		else if(mes.equals("02")) { month = "Febrero"; }
		else if(mes.equals("03")) { month = "Marzo"; }
		else if(mes.equals("04")) { month = "Abril"; }
		else if(mes.equals("05")) { month = "Mayo"; }
		else if(mes.equals("06")) { month = "Junio"; }
		else if(mes.equals("07")) { month = "Julio"; }
		else if(mes.equals("08")) { month = "Agosto"; }
		else if(mes.equals("09")) { month = "Septiembre"; }
		else if(mes.equals("10")) { month = "Octubre"; }
		else if(mes.equals("11")) { month = "Noviembre"; }
		else if(mes.equals("12")) { month = "Diciembre"; }
		return month;
	}
	
	public String getMesTresLetrasaNumero(String mes) {
		String iMes = "";
		if(mes.equals("JAN")) { iMes = "01"; }
		else if(mes.equals("FEB")) { iMes = "02"; }
		else if(mes.equals("MAR")) { iMes = "03"; }
		else if(mes.equals("APR")) { iMes = "04"; }
		else if(mes.equals("MAY")) { iMes = "05"; }
		else if(mes.equals("JUN")) { iMes = "06"; }
		else if(mes.equals("JUL")) { iMes = "07"; }
		else if(mes.equals("AUG")) { iMes = "08"; }
		else if(mes.equals("SEP")) { iMes = "09"; }
		else if(mes.equals("OCT")) { iMes = "10"; }
		else if(mes.equals("NOV")) { iMes = "11"; }
		else if(mes.equals("DEC")) { iMes = "12"; }
		return iMes;
	}
	
	public String getMesLetrasaNumero(String mes) {
		String iMes = "";
		if(mes.equals("Enero")) { iMes = "01"; }
		else if(mes.equals("Febrero")) { iMes = "02"; }
		else if(mes.equals("Marzo")) { iMes = "03"; }
		else if(mes.equals("Abril")) { iMes = "04"; }
		else if(mes.equals("Mayo")) { iMes = "05"; }
		else if(mes.equals("Junio")) { iMes = "06"; }
		else if(mes.equals("Julio")) { iMes = "07"; }
		else if(mes.equals("Agosto")) { iMes = "08"; }
		else if(mes.equals("Septiembre")) { iMes = "09"; }
		else if(mes.equals("Octubre")) { iMes = "10"; }
		else if(mes.equals("Noviembre")) { iMes = "11"; }
		else if(mes.equals("Diciembre")) { iMes = "12"; }
		return iMes;
	}
	
	public String getDiaEsp(String dia) {
		String diaEsp = "";
		if(dia.equals("Monday")) { diaEsp = "Lunes"; }
		else if(dia.equals("Tuesday")) { diaEsp = "Martes"; }
		else if(dia.equals("Wednesday")) { diaEsp = "Miercoles"; }
		else if(dia.equals("Thursday")) { diaEsp = "Jueves"; }
		else if(dia.equals("Friday")) { diaEsp = "Viernes"; }
		else if(dia.equals("Saturday")) { diaEsp = "Sabado"; }
		else if(dia.equals("Sunday")) { diaEsp = "Domingo"; }
		return diaEsp;
	}
	
	public void setDia(int d) {
		this.dia = d;
	}
	
	public void setDiaAo(int d) {
		this.diaAo = d;
	}
	
	public void setUltimoDiaMes(int d) {
		this.ultimoDiaMes = d;
	}

	public void setSemana(int d) {
		this.semana = d;
	}

	public void setMes(int d) {
		this.mes = d;
	}

	public void setAo(int d) {
		this.ao = d;
	}

	public void setHora(int d) {
		this.hora = d;
	}

	public void setMinuto(int d) {
		this.minuto = d;
	}

	public void setSegundo(int d) {
		this.segundo = d;
	}
	
	public int getDia() {
		return dia;
	}
	
	public int getDiaAo() {
		return diaAo;
	}
	
	public int getUltimoDiaMes() {
		return ultimoDiaMes;
	}

	public int getSemana() {
		return semana;
	}

	public int getMes() {
		return mes;
	}

	public int getAo() {
		return ao;
	}

	public int getHora() {
		return hora;
	}

	public int getMinuto() {
		return minuto;
	}

	public int getSegundo() {
		return segundo;
	}
	
	public String getSMes() {
		String apoyo = mes + "";
		if(apoyo.length() < 2) {
			apoyo = "0" + apoyo;
		}
		return apoyo;
	}

	public String getSDia() {
		String apoyo = dia + "";
		if(apoyo.length() < 2) {
			apoyo = "0" + apoyo;
		}
		return apoyo;
	}
	
	public String getSHora() {
		String apoyo = hora + "";
		if(apoyo.length() < 2) {
			apoyo = "0" + apoyo;
		}
		return apoyo;
	}

	public String getSMinuto() {
		String apoyo = minuto + "";
		if(apoyo.length() < 2) {
			apoyo = "0" + apoyo;
		}
		return apoyo;
	}

	public String getSSegundo() {
		String apoyo = segundo + "";
		if(apoyo.length() < 2) {
			apoyo = "0" + apoyo;
		}
		return apoyo;
	}
	
	public Fechas() {
		Calendar hoy = Calendar.getInstance();
		setMes(hoy.get(Calendar.MONTH) + 1);
		setAo(hoy.get(Calendar.YEAR));
		setDia(hoy.get(Calendar.DAY_OF_MONTH));
		setHora(hoy.get(Calendar.HOUR_OF_DAY));
		setMinuto(hoy.get(Calendar.MINUTE));
		setSegundo(hoy.get(Calendar.SECOND));
		setSemana(hoy.get(Calendar.WEEK_OF_YEAR));
		setUltimoDiaMes(hoy.getActualMaximum(Calendar.DAY_OF_MONTH));
		setDiaAo(hoy.get(Calendar.DAY_OF_YEAR));
	}
	
	public Fechas(int dia, int mes, int ao) {
		Calendar hoy = Calendar.getInstance();
		hoy.set(Calendar.YEAR, ao);
		hoy.set(Calendar.MONTH, mes -1);
		hoy.set(Calendar.DAY_OF_MONTH, dia);
		setMes(hoy.get(Calendar.MONTH) + 1);
		setAo(hoy.get(Calendar.YEAR));
		setDia(hoy.get(Calendar.DAY_OF_MONTH));
		setHora(hoy.get(Calendar.HOUR_OF_DAY));
		setMinuto(hoy.get(Calendar.MINUTE));
		setSegundo(hoy.get(Calendar.SECOND));
		setSemana(hoy.get(Calendar.WEEK_OF_YEAR));
		setUltimoDiaMes(hoy.getActualMaximum(Calendar.DAY_OF_MONTH));
		setDiaAo(hoy.get(Calendar.DAY_OF_YEAR));
	}

}
