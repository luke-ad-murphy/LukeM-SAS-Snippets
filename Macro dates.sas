rsubmit;

options mprint mlogic symbolgen;

data _null_;

call symput ('ld0',put(intnx('month',today(),-1,'beginning'),yymmn6.));

run;

data _null_;

call symput ("repdate",compress(put(intnx("month",today(),-1),date9.) ) );

call symput ("repdateB",compress(put(intnx("month",today(),-1),date9.)!!":00:00:00") );

call symput ("repdateA",compress(put(intnx("month",today(),0),date9.)!!":00:00:00" ) );

call symput ("wk1",compress(put(intnx("semimonth",today(),-3),date9.)!!":00:00:00"));

call symput ("wk2",compress(put(intnx("semimonth",today(),-2),date9.)!!":00:00:00"));

call symput ("wk3",compress(put(intnx("semimonth",today(),-1),date9.)!!":00:00:00"));

run;

%put &repdate.;

%put &repdateB.;

%put &repdateA.;

%put &ld0;

%put &wk1;

%put &wk2;

%put &wk3;

endrsubmit;

