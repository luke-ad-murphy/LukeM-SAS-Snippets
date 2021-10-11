proc export data=exp
     outfile='/var/opt/analysis_4/asis1/LM/value_4112.csv' dbms=csv;
run;

data _null_;
   infile '/var/opt/analysis_4/asis1/LM/value_4112.csv' firstobs=2;
   file '/var/opt/analysis_4/asis1/LM/value_4112x.csv';
   input;
   put _infile_;
run;
