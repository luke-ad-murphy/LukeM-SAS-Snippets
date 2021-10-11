proc sort data = dates; by new_cardno newdate; run;

data dates2;
   set dates;
   by new_cardno;
   Firstpurch = first.new_cardno;
   Lastpurch = last.new_cardno;
run;
