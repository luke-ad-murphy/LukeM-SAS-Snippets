data get_devs;

merge cnt (in = a keep=cnt houseflag lastname identity device_desc_modified

rename=(identity=orig device_desc_modified=orig_dev)

where = (cnt LE 14))

ss_1.tt_1317_house_emplid (in = b rename=(emplid=oth_emp) 

where=(houseflag NOT IN ("DN311RT42", "BN33WR59"))); 

by houseflag lastname;

if a and b;

channel=put(oth_emp,$dealfmt.);

if channel=' ' then channel='UNKNOWN';

retain cntr;

length dev1 dev2 dev3 dev4 dev5 dev6 dev7 dev8 dev9 dev10 dev11 dev12 dev13 dev14 

chan1 chan2 chan3 chan4 chan5 chan6 chan7 chan8 chan9 chan10 chan11 chan12 chan13 chan14 $25;

retain dev1-dev14 chan1-chan14;

array dev $dev1-dev14;

array chan $chan1-chan14;

if first.lastname then do;

cntr=1;

dev1=' ';

dev2=' ';

dev3=' ';

dev4=' ';

dev5=' ';

dev6=' ';

dev7=' ';

dev8=' ';

dev9=' ';

dev10=' ';

dev11=' ';

dev12=' ';

dev13=' ';

dev14=' ';

chan1=' ';

chan2=' ';

chan3=' ';

chan4=' ';

chan5=' ';

chan6=' ';

chan7=' ';

chan8=' ';

chan9=' ';

chan10=' ';

chan11=' ';

chan12=' ';

chan13=' ';

chan14=' ';

end;

else cntr=cntr+1;

dev[cntr]=oth_dev;

chan[cntr]=channel;

if last.lastname then output;

run;
