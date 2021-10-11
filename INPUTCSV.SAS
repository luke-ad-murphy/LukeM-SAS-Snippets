
DATA X;
  INFILE 'G:\USER\SURFOOD.CSV' DELIMITER=',' FIRSTOBS=3 ;

INPUT
           COMMUNE
           STORE_NO
           FOOD  ;
RUN;
PROC FSEDIT;
RUN;
