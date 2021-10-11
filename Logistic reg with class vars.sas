proc logistic data = Train descending;
class 
same_handset (ref='NA') 
exp_band (ref='Within_10PC') 
Int_disc_req (ref='Y') 
network_manuf (ref='OTHER') 
hold_addon_email (ref='N') 
bun_band (ref='M') 
/ param = ref
;
model Churn(event='1') = 
/* class vars */
same_handset
exp_band
Int_disc_req
network_manuf
hold_addon_email
bun_band

/* continuous vars */
mths_at_3
MT_over_MO_CALLS
access_fee
offnet_sms
/stepwise slentry = 0.001;
output out = logout p = pred;
run;