-- Generated by Oracle SQL Developer Data Modeler 4.0.1.836
--   at:        2014-03-28 20:29:19 CET
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g




CREATE TABLE Bolesti
  (
    idBolest NUMBER (10) NOT NULL ,
    ime NVARCHAR2 (255) NOT NULL ,
    opis VARCHAR2 (4000)
  ) ;
ALTER TABLE Bolesti ADD CONSTRAINT Bolesti_PK PRIMARY KEY ( idBolest ) ;
ALTER TABLE Bolesti ADD CONSTRAINT Bolesti__UN UNIQUE ( ime ) ;

CREATE TABLE Drzava
  (
    drzavaKod CHAR (2) NOT NULL ,
    ime       VARCHAR2 (255) NOT NULL
  ) ;
ALTER TABLE Drzava ADD CONSTRAINT Drzava_PK PRIMARY KEY ( drzavaKod ) ;

CREATE TABLE Edinici_merki
  ( merka CHAR (10) NOT NULL
  ) ;
ALTER TABLE Edinici_merki ADD CONSTRAINT Edinici_merki_PK PRIMARY KEY ( merka ) ;

CREATE TABLE Nacin_obrabotka
  (
    idObrabotka    NUMBER (10) NOT NULL ,
    imeNaObrabotka VARCHAR2 (255) NOT NULL
  ) ;
ALTER TABLE Nacin_obrabotka ADD CONSTRAINT Nacin_obrabotka_PK PRIMARY KEY ( idObrabotka ) ;
ALTER TABLE Nacin_obrabotka ADD CONSTRAINT Nacin_obrabotka__UN UNIQUE ( imeNaObrabotka ) ;

CREATE TABLE Proizvod_leci_bolesti
  (
    Proizvodi_idProizvod NUMBER (10) NOT NULL ,
    Bolesti_idBolest     NUMBER (10) NOT NULL ,
    koef                 NUMBER (10,5)
  ) ;
ALTER TABLE Proizvod_leci_bolesti ADD CONSTRAINT Proizvod_leci_bolesti__IDX PRIMARY KEY ( Proizvodi_idProizvod, Bolesti_idBolest ) ;

CREATE TABLE Proizvod_leci_simptomi
  (
    Proizvodi_idProizvod NUMBER (10) NOT NULL ,
    Simptomi_idSimptom   NUMBER (10) NOT NULL ,
    Attribute_1          NUMBER (10,5)
  ) ;
ALTER TABLE Proizvod_leci_simptomi ADD CONSTRAINT Proizvod_leci_simptomi__IDX PRIMARY KEY ( Proizvodi_idProizvod, Simptomi_idSimptom ) ;

CREATE TABLE Proizvodi
  (
    idProizvod NUMBER (10) NOT NULL ,
    ime NVARCHAR2 (255) NOT NULL ,
    opis                        VARCHAR2 (4000) ,
    Vidovi_idVid                NUMBER (10) ,
    Tip_proizvod_idTipProizvod  NUMBER (10) NOT NULL ,
    Nacin_obrabotka_idObrabotka NUMBER (10) NOT NULL ,
    datumDodavanje              DATE
  ) ;
ALTER TABLE Proizvodi ADD CONSTRAINT Proizvodi_PK PRIMARY KEY ( idProizvod ) ;

CREATE TABLE Recepti
  (
    Proizvodi_idProizvod NUMBER (10) NOT NULL ,
    opis                 VARCHAR2 (4000)
  ) ;
ALTER TABLE Recepti ADD CONSTRAINT Recepti_PK PRIMARY KEY ( Proizvodi_idProizvod ) ;

CREATE TABLE Regioni
  (
    idRegion         NUMBER (10) NOT NULL ,
    ime              VARCHAR2 (255) NOT NULL ,
    Drzava_drzavaKod CHAR (2) NOT NULL ,
    Regioni_idRegion NUMBER (10)
  ) ;
ALTER TABLE Regioni ADD CONSTRAINT Regioni_PK PRIMARY KEY ( idRegion ) ;

CREATE TABLE Simptomi
  (
    idSimptom NUMBER (10) NOT NULL ,
    ime       VARCHAR2 (400) NOT NULL ,
    opis      VARCHAR2 (4000) NOT NULL
  ) ;
ALTER TABLE Simptomi ADD CONSTRAINT Simptomi_PK PRIMARY KEY ( idSimptom ) ;
ALTER TABLE Simptomi ADD CONSTRAINT Simptomi__UN UNIQUE ( ime ) ;

CREATE TABLE Simptomi_na_bolesti
  (
    Bolesti_idBolest   NUMBER (10) NOT NULL ,
    Simptomi_idSimptom NUMBER (10) NOT NULL ,
    koef               NUMBER (10,5)
  ) ;
ALTER TABLE Simptomi_na_bolesti ADD CONSTRAINT Simptomi_na_bolesti__IDX PRIMARY KEY ( Bolesti_idBolest, Simptomi_idSimptom ) ;

CREATE TABLE Tip_proizvod
  (
    idTipProizvod NUMBER (10) NOT NULL ,
    imeNaTip      VARCHAR2 (255) NOT NULL
  ) ;
ALTER TABLE Tip_proizvod ADD CONSTRAINT Tip_proizvod_PK PRIMARY KEY ( idTipProizvod ) ;
ALTER TABLE Tip_proizvod ADD CONSTRAINT Tip_proizvod__UN UNIQUE ( imeNaTip ) ;

CREATE TABLE Ucestvo_recepti
  (
    Proizvodi_idProizvod         NUMBER (10) NOT NULL ,
    kolicina                     NUMBER (10,10) ,
    Recepti_Proizvodi_idProizvod NUMBER (10) NOT NULL ,
    Edinici_merki_merka          CHAR (10) NOT NULL
  ) ;
