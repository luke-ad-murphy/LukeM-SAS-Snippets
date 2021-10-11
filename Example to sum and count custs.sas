proc means data = use_201101 noprint; 
  class price_plan_desc; 
  var sms mins; 
  output out = use_201101_tot (drop = _type_ rename = (_freq_ = customers))
  sum = tot_sms tot_mins n= sms_users voi_users; 
run; 
