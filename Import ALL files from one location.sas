filename indata pipe 'ls -1 /var/opt/analysis_4/asis1/outage/*.csv';

data one;
infile indata truncover;
length fil2read $100;
input fil2read $;
infile dummy filevar=fil2read end=done dsd dlm=',' missover;
length msisdn account_desc $20. dummy $200.;
do while(not done);
file = fil2read;
input msisdn $ 
account_desc $ 
dummy $;
output;
end; 
run;

