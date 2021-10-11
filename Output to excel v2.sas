
%* Example data *;
data test;
	name="X";age=2;surname='Z';output;
	name="Y";age=4;surname='Q';output;
run;



%* Enter sheetname & cell range - adjust cell range to size of dataset *;
filename xlData dde "excel|Sheet2!r2c1:r100c3" notab;

%* Output the data itself *;
data _null_;
	set test;

	* Open the link to excel *;
	file xlData;

	* Output variables a, b and c to adjacent columns *;
	put name '09'x age '09'x surname;
run;
