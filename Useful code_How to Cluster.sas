/*SD Framework - Clustering*/


libname jul05 'Q:\car_data\roy_mail\RMD\Monthly Download\Jul05m\Sas Data';
libname fwork 'Q:\car_data\roy_mail\2005 Financial Year\UK Mails\Deliver Your Promises\Special Delivery\SD Framework\SAS Data';
libname view slibref=work server=server;

libname jul05 'N:data\car_data\roy_mail\RMD\Monthly Download\Jul05m\Sas Data';
libname fwork 'N:data\car_data\roy_mail\2005 Financial Year\UK Mails\Deliver Your Promises\Special Delivery\SD Framework\SAS Data';


/*Two files have been prepared, the first looking at 0-24 mths sr-rev the second 0-12mth*/

/*This cluster analysis looks at 0-12mth rev*/

/* if var is ordered can standardise right away.if var is categorical (e.g. total rev ) then must make binary - this is not
   preferable as would then have to do this for all vars  */

/*Standardise varibales*/

proc standard data=fwork.pos_sdrevdata_12 out=stan_a mean=0 std=1;
 var total_sdrev_12 sdfreq_12 sdrec;
run;

/*This produces a temp file (stan) with the variables standardised*/

/* Next is the first cluster stage (K-Means) which produces a maximum of 200 clusters and
deletes any clusters with less than 25 records*/

proc fastclus data=stan_a maxclusters=200 maxiter=50 conv=0.01
              mean=mean delete=25 out=out;
  var total_sdrev_12 sdfreq_12 sdrec;
  id bc;
run;

/*Produces two temp file mean and out*/

/*The next cluster analysis (hierarchical) combines the first analysis into many
clusters, all the way down to one, use the reports to identify the number of clusters 
which look to be most significant*/

proc cluster data=mean method=ward rsq ccc pseudo simple
     outtree=tree_a;
  var total_sdrev_12 sdfreq_12 sdrec;
  id cluster;
run;

/* produces tree which contains a list of the clusters with their
respective means for each var, along with the new cluster applications */

/*In this cast new segments 5,6,7 were identified as being possible solutions
beginning with segment 7 look produce detailed information*/

proc tree data=tree_a n=10 out=treeout10 noprint;
 copy cluster total_sdrev_12 sdfreq_12 sdrec;
run;

/*clusnames are new clusters 1-7 */
proc sort data=treeout10; by clusname; run;

/* calculates new means for each of the 7 */
proc means data=treeout10 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clusname;
run;

data treeout10;
 set treeout10;
 rename clusname= clus10;
run;

proc tree data=tree_a n=9 out=treeout9 noprint;
 copy cluster total_sdrev_12 sdfreq_12 sdrec;
run;

/*clusnames are new clusters 1-7 */
proc sort data=treeout9; by clusname; run;

/* calculates new means for each of the 7 */
proc means data=treeout9 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clusname;
run;

data treeout9;
 set treeout9;
 rename clusname= clus9;
run;
/*************************************************/

proc tree data=tree_a n=7 out=treeout7 noprint;
 copy cluster total_sdrev_12 sdfreq_12 sdrec;
run;

/*clusnames are new clusters 1-7 */
proc sort data=treeout7; by clusname; run;

/* calculates new means for each of the 7 */
proc means data=treeout7 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clusname;
run;

data treeout7;
 set treeout7;
 rename clusname= clus7;
run;

/* repeat for 6 cluster solution */
proc tree data=tree_a n=6 out=treeout6 noprint;
 copy cluster total_sdrev_12 sdfreq_12 sdrec;
run;

/*clusnames are new clusters 1-6 */
proc sort data=treeout6; by clusname; run;

proc means data=treeout6 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clusname;
run;

data treeout6;
 set treeout6;
 rename clusname= clus6;
run;

/* repeat for 5 cluster solution */
proc tree data=tree_a n=5 out=treeout5 noprint;
 copy cluster total_sdrev_12 sdfreq_12 sdrec;
run;

/*clusnames are new clusters 1-5 */
proc sort data=treeout5; by clusname; run;

proc means data=treeout5 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clusname;
run;

data treeout5;
 set treeout5;
 rename clusname= clus5;
run;


/*proc sort data=treeout10; by cluster;*/
/*proc sort data=treeout9; by cluster;*/
proc sort data=treeout7; by cluster;
/*proc sort data=treeout6; by cluster;*/
/*proc sort data=treeout5; by cluster;*/
proc sort data=out; by cluster;run;

/*merge all cluster solns onto original out file from proc fastclus, by
  cluster, to get list of urns with appropriate clusters */
