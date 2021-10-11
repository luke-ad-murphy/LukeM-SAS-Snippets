rsubmit;
DATA custndid (keep = fmtname start label ); 
LENGTH LABEL $20; 
SET add_ons; 
FMTNAME = "$custndid"; 
START = ACCOUNT_DESC; 
LABEL = "YES"; 
RUN;

proc sort data = custndid nodupkey;	by start; run;

* create a format from the dummy data;
PROC FORMAT cntlin = custndid; 
RUN; 

