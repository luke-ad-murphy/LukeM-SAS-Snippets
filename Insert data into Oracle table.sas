libname kf_1 meta library = "kf_1" metaout = data;
libname Suba ORACLE PATH=EDWTP03 /*SCHEMA=edwdba*/ USER=rev_assurance PASSWORD=revassurance;
 
data rk; 
set kf_1.lm_1706_dec12_segs (obs=100);
run;

Proc freq data=rk; tables account_desc /norow nocol nocum nopercent; run;

PROC SQL;
connect to oracle (user=rev_assurance password=revassurance path='EDWTP03');
*delete * from suba.PT_DELETE;
INSERT INTO suba.PT_DELETE SELECT
"12345", a.account_desc
FROM 
(
select 
account_desc from 
rk
) as a
;
disconnect from oracle;
QUIT;
