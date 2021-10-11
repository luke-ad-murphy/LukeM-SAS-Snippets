proc format;
picture MyDT (default=14) 
low-high='%Y%0m%0d%0H%0M%0S' 
(datatype=DATETIME) ;
run;

data _null_;
x=datetime();
put x MyDT.;
run;