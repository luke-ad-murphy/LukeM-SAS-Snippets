*Run this remotely and locally;
proc format;
value rev
low-0 = 'Negative or zer revenue'
0.1-5000 = '£0-£5,000'
5000.1-25000 = '£5,000-£25,000'
25000.1-high = '£25,000+';

run;

*Now for your proc freq;

proc freq data = rm;
tables totrmrevl12 /missing out = ;
format totrmrevl12 rev.;
run;

