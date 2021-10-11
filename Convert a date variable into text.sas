
rsubmit;
data lm_rlh_voice;
set ss_1.lm_rlh_voice;
end = put(Contract_end, monyy5.);
start2 = put(Start, date9.);
run;
endrsubmit;
