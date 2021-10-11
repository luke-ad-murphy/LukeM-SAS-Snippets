*************************************************************
REVISING THE OVERARCHING SEGMENTATION

May 2005

Victoria Greygoose

*************************************************************

This program amalgamates all three areas of the revision of the overarching segmentation - Current Value, Potential
Value and Risk.  It then creates a final program that can be used within the download;

/*Assign libnames*/

libname aug04 'Q:\car_data\roy_mail\RMD\Monthly Download\aug04\Sas Data';
libname seg 'Q:\car_data\roy_mail\RMD\Overarching Segmentation\SAS Data';
libname segmt 'Q:\car_data\roy_mail\RMD\Overarching Segmentation\SAS Data_final';
libname jul04 'Q:\car_data\roy_mail\RMD\Monthly Download\jul04\Sas Data';
libname oct04 'Q:\car_data\roy_mail\RMD\Monthly Download\oct04m\Sas Data';
libname sep04 'Q:\car_data\roy_mail\RMD\Monthly Download\sep04m\Sas Data';
libname aug04 'Q:\car_data\roy_mail\RMD\Monthly Download\aug04m\Sas Data';
libname feb05 'Q:\car_data\roy_mail\RMD\Monthly Download\Feb05m\Sas Data';
libname view slibref=work server=server;

libname aug04 'N:\data\car_data\roy_mail\RMD\Monthly Download\aug04\Sas Data';
libname seg 'N:\data\car_data\roy_mail\RMD\Overarching Segmentation\SAS Data';
libname segmt 'N:\data\car_data\roy_mail\RMD\Overarching Segmentation\SAS Data_final';
libname jul04 'N:\data\car_data\roy_mail\RMD\Monthly Download\jul04\Sas Data';
libname oct04 'N:\data\car_data\roy_mail\RMD\Monthly Download\oct04m\Sas Data';
libname sep04 'N:\data\car_data\roy_mail\RMD\Monthly Download\sep04m\Sas Data';
libname aug04 'N:\data\car_data\roy_mail\RMD\Monthly Download\aug04m\Sas Data';
libname feb05 'N:\data\car_data\roy_mail\RMD\Monthly Download\Feb05m\Sas Data';

*Create one overall site file that contains all the fields required to run all the scores that feed into the final
Current Value, Potential and Risk elements;

data segmt.site_final (keep=compid bsn gno totalrmrevL12 sdrevL12 meterrevL12 mktsect mktsub empband compseg siteseg 
                          totalrmrevP12 mslprevL12 wslprevL12 fslprevl12 mslerevL12 wslerevL12 fslerevL12 ppostrevL12
                          respservrevL12 cleanmrevL12 pstreamrevL12 d2drevL12 stlrevL12 totalbuirevL12 totalbulrevL12 
                          totalbuprevL12 totalbuurevL12 mmedia mailable postcode icountrevL12 izandfrevL12 
                          idirectrevL12 istlrevL12 loctype);
set jul04.site;
run;

*Merge on other revenue streams required;

**************Mailsort 2;
proc sort data = jul04.rev_ms2_lp (keep=bsn revL12) out = temprev_lp; by bsn; run; *4913;
proc sort data = jul04.rev_ms2_le (keep=bsn revL12) out = temprev_le; by bsn; run; *849;



************SD core question response - dedupe to site level;
data sdcore (keep=bsn csn qmca_value);
set jul04.corequest;
if qmca_value = 'Y' and qmca_date >='01Aug02'd then output;
run;
*5,659 obs;
proc sort data=sdcore nodupkey; by bsn; run; *0 obs deleted;



************Track and trace traffic;
proc sort data = jul04.rev_tracktrace (keep=bsn traffl12) out=ttrace; by bsn; run;
*14,186 obs;



***********Walksort 2;
proc sort data = jul04.Rev_ws2_le (keep=bsn revL12) out = ws2le_temp; by bsn; run; *349;
proc sort data = jul04.Rev_ws2_lp (keep=bsn revL12) out = ws2lp_temp; by bsn; run; *456;



************Mailsort 3;
proc sort data = jul04.Rev_ms3_le (keep=bsn revL12) out = ms3le_temp; by bsn; run; *911;
proc sort data = jul04.Rev_ms3_lp (keep=bsn revL12) out = ms3lp_temp; by bsn; run; *6323;



************PPI;
proc sort data = jul04.rev_ppi (keep=bsn revL12) out = ppi_temp; by bsn; run; *34,287;



************RM DIRECT STAMPS;
proc sort data = jul04.rev_rmdirect_stamps (keep=bsn revL12) out = rmdirect_stamps; by bsn; run; *66,537;


proc sort data = segmt.site_final; by bsn; run;


*Merge all the files together;
data segmt.site_final badb badc badd bade badf badg badh badi badj badk;
	merge segmt.site_final (in=a)
	      temprev_lp (in=b rename=(revL12=ms2lp_revL12))
	      temprev_le (in=c rename=(revL12=ms2le_revL12))
		  sdcore (in=d keep=bsn QMCA_value)
		  ttrace (in=e rename=(traffl12=tracktraceL12))
		  ws2le_temp (in=f rename=(revL12 = ws2le_revL12))
		  ws2lp_temp (in=g rename=(revL12 = ws2lp_revL12))
		  ms3le_temp (in=h rename=(revL12 = ms3le_revL12))
		  ms3lp_temp (in=i rename=(revL12 = ms3lp_revL12))
		  ppi_temp (in=j rename=(revL12=ppirevL12))
		  rmdirect_stamps (in=k rename=(revL12=rmdir_st_revL12));
by bsn;
if a then output segmt.site_final;
if b and not a then output badb;
if c and not a then output badc;
if d and not a then output badd;
if e and not a then output bade;
if f and not a then output badf;
if g and not a then output badg;
if h and not a then output badh;
if i and not a then output badi;
if j and not a then output badj;
if k and not a then output badk;
run;
*1,405,853 obs in risk_sites and 0 obs in all the bad files;


/*Now merge on the Head Office Indicator and Company Member flags from the new MARS data*/
data bc_minors;
	set feb05.bc_minors;
	length bsn_check 8.;
	bsn_check=substr(old_bc,1,2);
	bsn_rest=substr(old_bc,3,7);
run;

data bc_minors;
	set bc_minors;
	length bsn $8.;
	if bsn_check<=7 then bsn=compress(bsn_check||bsn_rest);
	else bsn='0';
run; 
data bc_minors1;
set bc_minors;
if bsn = '0' then delete;
run;
*1,553,828 left;
proc sort data=bc_minors1(rename=(new_bc=bc));by bsn;run;
proc sort data = segmt.site_final;by bsn;run;

*Merge this file onto the overall site file to give each a bc value;
data segmt.site_final bada;
	merge segmt.site_final (in=a)
	      bc_minors1 (in=b keep=bsn bc);
by bsn;
if a then output segmt.site_final;
if a and not b then output bada;
run;
*8645 sites have no match on the minors file and therefore have no bc attributed to them;

data test;
set segmt.site_final;
if bc = ' ' then delete;
run;

* Is the site_final file still a unique file of sites when sorted by bc?;
proc sort data = test nodupkey; by bc; run;
*There are 638 sites which are now merged into one of the other sites - therefore some sites in the data we are
using for the segmentation have now effectively been lost in the new data.  Not a lot we can do about this at this
stage but this will be rectified once the segmentation is run on MARS data;

