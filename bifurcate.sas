%macro bifurcate(data=, out=, task=, treatment=, value=0, y=, id=); 
   %local TempData MPRINTopt NOTESopt;
   %if %sysfunc(exist(&data))=0 %then %do;
       %put ERROR: File &data does not exist;
       data _null_;
          abort;
       run;
   %end;

   %let TempData=work.r%sysfunc(round(10000000*%sysfunc(ranuni(0))));
   %let TempMap=&TempData.M;

   %let MPRINTopt=%OptionFlag(MPRINT);

   %if (&MPRINTopt eq 1) %then %do;
      options nomprint;
   %end;

   %let NOTESopt=%OptionFlag(NOTES);

   %if (&NOTESopt eq 1) %then %do;
      options nonotes;
   %end;

   proc contents data=&data out=&TempData noprint; 
   run; 

   proc sql noprint;
      select max(varnum) into :nvars
      from &TempData; 
   quit; 

   %put; 
   %put Treatment: &treatment; 
   %put; 
   %put Dependent variable: &y; 
   %put; 
   %put Task: &task; 
   %put;  

   %let flag=%upcase(&treatment); 
   %let id=%upcase(&id);
   %let y=%upcase(&y); 

   %if (%upcase(%bquote(&task)) ne DEV) and (%upcase(%bquote(&task)) ne DEPLOY) %then %do; 
      %put ERROR: TASK options are neither DEV or DEPLOY; 
      data _null_;
         abort;
      run;
   %end;

   %do i=1 %to &nvars; 
       data _null_; 
          set &TempData;
          if _n_=&i; 
        call symputx("var&i",upcase(name)); 
          call symputx("type&i",type); 
        length=max(length,3);
          call symputx("length&i",length); 
        call symputx("namelength&i",length(compress(name))); 
      run;

      %if &&namelength&i>30 %then %do; 
         %put Name for variable=&&var&i is too long to create bifurcated pair;
         %put; 
      %end;  

   %end; 

   data _null_; 
      set &TempData end=eof; 
      match1+(upcase(name)=%upcase("&y"));
      match2+(upcase(name)=%upcase("&id"));
      match3+(upcase(name)=%upcase("&treatment"));
      error=0;
      if eof then do; 
        %if %upcase(&task)=DEPLOY %then %do; 
           if match2=0 then do; 
                put "ERROR: The ID variable does not exist";
             error=1;
           end; 
        %end; 
          %if %upcase("&task")="DEV" %then %do; 
           if match1=0 then do; 
                put "ERROR: The dependent variable does not exist";
             error=1;
             end; 
           if match3=0 then do; 
                put "ERROR: The treament flag does not exist";
            error=1;
           end;
          %end; 
          if error then abort;
      end; 
   run;  
 
   %if (&MPRINTopt eq 1) %then %do;
      options mprint;
   %end;

   %if (&NOTESopt eq 1) %then %do;
      options notes;
   %end;

   %if %upcase(%bquote(&task))=DEV %then %do;       
    data &out (drop=&treatment); 
       set &data; 
          %do i=1 %to &nvars;
            %if &&namelength&i<31 and %upcase("&&var&i") ne %upcase("&treatment") and %upcase("&&var&i") ne %upcase("&y") and %upcase("&&var&i") ne %upcase("&id") %then %do;            
                %if &&type&i=1 %then %do; 
                   if &treatment=1 then do; 
                      &&var&i.._t=&&var&i;
                      &&var&i.._c=&value;
                 end;
                   else do; 
                      &&var&i.._c=&&var&i;
                      &&var&i.._t=&value;
                   end;  
              %end;
              %else %do; 
                 length &&var&i.._t $&&length&i &&var&i.._c $&&length&i;  
                   if &treatment=1 then do; 
                      &&var&i.._t=&&var&i;
                      &&var&i.._c='_T_';
                 end;
                   else do; 
                      &&var&i.._c=&&var&i;
                      &&var&i.._t='_C_';
                   end;  
                %end; 
              drop &&var&i;
             %end;
          %end;  
       run;
   %end; 
   %else %do; 
      data &out; 
         set &data; 
          %do i=1 %to &nvars;
            %if &&namelength&i<31 and %upcase("&&var&i") ne %upcase("&treatment") and %upcase("&&var&i") ne %upcase("&y") and %upcase("&&var&i") ne %upcase("&id") %then %do;   
                %if &&type&i=1 %then %do;  
                   &&var&i.._t=&&var&i;
                   &&var&i.._c=&value;
             %end; 
              %else %do; 
                 length &&var&i.._t $&&length&i &&var&i.._c $&&length&i;  
                   &&var&i.._t=&&var&i;
                   &&var&i.._c='_T_';
              %end; 
            drop &&var&i; 
             %end;
          %end;
        _cell_='T'; 
          output; 
          %do i=1 %to &nvars;
            %if &&namelength&i<31 and "&&var&i" ne "&treatment" and "&&var&i" ne "&y" and "&&var&i" ne "&id" %then %do;   
                %if &&type&i=1 %then %do;  
                   &&var&i.._c=&&var&i;
                   &&var&i.._t=&value;
             %end; 
              %else %do; 
                 length &&var&i.._t $&&length&i &&var&i.._c $&&length&i;  
                   &&var&i.._c=&&var&i;
                   &&var&i.._t='_C_';
              %end;
                drop &&var&i; 
             %end;
          %end;
        _cell_='C'; 
        output; 
       run; 
    %end; 

   %put %eval(&nvars-2) variables succesfully bifurcated; 

   proc delete data=&TempData; 
   run;  

   %if (&MPRINTopt eq 1) %then %do;
      options mprint;
   %end;

   %if (&NOTESopt eq 1) %then %do;
      options notes;
   %end;

%mend bifurcate;
