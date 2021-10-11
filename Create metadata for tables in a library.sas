/* Lists all fields of all datasets in a library */
rsubmit;
proc contents data = asis5._all_ out = x;
run;
endrsubmit;
