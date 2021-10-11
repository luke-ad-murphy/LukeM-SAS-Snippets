
/* --------------------------------------
  Applying the solution to other records 

  Written by Tracey Harrower 16.11.05
  ---------------------------------------*/

/* firstly need a standardised means file of the original 7 cluster solution - already done! */

/* don't need to run this bit but just shows you how I got it - from 'Cluster work - 12month sdreva' programme */
proc tree data=tree_a n=7 out=treeout7 noprint;
 copy cluster total_sdrev_12 sdfreq_12 sdrec;
run;

/* calculate new means for each of the 7 */
proc sort data=treeout7; by clusname; run;
proc means data=treeout7 mean;
 var total_sdrev_12 sdfreq_12 sdrec;
 by clusname;
 output out=stats mean=;
run;

data treeout7;
 set treeout7;
 rename clusname= clus7;
run;

/* create permanent means file */
data fwork.cluster_means; 
 set stats(drop=_type_ _freq_);
 rename total_sdrev_12=cut_sdrev_12;
run;

/* RUN FROM HERE */

/* Use proc fastclus to apply clusters */

/* THIS WILL BE RUN ON A MONTHLY BASIS ON ALL ACCOUNT CUSTOMERS */ 

/* STEP 1: CREATE TOTAL_SDREV_12, SDFREQ_12, AND SDREC
   STEP 2: TREAT REVENUE OUTLIERS
   STEP 3: STANDARDISE FILE
   STEP 4: PROC FASTCLUS
   STEP 5: CHECK OUTPUT COMPARED TO LAST MONTH
*/

/* Assuming you have done step 1!,... */

/* first of all get rid of outliers for revenue */
data forstan;
 set fwork.soln2;  /* replace this filename with new filename you wish to append clusters to */
 if total_sdrev_12 > 128349 then cut_sdrev_12 = 128349;
 else cut_sdrev_12=total_sdrev_12;
run;
 
/* now standardise values */
proc standard data=forstan out=stan mean=0 std=1;
 var cut_sdrev_12 sdfreq_12 sdrec ;
 run;

/* keep required fields */
data test(keep=bc cut_sdrev_12 sdfreq_12 sdrec);
 set stan;
 run;

/* run fastclus, but this time your seeds file is the cluster means of the 7 cluster solution so it forces everyone to belong to
   one of these clusters.  0 iterations ensures one step only to do this */
proc fastclus data=test maxiter=0 replace=none maxc=7 conv=0.01
              seed=fwork.cluster_means out=out;
  var cut_sdrev_12 sdfreq_12 sdrec;
  id bc;
run;

/* go from 7 to 5 solution */
data out;
 set out;
   if cluster = 1 then sd_cluster = 1;
	else if cluster = 2 then sd_cluster = 1;
	else if cluster = 3 then sd_cluster = 3;
	else if cluster = 4 then sd_cluster = 5;
	else if cluster = 5 then sd_cluster = 5;
	else if cluster = 6 then sd_cluster = 2;
	else if cluster = 7 then sd_cluster = 4;
run;


/* check cluster means of both 7 and 5 cluster solutions to ensure they remain consistent */
/* These should be exactly the same */
proc means data=out mean n;
 by cluster;
 var cut_sdrev_12 sdfreq_12 sdrec;
run;

/* These should be similar */
proc means data=out;
 by sd_cluster;
 var cut_sdrev_12 sdfreq_12 sdrec;
run;


/* merge cluster back onto site file  */


/* check cluster volumes and check last months cluster values to this month (crosstab of migration) */
proc freq data=site;
 tables last_cluster*sd_cluster;
 run;




/* THE END! */
 


/* I ran this programme originally on fwork.soln2 and then ran the following to test accuracy. */
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
 tables clus7*cluster clus5*predcluster;
 run;

/* proc discrim */

proc discrim data=forstan testdata=fwork.soln2 testout=newp testoutd=newd
                  method=normal pool=no short noclassify crosslisterr;
 class cluster;
* priors proportional;
 var total_sdrev_12 sdfreq_12 sdrec;   
run;

