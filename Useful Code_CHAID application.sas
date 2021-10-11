/************************************************************/
/*															*/
/*				Code for SD Account Custs Prospects			*/
/*						CHAID Code 31/10/05					*/
/*															*/								
/*															*/
/*															*/
/************************************************************/

libname sep05 'Q:\car_data\roy_mail\RMD\Monthly Download\sep05m\Sas Data';
libname fwork 'Q:\car_data\roy_mail\2005 Financial Year\UK Mails\Deliver Your Promises\Special Delivery\SD Framework\SAS Data';
libname Metuse 'Q:\car_data\roy_mail\2005 Financial Year\UK Mails\Deliver Your Promises\Special Delivery\Q2 Special Delivery - Desk Media (Sep 05)\sas data';
libname view slibref=work server=server;

libname sep05 'N:data\car_data\roy_mail\RMD\Monthly Download\sep05m\Sas Data';
libname fwork 'N:data\car_data\roy_mail\2005 Financial Year\UK Mails\Deliver Your Promises\Special Delivery\SD Framework\SAS Data';
libname Metuse 'N:\data\car_data\roy_mail\2005 Financial Year\UK Mails\Deliver Your Promises\Special Delivery\Q2 Special Delivery - Desk Media (Sep 05)\sas data';

/*Create a file of all sites, excluding J and U for the code to be applied to*/

data fwork.file_sep;
	set sep05.site;
	keep bc mktsect empband ahstat new_compseg named_contacts totalrmrevl12 site_status ho_ind 
comp_mem mktgdept mroom coll istl izandf pobox probcoll pstream rmdirect busmailrevl12 
mslerevl12 mslprevl12 cleanmrevl12 meterrevl12 ppirevl12 ppostrevl12 respservrevl12 stlrevl12;
	if new_compseg in ('J+' 'J-' 'U+' 'U-' 'Uc') then delete;
run;

/* Then need to add info on SD rev in order to flag current SD users*/

data sdrevdata (keep=bc rev1 rev2 rev3 rev4 rev5 rev6 rev7 rev8 rev9 rev10 rev11 rev12);
	set sep05.rev_sd_total;
	run;

data sdrevdata;
	set sdrevdata;
	total_sdrev_12 = sum(rev1,rev2, rev3, rev4, rev5, rev6, rev7, rev8, rev9, rev10, rev11,
	rev12);
	run;

data sdrevdata;
	set sdrevdata;
	where total_sdrev_12 >0;
	run;


/*Merge on this info along with the meter use file to give details on all SD users*/


/*need to update bcs using bc minor file on the meter file*/
data bc_minors;
	set sep05.bc_minors (rename=(old_bc=bc));
	run;

proc sort data = bc_minors; by bc; run;

data meter_custs damn;
	merge metuse.meter_custs (in=a)
			bc_minors (in=b);
		by bc;
		if a and b then output meter_custs;
		if a and not b then output damn;
		run;

data meter_custs;
	set meter_custs (drop=bc);
	run;


data meter_custs;
	set meter_custs (rename=(new_bc = bc));
	run;


proc sort data=sdrevdata; by bc; run;
proc sort data=meter_custs; by bc; run;
proc sort data=fwork.file_sep; by bc; run;

data fwork.file_sep check checkb;
 merge	fwork.file_sep (in=a)
      	sdrevdata (in=b keep= bc total_sdrev_12)
		meter_custs (in=c);
      	by bc;
 if a and b then sdacc = 1;
 else sdacc = 0;
 if a and c then sdmeter = 1;
 else sdmeter = 0;
 if a then output fwork.file_sep;
 if b and not a then output check;
 if c and not a then output checkb;

run;

/* Any file in check or check b are J and U files*/

/* Ensure the data is in the same format as the CHAID file - this requires flags for
product use based on pos rev to be added to the fwork.file file*/

data fwork.file_sep;
	set fwork.file_sep;

	if busmailrevl12 <= 0 then busmail_flag = 0;
	else if busmailrevl12 > 0 then busmail_flag = 1;

    if mslerevl12 <= 0 then msle_flag = 0;
	else if mslerevl12 > 0 then msle_flag = 1;

	if mslprevl12 <= 0 then mslp_flag = 0;
	else if mslprevl12 > 0 then mslp_flag = 1;

	if cleanmrevl12 <= 0 then cleanm_flag = 0;
	else if cleanmrevl12 > 0 then cleanm_flag = 1;

	if meterrevl12 <= 0 then meter_flag = 0;
	else if meterrevl12 > 0 then meter_flag = 1;

	if ppirevl12 <= 0 then ppi_flag = 0;
	else if ppirevl12 > 0 then ppi_flag = 1;

	if ppostrevl12 <= 0 then ppost_flag = 0;
	else if ppostrevl12 > 0 then ppost_flag = 1;

	if respservrevl12 <= 0 then respserv_flag = 0;
	else if respservrevl12 > 0 then respserv_flag = 1;

	if stlrevl12 <= 0 then stl_flag = 0;
	else if stlrevl12 > 0 then stl_flag = 1;