ALTER TABLE Ucestvo_recepti ADD CONSTRAINT Ucestvo_recepti_PK PRIMARY KEY ( Proizvodi_idProizvod, Recepti_Proizvodi_idProizvod ) ;

CREATE TABLE Vidovi
  (
    idVid           NUMBER (10) NOT NULL ,
    latinsko_ime    VARCHAR2 (255) NOT NULL ,
    ime             VARCHAR2 (255) NOT NULL ,
    Vidovi_idVid    NUMBER (10) ,
    datumOtkrivanje DATE
  ) ;
ALTER TABLE Vidovi ADD CONSTRAINT Vidovi_PK PRIMARY KEY ( idVid ) ;
ALTER TABLE Vidovi ADD CONSTRAINT Vidovi__UN UNIQUE ( latinsko_ime ) ;

CREATE TABLE Vidovi_vo_regioni
  (
    Regioni_idRegion NUMBER (10) NOT NULL ,
    Vidovi_idVid     NUMBER (10) NOT NULL
  ) ;
ALTER TABLE Vidovi_vo_regioni ADD CONSTRAINT Vidovi_vo_regioni__IDX PRIMARY KEY ( Regioni_idRegion, Vidovi_idVid ) ;

ALTER TABLE Simptomi_na_bolesti ADD CONSTRAINT FK_ASS_10 FOREIGN KEY ( Bolesti_idBolest ) REFERENCES Bolesti ( idBolest ) ;

ALTER TABLE Simptomi_na_bolesti ADD CONSTRAINT FK_ASS_11 FOREIGN KEY ( Simptomi_idSimptom ) REFERENCES Simptomi ( idSimptom ) ;

ALTER TABLE Vidovi_vo_regioni ADD CONSTRAINT FK_ASS_13 FOREIGN KEY ( Regioni_idRegion ) REFERENCES Regioni ( idRegion ) ;

ALTER TABLE Vidovi_vo_regioni ADD CONSTRAINT FK_ASS_14 FOREIGN KEY ( Vidovi_idVid ) REFERENCES Vidovi ( idVid ) ;

ALTER TABLE Proizvod_leci_bolesti ADD CONSTRAINT FK_ASS_3 FOREIGN KEY ( Proizvodi_idProizvod ) REFERENCES Proizvodi ( idProizvod ) ;

ALTER TABLE Proizvod_leci_bolesti ADD CONSTRAINT FK_ASS_4 FOREIGN KEY ( Bolesti_idBolest ) REFERENCES Bolesti ( idBolest ) ;

ALTER TABLE Proizvod_leci_simptomi ADD CONSTRAINT FK_ASS_5 FOREIGN KEY ( Proizvodi_idProizvod ) REFERENCES Proizvodi ( idProizvod ) ;

ALTER TABLE Proizvod_leci_simptomi ADD CONSTRAINT FK_ASS_6 FOREIGN KEY ( Simptomi_idSimptom ) REFERENCES Simptomi ( idSimptom ) ;

ALTER TABLE Proizvodi ADD CONSTRAINT Proizvodi_Nacin_obrabotka_FK FOREIGN KEY ( Nacin_obrabotka_idObrabotka ) REFERENCES Nacin_obrabotka ( idObrabotka ) ;

ALTER TABLE Proizvodi ADD CONSTRAINT Proizvodi_Tip_proizvod_FK FOREIGN KEY ( Tip_proizvod_idTipProizvod ) REFERENCES Tip_proizvod ( idTipProizvod ) ;

ALTER TABLE Proizvodi ADD CONSTRAINT Proizvodi_Vidovi_FK FOREIGN KEY ( Vidovi_idVid ) REFERENCES Vidovi ( idVid ) ;

ALTER TABLE Recepti ADD CONSTRAINT Recepti_Proizvodi_FK FOREIGN KEY ( Proizvodi_idProizvod ) REFERENCES Proizvodi ( idProizvod ) ;

ALTER TABLE Regioni ADD CONSTRAINT Regioni_Drzava_FK FOREIGN KEY ( Drzava_drzavaKod ) REFERENCES Drzava ( drzavaKod ) ;

ALTER TABLE Regioni ADD CONSTRAINT Regioni_Regioni_FK FOREIGN KEY ( Regioni_idRegion ) REFERENCES Regioni ( idRegion ) ;

ALTER TABLE Ucestvo_recepti ADD CONSTRAINT Ucestvo_recepti_Merki_FK FOREIGN KEY ( Edinici_merki_merka ) REFERENCES Edinici_merki ( merka ) ;

ALTER TABLE Ucestvo_recepti ADD CONSTRAINT Ucestvo_recepti_Proizvodi_FK FOREIGN KEY ( Proizvodi_idProizvod ) REFERENCES Proizvodi ( idProizvod ) ;

ALTER TABLE Ucestvo_recepti ADD CONSTRAINT Ucestvo_recepti_Recepti_FK FOREIGN KEY ( Recepti_Proizvodi_idProizvod ) REFERENCES Recepti ( Proizvodi_idProizvod ) ;

ALTER TABLE Vidovi ADD CONSTRAINT Vidovi_Vidovi_FK FOREIGN KEY ( Vidovi_idVid ) REFERENCES Vidovi ( idVid ) ;


-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            15
-- CREATE INDEX                             0
-- ALTER TABLE                             38
-- CREATE VIEW                              0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

CREATE SEQUENCE SEQ_VIDOVI INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20;
CREATE SEQUENCE SEQ_PROIZVODI INCREMENT BY 1 START WITH 7;
