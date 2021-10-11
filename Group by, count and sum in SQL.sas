rsubmit;
	proc sql;
		create table ce_prepay as
			select 
				yr, mth, device_Desc_modified, connection_type,
				count(*) as base, sum(margin) as margin
			from ss_1.ce_prepay_handsets1
			group by
				yr, mth, device_Desc_modified, connection_type;
	quit;
endrsubmit;
