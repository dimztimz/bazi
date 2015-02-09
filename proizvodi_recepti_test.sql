select unique P.IDPROIZVOD,P.IME, P.VIDOVI_IDVID
from UCESTVO_RECEPTI ur right outer join PROIZVODI p on UR.PROIZVODI_IDPROIZVOD=P.IDPROIZVOD
start with P.VIDOVI_IDVID  in (1,2,3,46,47)
--start with P.VIDOVI_IDVID  between 832 and 836 or P.VIDOVI_IDVID  between 21326 and 21330 /*vidovite so ime felix i nivnite podvidovi*/
connect by PROIZVODI_IDPROIZVOD = prior UR.RECEPTI_PROIZVODI_IDPROIZVOD;

--ne raboti dobro, bavno e, ako e spojuvanjeto so IN. inaku ova e ekvivalento so toa pogore
select ur.*
from UCESTVO_RECEPTI ur
start with UR.PROIZVODI_IDPROIZVOD in (
  select idproizvod
  from PROIZVODI p
  where p.VIDOVI_IDVID = 1
  )
connect by PROIZVODI_IDPROIZVOD = prior UR.RECEPTI_PROIZVODI_IDPROIZVOD;

--malku poinakvo izminuvanje, gi dava i krajnite listovi kako posebni redici
--izminuvanjeto pogore gi dava listovite samo kako id vo kolonata UR.RECEPTI_PROIZVODI_IDPROIZVOD
select unique P.IDPROIZVOD,P.IME, P.VIDOVI_IDVID
from PROIZVODI p left outer join UCESTVO_RECEPTI ur on UR.RECEPTI_PROIZVODI_IDPROIZVOD=P.IDPROIZVOD
start with P.VIDOVI_IDVID  in (1,2,3,46,47)
--start with P.VIDOVI_IDVID  between 832 and 836 or P.VIDOVI_IDVID  between 21326 and 21330 /*vidovite so ime felix i nivnite podvidovi*/
connect by PROIZVODI_IDPROIZVOD = prior P.IDPROIZVOD;

---------------

--filtriranje so spojuvanje, filtrirame so informacii vo druga tabela, no potoa ne gi koristime tie podatoci
--primer filtrirame vo ucestvto_recepti so informacija vo tabelata proizvodi,ama ponatamu ne ni trebaat kolonite od prozivodi
select ur.*
from UCESTVO_RECEPTI ur inner join PROIZVODI p on UR.PROIZVODI_IDPROIZVOD=P.IDPROIZVOD
where P.VIDOVI_IDVID = 1;

--ekvivalentno so pogornoto, in e spojuvanje. pravi problem ako imame vakvo spojuvanje vo start with pogore
select ur.*
from UCESTVO_RECEPTI ur
where ur.PROIZVODI_IDPROIZVOD in (
  select idproizvod
  from PROIZVODI p
  where p.VIDOVI_IDVID = 1
  );