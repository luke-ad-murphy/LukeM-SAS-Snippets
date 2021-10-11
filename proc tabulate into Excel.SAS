
proc tabulate data=newls noseps formchar='09'x missing;
        class retseg;
        var retain;
        table retseg all,n retain / rts=50;
        title 'Retail Clusters';
run;

