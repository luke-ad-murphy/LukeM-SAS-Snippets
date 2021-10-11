/* try this,  all you need to do is change the working directory to the one you are on (you can see this in the work folder properties).  This will only show the files under your username as you do not have rights to see the others. */
/* I would not let everyone run code like this as it will fill the system with dummy files. */

x 'cd /var/opt/sas/sas_working1';
x 'du -a > base.txt';

filename test '/var/opt/sas/sas_working1/base.txt';
data x;
length size $20. name $100.;
infile test dlm='09'x;
input size $ name $;
run;
