/*COUNT*/

/* count 'this' in the string and it is case sensitive */
/* this code will output a 3 to the log                */
data one;
  xyz='This is a thistle? Yes, this is a thistle.';
  howmanythis=count(xyz,'this');
  put howmanythis;
run;


/* count 'this' in the string and ignore the case */
/* this code will output a 4 to the log           */
data one;
  xyz='This is a thistle? Yes, this is a thistle.';
  howmanythis=count(xyz,'this','i');
  put howmanythis;
run;


/*COUNTC*/

/* count lower case 'b'                      */
/* the code above will output a 1 to the log */
data one;                         
  xyz='Baboons Eat Bananas     ';   
  howmanyb=countc(xyz,'b');         
  put howmanyb;                     
run;  


/*COUNTW*/
 
/* this code will output a 6 to the log */                           
data one;                                                
  x='a string of words to count';                        
  howmany=countw(x);                                     
  put howmany;                                           
run;                                                     
