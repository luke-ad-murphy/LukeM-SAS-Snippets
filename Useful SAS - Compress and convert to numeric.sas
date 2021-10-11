
*Compress + signs out of a file;
data test;
set dd.test; 
trevL12 = compress(totrollrevL12,'+'); *to compress + out of them;
run;

* and format the resultant field to numeric;

data dd.test;
set test; 
format trollrevL12 8.; 
trollrevL12 = trevL12;
run;