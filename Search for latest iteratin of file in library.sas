Proc SQL noprint;
select max(substr(memname,15,6)) into :pluto
from dictionary.tables
where libname = 'CAU_DVS' and memname like 'LM_2650_PLUTO_%';
quit;