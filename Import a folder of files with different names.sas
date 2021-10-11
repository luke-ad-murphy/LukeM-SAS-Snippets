
/*=============================================================================                    
                            Project Information                                                    
-------------------------------------------------------------------------------                    
 Customer Name          : Internal and Marketing                                                                         
 Project Number         :                                                                          
 Project Path           :                                                                          
 Project Status         :                                                                          
-------------------------------------------------------------------------------                    
                             Program Information                                                   
-------------------------------------------------------------------------------                    
 Program                :  WLM automated updates                                                                        
 Brief Description      :                                                                          
 Copied From            :                                                                          
 Data sets Used         :                                                                          
 Data Set Created       :                                                                          
 Output Files           :                                                                          
 Notes / Assumptions    :                                                                          
-------------------------------------------------------------------------------                    
                             Programmer Information                                                
-------------------------------------------------------------------------------                    
 Author                 : Victoria Watson                                                          
 Department             : Analytics                                                                
 Creation Date          : 23FEB2009                                                                
-------------------------------------------------------------------------------                    
                            Environment Information                                                
-------------------------------------------------------------------------------                    
 SAS Version            : 9.1                                                                      
 Operating System       : XP_PRO                                                                   
-------------------------------------------------------------------------------                    
                           Change Control Information                                              
-------------------------------------------------------------------------------                    
 Modifications:                                                                                    
 Programmer/Date:       Reason:                                                                    
 ----------------       ---------------------------------------------------                        
                                                                                                   
==============================================================================*/                   
                                                                                                   
/******************************************************************************/

/*
   THIS CODE IS HIGHLY DEPENDANT ON THE CORRECT FILES BEING PRESENT IN THE 
   MANAGED FOLDERS FILE. YEE LING CHEN DOWNLOADS FILES INTO THE LATEST FILES 
   AREA - THE LATEST FILES THEN NEED TO BE MOVED INTO THE MANAGED FOLDER AND
   UPLOADED FROM THERE.

   PART A:
   THIS CODE AUTOMATICALLY READS IN THE NAMES OF THE FILES FROM THE DIRECTORY
   LISTED IN THIS STATEMENT. 

   PART B: 
   ENSURE OLD TXT FILE IS DELETED BEFORE CREATING THE NEW TXT FILE.
   THIS CODE READS IN EACH FILE LISTED IN THE "managed.txt" TEXT FILE

   PART C:
   WE HAVE 2 SUPPLIERS OF WLM DATA - NEUSTAR AND MIYOWA - EACH SUPPLIER HAS
   A DIFFERENT FORMAT FOR THE FILES. THIS SECTION OF CODE REFORMATS THE DATA
   SEE INDIVIDUAL COMMENTS STATEMENTS

   PART D:
   CHECKS VOLUMES AGAINST EACH MONTH AND APPENDS DATA FOR BASE FILE.*/

/******************************************************************************/

/*** pre- check existing file**/

/*rsubmit;*/
/*proc freq data=asis5.wlm_usage_2009;*/
/*  tables month ;*/
/*  tables rundate;*/
/*run;*/
/*endrsubmit;*/


/** PART A **/
options noxsync noxwait;
X DIR/s/b "Z:\WLM files\Latest files\Managed folder\" > "Z:\WLM files\Latest files\Managed folder\managed.txt" ;

/*** Run above statement alone before running next step ***/

/** PART B **/
data base;
 length dummy $1000;
  infile "Z:\WLM files\Latest files\Managed folder\managed.txt" dlm ='09'x ;
    input dummy $ ;

	if dummy ='Z:\WLM files\Latest files\Managed folder\managed.txt' then delete;
run;

