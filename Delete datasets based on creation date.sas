%let dslist=%str();
proc sql;
     select memname into :dslist separated by ' '
     from sashelp.vtable
      here libname='OLDDATA' and datepart(crdate) < "15MAR2007"d;
quit;
run;
proc datasets  library=OLDDATA nolist nodetails;
delete &dslist;
quit;
run;