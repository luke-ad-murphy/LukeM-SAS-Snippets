data a;

dat1=put(today(),yymmdd10.);

time1=put(time(),tod8.);
time2=compress(time1,':');

hour1=substr(time2,1,2);
min1=substr(time2,3,2);
sec1=substr(time2,5,2);

tod1=put(today(),8.);
tod2=tod1-17518;
tod3=compress(tod2,' ');

stamp=compress(compress(dat1) || '_' || compress(hour1) || '-' || compress(min1) || '-' || compress(sec1) || '-' || compress('000') || '_' || compress(tod3) || '.csv');

stamp2=compress(compress(dat1) || '_' || compress(hour1) || '-' || compress(min1) || '-' || compress(sec1) || '-' || compress('000') || '_' || compress(tod3) || '.ctl');

call symput ('filestamp',stamp);

call symput ('dummystamp',stamp2);


run;

%put &filestamp;
%put &dummystamp;