create or replace package body slucajno_polnenje_tabeli as

FUNCTION vrati_slucaen_broj_podvidovi return NUMBER as
  begin
    return TRUNC(ABS(SYS.DBMS_RANDOM.NORMAL*5));
  end vrati_slucaen_broj_podvidovi;
  
function vrati_slucaen_string return varchar2 as
begin
  return initcap(dbms_random.string('L', round(sys.dbms_random.value(5,20))));
end vrati_slucaen_string;

procedure napolni_vidovi as
  ime VARCHAR2(255);
  l_ime VARCHAR2(255);
  v_id number(10, 0);
  v_id2 number(10, 0);
  datum date;
  datum2 date;
  povt number(3,0);
  begin
    for i IN 1..3 loop
      ime := vrati_slucaen_string;
      l_ime := vrati_slucaen_string || ' ' || vrati_slucaen_string;
      v_id:= seq_vidovi.nextval;
      datum :=  sysdate - dbms_random.value(1, 18250); 
      insert into vidovi values (v_id, l_ime, ime, null, datum);
      povt := vrati_slucaen_broj_podvidovi;
      for j in 1..povt loop
        ime := initcap(dbms_random.string('L', 20));
        l_ime := l_ime || ' ' || initcap(dbms_random.string('L', 20));
        v_id2 := seq_vidovi.nextval;
        datum2 :=  datum + dbms_random.value(1, SYSDATE-datum);
        insert into vidovi values (v_id2, l_ime, ime, v_id, datum2);
      end loop;
    end loop;
    commit;
  end napolni_vidovi;

end slucajno_polnenje_tabeli;