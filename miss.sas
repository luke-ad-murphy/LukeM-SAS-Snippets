%macro miss(data=,out=) ; 

   proc summary data=&data ; 
      var _numeric_ ; 
	  output out=_miss_ (drop=_freq_ _type_) nmiss= ; 
   run ; 

   proc transpose data=_miss_ out=_miss_ ; 
   run ; 

   proc sql noprint ; 
      select _name_ into :missvars separated by ' '
	  from _miss_ (where=(col1>0)) ; 

      select count(*) into :nmissvars
	  from _miss_ (where=(col1>0)) ; 
   quit ;

   data map ; 
      set _miss_ (where=(col1>0)) ; 
	  %do i=1 %to &nmissvars ; 
	     if _n_=&i then dummy="_MISS_&i" ; 
	  %end ;
      rename _name_=variable ;  
   run ; 

   proc print noobs ; 
      var dummy variable ; 
   run ; 

   data &out ; 
      set &data ; 
	  array __miss__[&nmissvars] &missvars ;
      array _miss_[&nmissvars] ;  
	  do i=1 to &nmissvars ; 
	     _miss_[i]=(__miss__[i]=.) ; 
	  end ; 
	  drop i ; 
   run ; 

   proc stdize data=&out out=&out method=mean reponly ; 
      var _numeric_ ; 
   run ; 

   proc delete data=map _miss_ ; 
   run ; 

%mend ; 
