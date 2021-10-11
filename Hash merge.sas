data All_usage_tst_ (rename=(duration=billed_duration));
      if 0 then set sasload.em_rev_report_tst; /* (in =b) */
      declare hash hh_pat(dataset:"sasload.em_rev_report_tst");
 rc=hh_pat.defineKey("allocation_id2");
 rc=hh_pat.defineData("ALLOCATION_BASE","CHAN","CHAN_METHOD","FOC_END_DATE","SERIAL_NO","SERVICE_ID","charge_category_code_ch","foc_desc","voucher_type_id2");
 rc=hh_pat.defineDone();
 do until(eof);
 set sasload.em_usage_tst_ngn end=eof; /* (in =a) */
 rc=hh_pat.find();
 output;
 end;
 stop; 
 run;
