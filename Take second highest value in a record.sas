


/* THIS CODE WILL RETURN VARIABLE CALLED TEST GIVING THE SECOND HIGHEST*/
/* VALUE OF THE FIELDS SELECTED - 2 SIGNIFIES YOU WANT THE 2nd HIGHEST*/
rsubmit;
data test;
set asis5.LM_marg_3mnths (obs = 1000);

TEST = largest(2,
content,
sms_international,
sms_introam,
sms_other,
sms_premium,
sms_rlh,
sms_uk,
voice_dq,
voice_fixed_line,
voice_free,
voice_international,
voice_introam,
voice_national_rate,
voice_off_net,
voice_on_net,
voice_other,
voice_premium,
voice_rlh,
voice_voicemail,
data
);
run;
endrsubmit;
