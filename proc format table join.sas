/* FOR JOINS ON A CHARACTER VARIABLE */

* link in customer main data;
DATA custndid (keep = fmtname start label ); 
LENGTH LABEL $20; 
SET add_ons3; 
FMTNAME = "$custndid"; 
START = ACCOUNT_DESC; 
LABEL = "YES"; 
RUN;

proc sort data = custndid nodupkey;	by start; run;

* create a format from the dummy data;
PROC FORMAT cntlin = custndid; 
RUN; 

* bring back records from accounts table where the customer_node_id is matched;
data custid2 (compress = yes); 
set new_tlu1.customers_main1 (keep =  account_desc Portfolio_status 
Price_plan_desc	Age_band_id	DEVICE_DESC_MODIFIED Dealercode Gender_new mosukgrp
mosuktype H1UK_CNTR_START_DT H1UK_CNTR_END_DT CON_LEN SPECIAL_APPLICATION_IND); 
where put((ACCOUNT_DESC),$custndid.) = "YES"; 
run;
* NOTE that account_name is actually account_desc (account_name is a label
and not the variable name);

* append info back onto add-ons table;
proc sort data = add_ons3; by ACCOUNT_DESC; run;
proc sort data = custid2; by ACCOUNT_DESC; run;

data kf_1.add_ons_total (drop = SERVICE_ID);
merge add_ons3 (in = a)
	  custid2 (in = b);
by ACCOUNT_DESC;
if a;
run;


/******************************************************************************************/


/* FOR JOINS ON A NUMERIC VARIABLE */
rsubmit;
DATA accountid (keep = fmtname start label ); 
LENGTH LABEL $20; 
SET account_ids; 
FMTNAME = "acc"; 
START = Current_account_id; 
LABEL = "YES"; 
RUN;

proc sort data = accountid nodupkey; by start; run;

PROC FORMAT cntlin = accountid; 
RUN; 
endrsubmit;


/* Extract usage for selected account_ids from 01/10/07 to 31/3/08 */
rsubmit;
data asis5.Stars_contents;
set Asis9.Allcontent (keep = 
party_account_id
date_id
INVOICE_TEXT_ID
supplier_id
num_events
charge
asset_id);
where date_id ge 2466 and date_id le 3013
AND 
put(party_account_id,acc.) = "YES"; 
run;
endrsubmit;
