package bilki_ui;

import java.util.Date;

public class Vid {
	int idvid;
	String ime;
	String latinskoIme;
	int id_nadvid;
	Date datumOtkruvanje;
	public Vid(int idvid, String ime, String latinskoIme, int id_nadvid,
			Date datumOtkruvanje) {
		super();
		
		if (ime == null || latinskoIme == null) {
			throw new NullPointerException();
		}
		
		this.idvid = idvid;
		this.ime = ime;
		this.latinskoIme = latinskoIme;
		this.id_nadvid = id_nadvid;
		this.datumOtkruvanje = datumOtkruvanje;
	}
	public int getIdvid() {
		return idvid;
	}
	public void setIdvid(int idvid) {
		if (idvid <= 0) {
			throw new NullPointerException();
		}
		this.idvid = idvid;
	}
	public String getIme() {
		return ime;
	}
	public void setIme(String ime) {
		if (ime == null) {
			throw new NullPointerException();
		}
		this.ime = ime;
	}
	public String getLatinskoIme() {
		return latinskoIme;
	}
	public void setLatinskoIme(String latinskoIme) {
		if (latinskoIme == null) {
			throw new NullPointerException();
		}
		this.latinskoIme = latinskoIme;
	}
	public int getId_nadvid() {
		return id_nadvid;
	}
	public void setId_nadvid(int id_nadvid) {
		this.id_nadvid = id_nadvid;
	}
	public Date getDatumOtkruvanje() {
		return datumOtkruvanje;
	}
	public void setDatumOtkruvanje(Date datumOtkruvanje) {
		this.datumOtkruvanje = datumOtkruvanje;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((datumOtkruvanje == null) ? 0 : datumOtkruvanje.hashCode());
		result = prime * result + id_nadvid;
		result = prime * result + idvid;
		result = prime * result + ((ime == null) ? 0 : ime.hashCode());
		result = prime * result
				+ ((latinskoIme == null) ? 0 : latinskoIme.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Vid other = (Vid) obj;
		if (datumOtkruvanje == null) {
			if (other.datumOtkruvanje != null)
				return false;
		} else if (!datumOtkruvanje.equals(other.datumOtkruvanje))
			return false;
		if (id_nadvid != other.id_nadvid)
			return false;
		if (idvid != other.idvid)
			return false;
		if (ime == null) {
			if (other.ime != null)
				return false;
		} else if (!ime.equals(other.ime))
			return false;
		if (latinskoIme == null) {
			if (other.latinskoIme != null)
				return false;
		} else if (!latinskoIme.equals(other.latinskoIme))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "Vid [idvid=" + idvid + ", ime=" + ime + ", latinskoIme="
				+ latinskoIme + ", id_nadvid=" + id_nadvid
				+ ", datumOtkruvanje=" + datumOtkruvanje + "]";
	}
	
}
