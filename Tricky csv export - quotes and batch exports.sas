libname asis5 meta library = "asis5" metaout = data;



/* Split files into groups for interaction notes */
data group1 (keep = MSISDN notes) 
	 group2 (keep = MSISDN notes) 
	 group3 (keep = MSISDN notes) 
	 group4 (keep = MSISDN notes);
set asis5.lm_1147_analysis_3mth_3 (keep = MSISDN account_desc group sub);
WHERE msisdn NE '';

format fin $1.;
fin = group;

format notes $300.;
if sub = "A" then notes = 'SMS sent out between 12th and 17th March 2010: From 3: On 24 Mar some of our prices are going up including 090 091 098 calls and 070 numbers. Find out more @ http://xxx. three.co.uk/comms/xxxxxx Group'||fin||'"';
if sub = "B" then notes = 'SMS sent out between 12th and 17th March 2010: From 3: On 24 Mar some of our prices are going up including calls to 084 & 087 numbers. Find out more @ http://xxx. three.co.uk/comms/xxxxxx Group'||fin||'"';
if sub = "C" then notes = 'SMS sent out between 12th and 17th March 2010: From 3: On 24 Mar some of our prices are going up including making international calls. Find out more @ http://xxx. three.co.uk/comms/xxxxxx Group'||fin||'"';
if sub = "D" then notes = 'SMS sent out between 12th and 17th March 2010: From 3: On 24 Mar some of our prices are going up including making international calls. Find out more @ http://xxx. three.co.uk/comms/xxxxxx Group'||fin||'"';
if sub = "E" then notes = 'SMS sent out between 12th and 17th March 2010: From 3: On 24 Mar some of our prices are going up including answering calls when youre abroad. Find out more @ http://xxx. three.co.uk/comms/xxxxxx Group'||fin||'"';

notes = '"'||notes||'"';

if group = 1 then output group1;
else if group = 2 then output group2;
else if group = 3 then output group3;
else if group = 4 then output group4;
run;

proc export data = group2
outfile = '/var/opt/analysis_4/asis1/OOB camp/group2.CSV' dbms=csv replace;run;
proc export data = group3
outfile = '/var/opt/analysis_4/asis1/OOB camp/group3.CSV' dbms=csv replace;run;
proc export data = group4
outfile = '/var/opt/analysis_4/asis1/OOB camp/group4.CSV' dbms=csv replace;run;



/* Split group 1 into smaller 20k chunks */
/* Macro to split file into specified number of variables */
%macro split1(num);
data _null_;
if 0 then set orig nobs=count;
call symput('numobs',put(count,8.));
run;

%let m=%sysevalf(&numobs/&num,ceil);

data %do J=1 %to &m ; orig_&J %end;;
set group1;
%do I=1 %to &m;
if %eval(&num*(&i-1)) <_n_ <=
%eval(&num*&I) then output orig_&I;
%end;
run;
%mend split1;


/* Run macro to create multiple splt files */
data orig;
do i = 1 to 1663714; * 1663714 is number of records in the file I want to split;
output;
end;
run;
%split1(20000); * Selects the number of records you want in each file;

proc export data = orig_1
outfile = '/var/opt/analysis_4/asis1/OOB camp/group1_1.CSV' dbms=csv replace;run;




libname asis5 meta library = "asis5" metaout = data;



/* Split files into groups for interaction notes */
data group1 (keep = MSISDN notes) 
	 group2 (keep = MSISDN notes) 
	 group3 (keep = MSISDN notes) 
	 group4 (keep = MSISDN notes);
set asis5.lm_1147_analysis_3mth_3 (keep = MSISDN account_desc group sub);
WHERE msisdn NE '';

format fin $1.;
fin = group;

format notes $300.;
if sub = "A" then notes = 'SMS sent out between 12th and 17th March 2010: From 3: On 24 Mar some of our prices are going up including 090 091 098 calls and 070 numbers. Find out more @ http://xxx. three.co.uk/comms/xxxxxx Group'||fin||'"';
if sub = "B" then notes = 'SMS sent out between 12th and 17th March 2010: From 3: On 24 Mar some of our prices are going up including calls to 084 & 087 numbers. Find out more @ http://xxx. three.co.uk/comms/xxxxxx Group'||fin||'"';
if sub = "C" then notes = 'SMS sent out between 12th and 17th March 2010: From 3: On 24 Mar some of our prices are going up including making international calls. Find out more @ http://xxx. three.co.uk/comms/xxxxxx Group'||fin||'"';
if sub = "D" then notes = 'SMS sent out between 12th and 17th March 2010: From 3: On 24 Mar some of our prices are going up including making international calls. Find out more @ http://xxx. three.co.uk/comms/xxxxxx Group'||fin||'"';
if sub = "E" then notes = 'SMS sent out between 12th and 17th March 2010: From 3: On 24 Mar some of our prices are going up including answering calls when youre abroad. Find out more @ http://xxx. three.co.uk/comms/xxxxxx Group'||fin||'"';

notes = '"'||notes||'"';

if group = 1 then output group1;
else if group = 2 then output group2;
else if group = 3 then output group3;
else if group = 4 then output group4;
run;

proc export data = group2
outfile = '/var/opt/analysis_4/asis1/OOB camp/group2.CSV' dbms=csv replace;run;
proc export data = group3
outfile = '/var/opt/analysis_4/asis1/OOB camp/group3.CSV' dbms=csv replace;run;
proc export data = group4
outfile = '/var/opt/analysis_4/asis1/OOB camp/group4.CSV' dbms=csv replace;run;



/* Split group 1 into smaller 20k chunks */
/* Macro to split file into specified number of variables */
%macro split1(num);
data _null_;
if 0 then set orig nobs=count;
call symput('numobs',put(count,8.));
run;

%let m=%sysevalf(&numobs/&num,ceil);

data %do J=1 %to &m ; orig_&J %end;;
set group1;
%do I=1 %to &m;
if %eval(&num*(&i-1)) <_n_ <=
%eval(&num*&I) then output orig_&I;
%end;
run;
%mend split1;


/* Run macro to create multiple splt files */
data orig;
do i = 1 to 1663714; * 1663714 is number of records in the file I want to split;
output;
end;
run;
%split1(20000); * Selects the number of records you want in each file;




/* Macro for exporting file into csv. */
%macro inv(bat=);
proc export data = orig_&bat.
outfile = "/var/opt/analysis_4/asis1/OOB camp/group1_&bat..csv" dbms=csv replace;run;
%mend;  



/* Use above macro to export all files for group 1 */
%macro driver;
  %do i = 1 %to 84;
      %inv(bat = &i.);
  %end;
%mend;
%driver;   


*********************************XXXXXXXX********************************;
******************************XXXXXXXXXXXXXX*****************************;
*************************************************************************;
***********************  E-N-D  O-F  P-R-O-G-R-A-M **********************;
*************************************************************************;
******************************XXXXXXXXXXXXXX*****************************;
*********************************XXXXXXXX********************************;