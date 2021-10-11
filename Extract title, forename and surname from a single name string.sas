
/* Further formating for business addresses */
rsubmit;
data Ss_1.Rlh_1e_addresses (drop = Fullname Fullname2 Fullname3 Fullname4 Fullname5
Fullname6 Fullname7 space_name space_title);
set Ss_1.Rlh_1e_addresses;
Fullname = LEFT(TRIM(tranwrd(main_contact, 'Mrs', '')));
Fullname2 = LEFT(TRIM(tranwrd(Fullname, 'Miss', '')));
Fullname3 = LEFT(TRIM(tranwrd(Fullname2, 'Mr', '')));
Fullname4 = LEFT(TRIM(tranwrd(Fullname3, 'Ms', '')));
Fullname5 = LEFT(TRIM(tranwrd(Fullname4, 'Prof', '')));
Fullname6 = LEFT(TRIM(tranwrd(Fullname5, '(No Longer A Contact)', '')));
Fullname7 = LEFT(TRIM(tranwrd(Fullname6, 'Dr', '')));

space_name = index(Fullname7,' ');

First_name = substr(Fullname7, 1, space_name);
Surname = LEFT(TRIM(substr(Fullname7, space_name, 100)));

space_title = index(main_contact,' ');
Salutation = substr(main_contact, 1, space_title-1);
if Salutation IN ('Mrs', 'Miss', 'Mr', 'Ms', 'Prof', 'Dr')
then Salutation = Salutation;
else Salutation = '';

run;
endrsubmit;
