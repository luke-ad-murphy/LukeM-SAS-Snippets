/*----  BNET Start Code  ----*/

/*----  In revision: copy BNET_Revised to BNET  ----*/
/*----  Rename this file to BNET_Startup.sas    ----*/
%let root=C:\Users\klarsen\Documents\BNET\BNET2.0;  

*%let root=C:\EDUC\\BNET2.0;  

%include "&root\Macros\gnbcreg.sas" ; 
%include "&root\Macros\bifurcate.sas" ; 
%include "&root\Macros\information.sas" ; 
%include "&root\Macros\gainschart.sas" ; 
%include "&root\Macros\incremental.sas" ;
%include "&root\Macros\miss.sas" ;
%include "&root\Macros\miscellaneous.sas" ;

libname bnet "&root\Data" ; 
 
title1 "Net Lift Modeling";
