ods csv file ="/var/opt/analysis_4/asis1/automated_jobs/luke/OUTPUT/test.csv"; 
proc print data = x noobs;
run;
ods csv close;
