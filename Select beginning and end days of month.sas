rsubmit;
data x;
format start date9.;
format end date9.;

date = today();
start = intnx('month', date,-1,'beginning');
end = intnx('month', date,-1,'end');
startmon = put(start,yymmn6.);

put month date9. ;
put start date9. ;
put end date9. ;
run;
endrsubmit;