/** PART C ***/
data _null_;
  set base; 
   call execute("data x dates;");
   call execute("retain flg 0;");
   call execute("infile '"|| trim(left(dummy)) ||"' delimiter = ',' MISSOVER DSD;");
   call execute("format var1 $100. var2 $100. var3 $100. var4 $100. var5 $100. var6 $100. var7 $100. var8 $100. var9 $100.;");
   call execute("input var1 $ var2 $ var3 $ var4 $ var5 $ var6 $ var7 $ var8 $ var9 $;");
   call execute("if upcase(var1) in ('USER ID') then flg =1;");
   call execute("if flg = 1 then output x; else output dates;");
   call execute("run;");

   call execute("data zzz (keep=_rundate dumvar) ;");
   call execute("set dates;");
   call execute("dumvar=1;");
   call execute("if upcase(var1)=: 'START TIME' then do; _rundate =var2; output;end;");
   call execute("run;");

   call execute("data x2 (drop= var1-var9 flag); retain flag; length supplier $20.;");
   call execute("set x (drop=flg);");
   call execute("dumvar=1;");
   call execute("if _n_= 1 and var8 = 'Device Type' then flag='M';");
   call execute("if _n_= 1 and var8 = 'Logouts' then flag='Z';");
   call execute("if flag = 'M' then do;");
   call execute("Userid=var1; MSISDN=var2; SendParam=var3; Download=var4; IMSent=var5; IMRecv=var6; Logins=var7; DeviceType=var8; Logouts=var9; Supplier='Miyowa';");
   call execute("end; else");
   call execute("if flag = 'Z' then do;");
   call execute("Userid=var1; MSISDN=var2; IMSent=var3; IMRecv=var4; Emailsent=var5; Emailrecv=var6; Logins=var7; Logouts=var8; DeviceType=var9;Supplier='Neustar';");
   call execute("end;");
   call execute("if _n_ =1 then delete;");
   call execute("run;");

   call execute("data x3;");
   call execute("merge x2 zzz;by dumvar;");
   call execute("run;");

   /********* Reformat variables **************/

   call execute("data x4 (rename= (imsent2=imsent imrecv2=imrecv logins2=logins logouts2=logouts emailsent2=emailsent emailrecv2=emailrecv download2=download sendparam2=sendparam));");
   call execute("retain flag_msis 0 flag 0;");
   call execute("set x3;");

   /*** accounts for msisdns that dont begin with 44 ***/
   call execute('if substr(msisdn,1,1) NOT IN ("1" "2" "3" "4" "5" "6" "7" "8" "9" "0") then flag_msis=1;');
   call execute('if flag_msis=1 then msisdn2=substr(msisdn,3);');
   call execute('if flag_msis=0 then msisdn2=msisdn;');
   call execute('if substr(msisdn2,1)="7" then msisdn="44"||msisdn;');
   call execute('if msisdn2=" " then delete;');
   call execute('if substr(msisdn2,1,1)="6" then delete;');
   call execute('msisdn=msisdn2;');
   /*** end of msisdn reformatting ***/

   /** create numeric variables **/
   call execute('imsent2=input(imsent,best8.);');
   call execute('imrecv2=input(imrecv,best8.);');
   call execute('logins2=input(logins,best8.);');
   call execute('logouts2=input(logouts,best8.);');
   call execute('emailsent2=input(emailsent,best8.);');
   call execute('emailrecv2=input(emailrecv,best8.);');
   call execute('sendparam2=input(sendparam,best8.);');
   call execute('download2=input(download,best8.);');
   /** create rundate as a numeric date9. **/
   call execute('rundate=input(substr(_rundate,1,10),ddmmyy10.);'); 
   call execute('month=upcase(put(rundate,monname3.));'); 
   call execute('format rundate date9.;');
   /*** Drop temporary variables ****/
   call execute('drop msisdn2 flag flag_msis dumvar imsent imrecv logins logouts emailsent emailrecv download sendparam _rundate;');
   call execute("run;");

   /*** append the new data from x4 to final ***/
   call execute("proc append base=final data = x4 force;");
   call execute("run;");
run;



/** PART D ***/
data asis5.wlm_test2;
set final;
run;



/***** Test new code ****/
rsubmit;
proc freq data =asis5.wlm_test; table month /out=data; run;
proc freq data =asis5.wlm_test ; table rundate*supplier/ out=databydatesupplier; run;
endrsubmit;

rsubmit;
proc transpose data=databydatesupplier out=transdata (drop=_NAME_ _LABEL_);
  by rundate;
  id supplier;
  var count;
run;
endrsubmit;


/****When happy with the new code - append the monthly extractions together ****/


rsubmit;
data asis9.wlm_usage_2009;
  set asis9.wlm_usage_2009
      asis5.wlm_test;
run;
endrsubmit;

rsubmit;
proc freq data = asis9.wlm_usage_2009; table rundate; run;
endrsubmit;
