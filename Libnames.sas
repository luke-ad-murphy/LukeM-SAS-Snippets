data calendar;
  set adm.dim_service;
  where service_desc ? "Text" ;
  *where service_desc ? "75";
run;

data dates;
  set adm.dim_calendar;
  where datepart(date_desc)="30SEP2009"d;
run;


*libname tallyman oracle user=bobj password=bobj path=COLLC01 schema=tallyman UTILCONN_TRANSIENT=YES;
*libname mnp oracle user=mnpread password=mnpread schema=MNPuser path=MNPXP01 UTILCONN_TRANSIENT=YES;	 
*libname TP oracle user=SAS_USER password=SAS_USER schema=traffic_owner  path=EDWTP03 UTILCONN_TRANSIENT=YES;	 
*libname edw oracle user=SAS_QUERY pw=SAS_QUERY schema=edwdba path=EDWRP01 UTILCONN_TRANSIENT=YES; 
libname adm2 oracle user=sas_user pw=sas_user schema=adm_owner_prod_trial path=edwcp01 UTILCONN_TRANSIENT=YES; 
libname adm3 oracle user=sas_user pw=sas_user schema=adm_owner path=edwcp01 UTILCONN_TRANSIENT=YES; 
libname adm (adm3 adm2);
*libname ADC_IRE oracle user=query_adc  password=xgl29v path=BIRIC01  schema="ops$birip01"  UTILCONN_TRANSIENT=YES; 
*libname ire_rev oracle user=SAS_REV_ROI password=sa5revro1 schema=REV_OWNER_ROI  path=REVRP01 ;	 
*libname adm_ire oracle user=sas_query pw=sas_query schema=adm_owner   path=EWCIP01 ;
*libname ADC oracle user=query_adc  password=xgl29v path=BIL1P01  schema="ops$bilxp01" UTILCONN_TRANSIENT=YES ; 
*libname REVMART oracle user=SAS_REV password=c0nfidential schema=REV_OWNER path=REVRP01 UTILCONN_TRANSIENT=YES; 
*libname people oracle user=psftadm_ro password=r3ad0nly path=PEOXC01  schema=psftadm UTILCONN_TRANSIENT=YES;	 
*libname sprint oracle user=SAS_QUERY password=b1uekiwi path=SPRXC02 schema=sprint2 ;
*libname new_tlu '/var/opt/sascore' compress=yes;                                           
*libname new_tlu1 '/var/opt/sascore/maindata' compress=yes;                                           
libname mc_1 '/var/opt/analysis_1' compress=yes;
libname mc_2 '/var/opt/analysis_2'  compress=yes;
libname kf_1 '/var/opt/analysis_3'  compress=yes;
libname kf_2 '/var/opt/analysis_4' compress=yes;
libname Asis5 '/var/opt/analysis_5'  compress=yes;
libname Ts_1 '/var/opt/analysis_6'  compress=yes;
libname SG_1 '/var/opt/analysis_7' compress=yes;
libname Asis9 '/var/opt/analysis_9' compress=yes;
libname SA_1 '/var/opt/analysis_12' compress=yes;
libname Margin '/var/opt/analysis_13' compress=yes access=readonly;
libname new_camp '/var/opt/campain_lists' compress=yes ;                                                   
libname jl_1 '/var/opt/campain_lists/jo' compress=yes ;                                                   
libname RM_1 '/var/opt/analysis_11' compress=yes;
libname SS_1 '/var/opt/analysis_8'  compress=yes;
libname sasload '/var/opt/sasload';

