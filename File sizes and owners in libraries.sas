GOPTIONS ACCESSIBLE;

libname CAs_DVg meta library="CAs_DVg" metaout=data;
libname CAs_DVs meta library="CAs_DVs" metaout=data;
libname CAu_DVg meta library="CAu_DVg" metaout=data; 
libname CAu_DVs meta library="CAu_DVs" metaout=data; 

options validvarname=any;

ods listing close;

/* Get names of creators of large files */
proc sql;
create table Old_Big_Files as
select compress(libname||"."||memname) as filename, 
filesize/(1024*1024) format comma8.2 as Filesize_Mb,
datepart(modate) format ddmmyy10. as Last_Modified

from dictionary.tables where libname like "CA_%"    /*Note - This will only work for libraries that you have declared via a libanme statemnt.*/

order by modate 
;quit;


/*CAs_DVg*/
libname read '/var/opt/sas/sas_user01/CA/secure';

  ods output Contents.DataSet.EngineHost=tt ;

  proc contents data=read._all_ out=test details /*(keep=libname memname)*/ ;
  run ;

  data owners_CAs_DVg ;
    set tt (where=(Label1="Owner Name")) ;
  run ;


/*CAs_DVs*/
libname read "/var/opt/sas/userarch01/CA/secure";

  ods output Contents.DataSet.EngineHost=tt ;

  proc contents data=read._all_ out=test details /*(keep=libname memname)*/ ;
  run ;

  data owners_CAs_DVs ;
    set tt (where=(Label1="Owner Name")) ;
  run ;


/*CAu_DVg*/
libname read "/var/opt/sas/sas_user01/CA/shared";

  ods output Contents.DataSet.EngineHost=tt ;

  data owners_CAu_DVg ;
    set tt (where=(Label1="Owner Name")) ;
  run ;


/*CAu_DVs*/
libname read "/var/opt/sas/userarch01/CA/shared";

  ods output Contents.DataSet.EngineHost=tt ;

  data owners_CAu_DVs ;
    set tt (where=(Label1="Owner Name")) ;
  run ;



PROC SQL;
	CREATE TABLE All_Tables_Owners AS 
	SELECT * FROM owners_CAs_DVg
	 OUTER UNION CORR 
	SELECT * FROM owners_CAs_DVs
	 OUTER UNION CORR 
	SELECT * FROM owners_CAu_DVg
	 OUTER UNION CORR 
	SELECT * FROM owners_CAu_DVs
;
Quit;


proc sql;
create table All_Tables_Owners2
as select 
substr(a.member,6,200)as Table,
a.cValue1 as Owner
from All_Tables_Owners as a;
run;

data OLD_BIG_FILES2;
set OLD_BIG_FILES;
dataset_name = substr(filename,9,200);
library = substr(filename,1,7);
run;


* Join owner names;
PROC SQL;
   CREATE TABLE All_Tables_With_Owners AS 
   SELECT distinct 
		  	t1.library
			,t1.dataset_name
			,t1.Filesize_Mb
          	,t1.Last_Modified
		  	,t2.owner
      FROM OLD_BIG_FILES2 t1
           LEFT JOIN 
		   ALL_TABLES_OWNERS2 t2 
ON dataset_name = t2.Table
ORDER BY Last_Modified;
QUIT;



* Export file;
filename Usage temp;
proc export data=All_Tables_With_Owners outfile=Usage dbms=csv;
   run;
data _null_;
   infile Usage firstobs=1;
   file "/var/opt/sas/userarch11/logs/analytics/output/data_out/Usage_Report.csv";
   input;
   put _infile_;
run;

options emailhost=brmdep01v.it.hutchison3g.net;
filename outbox email ("Luke.Murphy@three.co.uk")           
type='text/html'
to   = 'DLAdvancedAnalytics@three.co.uk'
Subject = "SAS Library Usage - Please Review"
attach = ("/var/opt/sas/userarch11/logs/analytics/output/data_out/Usage_Report.csv");

ods html
   body=outbox /* Mail it! */
   rs=none; 


***********************************XXXXXXXX**********************************;
********************************XXXXXXXXXXXXXX*******************************;
*****************************************************************************;
*************************  E-N-D  O-F  P-R-O-G-R-A-M ************************;
*****************************************************************************;
********************************XXXXXXXXXXXXXX*******************************;
***********************************XXXXXXXX**********************************;