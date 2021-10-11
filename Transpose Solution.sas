
* Construct some data which represents that of the data to be summarised and reported;
data work.t1;
input category $ region value;
datalines;
A 1 20
A 1 20
A 1 28
A 1 40
A 2 30
A 3 25
B 1 40
B 3 12
C 1 90
C 2 80
C 3 75
C 4 76
run;

* Collapse the data to one row per region, per category;
proc summary data=work.t1 nway missing;
  class category region;
  var value;
  output out=work.t2 sum=;
run;

* Sort allows tranpose by cateogry;
proc sort data=work.t2;
  by category;
run;

* Transpose :-
		PREFIX is the text "REGION" to all new columns created will be
                prefixed with Region
		BY category, to obtain one row per category,
		ID of region to use the values in the region column as 
	       the suffix to the new column name
		VAR is value, i.e. the data column to be transposed
  		;
proc transpose data=work.t2 out=work.t3(drop=_name_) prefix=Region;
  by category;
  id region;
  var value;
run;

* Create a simple listing to a CSV file for importing into Excel. 
    NOTE:  ODS CSV is experimental in V8.2, although is quite robust
           for proc print, it differs to the production release (SAS V9)
           by the fact that the two blank rows at the top of the CSV file
           created in V8.2 are omitted in V9;
ods csv file="tranpose.csv";
proc print data=work.t1 noobs; * Original data;
run;
proc print data=work.t3 noobs; * Transposed data;
run;
ods csv close;