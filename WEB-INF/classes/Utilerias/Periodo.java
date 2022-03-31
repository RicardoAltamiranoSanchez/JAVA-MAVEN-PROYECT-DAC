package Utilerias;

public class Periodo {

	private String periodoDe = "";
	private String periodoA = "";
	private String periodo = "";
	private String ao = "";
	
	public Periodo() {
		
	}
	
	public void getSiguientePeriodo(String periodo, String ao) {
		int iPeriodo = Integer.parseInt(periodo);
		int iAo = Integer.parseInt(ao);
		
		if(iPeriodo == 24) {
			iPeriodo = 1;
			iAo++;
		} else {
			iPeriodo++;
		}
		
		this.periodo = "" + iPeriodo;
		this.ao = "" + iAo;
		
		if(iPeriodo == 1) { this.periodoDe = "01/01/" + iAo; this.periodoA = "15/01/" + iAo; }
		else if(iPeriodo == 2) { this.periodoDe = "16/01/" + iAo; this.periodoA = "31/01/" + iAo; }
		
		else if(iPeriodo == 3) { this.periodoDe = "01/02/" + iAo; this.periodoA = "15/02/" + iAo; }
		else if(iPeriodo == 4) { this.periodoDe = "16/02/" + iAo; this.periodoA = "28/02/" + iAo; }
		
		else if(iPeriodo == 5) { this.periodoDe = "01/03/" + iAo; this.periodoA = "15/03/" + iAo; }
		else if(iPeriodo == 6) { this.periodoDe = "16/03/" + iAo; this.periodoA = "31/03/" + iAo; }
		
		else if(iPeriodo == 7) { this.periodoDe = "01/04/" + iAo; this.periodoA = "15/04/" + iAo; }
		else if(iPeriodo == 8) { this.periodoDe = "16/04/" + iAo; this.periodoA = "30/04/" + iAo; }
		
		else if(iPeriodo == 9) { this.periodoDe = "01/05/" + iAo; this.periodoA = "15/05/" + iAo; }
		else if(iPeriodo == 10) { this.periodoDe = "16/05/" + iAo; this.periodoA = "31/05/" + iAo; }
		
		else if(iPeriodo == 11) { this.periodoDe = "01/06/" + iAo; this.periodoA = "15/06/" + iAo; }
		else if(iPeriodo == 12) { this.periodoDe = "16/06/" + iAo; this.periodoA = "30/06/" + iAo; }
		
		else if(iPeriodo == 13) { this.periodoDe = "01/07/" + iAo; this.periodoA = "15/07/" + iAo; }
		else if(iPeriodo == 14) { this.periodoDe = "16/07/" + iAo; this.periodoA = "31/07/" + iAo; }
		
		else if(iPeriodo == 15) { this.periodoDe = "01/08/" + iAo; this.periodoA = "15/08/" + iAo; }
		else if(iPeriodo == 16) { this.periodoDe = "16/08/" + iAo; this.periodoA = "31/08/" + iAo; }
		
		else if(iPeriodo == 17) { this.periodoDe = "01/09/" + iAo; this.periodoA = "15/09/" + iAo; }
		else if(iPeriodo == 18) { this.periodoDe = "16/09/" + iAo; this.periodoA = "30/09/" + iAo; }
		
		else if(iPeriodo == 19) { this.periodoDe = "01/10/" + iAo; this.periodoA = "15/10/" + iAo; }
		else if(iPeriodo == 20) { this.periodoDe = "16/10/" + iAo; this.periodoA = "31/10/" + iAo; }
		
		else if(iPeriodo == 21) { this.periodoDe = "01/11/" + iAo; this.periodoA = "15/11/" + iAo; }
		else if(iPeriodo == 22) { this.periodoDe = "16/11/" + iAo; this.periodoA = "30/11/" + iAo; }
		
		else if(iPeriodo == 23) { this.periodoDe = "01/12/" + iAo; this.periodoA = "15/12/" + iAo; }
		else if(iPeriodo == 24) { this.periodoDe = "16/12/" + iAo; this.periodoA = "31/12/" + iAo; }
	}
	
	
	public String getPeriodo() {
		return this.periodo;
	}
	
	public String getPeriodoDe() {
		return this.periodoDe;
	}
	
	public String getPeriodoA() {
		return this.periodoA;
	}
	
	public String getAo() {
		return this.ao;
	}
}
