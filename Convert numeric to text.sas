* Create new_cardno field by removing first digit;
data foc06oct.mailings;
set foc06oct.mailings;
format new_cardno $10.;
new_cardno = put (cardno,$10.);
run;

*** you can nest other functions in here;
new_cardno = put (COMPRESS(substr(cardno,2,10),' '),$10.);
