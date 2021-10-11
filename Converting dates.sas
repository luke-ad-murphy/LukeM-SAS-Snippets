data x;
set x;

format newdate date9.;

if date=' ' then newdate=.;
else
day = substr(date,1,2);
month = substr(date,4,2);
year = substr(date,7,4);
newdate=mdy(month,day,year);

run;
