proc format;
value voice
. = "A No voice use"
low-0 = "A No voice use"
0.00001-25 = "B Up to 25 mins"
25.00001-50 = "C 25 to 50 mins"
50.00001-75 = "D 50 to 75 mins"
75.00001-100 = "E 75 to 100 mins"
100.00001-150 = "F 100 to 150 mins"
150.00001-200 = "G 150 to 200 mins"
200.00001-250 = "H 200 to 250 mins"
250.00001-300 = "I 250 to 300 mins"
300.00001-350 = "J 300 to 350 mins"
350.00001-400 = "K 350 to 400 mins"
400.00001-450 = "L 400 to 450 mins"
450.00001-500 = "M 450 to 500 mins"
500.00001-600 = "N 500 to 600 mins"
600.00001-700 = "O 600 to 700 mins"
700.00001-800 = "P 700 to 800 mins"
800.00001-900 = "Q 800 to 900 mins"
900.00001-1000 = "R 900 to 1000 mins"
1000.00001-1500 = "S 1000 to 1500 mins"
1500.00001-2000 = "T 1500 to 2000 mins"
2000.00001-high = "U 2000 mins and above"
other = "Z Other";
run;



* SMS min bands;
proc format;
value sms 
. = "A No SMS use"
low-0 = "A No SMS use"
0.01-10 = "B Up to 10 SMS"
10.01-20 = "C 11 to 20 SMS"
20.01-30 = "D 21 to 30 SMS"
30.01-40 = "E 31 to 40 SMS"
40.01-50 = "F 41 to 50 SMS"
50.01-75 = "G 51 to 75 SMS"
75.01-100 = "H 76 to 100 SMS"
100.01-150 = "I 101 to 150 SMS"
150.01-200 = "J 151 to 200 SMS"
200.01-250 = "K 201 to 250 SMS"
250.01-300 = "L 251 to 300 SMS"
300.01-350 = "M 301 to 350 SMS"
350.01-400 = "N 351 to 400 SMS"
400.01-450 = "O 401 to 450 SMS"
450.01-500 = "P 451 to 500 SMS"
500.01-750 = "Q 501 to 750 SMS"
750.01-1000 = "R 751 to 1000 SMS"
1000.01-1500 = "S 1001 to 1500 SMS"
1500.01-2000 = "T 1501 to 2000 SMS"
2000.01-high = "U 2001 SMS and above"
other = "Z Other";
run;



* data bands;
proc format;
value dat 
. = "A No data use"
low-0 = "A No data use"
0.00001-0.25 = "B Up to 0.25MB"
0.2500001-0.5= "C 0.25MB to 0.5MB"
0.500001-1 = "D 0.5MB to 1MB"
1.00001-5 = "E 1MB to 5MB"
5.00001-10 = "F 5MB to 10MB"
10.00001-20 = "G 10MB to 20MB"
20.00001-30 = "H 20MB to 30MB"
30.00001-50 = "I 30MB to 50MB"
50.00001-100 = "J 50MB to 100MB"
100.00001-150 = "K 100MB to 150MB"
150.00001-200 = "L 150MB to 200MB"
200.00001-250 = "M 200MB to 250MB"
250.00001-300 = "N 250MB to 300MB"
300.00001-350 = "O 300MB to 350MB"
350.00001-400 = "P 350MB to 400MB"
400.00001-512 = "Q 400MB to 0.5GB"
512.00001-1024 = "R 0.5GB to 1GB"
1024.00001-1536 = "S 1GB to 1.5GB"
1536.00001-2048 = "T 1.5GB to 2GB"
2048.00001-high = "U 2GB and above"
other = "Z Other";
run;


* reciprocation;
proc format;
value recip
low--500.00001 = "A -500 units and below"
-500--400.00001 = "B -500 to -400 units"
-400--350.00001 = "C -400 to -350 units"
-350--300.00001 = "D -350 to -300 units"
-300--250.00001 = "E -300 to -250 units"
-250--200.00001 = "F -250 to -200 units"
-200--150.00001 = "G -200 to -150 units"
-150--100.00001 = "H -150 to -100 units"
-100--50.00001 = "I -100 to -50 units"
-50--0 = "J -50 to 0 units"
0-25 = "K 0 to 25 units"
25.00001-50 = "L 25 to 50 units"
50.00001-75 = "M 50 to 75 units"
75.00001-100 = "N 75 to 100 units"
100.00001-150 = "O 100 to 150 units"
150.00001-200 = "P 150 to 200 units"
200.00001-250 = "Q 200 to 250 units"
250.00001-300 = "R 250 to 300 units"
300.00001-350 = "S 300 to 350 units"
350.00001-500 = "T 350 to 500 units"
500.00001-high = "U 500 units and above"
other = "Z Other";
run;