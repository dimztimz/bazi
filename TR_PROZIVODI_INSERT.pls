create or replace trigger tr_prozivodi_insert
	before insert on proizvodi
	for each row
begin
	if (:new.idProizvod is null or :new.idProizvod < 1) then
		:new.idProizvod := seq_proizvodi.nextval;
	end if;
end;