run;

/* The next two steps add the propensity scores for likelihood to be an account cust and meter
cust using rules from CHAID*/

/*Code has been amended to make it more generic*/

data fwork.sd_prospects;
/*length NODEID $120;*/
set fwork.file_sep;

IF totalrmrevl12 < 1400.000000 THEN
DO;
	/* NODEID = 'x.14/0'; */
		sdacc_prosp_0 = 0.991214;
		sdacc_prosp_1 = 0.008786;
END;
ELSE IF totalrmrevl12 >= 1400.000000 AND totalrmrevl12 < 2810.000000 THEN
DO;
	/* NODEID = 'x.14/1'; */
	IF meterrevl12 < 1175.000000 THEN
	DO;
		/* NODEID = 'x.14/1.18/0'; */
		IF named_contacts = 0.000000  THEN
		DO;
			/* NODEID = 'x.14/1.18/0.2/0'; */
			sdacc_prosp_0 = 0.679245;
			sdacc_prosp_1 = 0.320755;
		END;
		ELSE IF named_contacts >= 1.000000 THEN
		DO;
			/* NODEID = 'x.14/1.18/0.2/1'; */
			sdacc_prosp_0 = 0.274336;
			sdacc_prosp_1 = 0.725664;
		END;
	END;
	ELSE IF meterrevl12 >= 1175.000000  THEN
	DO;
		/* NODEID = 'x.14/1.18/1'; */
		sdacc_prosp_0 = 0.996094;
		sdacc_prosp_1 = 0.003906;
	END;
END;
ELSE IF totalrmrevl12 >= 2810.000000 AND totalrmrevl12 < 4795.000000 THEN
DO;
	/* NODEID = 'x.14/2'; */
	IF meterrevl12 < 2100.000000 THEN
	DO;
		/* NODEID = 'x.14/2.18/0'; */
		IF ppi_flag = 0.000000 THEN
		DO;
			/* NODEID = 'x.14/2.18/0.37/0'; */
			sdacc_prosp_0 = 0.396450;
			sdacc_prosp_1 = 0.603550;
		END;
		ELSE IF ppi_flag = 1.000000 THEN
		DO;
			/* NODEID = 'x.14/2.18/0.37/1'; */
			sdacc_prosp_0 = 0.045455;
			sdacc_prosp_1 = 0.954545;
		END;
	END;
	ELSE IF meterrevl12 >= 2100.000000 THEN
	DO;
		/* NODEID = 'x.14/2.18/1'; */
		sdacc_prosp_0 = 0.968085;
		sdacc_prosp_1 = 0.031915;
	END;
END;
ELSE IF totalrmrevl12 >= 4795.000000 AND totalrmrevl12 < 7969.000000 THEN
DO;
	/* NODEID = 'x.14/3'; */
	IF meterrevl12 < 3500.000000 THEN
	DO;
		/* NODEID = 'x.14/3.18/0'; */
		IF ppi_flag = 0.000000 THEN
		DO;
			/* NODEID = 'x.14/3.18/0.37/0'; */
			sdacc_prosp_0 = 0.336066;
			sdacc_prosp_1 = 0.663934;
		END;
		ELSE IF ppi_flag = 1.000000 THEN
		DO;
			/* NODEID = 'x.14/3.18/0.37/1'; */
			sdacc_prosp_0 = 0.039157;
			sdacc_prosp_1 = 0.960843;
		END;
	END;
	ELSE IF meterrevl12 >= 3500.000000 THEN
	DO;
		/* NODEID = 'x.14/3.18/1'; */
		sdacc_prosp_0 = 0.943089;
		sdacc_prosp_1 = 0.056911;
	END;
