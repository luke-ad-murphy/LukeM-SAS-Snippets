data sales;
set focus.allsales (where = (newdate ge '31JUL2006'd and newdate le '22APR2007'd));
week = WEEK(newdate,'W');
run;
