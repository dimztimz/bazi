begin
  SLUCAJNO_POLNENJE_TABELI.NAPOLNI_PROIZVODI2;
end;
/

select count(idvid) from vidovi;
select count(idproizvod) from proizvodi;
select count(*) from recepti;
select count(*) from UCESTVO_RECEPTI;
select max(IDPROIZVOD) from PROIZVODI;
select * from UCESTVO_RECEPTI;
select trunc(datumdodavanje, 'YYYY') a, count(*) from proizvodi group by trunc(datumdodavanje, 'YYYY') order by a;
select trunc(datumotkrivanje, 'YYYY') a, count(*) from vidovi group by trunc(datumotkrivanje, 'YYYY') order by a;
/
drop sequence seq_proizvodi;
create SEQUENCE seq_proizvodi START WITH 264738;
/

declare
datum date;
begin
select max(datumdodavanje) into datum
from ucestvo_recepti u, proizvodi p
where
u.recepti_proizvodi_idproizvod > 263737 AND
u.recepti_proizvodi_idproizvod <= 264737 AND
u.proizvodi_idproizvod = p.idproizvod;
end;
/
select u.recepti_proizvodi_idproizvod, max(datumdodavanje)
from ucestvo_recepti u, proizvodi p
where
u.recepti_proizvodi_idproizvod > 263737 AND
u.recepti_proizvodi_idproizvod <= 264737 AND
u.proizvodi_idproizvod = p.idproizvod
group by u.recepti_proizvodi_idproizvod;
/



declare
  merka EDINICI_MERKI.MERKA%TYPE;
begin
  for i in 1..1000 loop
    select merka into merka from (select merka from edinici_merki e order by SYS.DBMS_RANDOM.value) e where rownum = 1;
    SYS.DBMS_OUTPUT.PUT_LINE(merka);
  end loop;
end;
/