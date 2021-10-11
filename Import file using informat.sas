data rwork.STARS_NRQ;
infile 'G:\Advanced Analytics\Analysis\MARKETING\0491 - STARS\N4317 Full Database Apr 07 - Feb 08.csv'
delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;

Informat Urn $100.; 
Informat mobile_num best12.; 
Informat cust_type $20.; 
Informat package_desc $20.; 
Informat account_desc $10.; 

Format Urn $100.; 
Format mobile_num best12.; 
Format cust_type $20.; 
Format package_desc $20.; 
Format account_desc $10.; 

input
Urn $
mobile_num $
cust_type $
package_desc $
account_desc $;

label Urn = "Inter Number";
label mobile_num = "OriginalTelephoneNumber";
label cust_type = "Customer Type";
label package_desc = "Package Name";
label account_desc = "AccountDescription";

run;
