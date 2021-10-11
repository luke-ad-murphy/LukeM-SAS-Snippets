
 data rwork.p4u;
      infile 'Z:\Advanced Analytics\Analysis\MARKETING\0536 - P4U Missing upgrades\Data\P4U Missing Upgrades.txt'
 firstobs=2 delimiter = "," MISSOVER DSD lrecl=32767 ;
         informat ID $20.;
         informat SIM $19.;
		 informat MSISDN $12.;
         informat Name $100.;
         informat Handset $50.;
		 informat Tariff $50.;
         informat Sale_Date ddmmyy10. ;
		 informat Channel $20.;

         format IMEI $20.;
         format SIM $19.;
		 format MSISDN $12.;
         format Name $100.;
         format Handset $50.;
		 format Tariff $50.;
         format Sale_Date ddmmyy10. ;
		 format Channel $20.;

input 
IMEI $
SIM $
MSISDN $
Name $
Handset $
Tariff $
Sale_Date ddmmyy10.
Channel $;

run;
