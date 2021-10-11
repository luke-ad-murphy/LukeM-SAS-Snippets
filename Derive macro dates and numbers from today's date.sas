rsubmit;
data x;
date = today();
* get start date of previous month;
start = intnx('month', date,-1,'beginning');
* get end date of previous month;
end = intnx('month', date,-1,'end');
* get start date of previous week;
startw = intnx('week', date,-1,'beginning');
* get end date of previous week;
endw = intnx('week', date,-1,'end');

* create a var giving year and month e.g. 200809;
startmon = put(start,yymmn6.);

put date date9.;
put start date9.;
put end date9.;
put startw date9.;
put endw date9.;

run;
endrsubmit;


rsubmit;
data _null_;
  %put &month.;
  %put &start;
  %put &end;
  %put &startw;
  %put &endw;
run;
endrsubmit;
