data _null_;
set  rm_1.day5_eml2  ;
   
file "/var/opt/analysis_4/campaigns/automated_jobs/vic/OUTPUT/VM_0152_ContWelc_EML_&stamp" delimiter=',' ;

if _n_ = 1 then do;
      put 'account_no'  ','  'title1'  ','  'fore'  ','  'sur'  ',' 
           'primary_email'  ','  'msisdn'  ','  'price_plan_desc'  ','  'device_name' ;
end;
else
do;
    put account_no $ 
       title1 $ 
       fore $      
       sur $ 
    primary_email $ 
     msisdn $ 
   price_plan_desc $ 
   device_name $ ;
end;
run;
