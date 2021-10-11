
/* NOTE - BE CAREFUL WITH VARIABLES THAT HAVE HIGH MISSING VALUES */


/* CREATE PERCENTILES WITHIN A DATA SET*/

rsubmit;

proc rank data = mc_2.ce_margin_200712_b out = ce_margin_200712_b groups=3;

var content_adult content_alerts content_games content_music
content_other content_tunes content_tv cost_content_adult_prop
cost_content_alerts cost_content_games_prop cost_content_music
cost_content_other cost_content_tunes cost_content_tv cost_data cost_email
cost_mms_international cost_mms_off_net cost_mms_on_net cost_mms_other
cost_mms_premium cost_nr_sms cost_nr_voice cost_sms_international cost_sms_introam
cost_sms_other cost_sms_premium_prop cost_sms_rlh cost_sms_uk cost_video_international
cost_video_off_net cost_video_on_net cost_video_other cost_voice_dq cost_voice_fixed_line
cost_voice_free cost_voice_international cost_voice_introam_prop
cost_voice_national_rate cost_voice_off_net cost_voice_on_net cost_voice_other
cost_voice_premium_prop cost_voice_rlh cost_voice_voicemail data
email inbound_revenue_sms inbound_revenue_voice mms_international
mms_off_net mms_on_net mms_other mms_premium one_off_cashback_total one_off_cost_hplr
one_off_cost_other one_off_equipment_disc one_off_equipment_sale
one_off_revenue_other recurring_access_charge_total
recurring_addon_charge_total recurring_discount_loyalty recurring_discount_other
recurring_other_charge_total sms_international sms_introam
sms_other sms_premium sms_rlh sms_uk
video_international video_off_net video_on_net video_other voice_dq voice_fixed_line
voice_free voice_international voice_introam voice_national_rate voice_off_net
voice_on_net voice_other voice_premium voice_rlh voice_voicemail;

run;

endrsubmit;



rsubmit;
proc rank data = offers out = offers groups = 4;

var
cost_sms_uk
cost_voice_international
cost_voice_fixed_line
cost_voice_on_net
sms_uk
voice_international
voice_fixed_line
voice_on_net;

/* Create ranks as new variables */
ranks
cost_sms_uk_rank
cost_voice_international_rank
cost_voice_fixed_line_rank
cost_voice_on_net_rank
sms_uk_rank
voice_international_rank
voice_fixed_line_rank
voice_on_net_rank;

run;
endrsubmit;
