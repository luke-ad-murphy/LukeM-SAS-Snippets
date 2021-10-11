data y2009;
set asis9.wlm_usage_agg (OBS = 10000);
where year = '2009'
AND supplier = "Neustar";
format date monyy5.;
date = input("01"||month||year,date9.);
run;