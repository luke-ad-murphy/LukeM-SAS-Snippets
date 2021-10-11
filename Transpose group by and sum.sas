/* Thsi code will output three lines for each allocation_used_precent:
total customers, total cnt and total dur for each instance of allocation.... */


/* Create tariff flag and subset data */
data chk;
set chk;
where margin_band = "&band.";
type = 'TT600';
run;

/* Sort by allocation used */
proc sort data = chk; by allocation_used_percent; run;

/* Summarise into format for outputting */
proc means data = chk n missing noprint;
by allocation_used_percent;
var cnt dur;
class type; /* This variable will be a constant */
output out = chk1 (drop=_type_ rename=(_freq_=customers )) sum=;
run;

proc transpose data = chk1 out = tt600;
by allocation_used_percent;
id type;
var customers cnt dur;
run;
endrsubmit;
