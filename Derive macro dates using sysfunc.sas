libname CAs_dvG meta library = "CAs_dvG" metaout = data; * SECURE development area;
libname RuSAND meta library = "RuSAND" metaout = data; 




* Period of churn and upgrade service orders;
* Risk month;
%let ch_mon = %sysfunc(intnx(month,%sysfunc(today()),1),yymmn6.);
%let ch_st = %sysfunc(intnx(month,%sysfunc(today()),1,b),ddmmyy10.);
%let ch_md = %sysfunc(intnx(month,%sysfunc(today()),1,m),ddmmyy10.);
%let ch_ed = %sysfunc(intnx(month,%sysfunc(today()),1,e),ddmmyy10.);

%let ch_mdx = %sysfunc(intnx(month,%sysfunc(today()),1,m),date9.);


* Behavoural period to analysis;
%let beh_st	= %sysfunc(intnx(month,%sysfunc(today()),-3,b),ddmmyy10.);
%let beh_ed	= %sysfunc(intnx(month,%sysfunc(today()),-1,e),ddmmyy10.);

%let beh_stx= %sysfunc(intnx(month,%sysfunc(today()),-3,b),date9.);
%let beh_edx= %sysfunc(intnx(month,%sysfunc(today()),-1,e),date9.);

%let beh_m1_st	= %sysfunc(intnx(month,%sysfunc(today()),-3,b),ddmmyy10.);
%let beh_m1_ed	= %sysfunc(intnx(month,%sysfunc(today()),-3,e),ddmmyy10.);
%let beh_m2_st	= %sysfunc(intnx(month,%sysfunc(today()),-2,b),ddmmyy10.);
%let beh_m2_ed	= %sysfunc(intnx(month,%sysfunc(today()),-2,e),ddmmyy10.);
%let beh_m3_st	= %sysfunc(intnx(month,%sysfunc(today()),-1,b),ddmmyy10.);
%let beh_m3_ed	= %sysfunc(intnx(month,%sysfunc(today()),-1,e),ddmmyy10.);

%let beh_m1_stx	= %sysfunc(intnx(month,%sysfunc(today()),-3,b),date9.);
%let beh_m1_edx	= %sysfunc(intnx(month,%sysfunc(today()),-3,e),date9.);
%let beh_m2_stx	= %sysfunc(intnx(month,%sysfunc(today()),-2,b),date9.);
%let beh_m2_edx	= %sysfunc(intnx(month,%sysfunc(today()),-2,e),date9.);
%let beh_m3_stx	= %sysfunc(intnx(month,%sysfunc(today()),-1,b),date9.);
%let beh_m3_edx	= %sysfunc(intnx(month,%sysfunc(today()),-1,e),date9.);

%let beh_m1	= %sysfunc(intnx(month,%sysfunc(today()),-3),yymmn6.);
%let beh_m2 = %sysfunc(intnx(month,%sysfunc(today()),-2),yymmn6.);
%let beh_m3	= %sysfunc(intnx(month,%sysfunc(today()),-1),yymmn6.);

%let p1date = %sysfunc(intnx(month,%sysfunc(today()),-3,b),date9.);
%let p0date = %sysfunc(intnx(month,%sysfunc(today()),-2,b),date9.);

%let rec_st = %sysfunc(intnx(month,%sysfunc(today()),-1,b),date9.);
%let rec_ed = %sysfunc(intnx(month,%sysfunc(today()),-1,e),date9.);



%put ch_mon	= &ch_mon;
%put ch_st	= &ch_st;
%put ch_md 	= &ch_md;
%put ch_ed	= &ch_ed;

%put ch_mdx = &ch_mdx;


* Behavoural period to analysis;
%put beh_st	= &beh_st;
%put beh_ed	= &beh_ed;

%put beh_stx= &beh_stx;
%put beh_edx= &beh_edx;

%put beh_m1_st	= &beh_m1_st;
%put beh_m1_ed	= &beh_m1_ed;
%put beh_m2_st	= &beh_m2_st;
%put beh_m2_ed	= &beh_m2_ed;
%put beh_m3_st	= &beh_m3_st;
%put beh_m3_ed	= &beh_m3_ed;

%put beh_m1_stx	= &beh_m1_stx;
%put beh_m1_edx	= &beh_m1_edx;
%put beh_m2_stx	= &beh_m2_stx;
%put beh_m2_edx	= &beh_m2_edx;
%put beh_m3_stx	= &beh_m3_stx;
%put beh_m3_edx	= &beh_m3_edx;

%put beh_m1	= &beh_m1;
%put beh_m2 = &beh_m2;
%put beh_m3	= &beh_m3;

%put p1date = &p1date;
%put p0date = &p0date;

%put rec_st = &rec_st;
%put rec_ed = &rec_ed;

* contract end date parameters to include in base;
* customer needs to be within 110 days of CED at start of risk month;
data x;
format z ddmmyy10.;
z = input(&ch_st., ddmmyy10.);
format ced ddmmyy10.;
ced = z + 110; /* Customer is within 110 days of CED at START of risk month, e.g. risk month dec 15 = 1st Dec + 110 days = 20th Mar 2016; */
call symput ('ced', ced);
rced = "'"||put(ced, ddmmyy10.)||"'";
call symput ('rced', rced);
run;

***********************************XXXXXXXX**********************************;
********************************XXXXXXXXXXXXXX*******************************;
*****************************************************************************;
*************************  E-N-D  O-F  P-R-O-G-R-A-M ************************;
*****************************************************************************;
********************************XXXXXXXXXXXXXX*******************************;
***********************************XXXXXXXX**********************************;