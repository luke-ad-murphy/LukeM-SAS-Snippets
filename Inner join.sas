proc sql;
connect to oracle (user=query_adc password=xgl29v path=BIL1P01
preserve_comments);
create table base as select * from connection to oracle
(
select x.account_name, b.*
   from account x inner join
   (select pih.PRODUCT_INSTANCE_ID,
            pih.customer_node_id ,
            pih.product_id, 
            pih.product_instance_status_code,
            pih.effective_start_date as strt_date,
            pih.effective_end_date as end_date
        FROM product_instance_history pih
        WHERE pih.product_id in ('32000046', '32000255')   
		AND pih.product_instance_status_code = 3
    ) b
on x.customer_node_id = b.customer_node_id
);
quit;