*Now merge the Head Office Indicator and the Company Member flags to the overall site file by bc;
proc sort data = feb05.site (keep=bc ho_ind comp_mem) out = site1; by bc; run;
proc sort data = segmt.site_final; by bc;run;

data segmt.site_final bada badb;
	merge segmt.site_final (in=a)
	      site1 (in=b);
by bc;
if a then output segmt.site_final;
if a and not b then output bada;
if b and not a then output badb;
run;
*8645 a sites don't have a match on b as expected;

/*Fill in missing values so that all fields have populated values*/
data segmt.site_final;
set segmt.site_final;
array revfill (33) totalrmrevl12 totalrmrevP12 totalbuurevl12 totalbulrevl12 totalbuirevl12 totalbuprevl12
                   cleanmrevL12 d2drevL12 icountrevL12 idirectrevL12 istlrevL12 izandfrevL12 mslprevl12 mslerevl12
                   meterrevL12 pstreamrevL12 respservrevL12 sdrevL12 stlrevL12 ppostrevL12 wslerevl12 wslprevl12
                   fslerevl12 fslprevl12 ms2lp_revL12 ms2le_revL12 tracktraceL12 ws2le_revL12 ws2lp_revL12 
                   ms3le_revL12 ms3lp_revL12 ppirevL12 rmdir_st_revL12;
do i = 1 to 33;
if revfill(i) = . then revfill(i)=0; else revfill(i)=revfill(i);
end;
run;

*Fill the Mailmedia flag so that anyone without a Y value gets a N;
data segmt.site_final (drop=i);
set segmt.site_final;
if mmedia = ' ' then mmedia = 'N'; else mmedia=mmedia;
run;



*********************************************CURRENT VALUE AT SITE LEVEL***********************************************
Current Value to include both RM revenue and track and trace proxied revenue where a site has it.
Analysis has been done to calculate an AVERAGE SD value and this has been multiplied against track and trace - this 
value is £4.19;

/*Create a new total RM revenue including track and trace revenue for non account/non meter SD customers*/
/*Only adding on rev at site level if track and trace traffic is positive*/
data segmt.site_final (drop=tracktrace12);
	set segmt.site_final;
	if sdrevl12 = 0 and tracktraceL12>0 then extrasd=tracktraceL12*4.19;
	else extrasd=0;
	if meterrevL12 = 0 and tracktraceL12>0 then extrasd1=tracktraceL12*4.19;
	else extrasd1=0;
	newtotrmrevl12=sum(totalrmrevl12,extrasd,extrasd1);
run; 

/*If a SINGLE site has negative revenue then keep as is, if a company member site has negative 
  revenue then set to zero*/
data segmt.site_final;
	set segmt.site_final;
	if compid=bsn then comprevl12=newtotrmrevl12;
	if compid ne bsn and newtotrmrevl12<0 and newtotrmrevl12 ne . then comprevl12=0;
	else comprevl12=newtotrmrevl12;
run;

proc univariate data = segmt.site_final;
where newtotrmrevL12 >0;
var newtotrmrevL12;
run;

/********************************CURRENT VALUE AT COMPANY LEVEL*******************************************************/

*Create a file of current value scores at company level;
/*Need to round up to company level*/
proc sort data=segmt.site_final;by compid;run;
proc means data=segmt.site_final noprint;
	by compid;
	var comprevl12;
	output out=comp(drop=_FREQ_ _TYPE_) sum=;
run;
*1230858 companies;

/*Band the new revenue - using previously used banding*/
data segmt.comp_curr_score; 
set comp;
if comprevl12 <= 0 then comp_rev_score=0;
else if comprevl12 < 500 then comp_rev_score=1;
else if comprevl12 < 1000 then comp_rev_score=2;
else if comprevl12 < 5000 then comp_rev_score=3;
else if comprevl12 < 10000 then comp_rev_score=5;
else if comprevl12 < 50000 then comp_rev_score=7;
else if comprevl12>=50000 then comp_rev_score=8;
run;
*1,230,858;

proc freq data = segmt.comp_curr_score;
tables comp_rev_score / missing;
run;
/* 0      858098       69.72%*/
/* 1      181328       14.73%*/
/* 2       36875        3.00%*/
/* 3       98981        8.04%*/
/* 5       25810        2.10%*/
/* 7       21503        1.75%*/
/* 8        8263        0.67%*/


**********************************POTENTIAL VALUE SCORE AT SITE LEVEL***************************************************

*******OPPORTUNITY SCORE************************************************************************************************

Create a temp file of the sites from the site file with positive revenue;
data posrev (keep=bsn compid mktsect loctype ho_ind comp_mem empband compseg siteseg totalrmrevL12 totalrmrevP12);
set segmt.site_final;
if totalrmrevL12 >0;
run;
/* 446,683 */

*Using the posrev file, create the peer groups by using the market sector and the employee band fields;
*Create a value to put into the market sector field and the employee band field for all records with no value;
data posrev;
set posrev;
if mktsect = ' ' then mktsect = 'X'; 
if empband = ' ' then empband = 'X'; 
run;
*446,683 obs;

data posrev;
set posrev;
if empband = 'X' then employee = 'X';
else if empband in ('A','B','C','D') then employee = 'L';
else if empband in ('E','F','G','H','I') then employee = 'H';
run;

proc freq data = posrev;
tables employee / missing;
run;
/*35,052 in H, 153,103 in L and 258,528 in X*/

*Concatenate the two fields together to create our groupings field;
data posrev;
length peer1 $2.;
set posrev;
if mktsect = 'H' then peer1 = 'H';
else if mktsect ne 'H' then peer1 = compress(mktsect,' ') || compress(employee,' ');
run; 

/*Now create mean and 70th percentile values against each of these peer groups - removing extreme values from each*/
/*group and then rerun the values*/

*Run the proc univariates on each of the mktemp groups;
proc sort data=posrev; by peer1; run;
proc univariate data = posrev noprint;
var totalrmrevL12;
by peer1;
output out = univariate1 min=min mean=mean max=max std=std median=median pctlpts=95 96 97 98 99 pctlpre=p_;
run;

*Remove outlying values within the top 5 percentiles of their peer1 group's values;
proc sort data = univariate1; by peer1; run; *37;

data posrev nomerge;
	merge posrev (in=a)
	      univariate1 (in=b keep=peer1 p_95);
by peer1;
if a then output posrev;
if a and not b then output nomerge;
run;
*0 in nomerge - good;

*Remove the outliers;
data posrev2;
set posrev;
if totalrmrevL12 > p_95 then delete;
run;
*424,466;

* Repeat univariates but on the new positive revenue file with outliers removed;
proc sort data=posrev2; by peer1; run;
proc univariate data = posrev2 noprint;
var totalrmrevL12;
by peer1;
output out = univariate2 min=min mean=mean max=max std=std median=median pctlpts=10 to 100 by 10 pctlpre=p_;
run;

*Merge the new mean and the 70th percentile values to the original posrev_jan file for each of the peer1 groups;
proc sort data = univariate2; by peer1; run; *37;
proc sort data = posrev; by peer1; run; *446,683;

data posrev bada;
	merge posrev (in=a drop=p_95)
	      univariate2 (in=b keep=peer1 mean p_70 rename=(mean=peer1_mean p_70=peer1_P70));