END;
ELSE IF totalrmrevl12 >= 7969.000000 AND totalrmrevl12 < 12951.000000 THEN
DO;
	/* NODEID = 'x.14/4'; */
	IF ppi_flag = 0.000000 THEN
	DO;
		/* NODEID = 'x.14/4.37/0'; */
		sdacc_prosp_0 = 0.606452;
		sdacc_prosp_1 = 0.393548;
	END;
	ELSE IF ppi_flag = 1.000000 THEN
	DO;
		/* NODEID = 'x.14/4.37/1'; */
		IF mktsect = ' '
		OR mktsect = 'D'
		OR mktsect = 'E'
		OR mktsect = 'H'
		OR mktsect = 'M'
		OR mktsect = 'R'
		OR mktsect = 'U'
		OR mktsect = 'Z' THEN
		DO;
			/* NODEID = 'x.14/4.37/1.1/0'; */
			sdacc_prosp_0 = 0.016129;
			sdacc_prosp_1 = 0.983871;
		END;
		ELSE IF mktsect = 'C'
		     OR mktsect = 'F'
		     OR mktsect = 'G'
		     OR mktsect = 'P'
		     OR mktsect = 'W' THEN
		DO;
			/* NODEID = 'x.14/4.37/1.1/1'; */
			sdacc_prosp_0 = 0.132743;
			sdacc_prosp_1 = 0.867257;
		END;
	END;
END;
ELSE IF totalrmrevl12 >= 12951.000000 AND totalrmrevl12 < 20208.000000 THEN
DO;
	/* NODEID = 'x.14/5'; */
	IF ppi_flag = 0.000000 THEN
	DO;
		/* NODEID = 'x.14/5.37/0'; */
		sdacc_prosp_0 = 0.482759;
		sdacc_prosp_1 = 0.517241;
	END;
	ELSE IF ppi_flag = 1.000000 THEN
	DO;
		/* NODEID = 'x.14/5.37/1'; */
		sdacc_prosp_0 = 0.017354;
		sdacc_prosp_1 = 0.982646;
	END;
END;
ELSE IF totalrmrevl12 >= 20208.000000 AND totalrmrevl12 < 70490.000000 THEN
DO;
	/* NODEID = 'x.14/6'; */
	IF ppirevl12 =< 0.000000 THEN
	DO;
		/* NODEID = 'x.14/6.22/0'; */
		sdacc_prosp_0 = 0.326923;
		sdacc_prosp_1 = 0.673077;
	END;
	ELSE IF ppirevl12 > 0.000000 AND ppirevl12 < 13826.000000 THEN
	DO;
		/* NODEID = 'x.14/6.22/1'; */
		IF meter_flag = 0.000000 THEN
		DO;
			/* NODEID = 'x.14/6.22/1.36/0'; */
			sdacc_prosp_0 = 0.009132;
			sdacc_prosp_1 = 0.990868;
		END;
		ELSE IF meter_flag = 1.000000 THEN
		DO;
			/* NODEID = 'x.14/6.22/1.36/1'; */
			sdacc_prosp_0 = 0.128713;
			sdacc_prosp_1 = 0.871287;
		END;
	END;
	ELSE IF ppirevl12 >= 13826.000000 THEN
	DO;
		/* NODEID = 'x.14/6.'; */
		sdacc_prosp_0 = 0.016200;
		sdacc_prosp_1 = 0.983800;
	END;
END;
ELSE IF totalrmrevl12 >= 70490.000000 THEN
DO;
	/* NODEID = 'x.14/7'; */
	
			sdacc_prosp_0 = 0.026900;
			sdacc_prosp_1 = 0.973100;
		END;
	/*The following code is optional.  It can be used to treat missing and unknown cases as missing.  By default, the missing and unknown cases are scored as the average.*/
ELSE 
DO;
	/* NODEID = 'x'; */
	sdacc_prosp_0 = .;
	sdacc_prosp_1 = .;
END;

run;

/*This file now has a column for likelihood to have SD accoount*/

/*Use the Meter CHAID code for Meter users*/


data fwork.sd_prospects;
/*length NODEID $120;*/
set fwork.sd_prospects;

/* NODEID = 'x'; */
/*sdmeter_prosp_0 = 0.497673;
sdmeter_prosp_1 = 0.502327;*/

