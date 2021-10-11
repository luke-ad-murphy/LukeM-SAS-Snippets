/*SPSS files*/
/**/
/*Reading a SPSS file into SAS using proc import is quite easy and works much like reading an Excel file. SAS recognizes the file extension for SPSS (*.sav) and automatically knows how to read it. Let's say that we have the following data stored in a SPSS file hsb.sav.*/
/**/
/*       id   Female   Read   Write    Math*/
/*      1.00	1.00	34.00	44.00	40.00*/
/*      2.00	1.00	39.00	41.00	33.00*/
/*      3.00	.00	63.00	65.00	48.00*/
/*      4.00	1.00	44.00	50.00	41.00*/
/*      5.00	.00	47.00	40.00	43.00*/
/*      6.00	1.00	47.00	41.00	46.00*/
/*      7.00	.00	57.00	54.00	59.00*/
/*      8.00	1.00	39.00	44.00	52.00*/
/*      9.00	.00	48.00	49.00	52.00*/
/*      10.00	1.00	47.00	54.00	49.00*/
/**/
/*Then the following proc import statement will read it in and create a temporary data set called mydata. The proc print command lets us see that we have imported the data correctly. From the proc contents output below we can see that SAS takes both variable labels and value labels from the SPSS file.*/

    proc import datafile="d:\hsb.sav" out=mydata dbms = sav replace;
    run;
    proc print data=mydata;
    run;

/*    Obs           ID    FEMALE         READ        WRITE         MATH*/
/**/
/*      1         1.00    female        34.00        44.00        40.00*/
/*      2         2.00    female        39.00        41.00        33.00*/
/*      3         3.00    male          63.00        65.00        48.00*/
/*      4         4.00    female        44.00        50.00        41.00*/
/*      5         5.00    male          47.00        40.00        43.00*/
/*      6         6.00    female        47.00        41.00        46.00*/
/*      7         7.00    male          57.00        54.00        59.00*/
/*      8         8.00    female        39.00        44.00        52.00*/
/*      9         9.00    male          48.00        49.00        52.00*/
/*     10        10.00    female        47.00        54.00        49.00*/


    proc contents data=mydata;
    run;

/*      #    Variable    Type    Len    Format     Label*/
/**/
/*      2    FEMALE      Num       8    FEMALE.    FEMALE*/
/*      1    ID          Num       8    F9.2       ID*/
/*      5    MATH        Num       8    F9.2       math score*/
/*      3    READ        Num       8    F9.2       reading score*/
/*      4    WRITE       Num       8    F9.2       writing score*/
