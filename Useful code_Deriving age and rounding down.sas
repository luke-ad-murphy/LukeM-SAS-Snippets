/*This piece of code shows how to create an age from a date of birth and round the age DOWN to the year*/

data customer;
set sastrain.customer;
age2005=int(('01feb2005'd-datebirth)/365);
run;
