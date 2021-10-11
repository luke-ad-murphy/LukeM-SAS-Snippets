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
