data data (drop=l);
set data;
length compsect $10.;
l = length(postcode);
compsect = substr(postcode,1,l-2);;
run;

