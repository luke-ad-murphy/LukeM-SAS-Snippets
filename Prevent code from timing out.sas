%macro mc(); 
 %let x = 1;
  %do %while (&x. < 120) ;
    data _null_;
      z=sleep(3600);
    run;
    %include "h:\remote.sas" ;
	%let x = %eval(&x.+1);
  %end; 
%mend;
%mc;
