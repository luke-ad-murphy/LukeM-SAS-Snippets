ods rtf file ="/var/opt/analysis_4/asis2/business main contents.rtf"; ** reference the SAMBA drive - it wont work unless you do this;
proc contents data=asis9.business_main_kb position; ** data dictionary of business main;
run;
ods rtf close; ** don't forget to close, rtf = rich text, html=web page etc..;
