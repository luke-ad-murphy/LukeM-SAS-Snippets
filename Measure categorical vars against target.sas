/*****************************************************************************************/


/* This produces a dataset called cat_vars in the work library that gives you the index
of each degree of all categorical variables against your target variable */


/***** Step 1 - set up macro names of file and target *****/


%let model_set = model_router; 	/* Name of data set that includes input vars and target */
%let target = churn; 			/* Name of target variable (binary only and in 1/0 format) in above dataset */


/*****************************************************************************************/

/***** Step 1 - Get a count of how many categorical vars I have as potential inputs *****/


/* Get list of numeric vars in your dataset */
proc contents data = &model_set. 
out = cats (keep = name type where = (type = 2)); 
run;

data cats;
set cats;
NAME = left(trim(NAME));
run;


* dropping ANY categorical vars that you know you don't want to include e.g. account IDs;
data cats;
set cats;
where NAME not IN('imei_number', 'msisdn', 'pcode', 'subchnl', 'new_postcode', 'emplid', 'ban',
'SAMPLE_ELIGIBLE', 'MARKETING_NAME', 'DOB','DEALERNAME', 'DEVICE_TYPE');
var = _n_;
run;


* how many vars have I got?;
proc sort data = cats; by descending var; run;
data _null_;
set cats (obs = 1);
call symput('max', var);
run;


/*****************************************************************************************/

/***** Step 3 - Counts of each categorical entry, for each variable versus target variable *****/

* what's the mean of target rate in the model file?;
* will be used to index against it;
proc summary nway missing data = &model_set.;
class ;
var &target.;
output out = ave_target (drop = _type_);
run;

data _null_;
set ave_target;
where _STAT_ = 'MEAN';
call symput('mean', &target.);
run;


* create shell of file for dumping output into;
data cat_vars;
format variable $50.;
format level $200.;
format '0'n best12.;
format '1'n best12.;
format perc_take_action best12.;
format index_vs_mean best12.;
run;


%macro inv(var = );
/* pull out individual cat var and profile vs target */
data xxxxxx;
set cats;
where var = &var.;
call symput('name', name);
run;

proc summary nway missing data = &model_set.;
class &name. &target.;
var ;
output out = varput (drop = _type_);
run;

proc sort data = varput; by &name.; run;

proc transpose data = varput out = varput (drop = _label_ _name_);
by &name.;
var _freq_;
id &target.;
run;

/* creat percent taking action and index */
data varput (rename = (&name. = level));
set varput;
variable 	 		= left(trim("&name."));
perc_take_action	= '1'n / sum('1'n, '0'n);
index_vs_mean 		= (perc_take_action / &mean.) * 100;
run;

proc sql;
create table varput as
select variable, level, '0'n, '1'n, perc_take_action, index_vs_mean
from varput;
quit;

/* Put all cat var files into one */
proc datasets lib = work nolist;
append base = cat_vars 
data = varput force;
quit;

%mend inv;  


%macro driver;
  %do i = 1 %to &max.;
      %inv(var = &i.);
  %end;
%mend;
%driver;   


/* Sort to highlight points of interest */
proc sort data = cat_vars; by variable descending index_vs_mean; run;


***********************************XXXXXXXX**********************************;
********************************XXXXXXXXXXXXXX*******************************;
*****************************************************************************;
*************************  E-N-D  O-F  P-R-O-G-R-A-M ************************;
*****************************************************************************;
********************************XXXXXXXXXXXXXX*******************************;
***********************************XXXXXXXX**********************************;