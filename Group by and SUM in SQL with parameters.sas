proc sql;
create table test as

select account_id as account_desc, 
	   sum(duration) as duration,
	   sum(volume) as volume,
	   sum(num_events) as events

from adm.fact_vdm_rated_events

WHERE event_type_id IN (19354026)
AND batch_load_id = 215726

group by account_desc;

quit;
