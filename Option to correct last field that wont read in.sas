data regularity_jul14;
infile '/var/opt/analysis_4/asis1/EZ/3870_mbb_daily_jul14_summary.csv' 
termstr=crlf 
firstobs = 1 delimiter = ","  MISSOVER DSD lrecl = 32767;
