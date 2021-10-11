data x;
firstname = 'Luke';
surname = 'Murphy';
run;


/* EXPORT CODE */ /* THIS MUST NOT BE RUN REMOTELY */
data _null_;
set  x;
file "/var/opt/analysis_4/asis1/SIM/wicky.csv" delimiter=',' DSD DROPOVER lrecl=32767;

format firstname $12. ;
format surname $12. ;

if _n_ = 1 then do;
	put 'firstname'  ','  'surname';
end;

do;
    put firstname $ @;
    put surname $ @;
end;

run;
