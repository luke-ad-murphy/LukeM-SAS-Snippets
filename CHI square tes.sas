proc freq data = GI;
tables so * Facebook_Not_at_all 
 / chisq measures 
/*plots = (freqplot(twoway=groupvertical scale=percent))*/
;
run;
