data dup_282_01;
set sasload.dat_282_01;
where timepart(charge_start_date) GT '18:00:00't;
run;
