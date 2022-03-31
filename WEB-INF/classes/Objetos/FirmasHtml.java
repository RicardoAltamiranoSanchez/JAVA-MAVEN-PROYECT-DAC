package Objetos;

public class FirmasHtml {

	private int id = 0;
	private String IdFirmas = "";
	private String HtmlFirma = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public FirmasHtml() {

	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	public void setIdFirmas(String idfirmas) {
		this.IdFirmas = idfirmas;
	}

	public String getIdFirmas() {
		return this.IdFirmas;
	}

	public void setHtmlFirma(String htmlfirma) {
		this.HtmlFirma = htmlfirma;
	}

	public String getHtmlFirma() {
		return this.HtmlFirma;
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
