DATA sa_1.em_payg_janon;
set adm.odh_ppy012_summary (keep=adc_active_date
adc_msisdn adc_account_number crm_imei crm_handset_desc imei_dealer_code adc_customer_node_id 
sasdatefmt=(adc_active_date='date9.')
where=(adc_active_date>='01jan2007'd));
run;
