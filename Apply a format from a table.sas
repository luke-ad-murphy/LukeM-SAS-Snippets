rsubmit;
PROC FORMAT cntlin = asis9.Em_device_format; 
RUN; 

data test;
set live_custs;
device = put(device_desc_modified, $devicef.);
run;
endrsubmit;
