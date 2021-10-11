rsubmit;
proc sql;
create table master2 
as select a.flag, b.*
from custlist a, master1 b
where a.custid = b.custid;
quit;
endrsubmit;
