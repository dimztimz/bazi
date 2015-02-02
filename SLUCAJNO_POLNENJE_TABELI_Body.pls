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
        datum2 :=  datum + dbms_random.value(1, SYSDATE-datum);
        insert into vidovi values (v_id2, l_ime2, ime, v_id, datum2);
      end loop;
    end loop;
    commit;
  end napolni_vidovi;

  procedure napolni_proizvodi as
    p_id number(10);
    ime varchar(255);
    opis varchar(4000);
    vid_id number(10);
    tip number(10);
    nacin number(10);
    datum date;
    broj_zapisi_vidovi number(10);
    vid_rownum number(10);
    cursor c_vidovi is
      SELECT IDVID FROM Vidovi
      ORDER BY dbms_random.value;
  begin
    open c_vidovi;
    FOR i IN 1..3 LOOP
      p_id := seq_proizvodi.nextval;
      ime := vrati_slucaen_string;
      opis := vrati_slucaen_opis;
      fetch c_vidovi into vid_id;
      
    END LOOP;
    close c_vidovi;
    
  exception
    when others then
      if (c_vidovi%isopen) then close c_vidovi; end if;
  end napolni_proizvodi;
end slucajno_polnenje_tabeli;