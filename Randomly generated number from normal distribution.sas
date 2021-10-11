data sim;
     do i = 1 to 30;
        result = rand("normal", 0, 1);
        subject = i;
     output;
     end;
drop i;
run; 
