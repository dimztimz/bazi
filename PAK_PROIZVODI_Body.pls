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