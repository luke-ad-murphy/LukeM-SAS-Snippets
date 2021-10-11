rsubmit;
proc sql;
create table ss_1.Rlh_1e_addresses as
select a.*,
	   b.TITLE as Title format = $15. informat = $15. length = 15,
	   b.BO_NAME_DISPLAY as Add1 format = $100. informat = $100. length = 100,
	   b.HOUSE_NUMBER as Add1 format = $30. informat = $30. length = 30,
	   b.FLAT_NUMBER as Add1 format = $30. informat = $30. length = 30,
	   b.ADDRESS1 as Add1 format = $50. informat = $50. length = 50,
	   b.ADDRESS2 as Add2 format = $50. informat = $50. length = 50,
	   b.ADDRESS3 as Add3 format = $50. informat = $50. length = 50,
	   b.ADDRESS4 as Add4 format = $50. informat = $50. length = 50,
	   b.CITY as City format = $30. informat = $30. length = 30,
	   b.POST_CODE as Postcode format = $12. informat = $12. length = 12,
	   b.COUNTY as County format = $30. informat = $30. length = 30,
	   b.COUNTRY as Country format = $30. informat = $30. length = 30
from Ss_1.Rlh_1e as a 
	 left join
	 edw.customer_latest_contact as b
on a.PARENT_account = b.ACCOUNT_NUMBER;
quit;
endrsubmit;


