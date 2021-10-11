* creating two new flags for 1st and last records by each urn;

proc sort data = sales2; by new_cardno newdate; run;

data sales3;
   set sales2;
   by new_cardno;
   Firstpurch = first.new_cardno;
   Lastpurch = last.new_cardno;
run;
