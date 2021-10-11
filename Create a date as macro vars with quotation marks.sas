data _null_;
 call symput ('dat1',put(intnx('month',TODAY(),-3,'beginning'),date9.));
 call symput ('dat2',put(intnx('month',TODAY(),-1,'end'),date9.));
run;
 
%put &dat1 &dat2 ;
 
data _null_;
 dt1="&dat1";
 dt2="&dat2";
 mm1=substr(dt1,3,3);
 dd1=substr(dt1,1,2);
 yy1=substr(dt1,6,4);
 mm2=substr(dt2,3,3);
 dd2=substr(dt2,1,2);
 yy2=substr(dt2,6,4);

 date1="'"||trim(dd1)||'-'||trim(mm1)||'-'||trim(yy1)||"'";
 date2="'"||trim(dd2)||'-'||trim(mm2)||'-'||trim(yy2)||"'";
 call symput('bmon',trim(date1));
 call symput('emon',trim(date2));
 
 run;
 
 %put &bmon &emon ;