by peer1;
if a then output posrev;
if a and not b then output bada;
run;
*0 obs in bada - good;

/*	******************************************/

/*Create location type flags using a combination of the Head Office Indicator and the Company Member flags*/
data posrev;
set posrev;
if loctype = 'A' then location = 'H';
else if loctype = 'B' then location = 'B';
else if loctype in ('C','D') then location = 'S';
else if ho_ind = 1 then location = 'H';
else if comp_mem = 1 then location = 'B';
else location = 'S';
run;

proc freq data = posrev;
tables location / missing;
run;
/*92,397 sites are branches, 36,121 are Head Offices and 318,165 are single sites*/

*Now use the location field to create the revised peer groups;
data posrev;
length peer2 $3.;
set posrev;
if mktsect = 'H' then peer2 = 'H';
else peer2=compress(mktsect,' ') || compress(employee,' ') || compress(location,' ');
run;

*Look at the final peer groups in terms of volume as before;
proc freq data = posrev;
tables peer2 / missing out= peer2_freq;
run;

proc sort data = peer2_freq; by descending count; run; *109 peer groups;

/*Assign a mean and a 70th percentile value to the peer2 groups using the same methodology as was done for peer1. */
/*Ensure that the outliers are removed again as was the case for peer1*/

proc sort data=posrev; by peer2; run;
proc univariate data = posrev noprint;
var totalrmrevL12;
by peer2;
output out = univariate3 min=min mean=mean max=max std=std median=median pctlpts=95 96 97 98 99 pctlpre=p_;
run;

*Remove outlying values from each of the peer2 groups;
proc sort data = univariate3; by peer2; run; *109;

data posrev nomerge;
	merge posrev (in=a)
	      univariate3 (in=b keep=peer2 p_95);
by peer2;
if a then output posrev;
if a and not b then output nomerge;
run;
*0 in nomerge - good;

*Remove the outliers;
data posrev3;
set posrev;
if totalrmrevL12 > p_95 then delete;
run;
*424,405 records remaining;

* Repeat univariates but on the new positive revenue file with outliers removed;
proc sort data=posrev3; by peer2; run; *424,405;
proc univariate data = posrev3 noprint;
var totalrmrevL12;
by peer2;
output out = univariate4 min=min mean=mean max=max std=std median=median pctlpts=10 to 100 by 10 pctlpre=p_;
run;

*Merge the mean and the 70th percentile values to the posrev3_jan file for each of the peer2 groups;
proc sort data = univariate4; by peer2; run; *109;
proc sort data = posrev; by peer2; run; *446,683;

data posrev bada;
	merge posrev (in=a drop=p_95)
	      seg.opp_univariates2_peer2 (in=b keep=peer2 mean p_70 rename=(mean=peer2_mean p_70=peer2_P70));
by peer2;
if a then output posrev;
if a and not b then output bada;
run;
*0 obs in bada - good;

********CR - PRINT OFF VOLUMES IN EACH OF THE PEER2 GROUPS TO QUALIFY HOW MANY HAVE LESS THAN 500 RECs******************


/*Records in peer2 groups with fewer than 500 records in them should use the peer1 mean and 70th percentile values, */
/*  else where they have greater than 500 records, they should use their peer2 mean and 70th percentile values*/

/*Assign the final mean and 70th percentile values for each peer2 peer group*/
data posrev;
set posrev;
if peer2 in ('CLB', 'PHB', 'UHB', 'CHB', 'CHH', 'PXH', 'ULB', 'CHS', 'UHS', 'CXH', 'UHH', 'WXH', 'ELH', 'EXH', 'UXH', 
             'ULH', 'XHB', 'XHH', 'XHS') 
       then do;
final_peer = peer1;
final_mean = peer1_mean;
final_P70 = peer1_P70;
end;

else do;

final_peer = peer2;
final_mean = peer2_mean;
final_P70 = peer2_P70;
end;

run;


*Now that each record on the posrev file has a mean and 70th percentile value, merge these onto the overall site file
by peer group.  Means creating the peer groups on the site file;

/*Create location type flags using a combination of the Head Office Indicator and the Company Member flags*/
data segmt.site_final;
set segmt.site_final;
if loctype = 'A' then location = 'H';
else if loctype = 'B' then location = 'B';
else if loctype in ('C','D') then location = 'S';
else if ho_ind = 1 then location = 'H';
else if comp_mem = 1 then location = 'B';
else location = 'S';
run;

proc freq data = segmt.site_final;
tables location / missing;
run;
/*212,512 sites are branches, 55,600 are Head Offices and 1,137,741 are single sites*/

data segmt.site_final;
set segmt.site_final;
if mktsect = ' ' then mktsect = 'X'; 
if empband = ' ' then empband = 'X'; 
run;

data segmt.site_final;
set segmt.site_final;
if empband = 'X' then employee = 'X';
else if empband in ('A','B','C','D') then employee = 'L';
else if empband in ('E','F','G','H','I') then employee = 'H';
run;

*Create the revised peer groups;
data segmt.site_final (drop=final_peer);
length peer2 $3.;
set segmt.site_final;
if mktsect in ('H', 'S') then peer2 = 'H';
else peer2 =compress(mktsect,' ') || compress(employee,' ') || compress(location,' ');
run;

proc freq data = segmt.site_final;
tables peer2 / missing;
run;

*Merge the values on the posrev file onto the site file by their three character peer group;
proc sort data = posrev nodupkey out=temppeer; by peer2;run; *109 obs;
proc sort data = segmt.site_final;by peer2;run;

data segmt.site_final bada;
	merge segmt.site_final (in=a)
	      temppeer (in=b keep=final_peer final_mean final_P70 peer2);
by peer2;
if a then output segmt.site_final;
if a and not b then output bada;
run;
* 0 obs in bada - good;

*Now create the benchmark score (target) which should be the less of the mean or the 70th percentile value for 
each site;
data segmt.site_final;
set segmt.site_final;
if min(final_p70, final_mean) = final_mean then target = final_mean;
else target = final_p70;
run;

*Now create each site's gapspend which is the difference between their target spend and their actual spend.  Sites
with negative rev should have rev set to zero;
data segmt.site_final;
set segmt.site_final;
if totalrmrevL12 <=0 then currentrev = 0;
else currentrev = totalrmrevL12;
run;

data segmt.site_final;
set segmt.site_final;
gapspend = target-currentrev;
run;

 proc format;
 value spend
 low-0='higher/equal to target'
 0.00001-500='£0-500 below target'
 500-1000='£500-1k below target'
 1000-5000='£1k-5k below target'
 5000-high='at least £5k below target';
 run;

proc freq data = segmt.site_final;
tables gapspend / missing;
format gapspend spend.;
run;
/*Higher/equal to target = 167,860 sites*/
/*£0-500 below target = 645,376 sites*/
/*£500-1k below target = 86,474 sites*/
/*£1k-5k below target = 466,886 sites*/
/*at least £5k below target = 39,257 sites*/


*Create opportunity score based on gapspend;
data segmt.site_final;
set segmt.site_final;
if gapspend >2500 then oppscore = 'H';
else if 1000< gapspend <=2500 then oppscore = 'M';
else if gapspend <=1000 then oppscore = 'L';
run;

