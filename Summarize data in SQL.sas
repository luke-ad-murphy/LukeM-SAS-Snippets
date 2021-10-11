proc sql;
	create table churn_summary as
	select cohort, conlen, churn_month, channel, churn_type, count(*) as volume 
		from analysis
			group by cohort, conlen, churn_month, channel, churn_type;
quit;
