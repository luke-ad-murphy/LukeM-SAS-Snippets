

data test;
	do x=1 to 10;
		y=x;output;
	end;
run;	


* To output your chart to a file instead of the graph window ... ;

* ...Put this before your procedure ... ;
filename outfile "c:\temp\my_graph.gif";
goptions device=gif gsfname=outfile htext=1.5;

* ... Now do your PROC GPLOT or whatever...;

proc gplot data=test;
	plot y*x;
run;
quit;


* ... to reset things do ...;

goptions device=win;
