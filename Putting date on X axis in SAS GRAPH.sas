/* This SAS code is to put the date on the bottom of the chart    */
/* When creating the data, if you're looking at it weekly then    */
/* create a date for the 1st date of the week, the same can be    */
/* done on creating the 1st of the month as shown in the dataset  */
/* below.                                                         */



/* Forces the date to the first of that month */
rsubmit;
proc sort data=all_sales; by card_number trans_date; run;
data sales_data2 (drop= stroke qty2 );
	set all_sales;
	by card_number trans_date;
	if first.trans_date;
	date=datepart(trans_date);
	date=date-(day(date)-1);
	 format date monyy.;
num=1;
run;

/* DON'T WORRY ABOUT THIS SAS CODE, JUST TO SHOW THE EXAMPLE                                         */
/* aggregating to get a new variable which will indicate whether it was the first or second etc visit */
rsubmit;
proc sort data=sales_data2; by card_number; run;
data all_data;
	set sales_data2;
	by card_number;
	retain num2;
	if first.card_number then num2=num;
	else num2=num2+num;
run;

/* DON'T WORRY ABOUT THIS SAS CODE, JUST TO SHOW THE EXAMPLE */
/* renaming variables */
rsubmit;
proc datasets;
	modify all_data;
	rename num2=visits
		   num=no_of_times_purchased;
run;

/* DON'T WORRY ABOUT THIS SAS CODE, JUST TO SHOW THE EXAMPLE */
/* SUBMIT THESE LOCALLY AND REMOTELY */
rsubmit;
proc format;
value repeat
1='1'
2='2'
3='3'
4='4'
5 - high='5+';
run;

/* locally submit this code. This will create two new variables which will give the first date and the last date */
proc summary data=servwork.all_data;
var date;
output out=servwork.min_max_date max=max min=min;
run;

/* Creating macro variables for the first and last date */
data _null_;
set servwork.min_max_date;
call symput("var1",min);
call symput("var2",max);
run;


/* The proc gchart produces a vertical bar chart which holds the frequency of visits for customers buying   */
/* from the Smoothlines range. The subgroups splits the vertical bar. The sumvar is the variable that needs */
/* summing. The midpoints part is to get the first occurence of the date. Freq will put the total number on */
/* top of the vertical bar for the number of visits                                                         */
proc gchart data=servwork.all_data;
	where date ge '01jun01'd ;
	format visits repeat. date monyy.;
	vbar date / subgroup=visits freq  sumvar=no_of_times_purchased midpoints=&var1. to &var2. by month;      
	title 'Embellished Leaf Range - Repeat Purchasing Behaviour';
	run;
	quit;

