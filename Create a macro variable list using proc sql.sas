/*If you've read my article about implementing BY processing for an entire SAS program, you know that you can use PROC SQL and SELECT INTO to place data values from a data set into a macro variable. For example, consider this simple program:*/


proc sql;
 select distinct ORIGIN into :valList separated by ',' from SASHELP.CARS;
quit;

/*It creates a macro variable VALLIST that contains the comma-separated list: "Asia,Europe,USA".*/
/**/
/*But we can use SAS functions to embellish that output, and create additional code statements that weave the data values into SAS program logic. For example, we can use the CAT function to combine the values that we query from the data set with SAS keywords. The results are complete program statements, which can then be referenced/executed in a SAS macro program. I'll share my final program, and then I'll break it down a little bit for you. Here it is:*/


/* define which libname.member table, and by which column */
%let TABLE=sashelp.cars;
%let COLUMN=origin;
 
proc sql noprint;
/* build a mini program for each value */
/* create a table with valid chars from data value */
select distinct 
   cat("DATA out_",compress(&COLUMN.,,'kad'),
   "; set &TABLE.(where=(&COLUMN.='", &COLUMN.,
   "')); run;") into :allsteps separated by ';' 
  from &TABLE.;
quit;
 
/* macro that includes the program we just generated */
%macro runSteps;
 &allsteps.;
%mend;
 
/* and...run the macro when ready */
%runSteps;
