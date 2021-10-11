data test;
  msisdn='447782324987';
run;

filename dir ftp 'xx.csv' cd='/reception/msisdn_no_group'
         user='scmuk' pass='uksop44' host='172.30.189.33'
         recfm=v ;

ods csv file = dir trantab=ascii;

proc print data=test;
run;

ods csv close;
ods listing;
quit;
