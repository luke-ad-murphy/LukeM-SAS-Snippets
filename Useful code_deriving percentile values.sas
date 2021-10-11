*In order to derive deciles or percentiles based on a value field (i.e. revenue), the program below creates an output
which tells you the parameter values for each of your percentiles as specified;

proc univariate data = vg.example;
var revenue;
output out = test pctlpre=P_ pctlpts = 0 to 100 by 10; *in this example the pctlpre bit determines that the output
field will be called P_, the second part dictates that the start and end values are 0 and 100 respectively and that the
increment will be 10 (ie this will determine decile values, by using 1 as an increment you will derive centile values);
run;

*THE SAS HELP option has info on this, just put in a search for 'univariate percentile' and look at the OUTPUT statement
option;