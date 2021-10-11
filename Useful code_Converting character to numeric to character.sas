*Converting a character field to a numeric field;
data test;
set test;
GrossAmount_n = input(GrossAmount,8.2); *where GrossAmount_n is the required numeric field and GrossAmount is character;
CommAmount_n = input(CommAmount,8.2);
run;

*Converting a numeric field to a character field;
data test;
set test;
GrossAmount_c = put(GrossAmount,8.2); *where GrossAmount_c is the required character field and GrossAmount is numeric;
CommAmount_c = put(CommAmount,8.2);
run;