proc freq data = segmt.site_final;
tables oppscore / missing;
run;
* For oppscore - Freq are 141,192 (10.04%) sites in High, 364,951 (25.96%) in Medium and 899,710 (64.0%) in Low;


/* Build in historical growth into overall opportunity score */

data segmt.site_final;
set segmt.site_final;
format L12growthrate 8.1;
 if totalrmrevP12>0 then L12growthrate=((totalrmrevL12-totalrmrevP12)/totalrmrevP12)*100;
run;


*Create growth scores;
data segmt.site_final;
set segmt.site_final;
 if totalrmrevL12 <0 or (totalrmrevL12 in (0,.) and totalrmrevP12 in (0,.)) then growscore=-3; /* -ve this year or zero both years */
 else if totalrmrevL12 >0 and totalrmrevP12 <=0 then growscore=0; /* +ve this yr but (-ve or 0) last year */
 else if l12growthrate = -100 or (totalrmrevL12 in (0,.) and totalrmrevP12<0) then growscore=-2; /* reduced rev to £0 or gone from -ve to 0*/
 else if -100 < l12growthrate < -10 then growscore=-1;  /* have reduced part of revenue */
 else if -10 <= l12growthrate < 10 then growscore=0; /* pretty much stayed the same */
 else if 10 <= l12growthrate < 100 then growscore=2;
 else if l12growthrate >= 100 then growscore=4;
run;

proc freq data = segmt.site_final;
tables growscore / missing;
run;
*888,232 in -3
  70,938 in -2
 101,590 in -1
 227,831 in 0
 89,525 in 2
 27,737 in 4
none missing;


*Apply new oppscores to these sites now that growth has been assessed too;
data segmt.site_final;
 set segmt.site_final;
 length newoppscore $1.;
 if (totalrmrevL12 in (0,.) and totalrmrevP12 in (0,.)) then newoppscore=oppscore;
 else if growscore in (-1,-2) then newoppscore='L'; /* reduced rev last yr */
 else do;
   if oppscore='H' then do;
    if growscore=-3 then newoppscore='M'; /* L12<0 */
    if growscore in (0,2,4) then newoppscore='H';
   end;
   if oppscore='M' then do;
    if growscore=-3 then newoppscore='M';
    if growscore in (0,2) then newoppscore='M';
    if growscore = 4 then newoppscore='H';
   end;
   if oppscore='L' then do;
     if growscore in (-3,-2,-1,0) then newoppscore='L';
     if growscore in (2,4) then newoppscore='M';
   end;
 end;
 run;

proc freq data=segmt.site_final;
tables newoppscore/missing;
run;
*117,512 in H (8.36%), 405,330 in M (28.83%) and 883,011 in L (62.81);


*******SPREAD SCORE**************************************************************************************************

*In order to determine spread of spend we need to derive the spend groups;
data segmt.site_final;
set segmt.site_final;

if totalrmrevL12 <= 0 then do;
	dm_gp = 0;
	sd_gp = 0;
	bulk_gp = 0;
	stmet_gp = 0;
	othuk_gp = 0;
	int_gp = 0;
end;

else if totalrmrevL12 > 0 then do;
	if mslprevL12 >0 or wslprevL12 >0 or fslprevL12 >0 or mmedia = 'Y' then dm_gp = 1; else dm_gp = 0;
	if sdrevL12 >0 then sd_gp = 1; else sd_gp = 0;
	if mslerevL12 >0 or wslerevL12 >0 or fslerevL12 >0 or ppostrevL12 >0 or respservrevL12 >0 or 
	   cleanmrevL12 >0 or pstreamrevL12 >0 or d2drevL12 >0 then bulk_gp=1; else bulk_gp = 0;
	if stlrevL12 >0 or meterrevL12 >0 then stmet_gp = 1; else stmet_gp = 0;
	if totalrmrevL12 -(sum(of mslprevL12,wslprevL12,fslprevL12,sdrevL12,mslerevL12,wslerevL12,
       fslerevL12,ppostrevL12,respservrevL12,cleanmrevL12,pstreamrevL12,d2drevL12,stlrevL12,meterrevL12))>0
	   then othuk_gp=1; else othuk_gp=0;
	if totalbuirevL12 >0 then int_gp=1; else int_gp = 0;
end;

run;

*Create a volume field to determine how many areas a site spends on;
data segmt.site_final;
set segmt.site_final;
spread = sum(of dm_gp,sd_gp,bulk_gp,stmet_gp,othuk_gp,int_gp);
run;

proc freq data = segmt.site_final;
tables spread / missing;
title 'Spread at Site Level';
run;
*0 = 959,170 (68.23%)
 1 = 333,105 (23.69%)
 2 =  70,451 (5.01%)
 3 =  30,677 (2.18%)
 4 =  7,784 (0.55%)
 5 =  3,854 (0.27%)
 6 =  812 (0.06%);

*According to a report sent to us by Royal Mail, some of the spend groups above have projected growth over the next
year whilst others have projected decline.  These are as follows: 
Growth groups = SD, ST/Meter
Decline groups = Bulkmail, DM

Create a flag to determine how many growth/decline groups each site has;
data segmt.site_final;
set segmt.site_final;
grow_gps = sum(sd_gp,stmet_gp);
decl_gps = sum(dm_gp,bulk_gp);
run;

proc freq data = segmt.site_final;
tables grow_gps decl_gps / missing;
run;
/*Grow groups - 1192581 sites (84.83%) have 0, 203075 (14.44%) have 1 and 10197 (0.73%) have 2*/
/*Decline groups - 1332343 sites (94.77%) have 0, 68772 (4.89%) have 1 and 4738 (0.34%) have 2*/

*************************************CREATE OVERALL POTENTIAL SCORE AT SITE LEVEL***********************************;

*Now we need to create the overall Potential score at site level.  To do this we are going to combine a customer's
opportunity score and spread of products and weight this by the proportion of their spend groups that are growing/
declining;

data segmt.site_final;
set segmt.site_final;

/*	Consider the sites with a high opportunity score	*/
	if newoppscore = 'H' and spread = 0 then pot_score = 'L';
	else if newoppscore = 'H' and spread >=3 then pot_score = 'H';
	else if newoppscore = 'H' then do;
		if decl_gps <= grow_gps then pot_score = 'H';
		if decl_gps > grow_gps then pot_score = 'M';
	end;

/*Consider the sites with a medium opportunity score	*/
	if newoppscore = 'M' and spread = 0 then pot_score = 'L';
	else if newoppscore = 'M' and spread >=3 then do;
		if grow_gps <= decl_gps then pot_score = 'M';
		if grow_gps > decl_gps then pot_score = 'H';
		end;
	else if newoppscore = 'M' then do;
		if decl_gps <= grow_gps then pot_score = 'M';
		if decl_gps > grow_gps then pot_score = 'L';
	end;

/*Consider the sites with a low opportunity score*/
	if newoppscore = 'L' and spread <=2 then pot_score = 'L';
	else if newoppscore = 'L' and spread >=3 then do;
		if grow_gps <= decl_gps then pot_score = 'L';
		if grow_gps > decl_gps then pot_score = 'M';
		end;
run;

proc freq data = segmt.site_final;
tables newoppscore*pot_score / missing;
title 'Potential Score at Site level';
run;
*Overall sites in each Pot_score band - 33,812 in H (2.41%), 129,446 in M (9.21%) and 1,242,595 in L (88.39);