IF named_contacts = 0.000000 THEN
DO;
	/* NODEID = 'x.2/0'; */
	IF site_status = 'PRIMARY' THEN
	DO;
		/* NODEID = 'x.2/0.27/0'; */
		IF mktsect = 'E'
		OR mktsect = 'G'
		OR mktsect = 'H'
		OR mktsect = 'R'
		OR mktsect = ' '
		OR mktsect = 'Z' THEN
		DO;
			/* NODEID = 'x.2/0.27/0.1/0'; */
			sdmeter_prosp_0 = 0.610294;
			sdmeter_prosp_1 = 0.389706;
		END;
		ELSE IF mktsect = 'C'
		     OR mktsect = 'D'
		     OR mktsect = 'F'
		     OR mktsect = 'M'
		     OR mktsect = 'P'
		     OR mktsect = 'U'
		     OR mktsect = 'W' THEN
		DO;
			/* NODEID = 'x.2/0.27/0.1/1'; */
			sdmeter_prosp_0 = 0.359281;
			sdmeter_prosp_1 = 0.640719;
		END;
	END;
	ELSE IF site_status = 'SECONDARY'
	     OR site_status = 'TERTIARY' THEN
	DO;
		/* NODEID = 'x.2/0.27/1'; */
		IF probcoll = 0.000000 THEN
		DO;
			/* NODEID = 'x.2/0.27/1.5/0'; */
			IF mktsect = 'D'
			OR mktsect = 'E'
			OR mktsect = 'H'
			OR mktsect = 'R'
			OR mktsect = 'U'
			OR mktsect = ' '
			OR mktsect = 'Z' THEN
			DO;
				/* NODEID = 'x.2/0.27/1.5/0.1/0'; */
				IF meterrevl12 < 1338.000000 THEN
				DO;
					/* NODEID = 'x.2/0.27/1.5/0.1/0.18/0'; */
					sdmeter_prosp_0 = 0.959535;
					sdmeter_prosp_1 = 0.040465;
				END;
				ELSE IF meterrevl12 >= 1338.000000  THEN
				DO;
					/* NODEID = 'x.2/0.27/1.5/0.1/0.18/1'; */
					sdmeter_prosp_0 = 0.817518;
					sdmeter_prosp_1 = 0.182482;
				END;
			END;
			ELSE IF mktsect = 'C'
			     OR mktsect = 'G'
			     OR mktsect = 'M'
			     OR mktsect = 'P'
			     OR mktsect = 'W' THEN
			DO;
				/* NODEID = 'x.2/0.27/1.5/0.1/1'; */
				IF new_compseg = 'A'
				OR new_compseg = 'C'
				OR new_compseg = 'E'
				OR new_compseg = 'E+'
				OR new_compseg = 'F'
				OR new_compseg = 'G'
				OR new_compseg = 'H'
				OR new_compseg = 'H+'
				OR new_compseg = 'I'
				OR new_compseg = 'Y'
				OR new_compseg = 'Z' THEN
				DO;
					/* NODEID = 'x.2/0.27/1.5/0.1/1.26/0'; */
					sdmeter_prosp_0 = 0.887324;
					sdmeter_prosp_1 = 0.112676;
				END;
				ELSE IF new_compseg = 'B'
				     OR new_compseg = 'C+'
				     OR new_compseg = 'D'
				     OR new_compseg = 'D+' THEN
				DO;
					/* NODEID = 'x.2/0.27/1.5/0.1/1.26/1'; */
					sdmeter_prosp_0 = 0.950226;
					sdmeter_prosp_1 = 0.049774;
				END;
			END;
			ELSE IF mktsect = 'F' THEN
			DO;
				/* NODEID = 'x.2/0.27/1.5/0.1/2'; */
				IF comp_mem = 0.000000 THEN
				DO;
					/* NODEID = 'x.2/0.27/1.5/0.1/2.11/0'; */
					sdmeter_prosp_0 = 0.798046;
					sdmeter_prosp_1 = 0.201954;
				END;
				ELSE IF comp_mem = 1.000000 THEN
				DO;
					/* NODEID = 'x.2/0.27/1.5/0.1/2.11/1'; */
					sdmeter_prosp_0 = 0.944206;
					sdmeter_prosp_1 = 0.055794;
				END;
			END;
		END;
		ELSE IF probcoll = 1.000000 THEN
		DO;
			/* NODEID = 'x.2/0.27/1.5/1'; */
			sdmeter_prosp_0 = 0.594406;
			sdmeter_prosp_1 = 0.405594;
		END;
	END;
