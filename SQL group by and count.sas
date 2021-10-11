rsubmit;
proc sql;
create table map as
select offer1, offer2, offer3, offer4, count (*) as volume
from offers
group by offer1, offer2, offer3, offer4;
quit;
endrsubmit;
