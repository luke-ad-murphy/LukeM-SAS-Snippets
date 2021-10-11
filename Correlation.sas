rsubmit;
proc corr data = Rf_conts_incl_data OUTP = correlations;
* note that OUTP = gives Pearson's correlation, 
OUTS = gives Spearman's,
OUTK = gives Kendall's;
var 
Adult_R
Adult_F
Community18_R
Community18_F
CommunitySub_R
CommunitySub_F
Dat_R
Dat_F
Entertainment_R
Entertainment_F
Games_R
Games_F
Music_R
Music_F
Other_R
Other_F
Pics_R
Pics_F
See_Me_TV_R
See_Me_TV_F
Sport_R
Sport_F
TV_R
TV_F
Tunes_R
Tunes_F
all_contents_freq;
run;
endrsubmit;
