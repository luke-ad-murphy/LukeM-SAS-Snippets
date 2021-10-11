rsubmit;
data Kf_1.prod_holdings;
set Kf_1.prod_holdings;
format Months_join monyy5.;
Months_join = INTNX("Month",init_cntr_start_dt,0);
If Tot_adds GE 3 then Prods = 3;
else Prods = Tot_adds;
run;
endrsubmit;
