rsubmit;
data lm_skype_marg;
set ss_1.lm_skype_marg;

if Skype_mins_200811 in (., 0) 
then do;
new_marg_200811 = margin_200811;
new_rev_200811 = total_rev_200811;
end;

if (Skype_mins_200811 GT 0 AND Skype_mins_200811 LE inb_voi_200811) 
then do;
new_marg_200811 = (margin_200811 - Inb_Skype_rev_200811);
new_rev_200811 = (total_rev_200811 - Inb_Skype_rev_200811);
end;

run;
endrsubmit;
