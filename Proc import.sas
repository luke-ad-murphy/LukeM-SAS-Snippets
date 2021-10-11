libname foc06dec 'I:\Focus DIY\2006\2006 December data\SAS Data';
libname foc06dec 'C:\Documents and Settings\lmurphy\My Documents\My Work\Focus DIY\2006\2006 December data\SAS Data';

***********************************************************************************************;
***********************************************************************************************;
***********************************************************************************************;

*********************;
* IMPORT MAIL FILES *;
*********************;

* import 5655_Focus_December_HM_A5_D;
proc import datafile = 'C:\Documents and Settings\lmurphy\My Documents\My Work\Focus DIY\2006\2006 December data\Mail files\5655_Focus_December_HM_A5_D.csv'
out = foc06dec.Focus_December_HM_A5_D
replace;
datarow = 2;
getnames = yes;
delimiter = ",";
run;



* import 5655_Focus_December_HM_Long_D_v2;
proc import datafile = 'C:\Documents and Settings\lmurphy\My Documents\My Work\Focus DIY\2006\2006 December data\Mail files\5655_Focus_December_HM_Long_D_v2.csv'
out = foc06dec.Focus_December_HM_Long_D_v2
replace;
datarow = 2;
getnames = yes;
delimiter = ",";
run;



* import 5655_Focus_December_HM_Long_N_v2;
proc import datafile = 'C:\Documents and Settings\lmurphy\My Documents\My Work\Focus DIY\2006\2006 December data\Mail files\5655_Focus_December_HM_Long_N_v2.csv'
out = foc06dec.Focus_December_HM_Long_N_v2
replace;
datarow = 2;
getnames = yes;
delimiter = ",";
run;



* import 5655_Focus_December_O60_A5_D;
proc import datafile = 'C:\Documents and Settings\lmurphy\My Documents\My Work\Focus DIY\2006\2006 December data\Mail files\5655_Focus_December_O60_A5_D.csv'
out = foc06dec.Focus_December_O60_A5_D
replace;
datarow = 2;
getnames = yes;
delimiter = ",";
run;



* import 5655_Focus_December_O60_A5_N;
proc import datafile = 'C:\Documents and Settings\lmurphy\My Documents\My Work\Focus DIY\2006\2006 December data\Mail files\5655_Focus_December_O60_A5_N.csv'
out = foc06dec.Focus_December_O60_A5_N
replace;
datarow = 2;
getnames = yes;
delimiter = ",";
run;



* import 5655_Focus_December_O60_Long_D_v2;
proc import datafile = 'C:\Documents and Settings\lmurphy\My Documents\My Work\Focus DIY\2006\2006 December data\Mail files\5655_Focus_December_O60_Long_D_v2.csv'
out = foc06dec.Focus_December_O60_Long_D_v2
replace;
datarow = 2;
getnames = yes;
delimiter = ",";
run;