/*cluster is 1-141 */
data solution_a(compress=yes);
 merge	/*treeout10 (in=a keep=cluster clus10)*/
/*      	treeout9 (in=b keep=cluster clus9)*/
		treeout7 (in=c keep=cluster clus7)
/*      	treeout6 (in=d keep=cluster clus6)*/
/*		treeout5 (in=e keep=cluster clus5)*/
		out (in=f keep=bc cluster);
 by cluster;
 if /*a and b and*/ c /*and d and e*/ and f ;
run;

proc sort data=solution_a; by bc; run;

/* merge solution to pos_revdata to see all vars with actual values */
data /*fwork.*/soln2(compress=yes);
 merge solution_a(in=a) fwork.pos_sdrevdata_12(in=b);
 by bc;
 if a and b;
run;

/*Run a series of proc means on each cluster to determine actual mean valuses for each cluster*/

proc sort data=fwork.soln2; by clus10; run;

proc means data=fwork.soln2 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clus10;
run;


proc sort data=fwork.soln2; by clus9; run;

proc means data=fwork.soln2 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clus9;
run;


proc sort data=/*fwork.*/soln2; by clus7; run;

proc means data=/*fwork.*/soln2 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clus7;
 output out=stats mean=;
run;


proc sort data=fwork.soln2; by clus6; run;

proc means data=fwork.soln2 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clus6;
run;


proc sort data=fwork.soln2; by clus5; run;

proc means data=fwork.soln2 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clus5;
run;

/*Proc freq to check spread of actual values of clusters*/

	proc format;
	value sdrevband 
				low-0='£0'
				1-1000='£1-£999'
				1000-4999='£1,000-£4,999'
				5000-9999='£5,000-£9,999'
				10000-49999='£10,000-£49,999'
				50000-99999='£50,000-£99,999'
				100000-249999='£100,000-£249,999'
				250000-high='£250,000+';

	run;

proc freq data=fwork.soln2;
	tables (total_sdrev_12 sdfreq_12 sdrec sdfir_12)*clus7/missing norow nocol;
	format total_sdrev_12 sdrevband.;
	run;

/* Cluster 7 seems to provide the best solution, although it is felt four clusters should be
	combined into to two larger clusters*/

data fwork.soln2;
	set fwork.soln2;
	if clus7 = 'CL10' then cluster = 1;
	else if clus7 = 'CL13' then cluster = 1;
	else if clus7 = 'CL15' then cluster = 3;
	else if clus7 = 'CL18' then cluster = 5;
	else if clus7 = 'CL7' then cluster = 5;
	else if clus7 = 'CL8' then cluster = 2;
	else if clus7 = 'CL9' then cluster = 4;
	run;

/*for further analysis we want to add on the compseg and mkt sector from the site file*/


data temp1 (keep=bc mktsect compseg empband);
	set jul05.site;
	run;

	
proc sort data=temp1; by bc; run;
	
proc sort data=fwork.soln2; by bc; run;




proc discrim data=fwork.soln2 testdata=fwork.soln2 testout=newp testoutd=newd
                  method=normal pool=no short noclassify crosslisterr;
 class cluster;
* priors proportional;
 var total_sdrev_12 sdfreq_12 sdrec;   
run;


data forstan;
 set fwork.soln2;
 if total_sdrev_12 > 128349 then cut_sdrev_12 = 128349;
 else cut_sdrev_12=total_sdrev_12;
run;
 
/* check means of actual values as opposed to standardised */
proc sort data=forstan; by cluster;
proc means data=forstan noprint;
 by cluster;
 var cut_sdrev_12 sdfreq_12 sdrec;
 output out=cluster_means(drop=_type_ _freq_) mean=;
run;

proc standard data=forstan out=stan mean=0 std=1;
 var cut_sdrev_12 sdfreq_12 sdrec ;
 run;

/* derive file of standardised means for clustering with */
proc sort data=stan; by cluster;
proc means data=stan noprint;
 by cluster;
 var cut_sdrev_12 sdfreq_12 sdrec;
 output out=fwork.cluster_means(drop=_type_ _freq_) mean=;
run;

/* reename original cluster so we don't overwrite it */
data test(keep=bc cluster cut_sdrev_12 sdfreq_12 sdrec rename=(cluster=sdcluster));
 set stan;
 run;

proc fastclus data=test maxiter=0 replace=none maxc=5 conv=0.01
              mean=fwork.cluster_means out=out;
  var cut_sdrev_12 sdfreq_12 sdrec;
  id bc;
run;
  
/* check accuracy */
proc freq data=out;
 tables sdcluster*cluster;
 run;
