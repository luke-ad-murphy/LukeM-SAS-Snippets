*delete temporary datasets - where kill deletes all datasets;
proc datasets lib=work kill nolist memtype=data;
quit;


*delete temporary datasets - where you want to denote specific datasets, in this case AE and DEMO;
proc datasets lib=work nolist;
delete AE DEMO;
quit;
run;
