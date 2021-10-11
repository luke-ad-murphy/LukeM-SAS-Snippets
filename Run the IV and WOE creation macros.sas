/*** FIRST OF ALL SET THE GLOBAL MACROS ***/

/*----  BNET Start Code  ----*/

/*----  In revision: copy BNET_Revised to BNET  ----*/
/*----  Rename this file to BNET_Startup.sas    ----*/

%let root = /var/opt/analysis_4/asis1/LM;  

%include "&root/Macros/gnbcreg.sas" ; 
%include "&root/Macros/bifurcate.sas" ; 
%include "&root/Macros/information.sas" ; 
%include "&root/Macros/gainschart.sas" ; 
%include "&root/Macros/incremental.sas" ;
%include "&root/Macros/miss.sas" ;
%include "&root/Macros/miscellaneous.sas" ;



/* Here's where you put your file name (test and validation),input vars and target var */
%information(data=train,
             crossvaldata=valid,
             y=churn,
             var=ALL, 
             printt=y, printg=y,
			 output=/var/opt/analysis_3);




***********************************XXXXXXXX**********************************;
********************************XXXXXXXXXXXXXX*******************************;
*****************************************************************************;
*************************  E-N-D  O-F  P-R-O-G-R-A-M ************************;
*****************************************************************************;
********************************XXXXXXXXXXXXXX*******************************;
***********************************XXXXXXXX**********************************;