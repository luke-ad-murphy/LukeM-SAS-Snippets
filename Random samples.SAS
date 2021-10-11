

/********************************************************
Examples of code to select :
- a proportion of say pcnumbers from an unsorted dataset
- a fixed number or a proportion from a dataset sorted by the sampling variable

Ray Kirk 11.4.01
******************************************************/

**** If data is not sorted in order of the sampling variable ****;

* Produce a sample of 1 in X pcnumbers (eg 1:50) *;
data upcs;
	set basket.summary(obs=1000 keep=upc * Other variables of interest *;);

	seed=input(upc,12.);
	call ranuni(seed,rand);
	* This creates a random number, using the upc as a seed *;
	* The next time the upc appears in the dataset, the same random number is generated *;

	if rand<0.02;
	* Just output 1 in 50 *;
run;

proc sort; by upc; run;




* Produce a sample of exactly X pcnumbers (eg X=1000) *;
* Not so easy ! *;





**** If sorted in order of the sampling variable ****;

* Produce a sample of exactly X pcnumbers (eg X=100) *;
data sample;
	set ccard.all2001 (obs=1000);
	by pcnumber;

	retain _rand;
	if first.pcnumber then _rand=ranuni(0);
	* Generate a random number the first time the pcnumber is encountered *;
	* The retain statement will carry this value forward until the next pcnumber *;

	if _rand<0.0001;	* Choose any small value ;
	* Only consider outputting 1 in 10000 of the pcnumbers *;

	if last.pcnumber then _count+1;
	if _count=100 then stop;
	* Output all of these 1:10000 until exactly 100 have been output *;

run;




* Produce a sample of 1 in X pcnumbers (eg 1:100) *;
data sample;
	set ccard.all2001 (obs=1000);
	by pcnumber;
	retain _rand;
	if first.pcnumber then _rand=ranuni(0);
	* Generate a random number the first time the pcnumber is encountered *;
	* The retain statement will carry this value forward until the next pcnumber *;

	if _rand<0.01;	* Value = 1 / X *;
	* Output 1 in 100 pcnumbers *;
	* Datastep keeps going until the end of the input data is reached *;
run;












* If using function, only the seed value when the function is first called has any effect *;
data rand1;
do a=1 to 5;
r=ranuni(1);
output;
end;
run;


data rand2;
do a=1 to 5;
r=ranuni(2);
output;
end;
run;


* To generate numbers from different random streams use CALL *;
* the seed is updated so you get the next rand number in the series on the next call *;
data rand12;
retain s1 1 s2 2;
do a=1 to 5;
*r1=ranuni(1);
*r2=ranuni(2);
call ranuni(s1,r1);
call ranuni(s2,r2);
output;
end;
run;
