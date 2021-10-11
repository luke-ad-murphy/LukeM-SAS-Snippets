PROC SQL;
 CREATE TABLE asis5.LM_1099_NON_CONTACTS AS 
	SELECT 
a.account_desc,
a.MSISDN,
b.CCV_PARTY_ID,
b.title,
c.address_line_1,
c.address_line_2,
c.address_line_3,
c.address_line_4,
c.address_line_5,
c.address_line_6,
c.address_line_7,
c.address_line_8,
c.address_line_9,
c.address_line_10,
c.postcode,
c.place_name,
c.CURRENT_RECORD_FLAG 
 FROM ASIS5.LM_1099_NON_CONTACTS AS a 
	  LEFT JOIN 
	  ASIS9.CUSTOMER_MAIN_EM AS b ON (a.account_desc = b.account_desc) 
	  LEFT JOIN
	  ASIS9.ADDRESS_MAIN AS c ON (a.account_desc = c.account_desc);
QUIT;

