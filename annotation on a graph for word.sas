
data anno;
set mydata;
retain xsys ysys '2' position '6'  ;
midpoint=p_code;
run;

proc gchart data=mydata;
goptions device=win hsize=20cm vsize=9cm;  *** IF YOU WANT TO CUT AND PASTE INTO WORD **;
hbar p_code / subgroup=visits sumvar=val nostats annotate=anno maxis=axis1;
label val=BASKETS;
axis1 label=none;  *** WONT SHOW A LABEL ON Y AXIS ;
format val comma8.; 
title 'REPEAT PURCHASING DURING PROMOTION';
run;
quit;

goptions reset=all;   ** RESET TO DEFAULT **: