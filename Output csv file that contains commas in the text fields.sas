data _null_;
set  Payg_email  ;
   
file "/var/opt/analysis_4/campaigns/automated_jobs/kingsley/OUTPUT/MbbPaygWelc_EML_&stamp";

if _n_ = 1 then do;
	put 'Account_name' ',' 'MSISDN1' ',' 'PRIMARY_EMAIL' ',' 'Title' ','
	'FIRSTNAME'  ',' 'Surname'  ','  'Device'  ',' 'Group'  ','  'DataPackage';
end;
else
do;
    put '"'Account_name'",'
		'"'MSISDN1'",'     
		'"'primary_email'",'     
		'"'Title'",'     
		'"'FIRSTNAME'",'     
		'"'Surname'",'     
		'"'Device'",'     
		'"'Group'",'     
		'"'DataPackage'"';
end;
run;