END;
ELSE IF named_contacts = 1.000000  THEN
DO;
	/* NODEID = 'x.2/1'; */
	IF probcoll = 0.000000 THEN
	DO;
		/* NODEID = 'x.2/1.5/0'; */
		IF meterrevl12 < 1338.000000 THEN
		DO;
			/* NODEID = 'x.2/1.5/0.18/0'; */
			IF new_compseg = 'A'
			OR new_compseg = 'B'
			OR new_compseg = 'C'
			OR new_compseg = 'C+'
			OR new_compseg = 'D+'
			OR new_compseg = 'E'
			OR new_compseg = 'E+' THEN
			DO;
				/* NODEID = 'x.2/1.5/0.18/0.26/0'; */
				IF mktsect = 'C'
				OR mktsect = 'F'
				OR mktsect = 'H'
				OR mktsect = 'P'
				OR mktsect = 'R'
				OR mktsect = 'W'
				OR mktsect = ' '
				OR mktsect = 'Z' THEN
				DO;
					/* NODEID = 'x.2/1.5/0.18/0.26/0.1/0'; */
					sdmeter_prosp_0 = 0.844221;
					sdmeter_prosp_1 = 0.155779;
				END;
				ELSE IF mktsect = 'D'
				     OR mktsect = 'E'
				     OR mktsect = 'G'
				     OR mktsect = 'M'
				     OR mktsect = 'U' THEN
				DO;
					/* NODEID = 'x.2/1.5/0.18/0.26/0.1/1'; */
					sdmeter_prosp_0 = 0.727941;
					sdmeter_prosp_1 = 0.272059;
				END;
			END;
			ELSE IF new_compseg = 'D'
			     OR new_compseg = 'F'
			     OR new_compseg = 'G'
			     OR new_compseg = 'H'
				 OR new_compseg = 'H+'
			     OR new_compseg = 'I'
			     OR new_compseg = 'Y'
			     OR new_compseg = 'Z' THEN
			DO;
				/* NODEID = 'x.2/1.5/0.18/0.26/1'; */
				IF mktsect = 'D'
				OR mktsect = 'E'
				OR mktsect = 'G'
				OR mktsect = 'H'
				OR mktsect = 'P'
				OR mktsect = 'R'
				OR mktsect = 'W'
				OR mktsect = ' '
				OR mktsect = 'Z' THEN
				DO;
					/* NODEID = 'x.2/1.5/0.18/0.26/1.1/0'; */
					sdmeter_prosp_0 = 0.939842;
					sdmeter_prosp_1 = 0.060158;
				END;
				ELSE IF mktsect = 'C'
				     OR mktsect = 'M'
				     OR mktsect = 'U' THEN
				DO;
					/* NODEID = 'x.2/1.5/0.18/0.26/1.1/1'; */
					sdmeter_prosp_0 = 0.800000;
					sdmeter_prosp_1 = 0.200000;
				END;
				ELSE IF mktsect = 'F' THEN
				DO;
					/* NODEID = 'x.2/1.5/0.18/0.26/1.1/2'; */
					sdmeter_prosp_0 = 0.884921;
					sdmeter_prosp_1 = 0.115079;
				END;
			END;
		END;
		ELSE IF meterrevl12 >= 1338.000000 THEN
		DO;
			/* NODEID = 'x.2/1.5/0.18/1'; */
			sdmeter_prosp_0 = 0.670498;
			sdmeter_prosp_1 = 0.329502;
		END;
	END;
	ELSE IF probcoll = 1.000000 THEN
	DO;
		/* NODEID = 'x.2/1.5/1'; */
		IF meterrevl12 < 1338.000000 THEN
		DO;
			/* NODEID = 'x.2/1.5/1.18/0'; */
			sdmeter_prosp_0 = 0.508021;
			sdmeter_prosp_1 = 0.491979;
		END;
		ELSE IF meterrevl12 >= 1338.000000 THEN
		DO;
			/* NODEID = 'x.2/1.5/1.18/1'; */
			sdmeter_prosp_0 = 0.216667;
			sdmeter_prosp_1 = 0.783333;
		END;
	END;
