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