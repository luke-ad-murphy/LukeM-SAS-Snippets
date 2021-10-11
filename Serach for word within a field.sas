
/* SEARCHING FOR THE WORD MANAGER WITHIN A FIELD IN A DATASET */

data manager1;
set g.rawdata (where=(cjobtit like '%Manager%'));
run;
