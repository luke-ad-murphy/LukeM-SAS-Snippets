*Use an array to weight various usage fields so that we can compare 
 October 2010 with February 2011.
October EWD = 28.6
February EWD = 26.1
Mean EWD = 27.35;

%macro weight(oct= , feb= );

data upgraders6 
(drop=	i
		tot_dur_&oct.
		otot_dur_&oct.
		din_onnet_&oct.
		din_offnet_&oct.
		din_DQ_&oct.
		din_Landline_&oct.
		din_Internat_&oct.
		din_Introam_&oct.
		din_RLH_&oct.
		din_National_&oct.
		din_Premium_&oct.
		din_Free_&oct.
		din_Other_&oct.
		din_Voicemail_&oct.
		doff_onnet_&oct.
		doff_offnet_&oct.
		doff_DQ_&oct.
		doff_Landline_&oct.
		doff_Internat_&oct.
		doff_Introam_&oct.
		doff_RLH_&oct.
		doff_National_&oct.
		doff_Premium_&oct.
		doff_Free_&oct.
		doff_Other_&oct.
		doff_Voicemail_&oct.
		tot_dur_&feb.
		otot_dur_&feb.
		din_onnet_&feb.
		din_offnet_&feb.
		din_DQ_&feb.
		din_Landline_&feb.
		din_Internat_&feb.
		din_Introam_&feb.
		din_RLH_&feb.
		din_National_&feb.
		din_Premium_&feb.
		din_Free_&feb.
		din_Other_&feb.
		din_Voicemail_&feb.
		doff_onnet_&feb.
		doff_offnet_&feb.
		doff_DQ_&feb.
		doff_Landline_&feb.
		doff_Internat_&feb.
		doff_Introam_&feb.
		doff_RLH_&feb.
		doff_National_&feb.
		doff_Premium_&feb.
		doff_Free_&feb.
		doff_Other_&feb.
		doff_Voicemail_&feb.);

set upgraders5;

format  tot_dur_W_&oct.
		otot_dur_W_&oct.
		din_onnet_W_&oct.
		din_offnet_W_&oct.
		din_DQ_W_&oct.
		din_Landline_W_&oct.
		din_Internat_W_&oct.
		din_Introam_W_&oct.
		din_RLH_W_&oct.
		din_National_W_&oct.
		din_Premium_W_&oct.
		din_Free_W_&oct.
		din_Other_W_&oct.
		din_Voicemail_W_&oct.
		doff_onnet_W_&oct.
		doff_offnet_W_&oct.
		doff_DQ_W_&oct.
		doff_Landline_W_&oct.
		doff_Internat_W_&oct.
		doff_Introam_W_&oct.
		doff_RLH_W_&oct.
		doff_National_W_&oct.
		doff_Premium_W_&oct.
		doff_Free_W_&oct.
		doff_Other_W_&oct.
		doff_Voicemail_W_&oct. 
		tot_dur_W_&feb.
		otot_dur_W_&feb.
		din_onnet_W_&feb.
		din_offnet_W_&feb.
		din_DQ_W_&feb.
		din_Landline_W_&feb.
		din_Internat_W_&feb.
		din_Introam_W_&feb.
		din_RLH_W_&feb.
		din_National_W_&feb.
		din_Premium_W_&feb.
		din_Free_W_&feb.
		din_Other_W_&feb.
		din_Voicemail_W_&feb.
		doff_onnet_W_&feb.
		doff_offnet_W_&feb.
		doff_DQ_W_&feb.
		doff_Landline_W_&feb.
		doff_Internat_W_&feb.
		doff_Introam_W_&feb.
		doff_RLH_W_&feb.
		doff_National_W_&feb.
		doff_Premium_W_&feb.
		doff_Free_W_&feb.
		doff_Other_W_&feb.
		doff_Voicemail_W_&feb. 8.0;

array octnew (26) tot_dur_W_&oct.
		otot_dur_W_&oct.
		din_onnet_W_&oct.
		din_offnet_W_&oct.
		din_DQ_W_&oct.
		din_Landline_W_&oct.
		din_Internat_W_&oct.
		din_Introam_W_&oct.
		din_RLH_W_&oct.
		din_National_W_&oct.
		din_Premium_W_&oct.
		din_Free_W_&oct.
		din_Other_W_&oct.
		din_Voicemail_W_&oct.
		doff_onnet_W_&oct.
		doff_offnet_W_&oct.
		doff_DQ_W_&oct.
		doff_Landline_W_&oct.
		doff_Internat_W_&oct.
		doff_Introam_W_&oct.
		doff_RLH_W_&oct.
		doff_National_W_&oct.
		doff_Premium_W_&oct.
		doff_Free_W_&oct.
		doff_Other_W_&oct.
		doff_Voicemail_W_&oct.;

array octold (26) tot_dur_&oct.
		otot_dur_&oct.
		din_onnet_&oct.
		din_offnet_&oct.
		din_DQ_&oct.
		din_Landline_&oct.
		din_Internat_&oct.
		din_Introam_&oct.
		din_RLH_&oct.
		din_National_&oct.
		din_Premium_&oct.
		din_Free_&oct.
		din_Other_&oct.
		din_Voicemail_&oct.
		doff_onnet_&oct.
		doff_offnet_&oct.
		doff_DQ_&oct.
		doff_Landline_&oct.
		doff_Internat_&oct.
		doff_Introam_&oct.
		doff_RLH_&oct.
		doff_National_&oct.
		doff_Premium_&oct.
		doff_Free_&oct.
		doff_Other_&oct.
		doff_Voicemail_&oct.;

array febnew (26) tot_dur_W_&feb.
		otot_dur_W_&feb.
		din_onnet_W_&feb.
		din_offnet_W_&feb.
		din_DQ_W_&feb.
		din_Landline_W_&feb.
		din_Internat_W_&feb.
		din_Introam_W_&feb.
		din_RLH_W_&feb.
		din_National_W_&feb.
		din_Premium_W_&feb.
		din_Free_W_&feb.
		din_Other_W_&feb.
		din_Voicemail_W_&feb.
		doff_onnet_W_&feb.
		doff_offnet_W_&feb.
		doff_DQ_W_&feb.
		doff_Landline_W_&feb.
		doff_Internat_W_&feb.
		doff_Introam_W_&feb.
		doff_RLH_W_&feb.
		doff_National_W_&feb.
		doff_Premium_W_&feb.
		doff_Free_W_&feb.
		doff_Other_W_&feb.
		doff_Voicemail_W_&feb.;

array febold (26) tot_dur_&feb.
		otot_dur_&feb.
		din_onnet_&feb.
		din_offnet_&feb.
		din_DQ_&feb.
		din_Landline_&feb.
		din_Internat_&feb.
		din_Introam_&feb.
		din_RLH_&feb.
		din_National_&feb.
		din_Premium_&feb.
		din_Free_&feb.
		din_Other_&feb.
		din_Voicemail_&feb.
		doff_onnet_&feb.
		doff_offnet_&feb.
		doff_DQ_&feb.
		doff_Landline_&feb.
		doff_Internat_&feb.
		doff_Introam_&feb.
		doff_RLH_&feb.
		doff_National_&feb.
		doff_Premium_&feb.
		doff_Free_&feb.
		doff_Other_&feb.
		doff_Voicemail_&feb.;

 do i= 1 to 26; 
  
febnew(i)=sum((febold(i)/26.1)*27.35);
octnew(i)=sum((octold(i)/28.6)*27.35);

end;

run;

%mend;

%weight(oct=201010, feb=201102);