**********************************POTENTIAL SCORE AT COMPANY LEVEL***************************************************
Create a company level file of companies with their Potential score;

*First create new flags that can be summed to determine what Potential score the site falls into AND
the site status of the site (ie primary/secondary);

data segmt.site_final;
set segmt.site_final;
if siteseg in ('A', 'B', 'C', 'C+', 'D', 'D+', 'E', 'E-', 'E+', 'F', 'G', 'H', 'I', 'J', 'U') then sitestat = 'P';
else sitestat = 'S';
run;

proc freq data = segmt.site_final;
tables sitestat / missing;
run;
*1,251,550 in P and 154,303 in S;

data test (keep= bsn compid low_p low_s med_p med_s high_p high_s dummy sitestat);
set segmt.site_final;
if pot_score = 'L' and sitestat ='P' then low_p = 1; else low_p = 0;
if pot_score = 'L' and sitestat ='S' then low_s = 1; else low_s = 0;
if pot_score = 'M' and sitestat ='P' then med_p = 1; else med_p = 0;
if pot_score = 'M' and sitestat ='S' then med_s = 1; else med_s = 0;
if pot_score = 'H' and sitestat ='P' then high_p = 1; else high_p = 0;
if pot_score = 'H' and sitestat ='S' then high_s = 1; else high_s = 0;
dummy=1;
run;

*Check that the above are mutually exclusive at site level;
proc freq data = test;
tables low_p*low_s*med_p*med_s*high_p*high_s / missing list;
run;
*They are - good;

proc sort data = test; by compid; run;*1,405,853;

proc means data = test noprint;
var low_p low_s med_p med_s high_p high_s dummy;
by compid;
output out = segmt.comp_pot_scores sum= low_p low_s med_p med_s high_p high_s totsites;
run;
*1,230,858 companies;

data segmt.comp_pot_scores;
set segmt.comp_pot_scores;
if low_p>0 then low_p_val=1; else low_p_val=0;
if low_s>0 then low_s_val=1; else low_s_val=0;
if med_p>0 then med_p_val=1; else med_p_val=0;
if med_s>0 then med_s_val=1; else med_s_val=0;
if high_p>0 then hig_p_val=1; else hig_p_val=0;
if high_s>0 then hig_s_val=1; else hig_s_val=0;
run;

*Set the final company level value according to site hierarchy rules;
data segmt.comp_pot_scores;
set segmt.comp_pot_scores;
if hig_p_val >0 then comp_pot_score = 'High';
else if med_p_val >0 then comp_pot_score = 'Med';
else if low_p_val >0 then comp_pot_score = 'Low';
else if hig_s_val >0 then comp_pot_score = 'High';
else if med_s_val >0 then comp_pot_score = 'Med';
else if low_s_val >0 then comp_pot_score = 'Low';
run;

proc freq data = segmt.comp_pot_scores;
tables comp_pot_score / missing;
title 'Freq of Company Level Potential Scores (Revised to include Opp inc gapspend, Spread and Growth/Decline';
run;
/*24,125 (1.96%) in High, 1,102,475 (89.57%) in Low and 104,258 (8.47%) in Med*/


***************************************RISK SCORE AT SITE LEVEL*******************************************************

************COMPETITOR RISK SCORE************************************************************************************;

*Create the product flags for the products which have been classified as high current risk from competitors;
data segmt.site_final;
set segmt.site_final;

if sdrevL12 not in (0,.) or (qmca_value = 'Y' and meterrevL12 > 0) or (tracktraceL12 >0 and meterrevL12>0)
	then sduse = 1; else sduse = 0;

if ms2lp_revL12 not in (0,.) or ms2le_revL12 not in (0,.) 
	then ms2use = 1; else ms2use = 0;

if ms3le_revL12 not in (0,.) or ms3lp_revL12 not in (0,.)
    then ms3use = 1; else ms3use = 0;

if ws2le_revL12 not in (0,.) or ws2lp_revL12 not in (0,.)
    then ws2use = 1; else ws2use = 0;

if sum(meterrevL12,ppirevL12) >=100000 and sum(meterrevL12,ppirevL12) <=500000 
    then meterppiuse = 1; else meterppiuse = 0;

if icountrevL12 not in (0,.) then idsuse = 1; else idsuse = 0; 

if idirectrevL12 not in (0,.) then ideuse = 1; else ideuse = 0; 

if izandfrevl12 not in (0,.) then izfuse = 1; else izfuse = 0;


run;

proc freq data = segmt.site_final;
title 'User flags';
tables sduse ms2use ms3use ws2use meterppiuse idsuse ideuse izfuse  / missing;
run;

*Create an overall msuse flag from the ms2use and the ms3use flags;
data segmt.site_final;
set segmt.site_final;
if ms2use = 1 or ms3use = 1 then msuse = 1; else msuse = 0;
run;

proc freq data = segmt.site_final;
tables msuse / missing;
Title 'Mailsort User flag';
run;
*7,071 with a msuse flag;

*Create a sum of 'Competitor Risk Revenue' - want to work out what proportion of each customer's revenue this
represents;
data segmt.site_final;
set segmt.site_final;
if meterppiuse = 1 then crisk_rev = sum(of meterrevL12,ppirevL12, ms2lp_revL12,ms2le_revL12,ms3lp_revL12,
                                        ms3le_revL12,ws2lp_revL12,ws2le_revL12,sdrevL12,idirectrevL12,icountrevL12,
                                        izandfrevL12);
else if meterppiuse = 0 then crisk_rev = sum(of ms2lp_revL12,ms2le_revL12,ms3lp_revL12,ms3le_revL12,
                                             ws2lp_revL12,ws2le_revL12,sdrevL12,idirectrevL12,icountrevL12,izandfrevL12);
run;

*What proportion does this revenue represent of the total RM revenue for each site?;
data segmt.site_final;
set segmt.site_final;
if totalrmrevL12<=0 then crisk_prop = 0;
else if totalrmrevL12>0 then crisk_prop = (crisk_rev/totalrmrevL12)*100;
run;

*There are sites with negative proportions and also sites with greater than 100% - correct these;
data segmt.site_final;
set segmt.site_final;
if crisk_prop>100 then crisk_prop=100;
else if crisk_prop<0 then crisk_prop=0;
else crisk_prop=crisk_prop;
run;

*Band the Competitor Risk proportion in order to create the final Competitor Risk score at site level;
data segmt.site_final;
set segmt.site_final;
if crisk_prop >=60 then CR_score = 'H';
else if 0< crisk_prop <60 then CR_score = 'M';
else CR_score = 'L';
run;

proc freq data = segmt.site_final;
tables CR_score / missing;
title 'CR_Scores at Site Level';
run;
*7,751 sites (0.55%) are in H, 13,473 sites (0.96%) are in M and 1,384,629 sites (98.49%) are in L; 

*******QUALITY OF SERVICE RISK SCORES*********************************************************************************

*Create user flags for the products that don't already have them;
data segmt.site_final;
set segmt.site_final;
if stlrevL12 not in (0,.) then stluse = 1; else stluse = 0;
if meterrevL12 not in (0,.) then metuse = 1; else metuse = 0;
if respservrevL12 not in (0,.) then rsuse = 1; else rsuse = 0;
if pstreamrevL12 not in (0,.) then psuse = 1; else psuse = 0;
if ppirevL12 not in (0,.) then ppiuse = 1; else ppiuse = 0;
if rmdir_st_revL12 not in (0,.) then rmdirstuse = 1; else rmdirstuse = 0;
if cleanmrevL12 not in (0,.) then cleanuse = 1; else cleanuse = 0;
if ppostrevL12 not in (0,.) then ppostuse = 1; else ppostuse= 0;
if istlrevL12 not in (0,.) then istluse = 1; else istluse = 0;
run;

