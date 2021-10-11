rsubmit;
data asis9.sub_imeis;
set asis9.sub_imeis;
format account_id best12.;
account_id = input(RBTACCTID,best12.);
run;
endrsubmit;