END;
ELSE IF named_contacts = 2.000000 THEN
DO;
	/* NODEID = 'x.2/2'; */
	IF probcoll = 0.000000 THEN
	DO;
		/* NODEID = 'x.2/2.5/0'; */
		IF totalrmrevl12 < 1.000000 THEN
		DO;
			/* NODEID = 'x.2/2.5/0.14/0'; */
			sdmeter_prosp_0 = 0.705224;
			sdmeter_prosp_1 = 0.294776;
		END;
		ELSE IF totalrmrevl12 >= 1.000000 AND totalrmrevl12 < 2600.000000 THEN
		DO;
			/* NODEID = 'x.2/2.5/0.14/1'; */
			IF mktsect = 'D'
			OR mktsect = 'F'
			OR mktsect = 'H'
			OR mktsect = 'M'
			OR mktsect = 'P'
			OR mktsect = ' '
			OR mktsect = 'Z' THEN
			DO;
				/* NODEID = 'x.2/2.5/0.14/1.1/0'; */
				IF meter_flag = 0.000000 THEN
				DO;
					/* NODEID = 'x.2/2.5/0.14/1.1/0.36/0'; */
					sdmeter_prosp_0 = 0.926174;
					sdmeter_prosp_1 = 0.073826;
				END;
				ELSE IF meter_flag = 1.000000 THEN
				DO;
					/* NODEID = 'x.2/2.5/0.14/1.1/0.36/1'; */
					sdmeter_prosp_0 = 0.824427;
					sdmeter_prosp_1 = 0.175573;
				END;
			END;
			ELSE IF mktsect = 'C'
			     OR mktsect = 'E'
			     OR mktsect = 'G'
			     OR mktsect = 'R'
			     OR mktsect = 'U'
			     OR mktsect = 'W' THEN
			DO;
				/* NODEID = 'x.2/2.5/0.14/1.1/1'; */
				sdmeter_prosp_0 = 0.765217;
				sdmeter_prosp_1 = 0.234783;
			END;
		END;
		ELSE IF totalrmrevl12 >= 2600.000000THEN
		DO;
			/* NODEID = 'x.2/2.5/0.14/2'; */
			sdmeter_prosp_0 = 0.505435;
			sdmeter_prosp_1 = 0.494565;
		END;
	END;
	ELSE IF probcoll = 1.000000 THEN
	DO;
		/* NODEID = 'x.2/2.5/1'; */
		IF meterrevl12 < 3062.000000 THEN
		DO;
			/* NODEID = 'x.2/2.5/1.18/0'; */
			IF totalrmrevl12 < 860.000000 THEN
			DO;
				/* NODEID = 'x.2/2.5/1.18/0.14/0'; */
				sdmeter_prosp_0 = 0.416667;
				sdmeter_prosp_1 = 0.583333;
			END;
			ELSE IF totalrmrevl12 >= 860.000000 THEN
			DO;
				/* NODEID = 'x.2/2.5/1.18/0.14/1'; */
				sdmeter_prosp_0 = 0.267857;
				sdmeter_prosp_1 = 0.732143;
			END;
		END;
		ELSE IF meterrevl12 >= 3062.000000 THEN
		DO;
			/* NODEID = 'x.2/2.5/1.18/1'; */
			sdmeter_prosp_0 = 0.132075;
			sdmeter_prosp_1 = 0.867925;
		END;
	END;
END;
ELSE IF named_contacts = 3.000000THEN
DO;
	/* NODEID = 'x.2/3'; */
	IF probcoll = 0.000000 THEN
	DO;
		/* NODEID = 'x.2/3.5/0'; */
		IF meterrevl12 < 1.000000 THEN
		DO;
			/* NODEID = 'x.2/3.5/0.18/0'; */
			sdmeter_prosp_0 = 0.682403;
			sdmeter_prosp_1 = 0.317597;
		END;
		ELSE IF meterrevl12 >= 1.000000 AND meterrevl12 < 3062.000000 THEN
		DO;
			/* NODEID = 'x.2/3.5/0.18/1'; */
			sdmeter_prosp_0 = 0.858333;
			sdmeter_prosp_1 = 0.141667;
		END;
		ELSE IF meterrevl12 >= 3062.000000 THEN
		DO;
			/* NODEID = 'x.2/3.5/0.18/2'; */
			sdmeter_prosp_0 = 0.426573;
			sdmeter_prosp_1 = 0.573427;
		END;
	END;
	ELSE IF probcoll = 1.000000 THEN
	DO;
		/* NODEID = 'x.2/3.5/1'; */
		IF totalrmrevl12 < 2600.000000 THEN
		DO;
			/* NODEID = 'x.2/3.5/1.14/0'; */
			sdmeter_prosp_0 = 0.421769;
			sdmeter_prosp_1 = 0.578231;
		END;
		ELSE IF totalrmrevl12 >= 2600.000000 THEN
		DO;
			/* NODEID = 'x.2/3.5/1.14/1'; */
			IF mktsect = 'D'
			OR mktsect = 'G'
			OR mktsect = 'H'
			OR mktsect = 'P'
			OR mktsect = ' '
			OR mktsect = 'Z' THEN
			DO;
				/* NODEID = 'x.2/3.5/1.14/1.1/0'; */
				sdmeter_prosp_0 = 0.218487;
				sdmeter_prosp_1 = 0.781513;
			END;
			ELSE IF mktsect = 'C'
			     OR mktsect = 'E'
			     OR mktsect = 'F'
			     OR mktsect = 'M'
			     OR mktsect = 'R'
			     OR mktsect = 'U'
			     OR mktsect = 'W' THEN
			DO;
				/* NODEID = 'x.2/3.5/1.14/1.1/1'; */
				sdmeter_prosp_0 = 0.104072;
				sdmeter_prosp_1 = 0.895928;
			END;
		END;
	END;