proc freq data = segmt.site_final;
tables stluse metuse rsuse psuse sduse ms2use ppiuse rmdirstuse cleanuse ppostuse ws2use istluse idsuse izfuse/missing;
Title 'User flags for Q of S measure';
run;

*Add up the number of the 14 'danger' products that each site is using;
data segmt.site_final;
set segmt.site_final;
danger_prods = sum(stluse,metuse,rsuse,psuse,sduse,ms2use,ppiuse,rmdirstuse,cleanuse,ppostuse,ws2use,istluse,idsuse,izfuse);
run;

*Assign the QS Risk Score to each site based on the number of products they have;
data segmt.site_final;
set segmt.site_final;
if danger_prods>=4 then QS_score = 'H';
else if 1<= danger_prods <=3 then QS_score = 'M';
else if danger_prods = 0 then QS_score = 'L';
run;

proc freq data = segmt.site_final;
tables QS_score;
title 'Quality of Service Risk score at site level';
run;
*18,024 (1.28%) in H, 275,728 (19.61%) in M and 1,112,101 (79.11%) in L;


***********************************CREATE FINAL RISK SCORE AT SITE LEVEL************************************************;

proc freq data=segmt.site_final;
 tables QS_score*cr_score;
 title 'Site level QS and CR scores crosstabbed';
run; 
*See output matrix and use matrix to classify sites with an overall site risk score;

data segmt.site_final;
set segmt.site_final;
if CR_score = 'H' then risk_score = 'H';
else if CR_score = 'L' then risk_score = 'L';
else if CR_score = 'M' and QS_score in ('L','M') then risk_score = 'M';
else if CR_score = 'M' and QS_score = 'H' then risk_score = 'H';
run;

*Assess final risk scores at site level;
proc freq data = segmt.site_final;
tables risk_score / missing;
title 'Site level risk scores';
run;
*17,482 (1.24%) sites in H, 3,742 (0.27%) sites in M and 1,384,629 (98.49%) sites in L;

*********************************RISK SCORE AT COMPANY LEVEL**********************************************************;
*Create a company level file of risk scores grouped in the same way as for the Potential score;

data test (keep= bsn compid low_p low_s med_p med_s high_p high_s dummy sitestat);
set segmt.site_final;
if risk_score = 'L' and sitestat ='P' then low_p = 1; else low_p = 0;
if risk_score = 'L' and sitestat ='S' then low_s = 1; else low_s = 0;
if risk_score = 'M' and sitestat ='P' then med_p = 1; else med_p = 0;
if risk_score = 'M' and sitestat ='S' then med_s = 1; else med_s = 0;
if risk_score = 'H' and sitestat ='P' then high_p = 1; else high_p = 0;
if risk_score = 'H' and sitestat ='S' then high_s = 1; else high_s = 0;
dummy=1;
run;

*Check that the above are mutually exclusive at site level;
proc freq data = test; 
tables low_p*low_s*med_p*med_s*high_p*high_s / missing list;
run;
*0 overlap - good;

proc freq data = test;
tables low_p low_s med_p med_s high_p high_s / missing;
title 'Risk Value combined with Site type';
run;
*Looks fine and adds up to the same totals as per the value splits above;

proc sort data = test; by compid; run;

proc means data = test noprint;
var low_p low_s med_p med_s high_p high_s dummy;
by compid;
output out = segmt.comp_risk_scores sum= low_p low_s med_p med_s high_p high_s totsites;
run;
*1,230,858 companies;

data segmt.comp_risk_scores;
set segmt.comp_risk_scores;
if low_p>0 then low_p_val=1; else low_p_val=0;
if low_s>0 then low_s_val=1; else low_s_val=0;
if med_p>0 then med_p_val=1; else med_p_val=0;
if med_s>0 then med_s_val=1; else med_s_val=0;
if high_p>0 then hig_p_val=1; else hig_p_val=0;
if high_s>0 then hig_s_val=1; else hig_s_val=0;
run;

*Now assign the company level risk scores according to the same methodology as for the Potential score;
data segmt.comp_risk_scores;
set segmt.comp_risk_scores;
if hig_p_val >0 then comp_risk_score = 'High';
else if med_p_val >0 then comp_risk_score = 'Med';
else if low_p_val >0 then comp_risk_score = 'Low';
else if hig_s_val >0 then comp_risk_score = 'High';
else if med_s_val >0 then comp_risk_score = 'Med';
else if low_s_val >0 then comp_risk_score = 'Low';
run;

proc freq data = segmt.comp_risk_scores;
tables comp_risk_score / missing;
title 'Risk Score assigned at Company Level';
run;
/*14,462 (1.17%) in High, 1,213,454 (98.59%) in Low and 2,942 (0.24%) in Med*/

*************************************COMBINING THE THREE SCORES AT COMPANY LEVEL**************************************;
*We now have three scores at company level for each company - Current Value, Potential and Risk.  Need to combine 
these into one file by compid;
proc sort data = segmt.comp_curr_score; by compid; run; *1,230,858;
proc sort data = segmt.comp_pot_scores; by compid; run; *1,230,858;
proc sort data = segmt.comp_risk_scores; by compid; run; *1,230,858;

data segmt.total_comp_scores;
	merge segmt.comp_curr_score (in=a keep=comp_rev_score compid)
          segmt.comp_pot_scores (in=b keep=compid comp_pot_score)
          segmt.comp_risk_scores (in=c keep=compid comp_risk_score);
by compid;
if a or b or c then output;
run;

*Merge company segment onto the files so that we can assess which companies need to be given a value (ie those that
are not in A-E) - also merge on L12 and P12 total RM rev (grouped to company level);
proc sort data = segmt.site_final (keep=compid compseg) nodupkey out = compseg_temp; by compid; run;
proc sort data = segmt.site_final (keep=compid totalrmrevL12 totalrmrevP12) out = tempsite; by compid; run;*1,405,853;

*Group the revenue streams up to company level using compid;
proc sort data = tempsite; by compid; run;
proc means data = tempsite noprint;
var totalrmrevL12 totalrmrevP12;
by compid;
output out = tempcomp sum=;
run;
*1,230,858 companies;

*Merge these revenue streams onto the overall company score file;
data segmt.total_comp_scores bada1 bada2;
	merge segmt.total_comp_scores (in=a)
	      tempcomp (in=b keep=totalrmrevL12 totalrmrevP12 compid)
          compseg_temp (in=c);
by compid;
if a then output segmt.total_comp_scores;
if a and not b then output bada1;
if a and not c then output bada2;
run;
*0 in bad files;

proc freq data = segmt.total_comp_scores;
where compseg in ('F','G','H','I','J','U');
tables comp_rev_score*comp_pot_score*comp_risk_score / missing list out = segmt.comb_comp_scores;
title 'Company Level Value Combinations';
run;
*CHECK THIS LIST TO ENSURE THAT ALL COMBINATIONS ARE ACCOUNTED FOR IN THE CODE BELOW;

