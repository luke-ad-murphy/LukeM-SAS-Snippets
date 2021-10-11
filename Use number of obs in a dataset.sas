data temp;
set ts_1.rb_1569_current_hs_customers;
rank=_n_;
run;

%let dsid=%sysfunc(open(temp));
%let num=%sysfunc(attrn(&dsid,nlobs));
%let rc=%sysfunc(close(&dsid));

data temp2;
set temp;
if rank le &num./10;
run; 