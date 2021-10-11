rsubmit;
%macro per(infile, outfile, percentiles, p1, p2, start_var, stop_var, lib, file);
/*
proc printto print='\\Linda\crm_business_data\helen\work\output.lst'
log ='\\Linda\crm_business_data\helen\work\log.lst';
run;

proc printto print="&output_location.output.lst"
log ="&output_location.log.lst";
run;
*/
%let opp=%sysfunc(open(&infile));

%let start=%sysfunc(varnum(&opp,&start_var));
%let stop=%sysfunc(varnum(&opp,&stop_var));

%do j = &start %to &stop;
%let y&j=%sysfunc(varname(&opp,&j));
%let t=%eval(&j-1);

data t1; set &infile;
	if &&y&j in (0, .) then delete;
	run;

%let t_op=%sysfunc(open(t1));
%let obst=%sysfunc(attrn(&t_op,nobs));
%let t_cl=%sysfunc(close(&t_op));
%if &obst>0 %then %do;

proc univariate data = t1;
output out = &percentiles pctlpts=&p1 &p2 pctlpre= &&y&j.._ pctlname =p10 p90;
var &&y&j;  run;

%let op=%sysfunc(open(&percentiles));
%let cnt=%sysfunc(attrn(&op,nvars));
%do i = 1 %to &cnt;
%let x&i=%sysfunc(varname(&op,&i));
%end;
%let rc=%sysfunc(close(&op));
data _null_;
	set &percentiles; 
	if _n_=1 then call symput('st1',ceil(&x1));
	if _n_=1 then call symput('st2',ceil(&x2));
	run;

%let diff = %sysfunc(ceil((&st2-&st1)/7));

data outfile1; set  
	%if &j=&start %then %do;
	&infile
	%end;
	%else %do;
	outfile1
	%end;
	;

	%do i=0 %to 9;
	%let diff2t_&i=%eval((&diff.*&i)+&st1);

	%if &&diff2t_&i <=10 %then %do;
	%let diff1_&i = %sysfunc(round(&&diff2t_&i,1));
		%if &&diff1_&i < &&diff2t_&i %then %do;
			%let diff2_&i = %eval(&&diff1_&i +1);
			%end;
		%else %do;
			%let diff2_&i = &&diff1_&i;
			%end;
	%end;
	%else %if &&diff2t_&i >10 and &&diff2t_&i<=50 %then %do;
	%let diff1_&i = %sysfunc(round(&&diff2t_&i,5));
		%if &&diff1_&i < &&diff2t_&i %then %do;
			%let diff2_&i = %eval(&&diff1_&i +5);
			%end;
		%else %do;
			%let diff2_&i = &&diff1_&i;
			%end;
	%end;
	%else %if &&diff2t_&i >50 and &&diff2t_&i<=100 %then %do;
	%let diff1_&i = %sysfunc(round(&&diff2t_&i,10));
		%if &&diff1_&i < &&diff2t_&i %then %do;
			%let diff2_&i = %eval(&&diff1_&i +10);
			%end;
		%else %do;
			%let diff2_&i = &&diff1_&i;
			%end;
	%end;
	%else %if &&diff2t_&i >100 and &&diff2t_&i<=1000 %then %do;
	%let diff1_&i = %sysfunc(round(&&diff2t_&i,50));
		%if &&diff1_&i < &&diff2t_&i %then %do;
			%let diff2_&i = %eval(&&diff1_&i +50);
			%end;
		%else %do;
			%let diff2_&i = &&diff1_&i;
			%end;
	%end;
	%else %if &&diff2t_&i >1000 and &&diff2t_&i<=10000 %then %do;
	%let diff1_&i = %sysfunc(round(&&diff2t_&i,100));
		%if &&diff1_&i < &&diff2t_&i %then %do;
			%let diff2_&i = %eval(&&diff1_&i +100);
			%end;
		%else %do;
			%let diff2_&i = &&diff1_&i;
			%end;
	%end;
	%else %if &&diff2t_&i >10000 %then %do;
	%let diff1_&i = %sysfunc(round(&&diff2t_&i,1000));
		%if &&diff1_&i < &&diff2t_&i %then %do;
			%let diff2_&i = %eval(&&diff1_&i +1000);
			%end;
		%else %do;
			%let diff2_&i = &&diff1_&i;
			%end;
	%end;
	%end;

	format b&&y&j $20.;
	if &&y&j=. then b&&y&j="N. Missing";
	else if &&y&j =0 then b&&y&j="A. 0";
	else if 0 lt &&y&j <=&diff2_0 then b&&y&j="B. 0-&diff2_0";
	else if &diff2_0 lt &&y&j <=&diff2_1 then b&&y&j="C. &diff2_0.-&diff2_1";
	else if &diff2_1 lt &&y&j <=&diff2_2 then b&&y&j="D. &diff2_1.-&diff2_2";
	else if &diff2_2 lt &&y&j <=&diff2_3 then b&&y&j="E. &diff2_2.-&diff2_3";
	else if &diff2_3 lt &&y&j <=&diff2_4 then b&&y&j="F. &diff2_3.-&diff2_4";
	else if &diff2_4 lt &&y&j <=&diff2_5 then b&&y&j="G. &diff2_4.-&diff2_5";
	else if &diff2_5 lt &&y&j <=&diff2_6 then b&&y&j="H. &diff2_5.-&diff2_6";
	else if &diff2_6 lt &&y&j <=&diff2_7 then b&&y&j="I. &diff2_6.-&diff2_7";
	else if &diff2_7 lt &&y&j <=&diff2_8 then b&&y&j="J. &diff2_7.-&diff2_8";
	else if &diff2_8 lt &&y&j <=&diff2_9 then b&&y&j="K. &diff2_8.-&diff2_9";
	else if &&y&j >&diff2_9 then b&&y&j="L. >&diff2_9";
	else b&&y&j="M. Other"; 
	*bdummy=0;
	run;
	proc freq data =  outfile1; tables b&&y&j; run;
	%end;
	%else %do;
	data outfile1; set 
		%if &j=&start %then %do;
		&infile
		%end;
		%else %do;
		outfile1
		%end;
		;
		b&&y&j=0;
		run;
		%end;
	%end;

%do j = &start %to &stop;
%let l&j=%sysfunc(varlabel(&opp,&j));
proc datasets lib=work; 
modify outfile1;
label 
b&&y&j=&&l&j
;
run;
data &outfile (drop = &&y&j); set outfile1; run;
%end;
%let rcc=%sysfunc(close(&opp));

proc printto; run;

%mend per;
endrsubmit;

rsubmit;
%per(bandtest, bandtest1, per, 5, 95, invoice_n1, margin_n3, work, bandtest1);
endrsubmit;
