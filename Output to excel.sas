
%* Example data *;
data test;
	a="X";b=2;output;
	a="Y";b=4;output;
run;





%* Enter sheetname & cell range for column names - adjust cell range to number of columns *;
filename xlData dde "excel|Sheet1!r1c1:r1c2" notab;

%* Output the column names *;
data _null_;
	* Open the link to excel *;
	file xlData;

	* Output variable names to adjacent columns *;
	put "store name" '09'x "store no";
run;





%* Enter sheetname & cell range - adjust cell range to size of dataset *;
filename xlData dde "excel|Sheet1!r2c1:r3c2" notab;

%* Output the data itself *;
data _null_;
	set test;
	* Open the link to excel *;
	file xlData;

	* Output variables a and b to adjacent columns *;
	put a '09'x b;
run;







%* Or use this macro which automatically picks up the variable names and size of the dataset *;
%excel2(data=test, sheet=sheet2);



%* You will first need to activate the macro library *;
%include "S:\user\ray\sas\sas library\macro setup.sas"; 
%* JUST RUN THIS LINE ONCE LOCALLY AT THE START OF A SESSION *;
