%macro driver;
  %do i = 1 %to 8;
  %let J=%sysfunc(putn(&i.,z3.));
      %inv(bat = &j._01);
	  %inv(bat = &j._02);
	  %inv(bat = &j._03);
  %end;
%mend;
%driver;
