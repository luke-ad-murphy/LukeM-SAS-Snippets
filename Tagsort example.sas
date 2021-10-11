proc sort tagsort data = sasload.za_postpay_&startd.; 
by PRODUCT_ID CHARGE_USAGE_CODES SERVICE_ID EVENT_SUB_TYPE_CODE IN_BUNDLE; 
run;
