/* Replacing missing values with zeroes */

data cust1;
        set cust;
        array a(*) _numeric_;
        do i=1 to dim(a);
        if a(i)=. then a(i)=0;
        end;
        drop i;
run;



/* Or use this */
  array zero _numeric_;
  do over zero;
    if zero=. then zero=0;
  end;
