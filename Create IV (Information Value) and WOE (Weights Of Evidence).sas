https://www.observeupdate.com/article/sas-code-for-iv-woe/           ;


/*Information value and Weight of Evidence Calculator Sean O'Connor 2013 
/*Instructions*

The below calculates the Weight of Evidence and Information Value for any table in the work library 
called 'inputdata' with a binary target variable called 'target'. 
The only conditions are that this dataset should not include a variable called 'n',and that there is no 
other tables called '_tempdata', 'IV_Table' or 'WOE_Table', or at least ones you don't mind being over 
written. The IV and WOE values are output to the tables 'IV_Table' or 'WOE_Table' respectively.*/




/************//* 1.Sample data *//***************/

/* CHANGE THIS BIT TO CREATE 'inputdata' temp dataset and rename target to 'target' */
data inputdata (keep = target home timing2 grp_type);
set kf_1.lm_1734_mod_test;
rename so = target;
run;


/********************************************************************************************************/


/***********//* 2.Transpose Statistics to one column *//*******/
/*Transpose as the categories to one variable to make further reshaping easier*/ 
/*Create unique ID for transposition*/
data _tempdata;
set inputdata;
n = _n_;
run; 

/*Sort the data for transposition*/
proc sort data = _tempdata; by target n; run; 

/*Transpose as the categories to one column*/
proc transpose data = _tempdata out = _tempdata;
by target n;
var _character_ _numeric_;
run; 


/********************************************************************************************************/


/***********//* 3.Calculate Frequencies *//*********/
/*Sort the data so frequncies can be done by variable*/
proc sort data = _tempdata out = _tempdata; by _name_ target; run;

/*Calculate frequencies for each variable and target group*/
proc freq data = _tempdata;
by _name_ target;
tables col1 /out = _tempdata;
run; 


/********************************************************************************************************/


/**********//* 4.Events And Non-Events to one row For each attribute *//*******/
proc sort data = _tempdata; by _name_ col1; run;

/*Transpose the data so the good and bad relative frequencies are on one row*/
proc transpose data = _tempdata out = _tempdata;
by _name_ col1;
id target;
var percent;
run; 


/********************************************************************************************************/


/********//* 5.calculate the IV and WOE *//*******/

/*Calculate the IV and WOE*/
data IV_Table(keep=variable IV) WOE_Table(keep=variable attribute woe);
*output a table each for IV and WOE;
set _tempdata;
by _name_; 
rename col1=attribute _name_=variable;
'0'n=sum('0'n,0)/100;
*Convert to percent and convert null to zero;'1'n=sum('1'n,0)/100; 
*Convert to percent and convert null to zero; 

/*Calculate WOE*/
woe=log('0'n/'1'n)*100;

output WOE_Table;*Output WOE; 

/*Calculate IV*/if '1'n ne 0 and '0'n ne 0 then do; 
*IF statement to handle divide-by-zero and log-of-zero errors;
raw=('0'n-'1'n)*log('0'n/'1'n); 
*IV calculation, ;
end
;else raw=0; 
IV+sum(raw,0);
*Culmulativly add to IV, set null to zero; 
if last._name_ then do; 


*only _tempdata the last final row;
output IV_table;
IV=0;
end; 
where upcase(_name_) ^='TARGET' and upcase(_name_) ^= 'N';
/*Remove the target and the row number from the list of predictors*/
run; 


/********************************************************************************************************/

/********//* 6. Output Data *//********/

/*Sort by most predictive variable to least*/
proc sort data = IV_table; by descending IV; run; 

/*Output IV listing*/
title1 "IV Listing";
proc print data = IV_table; run; 

/*sort attribute and weight of evidence*/
proc sort data = woe_table; by variable WOE; run; 

/*Output the WOE table*/
title1 "WOE Listing";
proc print data = WOE_Table;run; 



- See more at: https://www.observeupdate.com/article/sas-code-for-iv-woe/#sthash.4b0URQiN.dpuf     ;



***********************************XXXXXXXX**********************************;
********************************XXXXXXXXXXXXXX*******************************;
*****************************************************************************;
*************************  E-N-D  O-F  P-R-O-G-R-A-M ************************;
*****************************************************************************;
********************************XXXXXXXXXXXXXX*******************************;
***********************************XXXXXXXX**********************************;