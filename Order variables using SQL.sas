rsubmit;
data test;
var1=1;
var2=3;
var3="vic";
var4="is";
var5="ace";
run;
endrsubmit;


rsubmit;
proc sql;
create table  finaloutputdd
as select var1, var3,var2,var5,var4
from test
;
quit; 
endrsubmit;
