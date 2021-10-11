/* EXTRACTS A LIST OF VALUES TO SUBSEQUENTLY USE */
data prods (keep = product_id product_name);
retain fin;
length fin $400;
set adc.product_history;
where upcase(product_name) like "%LOYALTY DISCOUNT%";

fin = trim(left(fin))||trim(left(put(product_id,$10.))) || ',';
fin2 = reverse(substr(reverse(trim(left(fin))),2));

call symput('based',fin2);

run;

data _null_;
  %put &based.;
run;


/* Extract instances of loyalty discounts based on list of values */
data loyalty (keep=customer_node_id EFFECTIVE_START_DATE 
EFFECTIVE_END_DATE product_id period);
set adc.product_instance_history;
where product_id in (&based.)
run;





/* EXTRACT A SINGLE VALUE TO BE USED */
data start (keep= date_desc date_id);
set adm.dim_calendar;
where datepart(date_desc) EQ '01JAN2010'd;
call symput('start',DATE_ID);
run;

data end (keep= date_desc date_id);
set adm.dim_calendar;
where datepart(date_desc) EQ '31JAN2010'd;
call symput('end',DATE_ID);
run;


/* Exrtact content based on range created above */
data content;
set asis9.allcontent;
where date_id GE &start. 
AND date_id LE &end.; 
run;