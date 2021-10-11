data _null_; 
  curtime = put(time(), time.);
  curdate = put(date(), date.); 
  put "Started: " curdate curtime ; 
run; 
