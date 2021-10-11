/* Please email to:

Luke.Murphy@three.co.uk

*/

libname perm 'C:\user';

%include printnum / SOURCE2;



/* Displays all automatic macro vars in the log */
%put _automatic_;
/* Displays all user defined macro vars in the log */
%put _user_;
/* Displays ALL automatic and user defined macro vars in the log */
%put _all_;

/* Write bits of text to the log */
%put today is &sysday;
%put Luke Murphy;
%put Today is &sysday;
%put Version is &sysver;
%put Last file used was &syslast;


proc sort data = perm.schedule out = work.sorted;
by course_number begin_date;
run;


/* shows you if your macro code is ok */
options mcompilenote = all;


/*******************/


%let table1 = schedule;
%let table2 = register;
%let joinvar = course_number;
%let freqvar = location;


/* Delete the macro variable 'x' */
%symdel x;



/* Group by and count / sum in SQL */;
title;
proc sql;
   select &freqvar,n(&freqvar) label='Count'
      from perm.&table1, perm.&table2
      where &table1..&joinvar = &table2..&joinvar
      group by &freqvar;
quit;



%let table1 = students;
%let table2 = register;
%let joinvar = student_name;
%let freqvar = city_state;

title;
proc sql;
   select &freqvar,n(&freqvar) label='Count'
      from perm.&table1, perm.&table2
      where &table1..&joinvar = &table2..&joinvar
      group by &freqvar;
quit;


/***********/

%let Pattern = Ba;

options nocenter;
proc print data=perm.all noobs label uniform;
   where student_name contains "&Pattern";
   by student_name student_company;
   var course_title begin_date location teacher;
title  'Courses Taken by Selected Students:';
title2 'Those with Babbit in Their Name';
Footnote "Report created on &sysdate9";
run;

%put Today is &sysday;
%put Version is &sysver;
%put Last file used was &syslast;

%put _automatic_;
%put _user_;
%put _all_;

/***************/

%let dsn = &syslast;
%let libref = %upcase(%scan(&dsn,1));
%let file = %upcase(%scan(&dsn,2,.));


title "Variables in &dsn";
proc sql;
   select name, type, length
      from dictionary.columns
      where libname = "&libref" and
            memname = "&file";
quit;
 

/***************/

* 3-18;
%let num = 3;

options mprint symbolgen;

%macro print;
proc print data=perm.all label noobs n;
   where course_number=&num;
   var student_name student_company;
   title "Enrollment for Course &num";
run;
%mend print;

%let num = 8;

%print


/*-**************/

* 3-36;

options mprint symbolgen;
options mcompilenote = all;
%macro printnum (Num = 1);
proc print data=perm.all label noobs n;
   where course_number = &Num;
   var student_name student_company;
   title "Enrollment for Course &Num";
run;
%mend;

%printnum (Num = 8)
%printnum (Num = 10)
%printnum ()



/********************/;


/* Symput used when creating a macro within a dataset */
/* Allows the value assigned of the macro to change as shown below */

options symbolgen pagesize=30;
%let crsnum=3;
data revenue;
   set perm.all end=final;
   where course_number = &crsnum;
   total + 1;
   if paid = 'Y' then paidup+1;
   if final then do;
      if paidup < total then do;
         call symput('foot','Some Fees Due');
      end;
      else do;
         call symput('foot','All Students Paid');
      end;
   end;
run;
proc print data=revenue;
   var student_name student_company paid;
   title "Paid Status for Course &crsnum";
   footnote "&foot";
run;

%put foot = &foot;



/********************/;


options symbolgen pagesize=30;
%let crsnum=3;
data revenue;
   set perm.all end=final;
   where course_number=&crsnum;
   total+1;
   if paid='Y' then paidup+1;
   if final then do;
      call symput('numpaid',paidup);
      call symput('numstu',total);
      call symput('crsname',course_title);
   end;
run;
proc print data=revenue noobs;
   var student_name student_company paid;
   title "Fee Status for &crsname (#&crsnum)";
   footnote "Note: &numpaid out of &numstu paid";
run;


options symbolgen pagesize=30;
%let crsnum=3;
data revenue;
   set perm.all end=final;
   where course_number=&crsnum;
   total+1;
   if paid='Y' then paidup+1;
   if final then do;
      call symput('numpaid',trim(left(paidup)));
      call symput('numstu',trim(left(total)));
      call symput('crsname',trim(course_title));
   end;
run;
proc print data=revenue noobs;
   var student_name student_company paid;
   title "Fee Status for &crsname (#&crsnum)";
   footnote "Note: &numpaid out of &numstu paid";
run;


/* Symput X will get rid of trailing and preceeding blanks */
/* Good for using when concatenating and formatting fields */
options symbolgen pagesize=30;
%let crsnum=3;
data revenue;
   set perm.all end=final;
   where course_number=&crsnum;
   total+1;
   if paid='Y' then paidup+1;
   if final then do;
      call symputx('crsname',course_title);
      call symputx('date',put(begin_date,mmddyy10.));
      call symputx('due',put(fee*(total-paidup),dollar8.));
   end;
run;
proc print data=revenue;
   var student_name student_company paid;
   title "Fee Status for &crsname (#&crsnum) Held &date";
   footnote "Note: &due in Unpaid Fees";
run;


/********************/;

* 4-26;

options nodate;
options symbolgen pagesize=30;

data test;
call symput ('date',put(today(),WORDDATE20.));
run;


proc print data = perm.courses;
title "Courses Offered as of &date";
run;


data test;
call symputx ('date',put(today(),WORDDATE20.));
run;

