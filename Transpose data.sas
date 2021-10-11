/* USED TO CREATE EITHER A SUM OR COUNT WITHIN THE XTAB FIELDS */
/* TO CREATE A COUNT A DUMMY VARIABLE OF ONE NEEDS TO BE CREATED WITHIN
   ORIGINAL DATASET AS THIS WILL THEN BE SUMMED TO PRODUCE THE COUNT */

/* creating dummy variable for a count */
data table;
set table;
	num=1;
run;


/* DATA NEEDS TO BE GROUPED TO HIGHEST LEVEL FIRST , eg BY ITEM THEN SEGMENT */

proc summary data=table;
class item segment;						/* in final xtab item will be row header, segment will be collumn header */
var price_paid;							/* in this case sales values are being examined, to create a */
										/* count the dummy field 'num' would need to be summed */
output out=test (drop=_type_ _freq_) sum=;
run;


/*data then needs to be sorted by potential row header */
proc sort data=test; by item; run;


/* TRANSOPSE PROCESS */
/* 'by' part is asking for row headings */
/* 'var' is asking for field to be summed */
/* 'id' is asking for collumn headings */
proc transpose data=test out=segtotals (drop=_label_ _name_);
  by item;
  var price_paid;
  id segment;
run;