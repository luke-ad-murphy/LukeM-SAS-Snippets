/* TRANSOPSE PROCESS */
/* 'by' part is asking for row headings */
/* 'var' is asking for field to be summed */
/* 'id' is asking for collumn headings */
proc transpose data=model1 out=sectcount (drop=_label_ _name_);
  by psect;
  var num;
  id acorn;
run;