END;
ELSE IF named_contacts = 4.000000 THEN
DO;
	/* NODEID = 'x.2/4'; */
	IF probcoll = 0.000000 THEN
	DO;
		/* NODEID = 'x.2/4.5/0'; */
		IF meterrevl12 < 3062.000000 THEN
		DO;
			/* NODEID = 'x.2/4.5/0.18/0'; */
			sdmeter_prosp_0 = 0.586957;
			sdmeter_prosp_1 = 0.413043;
		END;
		ELSE IF meterrevl12 >= 3062.000000 THEN
		DO;
			/* NODEID = 'x.2/4.5/0.18/1'; */
			sdmeter_prosp_0 = 0.360360;
			sdmeter_prosp_1 = 0.639640;
		END;
	END;
	ELSE IF probcoll = 1.000000 THEN
	DO;
		/* NODEID = 'x.2/4.5/1'; */
		IF meterrevl12 < 5310.000000 THEN
		DO;
			/* NODEID = 'x.2/4.5/1.18/0'; */
			IF mktsect = 'F'
			OR mktsect = 'H'
			OR mktsect = 'M'
			OR mktsect = 'R'
			OR mktsect = ' '
			OR mktsect = 'Z' THEN
			DO;
				/* NODEID = 'x.2/4.5/1.18/0.1/0'; */
				sdmeter_prosp_0 = 0.210843;
				sdmeter_prosp_1 = 0.789157;
			END;
			ELSE IF mktsect = 'C'
			     OR mktsect = 'D'
			     OR mktsect = 'E'
			     OR mktsect = 'G'
			     OR mktsect = 'P'
			     OR mktsect = 'U'
			     OR mktsect = 'W' THEN
			DO;
				/* NODEID = 'x.2/4.5/1.18/0.1/1'; */
				sdmeter_prosp_0 = 0.390000;
				sdmeter_prosp_1 = 0.610000;
			END;
		END;
		ELSE IF meterrevl12 >= 5310.000000 THEN
		DO;
			/* NODEID = 'x.2/4.5/1.18/1'; */
			sdmeter_prosp_0 = 0.104000;
			sdmeter_prosp_1 = 0.896000;
		END;
	END;
END;
ELSE IF named_contacts = 5.000000 THEN
DO;
	/* NODEID = 'x.2/5'; */
	IF meterrevl12 < 3062.000000 THEN
	DO;
		/* NODEID = 'x.2/5.18/0'; */
		sdmeter_prosp_0 = 0.375527;
		sdmeter_prosp_1 = 0.624473;
	END;
	ELSE IF meterrevl12 >= 3062.000000 AND meterrevl12 < 8000.000000 THEN
	DO;
		/* NODEID = 'x.2/5.18/1'; */
		sdmeter_prosp_0 = 0.200957;
		sdmeter_prosp_1 = 0.799043;
	END;
	ELSE IF meterrevl12 >= 8000.000000 THEN
	DO;
		/* NODEID = 'x.2/5.18/2'; */
		sdmeter_prosp_0 = 0.087273;
		sdmeter_prosp_1 = 0.912727;
	END;
END;
ELSE IF named_contacts >= 6.000000 AND named_contacts < 8.000000 THEN
DO;
	/* NODEID = 'x.2/6'; */
	IF totalrmrevl12 < 2600.000000 THEN
	DO;
		/* NODEID = 'x.2/6.14/0'; */
		IF probcoll = 0.000000 THEN
		DO;
			/* NODEID = 'x.2/6.14/0.5/0'; */
			sdmeter_prosp_0 = 0.551402;
			sdmeter_prosp_1 = 0.448598;
		END;
		ELSE IF probcoll = 1.000000 THEN
		DO;
			/* NODEID = 'x.2/6.14/0.5/1'; */
			sdmeter_prosp_0 = 0.333333;
			sdmeter_prosp_1 = 0.666667;
		END;
	END;
	ELSE IF totalrmrevl12 >= 2600.000000 AND totalrmrevl12 < 9200.000000 THEN
	DO;
		/* NODEID = 'x.2/6.14/1'; */
		sdmeter_prosp_0 = 0.164179;
		sdmeter_prosp_1 = 0.835821;
	END;
	ELSE IF totalrmrevl12 >= 9200.000000 THEN
	DO;
		/* NODEID = 'x.2/6.14/2'; */
		sdmeter_prosp_0 = 0.075000;
		sdmeter_prosp_1 = 0.925000;
	END;
END;
ELSE IF named_contacts >= 8.000000 AND named_contacts < 11.000000 THEN
DO;
	/* NODEID = 'x.2/7'; */
	IF meterrevl12 < 1338.000000 THEN
	DO;
		/* NODEID = 'x.2/7.18/0'; */
		sdmeter_prosp_0 = 0.290323;
		sdmeter_prosp_1 = 0.709677;
	END;
	ELSE IF meterrevl12 >= 1338.000000 AND meterrevl12 < 19477.000000 THEN
	DO;
		/* NODEID = 'x.2/7.18/1'; */
		sdmeter_prosp_0 = 0.112121;
		sdmeter_prosp_1 = 0.887879;
	END;
	ELSE IF meterrevl12 >= 19477.000000 THEN
	DO;
		/* NODEID = 'x.2/7.18/2'; */
		sdmeter_prosp_0 = 0.053628;
		sdmeter_prosp_1 = 0.946372;
	END;
