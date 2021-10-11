/****************************************************************************************
*       CLIENT:         			                                                    *
*       PROJECT:        		META					            	            *
*       PROGRAM NAME:   Demo Regression DHS ACDs.sas								*
*       PROGRAMMER:      			                                                    *
*       DATE:            		                                                        *
*       AIM:            regression analysis on daily dhs calls							*
****************************************************************************************/

rsubmit;libname dell 'N:\data\car_data\Dell\META\Demo\SAS data';endrsubmit;
			libname dell 'Q:\car_data\Dell\META\Demo\SAS data';
			libname view slibref=work server=server;


/*DHS CALLS*/

/* Stepwise first */
proc reg data=dell.Rawdata;
title 'dhs calls stepwise model';
 where '30apr04'd < date;			
 model dhscalls=
/*date
weekdays*/
np_dhs
np_dhs_tail
np_week
np_wend
npspend
npspend_tail
npspend_week
npspend_wend
npins_dhs
npins_dhs_bsdtail
npins_dhs_dhstail
npins_bsd
npins_bsd_bsdwktail
npins_bsd_dhstail
npins_bsd_bsdtail
/*npins_ebu*/
/*b2bins*/
/*b2bins_tail*/
/*pcp_dhs*/
/*pcp_dhs_tail*/
pcp_spend_dhs
pcp_spend_dhs_tail
pcp_bsd
pcp_bsd_tail
pcp_spend_bsd
pcp_spend_bsd_tail
drtv_imp
drtv_imp_lag1
drtv_sp
drtv_tvrs
peaktv_imp
peaktv_imp_lag1
peaktv_tvrs
ebutv_imp
ebutv_tvrs
ebutv_spend
online_spend
dm_dhs
dm_dhs_tail1
dm_dhs_tail2
dm_dhs_tail3
dmcat_bsd
dmcat_bsd_tail1
dmcat_bsd_tail2
dmcat_bsd_tail3
dmpc_bsd
dmpc_bsd_tail1
dmpc_bsd_tail2
dmpc_bsd_tail3
dmpc_bsd_tail4
fax
email_bsd
email_dhs
mon
tue
wed
thu
fri
sat
sun
bsd_off_doubmem
bsd_off_hardup
bsd_off_del
bsd_off_per
bsd_off_monoff
bsd_on_doubmem
bsd_on_hardup
bsd_on_del
bsd_on_per
bsd_on_monoff
dhs_off_doubmem
dhs_off_del
dhs_off_per
dhs_off_monoff
dhs_off_fin
dhs_off_end_doubmem
dhs_off_end_del
dhs_off_end_per
dhs_off_end_monoff
dhs_off_end_fin
dhs_on_doubmem
dhs_on_del
dhs_on_per
dhs_on_monoff
dhs_on_fin
dhs_on_end_doubmem
dhs_on_end_del
dhs_on_end_per
dhs_on_end_monoff
dhs_on_end_fin
dell_tv
hp_tv
ibm_tv
pcw_tv
dell_tv_sov
dell_radio
hp_radio
ibm_radio
time_radio
pcw_radio
dell_radio_sov
dell_press_weekday
dell_press_weekend
dell_press
hp_press
ibm_press
pcw_press
time_press
fujitsu_press
dell_press_sov_pcwtime
dell_press_sov
dell_internet
hp_internet
ibm_internet
pcw_internet
time_internet
dell_int_cov
tmu_dhs
tmu_bsd
cmu_bsd_desk
cmu_dhs_desk
cmu_bsd_lap
cmu_dhs_lap
Low_PP_to_499
Low_PP_to_599
Low_PP_to_699
Low_PP_to_799
Low_PP_to_899
Low_PP_to_999
Ave_PP_to_499
Ave_PP_to_599
Ave_PP_to_699
Ave_PP_to_799
Ave_PP_to_899
Ave_PP_to_999
bnpl_tv
/*bsdcalls
dhscalls
bsd_svs
dhs_svs*/
npins_DHS_TAIL_1wk
npins_DHS_TAIL_1wksmooth
npins_dhs_3days
drtvl1_npdhs_dhstail
peaktvl1_npdhs_dhstail

	/selection=stepwise;		/* This is the only difference in code between regular & stepwise regression */

output p=yhat r=yresid dffits 
= ydif out=dhscalls_step (keep=dhscalls date yhat
 /*np_dhs_lag1 npins_dhs_bsdtail drtvl1_npinsbsd  drtv_tvrs
 online_spend   dm_dhs_tail2 peaktv_tvrs_lag5
peaktvl1_npdhstail dhs_off_del dhs_on_per 
sat sun ukhols*/); run;quit;


proc contents data=dell.rawdata;
run;

/* Then regular regression */

/*DHS CALLS*/
proc reg data=dell.Rawdata;
title 'dhs calls regular model';
 where '30apr04'd < date;			
 model bsdcalls=

np_dhs
/*npins_dhs_dhstail*/
/*npins_bsd_dhstail*/
/*npins_bsd_bsdtail*/
/*drtv_imp*/
/*pcp_bsd*/
/*pcp_bsd_tail*/
/*dmcat_bsd*/
dmcat_bsd_tail1
/*dmcat_bsd_tail2*/
/*dmcat_bsd_tail3*/
/*fax*/
peaktv_imp
/*peaktv_lag1*/
/*peaktv_tvrs*/
online_spend
/*dm_dhs_tail3*/
/*email_dhs*/
/*sat*/
/*sun*/
/*dhs_off_monoff*/
/*pcw_tv*/
/*pcw_press*/
/*drtvl1_npdhs_dhstail*/

;		/* This is the only difference in code between regular & stepwise regression */

output p=yhat r=yresid dffits 
= ydif out=dhscalls_reg (keep=bsdcalls date yhat
np_dhs np_dhs_tail npins_dhs_dhstail npins_bsd_dhstail
drtv_tvrs peaktv_tvrs online_spend dm_dhs_tail3 email_dhs
sat sun dhs_off_monoff pcw_tv pcw_press drtvl1_npdhs_dhstail
peaktvl1_npdhs_dhstail
); run;quit;
