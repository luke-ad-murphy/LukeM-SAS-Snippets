proc sort data = c_all; by msisdn file; run;


data c_all (keep = MSISDN week cell);
set c_all;
by msisdn;
if first.msisdn;
run;
