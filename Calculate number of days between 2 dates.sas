* Date_ddesc has datepart() around it because it has date and time whereas
init_cntr_start_dt is only date;

rsubmit;
data Asis5.Lm_add_ons_total;
set Asis5.Lm_add_ons_total;
Days_diff = INTCK('Days',init_cntr_start_dt,datepart(Date_desc));
run;
endrsubmit;


