data test;
infile "Z:\WLM files\0801\file.csv"
delimiter = "," MISSOVER DSD lrecl = 32767 firstobs = 8;

informat User_id $9.;
informat MSISDN $14.;
informat IM_Sent best32.;
informat IM_Recv best32.;
informat Email_sent best32.;
informat Email_recv best32.;
informat Logins best32.;
informat Logouts best32.;
informat Handset $10.; 

format User_id $9.;
format MSISDN $14.;
format IM_Sent best12.;
format IM_Recv best12.;
format Email_sent best12.;
format Email_recv best12.;
format Logins best12.;
format Logouts best12.;
Format Handset $10.; 

input
User_id $
MSISDN $
IM_Sent
IM_Recv
Email_sent
Email_recv
Logins
Logouts 
Handset $
;

run;
