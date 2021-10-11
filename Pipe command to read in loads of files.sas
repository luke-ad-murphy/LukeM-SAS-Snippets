filename indata pipe 'ls -1 /var/opt/analysis_4/asis1/Campaign_history/*.csv';

data one;
  infile indata truncover ;
  length fil2read  $100;
  input fil2read $;
  infile dummy 
  filevar = fil2read 
  end = done 
  dsd dlm = ',' 
  missover firstobs = 2;
  length account_desc $11. Camp_code $6. Date $10. cell_id $1.;
  do while (not done);
    file = fil2read;
    input account_desc $ 
          Camp_code $ 
          Date $
		  cell_id $
;
    output;
  end;  
run;
