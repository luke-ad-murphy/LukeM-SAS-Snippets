data data_for_plots;
input Contrast $22. Foldchange Lower_Confidence_Limit Higher_Confidence_Limit;
cards;
Treatment A Vs Placebo 2.52 2.12 2.98 
Treatment B Vs Placebo 1.18 0.97 1.42 
;
run;

ods html style=statistical;
proc sgplot data = data_for_plots;
scatter x = Contrast y = Foldchange / datalabel = Foldchange 
group = Contrast YERRORLOWER = Lower_Confidence_Limit 
YERRORUPPER = Higher_Confidence_Limit markerattrs = (symbol = "circle"); 
refline 1 / axis = y lineattrs = (pattern = 2 color = "black"); 
yaxis logbase = 10 logstyle = logexpand type = log; 
run; 
