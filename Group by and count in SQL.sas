/* Group by and count / sum in SQL */;
title;
proc sql;
   select handset,n(handset) label='Count'
      from perm.table1, perm.table2
      where table1.id = table2.id
      group by handset;
quit;
