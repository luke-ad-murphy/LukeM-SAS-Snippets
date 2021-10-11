
/* ADD BANDINGS TO THE LAPSED GROUP */

/* using tier method */
rsubmit;
%let indivs=interim.lapsindiv;
data &indivs.;
        set &indivs. (where=(value ne 0));
        merval = 1;
run;

proc univariate data=&indivs.;
        var value;
        output out=percentiles
        pctlpts=10 20 30 40 50 60 70 80 90 100 pctlpre=dct;
run;

data percentiles;
 set percentiles;
 merval=1;
run;

data &indivs.;
 merge &indivs. percentiles;
 by merval;
run;

data &indivs.;
 set &indivs.;
 if value lt dct40 then tier = 4;
 else if value lt dct70 then tier = 3;
 else if value lt dct90 then tier = 2;
 else tier = 1;
run;

data &indivs.;
	set &indivs. (drop=dct10 dct20 dct30 dct40 dct50 
					   dct60 dct70 dct80 dct90 dct100);
run;

proc freq data=&indivs.;
tables tier;
run;
endrsubmit;




/* using quartiles */
rsubmit;
%let indivs=interim.lapsindiv;

proc univariate data=&indivs.;
        var value;
        output out=percentiles2
        pctlpts=25 50 75 100 pctlpre=dct;
run;

data percentiles2;
 set percentiles2;
 merval=1;
run;

data &indivs.;
 merge &indivs. percentiles2;
 by merval;
run;

data &indivs.;
 set &indivs.;
 if value lt dct25 then band = 4;
 else if value lt dct50 then band = 3;
 else if value lt dct75 then band = 2;
 else band = 1;
run;

proc freq data=&indivs.;
tables band;
run;

data &indivs.;
	set &indivs. (drop=dct25 dct50 dct75 dct100 merval);
run;
endrsubmit;
