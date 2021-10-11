data connect_201508;
infile "/var/opt/analysis_4/asis1/LM/connect_201508.csv"
termstr=crlf  delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;

Informat ban $10.; 
Informat MBs best12.; 
Informat mrh_MBs best12.; 
Informat day_MBs best12.; 
Informat erh_MB best12.; 
Informat eve_MB best12.; 
Informat nt_MB best12.; 
Informat video_stream best12.; 
Informat audio_stream best12.; 
Informat browsing best12.; 
Informat facebook best12.; 
Informat twitter best12.; 
Informat message_col best12.; 
Informat days_used best12.; 

format ban $10.; 
format MBs best12.; 
format mrh_MBs best12.; 
format day_MBs best12.; 
format erh_MB best12.; 
format eve_MB best12.; 
format nt_MB best12.; 
format video_stream best12.; 
format audio_stream best12.; 
format browsing best12.; 
format facebook best12.; 
format twitter best12.; 
format message_col best12.; 
format days_used best12.; 

input
ban $
MBs 
mrh_MBs 
day_MBs 
erh_MB 
eve_MB 
nt_MB 
video_stream 
audio_stream 
browsing 
facebook 
twitter 
message_col 
days_used 
;

run;
