*Take everything up to the first space within the add1 field;
data temp (keep=csn add1 mail_srt mail_contact title);
set rmp.mail_csn;
title = scan(add1,1,' ');
run;
