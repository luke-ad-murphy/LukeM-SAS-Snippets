rsubmit;
data month_nums2;
set month_nums;
period = COMPRESS("Invoice_"||_n_,' ');
run;
endrsubmit;
