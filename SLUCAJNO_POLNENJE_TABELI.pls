create or replace package slucajno_polnenje_tabeli as 

  function vrati_slucaen_broj_podvidovi return number;
  function vrati_slucaen_string return varchar2;
  function vrati_slucaen_opis return varchar2;
  procedure napolni_vidovi;
  procedure napolni_proizvodi;

end slucajno_polnenje_tabeli;
