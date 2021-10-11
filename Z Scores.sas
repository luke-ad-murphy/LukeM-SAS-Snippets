/* Create scores for my factors */

data survey2;
set survey;

* Voice;
voice = sum(Q7_4, Q7_13, Q11_3, Q11_5, Q14_19);

* SMS;
sms = sum(Q7_5, Q11_4);

* Data;
data = sum(Q7_6, Q7_7, Q7_9, Q10_3, Q11_6, Q14_3, Q14_17);

* Handset;
handset = sum(Q7_1, Q7_2, Q7_3, Q10_1, Q11_2, Q14_15, Q14_16);

* Value;
value = sum(Q7_12, Q7_14, Q10_2, Q10_4, Q10_9, Q11_1, Q14_1, Q14_2, Q14_4, Q14_9, Q14_18);

* Brand & network;
brand_network = sum(Q7_8, Q10_5, Q10_6, Q14_5, Q14_6, Q14_13, Q14_11, Q14_12, Q10_8);

run;


/* Get means and standard deviations */
proc summary nway missing data = survey2;
class ;
var voice sms data handset value brand_network;
output out = data (drop = _type_);
run;

* Means and standard devs for voice sms data handset value brand_network;
/*MEAN	13.601659751	7.7012448133	18.692946058	17.031120332	29.869294606	25.553941909*/
/*STD	5.1391284991	3.0193345266	4.6150247298	5.8683642483	6.9660247003	5.663667169*/


/* Standardise scores */
data survey3;
set survey2;

voice_z 	= (voice - 13.601659751) / 5.1391284991;
sms_z		= (sms - 7.7012448133) / 3.0193345266;
data_z		= (data - 18.692946058) / 4.6150247298;
handset_z	= (handset - 17.031120332) / 5.8683642483;
value_z		= (value - 29.869294606) / 6.9660247003;
brand_network_z = (brand_network - 25.553941909) / 5.663667169;

run;



/* Rank the three most important factors */
data survey3;
set survey3;
First = max(voice_z, sms_z, data_z, handset_z, value_z, brand_network_z);
Second = largest(2, voice_z, sms_z, data_z, handset_z, value_z, brand_network_z);
Third = largest(3, voice_z, sms_z, data_z, handset_z, value_z, brand_network_z);
Fourth = largest(4, voice_z, sms_z, data_z, handset_z, value_z, brand_network_z);
Fifth = largest(5, voice_z, sms_z, data_z, handset_z, value_z, brand_network_z);
Sixth = largest(6, voice_z, sms_z, data_z, handset_z, value_z, brand_network_z);
run;



/* Names of important factors vars */
data survey3;
set survey3;

format First_n $15.;
format Second_n $15.;
format Third_n $15.;
format Fourth_n $15.;
format Fifth_n $15.;
format Sixth_n $15.;

if First = voice_z then First_n = "Voice";
else if First = sms_z then First_n = "SMS";
else if First = data_z then First_n = "Data";
else if First = handset_z then First_n = "Handset";
else if First = value_z then First_n = "Value";
else if First = brand_network_z then First_n = "Brand network";

if Second = voice_z then Second_n = "Voice";
else if Second = sms_z then Second_n = "SMS";
else if Second = data_z then Second_n = "Data";
else if Second = handset_z then Second_n = "Handset";
else if Second = value_z then Second_n = "Value";
else if Second = brand_network_z then Second_n = "Brand network";

if Third = voice_z then Third_n = "Voice";
else if Third = sms_z then Third_n = "SMS";
else if Third = data_z then Third_n = "Data";
else if Third = handset_z then Third_n = "Handset";
else if Third = value_z then Third_n = "Value";
else if Third = brand_network_z then Third_n = "Brand network";

if Fourth = voice_z then Fourth_n = "Voice";
else if Fourth = sms_z then Fourth_n = "SMS";
else if Fourth = data_z then Fourth_n = "Data";
else if Fourth = handset_z then Fourth_n = "Handset";
else if Fourth = value_z then Fourth_n = "Value";
else if Fourth = brand_network_z then Fourth_n = "Brand network";

if Fifth = voice_z then Fifth_n = "Voice";
else if Fifth = sms_z then Fifth_n = "SMS";
else if Fifth = data_z then Fifth_n = "Data";
else if Fifth = handset_z then Fifth_n = "Handset";
else if Fifth = value_z then Fifth_n = "Value";
else if Fifth = brand_network_z then Fifth_n = "Brand network";

if Sixth = voice_z then Sixth_n = "Voice";
else if Sixth = sms_z then Sixth_n = "SMS";
else if Sixth = data_z then Sixth_n = "Data";
else if Sixth = handset_z then Sixth_n = "Handset";
else if Sixth = value_z then Sixth_n = "Value";
else if Sixth = brand_network_z then Sixth_n = "Brand network";

run;





***********************************XXXXXXXX**********************************;
********************************XXXXXXXXXXXXXX*******************************;
*****************************************************************************;
*************************  E-N-D  O-F  P-R-O-G-R-A-M ************************;
*****************************************************************************;
********************************XXXXXXXXXXXXXX*******************************;
***********************************XXXXXXXX**********************************;