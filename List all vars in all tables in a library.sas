proc sql;
create table columns as
select name as variable
,memname as table_name
from dictionary.columns
where libname = 'CAS_DVG'
;
quit;
