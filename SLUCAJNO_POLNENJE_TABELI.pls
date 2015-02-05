create or replace package slucajno_polnenje_tabeli as 

  function vrati_slucaen_broj_podvidovi return number;
  function vrati_slucaen_string return varchar2;
  function vrati_slucaen_opis return varchar2;
  procedure napolni_vidovi;
  procedure napolni_tip_proizvod;
  procedure napolni_nacin_obrabotka;
  procedure napolni_proizvodi;
  procedure napolni_proizvodi2;

end slucajno_polnenje_tabeli;
