libname kf_1 '/var/opt/analysis_3'  compress=yes;

/* Create random sample of my data */
data x;
set kf_1.lm_1706_nov_base;
random = ranuni(1);
run;

proc sort data = x; by random; run;

data x;
set x (obs = 430000);
keep account_desc minutes total_mb days_consumed_gt1;
run;


/*This produces a temp file (stan) with the variables standardised*/
proc standard data = x out = x mean = 0 std = 1;
 var minutes total_mb days_consumed_gt1;
run;


/* Next is the first cluster stage (K-Means) which produces a maximum of 200 clusters and
deletes any clusters with less than 25 records*/
/*Produces two temp file mean and out*/
proc fastclus data = x maxclusters = 200 maxiter = 50 conv = 0.01
              mean = kf_1.lm_1706_nov_tree_mean delete = 1000 out = kf_1.lm_1706_nov_tree_out;
  var minutes total_mb days_consumed_gt1;
  id account_desc;
run;




/*The next cluster analysis (hierarchical) combines the first analysis into many
clusters, all the way down to one, use the reports to identify the number of clusters 
which look to be most significant*/
/* produces tree which contains a list of the clusters with their
respective means for each var, along with the new cluster applications */
proc cluster data = kf_1.lm_1706_nov_tree_mean method = ward rsq ccc pseudo simple
     outtree = tree;
  var minutes total_mb days_consumed_gt1;
  id cluster;
run;



/* 5 Segment solution details */
proc tree data = tree n = 5 out = treeout5 noprint;
 copy cluster minutes total_mb days_consumed_gt1;
run;

/*clusnames are new clusters 1-5 */
proc sort data = treeout5; by clusname; run;

/* calculates new means for each of the 5 */
proc means data = treeout5 mean;
 var minutes total_mb days_consumed_gt1;
 by clusname;
run;

data treeout5;
 set treeout5;
 rename clusname = clus5;
run;



/* 6 Segment solution details */
proc tree data = tree n = 6 out = treeout6 noprint;
 copy cluster minutes total_mb days_consumed_gt1;
run;

/*clusnames are new clusters 1-6 */
proc sort data = treeout6; by clusname; run;

/* calculates new means for each of the 6 */
proc means data = treeout6 mean;
 var minutes total_mb days_consumed_gt1;
 by clusname;
run;

data treeout6;
 set treeout6;
 rename clusname = clus6;
run;



/* 7 Segment solution details */
proc tree data = tree n = 7 out = treeout7 noprint;
 copy cluster minutes total_mb days_consumed_gt1;
run;

/*clusnames are new clusters 1-7 */
proc sort data = treeout7; by clusname; run;

/* calculates new means for each of the 7 */
proc means data = treeout7 mean;
 var minutes total_mb days_consumed_gt1;
 by clusname;
run;

data treeout7;
 set treeout7;
 rename clusname = clus7;
run;




/*merge all cluster solns onto original out file from proc fastclus, by
  cluster, to get list of urns with appropriate clusters */
proc sort data = treeout5; by cluster; run;
proc sort data = treeout6; by cluster; run;
proc sort data = treeout7; by cluster; run;
proc sort data = kf_1.lm_1706_nov_tree_out; by cluster; run;

data kf_1.lm_1706_nov_tree_out (compress = yes);
 merge	treeout5 (in=b keep=cluster clus5)
		treeout6 (in=c keep=cluster clus6)
		treeout7 (in=d keep=cluster clus7)
		kf_1.lm_1706_nov_tree_out (in = e);
 by cluster;
 if e;
run;



/* Merge back to original MBs, days and voice minutes data */
proc sql;
create table kf_1.lm_1706_nov_tree_out as
select a.*, 
	   b.minutes as orig_mins,
	   b.total_mb as orig_total_mb,
	   b.days_consumed_gt1 as orig_days_consumed_gt1
from kf_1.lm_1706_nov_tree_out as a
	 left join 
	 kf_1.lm_1706_nov_base as b
on a.account_desc = b.account_desc;
quit;



/* Profile each of the three solutions by the cluster variables */
%macro clust_prof (clus = );
proc summary nway missing data = kf_1.lm_1706_nov_tree_out;
class &clus.;
var orig_mins orig_total_mb orig_days_consumed_gt1;
output out = &clus. (drop = _type_);
run;

proc export data = &clus.
outfile = "/var/opt/analysis_4/asis1/LM/lm_1706_&clus..csv" dbms=csv replace;run;
%mend clust_prof;

%clust_prof (clus = clus5);
%clust_prof (clus = clus6);
%clust_prof (clus = clus7);


***********************************XXXXXXXX**********************************;
********************************XXXXXXXXXXXXXX*******************************;
*****************************************************************************;
*************************  E-N-D  O-F  P-R-O-G-R-A-M ************************;
*****************************************************************************;
********************************XXXXXXXXXXXXXX*******************************;
***********************************XXXXXXXX**********************************;