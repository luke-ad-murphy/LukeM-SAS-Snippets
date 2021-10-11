
/* DATA PREP */

/* check for outliers in rev field (other two variables only have values from 1-12 */
proc univariate data=fwork.pos_sdrevdata_12;
	var total_sdrev_12;
	run;


data fwork.pos_sdrevdata_12;
	set fwork.pos_sdrevdata_12;
	if total_sdrev_12 > 128349 then cut_sdrev_12 = 128349;
	else cut_sdrev_12 = total_sdrev_12;
	run;

proc standard data=fwork.pos_sdrevdata_12 out=stan_a mean=0 std=1;
 var cut_sdrev_12 sdfreq_12 sdrec;
run;

proc fastclus data=stan_a maxclusters=200 maxiter=50 conv=0.01
              mean=mean delete=25 out=out;
  var total_sdrev_12 sdfreq_12 sdrec;
  id bc;
run;

proc cluster data=mean method=ward rsq ccc pseudo simple
     outtree=tree_a;
  var total_sdrev_12 sdfreq_12 sdrec;
  id cluster;
run;

/* produces tree which contains a list of the clusters with their
respective means for each var, along with the new cluster applications */

/*In this cast new segments 5,6,7 were identified as being possible solutions
beginning with segment 7 look produce detailed information*/

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


proc sort data=treeout7; by cluster;
proc sort data=treeout6; by cluster;
proc sort data=treeout5; by cluster;
proc sort data=out; by cluster;run;

/*merge all cluster solns onto original out file from proc fastclus, by
  cluster, to get list of URNs with appropriate clusters */
data solution_a(compress=yes);
 merge	treeout7 (in=a keep=cluster clus7)
      	treeout6 (in=b keep=cluster clus6)
		treeout5 (in=c keep=cluster clus5)
		out (in=d keep=bc cluster);
 by cluster;
 if a and b and c and d  ;
run;

proc sort data=solution_a; by bc; run;

/* merge solution to original analysis file to see all vars with actual values (ie with outliers) */
data fwork.soln2(compress=yes);
 merge solution_a(in=a) fwork.pos_sdrevdata_12(in=b);
 by bc;
 if a and b;
run;

/*Run a series of proc means on each cluster to determine actual mean values for each cluster*/

proc sort data=fwork.soln2; by clus7; run;
proc means data=fwork.soln2 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clus7;
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
	combined into two larger clusters*/

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


/* Applying the solution to other records */

/* double check freqs and means to ensure data is right and consistent before we start! */
proc freq data=fwork.soln2;
 tables cluster; run;
proc sort data=fwork.soln2; by cluster;
proc means data=fwork.soln2 noprint;
 by cluster;
 var total_sdrev_12 sdfreq_12 sdrec;
 output out=cluster_means(drop=_type_ _freq_) mean=;
run;

/* firstly need a standardised means file of the original 7 cluster solution */
/* got stats from 'Cluster work - 12month sdreva' programme */
data fwork.cluster_means; 
 set stats(drop=_type_ _freq_);
 rename total_sdrev_12=cut_sdrev_12;
run;

/* proc fastclus */

/* first of all get rid of outliers again */
data forstan;
 set fwork.soln2;
 if total_sdrev_12 > 128349 then cut_sdrev_12 = 128349;
 else cut_sdrev_12=total_sdrev_12;
run;
 
proc standard data=forstan out=stan mean=0 std=1;
 var cut_sdrev_12 sdfreq_12 sdrec ;
 run;

data test(keep=bc clus7 cut_sdrev_12 sdfreq_12 sdrec);
 set stan;
 run;

proc fastclus data=test maxiter=0 replace=none maxc=7 conv=0.01
              seed=fwork.cluster_means out=out;
  var cut_sdrev_12 sdfreq_12 sdrec;
  id bc;
run;
  
/* Testing accuracy */
data out;
 set out;
    /* how we grouped up original solution */
    if clus7 = 'CL10' then clus5 = '1';
	else if clus7 = 'CL13' then clus5 = '1';
	else if clus7 = 'CL15' then clus5 = '3';
	else if clus7 = 'CL18' then clus5 = '5';
	else if clus7 = 'CL7' then clus5 = '5';
	else if clus7 = 'CL8' then clus5 = '2';
	else if clus7 = 'CL9' then clus5 = '4';
    /* do same to predicted */ 
    if cluster = 1 then predcluster = 1;
	else if cluster = 2 then predcluster = 1;
	else if cluster = 3 then predcluster = 3;
	else if cluster = 4 then predcluster = 5;
	else if cluster = 5 then predcluster = 5;
	else if cluster = 6 then predcluster = 2;
	else if cluster = 7 then predcluster = 4;
run;

/* check accuracy */
proc freq data=out;
 tables clus7*predcluster;
 run;
/* Tried building one model over all but different vars are significant for different segments so not the optimum 
 method */




/* proc discrim */

proc discrim data=forstan testdata=fwork.soln2 testout=newp testoutd=newd
                  method=normal pool=no short noclassify crosslisterr;
 class cluster;
* priors proportional;
 var cut_sdrev_12 sdfreq_12 sdrec;   
run;

