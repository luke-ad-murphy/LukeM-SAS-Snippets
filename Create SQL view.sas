proc sql;
create view work.fixed_charges_sum as
  SELECT account_name, type3, 
  SUM(total_charge) as charge
  FROM work.fixed_charges_discounted
  GROUP BY account_name, type3;
quit;
