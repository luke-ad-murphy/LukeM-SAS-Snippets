
/* ADD BANDINGS TO THE LAPSED GROUP */

/* using tier method */
/* 'test' is name of dataset you want to create percentiles for */
/* 'value' is name of the variable you want to create percentiles for */

rsubmit;
data test;
        set test (where=(value ne 0));
        merval = 1;
run;

proc univariate data=test;
        var value;
        output out=percentiles
        pctlpts=10 20 30 40 50 60 70 80 90 100 pctlpre=dct;
run;

data percentiles;
 set percentiles;
 merval=1;
run;

data test;
 merge test percentiles;
 by merval;
run;

* Here is where you decide how many groups you want;
data test;
 set test;
 if value lt dct40 then tier = 4;
 else if value lt dct70 then tier = 3;
 else if value lt dct90 then tier = 2;
 else tier = 1;
run;

data test;
	set test (drop=dct10 dct20 dct30 dct40 dct50 
					   dct60 dct70 dct80 dct90 dct100);
run;

proc freq data=test;
tables tier;
run;
endrsubmit;