proc print data = perm.courses;
title "Courses Offered as of &date";
run;


/********************/;


* 4-49;

* create a series of macro variables and then call them;
* good for using as a lookup table?;

data _null_;
set perm.schedule;
call symputx('START'||left(course_number),put(begin_date,mmddyy10.));
run;

%let crs=4;
proc print data=perm.all noobs n;
   where course_number=&crs;
   var student_name student_company;
   title1 "Roster for Course &crs";
   title2 "Beginning on &&START&crs";
run;



/********************/;

/* Symget function */
/* Can be used in table lookup applications */

* 4-60;

/* 'start'||trim(left(course_number)) is telling you what the macro var will be called */
/* put(begin_date,mmddyy10.)) is assigning the value to the macro variable */


data _null_;
   set perm.schedule;
   call symput('start'||trim(left(course_number)),
               put(begin_date,mmddyy10.));
run;

%put _user_;

data outstand;
set perm.register;
where paid = 'N';
format begin date9.;

/* here the 'input' part is changing the answer to numeric so that it can be formatted as a date */
/* it is looking up start which is 'start'  and course number (trim left aligned)
e.g. 'Start1' from the macro vars created above and reading in the corresponding date */

begin = input(symget('start'||left(course_number)),mmddyy10.);

run;

/* Sygmet always reads in $200. format as a default */



/********************/;


/* Creating macro vars in proc SQL */

* 4-74;

* use this for creating lookups in sql;
* might be more efficient than doing an SQL join;

proc sql noprint;
	select begin_date format = mmddyy10.
		into: start1 - :start18
	from perm.schedule;
quit;

%put _user_;

%let num=4;
proc print data=perm.all noobs n;
   where course_number=&num;
   var student_name student_company;
   title "Roster for Course &num Beginning on &&start&num";
run;


/* If you don't know how many classes there are... */
proc sql noprint;
	select count(*)
		into: numrows
		from perm.schedule;

/* %let will remove trailing and preceeding blanks from the macro vars created above */
%let numrows = &numrows;
	
	select begin_date format = mmddyy10.
		into: start1 - :start&numrows
		from perm.schedule;
quit;

%let num = 4;
proc print data=perm.all noobs n;
   where course_number=&num;
   var student_name student_company;
   title "Roster for Course &num Beginning on &&start&num";
run;



/********************/;

*5-20;

/* checks the logic and resolves macro vars */
options mlogic;


/* Using logic statements within macros */
%macro paid(crsnum);
%if &crsnum GE 1 and &crsnum LE 18 %then %do;
  proc print data=perm.register label n noobs;
    var student_name paid;
    where course_number=&crsnum;
  title "Fee Status for Course &crsnum";
  run;
  	%end;

	%else %do;
		%put Course Number must be between 1 and 18;
		%put Supplied value was: &crsnum;
	%end;

%mend paid;

%paid(2)
%paid(47)


/* Using nested logic statements within macros */
%macro paid(crsnum, status);
%let first = %upcase(%substr(&status,1,1));

	%if &first = Y or &first = N %then %do;
		%if &crsnum GE 1 and &crsnum LE 18 %then %do;
    		 proc print data=perm.register label n noobs;
		 	var student_name paid;
   		 	where course_number=&crsnum;
		 	where also paid = "&first";
  	title "Fee Status for Course &crsnum";
  	run;
	  	%end;

		%else %do;
			%put Course Number must be between 1 and 18;
			%put Supplied value was: &crsnum;
		%end;
	%end;

	%else %do;
		%put Status must begin with Y or N;
		%put Supplied value was: &status;
	%end;

%mend paid;

%paid(2,Y)
%paid(2,no)
%paid(2,?)




%macro printit;
   %if &syslast = _NULL_ %then %do;
     proc print data=_last_(obs=5);
       title "Listing of data set &syslast";
     run;
   %end;
%mend;

options mlogic mprint symbolgen;
%printit;



/********************/;

*5-40;

/* Do loops within macros */

%macro printnum;
	%do Num = 1 %to 18;
		proc print data=perm.all label noobs n;
   			where course_number = &Num;
   			var student_name student_company;
   			title "Enrollment for Course &Num";
		run;
	%end;
%mend;

options mlogic mprint symbolgen mcompilenote = all;

%printnum



%macro print (dsn, var, type = CHAR);
%let dsn = %upcase(&dsn);
%let var = %upcase(&var);
%let type = %upcase(&type);

/* This will count how many unique categories there are by the chosen var from &var */
proc sort data = &dsn(keep = &var) out = unique nodupkey;
by &var;
run;

data _null_;
set unique end = final;
call symput('value'||left(_n_),trim(left(&var)));
if final then call symput('count',_n_);
run;

%do i = 1 %to &count;
proc print data = &dsn;
	%if &type = CHAR %then %do;
		where &var = "&&value&I";
	%end;
	%else %do;
		where &var = &&value&i;
	%end;
	title1 "Listing od &dsn Data set";
	title2 "for &var = &&value&i";
run;
%end;
%mend print;

%print (perm.schedule, location)
%print (perm.courses, Days, type = num)



/********************/;


*5-61;

options mlogic mprint symbolgen mcompilenote = all;

%macro datemar(fmt = date9.);
  data _null_;
    call symput('today',trim(left(put(today(),&fmt))));
  run;
%mend datemar;


%macro prtrost(num=1);
	%local today;
	%datemvar (fmt = mmddyy10.);
  proc print data=perm.all label noobs n;
    where course_number=&num;
    var student_name student_company city_state;
    title1 "Enrollment for Course &num as of &today";
  run;
%mend prtrost;

%prtrost(num=8)
