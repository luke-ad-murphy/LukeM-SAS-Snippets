/* EXPORT CODE */ /* THIS MUST NOT BE RUN REMOTELY */
data _null_;
    set  VIEW.Gp0113_lp                               end=EFIEOD;
    %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
    %let _EFIREC_ = 0;     /* clear export record count macro variable */
    file 'Q:\car_data\British Gas Data\Energy Retention\Retention questionaire\raw data\Mail File splits\Elec Conv\Gp0113_lp.csv' delimiter=',' DSD DROPOVER lrecl=32767;
       format Treatment_id $12. ;
       format Creative_id $12. ;
       format Martkey $30. ;
       format Full_name $40. ;
       format Address1 $50. ;
       format Address2 $50. ;
       format Address3 $50. ;
       format Address4 $50. ;
       format Address5 $50. ;
       format Postcode $10. ;
       format Nation $25. ;
       format Elec_pay_meth $20. ;
       format Gas_pay_meth $20. ;
       format Seven_prod_flag_Y_N $7. ;
       format Trans_seg_2003 $3. ;
       format Nationality $15. ;
       format Elec_area $10. ;
       format Consent_status $25. ;
       format Gas_ref_num $15. ;
       format Cu1_prod_ref $12. ;
       format Telephone $15. ;
       format Gas_Num_Promp_Pay $2. ;
       format Gas_Num_Standard_Pay $2. ;
       format Gas_Num_Late_Pay $2. ;
       format Gas_Num_Unknown_Pay $2. ;
       format Gas_tgb_last_qtr_days $25. ;
       format Occam_record_id $25. ;
       format Gas_account_ref $15. ;
       format Cu1_product_ref $12. ;
       format file $30. ;
       format Promptness $30. ;
    if _n_ = 1 then        /* write column names */
     do;
       put
       'Treatment_id'
       ','
       'Creative_id'
       ','
       'Martkey'
       ','
       'Full_name'
       ','
       'Address1'
       ','
       'Address2'
       ','
       'Address3'
       ','
       'Address4'
       ','
       'Address5'
       ','
       'Postcode'
       ','
       'Nation'
       ','
       'Elec_pay_meth'
       ','
       'Gas_pay_meth'
       ','
       'Seven_prod_flag_Y_N'
       ','
       'Trans_seg_2003'
       ','
       'Nationality'
       ','
       'Elec_area'
       ','
       'Consent_status'
       ','
       'Gas_ref_num'
       ','
       'Cu1_prod_ref'
       ','
       'Telephone'
       ','
       'Gas_Num_Promp_Pay'
       ','
       'Gas_Num_Standard_Pay'
       ','
       'Gas_Num_Late_Pay'
       ','
       'Gas_Num_Unknown_Pay'
       ','
       'Gas_tgb_last_qtr_days'
       ','
       'Occam_record_id'
       ','
       'Gas_account_ref'
       ','
       'Cu1_product_ref'
       ','
       'file'
       ','
       'Promptness'
       ;
     end;
     do;
       EFIOUT + 1;
       put Treatment_id $ @;
       put Creative_id $ @;
       put Martkey $ @;
       put Full_name $ @;
       put Address1 $ @;
       put Address2 $ @;
       put Address3 $ @;
       put Address4 $ @;
       put Address5 $ @;
       put Postcode $ @;
       put Nation $ @;
       put Elec_pay_meth $ @;
       put Gas_pay_meth $ @;
       put Seven_prod_flag_Y_N $ @;
       put Trans_seg_2003 $ @;
       put Nationality $ @;
       put Elec_area $ @;
       put Consent_status $ @;
       put Gas_ref_num $ @;
       put Cu1_prod_ref $ @;
       put Telephone $ @;
       put Gas_Num_Promp_Pay $ @;
       put Gas_Num_Standard_Pay $ @;
       put Gas_Num_Late_Pay $ @;
       put Gas_Num_Unknown_Pay $ @;
       put Gas_tgb_last_qtr_days $ @;
       put Occam_record_id $ @;
       put Gas_account_ref $ @;
       put Cu1_product_ref $ @;
       put file $ @;
       put Promptness $ ;
       ;
     end;
    if _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */
    If EFIEOD then
       call symput('_EFIREC_',EFIOUT);
    run;
