rsubmit;
data dates;
set asis5.Lm_period_lookup;
where date = today();

* also changing a character variable to numeric here;
month2 = put(COMPRESS(Period_pre,''),$6.);
* changing a date field to a text (as a date written in string);
start = put(Start_pre, date9.);

call symput('month',month2);
call symput('start_day',start);

run;
endrsubmit;


rsubmit;
data _null_;
  %put &month.;
  %put start_day;
run;
endrsubmit;


/* Example of using one of the macro vars created */
rsubmit;
data test_&month. (obs = 10);
set margin.Finance_z4a_&month.;
run;
endrsubmit;
