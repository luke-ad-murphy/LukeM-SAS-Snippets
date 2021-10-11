data overlap;
set Kf_1.Prod_holdings; 
where Prods GE 2;
array dot(19) Add_E_mail -- X___Series_Silver; 
 do i= 1 to 19; 
   if dot(i) = . then dot(i) = 0;
end;
run;
