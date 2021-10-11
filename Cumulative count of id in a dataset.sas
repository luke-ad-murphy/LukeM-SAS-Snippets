rsubmit;
proc sort data = mult_hands2; by account_desc EFFECTIVE_START_DATE; run;

data mult_hands2;
set mult_hands2;
by account_desc;

if first.account_desc then discount = 1;
else discount + 1;
 
run;

proc freq data = mult_hands2; table discount; run;
endrsubmit;
