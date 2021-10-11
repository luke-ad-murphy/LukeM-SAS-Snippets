rsubmit;
proc sql;
    create index RBTACCTID on BUS_OOB_CAMPAIGN_SEGMENTS_v2 (RBTACCTID);
quit;
endrsubmit;
