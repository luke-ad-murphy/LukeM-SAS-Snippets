libname mc_1 '/var/opt/analysis_1' compress=yes;
libname mc_2 '/var/opt/analysis_2'  compress=yes;
libname kf_1 '/var/opt/analysis_3'  compress=yes;
libname kf_2 '/var/opt/analysis_4' compress=yes;
libname Asis5 '/var/opt/analysis_5'  compress=yes;
libname Ts_1 '/var/opt/analysis_6'  compress=yes;
libname SG_1 '/var/opt/analysis_7' compress=yes;
libname Asis9 '/var/opt/analysis_9' compress=yes;
libname SA_1 '/var/opt/analysis_12' compress=yes;
libname Margin '/var/opt/analysis_13' compress=yes access=readonly;
libname new_camp '/var/opt/campain_lists' compress=yes ;                                                   
libname jl_1 '/var/opt/campain_lists/jo' compress=yes ;                                                   
libname RM_1 '/var/opt/analysis_11' compress=yes;
libname SS_1 '/var/opt/analysis_8'  compress=yes;



proc datasets library=SG_1 details;
run;
quit;