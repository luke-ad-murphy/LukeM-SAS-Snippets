/* VERY USEFUL FOR MERGING TWO DATASETS (WHERE ONE IS LARGE),
   USING NORMAL BASE SAS CODE WOULD TAKE MUCH LONGER DUE
   OT THE NECCESSITY TO SORT THE DATASETS PRIOR OT MERGING */	

rsubmit;
proc sql;
create table x
as select a.*, b.*
from custlist a, salesdata b
where a.custid = b.custid;
quit;
endrsubmit;