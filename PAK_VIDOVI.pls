create or replace package pak_vidovi as
	function find_vid_po_latinsko_ime(platinsko_ime varchar2) return vidovi%rowtype;
	function find_vid_po_ime(pime varchar2) return vidovi%rowtype;
	procedure insert_vid(platinsko_ime IN varchar2, pime IN varchar2, pnadvid IN number, pdatum IN date);
	procedure insert_vid(platinsko_ime IN varchar2, pime IN varchar2, pnadvid_latinsko_ime IN varchar2, pdatum IN date);
	procedure update_vid(pid in number, platinsko_ime IN varchar2, pime IN varchar2, pnadvid IN number, pdatum IN date);
	procedure delete_vid(pid in number);
end pak_vidovi;