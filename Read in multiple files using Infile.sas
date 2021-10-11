
data mc; 
  infile datalines;
/* Ensure fully qualified path will fit in FIL2READ */
     length fil2read $40;
     input fil2read $;

  infile dummy filevar=fil2read end=done;

  do while(not done);
    
    input var1 $  var2 $;  

    output;
  end;      
datalines;
c:\temp\extfile1.txt
c:\temp\extfile2.txt
c:\temp\extfile3.txt
;          
            
