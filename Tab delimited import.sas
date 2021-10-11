PROC IMPORT OUT= FOC06HMX.May_control 
            DATAFILE= "I:\Focus DIY\2006\2006 Homemovers extension\Mail files\May - FDA27249_control.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=NO;
     DATAROW=1; 
RUN;


 data FOC06HMX.May_control;
      infile 'I:\Focus DIY\2006\2006 Homemovers extension\Mail files\May - FDA27249_control.txt'
 delimiter='09'x MISSOVER DSD lrecl=32767 ;
         informat VAR1 $7. ;
         informat VAR2 $22. ;
         informat VAR3 $17. ;
         informat VAR4 $37. ;
         informat VAR5 $39. ;
         informat VAR6 $32. ;
         informat VAR7 $27. ;
         informat VAR8 $23. ;
         informat VAR9 $14. ;
         informat VAR10 $14. ;
         format VAR1 $7. ;
         format VAR2 $22. ;
         format VAR3 $17. ;
         format VAR4 $37. ;
         format VAR5 $39. ;
         format VAR6 $32. ;
         format VAR7 $27. ;
         format VAR8 $23. ;
         format VAR9 $14. ;
         format VAR10 $14. ;
     	 input
                  VAR1 $
                  VAR2 $
                  VAR3 $
                  VAR4 $
                  VAR5 $
                  VAR6 $
                  VAR7 $
                  VAR8 $
                  VAR9 $
                  VAR10 $;
run;
