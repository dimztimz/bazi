create or replace package body slucajno_polnenje_tabeli as

FUNCTION vrati_slucaen_broj_podvidovi return NUMBER as
  begin
    return TRUNC(ABS(SYS.DBMS_RANDOM.NORMAL*5));
  end vrati_slucaen_broj_podvidovi;
  
function vrati_slucaen_string return varchar2 as
begin
  return initcap(dbms_random.string('L', round(sys.dbms_random.value(5,20))));
end vrati_slucaen_string;

function vrati_slucaen_opis return varchar2 as
  opis varchar2(4000);
  povt number(3);
begin
  povt := ROUND(SYS.DBMS_RANDOM.VALUE(5,100));
  opis := vrati_slucaen_string;
  for i in 1..povt loop
    opis := opis || ' ' || dbms_random.string('L', round(sys.dbms_random.value(5,20)));
  end loop;
  opis := opis || '.';
  return opis;
end vrati_slucaen_opis;


procedure napolni_vidovi as
  ime VARCHAR2(255);
  l_ime VARCHAR2(255);
  v_id number(10, 0);
  datum date;
  v_id2 number(10, 0);
  l_ime2 VARCHAR2(255);
  datum2 date;
  povt number(3,0);
  begin
    for i IN 1..50000 loop
      ime := vrati_slucaen_string;
      l_ime := vrati_slucaen_string || ' ' || vrati_slucaen_string;
      v_id:= seq_vidovi.nextval;
      datum :=  sysdate - dbms_random.value(1, 18250); 
      insert into vidovi values (v_id, l_ime, ime, null, datum);
      povt := vrati_slucaen_broj_podvidovi;
      for j in 1..povt loop
        ime := vrati_slucaen_string;
        l_ime2 := l_ime || ' ' || vrati_slucaen_string;
        v_id2 := seq_vidovi.nextval;
        datum2 :=  datum + dbms_random.value(0, SYSDATE-datum);
        insert into vidovi values (v_id2, l_ime2, ime, v_id, datum2);
      end loop;
    end loop;
  end napolni_vidovi;

  procedure napolni_tip_proizvod as
    tip_id TIP_PROIZVOD.IDTIPPROIZVOD%TYPE;
    tip_ime TIP_PROIZVOD.IMENATIP%TYPE;
  begin
    for i in 1..100 loop
      begin
        tip_id := i;
        tip_ime := vrati_slucaen_string;
        insert into TIP_PROIZVOD values (tip_id, tip_ime);
      exception when others then null;
      end;
    end loop;
  end napolni_tip_proizvod;
  
  procedure napolni_nacin_obrabotka as
    nacin_id NACIN_OBRABOTKA.IDOBRABOTKA%TYPE;
    nacin_ime NACIN_OBRABOTKA.IMENAOBRABOTKA%TYPE;
  begin
    for i in 1..100 loop
      begin
        nacin_id := i;
        nacin_ime := vrati_slucaen_string;
        insert into NACIN_OBRABOTKA values (nacin_id, nacin_ime);
      exception when others then null;
      end;
    end loop;
  end napolni_nacin_obrabotka;

  procedure napolni_proizvodi as
    p_id number(10);
    ime varchar(255);
    opis varchar(4000);
    vid_id number(10);
    tip number(10);
    nacin number(10);
    datum date;
    --z number(10);
    cursor c_vidovi is
      SELECT idvid, datumotkrivanje FROM Vidovi;
    povt number(5);
    max_tip_id TIP_PROIZVOD.IDTIPPROIZVOD%TYPE;
    max_nacin_obrabotka_id NACIN_OBRABOTKA.IDOBRABOTKA%TYPE;
  begin
    select max(IDTIPPROIZVOD) into max_tip_id from tip_proizvod;
    select max(IDOBRABOTKA) into max_nacin_obrabotka_id from NACIN_OBRABOTKA;
    --z := 1000;
    FOR i IN c_vidovi LOOP
      --if (z = 0) then exit; end if;
      --z := z - 1;
      povt := trunc(abs(sys.dbms_random.NORMAL*2));
      vid_id := i.idvid;
      FOR j IN 1..povt LOOP
      begin
        p_id := seq_proizvodi.nextval;
        ime := vrati_slucaen_string;
        opis := vrati_slucaen_opis;
        tip := round(SYS.DBMS_RANDOM.VALUE(1,max_tip_id));
        nacin := round(SYS.DBMS_RANDOM.VALUE(1,max_nacin_obrabotka_id));
        datum := i.datumotkrivanje + dbms_random.value(0, SYSDATE-i.datumotkrivanje);
        insert into proizvodi
        values(p_id, ime, opis, vid_id, tip, nacin, datum);
      exception when others then
        DBMS_OUTPUT.PUT_LINE(SYS.DBMS_UTILITY.FORMAT_ERROR_STACK);
      end;
      END LOOP;
    END LOOP;
    if (c_vidovi%isopen) then close c_vidovi; end if;
  exception
    when others then
      if (c_vidovi%isopen) then close c_vidovi; end if;
  end napolni_proizvodi;
  
  procedure napolni_proizvodi2 as
    p_id number(10);
    ime varchar(255);
    opis varchar(4000);
    vid_id number(10);
    tip number(10);
    nacin number(10);
    datum date;  
    povt number(5);
    max_tip_id TIP_PROIZVOD.IDTIPPROIZVOD%TYPE;
    max_nacin_obrabotka_id NACIN_OBRABOTKA.IDOBRABOTKA%TYPE;
    max_proizvod_id proizvodi.idproizvod%type;
    p_id2 PROIZVODI.IDPROIZVOD%type;
    kolicina UCESTVO_RECEPTI.KOLICINA%type;
    merka UCESTVO_RECEPTI.EDINICI_MERKI_MERKA%type;
  begin
    select max(IDTIPPROIZVOD) into max_tip_id from tip_proizvod;
    select max(IDOBRABOTKA) into max_nacin_obrabotka_id from NACIN_OBRABOTKA;
    vid_id := null;
    for z in 1..100 loop
      select max(idproizvod) into max_proizvod_id from proizvodi;
      for i in 1..1000 loop
        p_id := seq_proizvodi.nextval;
        ime := vrati_slucaen_string;
        opis := vrati_slucaen_opis;
        tip := round(SYS.DBMS_RANDOM.VALUE(1,max_tip_id));
        nacin := round(SYS.DBMS_RANDOM.VALUE(1,max_nacin_obrabotka_id));
        datum := sysdate - dbms_random.value(1, 18250);
        insert into proizvodi
        values(p_id, ime, opis, vid_id, tip, nacin, datum);
        
        povt := round(sys.dbms_random.NORMAL*5 + 5);
        if (povt > 0) then
          opis := vrati_slucaen_opis;
          insert into recepti values (p_id, opis);
        end if;
        for j in 1..povt loop
          begin
            p_id2 := round(SYS.DBMS_RANDOM.value(1, max_proizvod_id));
            kolicina := SYS.DBMS_RANDOM.value(0, 20);
            select e.merka into merka from (select e.merka from edinici_merki e order by SYS.DBMS_RANDOM.value) e where rownum = 1;
            insert into UCESTVO_RECEPTI values (p_id2, kolicina, p_id, merka);
          exception when others then
            DBMS_OUTPUT.PUT_LINE(SYS.DBMS_UTILITY.FORMAT_ERROR_STACK);
          end;
        end loop;
        --selectov e mnogu baven
        --select nvl(max(datumdodavanje), datum) into datum
        --from proizvodi p, ucestvo_recepti u
        --where u.proizvodi_idproizvod = p.idproizvod AND
        -- u.recepti_proizvodi_idproizvod = p_id;
        --datum := datum + dbms_random.value(1, SYSDATE-datum);
        --update proizvodi
        --set datumdodavanje=datum
        --where idproizvod = p_id;
      end loop;
    end loop;
  end napolni_proizvodi2;
end slucajno_polnenje_tabeli;