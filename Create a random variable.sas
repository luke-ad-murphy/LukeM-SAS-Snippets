data temp_comps (keep = compid mktsect mktsub nov_compseg jan_compseg mag2 control);
set temp_comps;
rand = ranuni(100);
control = 'N';
if rand <0.1 then control = 'Y'; else control = 'N';
run;