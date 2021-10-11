
* Example of creating a read only libname - Ray Kirk 20.4.01 *;


* Create libname *;
libname temp 'c:temp';

* Can now create dataset *;
data temp.test;a=1;run;


* Create readonly libname to same directory *;
libname temp2 'c:temp' access=readonly;

* Can now view datasets *;

* But cannot create data in there *;
data temp2.test;a=1;run;

* Cant delete things either *;
proc datasets lib=temp2;
delete test;
run;

* But can delete from normal libname *;
proc datasets lib=temp;
delete test;
run;
