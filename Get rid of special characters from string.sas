ship_name2=compress(ship_name,,"kw");
 
/*For my field, compress alone would not work, but using the above, did remove whatever invisible funny symbol was causing the problem.*/
/*The "kw" stands for "keep writeable" as in keep character values that are expected. So this also keeps the spaces between the words.*/
