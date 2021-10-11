data macs;

date 	= today();
* get start date of previous month;
start 	= intnx('month', date,-1,'beginning');
* get end date of previous month;
end 	= intnx('month', date,-1,'end');

* period variables e.g. 200809;
bmon   = put(intnx('month', date,-1,'beginning'), yymmn6.);
month1 = put(intnx('month', date,-1,'beginning'), yymmn6.);
month2 = put(intnx('month', date,-2,'beginning'), yymmn6.);
month3 = put(intnx('month', date,-3,'beginning'), yymmn6.);

repdate = put(start, date9.);
extractd = "'"||put(start-6, date9.)||"'";

startd 	= put(start, yymmddn8.);
endd 	= put(end, yymmddn8.);

st 			= put(start, date9.);
end_dt_1 	= put(start+4, date9.);

st_dt_2 	= put(start+5, date9.);
end_dt_2 	= put(start+9, date9.);

st_dt_3		= put(start+10, date9.);
end_dt_3	= put(start+14, date9.);

st_dt_4		= put(start+15, date9.);
end_dt_4	= put(start+19, date9.);

st_dt_5		= put(start+20, date9.);
end_dt_5	= put(start+24, date9.);

st_dt_6		= put(start+25, date9.);
ed			= put(end, date9.);


dis_st_dt_1  	= "'"||substr(st,1,2)||"-"||substr(st,3,3)||"-"||substr(st,6,4)||"'";
dis_end_dt_1 	= "'"||substr(end_dt_1,1,2)||"-"||substr(end_dt_1,3,3)||"-"||substr(end_dt_1,6,4)||"'";

dis_st_dt_2  	= "'"||substr(st_dt_2,1,2)||"-"||substr(st_dt_2,3,3)||"-"||substr(st_dt_2,6,4)||"'";
dis_end_dt_2 	= "'"||substr(end_dt_2,1,2)||"-"||substr(end_dt_2,3,3)||"-"||substr(end_dt_2,6,4)||"'";

dis_st_dt_3		= "'"||substr(st_dt_3,1,2)||"-"||substr(st_dt_3,3,3)||"-"||substr(st_dt_3,6,4)||"'";
dis_end_dt_3 	= "'"||substr(end_dt_3,1,2)||"-"||substr(end_dt_3,3,3)||"-"||substr(end_dt_3,6,4)||"'";

dis_st_dt_4 	= "'"||substr(st_dt_4,1,2)||"-"||substr(st_dt_4,3,3)||"-"||substr(st_dt_4,6,4)||"'";
dis_end_dt_4 	= "'"||substr(end_dt_4,1,2)||"-"||substr(end_dt_4,3,3)||"-"||substr(end_dt_4,6,4)||"'";

dis_st_dt_5 	= "'"||substr(st_dt_5,1,2)||"-"||substr(st_dt_5,3,3)||"-"||substr(st_dt_5,6,4)||"'";
dis_end_dt_5	= "'"||substr(end_dt_5,1,2)||"-"||substr(end_dt_5,3,3)||"-"||substr(end_dt_5,6,4)||"'";

dis_st_dt_6		= "'"||substr(st_dt_6,1,2)||"-"||substr(st_dt_6,3,3)||"-"||substr(st_dt_6,6,4)||"'";
dis_end_dt_6	= "'"||substr(ed,1,2)||"-"||substr(ed,3,3)||"-"||substr(ed,6,4)||"'";

call symput('startd', startd);
call symput('endd', endd);
call symput('repdate', repdate);
call symput('extractd', extractd);

call symput('bmon', bmon);
call symput('month1', month1);
call symput('month2', month2);
call symput('month3', month3);

call symput('dis_st_dt_1', dis_st_dt_1);
call symput('dis_end_dt_1', dis_end_dt_1);
call symput('dis_st_dt_2', dis_st_dt_2);
call symput('dis_end_dt_2', dis_end_dt_2);
call symput('dis_st_dt_3', dis_st_dt_3);
call symput('dis_end_dt_3', dis_end_dt_3);
call symput('dis_st_dt_4', dis_st_dt_4);
call symput('dis_end_dt_4', dis_end_dt_4);
call symput('dis_st_dt_5', dis_st_dt_5);
call symput('dis_end_dt_5', dis_end_dt_5);
call symput('dis_st_dt_6', dis_st_dt_6);
call symput('dis_end_dt_6', dis_end_dt_6);

run;


data _null_;
%put &startd.;
%put &endd;
%put &extractd;
%put &repdate;
%put &bmon;
%put &month1;
%put &month2;
%put &month3;
%put &dis_st_dt_1;
%put &dis_end_dt_1;
%put &dis_st_dt_2;
%put &dis_end_dt_2;
%put &dis_st_dt_3;
%put &dis_end_dt_3;
%put &dis_st_dt_4;
%put &dis_end_dt_4;
%put &dis_st_dt_5;
%put &dis_end_dt_5;
%put &dis_st_dt_6;
%put &dis_end_dt_6;
run;