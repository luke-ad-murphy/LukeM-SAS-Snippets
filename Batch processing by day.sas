/*===============================================================================';
                         Program Information';
 '-------------------------------------------------------------------------------';
 Project Number			: 0780
 Program                : International calling/texting activity
 Brief Description      : Extract & format all international calls for a month
 Requested by			: 
 Copied From            : 
 Datasets Used 			: 
 Output Datasets Created: 
 Output Files           : 
 Notes / Assumptions    : 
 '-------------------------------------------------------------------------------';
 '                             Programmer Information';
 '-------------------------------------------------------------------------------';
 Author                 : Luke Murphy (Luke.Murphy@three.co.uk)
 Department				: Advanced Analytics
 Creation Date          : 07/01/2009
 '-------------------------------------------------------------------------------';
 '                            Environment Information';
 '-------------------------------------------------------------------------------';
 SAS Version            : 9.1                                                     
 Operating System       : XP_PRO   
 '-------------------------------------------------------------------------------';
 '                           Change Control Information';
 '-------------------------------------------------------------------------------';
 Modifications:';
 Programmer/Date:       Reason:
 --------------------------------------------------------------------------------';
 
 ================================================================================*/


%adc;
%revmart;


******************************************************************************;
*********************** C - O - N - T - E - N - T - S ************************;
******************************************************************************;


* A - EXTRACT INTERNATIONAL USAGE DATA FOR DEC 08

* B - APPEND THE FILES TOGETHER INTO ONE MONTH

* C - FORMAT FILE AND STORE IN PERMANENT LOCATION

* D - MERGE DETAILS FROM CUSTOMER MAIN


******************************************************************************;
******************************************************************************;
******************************************************************************;

**************************************************;
* A - EXTRACT INTERNATIONAL USAGE DATA FOR DEC 08 ;
**************************************************;


/* Macro for extracting internatioanl usage in batches (by day approximately) */
%macro inv(bat=);
  %syslput bat = &bat.;
    %put &bat.;
      rsubmit; 
proc sql;
connect to oracle(user=query_adc pw=xgl29v path=BIL1P01);
  create table international_&bat. as 
    select * from connection to oracle
     (select                    
A_PARTY_ID,                            
A_PARTY_NETWORK_ID,         
A_PARTY_ROUTE,                                         
B_PARTY_ID,                 
B_PARTY_LOCATION_CODE,                  
B_PARTY_NETWORK_ID,          
B_PARTY_ROUTE,                               
CHARGE,                     
CHARGE_START_DATE,                         
DURATION,
volume, 
EVENT_SUB_TYPE_CODE,         
EVENT_TYPE_CODE                
from normalised_event PARTITION (NORMALISED_EVENT_P&bat.) 
		  where event_type_Code in (
'100000', /* Voice - int */
'600060', /* NR Voice - Int */
'220000', /* Voice - Roaming */
'100040', /* SMS - International */
'600130', /* SMS - IntrRoaming */
'600150', /* SMS - IntrRoaming non EU */
'600170', /* Voice - CKC */
'600171') /* NR Voice - CKC */
);
quit;
endrsubmit;
%mend;  



/* Use above macro to extract data for dec */
%macro driver;
  %do i = 2141 %to 2175;
      %inv(bat = &i.);
  %end;
%mend;
%driver;   



******************************************************************************;
******************************************************************************;
******************************************************************************;


***********************************************;
* B - APPEND THE FILES TOGETHER INTO ONE MONTH ;
***********************************************;

rsubmit;
data all_int;
set
international_2141
international_2142
international_2143
international_2144
international_2145
international_2146
international_2147
international_2148
international_2149
international_2150
international_2151
international_2152
international_2153
international_2154
international_2155
international_2156
international_2157
international_2158
international_2159
international_2160
international_2161
international_2162
international_2163
international_2164
international_2165
international_2166
international_2167
international_2168
international_2169
international_2170
international_2171
international_2172
international_2173
international_2174
international_2175
;

where charge_start_date ge '01DEC2008:00:00:00'dt and
      charge_start_date le '31DEC2008:00:00:00'dt;
run;
endrsubmit;


******************************************************************************;
******************************************************************************;
******************************************************************************;


**************************************************;
* C - FORMAT FILE AND STORE IN PERMANENT LOCATION ;
**************************************************;

%adc;

/* Create list of countries with reference codes */
rsubmit;
data countries;
  set adc.reference_code;
     where REFERENCE_TYPE_ID = 4100044;
run;
endrsubmit;

/* Create format for country names */
rsubmit;
proc sort data = countries out = countries nodupkey;
   by reference_code;
run;

DATA countries2 (keep=fmtname start label );
  LENGTH start LABEL $ 30;
  	SET countries (keep= reference_code abbreviation)  end=end;
	 if charge_usage_codes= '*' then delete;
	 FMTNAME="$coun";    *character or numeric;
	 START= trim(left(reference_code));
	 LABEL= abbreviation;
	 output;
     if end then do;
	 START= 'other';
	 LABEL= '';
	 output;
	 end;
