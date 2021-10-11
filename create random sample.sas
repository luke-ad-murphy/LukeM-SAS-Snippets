rsubmit;
libname lapse '\\gbhitopsser0130\sasdata_user\user\luke\interim 2002\lapsing model';
endrsubmit;
libname lapse 'p:\user\luke\interim 2002\lapsing model';


/* CREATE SAMPLE */

rsubmit;
%let prof=lapse.profilelapse2;

*proc freq data=&prof.;
*tables active;
*run;

data active;
	set &prof.;
	where active=1;
run;

data lapse;
	set &prof.;
	where active=0;
run;

/* Produce a sample of 1 in 277 so sample is approx 10000 for actives*/
rsubmit;

data sampleac;
	set active (obs=2771371);	/*obs is number of records in the dataset*/
	by custid;
	retain _rand;
	if first.custid then _rand=ranuni(0);
	/* Generate a random number the first time the pcnumber is encountered */
	/* The retain statement will carry this value forward until the next pcnumber */

	if _rand<0.00360839268838606;	/* Value = 1 / X */
	/* Output 1 in 277 pcnumbers - above figure calculated in excel*/
	/* Datastep keeps going until the end of the input data is reached */
run;

/* Produce a sample of 1 in 54 so sample is approx 10000 for lapsers*/

data samplela;
	set lapse (obs=539514); 
	by custid;
	retain _rand;
	if first.custid then _rand=ranuni(0);
	if _rand<0.0185352001986973;	/* Value = 1 / X */
	/* Output 1 in 54 pcnumbers - above figure calculated in excel*/
	/* Datastep keeps going until the end of the input data is reached */
run;

data lapse.sample;
	set sampleac
	    samplela;
run;

proc freq data=lapse.sample;
tables active;
run;

endrsubmit;


/* CREATE SAMPLE TWO - TO ENSURE MODEL CHOSEN NOT INFLUENCED BY SAMPLE */

rsubmit;

data sampleac2;
	set active (obs=2771371);	
	by custid;
	retain _rand;
	if first.custid then _rand=ranuni(0);
	if _rand<0.00360839268838606;	
run;

data samplela2;
	set lapse (obs=539514); 
	by custid;
	retain _rand;
	if first.custid then _rand=ranuni(0);
	if _rand<0.0185352001986973;	
run;

data lapse.sample2;
	set sampleac2
	    samplela2;
run;

proc freq data=lapse.sample2;
tables active;
run;

endrsubmit;
