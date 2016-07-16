REM
REM $Header$
REM

REM Copyright (c) Oracle Corporation Canada Inc. 1992,1994 All Right Reserved.

REM
REM NAME:
REM    catmd.sql 
REM DESCRIPTION:
REM    Installs 
REM		- MD3 data dictionary tables 
REM		- MD3 data dictionary user views
REM		- MDSQL packages for MD operations
REM		- MDWEX packages for extracting data 
REM		- MDD package for partition operation Daemon
REM		- MDGTRIG package for generating triggers
REM NOTES:
REM    Must be run as MDSYS.
REM MODIFIED     (DD-MON-YY)  DESCRIPTION
REM Vretanos      24-JAN-96   Remove PRVTLIMS.SQL file.
REM Feng          27-DEC-95   Reorder execution of prvtboot with md package
REM Vretanos      28-SEP-95   Modify order of installation of MDD.
REM Vretanos      22-SEP-95   Add MDLIMS pacakge.
REM Vretanos      21-SEP-95   Update MD_WEX installation.
REM Feng          01-AUG-95   Add MDDICT dictionary package
REM Vretanos      22-NOV-94   Creation
REM

REM Installing MD3 tables ...
prompt Installing MD3 tables ...
@@prvtboot.plb
show errors;
set serveroutput on
execute mdbootstrap.build_md3;

commit;

REM Creating MD package ...
prompt Creating package MD ...
@@md
show errors;
@@prvtmd.plb
show errors;

commit;

REM Creating MD3 views ...
prompt Creating MD3 views ...
@@md3view
@@md3dba
commit;

REM Creating MDLIB package ...
prompt Creating package MDLIB ...
@@prvtmdlb.plb
show errors;
commit;

REM Creating MDLEX package ...
prompt Creating package MDLEX ...
@@prvtlex.plb
show errors;

REM Creating MDGEN package ...
prompt Creating MDGEN pacakge ...
@@prvtmdgn.plb
show errors;

REM Creating MDDICT package ...
prompt Creating package MDDICT ...
@@prvtdict.plb
show errors;
commit;

REM Creating MDERR package ...
prompt Creating package MDERR ...
@@prvterr.plb
show errors;

REM Creating MDD package ...
prompt Creating MDD package ...
@@mdd
show errors;
@@prvtmdd.plb
show errors;
 
REM Create MDTRIG package ...
@@prvttrig.plb
show errors;

REM Create MDEXEC package ...
prompt Creating package MDEXEC ...
@@prvtexec.plb
show errors;
commit;
 
REM Creating MD_DDL package ...
prompt Creating MD_DDL package ...
@@md_ddl
show errors;
@@prvtddl.plb
show errors;
commit;
 
REM Creating MD_DML package ...
prompt Creating MD_DML package ...
@@md_dml
show errors;
@@prvtdml.plb
show errors;
commit;
 
REM Creating MD_PART package ...
prompt Creating MD_PART package ...
@@md_part
show errors;
@@prvtpart.plb
show errors;
commit;

REM Install MD_WEX package.
prompt Install MD_WEX package.
@@prvtvbld.plb
show errors;
@@prvtwxut.plb
show errors;
@@md_wex
show errors;
@@prvtwex.plb
show errors;

REM Install the MDVERIFY pacakage.
prompt Install MDVERIFY package ...
@@mdverify.plb
show errors;
