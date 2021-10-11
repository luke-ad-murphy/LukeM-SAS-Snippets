
SYMBOL interpol = boxt0 bwidth=5 width=1 color=blue 
       value=dot cv=red height=1; 
      axis1 order = (-50 to 20 by 1) offset=(1,1) 
            label = (height = 1 'New value') minor=none; 
axis2 order = (0 to 150 by 10) offset=(1,1) 
      /*label = (height = 1 'MRC') */; 

PROC GPLOT DATA = kf_1.lm_1706_oct_vals; 
PLOT New_value_measure * Cash_MRC_band2 / 
/*anno=special */
haxis=axis1 
vaxis=axis2;  
/*FORMAT group Grp.; */
TITLE H=1.5 " 
/*upper/lower */
/*whisker represent */
/*the 90th & 10th */
/*percentiles"; */;
RUN; 
QUIT;
