proc sql;

select trim(name)||'='||trim(name)||'_NEW' 

into :varl separated by ' ' 

/*from sashelp.vcolumn */

from DICTIONARY.COLUMNS 

WHERE LIBNAME EQ "WORK" and MEMNAME EQ "F1" 

/*and upcase(name) like 'COL%'*/; 

quit;

data _null_;

%put &varl.;

run;


proc datasets library=work nolist; 

modify a; 

rename &varlist; 

quit; 