RUN; 

PROC FORMAT cntlin = countries2;
quit;
endrsubmit;



/* Create list of network names with reference codes */
rsubmit;
data x;
  set adc.reference_code;
     where REFERENCE_TYPE_ID = 4100130;
run;
endrsubmit;

/* Create format for network names */
rsubmit;
proc sort data = x out = lk3 nodupkey;
   by REFERENCE_CODE;
run;

DATA lookup3 (keep = fmtname start label);
  LENGTH start LABEL $ 30;
  	SET lk3 (keep = reference_code CODE_LABEL)  end=end;
	 if charge_usage_codes= '*' then delete;
	 FMTNAME = "$type";    *character or numeric;
	 START = trim(left(reference_code));
	 LABEL = CODE_LABEL;
	 output;
     if end then do;
	 START = 'other';
	 LABEL = '';
	 output;
	 end;
RUN; 

PROC FORMAT cntlin = lookup3 ;
quit;
endrsubmit;



/* Create list of event types */
rsubmit;
data events;
 set adm.dim_event_type (keep=EVENT_SUBTYPE_CODE EVENT_SUBTYPE_name);
run;
endrsubmit;

/* Create format for event types */
rsubmit;
proc sort data = events out = events nodupkey;
   by EVENT_SUBTYPE_CODE;
run;

DATA events2 (keep=fmtname start label );
  LENGTH LABEL $ 30;
  	SET events   end=end;
	 FMTNAME="subt";   
	 START= EVENT_SUBTYPE_CODE;
	 LABEL= EVENT_SUBTYPE_name;
RUN; 

PROC FORMAT cntlin = events2;
quit;
endrsubmit;



/* Create final dataset and apply formats for country and event types */
rsubmit;
data asis5.international_all_dec08 (compress=yes keep=msisdn_a a_party_network_id a_party_route
                                            msisdn_b event_type_code event_sub_type_code
                                           duration volume date flag2 flag charge country_from
											country_to network_from network_to ACTION);
  set all_int ;

       date = datepart(charge_start_date);
	   COUNTRY_FROM = put(A_PARTY_ROUTE, $coun.);
       COUNTRY_TO = put(B_PARTY_ROUTE, $coun.);
	   NETWORK_FROM = put(A_PARTY_NETWORK_ID,type.);
	   NETWORK_TO = put(B_PARTY_NETWORK_ID,type.);
	   ACTION = put(EVENT_SUB_TYPE_CODE,subt.) ;

       msisdn_a = substr(a_party_id,3);
       msisdn_b = substr(b_party_id,3);


	   if upcase(ACTION) =:'INT' then flag='IN';else
	   if upcase(ACTION) =:'MT' or upcase(ACTION) =:'RLH MT'  then flag='IR';else
	   if upcase(ACTION) =:'ROAM' or upcase(ACTION)=:'SATELLITE' or
          upcase(ACTION) =:'RLH' then flag='OR';else
	   flag='UN';

        /*change here*/

	   if event_type_code in ('100000','600060','220000','600170','600171') 
                              then flag2 = 'voi'; else
	   if event_type_code in ('100040','600130','600150') then flag2 = 'sms'; else
	   if event_type_code in ('600163', '600000', '100010', '600120', '220010') 
                              then flag2 = 'dat';
run;
endrsubmit;


rsubmit;
proc freq data = asis5.international_all_dec08; table ACTION; run;
endrsubmit;


******************************************************************************;
******************************************************************************;
******************************************************************************;


***************************************;
* D - MERGE DETAILS FROM CUSTOMER MAIN ;
***************************************;

/* Create urn to get back to unique records */
rsubmit;
data asis5.international_all_dec08;
set asis5.international_all_dec08;
urn = _n_;
run;
endrsubmit;


/* Merge details from customer main */
rsubmit;
proc sql;
create table international_all_dec08 as
select a.*,
	   b.account_desc,
	   b.price_plan_desc,
	   b.postacct,
	   b.date_became_customer
from asis5.International_all_dec08 as a 
	 left join 
	 asis9.Customer_main_em as b
on a.msisdn_a = b.msisdn;
quit;
endrsubmit;


/* Get back to original number of records */
rsubmit;
proc sort data = international_all_dec08 nodupkey out = asis5.international_all_dec08;
by urn;
run;
endrsubmit;



/* Merge in business account info */
rsubmit;
proc sql;
create table asis5.international_all_dec08 as
select a.*, 
	   b.INDUSTRY_TYPE
from asis5.international_all_dec08 as a
	 left join 
	 asis9.Business_main_kb as b
on a.account_desc = b.account_desc;
quit;

proc freq data = asis5.international_all_dec08; table INDUSTRY_TYPE; run;
endrsubmit;


*********************************XXXXXXXX********************************;
******************************XXXXXXXXXXXXXX*****************************;
*************************************************************************;
***********************  E-N-D  O-F  P-R-O-G-R-A-M **********************;
*************************************************************************;
******************************XXXXXXXXXXXXXX*****************************;
*********************************XXXXXXXX********************************;
