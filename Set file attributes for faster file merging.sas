rsubmit;
proc sql;
create index INST_PROD_ID on asis5.LM_Accounts (INST_PROD_ID);
quit;

data asis5.LM_Accounts;
attrib 
INST_PROD_ID length = $15.
rbtacctid length = $15.;
set asis5.LM_Accounts;
run;

proc sort data = asis5.LM_Accounts; by INST_PROD_ID; run;
endrsubmit;
