data lazy_base;
set lazy_base;
parea=compress(SUBSTR(post_code,1,3), " 1234567890");
run;