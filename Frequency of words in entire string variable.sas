/* Might struggle with very large dataset? */
data x(keep = word);
    set cas_dvs.lm_4201_Cases_match (obs=20);
    i = 1;
    origword = scan(RC_DESCRLONG,i); /*RC_DESCRLONG is the var I want to count*/
    word = compress(lowcase(origword),'?');
    wordord = i;
    do until (origword = ' ');
        output;
        i + 1;
        wordord = i;
        origword = scan(RC_DESCRLONG,i);
        word = compress(lowcase(origword),'?');
    end;
run;

proc summary nway missing data = x;
	class word;
	var ;
	output out = zzz (drop = _type_);
run;
proc sort data = zzz; by descending _freq_; run;