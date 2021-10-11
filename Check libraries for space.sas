
filename du pipe 'du -k /var/opt/sas/sas_working';
filename df pipe 'df -g /var/opt/sas/sas_working';
filename lsu pipe 'ls -trl /var/opt/sas/sas_working';

filename dus pipe 'du -k /var/opt/analysis_10';
filename dfu pipe 'df -k /var/opt/analysis_13';*margin*;
filename lsu pipe 'ls -trl /var/opt/analysis_10/';*utility*;

filename lsz pipe 'ls -trl /var/opt/analysis_13/';
filename dfu5 pipe 'df -k /var/opt/analysis_5'; *asis5, 39G*;
filename dfu5 pipe 'df -k /var/opt/analysis_1'; *mc_1, 37G*;
filename dfu5 pipe 'df -k /var/opt/analysis_2'; *mc_2, 30G*;
filename dfu5 pipe 'df -k /var/opt/analysis_9'; *asis9, 30G*;
filename dfu5 pipe 'df -k /var/opt/analysis_12'; *sa_1, 44G*;
filename dfu5 pipe 'df -k /var/opt/analysis_6'; *ts_1, 8G*;
filename dfu5 pipe 'df -k /var/opt/analysis_3'; *kf_1, 8G*;

rsubmit;
filename dfu5 pipe 'df -k /var/opt/analysis_11'; *rm_1, 8G*;
filename dfu5 pipe 'df -k /var/opt/sas/sas_working';
filename dfu5 pipe 'df -k /var/opt/analysis_10'; *utility, 100G*;

rsubmit;
*space avail utility area;
data _null_;
length line $500;
infile dfu5;
input line;
put _infile_;
run;

*saswork disk space available;
data _null_;
length line $500;
infile df;
input line;
put _infile_;
run;
*saswork folder usage;
data _null_;
length line $500;
infile dus;
input line;
put _infile_;
run;

*directory usage utility area;
data _null_;
length line $500;
infile dus;
input line;
put _infile_;
run;



%macro check(infil= );
data _null_;
length line $500;
infile &infil;
input line;
put _infile_;
run;
%mend;
%check(infil=lsu);
%check(infil=lsz);
%check(infil=du);
%check(infil=dfu5);
filename lsu2 pipe 'ls -trl /var/opt/analysis_10/SAS_util00010000741E_sasph002';
%check(infil=lsu2);

*clear out directories;
x 'rm /var/opt/analysis_10/SAS_util0001000048A2_sasph002/*.*';
x 'rm /var/opt/analysis_10/SAS_util000100001A96_sasph002/*.*';
x 'rm /var/opt/sas/sas_working/upload_test.sas';

*check space again;
%check(infil=dfu);

proc options;run;

x kill -9 26124;

rsubmit;
libname Margin2 '/var/opt/analysis_13' compress=yes;
endrsubmit;
libname Margin2 server=sasnode.unxspawn slibref=Margin2;
rsubmit;
libname ppayusg '/var/opt/sas/sas_working';
endrsubmit;
libname ppayusg server=sasnode.unxspawn;


proc contents data=sa_1.all_usage_type;
run;

proc print data=ppayusg.all_usage_type_v;
where service_id=20497131;
run;

proc print data=sa_1.all_usage_type;
where service_id=20497131;
run;

proc contents data=ppayusg.usg_summary200803;
run;

proc datasets library=margin2;
repair all_usage_type;
run;

proc datasets library=ppayusg;
delete fin3;
run;

proc datasets library=margin2;
delete all_usage_type;
run;

x rm /var/opt/analysis_13/all_usage_type.sas7bdat;
x rm /var/opt/sas/sas_working/Usg_summary200805.sas7bdat;
x gzip /var/opt/analysis_9/customer_main_sep07.sas7bdat;



libname kf_1 '/var/opt/analysis_3'  compress=yes;

proc datasets library=kf_1;
run;
