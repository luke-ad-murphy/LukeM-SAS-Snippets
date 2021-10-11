rsubmit;
data Lm_device_type (drop = label fmtname rename = (START = Device));
set Asis9.Em_device_format;
if Start = '' then delete;
run;
endrsubmit;

rsubmit;
data Lm_device_type (keep = DEVICE Type);
set Lm_device_type;

format type $8.;

SIMF1 = INDEX(Device,'SIM PACK');
SIMF2 = INDEX(Device,'SIM ONLY');
MBB1 = INDEX(Device,'E220');
MBB2 = INDEX(Device,'MF622');
DC1 = INDEX(Device,'DATA');

IF SIMF1 NE 0 OR SIMF2 NE 0 then Type = 'SIM ONLY';
ELSE IF MBB1 NE 0 OR MBB2 NE 0 THEN Type = 'DONGLE';
ELSE IF DC1 NE 0 THEN Type = 'DATACARD';
ELSE Type = 'HANDSET';

run;

proc freq data = Lm_device_type; table DEVICE * Type; run;
endrsubmit;


rsubmit;
DATA Asis9.Lm_device_type_format (keep = fmtname start label ); 
LENGTH LABEL $8.; 
SET Lm_device_type; 
FMTNAME = "$devtype"; 
START = DEVICE; 
LABEL = type; 
RUN;
endrsubmit;
