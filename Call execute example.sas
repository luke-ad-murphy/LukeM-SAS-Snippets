rsubmit;
data _null_;
set ss_1.rlh_no_cell (obs = 10);
call execute(" data b1; set people.ps_rftinst_prod (keep=rbtacctno inst_prod_id);");
call execute(" where rbtacctno ='"||account_desc||"'; run;");
call execute(" proc append data = b1 base=acc force; run;");
call execute(" DM 'log' clear;");
run;

data _null_;
set acc ;
call execute(" data one; set people.ps_rf_inst_prod ;");
call execute(" where inst_prod_id ='"||inst_prod_id||"' and INST_PROD_STATUS = 'INS'; run;");
call execute(" proc append data = one base=all force; run;");
run;
endrsubmit;
