create or replace TRIGGER TR_VIDOVI_INSERT
  BEFORE INSERT ON Vidovi
  FOR EACH ROW
BEGIN
    if (:new.idVid is null or :new.idVid <= 0) then
        :new.IDVID := seq_vidovi.nextval;
    end if;
END;