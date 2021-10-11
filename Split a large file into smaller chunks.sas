/* Macro to split file into specified number of variables */
%macro split1(num);
data _null_;
if 0 then set orig nobs=count;
call symput('numobs',put(count,8.));
run;

%let m=%sysevalf(&numobs/&num,ceil);

data %do J=1 %to &m ; orig_&J %end;;
set Group1;
%do I=1 %to &m;
if %eval(&num*(&i-1)) <_n_ <=
%eval(&num*&I) then output orig_&I;
%end;
run;
%mend split1;


/* Run macro to create multiple splt files */
data orig;
do i = 1 to 1738200; * 1738200 is number of records in the file I want to split;
output;
end;
run;
%split1(20000); * Selects the number of records you want in each file;