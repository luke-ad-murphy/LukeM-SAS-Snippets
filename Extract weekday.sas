* extracts weekday from a date field 
1 = sunday
2= monday etc etc;

data sales2;
set sales2;
day = weekday(newdate);
run;



rsubmit;
data x (where = (NETWORK_TO in ("O2","ORANGE","VODAFONE","VIRGIN","T_MOBILE", "3_UK")));
set international_193_01 (obs = 100);

format NETWORK_TO $40.;
format time TOD.;
format day DOWNAME.;

NETWORK_TO = put(B_PARTY_NETWORK_ID,type.);
time = (charge_start_date);
date2 = datepart(charge_start_date);
day = (date2);


run;
endrsubmit;
