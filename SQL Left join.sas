
* Append handset used back onto selected handsets data;
rsubmit;
proc sql;
create table Selected_prepay3 as
select a.*, 
	b.Manufacturer,
	b.Marketing_Name,
	b.Designation_Type,
	b.Bands
from Selected_prepay2 as a
	 left join
	 hands_may08v5 as b
on a.account_desc = b.account_desc;
quit;
endrsubmit;
