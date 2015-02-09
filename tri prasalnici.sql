-- 1. site vidovi i podvidovi so ime na osnoven vid
select *
  from vidovi v
  start with V.VIDOVI_IDVID is null AND 
    (lower(V.IME) like lower('%' || :search || '%') OR
    lower(V.LATINSKO_IME) like lower('%' || :search || '%'))
  connect by prior V.IDVID = V.VIDOVI_IDVID;

/*
prva rabota kon optimizacija na prasalnikot e da go otstranime connect by zasto
imame hierarhija (drvo) so dlabocina 1. dovolno e samo edno spojuvanje na tabelata
so samata sebe (connect by pravi onolku spojuvanja kolku sto e dlabocinata)
pa go dobivame sledniov prasalnik koj e skoro ekvivalenten ako nemame povekje od
dve nivoa vo podatocite. vikame skoro zasto redosledot moze da bide razlicen.
*/

-- 1.1 ostranet connect by
select *
from vidovi v
where
  V.VIDOVI_IDVID is null AND 
  (lower(V.IME) like lower('%' || :search || '%') OR
  lower(V.LATINSKO_IME) like lower('%' || :search || '%'))
union
select *
from vidovi v
where
  --operatorot in e vsusnot spojuvanje
  V.VIDOVI_IDVID in (
    select v.idvid
    from vidovi v
    where
      V.VIDOVI_IDVID is null AND 
      (lower(V.IME) like lower('%' || :search || '%') OR
      lower(V.LATINSKO_IME) like lower('%' || :search || '%'))
    );

/*
sepak i so noviov prasalnik ne dobivame nikakva prednost. da probame da stavime
index na kolonata so nadvoresen kluc (kon samata sebe) vidovi_idvid
*/
create index vidovi_nadvid on vidovi(vidovi_idvid);
/*indexot nisto ne smena, spjuvanjeto e pak hash join */
drop index vidovi_nadvid;
/*glavnata optimizacija treba da se napravi vusnost pri prebaruvanjeto so LIKE
za toa ne mozeme da stavime obicn index so create index
mora da koristime full text index od paketot
http://www.dba-oracle.com/oracle_tips_like_sql_index.htm
http://docs.oracle.com/cd/B28359_01/text.111/b28303/ind.htm#g1020588
*/

--1.2 staven text index
create index vidovi_ime on vidovi(ime) indextype is CTXSYS.CTXCAT;
create index vidovi_lat_ime on vidovi(latinsko_ime) indextype is CTXSYS.CTXCAT;

select *
from vidovi v
where
  V.VIDOVI_IDVID is null AND 
  (CATSEARCH(ime, :search, null) > 0  OR
  CATSEARCH(latinsko_ime, :search, null) > 0)
union
select *
from vidovi v
where
  V.VIDOVI_IDVID in (
    select v.idvid
    from vidovi v
    where
      V.VIDOVI_IDVID is null AND 
      (CATSEARCH(ime, :search, null) > 0  OR
      CATSEARCH(latinsko_ime, :search, null) > 0)
    );
/*dobivame zabrzuvaje od okolu 3 pati odnosno od 1,5 sekuna na polovina sekunda
negativna strana na catsearch e sto prebaruvame samo po celi zborovi ili
del od pocetokot na zborot ako stiavme dzvezdicka vo stringot desno, primer 'felix*'

ne prebaruva po del od krajot na zborot ili od sredinata, pa rezultatite ne se ekvivalentni
kako so like kade prebaruvame bilo kade vo zborot.
isto taka catserach ima problem ako prebaruvame samo po edna bukva na pocetokot na zborot
primer 'e*' ili 'x*', se zakuva. tuka podobro e so like.
*/

--1.3 text index primenet i kaj connect by
select *
  from vidovi v
  start with V.VIDOVI_IDVID is null AND 
      (CATSEARCH(ime, :search, null) > 0  OR
      CATSEARCH(latinsko_ime, :search, null) > 0)
  connect by prior V.IDVID = V.VIDOVI_IDVID;


-- 2. site proizovdi sto sodrzat eden vid ili negovite podvidovi
select unique P.IDPROIZVOD, P.IME
  from PROIZVODI p left outer join UCESTVO_RECEPTI ur on P.IDPROIZVOD = UR.RECEPTI_PROIZVODI_IDPROIZVOD
start with VIDOVI_IDVID in (select V.IDVID
  from vidovi v
  start with V.VIDOVI_IDVID is null AND 
    (lower(V.IME) like lower('%' || :search || '%') OR
    lower(V.LATINSKO_IME) like lower('%' || :search || '%'))
  connect by prior V.IDVID = V.VIDOVI_IDVID)
connect by PROIZVODI_IDPROIZVOD = prior IDPROIZVOD;

/*spjuvanjeto so IN vo start with pravi problemi, vo execution plan connect by optimizatorot
go pravi bez filtriranje, kako da nema start with, pa potoa filtrira.
toa e mnogu bavno dobivame izminuvanje ogromen graf pocnuvaki od sekoj jazol
toa go optimizirame taka sto toa spoluvanje go krevame gore*/

-- 2.2 optimizaran raboti normalno. prvo naogja vidovi istko kako vo prasalnik 1,
-- pa pustame prebaruvanje trgnuvajki od proizvodite so tie vidovi
select unique P.IDPROIZVOD, P.IME, P.VIDOVI_IDVID
  from PROIZVODI p left outer join UCESTVO_RECEPTI ur on P.IDPROIZVOD = UR.RECEPTI_PROIZVODI_IDPROIZVOD
  left outer join (
    select V.IDVID
    from vidovi v
    start with V.VIDOVI_IDVID is null AND 
      (lower(V.IME) like lower('%' || :search || '%') OR
      lower(V.LATINSKO_IME) like lower('%' || :search || '%'))
    connect by prior V.IDVID = V.VIDOVI_IDVID
  ) vv on P.VIDOVI_IDVID = VV.IDVID
start with VV.IDVID is not null
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
