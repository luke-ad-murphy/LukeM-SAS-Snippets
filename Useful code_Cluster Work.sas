/*SD Framework - Clustering*/

/*Two files have been prepared, the first looking at 0-24 mths sr-rev the second 0-12mth*/

/*THe first cluster analysis looks at 0-24mth rev*/

/* if var is ordered can standardise right away.if var is categorical (e.g. job ) then must make binary - this is not
   preferable as would then have to do this for all vars  */

/*Standardise varibales*/

proc standard data=fwork.pos_sdrevdata out=stan mean=0 std=1;
 var total_sdrev sdfreq sdrec;
run;

/*This produces a temp file (stan) with the variables standardised*/

/* Next is the first cluster stage (K-Means) which produces a maximum of 200 clusters and
deletes any clusters with less than 25 records*/

proc fastclus data=stan maxclusters=200 maxiter=50 conv=0.01
              mean=mean delete=25 out=out;
  var total_sdrev sdfreq sdrec;
  id bc;
run;

/*Produces two temp file mean and out*/

/*The next cluster analysis (hierarchical) combines the first analysis into many
clusters, all the way down to one, use the reports to identify the number of clusters 
which look to be most significant*/

proc cluster data=mean method=ward rsq ccc pseudo simple
     outtree=tree;
  var total_sdrev sdfreq sdrec;
  id cluster;
run;

/* produces tree which contains a list of the clusters with their
respective means for each var, along with the new cluster applications */

/*In this cast new segments 6,7,8,9 were identified as being possible solutions
beginning with segment 9 look produce detailed information*/

proc tree data=tree n=9 out=treeout9 noprint;
 copy cluster total_sdrev sdfreq sdrec;
run;

/*clusnames are new clusters 1-9 */
proc sort data=treeout9; by clusname; run;

/* calculates new means for each of the 9 */
proc means data=treeout9 mean;
 var total_sdrev sdfreq sdrec;
 by clusname;
run;

data treeout9;
 set treeout9;
 rename clusname= clus9;
run;

/* repeat for 8 cluster solution */
proc tree data=tree n=8 out=treeout8 noprint;
 copy cluster total_sdrev sdfreq sdrec;
run;

/*clusnames are new clusters 1-8 */
proc sort data=treeout8; by clusname; run;

proc means data=treeout8 mean;
 var total_sdrev sdfreq sdrec;
 by clusname;
run;

data treeout8;
 set treeout8;
 rename clusname= clus8;
run;

/* repeat for 7 cluster solution */
proc tree data=tree n=7 out=treeout7 noprint;
 copy cluster total_sdrev sdfreq sdrec;
run;

/*clusnames are new clusters 1-7 */
proc sort data=treeout7; by clusname; run;

proc means data=treeout7 mean;
 var total_sdrev sdfreq sdrec;
 by clusname;
run;

data treeout7;
 set treeout7;
 rename clusname= clus7;
run;

/* repeat for 6 cluster solution */
proc tree data=tree n=6 out=treeout6 noprint;
 copy cluster total_sdrev sdfreq sdrec;
run;

/*clusnames are new clusters 1-6 */
proc sort data=treeout6; by clusname; run;

proc means data=treeout6 mean;
 var total_sdrev sdfreq sdrec;
 by clusname;
run;

data treeout6;
 set treeout6;
 rename clusname= clus6;
run;

proc sort data=treeout9; by cluster;
proc sort data=treeout8; by cluster;
proc sort data=treeout7; by cluster;
proc sort data=treeout6; by cluster;
proc sort data=out; by cluster;run;

/*merge all cluster solns onto original out file from proc fastclus, by
  cluster, to get list of urns with appropriate clusters */
/*cluster is 1-141 */
data solution(compress=yes);
 merge	treeout9 (in=a keep=cluster clus9)
      	treeout8 (in=b keep=cluster clus8)
		treeout7 (in=c keep=cluster clus7)
		treeout6 (in=d keep=cluster clus6)
		out (in=e keep=bc cluster);
 by cluster;
 if a and b and c and d and e;
run;

proc sort data=solution; by bc; run;

/* merge solution to pos_revdata to see all vars with actual values */
data fwork.soln1(compress=yes);
 merge solution(in=a) fwork.pos_sdrevdata(in=b);
 by bc;
 if a and b;
run;

/*Run a series of proc means on each cluster to determine actual mean valuses for each cluster*/

proc sort data=fwork.soln1; by clus9; run;

proc means data=fwork.soln1 mean;
 var total_sdrev sdfreq sdrec;
 by clus9;
run;


proc sort data=fwork.soln1; by clus8; run;

proc means data=fwork.soln1 mean;
 var total_sdrev sdfreq sdrec;
 by clus8;
run;


proc sort data=fwork.soln1; by clus7; run;

proc means data=fwork.soln1 mean;
 var total_sdrev sdfreq sdrec;
 by clus7;
run;
