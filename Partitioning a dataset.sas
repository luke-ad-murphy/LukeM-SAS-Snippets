libname spdelib spde '/var/opt/analysis_1' datapath=('/var/opt/analysis_1' '/var/opt/analysis_2') partsize=16;

data spdelib.test;

set margin.finance_inbound_data_200910;

run;
