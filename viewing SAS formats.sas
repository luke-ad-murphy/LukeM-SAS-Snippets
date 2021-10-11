All,

You should now find that you have a libname called "Library" set up by the autoexec.  This will let you use the common formats as explained at last weeks session.

If you want to view what is "in" a format, the following will let you do this :


/*1) Activate the explorer within SAS v8
2) Tools...options...Explorer
3) Pick "Catalog Entries" from dropdown
4) Find "FORMAT"
5) Double click on it
6) Click "Add" button
7) Type in an Action of your choice - eg "View Format"
8) Copy the Action Command below for FORMAT,  i.e. GSUBMIT 'proc .... run;'
9) Click "OK", and again "OK"
10) Repeat 4-9 for FORMATC (character formats)
11) Make sure you have "Save settings" selected in Tools...Options...Preferences...General, else you will need to do this each session!

Now when you double click on a format, it will be displayed in the output window.  If you do this for a pcnumber based format it will take a while to appear (10mins) as there are 3million+ entries*/


/*Action Command For FORMAT = */ GSUBMIT 'proc format library=%8b.%32b fmtlib; select %32b; run;'
/*Action Command  For FORMATC =*/ GSUBMIT 'proc format library=%8b.%32b fmtlib; select $%32b; run;'


