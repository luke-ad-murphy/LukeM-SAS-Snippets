
proc sort data = sept_selected nodupkey 
out = h; 
by MSISDN; 
run;

