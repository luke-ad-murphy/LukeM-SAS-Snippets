proc export data=rwork.ce_final
  outfile = "&path."
  dbms = csv REPLACE;
run;
