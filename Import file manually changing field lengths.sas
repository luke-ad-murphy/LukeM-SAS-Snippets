* CSV FILE;
data BGDATA.Mailings;
infile 'q:\car_data\british gas data\results database\mailings.csv' dsd truncover firstobs=2;
input src_code:$20. Info_only:best32. App_reg:best32. Booked:best32. sales:best32. 
	  sales_value:best32. src_id:best32. Camp_Id:best32. Company:$12. Product:$19.
      Media:$30. Insert:$20. Camp_Title:$30. Focus:$10. Volume:best32. Media_Costs:best32.
	  Supplier:$50. Format:$30. Size:$20. Colour:$20. Pages:$20. Creative:$100. 
	  Targeting:$100. Offer:$100. Camp_Type:$12. Cross_Sell_1_Code:$100. Cross_Sell_2:$50.
	  Cross_Sell_2_Code:$50. Cross_Sell_3:$50. JobNo:$20. startdate:date9. enddate:date9.;
format src_code:$20.; format Info_only:best32.; format App_reg:best32.;
format Booked:best32.; format sales:best32.; format sales_value:best32.;
format src_id:best32.; format Camp_Id:best32.; format Company:$12.;
format Product:$19.; format Media:$30.; format Insert:$20.;
format Camp_Title:$30.; format Focus:$10.;format Volume:best32.;
format Media_Costs:best32.; format Supplier:$50.; format Format:$30.;
format Size:$20.; format Colour:$20.; format Pages:$20.; 
format Creative:$100.; format Targeting:$100.; format Offer:$100.;
format  Camp_Type:$12.; format Cross_Sell_1_Code:$100.; format Cross_Sell_2:$50.;
format Cross_Sell_2_Code:$50.; format Cross_Sell_3:$50.; format JobNo:$20.;
format startdate:date9.; format enddate:date9.;
run;


* TEXT FILE;
 data FOC06HMX.May_control;
      infile 'I:\Focus DIY\2006\2006 Homemovers extension\Mail files\May - FDA27249_control.txt'
 delimiter='09'x MISSOVER DSD lrecl=32767 ;
         informat Title $7. ;
         informat Firstname $22. ;
         informat Surname $17. ;
         informat Address1 $37. ;
         informat Address2 $39. ;
         informat Address3 $32. ;
         informat Address4 $27. ;
         informat Address5 $23. ;
         informat Postcode $14. ;
         informat Telephone $14. ;
         informat Cardno $11. ;
         informat Store_manager $28. ;
         informat Store $35. ;
         informat Store_address $107. ;
         informat Store_phone $14. ;
         format Title $7. ;
         format Firstname $22. ;
         format Surname $17. ;
         format Address1 $37. ;
         format Address2 $39. ;
         format Address3 $32. ;
         format Address4 $27. ;
         format Address5 $23. ;
         format Postcode $14. ;
         format Telephone $14. ;
         format Cardno $11. ;
         format Store_manager $28. ;
         format Store $35. ;
         format Store_address $107. ;
         format Store_phone $14. ;
     	 input  Title $ Firstname $ Surname $ Address1 $ Address2 $ Address3 $ Address4 $
                  Address5 $ Postcode $ Telephone $ Cardno $ Store_manager $ Store $
                  Store_address $ Store_phone $;
run;


/* IMPORTING DATES */

 data rwork.p4u;
      infile 'G:\Advanced Analytics\Analysis\MARKETING\0526 - Tariff upgrade classification\Data\Phones 4u 2007 claim.txt'
 firstobs=2 delimiter = "," MISSOVER DSD lrecl=32767 ;
         informat IMEI $20.;
         informat MSISDN $12.;
         informat Flag $12.;
         informat Name $50.;
         informat Upgrade_Date ddmmyy10. ;

         format IMEI $20.;
         format MSISDN $12.;
         format Flag $12.;
         format Name $50.;
         format Upgrade_Date ddmmyy10. ;

input  IMEI $ MSISDN $ Flag $ Name $ Upgrade_Date ddmmyy10.;

run;
