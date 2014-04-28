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
	procedure insert_vid(platinsko_ime IN varchar2, pime IN varchar2, pnadvid IN number, pdatum IN date);
	--procedure update_vid(pid in number, platinsko_ime IN varchar2, pime IN varchar2, pnadvid IN number, pdatum IN date);
	--procedure delete_vid(pid in number);
end pak_vidovi;
/

create or replace package body pak_vidovi as
	procedure insert_vid(platinsko_ime IN varchar2, pime IN varchar2, pnadvid IN number, pdatum IN date) is
		today date;
		datum date;
		lat_ime_dva_zbora EXCEPTION;
	begin
		today := trunc(pdatum);
		if (PDATUM IS NULL OR
			PDATUM > today) THEN
			datum := trunc(sysdate);
		else
			datum := today;
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
	
end pak_vidovi;
/