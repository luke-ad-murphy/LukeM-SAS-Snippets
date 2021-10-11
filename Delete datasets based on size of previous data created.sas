%macro chk;
%let obsx=0;
 
data z;
x=0;
do while (x>0);
set mc_1.PREPAY_base2 nobs=nobs;
end;
call symput('obsx',nobs);
run;
 
%put &obsx;
 
%if &obsx.>8000000 %then %do;
 proc datasets lib=mc_1 nolist;
   delete prepay_base1 pp_base;
  run;

%end;*of do loop*;
%mend chk;
%chk;
