*Using Index to find a string of characters within a field;

data temp;
 set temp;
 upvar=upcase(var); /* make sure to upper case field first to account for small and caps */
 flag=index(upvar,'VICTORIA');       
run;

/* if upvar contains VICTORIA then flag will be > 0 */ 
