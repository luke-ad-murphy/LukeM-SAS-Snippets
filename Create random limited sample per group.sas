/* Macros */
%let size = 20000; /*Sample size required per segment */
%let file = cas_dvg.Sniper_segments_&period.; /*file of data to be sampled*/ 
%let group = sniper_segment; /* Name of grouping or segment to sample by */



/* List of groups to create samples for */
proc summary nway missing data = &file.;
where &group. NE '';
class &group.;
var ;
output out = seg_cnt (drop = _type_);
run;

data seg_cnt;
set seg_cnt;
count = _n_;
call symput('max', max(count));
run;
%put &max.;



/* Extract required number of records rows (where available) 
for each group */
%macro sample(bat=);

data seg;
set seg_cnt;
where count = &bat.;
call symput('seg', &group.);
run;

data samp_&bat. 
(keep=billing_account_number MSISDN &group. rand cntr_end_dt);
set &file.;
where billing_account_number =: '9'
AND MSISDN NE .
AND &group. = "&seg.";
rand = ranuni(100);
run;

proc sort data = samp_&bat.; by rand; run;

data samp_&bat. (drop=rand);
set samp_&bat. (obs=&size.);
run;
%mend sample;  


%macro driver;
  %do i = 1 %to &max.;
      %sample(bat = &i.);
  %end;
%mend;
%driver;   



/* Append samples into one file */
data sample;
set samp_1;
run;

%macro append(bat=);
data sample;
set sample samp_&bat.;
run;
%mend append;  

%macro driver;
  %do i = 2 %to &max.;
      %append(bat = &i.);
  %end;
%mend;
%driver;   

proc freq data = sample; table &group. ; run;


***********************************XXXXXXXX**********************************;
********************************XXXXXXXXXXXXXX*******************************;
*****************************************************************************;
*************************  E-N-D  O-F  P-R-O-G-R-A-M ************************;
*****************************************************************************;
********************************XXXXXXXXXXXXXX*******************************;
***********************************XXXXXXXX**********************************;