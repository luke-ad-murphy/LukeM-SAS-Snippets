libname kf_1 '/var/opt/analysis_3'  compress=yes;


data kf_1.lm_test2;
z = "Test file";
run;


 x chmod 777 /var/opt/analysis_3/lm_test2.sas7bdat;