END;
ELSE IF named_contacts >= 11.000000 THEN
DO;
	/* NODEID = 'x.2/8'; */
	IF meterrevl12 < 1.000000 THEN
	DO;
		/* NODEID = 'x.2/8.18/0'; */
		IF mroom = 0.000000 THEN
		DO;
			/* NODEID = 'x.2/8.18/0.13/0'; */
			sdmeter_prosp_0 = 0.177419;
			sdmeter_prosp_1 = 0.822581;
		END;
		ELSE IF mroom = 1.000000 THEN
		DO;
			/* NODEID = 'x.2/8.18/0.13/1'; */
			sdmeter_prosp_0 = 0.083333;
			sdmeter_prosp_1 = 0.916667;
		END;
	END;
	ELSE IF meterrevl12 >= 1.000000 AND meterrevl12 < 5310.000000 THEN
	DO;
		/* NODEID = 'x.2/8.18/1'; */
		sdmeter_prosp_0 = 0.184000;
		sdmeter_prosp_1 = 0.816000;
	END;
	ELSE IF meterrevl12 >= 5310.000000 THEN
	DO;
		/* NODEID = 'x.2/8.18/2'; */
		sdmeter_prosp_0 = 0.048405;
		sdmeter_prosp_1 = 0.951595;
	END;
END;
/*The following code is optional.  It can be used to treat missing and unknown cases as missing.  By default, the missing and unknown cases are scored as the average.*/
/*ELSE 
DO;*/
	/* NODEID = 'x'; */
/*	sdmeter_prosp_0 = '???';
	sdmeter_prosp_1 = '???';
END;*/

run;

/*Using the fields for SD Account Use, SD Meter Use. SD Acc Prospect and SD Meter Prospect
can have a field which provides a hieracrhy for mailings*/

data fwork.sd_prospects;
	set fwork.sd_prospects;
	if sdacc = 1 then SD_Hierarchy = 4;
	else if sdmeter = 1 then SD_Hierarchy = 3;
	else if sdacc_prosp_1 => 0.80 then SD_Hierarchy = 2;
	else if sdacc_prosp_1 => 0.70 and sdmeter_prosp_1 < 0.90 then SD_Hierarchy = 2;
	else if sdmeter_prosp_1 => 0.80 then SD_Hierarchy = 1;
	else SD_Hierarchy = 0;
run;	

/*Band the DV_1 as a format to allow analysis*/

proc format;
	value likelihood 
				0-0.10000='0-10%'
				0.1000-0.2000='11-20%'
				0.2000-0.3000='21-30%'
				0.3000-0.4000='31-40%'
				0.4000-0.5000='41-50%'
				0.5000-0.6000='51-60%'
				0.6000-0.7000='61-70%'
				0.7000-0.8000='71-80%'
				0.8000-0.9000='81-90%'
				0.9000-1='91-100%';
	run;

/*run proc freqs on the bands against all sd account users and the top sd account users*/


proc freq data=fwork.sd_prospects;
	tables sdacc_prosp_1*sdacc/missing;
	format sdacc_prosp_1 likelihood.;
run;

proc freq data=fwork.sd_prospects;
	tables sdmeter_prosp_1*sdmeter/missing;
	format sdmeter_prosp_1 likelihood.;
run;

proc freq data=fwork.sd_prospects;
	tables sdmeter_prosp_1*sdacc_prosp_1/missing;
	format sdmeter_prosp_1 likelihood.;
	format sdacc_prosp_1 likelihood.;
run;

proc freq data=fwork.sd_prospects;
	tables new_compseg*SD_Hierarchy/missing;
run;


/*Output for powerpoint*/
ods csv file="n:\data\car_data\roy_mail\2005 Financial Year\UK Mails\Deliver Your Promises\Special Delivery\SD Framework\Output\sd_acc_prospects.csv";


proc freq data=fwork.sd_prospects;
	tables sdacc_prosp_1*sdacc/missing nocol nopercent norow;
	format sdacc_prosp_1 likelihood.;
run;

proc freq data=fwork.sd_prospects;
	tables sdmeter_prosp_1*sdmeter/missing nocol nopercent norow;
	format sdmeter_prosp_1 likelihood.;
run;


proc freq data=temp;
	tables new_compseg*SD_Hierarchy/missing nocol nopercent norow;
	format sdmeter_prosp_1 likelihood.;
run;

ods _all_ close;
ods listing;

