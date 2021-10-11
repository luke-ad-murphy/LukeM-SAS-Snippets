*The data set here holds 24 revenue fields which have been read in as character because they all start with a + or -.
This array is to compress the + from each and convert the resultant fields to numeric.  All 24 are done at the same
time, hence using an array;

*NB accrev1 - accrev24 are all the revenue fields;

data dd.revenue1 (drop = i accrev1 accrev2 accrev3 accrev4 accrev5 accrev6 accrev7 accrev8 accrev9 accrev10 
                  accrev11 accrev12 accrev13 accrev14 accrev15 accrev16 accrev17 accrev18 accrev19 accrev20 
                  accrev21 accrev22 accrev23 accrev24);
set dd.revenue; *(below, plus and conv are the two different array names);
length accrevnew1 accrevnew2 accrevnew3 accrevnew4 accrevnew5 accrevnew6 accrevnew7 accrevnew8 accrevnew9 accrevnew10
                   accrevnew11 accrevnew12 accrevnew13 accrevnew14 accrevnew15 accrevnew16 accrevnew17 accrevnew18 accrevnew19
       accrevnew20 accrevnew21  accrevnew22 accrevnew23 accrevnew24 8.;
array plus(24) accrev1 -- accrev24; *if you don't know how many times the process is to be repeated put (*);
array conv (24) accrevnew1 -- accrevnew24;
 do i= 1 to 24; *if you have used an (*) above, put here do i=1-dim(plus) - this is the amount of times 
                                                                the process will run (where (plus) is the array name);
   plus(i) = compress(plus(i),'+'); *to compress + out of them;
   conv(i) = input(plus(i),8.);  *to convert fields to numeric values;
 end;
run;
