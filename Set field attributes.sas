rsubmit;
data repairs;
attrib 
RBTACCTNO length = $11.;
set repairs;
format RBTACCTNO $11.;
where newdate ne .;
run;
endrsubmit;
