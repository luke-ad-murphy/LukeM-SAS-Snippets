


* Set up a macro variable ;
%let dt=01jan2000;

* Create a dataset date variable *;
data test;
	mydate="&dt"d;
	format mydate date9.;
run;


* Display using a put statement, as the previous day *;
%let dt2 = %sysfunc(putn(%sysevalf("&dt"d-1),date9.));
%put &dt2;

