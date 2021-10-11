/* Use =: to signify begins with */

data test;
  set mc_1.za;
    where CHARGE_USAGE_CODES =: "101:128";
run;
