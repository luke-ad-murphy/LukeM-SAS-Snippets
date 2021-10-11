** this line of code replaces the euro sign with a £ sign in the euro format  **;
options debug=('euro=A3');


** this line of code creates a macro variable of todays date  **;
data _null_;
call symput ('date',trim(left(put(today(),worddate20.))));
run;


** this produces quite a nice graph !!  **;
goptions reset=all;


goptions border gunit=pct  ctext=black htext=2 htitle=5 ftext="optima" ;
symbol v=dot h=2 pointlabel=(c=red "#ext_prc" justify=L position=bottom ); * c=blue justify=r position=top);
goptions device=activex;

** specify destination for word document **;
*ods rtf file='c:\stu_graph.rtf';
ods html file='c:\stu_graph.html';


proc gplot data=test annotate=library.logo ;
by staff_discount;
plot trans_date * ext_prc /frame  iframe='s:\logo\ciu_logo.gif' description='my chart' ;
title stuarts title;
format trans_date dtdate9. ext_prc euro8.;
label ext_prc='Price Paid' trans_date="Date";
footnote j=r &date.;
run;
ods html close;
*ods rtf close;

quit;

data _null_ ;
  file  '.\myhtml' lrecl=32700 ;
  put "<html>" ;
  put "<head>" ;
  put "<title><bold>This is my title</bold>" ;
  put "</title>" ;
  put "<img src='s:\logo\background.bmp'>";
  put "</head>";
  put "<body><";
  put "</html>" ;
  run;