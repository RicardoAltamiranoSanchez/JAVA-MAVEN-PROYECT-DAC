package Objetos;

public class FirmasBanners {

	private int id = 0;
	private String IdFirmas = "";
	private String ArchivoBannerFirma = "";
	private String EstatusBannerFirma = "";
	private String value = "";
	private String log = "";
	private boolean error = false;

	public FirmasBanners() {

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

	public void setArchivoBannerFirma(String archivobannerfirma) {
		this.ArchivoBannerFirma = archivobannerfirma;
	}

	public String getArchivoBannerFirma() {
		return this.ArchivoBannerFirma;
	}
	
	public void setEstatusBannerFirma(String estatusbannerfirma) {
		this.EstatusBannerFirma = estatusbannerfirma;
	}

	public String getEstatusBannerFirma() {
		return this.EstatusBannerFirma;
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
