** 

Copyright (c) 2007-2011 InfoDecipher Corp.

Please do not use this code outside this macro.

** ; 

%macro gnbcreg(var=ALL, data=, y=, epsilon=0.001, maxiter=10, short=NO, id=, entry=,
               outest=, out=, scaling=RANKS, diagnostics=YES, selection=NONE, method=GNBC, 
               treatment=NONE, globalsmoothing=60, corrlimit=0.50, prescreen=YES, 
               globalbinning=50) ;
   %if %bquote(&treatment)=NONE %then %do ; 
   title1 "The GNBCREG Macro: Y=%upcase(&y)" ;
   %end ;
   %else %do ; 
   title1 "The GNBCREG Macro: Y=%upcase(&y), TREATMENT=%upcase(&treatment)" ;
   %end ; 

   options obs=max nonotes nomprint nodate nonumber  ;
   
   ***********************************************************
   *  Important macro variables                              *
   ********************************************************* *
   &dim = number of input variables
   &&smooth&i = ith smoothing paramter
   &&var&i = ith variable
   &&pregroup&i = Pre-bin paramters
   &nobs = number observations in dataset
   &totalSet1 = Total number goods
   &totalSet0 = Total number bads
   &intercept = Intercept of the model
   &maxlength = Maximum variable-length
   &i = index to loop over variables
   &iter = Iteration number for GNBC algorithm

   ***********************************************************
   *  Important Data sets                                    *
   ********************************************************* *
   gnbc = Full dataset scored
   b&&var&i = Estimates for variable &i  ;


   ***********************************************************
   *  Stagewise selection macro                              *
   ********************************************************* ;
   %macro stagewisesel ;

      %let any_variables_left=1 ; 

	  %do j=1 %to &dim ; 
	     %let selected&j=0 ;
		 %let blacklisted&j=0 ; 
      %end ;  

      proc logistic data=_gnbc_ 
         outest=_selected_ descending noprint ; 
	     model 
         %if %bquote(&treatment) ne NONE %then %do ; 
            _response_ 
         %end ; 
         %else %do ; 
		    &y
         %end ; 
                  = %do j=1 %to &dim ;
		               %if &&selected&j=0 and &&skipped&j=0 %then %do ; 
                         _&&var&j
			           %end ; 
                   %end; / selection=forward slentry=&entry stop=1 nocheck ;
	     output out=_localscores_ xbeta=_stagewise_  ; 
	  run ; 

      data _localscores_ ; 
         set _localscores_ %if %bquote(&treatment) ne NONE %then %do ;
                              (where=(_level_=4))
                           %end ; ;
		 drop _level_ ; 
      run ; 
   
      proc transpose data=_selected_ out=_selected_ ;
	  run ; 

      data _null_ ;
	     %if %bquote(&treatment)=NONE %then %do ; 
         set _selected_ (where=(&y>.)) end=eof ; 
		 %end ; 
         %else %do ; 
         set _selected_ (where=(_response_>.)) end=eof ; 
         %end ; 
		 retain matches 0 this_var ; 
		 %do j=1 %to &dim ; 
		    matches=matches+(upcase(_name_)=%upcase("_&&var&j")) ; 
 		    if upcase(_name_)=%upcase("_&&var&j") then this_var="&&var&j" ;
		 %end ; 
		 if eof then do ; 
		    call symputx('any_variables_left',(matches>0)) ; 
		    call symputx('this_var',this_var) ; 
         end ;  
      run ;

      %do j=1 %to &dim ;
	     %let selected&j=0 ; 
         data _null_ ;
		    %if %bquote(&treatment)=NONE %then %do ; 
               set _selected_ (where=(upcase(compress(_name_))=%upcase("_&&var&j") and &y>0)) ;
			%end ; 
			%else %do ; 
               set _selected_ (where=(upcase(compress(_name_))=%upcase("_&&var&j") 
                               and _response_>0)) ;
			%end ; 
            call symputx("selected&j",1) ;
        run ;
      %end ;

	  proc delete data=_selected_ ; 
	  run ; 

	  %if %bquote(&this_var) ne %then %do ; 
	     %put Variable &this_var added to the model ; 
		 %put ;
	  %end ; 
	  %else %do ; 
	     %put No variable met the required significance level (alpha=&entry) ; 
	  %end ; 
	  
	  %let qualifiers=0 ; 
      %do j=1 %to &dim ; 
	     %if &&selected&j=0 and &&skipped&j=0 %then %do ; 
            %let qualifiers=%eval(&qualifiers+1) ; 
         %end ; 
      %end ; 

      %let missed_rounds=0 ;

      %do %while (&any_variables_left=1 and &qualifiers>0) ;

	     %let corr=0 ; 
         %let wrong_slope=0 ;  
        
         %if &qualifiers>0 %then %do ;
	         proc logistic data=_localscores_ outest=_selected_ descending noprint ; 
			 model
	         %if %bquote(&treatment) ne NONE %then %do ; 
	            _response_ 
	         %end ; 
	         %else %do ; 
			    &y
	         %end ; 
		         = _stagewise_
	                       %do j=1 %to &dim ;
			                  %if &&selected&j=0 and &&skipped&j=0 
                                  and &&blacklisted&j=0 %then %do ; 
	                             _&&var&j
				              %end ; 
	                       %end; / selection=forward slentry=&entry stop=2
	                               include=1 nocheck ;
		       output out=_localscores_new 
	                   (drop=_stagewise_) xbeta=_stagewise_new ; 
		     run ;

             data _localscores_new ; 
                set _localscores_new %if %bquote(&treatment) ne NONE %then %do ;
                                    (where=(_level_=4))
                                  %end ; ; 
		        drop _level_ ; 
             run ; 
   
			 proc transpose data=_selected_ out=_selected_ ;
		     run ; 

             data _null_ ;
         	    set _selected_
	            %if %bquote(&treatment) ne NONE %then %do ; 
                   (where=(_response_>.)) 
				%end ; 
				%else %do ; 
                   (where=(&y>.)) 
                %end ; 
                end=eof ;
                length this_var $ &maxlength ;  
				retain this_var ;
		        retain matches 0 ; 
				retain right_signs 0 ;
				retain this_j ; 
				retain this_slope ; 
				%if %bquote(&treatment)=NONE %then %do ; 
				   coresplope_wrong+(_name_="_stagewise_")*(&y<0) ;   
                %end ;
                %else %do ; 
				   coresplope_wrong+(_name_="_stagewise_")*(_response_<0) ;   
                %end ; 
		        %do j=1 %to &dim ; 
				   if upcase(_name_)=%upcase("_&&var&j") then do ; 
                      this_var="&&var&j" ; 
					  this_j=&j ; 
					  %if %bquote(&treatment)=NONE %then %do ; 
					  this_slope=&y ; 
					  %end ; 
					  %else %do ; 
					  this_slope=_response_ ; 
					  %end ; 
				   end ; 
		           matches=matches+(upcase(_name_)=%upcase("_&&var&j")) ; 
				   %if %bquote(&treatment)=NONE %then %do ;
		           right_signs=right_signs+(upcase(_name_)=%upcase("_&&var&j"))*(&y>0) ; 
				   %end ; 
				   %else %do ; 
		           right_signs=right_signs+(upcase(_name_)=%upcase("_&&var&j"))*(_response_>0) ; 
                   %end ; 
		        %end ; 
		        if eof then do ; 
		           call symputx('any_variables_left',(matches>0)) ; 
				   call symputx('this_var',this_var) ;
				   call symputx('this_j',this_j) ; 
				   call symputx('this_slope',this_slope) ; 
		           call symputx('wrong_slope',(right_signs=0 or coresplope_wrong>0)*(matches>0)) ; 
                end ;  
             run ;

			 %if %bquote(&this_var) ne %then %do ; 
			    proc corr data=_localscores_ noprint out=_corr_ 
                  (where=(_type_="CORR")) ; 
			      var _&this_var ;
                  with %do j=1 %to &dim ; 
                     %if &&selected&j=1 %then %do ; 
                        _&&var&j
                     %end ; 
                  %end ;; 
			    run ; 
			    data _null_ ; 
			       set _corr_ (keep=_&this_var) end=eof ;
                   retain maxcorr 0 ; 
                   if abs(_&this_var)>maxcorr then maxcorr=abs(_&this_var) ;  
				   if eof then call symputx("corr",(maxcorr>&corrlimit)) ; 
                run ; 
				proc delete data=_corr_ ; 
				run ; 
			 %end ; 			 
		 %end; 
		 %else %do ; 
		     %let any_variables_left=0 ; 
		 %end ; 

		 %if &wrong_slope=1 or &corr=1 %then %do ; 
			%let blacklisted&this_j=1 ; 
		 %end ; 

		 %if &wrong_slope=1 or &corr=1 %then %let missed=1 ; 
		 %else %let missed=0 ; 

         %let missed_rounds=%eval(&missed_rounds+&missed) ; 

		 %if &any_variables_left=1 and &wrong_slope=0 and &corr=0 %then %do ; 

		    %put Variable &this_var added to the model ; 
			%put ;

		    data _localscores_ ; 
               set _localscores_new ; 
               rename _stagewise_new=_stagewise_ ; 
            run ; 

			%let selected&this_j=1 ; 

			%let missed_rounds=0 ; 

         %end ;  

		 %let qualifiers=0 ; 		
         %do j=1 %to &dim ; 
		    %if &&selected&j=0 and &&skipped&j=0 and &&blacklisted&j=0 %then %do ; 
               %let qualifiers=%eval(&qualifiers+1) ; 
            %end ; 
         %end ; 

		 proc delete data=_localscores_new _selected_; 
		 run ; 

		 /*
		 %put Any variables left = &any_variables_left ; 
		 %put Number of qualified variables left = &qualifiers ;
         %put Number of missed rounds = &missed_rounds ;  
		 */ 

      %end ;


     %put SELECTED VARIABLES: ;
	 %let total_selected=0 ; 
     %do j=1 %to &dim ;
	    %let total_selected=%eval(&total_selected+&&selected&j) ; 
        %if &&selected&j=1 %then %put &&var&j ;
     %end ;
     %put ;

	 data _null_ ; 
	    if &total_selected<=1 then do ; 
		    put "Less than 2 variables selected.  The macro stopped." ; 
		    abort ; 
		end ; 
	 run ; 

	 data _gnbc_ ; 
	    set _gnbc_ ; 
        %do j=1 %to &dim ;
           %if &&selected&j=0 %then %do ; 
               drop &&var&j g&j b&j ;
		   %end ; 
        %end ;
	 run ; 

	 proc delete data=_localscores_ ; 
	 run ; 

  %mend ;  
  %macro varclus ; 
     ods listing close ; 
     ods output clustersummary=_summary_ rsquare(match_all)=_clusters_; 
     proc varclus data=_gnbc_ maxeigen=1 ; 
        var %do j=1 %to &dim ;
			   %if &&skipped&j=0 %then %do ; 
	               _&&var&j
			   %end ; 
	        %end; ; 
     run ; 
     ods listing ; 

	 data _null_ ; 
        set _summary_ end=eof ; 
        if eof then call symputx('nclusters',cluster-2) ; 
     run ; 

	 data _clusters_ ; 
	    length variable $32 ; 
	    set _clusters_&nclusters ; 
	    retain cluster_full ; 
        if cluster ne '' then cluster_full=cluster ; 
     run ; 

	 proc sort data=_clusters_ ; 
	    by cluster_full rsquareratio ; 
	 run ; 

     data _clusters_ ; 
        set _clusters_ ; 
        by cluster_full ; 
        if first.cluster_full ; 
     run ; 

     %do j=1 %to &dim ;
	    %let selected&j=0 ; 
        data _null_ ;
           set _clusters_ (where=(upcase(compress(variable))=%upcase("_&&var&j")
                           and NextClosest<&corrlimit)) ;
           call symputx("selected&j",1) ;
       run ;
     %end ;

	 proc delete data=_clusters_ _summary_  
                      %do j=1 %to &nclusters ; 
                         _clusters_&j 
                      %end ; ; 
	 run ; 
      
   %mend ; 



   ***********************************************************
   *  Macro to check the feasibility of a variable           *
   ********************************************************* ;
   %macro feasibility ; 
   %do i=1 %to &dim ; 

      proc sql noprint ; 
         select nmiss(&&var&i)/count(*) into :percmiss&i 
		 from _gnbc_ ; 
	  quit ; 

	  %if &&percmiss&i>0.98 %then %let skipped&i=1 ; 

      proc sql ; 
	     create table _separation_ as
		 select mean(&y) as perc_good, 
		        &&var&i as &&var&i,
		        count(*) / (select count(*) from _gnbc_) as perc
		 from _gnbc_ 
		 group by &&var&i ; 
	  quit ; 

	  data _null_ ; 
	     set _separation_ end=eof nobs=n ; 
		 retain problem 0 ;
		 %if &&type&i=n %then %do ; 
		    problem=problem+(perc_good=1 or perc_good=0)*(perc>0.02)*(&&var&i=.) ;
		    problem=problem+(perc_good=1 or perc_good=0)*(perc>0.25) ;
  		 %end ; 
		 %else %do ; 
		    problem=problem+(perc_good=1 or perc_good=0)*(perc>0.02) ;
		 %end ; 
		 if eof then do ; 
		    if n=1 then problem=1 ; 
		    %if &&type&i=c %then %do ; 
			   if n>100 then problem=1 ;
			%end; 			   
		    call symputx('sparseness',(problem>0)) ; 
			call symputx("uniquevalues&i",n) ;
  		 end ; 
	  run ; 

	  proc delete data=_separation_ ; 
	  run ; 

	  %if &sparseness=1 %then %let skipped&i=1 ;

	  %if &&skipped&i=1 %then %do ; 
	     %if &&percMiss&i>0.98 %then %do ; 
            %put NOTE:  Variable &&var&i was excluded due to too many missing values (>98%) ; 
         %end ; 
         %else %if &&uniqueValues&i=1 %then %do ; 
            %put NOTE:  Variable &&var&i was excluded because it is a constant ;
         %end ; 
         %else %if &&uniqueValues&i>100 and &&type&i=c %then %do ; 
             %put NOTE:  Character variable &&var&i was excluded because it has too many categories  ;
		 %end ; 
		 %else %do ; 
             %put NOTE:  Variable &&var&i was excluded because of quasi-complete separation of data points  ;
		 %end ;
	  %end ; 
   %end ; 
   %mend ;
    

   ***********************************************************
   *  Macro to pre-weight g functions                        *
   ********************************************************* ;
   %macro preweight ;
   %if %bquote(&treatment)=NONE %then %do ; 
	   proc logistic data=_gnbc_
	                 outest=pretweaks
	                 descending
	                 noprint ;
	      model &y = %do i=1 %to &dim ;
	                     %if &&selected&i=1 %then %do ;
	                        g&i
	                     %end ;
	                 %end ; / nocheck ;
	   run ;
   %end ; 
   %else %do ; 
	   proc logistic data=_gnbc_  
	                 outest=pretweaks
	                 descending
	                 noprint ;
	      model _response_ = %do i=1 %to &dim ;
	                     %if &&selected&i=1 %then %do ;
	                        g&i
	                     %end ;
	                 %end ; / nocheck ;
	   run ;

	   data pretweaks ; 
	      set pretweaks ; 
		  intercept=0 ; 
	   run ;
   %end ; 
   %do i=1 %to &dim ;
      %if &&selected&i %then %do ;
      data _null_ ;
         set pretweaks(keep=g&i) ;
         call symputx("pretweak&i",g&i) ;
      run ;
      data b&&var&i ;
         set b&&var&i ;
         b1=g*(&&pretweak&i-1) ;
      run ;
      %end ;
   %end ;
   data _gnbc_ ;
      if _n_=1 then set pretweaks(keep=intercept) ;
      set _gnbc_ (drop=intercept) ;
      %do i=1 %to &dim ;
         %if &&selected&i %then %do ;
         b&i=g&i*(&&pretweak&i-1) ;
         %end ;
      %end ;
   proc delete data=pretweaks ;
   run ;
   %mend ;

   ***********************************************************
   *  Macro to pre-group variables                           *
   ********************************************************* ;
   %macro pregroup ;
   proc rank data=_gnbc_ out=_gnbc_ groups=&&pregroup&i ;
      var &&var&i ;
      ranks &&var&i.._grp ;
   run ; 

   proc sort data=_gnbc_ ;
      by &&var&i.._grp ;
   run ; 

   proc summary data=_gnbc_ ;
      by &&var&i.._grp ;
      var &&var&i r&&var&i ;
      output out=_medians_ (drop=_type_ _freq_) 
                           median(&&var&i)=&&var&i
                           max(&&var&i)=end
                           min(&&var&i)=min
                           mean(r&&var&i)=r&&var&i ; 
   run ; 

   data _gnbc_ ;
      merge _gnbc_ (drop=&&var&i r&&var&i)
            _medians_ (keep=&&var&i.._grp &&var&i r&&var&i) ;
      by &&var&i.._grp ;
      drop &&var&i.._grp ;
   run ; 

   data _&&var&i ;
      keep start end &&var&i ;
      set _medians_ ;
      lag=lag(end) ;
      if _n_=1 then start=min ;
      else if _n_=2 and lag=. then start=min ;
      else start=lag ;
      label start="Start" ;
      label end="End" ;
   run ; 

   proc delete data=_medians_ ;
   run; 

   data _null_ ;
      set _&&var&i nobs=n ;
      call symputx('pregroups',n) ;
   run ;
   %put &&var&i has been pre-grouped with &pregroups groups (target=&&pregroup&i);
   %let pregroup&i=&pregroups ;
   %if &pregroups<6 %then %do ;
      %let smooth&i=0 ;
      %put There are less than 6 unique groups after pre-grouping &&var&i ;
      %put The smoothing parameter for &&var&i has been set to 0 ;
   %end ;
   %put ;
   %mend ;

   ***********************************************************
   *  Macro to center functions                              *
   ********************************************************* ;
   %macro center(parm) ;
      proc summary data=b&&var&i ;
         weight n ;
         %if "&parm"="g" %then %do ;
            var g ;
         %end ;
         %else %do ;
            var b&iter ;
         %end ;
         output out=_mean_(keep=mu) mean=mu ;
	  run ; 

      data b&&var&i ;
         if _n_=1 then set _mean_ ;
         set b&&var&i ;
         %if "&parm"="g" %then %do ;
            g=g-mu ;
         %end ;
         %else %do ;
            &parm.&iter=&parm.&iter-mu ;
         %end ;
         drop mu ;
	  run ; 

      proc delete data=_mean_ ;
      run ;
   %mend ;

   ***********************************************************
   *  Macro to get g functions                               *
   ********************************************************* ;
   %macro smooth ;
      %if &&smooth&i=0 or &&type&i=c %then %do ;
      data _temp ;
         set _gnbc_ (keep=&&var&i &y %if %bquote(&treatment) ne NONE %then %do ;
                                       &treatment
                                    %end ;) ;
      run ;
      proc sql ;
         create table b&&var&i as
         select
             &&var&i,
             sum(&y) as set1,
             sum(&y=0) as set0,
             %if %bquote(&treatment) ne NONE %then %do ;
                sum(&y*&treatment) as set1_t,
                sum(&y*(&treatment=0)) as set1_c,
                sum((&y=0)*&treatment) as set0_t,
                sum((&y=0)*(&treatment=0)) as set0_c,
             %end ;
             count(*) as n
         from _temp
         group by &&var&i
         order by &&var&i ;
      quit ;
      data b&&var&i ;
         set b&&var&i ;
         %if %bquote(&treatment)=NONE %then %do ;
         if min(set1,set0)>0 then
            g=log((set1/&totalSet1)/(set0/&totalSet0)) ;
         else g=0 ;
         %end ;
         %else %do ;
         if min(set1_t,set1_c,set0_t,set0_c)>0 then
            g=log((set1_t/&totalSet1_t)/(set0_t/&totalSet0_t))
              -log((set1_c/&totalSet1_c)/(set0_c/&totalSet0_c)) ;
         else g=0 ;
         %end ;
         start=&&var&i ;
         end=&&var&i ;
	     label g="Naive function" ;
	     label &&var&i="&&var&i" ;
         label start="&&var&i" ;
         label end="&&var&i" ;
         fmtname=compress('var'||"&i"||"_") ;
         b0=0 ;
         type="&&type&i" ;
      run ;
      %center(g) ;
      data b&&var&i ;
         set b&&var&i ;
         label=g ;
	  run ; 
      %end ;
      %else %do ;
	      data _temp ;
	         set _gnbc_ (keep=&&var&i 
                         %if %bquote(&scaling)=RANKS %then %do ; 
                           r&&var&i 
                         %end ; &y
	                     %if %bquote(&treatment) ne NONE %then %do ;
	                       &treatment
	                     %end ; ) ;
	      proc sort data=_temp;
	         by &&var&i ;
	      data _missing_ ;
	         set _temp (where=(&&var&i=.)) ;
	         %if %bquote(&treatment)=NONE %then %do ;
	            set1=&y ;
	            set0=(&y=0) ;
	         %end ;
	         %else %do ;
	            set1_t=&y*&treatment ;
	            set1_c=&y*(&treatment=0) ;
	            set0_t=(&y=0)*&treatment ;
	            set0_c=(&y=0)*(&treatment=0) ;
	         %end ;
	      proc summary data=_missing_ ;
	         var set1: set0: ;
	         output out=_missing_ sum= ;
		  run ; 

	      data _missing_ ;
	         retain &&var&i r&&var&i row n g ;
	         keep &&var&i r&&var&i row n g ;
	         set _missing_ ;
	         n=_freq_ ;
	         &&var&i=. ;
	         r&&var&i=. ;
	         row=0 ;
	         %if %bquote(&treatment)=NONE %then %do ;
	            if min(set1,set0)>0 then
	               g=log((set1/&totalSet1)/(set0/&totalSet0)) ;
	            else g=0 ;
	         %end ;
	         %else %do ;
	            if min(set1_t,set0_t,set1_c,set0_c)>0 then
	               g=log((set1_t/&totalSet1_t)/(set0_t/&totalSet0_t))-
	                 log((set1_c/&totalSet1_c)/(set0_c/&totalSet0_c)) ;
	            else g=0 ;
	         %end ;
	      run ;

	      data _unique_ ;
	         keep capN n row n &&var&i 
             %if %bquote(&scaling)=RANKS %then %do ;
                r&&var&i
             %end ;
             %if %bquote(&treatment)=NONE %then %do ;
			    set1 
		     %end ; 
			 %else %do ; 
			    set1: set0: 
			 %end ; ;
	         retain row 0 ;
	         set _temp (where=(&&var&i>.)) ;
	         %if %bquote(&treatment)=NONE %then %do ;
	            set1+&y ;
	         %end ;
	         %else %do ;
	            set1_t+&y*&treatment ;
	            set1_c+&y*(&treatment=0) ;
	            set0_t+(&y=0)*&treatment ;
	            set0_c+(&y=0)*(&treatment=0) ;
	         %end ;
	         capN+1 ;
	         n+1 ;
	         by &&var&i ;
	         if last.&&var&i then do ;
	            row=row+1 ;
	            output ;
	            n=0 ;
	            %if %bquote(&treatment)=NONE %then %do ;
	               set1=0 ;
	            %end ;
	            %else %do ;
	               set1_t=0 ;
	               set1_c=0 ;
	               set0_t=0 ;
	               set0_c=0 ;
	            %end ;
	         end ;
	      proc delete data=_temp ;
	      data _null_ ;
	         set _unique_ nobs=nobs ;
	         call symputx('unique',nobs) ;
	      run ;
	      data b&&var&i ;
	         %if %bquote(&treatment)=NONE %then %do ;
	             keep nobs1-nobs&unique
	                  events1-events&unique
	                  values1-values&unique
	                  capN ;
	             set _unique_ end=eof ;
	             array nobs[&unique] ;
	             array events[&unique] ;
	             array values[&unique] ;
	             retain nobs1-nobs&unique
	                    events1-events&unique
	                    values1-values&unique ;
	         %end ;
	         %else %do ;
	             keep nobs1-nobs&unique
	                  events_t1-events_t&unique
	                  events_c1-events_c&unique
	                  nonevents_t1-nonevents_t&unique
	                  values1-values&unique
	                  capN ;
	             set _unique_ end=eof ;
	             array nobs[&unique] ;
	             array events_t[&unique] ;
	             array events_c[&unique] ;
	             array nonevents_t[&unique] ;
	             array values[&unique] ;
	             retain nobs1-nobs&unique
	                    events_t1-events_t&unique
	                    events_c1-events_c&unique
	                    nonevents_t1-nonevents_t&unique
	                    values1-values&unique ;
	         %end ;

	         cum+n ;
	         nobs[_n_]=n ;
	         %if %bquote(%upcase(&scaling))=NONE %then %do ;
	            values[_n_]=&&var&i ;
	         %end ;
	         %else %if %bquote(%upcase(&scaling))=RANKS %then %do ;
	            values[_n_]=r&&var&i ;
	         %end ;
	         %if %bquote(&treatment)=NONE %then %do ;
	            events[_n_]=set1 ;
	         %end ;
	         %else %do ;
	            events_t[_n_]=set1_t ;
	            events_c[_n_]=set1_c ;
	            nonevents_t[_n_]=set0_t ;
	         %end ;
	         if eof then output ;
	      run ;
	      data b&&var&i ;
	         keep set1: set0: start end row n ;
	         set b&&var&i ;

	         array nobs[&unique] ;
	         array values[&unique] ;

	         %if %bquote(&treatment)=NONE %then %do ;
	             array events[&unique] ;
	         %end ;
	         %else %do ;
	             array events_t[&unique] ;
	             array events_c[&unique] ;
	             array nonevents_t[&unique] ;
	         %end ;

	         span=floor(&unique*&&smooth&i/2) ;
	         size=floor(capN*&&smooth&i/2) ;
	         do i=1 to &unique ;
	            lower=1 ;
	            upper=&unique ;
	            neighbors1=nobs[i] ;
	            neighbors2=0 ;
	            if nobs[i]>floor(capN*&&smooth&i) then do ;
	               end=i ;
	               start=i ;
	            end ;
	            else do ;
	               j=i-1 ;
	               do while (j ge lower and neighbors1<size) ;
	                  neighbors1=neighbors1+nobs[j] ;
	                  j=j-1 ;
	               end ;
	               start=j+1 ;
	               j=i+1 ;
	               do while (j le upper and neighbors2<size) ;
	                  neighbors2=neighbors2+nobs[j] ;
	                  j=j+1 ;
	               end ;
	               end=j-1 ;
	            end ;
	            d=max(abs(values[end]-values[i]),abs(values[start]-values[i])) ;
	            if d=0 then d=1 ;
	            neighborsW=0 ;
	            neighbors=0 ;
	            %if %bquote(&treatment)=NONE %then %do ;
	               set1=0 ;
	            %end ;
	            %else %do ;
	               set1_t=0 ;
	               set1_c=0 ;
	               set0_t=0 ;
	            %end ;
	             sumLocalWeight=0 ;
	            neighborsL=0 ;
	            neighborsR=0 ;
	            do j=i to start by -1 ;
	               overflow=min(1,size/(neighborsL+nobs[j])) ;
	               neighborsL=neighborsL+nobs[j] ;
	               u=abs(values[j]-values[i])/d ;
	               localweight=(3/4)*(1-u**2) ;
	               %if %bquote(&treatment)=NONE %then %do ;
	                  set1=set1+events[j]*localweight*overflow ;
	               %end ;
	               %else %do ;
	                  set1_t=set1_t+events_t[j]*localweight*overflow ;
	                  set1_c=set1_c+events_c[j]*localweight*overflow ;
	                  set0_t=set0_t+nonevents_t[j]*localweight*overflow ;
	               %end ;
	               neighborsW=neighborsW+nobs[j]*localweight*overflow ;
	               sumLocalWeight=sumLocalWeight+localWeight ;
	            end ;
	            do j=i+1 to end ;
	               overflow=min(1,size/(neighborsR+nobs[j])) ;
	               neighborsR=neighborsR+nobs[j] ;
	               u=abs(values[j]-values[i])/d ;
	               localweight=(3/4)*(1-u**2) ;
	               %if %bquote(&treatment)=NONE %then %do ;
	                  set1=set1+events[j]*localweight*overflow ;
	               %end ;
	               %else %do ;
	                  set1_t=set1_t+events_t[j]*localweight*overflow ;
	                  set1_c=set1_c+events_c[j]*localweight*overflow ;
	                  set0_t=set0_t+nonevents_t[j]*localweight*overflow ;
	               %end ;
	               neighborsW=neighborsW+nobs[j]*localweight*overflow ;
	               sumLocalWeight=sumLocalWeight+localWeight ;
	            end ;
	            neighbors=neighborsL+neighborsR ;
	            adjustment=neighbors/neighborsW ;
	            %if %bquote(&treatment)=NONE %then %do ;
	               set0=neighborsW-set1 ;
	               set1=set1*adjustment ;
	               set0=set0*adjustment ;
	            %end ;
	            %else %do ;
	               set0_c=neighborsW-sum(set1_t,set1_c,set0_t) ;
	               set1_t=set1_t*adjustment ;
	               set1_c=set1_c*adjustment ;
	               set0_t=set0_t*adjustment ;
	               set0_c=set0_c*adjustment ;
	            %end ;
	            row=i ;
	            n=nobs[i] ;
	            output b&&var&i ;
	         end ;
	      run ;
	      data b&&var&i ;
	         keep &&var&i 
             %if %bquote(%upcase(&scaling))=RANKS %then %do ;
                r&&var&i 
             %end ; row n g ;
	         merge b&&var&i _unique_ (keep=&&var&i r&&var&i row) ;
	         by row ;
	         %if %bquote(&treatment)=NONE %then %do ;
	            if min(set1,set0) ge 1 then g=log((set1/&totalSet1)/(set0/&totalSet0)) ;
	            else g=0 ;
	         %end ;
	         %else %do ;
	            if min(set1_t,set0_t,set1_c,set0_c) ge 1 then
	            g=log((set1_t/&totalSet1_t)/(set0_t/&totalSet0_t))-
	              log((set1_c/&totalSet1_c)/(set0_c/&totalSet0_c)) ;
	            else g=0 ;
	         %end ;
	      run ;
	      data b&&var&i ;
	         set _missing_ b&&var&i ;
	         b0=0 ;
	         label g="Naive function" ;
	         label &&var&i="&&var&i" ;
			 %if %bquote(%upcase(&scaling))=RANKS %then %do ;
	            label r&&var&i="Rank(r&&var&i)" ;
			 %end ; 
	      run ;
	      %center(g) ;
	      data b&&var&i ;
	         set b&&var&i ;
	         label=g ;
			 %if %bquote(%upcase(&scaling))=RANKS %then %do ;
	            start=r&&var&i ;
	            end=r&&var&i ;
			 %end ; 
			 %else %do ; 
	            start=&&var&i ;
	            end=&&var&i ;
             %end ; 
	         label start="Start" ;
	         label g="Naive function" ;
	         label &&var&i="&&var&i" ;
	         label end="End" ;
	         fmtname=compress('var'||"&i"||"_") ;
	         type='n' ;
	      proc delete data=_unique_ _missing_;
	      run ;
	  %end ;

      proc format cntlin=b&&var&i ;
      run ; 

      data _gnbc_ ; 
	     set _gnbc_ ; 
		 %if "&&type&i"="c" %then %do ;
            g&i=put(&&var&i,$var&i._.)*1 ;
         %end ;
         %else %if &&smooth&i=0 or &&type&i=c %then %do ;
            g&i=put(&&var&i,var&i._.)*1 ;
         %end ;
	     %else %do ;
           %if %bquote(&scaling)=RANKS %then %do ;
	          g&i=put(r&&var&i,var&i._.)*1 ;
		   %end ; 
		   %else %do ; 
	          g&i=put(&&var&i,var&i._.)*1 ;
           %end ;
	     %end ; 
		 b&i=0 ;
      run ; 

   %mend ;
  

   ***********************************************************
   *  Macro to adjust g functions                            *
   ********************************************************* ;
   %macro adjust ;
   %if &&smooth&i=0 or &&type&i=c %then %do ;
      data _temp ;
         set _gnbc_ (keep=xb phat b&i &&var&i &y g&i) ;
         %if %bquote(&treatment)=NONE %then %do ;
            w=phat*(1-phat) ;
            z=w*b&i+(&y-phat) ;
         %end ;
         %else %do ;
            w=1 ;
            z=b&i+(g&i-xb) ;
         %end ;
      run ;
      proc summary data=_temp ;
         by &&var&i ;
         var z w ;
         output out=_adjustment_ sum= ;
	  run ; 

      data _adjustment_ ;
         set _adjustment_ ;
         if w>.01 then b&iter=z/w ;
         else do ;
            b&iter=0 ;
            * put "WARNING:  Local weight=0 when &&var&i = " &&var&i ;
            * put "Model fit may not be valid" ;
         end ;
      data b&&var&i ;
         merge b&&var&i _adjustment_ (keep=b&iter &&var&i);
         by &&var&i ;
         label b&iter="b&iter(x)" ;
      proc delete data=_adjustment_ ;
      run ;
   %end ;
   %else %do ;
      data _temp ;
         set _gnbc_ (keep=phat b&i &&var&i xb g&i
                     %if %upcase(%bquote(&scaling))=RANKS %then %do ; 
                        r&&var&i
                     %end ; &y) ;
         %if %bquote(&treatment)=NONE %then %do ;
            w=phat*(1-phat) ;
            z=w*b&i+(&y-phat) ;
         %end ;
         %else %do ;
            w=1 ;
            z=b&i+(g&i-xb) ;
         %end ;
      data _missing_ ;
         set _temp (where=(&&var&i=.)) ;
      data unique ;
         keep zvar wvar row n 
         %if %upcase(%bquote(&scaling))=RANKS %then %do ; 
            r&&var&i 
         %end ; &&var&i capN ;
         retain row 0 ;
         set _temp (where=(&&var&i>.)) ;
         capN+1 ;
         n+1 ;
         zvar+z ;
         wvar+w ;
         by &&var&i ;
         if last.&&var&i then do ;
            row=row+1 ;
            output ;
            n=0 ;
            zvar=0 ;
            wvar=0 ;
         end ;
      proc delete data=_temp ;
      data _null_ ;
         set unique nobs=nobs ;
         call symputx('unique',nobs) ;
      run ;
      data _adjustment_ ;
         keep nobs1-nobs&unique
              z1-z&unique
              w1-w&unique
              values1-values&unique
              capN ;
         set unique end=eof ;
            array nobs[&unique] ;
            array z[&unique] ;
            array w[&unique] ;
            array values[&unique] ;
            retain nobs1-nobs&unique
                   z1-z&unique
                   w1-w&unique
                   values1-values&unique ;
            cum+n ;
            nobs[_n_]=n ;
            %if %upcase(%bquote(&scaling))=NONE %then %do ;
               values[_n_]=&&var&i ;
            %end ;
            %else %if %upcase(%bquote(&scaling))=RANKS %then %do ;
               values[_n_]=r&&var&i ;
            %end ;
            z[_n_]=zvar ;
            w[_n_]=wvar ;
            if eof then output ;
      run ;
      data _adjustment_ ;
         keep b&iter row ;
         set _adjustment_ ;
         array nobs[&unique] ;
         array z[&unique] ;
         array w[&unique] ;
         array values[&unique] ;
         span=floor(&unique*&&smooth&i/2) ;
         size=floor(capN*&&smooth&i/2) ;
         do i=1 to &unique ;
            lower=1 ;
            upper=&unique ;
            neighbors1=nobs[i] ;
            neighbors2=0 ;
            if nobs[i]>floor(capN*&&smooth&i) then do ;
               end=i ;
               start=i ;
            end ;
            else do ;
               j=i-1 ;
               do while (j ge lower and neighbors1<size) ;
                  neighbors1=neighbors1+nobs[j] ;
                  j=j-1 ;
               end ;
               start=j+1 ;
               j=i+1 ;
               do while (j le upper and neighbors2<size) ;
                  neighbors2=neighbors2+nobs[j] ;
                  j=j+1 ;
               end ;
               end=j-1 ;
            end ;
            d=max(abs(values[end]-values[i]),abs(values[start]-values[i])) ;
            if d=0 then d=1 ;
            zsumL=0;
            zsumR=0 ;
            wsumL=0 ;
            wsumR=0 ;
            neighborsR=0 ;
            neighborsL=0 ;
            do j=i to start by -1 ;
               overflow=min(1,size/(neighborsL+nobs[j])) ;
               neighborsL=neighborsL+nobs[j] ;
               u=abs(values[j]-values[i])/d ;
               zsumL=zsumL+z[j]*(3/4)*(1-u**2)*overflow ;
               wsumL=wsumL+w[j]*(3/4)*(1-u**2)*overflow ;
            end ;
            do j=i+1 to end ;
               overflow=min(1,size/(neighborsR+nobs[j])) ;
               neighborsR=neighborsR+nobs[j] ;
               u=abs(values[j]-values[i])/d ;
               zsumR=zsumR+z[j]*(3/4)*(1-u**2)*overflow ;
               wsumR=wsumR+w[j]*(3/4)*(1-u**2)*overflow ;
            end ;
            zsum=zsumR+zsumL ;
            wsum=wsumR+wsumL ;
            if wsum>.01 then b&iter=zsum/wsum ;
            else do ;
               put "Local weight=0 for &&var&i at row " i ;
               put "Model fit may not be valid" ;
               b&iter=0 ;
            end ;
            row=i ;
            output _adjustment_ ;
         end ;
      data _adjustment_ ;
         keep b&iter &&var&i ;
         merge _adjustment_ unique(keep=row &&var&i) ;
         by row ;
      proc delete data=unique ;
      proc summary data=_missing_ ;
         var z w ;
         id &&var&i ;
         output out=_missing_ (keep=z w &&var&i) sum= ;
      data _missing_ ;
         keep b&iter &&var&i ;
         set _missing_ ;
         if w>0 then b&iter=z/w ;
         else do ;
            b&iter=0 ;
            * put "WARNING:  Local weight=0 when &&var&i is missing " ;
            * put "Model fit may not be valid" ;
            * put "You might have very few records where &&var&i is missing" ;
         end ;
      data _adjustment_ ;
         set _missing_ _adjustment_ (keep=b&iter &&var&i) ;
      proc delete data=_missing_ ;
      data b&&var&i ;
         merge b&&var&i _adjustment_(in=a) ;
         by &&var&i ;
         if not a then b&iter=0 ;
         label b&iter="b&iter(x)" ;
      proc delete data=_adjustment_ ;
      run ;
   %end ;
   %center(b) ;
   data b&&var&i ;
      set b&&var&i ;
      label=b&iter ;
   run ; 
   proc format cntlin=b&&var&i ;
   run ; 
   data _gnbc_ ;
      set _gnbc_ (drop=b&i) ;
      %if "&&type&i"="c" %then %do ;
         b&i=put(&&var&i,$var&i._.)*1 ;
      %end ;
      %else %if &&smooth&i=0 or &&type&i=c %then %do ;
         b&i=put(&&var&i,var&i._.)*1 ;
      %end ;
	  %else %do ; 
	     %if %upcase(%bquote(&scaling))=RANKS %then %do ; 
	        b&i=put(r&&var&i,var&i._.)*1 ;
		 %end ; 
		 %else %do ; 
	        b&i=put(&&var&i,var&i._.)*1 ;
		 %end ; 
	  %end ; 
      label b&i="b&i(x&i)" ;
   run ;

   %mend ;

   ***********************************************************
   *  Macro to score                                         *
   ********************************************************* ;
   %macro score ;
      data _gnbc_ ;
         set _gnbc_ ;
         xb=intercept ;
		 /*
         array g[&dim] g1-g&dim ;
         array b[&dim] b1-b&dim ;
         %do j=1 %to &dim ;
            %if &&selected&j=1 and &&skipped&j=0 %then %do ;
               xb=xb+g[&j]+b[&j] ;
            %end ;
         %end ;
         if xb< -100 then phat=0 ;
         else if xb>100 then phat=1 ;
         else phat=1/(1+exp(-xb)) ;
         %do j=1 %to &dim ;
            _&&var&j=g[&j]+b[&j] ;
         %end ;
		 */ 
         %do j=1 %to &dim ;
		    %if &&selected&j=1 %then %do ;
			   _&&var&j=sum(g&j,b&j) ;
               xb=xb+_&&var&j ;
		    %end ; 
         %end ;
         if xb< -100 then phat=0 ;
         else if xb>100 then phat=1 ;
         else phat=1/(1+exp(-xb)) ;
      run ;
 
   %mend ;

   ***********************************************************
   *  Intercept macro                                        *
   ********************************************************* ;
   %macro intercept ;
      %if &treatment=NONE %then %do ;
      proc nlin data=_gnbc_ outest=_adjustment_
         method=newton sigsq=1 noprint maxiter=200 ;
         parms adjustment 0 ;
         logl=&y*(adjustment+xb)-log(1+exp(adjustment+xb)) ;
         model.like = sqrt(-2*logl) ;
      data _adjustment_ (keep=adjustment) ;
         set _adjustment_ (where=(trim(_type_)="FINAL")) ;
      %let fail=1 ;
      data _null_ ;
         set _adjustment_ nobs=obs ;
         if obs>0 then call symput('fail',0) ;
      run ;
      %if &fail %then %do ;
         data _adjustment_ ;
            adjustment=0 ;
         run ;
         %put WARNING: Intercept could not be estimated after 200 iterations ;
         %put          Intercept will not be updated in this iteration ;
         %put          Model fit may not be valid ;
      %end ;
      data _gnbc_ ;
         if _n_=1 then set _adjustment_ ;
         set _gnbc_ ;
         intercept=intercept+adjustment ;
         drop adjustment ;
      proc delete data=_adjustment_ ;
      run ;
      %end ;
   %mend ;


   ***********************************************************
   *  Goodness of fit macro                                  *
   ********************************************************* ;
   %macro gof ;
       ods listing close ;
       ods output Association = cstat ;
       proc logistic data=_gnbc_ ;
          model &y=xb / noint nocheck maxiter=200 GCONV=0.01 ;
       run ;
       ods listing ;
       proc npar1way data=_gnbc_ edf noprint ;
          var xb ;
          class &y ;
          output out=ks (keep = _d_) edf  ;
	   run ; 
       data cstat ;
          set cstat (keep=cvalue2) end=eof ;
          rename cvalue2=cvalue ;
          label cvalue2="C-Statistic" ;
          if eof then output ;
       run ;
       proc sql noprint ;
          create table logl as select
          2*sum(abs(&y*xb-log(1+exp(xb)))) as logl,
          2*sum(abs(&y*intercept-log(1+exp(intercept)))) as intOnly,
          mean( (phat-&y)**2 / (phat*(1-phat)) ) as MSE
          from _gnbc_ ;
      data gof ;
          length pvalue $6 ;
          merge logl cstat ks ;
          deviance=intOnly-logl ;
          if deviance>0 then sig=1-probchi(deviance,1) ;
          format sig 6.4 ;
          if sig=. then pvalue=" " ;
          else if sig<.0001 then pvalue="<.0001" ;
          else pvalue=sig ;
          drop sig intOnly ;
          label pvalue="Pr > ChiSq"
                logl="-2LogL"
                deviance="Deviance"
                MSE="MSE"
                _d_="KS" ;
       proc delete data=logl cstat ;
       run ;
   %mend ;

   ***********************************************************
   *  Clean up the paramters                                 *
   ********************************************************* ;
   %if &maxiter=0 %then %let method=NBC ;
   %let method=%bquote(%upcase(&method)) ;
   %if &method=NBC %then %let maxiter=0 ;
   %if %bquote(&treatment) ne NONE and %bquote(&method)=GNBC %then %let method=SNBC ;  
   %put METHOD:  &method ;
   %put ;
   %if %upcase(%bquote(&scaling)) ne RANKS %then %let scaling=NONE ;
   %put DISTANCE SCALING FOR KERNELS:  %upcase(&scaling) ;
   %put ;
   %if %upcase(%bquote(&diagnostics))=Y %then %let diagnostics=YES ;
   %if %upcase(%bquote(&diagnostics))=N %then %let diagnostics=NO ;
   %if %bquote(&entry)= %then %do ; 
      %if %bquote(&treatment)=NONE %then %let entry=0.05 ;
	  %else %let entry=0.1 ; 
   %end ; 
   %put DIAGNOSTICS:  %upcase(&diagnostics) ;
   %put ;
   %if %bquote(%upcase(&selection)) ne Y and  
       %bquote(%upcase(&selection)) ne YES %then %let selection=NONE ; 
   %put VARIABLE SELECTION:  %upcase(&selection) ;
   %put ;
   %if %upcase(%bquote(&short))=Y %then %let short=YES ;
   %if %upcase(%bquote(&short))=N %then %let short=NO ;
   %put SHORT OUTPUT:  &short ;
   %put ;
   %put MAX ITERATIONS: &maxiter ;
   %put ;
   %if %upcase(%bquote(&prescreen))=Y %then %let prescreen=YES ; 


   ***********************************************************
   *  Check platform                                         *
   ********************************************************* ;
   %put PLATFORM:  &sysscp ;
   %put ;

   ***********************************************************
   *  Scan and disect the VAR statement                      *
   ********************************************************* ;
   %if %bquote(&var)=ALL %then %do ; 
       proc contents data=&data
                    out=_dim_(keep=name type
                    where=(upcase(name) ne upcase(compress("&y")) and
                           upcase(name) ne upcase(compress("&treatment")) 
						   %if %upcase(%bquote(&id)) ne %then %do ;  
                           and upcase(name) ne upcase("&id")
						   %end ;  
                           and name notin ('_FREQ_','_TYPE_')))
                    noprint ;
       data _null_ ;
       set _dim_ nobs=dim end=eof ;
         if eof then call symput('dim',trim(left(dim))) ;
       run ;
       %do i=1 %to &dim ;
         data _null_ ;
            set _dim_ ;
            name=upcase(name) ;
            if _n_=&i ;
            call symput("var&i",trim(left(name))) ;
			if type=1 then do ; 
               call symputx("type&i","n") ; 
               call symputx("smooth&i",&globalsmoothing/100) ; 
               call symputx("pregroup&i",&globalbinning) ; 
            end ; 
			else do ; 
               call symputx("type&i","c") ;
               call symputx("smooth&i",0) ;
               call symputx("pregroup&i",0) ; 
            end ; 
         run ;
       %end ;
       proc delete data=_dim_ ;
       run ;
   %end ;  
   %else %do ; 
	   %let numInputs=0 ;
	   %do i=1 %to 500 ;
	      %if %scan(&var,&i) ne %then %do ;
	         %let numInputs=%eval(&numInputs+1) ;
	         %let input&numInputs=%scan(&var,&i) ;
	      %end ;
	   %end ;
	   %let dim=1 ;
	   %do i=1 %to %eval(&numInputs-2) %by 3 ;
	      %let var&dim=&&input&i ;
	      %let dim=%eval(&dim+1) ;
	   %end ;
	   %let dim=1 ;
	   %do i=2 %to %eval(&numInputs-1) %by 3 ;
	      %let smooth&dim=&&input&i ;
	      data _null_ ;
	         smooth=&&smooth&dim/100 ;
	         call symput("smooth&dim",trim(left(smooth))) ;
	      run ;
	      %let dim=%eval(&dim+1) ;
	   %end ;
	   %let dim=1 ;
	   %do i=3 %to %eval(&numInputs) %by 3 ;
	      %let pregroup&dim=&&input&i ;
	      %let dim=%eval(&dim+1) ;
	   %end ;
	   %let dim=%eval(&dim-1) ;
   %end ;

   ***********************************************************
   *  Get the maximum variable-length                        *
   ********************************************************* ;
   data _null_ ;
      length=11 ;
      %do i=1 %to &dim ;
         l=length(compress("&&var&i")) ;
         if l>length then length=l ;
      %end ;
      call symput('maxlength',length) ;
   run ;

   ***********************************************************
   *  Check the input dataset                                *
   ********************************************************* ;
   %if %sysfunc(exist(&data))=0 %then %do ;
       %put ERROR: File &data does not exist ;
	   title1 ; 
	   title2 ; 
       data _null_ ;
          abort ;
       run ;
   %end ;
   %else %do ;
      proc contents data=&data noprint out=nobs(keep=nobs) ;
      data _null_ ;
         set nobs ;
         call symput('nobs',trim(left(nobs))) ;
      proc delete data=nobs ;
      run ;
      %put There were &nobs observations read from the input dataset %upcase(&data) ;
      %put ;
   %end ;
   %let dataid=%sysfunc(open(&data,i)) ;
   %do i=1 %to &dim ;
      %if %sysfunc(varnum(&dataid,&&var&i))=0 %then %do ;
         %put ERROR: Variable &&var&i does not exist ;
         %let rc=%sysfunc(close(&dataid)) ;
         %put ;
		 title1 ; 
		 title2 ; 
         data _null_ ;
            abort ;
         run ;
      %end ;
   %end ;
   %if %bquote(&id) ne %then %do ;
   %if %sysfunc(varnum(&dataid,&id))=0 %then %do ;
      %put ERROR: ID variable %upcase(&id) does not exist ;
      %put ;
      %let rc=%sysfunc(close(&dataid)) ;
		 title1 ; 
		 title2 ; 
      data _null_ ;
        abort ;
      run ;
   %end ;
   %end ;
   %if %sysfunc(varnum(&dataid,&y))=0 %then %do ;
      %put ERROR: ;
      %put Y variable does not exist ;
      %put ;
      %let rc=%sysfunc(close(&dataid)) ;
		 title1 ; 
		 title2 ; 
      data _null_ ;
         abort ;
      run ;
   %end ;
   %let rc=%sysfunc(close(&dataid)) ;
   %put ;

   ***********************************************************
   *  Check the dependent variable                           *
   ********************************************************* ;
   %if %bquote(&y)= %then %do ;
      title1 ; 
	  title2 ; 
      data _null_ ;
         put "ERROR: No Y-variables specified" ;
         abort ;
      run ;
   %end ; 

   proc sort data=&data(keep=&y) out=levels nodupkey ;
      by &y ;
   run ; 

   proc sql noprint ;
      select count(*) into :levels
      from levels ;
      select min(&y) into :miny
      from levels ;
      select max(&y) into :maxy
      from levels ;
   quit ;
   proc delete data=levels ;
   run ; 
   %if &levels<=1 or &levels>2 %then %do ;
         title1 ; 
		 title2 ; 
      data _null_ ;
         put "ERROR: Y-variable must have values 0 and 1 " ;
         abort ;
         put "  " ;
      run ;
   %end ;
   %put DEPENDENT VARIABLE: %upcase(&y) ;
   %put ;

   ***********************************************************
   *  Check the treatment variable                           *
   ********************************************************* ;
   %if %bquote(&treatment) ne NONE %then %do ;
	   proc sort data=&data(keep=&treatment) out=levels nodupkey ;
	      by &treatment ;
	   run ; 

	   proc sql noprint ;
	      select count(*) into :levels
	      from levels ;
	      select min(&treatment) into :mint
	      from levels ;
	      select max(&treatment) into :maxt
	      from levels ;
	   quit ;

	   proc delete data=levels ;
	   run ; 

	   %if &levels<=1 or &levels>2 %then %do ;
          title1 ; 
		  title2 ; 
	      data _null_ ;
	         put "ERROR: Treatment variable can only have values 0 and 1 " ;
	         abort ;
	         put "  " ;
	      run ;
	   %end ; 
	   %put TREATMENT VARIABLE: %upcase(&treatment) ;
	   %put ;
   %end ;

   ***********************************************************
   *  Get variable types                                     *
   ********************************************************* ;
   %do i=1 %to &dim ;
      proc contents data=&data out=vartypes noprint ;
      data _null_ ;
         set vartypes
         (where=(upcase(compress(name))=upcase(compress("&&var&i")))) ;
         if type=1 then call symputx("type&i",'n') ;
         else           call symputx("type&i",'c') ;
      proc delete data=vartypes ;
      run ;
   %end ;

   ***********************************************************
   *  Check consistency in VAR statement                     *
   ********************************************************* ;
   %do i=1 %to &dim ;
      data _null_ ;
         if "&&type&i"="c" and &&smooth&i>0 then do ;
            put "Note: Character variables can't be smoothed" ;
            put "Smoothing Parameter for &&var&i will be set to 0" ;
            call symput("smooth&i",0) ;
            put " " ;
         end ;
         if "&&type&i"="c" and &&pregroup&i>0 then do ;
            put "Character variables can not be pre-grouped" ;
            put "&&var&i will not be pre-grouped" ;
            put " " ;
            call symput("pregroup&i",'0') ;
         end ;
      run ;
   %end ;

   ***********************************************************
   *  Count levels of Y                                      *
   ********************************************************* ;
   %if %bquote(&treatment)=NONE %then %do ;
   proc sql noprint ;
      select sum(&y=1) into :totalSet1
      from &data ;
      select sum(&y=0) into :totalSet0
      from &data ;
   quit ;
   %end ;
   %else %do ;
   proc sql noprint ;
      select sum(&y*&treatment) into :totalSet1_t
      from &data ;
      select sum(&y*(&treatment=0)) into :totalSet1_c
      from &data ;
      select sum((&y=0)*&treatment) into :totalSet0_t
      from &data ;
      select sum((&y=0)*(&treatment=0)) into :totalSet0_c
      from &data ;
   quit ;
   %end ;

   ***********************************************************
   *  Set up the output library                              *
   ********************************************************* ;
   data _null_ ;
      savecode=(compress("&outest") ne '') ;
      call symputx("savecode",savecode) ;
	  saveoutput=(compress("&out") ne '') ;
      call symputx("saveoutput",saveoutput) ;
      if savecode then do ;
         t=compress("&outest",'\') ;
         tt="&outest" ;
         numberSlashes=length(tt)-length(t) ;
         fileName=scan(tt,numberSlashes+1,'\') ;
         folder=substr(tt,1,length(tt)-length(fileName)) ;
         call symput('folder',trim(left(folder))) ;
         call symput('fileName',trim(left(fileName))) ;
      end ;
   run ;

   %if &savecode=1 %then %do ;
	   data _null_ ;
	      if %sysfunc(libname(__g__,&folder)) notin (0,-70004) then do ;
	         put "ERROR: OUTEST folder does not exist" ;
	         put "Make sure to use backward slashes for PC, and forward slashes for UNIX/LINUX" ;
	         put "Do not to use quotes around the path" ;
	         abort ;
	      end ;
	      else do ;
	         put "Estimates and scoring code will be saved in the folder &folder" ;
	         put "Scoring code file name: &fileName " ;
	      end ;
	   run ;
	   libname __g__ clear ;
       %put ;
   %end ;
   %if &saveoutput=1 %then %do ;
	   data _null_ ;
	      if %sysfunc(libname(out,&out)) notin (0,-70004) then do ;
	         put "ERROR: OUT directory does not exist" ;
	         put "Make sure to use backward slashes for PC, and forward slashes for UNIX/LINUX" ;
	         put "Do not to use quotes around the path" ;
	         abort ;
	      end ;
	      else do ;
	         put "Output files will be saved in the folder &out" ;
	      end ;
	   run ;
	   %put ;
   %end ;


   ***********************************************************
   *  Create a base file                                     *
   ********************************************************* ;
   proc sql ;
      create table _gnbc_ as
      select 0 as like, *, 0 as intercept
      from &data (keep=%do i=1 %to &dim ;
                          &&var&i
                       %end ; &y &id
                       %if %bquote(&treatment) ne NONE %then %do ;
                          &treatment
                       %end ; ) ;
   quit ;

   data _gnbc_ ;
      set _gnbc_ ;
      format _all_ ;
      %do i=1 %to &dim ;
         %if "&&type&i"="c" %then %do ;
            &&var&i=compress(&&var&i,'/ -') ;
            if &&var&i='' then &&var&i='.' ;
         %end ;
      %end ;
	  %if %bquote(&treatment) ne NONE %then %do ; 
	     select ; 
		    when(&y and &treatment) _response_=4 ; 
		    when(&y=0 and &treatment=0) _response_=3 ; 
		    when(&y=0 and &treatment) _response_=2 ; 
		    otherwise _response_=1 ;
         end ;  
	  %end ; 
   run ;

   %do i=1 %to &dim ; 
      %let skipped&i=0 ; 
	  %let uniquevalues&i=1 ; 
	  %let percmiss&i=0 ; 
   %end ; 
   %if %bquote(&prescreen)=YES %then %do ; 
      %feasibility ;
   %end ; 
 
   %do i=1 %to &dim ;
      %if &&skipped&i=0 %then %do ; 
	      %if &&smooth&i ne 0 and %upcase(%bquote(&scaling))=RANKS %then %do ;
	         proc rank data=_gnbc_ out=_gnbc_ ;
	            var &&var&i ;
	            ranks r&&var&i ;
	         run ;
	      %end ;
	      %if &&pregroup&i ne 0 and &&type&i=n and &&smooth&i ne 0 %then %do ;
	         %pregroup ;
	      %end ;
	  %end ; 
   %end ;

   ***********************************************************
   *  Print VAR statement                                    *
   ********************************************************* ;
   data _var_statement ;
      retain variable type skipped preBins levels percMiss smoothingParameter ; 
      length variable $ &maxlength type $4 skipped $1 ;
      %do i=1 %to &dim ;
         variable=upcase(compress("&&var&i")) ;
         smoothingParameter=&&smooth&i ;
         preBins=&&pregroup&i ;
		 if "&&type&i"="c" then preBins=&&uniquevalues&i ;
		 if &&skipped&i=1 then skipped='Y' ; 
		 else skipped='N' ;
         if "&&type&i"="c" then type="Char" ;
         else type="Num" ;
		 levels=&&uniquevalues&i ; 
	     percMiss=&&percmiss&i ;  
		 format percMiss percent7.1 ;
         label variable="Variable"
               smoothingParameter="Smoothing parameter"
               preBins="Bins"
               type="Type"
               skipped="Skipped"
               percMiss='Missing' 
               levels="Levels" ;
         output ;
      %end ;
   run ; 

   proc print noobs label ;
      title2 "Variable information" ;
   run ; 

   proc delete data=_var_statement ;
   run ;

   ***********************************************************
   *  Estimate G(x) functions                                *
   ********************************************************* ;
   %do i=1 %to &dim ;
      %if &&skipped&i=0 %then %do ;
         %smooth ;
		 %put Naive function for &&var&i estimated ;
         %put ;  
         %let selected&i=1 ;
	  %end ; 
	  %else %do ; 
         %let selected&i=0 ;
		 data _gnbc_ ; 
		    set _gnbc_ ; 
			g&i=0 ; 
			b&i=0 ; 
		 run ; 
	  %end ; 	     
   %end ;
   %put ;
   %put All naive functions successfully estimated ;
   %put ;
   %put ; 

   %score ; 

   ***********************************************************
   *  Variable selection                                     *
   ********************************************************* ;
   %if %bquote(%upcase(&selection))=YES or %bquote(%upcase(&selection))=Y %then %do ;
      %if %bquote(&treatment)=NONE %then %do ; 
         %stagewisesel ;
      %end ; 
      %else %do ; 
         %stagewisesel ;
      %end ;  
   %end ;

   %score ;
   %intercept ;
   %score ;
   %let converged=0 ;
   %let maxReached=0 ;
   %let stopped=0 ;
   %let iter=1 ;
   %if %sysfunc(exist(_status_)) %then %do ;
      proc delete data=_status_ ;
      run ;
   %end ;
   %if %sysfunc(exist(fithist)) %then %do ;
      proc delete data=fithist ;
      run ;
   %end ;
   %if %bquote(&treatment)=NONE %then %do ;
   %gof ;
   data gof ;
      set gof ;
      iteration=0 ;
   proc append data=gof base=fithist ;
   run ;
   %end ;
   %if &method=SNBC %then %do ;
      %put Estimating slope coefficients for SNBC ... ;
      %preweight ;
      %let iter=2 ;
      %score ;
	  %if %bquote(&treatment)=NONE %then %do ; 
         %gof ;
	      data gof ;
	         set gof ;
	         iteration=1 ;
	      proc append data=gof base=fithist ;
	      run ;
	  %end ; 
      %put Done estimating slope coefficients for SNBC ;
   %end ;
   %else %if &maxiter>0 and &method=GNBC %then %do ;
   %put Estimating adjustment functions for GNBC ...  ;
   %put ;
      %preweight ;
      %put Iteration &iter completed ;
      %let iter=2 ;
      %score ;
	  %if %bquote(&treatment)=NONE %then %do ; 
	      %gof ;
	      data gof ;
	         set gof ;
	         iteration=1 ;
	      proc append data=gof base=fithist ;
	      run ;
	  %end ; 
   %do %while(&converged=0 and &maxReached=0 and &stopped=0) ;
      %do i=1 %to &dim ;
         %if &&selected&i=1 %then %do ;
            %let local_iter=1 ;
            %let local_convergence=0 ;
            data b&&var&i ;
               set b&&var&i ;
               local=b%eval(&iter-1) ;
            run ;
            proc sort data=_gnbc_ ;
               by &&var&i ;
            run ;
            %do %while(&local_convergence=0) ;
               %adjust ;
               %score ;
               data _t ;
                  set b&&var&i ;
                  sumdist=(b&iter-local)**2 ;
                  sumx=(local+g)**2 ;
               proc summary data=_t ;
                  weight n ;
                  var sumx sumdist ;
                  output out=t (keep=sumx sumdist) sum= ;
               data _t ;
                  set _t ;
                  sumdist=sqrt(sumdist) ;
                  sumx=sqrt(sumx) ;
                  delta=sumdist/sumx ;
               run ;
               proc sql noprint ;
                  select (delta<&epsilon or &local_iter ge &maxiter) into :local_convergence
                  from _t ;
               quit ;
               data b&&var&i ;
                  set b&&var&i ;
                  local=b&iter ;
               proc delete data=_t ;
               run ;
               %let local_iter=%eval(&local_iter+1) ;
            %end ;
            data _t ;
               set b&&var&i ;
               sumdist=(b&iter-b%eval(&iter-1))**2 ;
               sumx=(b%eval(&iter-1)+g)**2 ;
            proc summary data=_t ;
               weight n ;
               var sumx sumdist ;
               output out=_t (keep=sumx sumdist) sum= ;
            data _t ;
               keep iteration sumx sumdist delta variable ;
               length variable $&maxlength ;
               set _t ;
               variable=upcase("&&var&i") ;
               iteration=&iter ;
               sumdist=sqrt(sumdist) ;
               sumx=sqrt(sumx) ;
               delta=sumdist/sumx ;
               label delta="||D||" ;
            proc append data=_t base=_status_  ;
            proc delete data=_t ;
            run ;
         %end ;
      %end ;
      %intercept ;
      %score ;
      %if &treatment=NONE %then %do ;
	      %gof ;
	      data gof ;
	         set gof ;
	         iteration=&iter ;
	      proc append data=gof base=fithist ;
	      run ;
      %end ;
      proc sql noprint ;
         select (sum(sumdist)/sum(sumx)<&epsilon) into :converged
         from _status_ (where=(iteration=&iter)) ;
      quit ;
      data _null_ ;
         call symput('maxReached',(&iter ge &maxiter)) ;
      run ;
      %if &treatment=NONE %then %do ;
      data _null_ ;
         set fithist end=eof ;
         lagMSE=lag(MSE) ;
         lagLogL=lag(logl) ;
         if eof and _n_>1 then do ;
            if MSE>lagMSE and LogL>lagLogL and &converged=0 then do ;
               call symput('stopped',1) ;
            end ;
            else if abs(lagLogL-logL)/abs(lagLogL+.00001)<.001 then do ;
               call symput('converged',1) ;
            end ;
         end ;
      run ;
      %end ;
      %put Iteration &iter completed ;
      %let iter=%eval(&iter+1) ;
   %end ;
   %put ;
   %if &stopped %then %do ;
      %put GNBC stopped because SSE and -2LogL increased in the last iteration ;
   %end ;
   %else %if &maxReached %then %do ;
      %put GNBC could not converge in &maxiter iterations ;
   %end ;
   %else %do ;
      %put GNBC converged in %eval(&iter-1) iterations ;
   %end ;
   data _status_ ;
      keep iteration variable delta convergence ;
      set _status_ ;
      by iteration ;
      if first.iteration then do ;
         d=0 ;
         n=0 ;
      end ;
      d+sumdist ;
      n+sumx ;
      if last.iteration then convergence=d/n ;
      label convergence="Total ||D||" ;
   run ;
   %end ;
   %let iter=%eval(&iter-1) ;
   %if &treatment=NONE %then %do ;
	   proc print data=fithist label noobs ;
	      var iteration logl cvalue MSE _d_ ;
	      title2 "Iteration History" ;
	   run ;

	   proc delete data=gof fithist ks ;
	   run ;
   %end ;


   %if %bquote(&treatment) ne NONE %then %do ;

      proc rank data=_gnbc_ (keep=&treatment &y xb) out=_ranks groups=10 ;
         var xb ;
         ranks decile ;
      run ;

      data _ranks ;
         set _ranks ;
         if &treatment=1 then target_t=&y ;
         else target_c=&y ;
         if &treatment=0 then nontarget_t=(&y=0) ;
         else nontarget_c=(&y=0) ;
      run ;

      proc summary data=_ranks ;
         class decile ;
         var target_: nontarget_: ;
         output out=_liftcurve (drop=_freq_) mean= ;
      run ;

      data _null_ ;
         set _liftcurve (where=(_type_=0)) ;
         call symputx('over_all_lift',round(target_t-target_c,.00001)) ;
         intercept=log(target_t/nontarget_t)-log(target_c/nontarget_c) ;
         call symputx('intercept',intercept) ;
      run ;

      data _liftcurve ;
         set _liftcurve (where=(_type_>0)) ;
         net_lift = target_t-target_c ;
      run ;

      title2 "Incremental Lift Curve " ;
      proc print data=_liftcurve noobs ;
         var decile target_t target_c net_lift ;
      run ;

      proc delete data=_liftcurve _ranks ;
      run ;

   %end ;

   ***********************************************************
   *  Output scoring code                                    *
   ********************************************************* ;
   %if %bquote(&treatment)=NONE %then %do ;
   data _null_ ;
      set _gnbc_ ;
      if _n_=1 ;
      call symputx('intercept',intercept) ;
   run ;
   %end ;

   %do i=1 %to &dim ;
      %if &&selected&i=1 %then %do ;
         %if %upcase(&&pregroup&i) ne 0 and &&type&i ne c %then %do ;
         data b&&var&i ;
            merge b&&var&i
            _&&var&i ;
            by &&var&i ;
            g_plus_b=b&iter+g ;
            b=b&iter ;
	        label g="Naive function" ;
            label g_plus_b="Adjusted function" ;
         run ;
         %end ;
         %else %do ;
         data b&&var&i ;
            set b&&var&i end=eof ;
            start=&&var&i ;
            end=&&var&i ;
            %if "&&type&i"="c" %then %do ;
               start=compress(start,'/ -') ;
               end=compress(end,'/ -') ;
	           label g="Naive function" ;
               label g_plus_b="Adjusted function" ;
               if start="" then start="." ;
               if end="" then end="." ;
            %end ;
            g_plus_b=b&iter+g ;
            b=b&iter ;
         run ;
         %end ;
      %end ;
   %end ;


   %if &savecode %then %do ;
   %put ;
   data _null_ ;
      file "&outest" ;
      %if %bquote(&treatment)=NONE %then %do ;
         put " ************************************************** " ;
         put "  Sampling scheme: " ;
         put "     %trim(&totalSet1) records with %upcase(&y)=1 " ;
         put "     %trim(&totalSet0) records with %upcase(&y)=0 " ;
         put " ************************************************** ; " ;
         put ;
      %end ;
      %else %do ;
         put " ************************************************** " ;
         put "  Sampling scheme: " ;
         put "     Test Group: " ;
         put "        %trim(&totalSet1_t) records with %upcase(&y)=1 " ;
         put "        %trim(&totalSet0_t) records with %upcase(&y)=0 " ;
         put "     Control Group: " ;
         put "        %trim(&totalSet1_c) records with %upcase(&y)=1 " ;
         put "        %trim(&totalSet0_c) records with %upcase(&y)=0 " ;
         put " ************************************************** ; " ;
         put ;
      %end ;
      %do i=1 %to &dim ;
         %if &&selected&i=1 %then %do ;
            %if "&&type&i"="c" %then %do ;
               put "&&var&i=compress(&&var&i,'/ -') ;" ;
               put "if &&var&i='' then &&var&i='.' ;" ;
            %end ;
         %end ;
      %end ;
      put ;
   run ;
   %do i=1 %to &dim ;
      %if &&selected&i=1 %then %do ;
         %if &&smooth&i ne 0 or &&pregroup&i>0 %then %do ;
            data _null_ ;
               file "&outest" mod ;
               set b&&var&i end=eof ;
               if _n_=1 then put "select ;" ;
               if not eof then put @5 "when(&&var&i le " end ") b_&&var&i= " g_plus_b " ;" ;
               else do ;
                  put @5 "otherwise b_&&var&i=" g_plus_b " ;" ;
                  put "end ;" ;
               end ;
            run ;
         %end ;
         %else %if &&type&i=n and &&smooth&i=0 %then %do ;
            data _null_ ;
               file "&outest" mod ;
               set b&&var&i end=eof ;
               if _n_=1 then put "select ;" ;
               if not eof then put @5 "when(&&var&i = " end ") b_&&var&i= " g_plus_b " ;" ;
               else do ;
                  put @5 "otherwise b_&&var&i=" g_plus_b " ;" ;
                  put "end ;" ;
               end ;
            run ;
         %end ;
         %else %do ;
            data _null_ ;
               file "&outest" mod ;
               set b&&var&i end=eof ;
               start=trim(left(start)) ;
               if _n_=1 then put "select ;" ;
               if not eof then put @5 "when(&&var&i = '" start "') b_&&var&i= " g_plus_b " ;" ;
               else do ;
                  put @5 "otherwise b_&&var&i=" g_plus_b " ;" ;
                  put "end ;" ;
               end ;
            run ;
         %end ;
      %end ;
   %end ;
   data _null_ ;
      %if %bquote(&treatment)=NONE %then %do ;
      sampleRatio=&totalset1/(&totalset0+&totalSet1) ;
      %end ;
      file "&outest" mod ;
      %if %bquote(&treatment)=NONE %then %do ;
      put "sampleRatio = " sampleRatio " ;" ;
      put "xb_&y="
	  %end ; 
	  %else %do ; 
      put "net_&y="
      %end ; 
      %do i=1 %to %eval(&dim-1) ;
         %if &&selected&i=1 %then %do ;
         "b_&&var&i + "
         %end ;
      %end ;
      %if &&selected&dim=1 %then %do ;
         "b_&&var&dim + &intercept ; " ;
      %end ;
      %else %do ;
         "&intercept ; " ;
      %end ;
	  %if %bquote(&treatment)=NONE %then %do ; 
         put "p_&y = 1/(1+exp(-xb_&y)) ; " ;
	  %end ; 
   run ;
   %end ;

   ***********************************************************
   *  Print estimates                                        *
   ********************************************************* ;
   %if %upcase(%bquote(&short))=NO %then %do ;
      %do i=1 %to &dim ;
         %if &&selected&i=1 %then %do ;
            proc print data=b&&var&i noobs label ;
               var start end g g_plus_b ;
               title2 "Estimates for &&var&i " ;
            run ;
         %end ;
      %end ;
   %end ;

   ***********************************************************
   *  Save OUTEST tables and status table                    *
   ********************************************************* ;
   %if &saveoutput=1 %then %do ;
       data out._&data._ ;
          set _gnbc_ ;
          drop like ;
          %do i=1 %to &dim ;
            %if &&smooth&i ne 0 and %upcase(%bquote(&scaling))=RANKS 
                and &&selected&i=1 %then %do ;
               drop r&&var&i ;
            %end ;
            %if &&selected&i=1 %then %do ;
               drop b&i g&i ;
            %end ;
          %end ;
          rename phat=p_&y ;
          rename xb  =xb_&y ;
	   run ; 
       %if %bquote(&id) ne %then %do ;
          proc sort ;
            by &id ;
          run ;
       %end ;

	   %let maxlength=%eval(&maxlength+1) ;
	   %do i=1 %to &dim ;
	      %if &&selected&i=1 %then %do ;
	         proc sql ;
	            create table out._&&var&i as
	            select start, end, &&var&i, n, g, g_plus_b
	            from b&&var&i
	         quit ;
	      %end ;
	   %end ;
	   %if %sysfunc(exist(_status_)) %then %do ;
	      data out.convergence_status ;
	         set _status_ ;
	      proc delete data=_status_ ;
	      run ;
	   %end ;
	   libname out clear ;
   %end ;

   %if %sysfunc(exist(_status_)) %then %do ;
      proc delete data=_status_ ;
      run ;
   %end ;


   ***********************************************************
   *  Do diagnostics                                         *
   ********************************************************* ;
   %if %sysfunc(exist(multicorr)) %then %do ;
      proc delete data=multicorr ;
      run ;
   %end ;
   %let total_selected=0 ; 
   %do i=1 %to &dim ; 
      %let total_selected=%eval(&total_selected+&&selected&i) ; 
   %end ; 
   
   %if %upcase(%bquote(&diagnostics))=YES and &total_selected>1 %then %do ;
      data _variables ;
         length variable $&maxlength ;
         %do i=1 %to &dim ;
            %if &&selected&i=1 %then %do ;
            variable=compress(upcase("&&var&i")) ;
            row+1 ;
            output ;
            %end ;
         %end ;
      run ;
 	  ods listing close ;
	  ods output ParameterEstimates = _wald_ ;
	  proc logistic data=_gnbc_ 
         desc ;
	     model 
         %if %bquote(&treatment) ne NONE %then %do ; 
		    &treatment
	     %end ; 
         %else %do ; 
            &y 
         %end ;  
             = %do i=1 %to &dim ;
	              %if &&selected&i=1 %then %do ;
	                 _&&var&i
	              %end ;
	           %end ; intercept / noint nocheck ;
	    run ;
	    ods listing ;
	    data _wald_ ;
	       keep waldChisq row ;
	       set _wald_ (where=(compress(upcase(variable)) ne "INTERCEPT")) end=eof ;
	       retain max 0 ;
	       row+1 ;
	       if waldChisq>max then max=waldChisq ;
	       if eof then call symput('maxWald',max) ;
	    run ;
	    data _wald_ (keep=variable importance) ;
	       merge _variables _wald_ ;
	       by row ;
	       importance=round(100*waldChisq/&maxWald,1.0) ;
	       label importance="Importance" ;
	    proc sort data=_wald_ ;
	       by variable ;
	    run ;
	 
        data _wald_ ;
           set _wald_ end=eof ;
           retain max 0 ;
           if importance>max then max=importance ;
           if eof then call symput('maxWald',max) ;
        run ;
        data _wald_ (keep=variable importance) ;
           set _wald_ ;
           importance=round(100*importance/&maxWald,1.0) ;
           label importance="Importance" ;
        proc sort data=_wald_ ;
           by variable ;
        run ;

        %do i=1 %to &dim ;
            %if &&selected&i=1 and &&skipped&i=0 %then %do ;
	            proc reg data=_gnbc_ noprint outest=_rsq rsquare ;
	            model _&&var&i=%do k=1 %to &dim ;
	                           %if &k ne &i and &&selected&k=1 and &&skipped&i=0 %then %do ;
	                              _&&var&k
	                           %end ;
	                       %end ;;
	            data _rsq (keep=rsquare variable);
	               set _rsq (keep=_rsq_) ;
	               rsquare=_rsq_ ;
	               length variable $&maxlength ;
	               variable=compress(upcase("&&var&i")) ;
	            proc append base=multicorr data=_rsq ;
	            proc delete data=_rsq ;
	            run ;
            %end ;
         %end ;
         proc sort data=multicorr ;
            by variable ;
         run ;

         data _diagnostics ;
            merge _wald_ multicorr ;
            by variable ;
               label rsquare="R^2 with other variables"
                     variable="Adjusted function" ;
         proc sort ;
            by descending importance ;
         title2 "Diagnostics" ;
         proc print label noobs ;
            var variable importance rsquare ;
         proc delete data=multicorr _wald_ _diagnostics _variables ;
         run ;
   %end ;
   %else %do ; 
         data _wald_ ; 
		    %do i=1 %to &dim ;
			   %if &&selected&i=1 %then %do ; 
		          variable="&&var&i" ; 
				  importance=100 ; 
				  rsquare=0 ; 
                  label rsquare="R^2 with other variables"
                        variable="Adjusted function"
                        importance="Importance" ;
			   %end ; 
			%end ; 
		 run ; 
         proc print label noobs ;
            var variable importance rsquare ;
		 proc delete data=_wald_ ; 
		 run ; 
   %end ; 

   %do i=1 %to &dim ;
      %if %sysfunc(exist(_&&var&i)) %then %do ;
      proc delete data=_&&var&i ;
      %end ;
	  %if %sysfunc(exist(b&&var&i)) %then %do ; 
      proc delete data=b&&var&i ;
      %end ; 
   %end ;
   proc delete data=_gnbc_ ;
   run ;

   title1 ;
   title2 ;
   options obs=max notes mprint date  ;

%mend ;

