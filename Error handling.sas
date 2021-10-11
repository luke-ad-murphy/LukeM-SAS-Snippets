
/*MACROS for ERROR Handling */



/*EMAIL ADDRESSES*/

%let userid1 = mark.chaimbault@three.co.uk ;
%let userid2 = Luke.murphy@three.co.uk;
%let userid3 = ;



/**********************************************************************************/
* INITIAL SET UP OF LOG FILES ETC                                               ***
/*********************************************************************************/;

%macro init(logfl=,printfl=,email=0,processname=);
options NOERRORABEND;

/*DATESTAMP LOG*/
data _null_;
  %global logloc; 
  %global prtloc; 

  call symput('logloc', "&logfl._"||trim(left(put(today(),date9.)))||".txt"  );
  call symput('prtloc', "&printfl._"||trim(left(put(today(),date9.)))||".txt"  );
run;
%put &logloc.;
/*put(datetime(),datetime.)*/

%global hdds_err_flg; /* Error flag, set to 1 if an error occurs */
%global hdds_email_flg; /* Send e-mail flag, if 1, an e-mail is sent to the operator in case of an error */
%global hdds_process_name; /* The unique name for the process being executed */
%global hdds_log_file; /* The path and name for the file log content is written to */
%global hdds_output_file; /* The path and name for the file output content is written to */
%global error_log; /* The number of Error Lines extracted from the Log File*/




/*Initializing the Macro Variables*/
%let hdds_err_flg=0;
%let hdds_email_flg=0;
%let hdds_process_name=%upcase(&processname);
%let hdds_log_file = ;
%let hdds_output_file = ;
%let error_log = 0;

%if (%eval(&email>0)) %then %let hdds_email_flg=1;


/* Start writing into external files if log or output file paths and name are provided */
%if (%eval("&logfl" ne "" or "&printfl" ne "")) %then %do;
  proc printto 
    %if ("&logfl" ne "") %then %do;
      %let hdds_log_file = &logloc.;
      log="&logloc"
    %end;
    %if ("&printfl" ne "") %then %do;
      %let hdds_output_file = &prtloc;
      print="&prtloc"
    %end;
   new ;
  run;
%end;
%mend init;





/**********************************************************************************/
*CALL THIS MACRO AFTER EACH STEP IF YOU WANT INSTANT EMAIL AND SAS TO TERMINATE*
/*********************************************************************************/;

%macro chkErr(checkpoint=);
  %if (%eval(&hdds_err_flg=0 and (&syserr>0 and not(&syserr = 4)))) %then %do;
      %let hdds_err_flg=1;
     %final;
      /*Terminate SAS - we may remove this*/
       data _null_;
         abort abend;
       run;
   %end;
%mend chkErr;





/**********************************************************************************/
* CALLED AT END OF PROGRAM *
/*********************************************************************************/;

%macro final();

/*Close the log and output external files*/
proc printto;
run;

/*If the Log content is being written to external file then call %getErrors read log file*/
  %if ("&hdds_log_file" ne "") %then %do;
    %getErrors;
  %end;

/*If Log content is not being written to external file*/
%if ("&hdds_log_file" = "") %then %do;
   /*If Error and Email Flag is*/
   %if (%eval(&hdds_email_flg=1 and &hdds_err_flg = 1)) %then %do;
     %let msg = SAS Program Stopped After Checkpoint: &checkpoint;
     %email(to_addr1=&userid1.,to_addr2=&userid2.,to_addr3=&userid3.,
            ,subject=PROCESS &hdds_process_name caused a SAS Error, message="&msg");
   %end;
   /*If no Error and Email Flag is on*/
   %else %if (%eval(&hdds_email_flg=1 and &hdds_err_flg = 0)) %then %do;
     %let msg = No Critical Errors;
     %email(to_addr1=&userid1.,to_addr2=&userid2.,to_addr3=&userid3.,
            subject=PROCESS &hdds_process_name ran successfully, message="&msg");
   %end;
%end;
%else %do;
/*log file on*/
 /*If Error and Email Flag*/
   %if (%eval(&hdds_email_flg=1 and &error_log ge 1 and &hdds_err_flg = 1)) %then %do;
       %let msg = SAS Program Stopped After Checkpoint &checkpoint;
       %email(to_addr1=&userid1.,to_addr2=&userid2.,to_addr3=&userid3.,
              subject=PROCESS &hdds_process_name caused a SAS Error, message="&msg");
   %end;
 /*If Error = 0 and Email Flag = 1*/
   %else %if (%eval(&hdds_email_flg=1 and &error_log ge 1 and &hdds_err_flg = 0)) %then %do;
      %let msg = Non Critical Error occured;
      %email(to_addr1=&userid1.,to_addr2=&userid2.,to_addr3=&userid3.,
             subject=PROCESS &hdds_process_name caused a SAS Error, message="&msg");
   %end;
/*No Errors*/
    %else %if (%eval(&hdds_email_flg=1 and &error_log = 0)) %then %do;
       %let msg = No Errors;
       %email(to_addr1=&userid1.,to_addr2=&userid2.,to_addr3=&userid3.,
              subject=PROCESS &hdds_process_name ran successfully, message="&msg");
    %end;
%end;
%mend final;





/**********************************************************************************/
*SCAN LOG FOR ERRORS*
/*********************************************************************************/;


%macro getErrors;
 /*Extract Errors and Warnings from the Log File and stores them in their corresponding data sets*/
data log(keep=logline) errors(keep=logline) warnings(keep=logline);
 infile "&logloc." missover;
  length logline $256 code $20;
   retain code ;
   input;
    if index(_infile_,'0D'x) then logline=scan(_infile_,1,'0D'x);
    else logline=_infile_;
    logline = translate(logline,' ','%');

    if index(logline,':') then code=scan(logline,1,':');
    else if substr(logline,1,5) ne ' ' then code=scan(logline,1,' ');
    output log;

    if index(code,'ERROR') =1 and logline ne ' ' then output errors;
    if index(code,'WARNING') =1 and logline ne ' ' then output warnings;
run;

/*Error_Log Macro Variable captures number of error lines in the log file*/
proc sql noprint;
  select count(*)
    into :error_log
      from errors;
quit;
%mend getErrors;




/**********************************************************************************/
*EMAIL SUCCESS*
/*********************************************************************************/;

%macro email(to_addr1=,to_addr2=,to_addr3=,to_addr4=,
             c_addr1= ,c_addr2= ,c_addr3= ,c_addr4= ,
             subject= ,message=,
             attach_file1=,attach_file2=,attach_file3=);




data _null_;
 length tot $1000;
  %do i=1 %to 3;
     %if ("&&to_addr&i.." ne "") %then %do;
        tot=trim(left(tot)) || ' "' || trim(left(("&&to_addr&i")))|| '"';
	 %end;
  %end;
  call symput ('emtot',tot);
  call symput ('emcct',tot);
run;

%put &emtot.;

filename outbox email;
data _null_;
 file outbox
     to=(&emtot.)
     subject="SASJOBS Automated Mail: &subject"
     ;
  put &message;
run;
%mend email;


******************************************************************************************************;
******************************************************************************************************;
******************************************************************************************************;