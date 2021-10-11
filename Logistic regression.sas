
*********************************	
* CHURN models for SERVICE data *	
*********************************;	
	
/*Service Models(bad vs good)*/;	
data Service_BAD_GOOD  Service_Passive;	
 set service;	
          if serviced in (1,2) then serv_target = 0;/*identify GOOD rating customers as non-event for target*/	
     else if serviced in (4,5) then serv_target = 1;/*identify BAD rating customers as event for target */	
                               else serv_target = . ; 	
          if serviced in (1,2,4,5) then output Service_BAD_GOOD;	
                                   else output Service_Passive;	
run;	
	
/*check on proportion of the event(1) in the target variable*/;	
ods graphics on;	
proc freq data= Service_BAD_GOOD  order=freq;	
   tables serv_target;	
run;	
ods graphics off;	
	
***********************************************	
* (1) create a macro variable for the %age    *	
*     of Target event in the original dataset *	
***********************************************;	
%let pi1= 0.2271;/*original proportion of 1 in the total population*/	
    	
	
**********************************	
/* Sort the data by the target   */	
/* in preparation for stratified */	
/* sampling.                     */	
***********************************;	
proc sort data= Service_BAD_GOOD(where=(serv_Target in (1,0)))	
          out=dataset; 	
     by serv_Target ; 	
run;	

/* The SURVEYSELECT procedure will  */	
/* perform stratified sampling on   */	
/* any variable in the STRATA       */	
/* statement.  The OUTALL option    */	
/* specifies that you want a flag   */	
/* appended to the file to indicate */	
/* selected records, not simply a   */	
/* file comprised of the selected   */	
/* records.                         */	
**************************************;	

proc surveyselect noprint	
                  data = dataset	
                  samprate= 0.70 /* The Train=70% and Valid= 30% */
                  out=dataset1	
                  seed=44444 /*help create pseudo random numbers generated for the partitioning */	
                  outall;/*retain the original dataset augumented by a flag to indicate selection in the sample*/	
   strata serv_Target ;	
run;
	
/* Verify stratification */	
proc freq data = dataset1  order=freq;	
   tables selected serv_Target* selected ;	
run;	
	
/* Create TRAINING and VALIDATION data sets */	
data Train (drop= selected)	
     Valid (drop= selected)	;	
  set dataset1(drop = SelectionProb SamplingWeight);	
    if selected then output Train;	
                else output Valid;	
run;	


**********************************************************************************************************;
%let final= pulse_last_FNo
			home_signal
			free_mins_maxvsavg
			intl_sms_maxvsavg
			Int_12m_total
			last_in_months_ago
			mths_til_ced
			mrc_latestlessavg
			my3_web_6m
			tot_data_latestvsavg
			upgrade_vs_cedm
			app_flag
			my3_hs
			HOME_VOICE_PERCENT_AUG
			SMS_6PM_MIDNIGHT_percent
;

title "Final Service (Bad vs Good) Models";
proc logistic data= train;													
   model serv_Target(event='1') = &final. / selection=B													
											sls=0.05
					                      /*sle=0.05*/
											clodds=pl 													
											lackfit 				
											ctable 
											stb;
run;													
quit;


/*verify correlation amongt key drivers in the model*/													
/*Use 0.30 as a benchmark */
ods output pearsoncorr= corr;	
proc corr data=  ss_1.MC_ServiceBAD_Train1 /*rank*/;	
/*    with serv_Target;	*/
    var pulse_last_FNo
		home_signal
		free_mins_maxvsavg
		intl_sms_maxvsavg
		Int_12m_total
		last_in_months_ago
		mths_til_ced
		mrc_latestlessavg
		my3_web_6m
		tot_data_latestvsavg
		upgrade_vs_cedm
		app_flag
		my3_hs
		HOME_VOICE_PERCENT_AUG
		SMS_6PM_MIDNIGHT_percent;
run;



*********************************
* Score your validation dataset *
*********************************;
ods graphics on;	
proc logistic data= train;													
   model charge_Target(event='1')=  /*selected variables only*/ ;
                                          				
   score data= Valid /* Important: make sure to prepare the Valid dataset 
                                            the same way as your Train dataset before scoring it */												
         out= sco_valid													
         priorevent= &pi1.
         outroc= roc;													
run;													
quit;
