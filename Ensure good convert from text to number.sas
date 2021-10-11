I was importing CSV file in SAS which had numeric field 'ttl_vol_mb', but when importing it converting in to character field with some funny characters.

I was using t_vol = input(compress(tt_Vol_mb,' '),'"'),best12.) but I was not able to pick all values, then I searched compress function with modifier and used it following way.
t_vol = input(compress(compress(tt_Vol_mb,' '),'"','s'),best12.);
 
Third option "modifiers" compressing any space characters (blank, horizontal tab, vertical tab, carriage return, line feed, and form feed) to the list of characters.
