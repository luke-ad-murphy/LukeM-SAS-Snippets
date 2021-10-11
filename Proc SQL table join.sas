proc sql;
create table add_ons4 as
select a.*, 
	b.account_desc,
	b.Portfolio_status,
	b.Price_plan_desc,
	b.package_desc,
	b.DEVICE_DESC_MODIFIED,
	b.special_application_ind,
	b.owner_status_home,
	b.marital_status,
	b.full_name,
	b.DOB,
	b.occupation_status,
	b.lifestage_segment,
	b.postcode,
	b.mosukgrp,
	b.mosuktype
from add_ons3 as a, new_tlu1.customers_main1 as b
where a.ccv_party_id = b.ccv_party_id;
quit;
