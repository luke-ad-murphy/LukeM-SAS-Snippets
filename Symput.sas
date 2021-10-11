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



