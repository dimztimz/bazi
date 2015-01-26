--Zadaca so paketi po Napredni bazi na podatoci
--Dimitrij Mijoski, 111132

CREATE SEQUENCE SEQ_VIDOVI INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20;
/

create or replace TRIGGER TR_VIDOVI_INSERT
  BEFORE INSERT ON Vidovi
  FOR EACH ROW
BEGIN
    if (:new.idVid is null or :new.idVid <= 0) then
        :new.IDVID := seq_vidovi.nextval;
    end if;
END;
/

create or replace package pak_vidovi as
	function find_vid_po_latinsko_ime(platinsko_ime varchar2) return vidovi%rowtype;
	function find_vid_po_ime(pime varchar2) return vidovi%rowtype;
	procedure insert_vid(platinsko_ime IN varchar2, pime IN varchar2, pnadvid IN number, pdatum IN date);
	procedure insert_vid(platinsko_ime IN varchar2, pime IN varchar2, pnadvid_latinsko_ime IN varchar2, pdatum IN date);
	procedure update_vid(pid in number, platinsko_ime IN varchar2, pime IN varchar2, pnadvid IN number, pdatum IN date);
	procedure delete_vid(pid in number);
end pak_vidovi;
/

create or replace package body pak_vidovi as
	function find_vid_po_latinsko_ime(platinsko_ime varchar2) return vidovi%rowtype is
		retRow vidovi%rowtype;
	begin
		select * into retRow
		from vidovi
		where VIDOVI.LATINSKO_IME = PLATINSKO_IME;
		return retRow;
	end;
	
	function find_vid_po_ime(pime varchar2) return vidovi%rowtype is
		retRow vidovi%rowtype;
		cursor c1 is
			select *
			from vidovi
			where ime = pime;
	begin
		open c1;
		fetch c1 into retRow;
		close c1;
		return retRow;
	exception
	 when others then
		if c1%isopen then close c1; end if;
	end;

	procedure insert_vid(platinsko_ime IN varchar2, pime IN varchar2, pnadvid IN number, pdatum IN date) is
		today date;
		datum date;
		lat_ime_dva_zbora EXCEPTION;
	begin
		today := trunc(sysdate);
		if (PDATUM IS NULL OR
			PDATUM > today) THEN
			datum := today;
		else
			datum := trunc(pdatum);
		END IF;
		
		if (not regexp_like(PLATINSKO_IME, '^[a-zA-Z]+( [a-zA-Z]+)+$')) then
			RAISE lat_ime_dva_zbora;
		end if;
	
		insert into VIDOVI(LATINSKO_IME, IME, VIDOVI_IDVID, DATUMOTKRIVANJE)
		values (platinsko_ime, pime, pnadvid, datum);
		commit;
	exception
		when lat_ime_dva_zbora then
			DBMS_OUTPUT.PUT_LINE('Latinskoto ime: ''' || PLATINSKO_IME || ''' mora da ima najmalku dva zbora');
	end;
	
	procedure insert_vid(platinsko_ime IN varchar2, pime IN varchar2, pnadvid_latinsko_ime IN varchar2, pdatum IN date) is
		cursor c1 is
			select v.idVid
			from vidovi v
			where v.latinsko_ime = pnadvid_latinsko_ime;
		nadvidId VIDOVI.IDVID%type;
	begin
		open c1;
		loop
			fetch c1 into nadvidId;
			DBMS_OUTPUT.PUT_LINE('asdasd ' || nadvidId);
			if (c1%notfound) then
				exit;
			end if;
		end loop;
		close c1;
		
		if nadvidId is not null then
			insert_vid(platinsko_ime, pime, nadvidId, pdatum);
		end if;
		
	exception
		when others then
			if c1%isopen then
				close c1;
			end if;
	end;
	
	procedure update_vid(pid in number, platinsko_ime IN varchar2, pime IN varchar2, pnadvid IN number, pdatum IN date) is
		red VIDOVI%ROWTYPE;
	begin
		select idVid, nvl(platinsko_ime, v.latinsko_ime), nvl(pime, v.ime),
			nvl(pnadvid, v.VIDOVI_IDVID), nvl(pdatum, v.datumotkrivanje) into red
		from vidovi v
		where v.idVid = pid;
		
		update vidovi
		set latinsko_ime = red.latinsko_ime, ime=red.ime,
		vidovi_idvid=red.vidovi_idvid, DATUMOTKRIVANJE=red.DATUMOTKRIVANJE
		where idvid = pid;
		
		commit;
	end update_vid;
	
	procedure delete_vid(pid in number) is
	begin
		delete from VIDOVI
		where IDVID = pid;
		commit;
	end delete_vid;
end pak_vidovi;
/



create sequence seq_proizvodi increment by 1 start with 7;
/

create or replace trigger tr_prozivodi_insert
	before insert on proizvodi
	for each row
begin
	if (:new.idProizvod is null or :new.idProizvod < 1) then
		:new.idProizvod := seq_proizvodi.nextval;
	end if;
end;
/

select * from PROIZVODI;
/

create or replace package pak_proizvodi as
	procedure insert_proizvod(p_ime varchar2, p_opis varchar2, p_idVid number,
		p_idTip number, p_idNacinObrabotka number, p_datumDodavanje date);
	procedure update_proizvod(p_id number, p_ime varchar2, p_opis varchar2,
		p_idVid number, p_idTip number, p_idNacinObrabotka number,
		p_datumDodavanje date);
	procedure delete_proizvod(p_id number);
	
	function najdiBrojNaProizvodiSodrzatVid(p_vidId number) return number;
end pak_proizvodi;
/

create or replace package body pak_proizvodi as
	procedure insert_proizvod(p_ime varchar2, p_opis varchar2, p_idVid number,
		p_idTip number, p_idNacinObrabotka number, p_datumDodavanje date) is
		today date;
		datum date;
	begin
		today := trunc(sysdate);
		if (P_DATUMDODAVANJE is null or
			P_DATUMDODAVANJE > today) then
			datum := today;
		else
			datum := trunc(P_DATUMDODAVANJE);
		end if;
		
		insert into proizvodi(IME, OPIS, VIDOVI_IDVID, TIP_PROIZVOD_IDTIPPROIZVOD,
			NACIN_OBRABOTKA_IDOBRABOTKA, DATUMDODAVANJE)
		values (p_ime, p_opis, p_idVid, p_idTip, p_idNacinObrabotka, p_datumDodavanje);
		commit;
	end;
	
	procedure update_proizvod(p_id number, p_ime varchar2, p_opis varchar2,
		p_idVid number, p_idTip number, p_idNacinObrabotka number,
		p_datumDodavanje date) is
		red proizvodi%rowtype;
	begin
		select  idProizvod, nvl(p_ime, ime), nvl(p_opis, opis),
		nvl(p_idVid, vidovi_idvid), nvl(p_idTip, TIP_PROIZVOD_IDTIPPROIZVOD),
			nvl(p_idNacinObrabotka, nacin_obrabotka_idObrabotka),
			nvl(p_datumDodavanje, datumDodavanje)
		into red
		from proizvodi
		where idProizvod = p_id;
		
		update proizvodi
		set ime=red.ime, opis=red.opis, vidovi_idvid=red.vidovi_idvid,
			TIP_PROIZVOD_IDTIPPROIZVOD=red.TIP_PROIZVOD_IDTIPPROIZVOD,
			nacin_obrabotka_idObrabotka=red.nacin_obrabotka_idObrabotka,
			datumDodavanje=red.datumDodavanje
		where idProizvod = p_id;
		commit;
	end;
	
	procedure delete_proizvod(p_id number) is
	begin
		delete from PROIZVODI
		where PROIZVODI.IDPROIZVOD = P_ID;
		commit;
	end;
	
	function najdiBrojNaProizvodiSodrzatVid(p_vidId number) return number is
		cursor c1 is
		select idProizvod
		from proizvodi
		where vidovi_idVid = p_vidId;
		idProizvodVar proizvodi.idProizvod%type;
		brojac number(10) := 0;
	begin
		open c1;
		loop
			fetch c1 into idProizvodVar;
			exit when c1%notfound;
			brojac := brojac + 1;
		end loop;
		close c1;
		
		return brojac;
	exception
	when others then
		if (c1%isopen) then
			close c1;
		end if;
		return -1;
	end;
end pak_proizvodi;
/