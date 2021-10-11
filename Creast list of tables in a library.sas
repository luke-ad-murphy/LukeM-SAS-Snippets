proc sql;
create table x as 
select memname,
	   nobs,
	   nvar,
	   crdate,
	   modate
from sashelp.vtable
where libname = "PEOPLE"; /* Needs to be capitals */
quit;

