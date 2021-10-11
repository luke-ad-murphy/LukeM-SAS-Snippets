/****************************/
/*	SPEARMAN'S RANK TEST	*/
/* 							*/
/*	Chris Rees 	06/09/04	*/
/****************************/

/*Assign libname for the library containing the file to be analysed*/

%macro spearman(lib= ,file=,var1=,var2=,group=);

options mprint /*symbolgen*/ mlogic;

/*Rank the two varibales*/

proc rank data=&lib..&file out=var1 groups=&group.;
	var &var1.;
	ranks &var1._rank;
run;

proc rank data=var1 out=var2 groups=&group.;
	var &var2.;
	ranks &var2._rank;
run;

/*Create d and d squared*/
data var2;
	set var2;
	d=&var1._rank-&var2._rank;
	d2=d*d;
	dummy=1;
run;

/*create sum of d squared*/
proc means data=var2 noprint;
	var d2;
	by dummy;
	output out=d2 sum=;
run;

/*Carry out Spearman's rank correlation*/
data d2;
	set d2(rename=(_FREQ_=n));
	rs=1-((6*d2)/(n*((n*n)-1)));
run;

/*Look up on tables to see if rs value is significant*/

%mend spearman;

%spearman(lib=ppg ,file=pagerev_rank,var1=page,var2=rev,group=14);
/*Lib is the library that the file is contained in*/
/*File is the name of the file which you want to carry out the Spearman's rank correlation
	The file should only contain the two variables that you want to analyse*/
/*Var1 is one of the variables you want to analyse*/
/*Var2 is the other variable you want to analyse*/
/*Group is the number of groups that the file contains*/


/*Look at d2 in the view library and look up the d2 value in a stats book*/
