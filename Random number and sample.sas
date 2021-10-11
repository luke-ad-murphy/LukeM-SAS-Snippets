rsubmit;
data x (drop = random);
set y;
random = ranuni(0);
if 0.07 < random < 0.075;
run;
endrsubmit;