******************************COMBINING THE VALUES TO CREATE OVERALL SEGMENT VALUES***********************************;

data segmt.total_comp_scores;
length new_compseg $2.;
set segmt.total_comp_scores;
if compseg in ('F','G','H','I','J','U') then do;
*WHEN TRANSFERRED TO MARS,PUT TRACK&TRACE INTO THE P12 REV AS WELL;
	if comp_rev_score=0 and totalrmrevP12 >0 then new_compseg = 'J';
	else if comp_rev_score=0 and totalrmrevP12 <=0 then new_compseg = 'U';

	else if comp_rev_score = 0 then new_compseg = 'I';
	else if comp_rev_score = 1 then new_compseg = 'I';
	else if comp_rev_score = 2 then new_compseg = 'I';
	else if comp_rev_score = 3 and comp_pot_score = 'Low' and comp_risk_score = 'Low' then new_compseg = 'I';
	else if comp_rev_score = 3 and comp_pot_score = 'Low' and comp_risk_score = 'Med' then new_compseg = 'I';
	else if comp_rev_score = 3 and comp_pot_score = 'Low' and comp_risk_score = 'High' then new_compseg = 'I';

	else if comp_rev_score = 3 and comp_pot_score = 'Med' and comp_risk_score = 'Low' then new_compseg = 'H';
	else if comp_rev_score = 3 and comp_pot_score = 'Med' and comp_risk_score = 'High' then new_compseg = 'H';
	else if comp_rev_score = 3 and comp_pot_score = 'Med' and comp_risk_score = 'Med' then new_compseg = 'H';
	else if comp_rev_score = 5 and comp_pot_score = 'Med' and comp_risk_score = 'Low' then new_compseg = 'H';
	else if comp_rev_score = 5 and comp_pot_score = 'Med' and comp_risk_score = 'High' then new_compseg = 'H';
	else if comp_rev_score = 5 and comp_pot_score = 'Med' and comp_risk_score = 'Med' then new_compseg = 'H';

	else if comp_rev_score = 3 and comp_pot_score = 'High' and comp_risk_score = 'Low' then new_compseg = 'H+';
	else if comp_rev_score = 3 and comp_pot_score = 'High' and comp_risk_score = 'High' then new_compseg = 'H+';
	else if comp_rev_score = 3 and comp_pot_score = 'High' and comp_risk_score = 'Med' then new_compseg = 'H+';

	else if comp_rev_score = 5 and comp_pot_score = 'Low' and comp_risk_score = 'Low' then new_compseg = 'G';
	else if comp_rev_score = 5 and comp_pot_score = 'Low' and comp_risk_score = 'Med' then new_compseg = 'G';
	else if comp_rev_score = 5 and comp_pot_score = 'Low' and comp_risk_score = 'High' then new_compseg = 'G';
	else if comp_rev_score = 7 and comp_pot_score = 'Low' and comp_risk_score = 'Low' then new_compseg = 'G';
	else if comp_rev_score = 7 and comp_pot_score = 'Low' and comp_risk_score = 'High' then new_compseg = 'G';
	else if comp_rev_score = 7 and comp_pot_score = 'Low' and comp_risk_score = 'Med' then new_compseg = 'G';
	else if comp_rev_score = 8 and comp_pot_score = 'Low' and comp_risk_score = 'Low' then new_compseg = 'G';
	else if comp_rev_score = 8 and comp_pot_score = 'Low' and comp_risk_score = 'High' then new_compseg = 'G';
	else if comp_rev_score = 8 and comp_pot_score = 'Low' and comp_risk_score = 'Med' then new_compseg = 'G';

	else if comp_rev_score = 5 and comp_pot_score = 'High' and comp_risk_score = 'Low' then new_compseg = 'F';
	else if comp_rev_score = 5 and comp_pot_score = 'High' and comp_risk_score = 'High' then new_compseg = 'F';
	else if comp_rev_score = 5 and comp_pot_score = 'High' and comp_risk_score = 'Med' then new_compseg = 'F';
	else if comp_rev_score = 7 and comp_pot_score = 'Med' and comp_risk_score = 'Low' then new_compseg = 'F';
	else if comp_rev_score = 7 and comp_pot_score = 'Med' and comp_risk_score = 'High' then new_compseg = 'F';
	else if comp_rev_score = 7 and comp_pot_score = 'High' and comp_risk_score = 'High' then new_compseg = 'F';
	else if comp_rev_score = 7 and comp_pot_score = 'High' and comp_risk_score = 'Low' then new_compseg = 'F';
	else if comp_rev_score = 7 and comp_pot_score = 'High' and comp_risk_score = 'Med' then new_compseg = 'F';
	else if comp_rev_score = 7 and comp_pot_score = 'Med' and comp_risk_score = 'Med' then new_compseg = 'F';
	else if comp_rev_score = 8 and comp_pot_score = 'High' and comp_risk_score = 'High' then new_compseg = 'F';
	else if comp_rev_score = 8 and comp_pot_score = 'High' and comp_risk_score = 'Low' then new_compseg = 'F';
	else if comp_rev_score = 8 and comp_pot_score = 'High' and comp_risk_score = 'Med' then new_compseg = 'F';
	else if comp_rev_score = 8 and comp_pot_score = 'Med' and comp_risk_score = 'High' then new_compseg = 'F';
	else if comp_rev_score = 8 and comp_pot_score = 'Med' and comp_risk_score = 'Low' then new_compseg = 'F';
	else if comp_rev_score = 8 and comp_pot_score = 'Med' and comp_risk_score = 'Med' then new_compseg = 'F';


	end;

else if compseg in ('A','B','C','C+','D','D+','E','E-','E+') then new_compseg=compseg;

run;

proc freq data = segmt.total_comp_scores;
where compseg in ('F','G','H','I','J','U');
tables new_compseg / missing;
title 'Company Segment Values at Company Level';
run;
*F   13904        1.14% 
G   21077        1.73%   
H   48851        4.00%         
H+  6994         0.57% 
I   271493       22.25%      
J   63688        5.22% 
U   794220       65.09%

*Compare these to the old company segment volumes;
proc freq data = segmt.total_comp_scores;
where compseg in ('F','G','H','I','J','U');
tables compseg / missing;
title  'Old Company Segment Values at Company Level';
run;

*Look at segment migration from new to old segments;
proc freq data = segmt.total_comp_scores;
where compseg in ('F','G','H','I','J','U');
tables compseg*new_compseg / missing;
title 'Segment Migration from Old Company Segment to New Company Segment';
run;

*Need to apply these company values to the sites within the companies so that we can run some profiling;
proc sort data = segmt.total_comp_scores; by compid; run; *1,230,858;
proc sort data = jul04.site (keep=bsn compid empband mktsect totalrmrevL12 busmail cleanm d2d icount idirect
                             iresp istl izandf meter msle mslp pobox ppost pstream respserv sdrevL12 siteseg
                             st stl sduser) out = segmt.site_profs; by compid; run; *1,405,853;

data segmt.site_profs bada badb;
	merge segmt.site_Profs (in=a)
	      segmt.total_comp_scores (in=b keep=compid compseg new_compseg);
by compid;
if a then output segmt.site_profs;
if b and not a then output badb;
if a and not b then output bada;
run;
*0 in bada and badb;

