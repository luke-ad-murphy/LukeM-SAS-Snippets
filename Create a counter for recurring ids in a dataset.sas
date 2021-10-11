rsubmit;
proc sort data = loy3; by bd_account EFFECTIVE_START_DATE; run;

data loy4;
set loy3;
by bd_account;

if first.bd_account then x = 1;
else x + 1;
 
run;
endrsubmit;
