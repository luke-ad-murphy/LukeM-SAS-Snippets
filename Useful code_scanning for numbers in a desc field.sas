data test;
set an.file_all;
	do i = 1 to length(proddesc);
		if substr(proddesc,i,1) in ('1', '2', '3', '4', '5', '6', '7', '8', '9', '0') then output;
	end;
run;