*Fill in the blank values for all the product usage fields;
data segmt.site_profs;
set segmt.site_profs;
if busmail = ' ' then busmail = 'N'; else busmail = busmail;
if cleanm = ' ' then cleanm = 'N'; else cleanm = cleanm;
if d2d = ' ' then d2d = 'N'; else d2d = d2d;
if icount = ' ' then icount = 'N'; else icount = icount;
if idirect = ' ' then idirect = 'N'; else idirect = idirect;
if iresp = ' ' then iresp = 'N'; else iresp = iresp;
if istl = ' ' then istl = 'N'; else istl = istl;
if izandf = ' ' then izandf = 'N'; else izandf = izandf;
if meter = ' ' then meter = 'N'; else meter = meter;
if msle = ' ' then msle = 'N'; else msle = msle;
if mslp = ' ' then mslp = 'N'; else mslp = mslp;
if pobox = ' ' then pobox = 'N'; else pobox = pobox;
if ppost = ' ' then ppost = 'N'; else ppost = ppost;
if pstream = ' ' then pstream = 'N'; else pstream = pstream;
if respserv = ' ' then respserv = 'N'; else respserv = respserv;
if st = ' ' then st = 'N'; else st = st;
if stl = ' ' then stl = 'N'; else stl = stl;
run;

*Create an SD user flag;
data segmt.site_profs;
set segmt.site_profs;
if sdrevL12 >0 then sd = 'Y'; else sd = 'N';
run;

*Run some site level profiles for each of the segments;
ods csv file="N:\data\car_data\roy_mail\RMD\Overarching Segmentation\Output data\site_profs_rev_100505.csv";
proc freq data = segmt.site_profs;
where new_compseg in ('F','G','H','H+','I','J','U');
tables empband*new_Compseg / missing norow nocol nopercent nocum;
tables mktsect*new_Compseg / missing norow nocol nopercent nocum;
tables busmail*new_Compseg / missing norow nocol nopercent nocum;
tables cleanm*new_Compseg / missing norow nocol nopercent nocum;
tables d2d*new_Compseg / missing norow nocol nopercent nocum;
tables icount*new_Compseg / missing norow nocol nopercent nocum;
tables idirect*new_Compseg / missing norow nocol nopercent nocum;
tables iresp*new_Compseg / missing norow nocol nopercent nocum;
tables istl*new_Compseg / missing norow nocol nopercent nocum;
tables izandf*new_Compseg / missing norow nocol nopercent nocum;
tables meter*new_Compseg / missing norow nocol nopercent nocum;
tables msle*new_Compseg / missing norow nocol nopercent nocum;
tables mslp*new_Compseg / missing norow nocol nopercent nocum;
tables pobox*new_Compseg / missing norow nocol nopercent nocum;
tables ppost*new_Compseg / missing norow nocol nopercent nocum;
tables pstream*new_Compseg / missing norow nocol nopercent nocum;
tables respserv*new_Compseg / missing norow nocol nopercent nocum;
tables sd*new_Compseg / missing norow nocol nopercent nocum;
tables st*new_Compseg / missing norow nocol nopercent nocum;
tables stl*new_Compseg / missing norow nocol nopercent nocum;
run;
ods _all_ close;
ods listing;

*Fill in the blanks in the total RM revenue field;
data segmt.site_profs;
set segmt.site_profs;
if totalrmrevL12 = . then totalrmrevL12 = 0; else totalrmrevL12=totalrmrevL12;
run;

*Look at the mean revenue by segment;
proc sort data = segmt.site_profs; by new_compseg; run;
proc means data = segmt.site_profs noprint;
var totalrmrevL12;
by new_compseg;
output out = segmt.rmrev_by_new_compseg sum=totalrmrevL12 mean=meanrmrevL12;
run;


*Look at the proc freq by segment at Site Level;
proc freq data = segmt.site_Profs;
where compseg in ('F','G','H','I','J','U');
tables new_compseg / missing;
title 'New Segment Values at Site Level';
run;
*Cool!  See output for volume by segment;

proc freq data = segmt.site_profs;
where compseg in ('F','G','H','I','J','U');
tables compseg / missing;
title  'Old Segment Values at Site Level';
run;

		****************************************************************************************************

*Run a proc freq by new company segment of the combinations of the three scores at company level - for reference;

/*Segment F*/
proc freq data = segmt.total_comp_scores;
where new_compseg = 'F';
tables comp_rev_score*comp_pot_score*comp_risk_score / missing list;
title 'Score Combinations for New Segment F';
run;

/*Segment G*/
proc freq data = segmt.total_comp_scores;
where new_compseg = 'G';
tables comp_rev_score*comp_pot_score*comp_risk_score / missing list;
title 'Score Combinations for New Segment G';
run;

/*Segment H*/
proc freq data = segmt.total_comp_scores;
where new_compseg = 'H';
tables comp_rev_score*comp_pot_score*comp_risk_score / missing list;
title 'Score Combinations for New Segment H';
run;

/*Segment H+*/
proc freq data = segmt.total_comp_scores;
where new_compseg = 'H+';
tables comp_rev_score*comp_pot_score*comp_risk_score / missing list;
title 'Score Combinations for New Segment H+';
run;

/*Segment I*/
proc freq data = segmt.total_comp_scores;
where new_compseg = 'I';
tables comp_rev_score*comp_pot_score*comp_risk_score / missing list;
title 'Score Combinations for New Segment I';
run;

*Look at the site level values against each site's gapspend so that we can create a gap level total amount for each
segment;
proc sort data = segmt.site_profs; by bsn; run;
proc sort data = segmt.site_final; by bsn; run;

data segmt.site_profs bada badb;
	merge segmt.site_profs (in=a)
	      segmt.site_final (in=b keep=bsn gapspend);
by bsn;
if a then output segmt.site_profs;
if b and not a then output badb;
if a and not b then output bada;
run;
* 0 in the bad files;

*Fill in the missing blank values within the revenue fields;
data segmt.site_profs;
set segmt.site_profs;
if totalrmrevL12 = . then totalrmrevL12 = 0; else totalrmrevL12 = totalrmrevL12;
if gapspend = . then gapspend =0; else gapspend=gapspend;
run;

*Create a volume of gapspend by new segment value - for all sites and then for sites with positive gapspend;
proc sort data = segmt.site_profs; by new_compseg; run;
proc means data = segmt.site_profs noprint;
where gapspend >0;
var gapspend;
by new_compseg;
output out=segmt.gapvalues_site_rev sum=tot_gapspend mean=av_gapspend;
run;

*For primary sites only;
proc means data = segmt.site_profs noprint;
where gapspend >0 and siteseg in ('F','G','H','I','J','U');
var gapspend;
by new_compseg;
output out=segmt.gapvalues_prisite_rev sum=tot_gapspend mean=av_gapspend;
run;

*Average Total RM Rev for all sites;
proc means data = segmt.site_profs noprint;
var totalrmrevL12;
by new_compseg;
output out=segmt.rmspend_site_all_rev sum=totrmrevL12 mean=av_rmrevL12;
run;

*Average Total RM Rev for sites with positive gapspend;
proc means data = segmt.site_profs noprint;
where gapspend >0;
var totalrmrevL12;
by new_compseg;
output out=segmt.rmspend_site_posgapspend_rev sum=totrmrevL12 mean=av_rmrevL12;
run;

*END;

