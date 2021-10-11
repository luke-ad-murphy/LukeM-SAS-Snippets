/* This is useful if you've tried linear relationships to the target (e.g. corelation measures)
but nothing came up.  There might exist a non-linear relationship that you can work out by
deciling and re-ordering.  Simple example would be age versus the speend you can run - would
be an inversed U shape when plotted (very young and very old people will move more slowly!) */


/*****************************************************************************************/

/***** Step 1 - set up macro names of file and target *****/


%let model_set = model_router; /* Name of data set that includes input vars and target */
%let target = churn; 	/* Name of target variable (binary only) in above dataset */
%let ptiles = 5;		/* Number of percentiles you want to create for each numeric var */


/*****************************************************************************************/

/***** Step 2 - Get a count of how many numeric vars i have as potential inputs *****/


/* Get list of numeric vars in your dataset */
proc contents data = &model_set. (drop = &target.)  /* dropping target variable */
out = nums (keep = name type where = (type = 1)); 
run;

data nums;
set nums ;
var = _n_;
NAME = left(trim(NAME));
run;

* how many vars have I got?;
proc sort data = nums; by descending var; run;
data _null_;
set nums (obs = 1);
call symput('max', var);
run;


/*****************************************************************************************/

/***** Step 3 - Create percentiles of each var against the target var *****/

%macro inv(var = );
data xxxxxx;
set nums;
where var = &var.;
call symput('name', name);
run;

proc rank data = &model_set. out = &model_set. groups = &ptiles.;
var &name.;
ranks R_&name.;
run;
%mend inv;  


%macro driver;
  %do i = 1 %to &max.;
      %inv(var = &i.);
  %end;
%mend;
%driver;   


***********************************XXXXXXXX**********************************;
********************************XXXXXXXXXXXXXX*******************************;
*****************************************************************************;
*************************  E-N-D  O-F  P-R-O-G-R-A-M ************************;
*****************************************************************************;
********************************XXXXXXXXXXXXXX*******************************;
***********************************XXXXXXXX**********************************;