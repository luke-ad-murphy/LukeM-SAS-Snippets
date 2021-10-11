data work.fixed_charges_addon / view=work.fixed_charges_addon;
  set work.fixed_charges_discounted; 
  where type3 in("Subscripti", "Other");
run; 
