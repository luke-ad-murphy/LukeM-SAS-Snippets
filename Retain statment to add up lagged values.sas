rsubmit;
proc sort data = asis5.Lm_chg_intl_jun08; by NORMALISED_EVENT_ID; run;

data asis5.Lm_chg_intl_jun08;
retain charge_new;
set asis5.Lm_chg_intl_jun08;

format Charge_new 24.6;

by NORMALISED_EVENT_ID;

if first.NORMALISED_EVENT_ID then Charge_new = 0;
Charge_new = Charge_new + charge;
 
run;
endrsubmit;








