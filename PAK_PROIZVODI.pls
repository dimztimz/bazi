create or replace package pak_proizvodi as
	procedure insert_proizvod(p_ime varchar2, p_opis varchar2, p_idVid number,
		p_idTip number, p_idNacinObrabotka number, p_datumDodavanje date);
	procedure update_proizvod(p_id number, p_ime varchar2, p_opis varchar2,
		p_idVid number, p_idTip number, p_idNacinObrabotka number,
		p_datumDodavanje date);
	procedure delete_proizvod(p_id number);
	
	function najdiBrojNaProizvodiSodrzatVid(p_vidId number) return number;
end pak_proizvodi;