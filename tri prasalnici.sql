-- site vidovi i podvidovi so ime na osnoven vid
select *
  from vidovi v
  start with V.VIDOVI_IDVID is null AND 
    (lower(V.IME) like lower('%' || :search || '%') OR
    lower(V.LATINSKO_IME) like lower('%' || :search || '%'))
  connect by prior V.IDVID = V.VIDOVI_IDVID;


-- site proizovdi sto sodrzat eden vid ili negovite podvidovi
select unique P.IDPROIZVOD, P.IME
  from PROIZVODI p left outer join UCESTVO_RECEPTI ur on P.IDPROIZVOD = UR.RECEPTI_PROIZVODI_IDPROIZVOD
start with VIDOVI_IDVID in (select V.IDVID
  from vidovi v
  start with V.VIDOVI_IDVID is null AND 
    (lower(V.IME) like lower('%' || :search || '%') OR
    lower(V.LATINSKO_IME) like lower('%' || :search || '%'))
  connect by prior V.IDVID = V.VIDOVI_IDVID)
connect by PROIZVODI_IDPROIZVOD = prior IDPROIZVOD;

-- najcesto koristen vid
select V.IME, V.LATINSKO_IME
from vidovi v
where V.IDVID in
  (select  P.VIDOVI_IDVID
    from PROIZVODI p left outer join UCESTVO_RECEPTI ur on P.IDPROIZVOD = UR.PROIZVODI_IDPROIZVOD
  connect by prior P.IDPROIZVOD =  UR.RECEPTI_PROIZVODI_IDPROIZVOD
  group by P.VIDOVI_IDVID
  having count(*) = (select  max(COUNT(*))
    from PROIZVODI p left outer join UCESTVO_RECEPTI ur on P.IDPROIZVOD = UR.PROIZVODI_IDPROIZVOD
  connect by prior P.IDPROIZVOD =  UR.RECEPTI_PROIZVODI_IDPROIZVOD
  group by P.VIDOVI_IDVID));
