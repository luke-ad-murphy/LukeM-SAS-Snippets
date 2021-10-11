
/* TAKE MAXIMUM AND MINIMUM VALUE FROM SERIES OF VARIABLES THEN RETURN THE
NAME OF THAT VARIABLE*/
rsubmit;
data asis5.LM_marg_3mnths;
set asis5.LM_marg_3mnths;

format Rev $30.;
format Cost $30.;

content = sum(content_adult, content_alerts, content_games, content_music, 
			  content_other, content_tunes, content_tv);

cost_content = sum(cost_content_adult_prop, cost_content_alerts, 
				   cost_content_games_prop, cost_content_music,
				   cost_content_other, cost_content_tunes, cost_content_tv);

Positive = max(
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

Negative = min(
cost_content,
cost_sms_international,
cost_sms_introam,
cost_sms_other,
cost_sms_premium_prop,
cost_sms_rlh,
cost_sms_uk,
cost_voice_dq,
cost_voice_fixed_line,
cost_voice_free,
cost_voice_international,
cost_voice_introam_prop,
cost_voice_national_rate,
cost_voice_off_net,
cost_voice_on_net,
cost_voice_other,
cost_voice_premium_prop,
cost_voice_rlh,
cost_voice_voicemail,
cost_data
);


/* calculate Revest positive generator */
if positive = 0 then Rev = 'N/A';
else if positive = content then Rev = 'content';
else if positive = sms_international then Rev = 'SMS international';
else if positive = sms_introam then Rev = 'SMS International roam';
else if positive = sms_other then Rev = 'SMS other';
else if positive = sms_premium then Rev = 'SMS premium';
else if positive = sms_rlh then Rev = 'SMS Roam like home';
else if positive = sms_uk then Rev = 'SMS UK';
else if positive = voice_dq then Rev = 'Voice - directory enquiries';
else if positive = voice_fixed_line then Rev = 'Voice - fixed line';
else if positive = voice_free then Rev = 'Voice - free';
else if positive = voice_international then Rev = 'Voice - international';
else if positive = voice_introam then Rev = 'Voice - international roaming';
else if positive = voice_national_rate then Rev = 'Voice - national rate';
else if positive = voice_off_net then Rev = 'Voice - off net';
else if positive = voice_on_net then Rev = 'Voice - on net';
else if positive = voice_other then Rev = 'Voice - other';
else if positive = voice_premium then Rev = 'Voice - premium';
else if positive = voice_rlh then Rev = 'Voice - roam like home';
else if positive = voice_voicemail then Rev = 'Voice - voicemail';
else if positive = data then Rev = 'Data';
else Rev = 'N/A';

/* calculate lowest negative generator */
if negative = 0 then Cost = 'N/A';
else if negative = cost_content then Cost = 'content';
else if negative = cost_sms_international then Cost = 'SMS international';
else if negative = cost_sms_introam then Cost = 'SMS International roam';
else if negative = cost_sms_other then Cost = 'SMS other';
else if negative = cost_sms_premium_prop then Cost = 'SMS premium';
else if negative = cost_sms_rlh then Cost = 'SMS Roam like home';
else if negative = cost_sms_uk then Cost = 'SMS UK';
else if negative = cost_voice_dq then Cost = 'Voice - directory enquiries';
else if negative = cost_voice_fixed_line then Cost = 'Voice - fixed line';
else if negative = cost_voice_free then Cost = 'Voice - free';
else if negative = cost_voice_international then Cost = 'Voice - international';
else if negative = cost_voice_introam_prop then Cost = 'Voice - international roaming';
else if negative = cost_voice_national_rate then Cost = 'Voice - national rate';
else if negative = cost_voice_off_net then Cost = 'Voice - off net';
else if negative = cost_voice_on_net then Cost = 'Voice - on net';
else if negative = cost_voice_other then Cost = 'Voice - other';
else if negative = cost_voice_premium_prop then Cost = 'Voice - premium';
else if negative = cost_voice_rlh then Cost = 'Voice - roam like home';
else if negative = cost_voice_voicemail then Cost = 'Voice - voicemail';
else if negative = cost_data then Cost = 'Data';
else Cost = 'N/A';

run;

proc freq data = asis5.LM_marg_3mnths; table Rev; run;
proc freq data = asis5.LM_marg_3mnths; table Cost; run;
endrsubmit;
