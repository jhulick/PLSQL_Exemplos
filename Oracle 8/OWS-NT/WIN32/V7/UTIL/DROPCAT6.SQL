rem 
rem $Header: dropcat6.sql,v 1.1 1992/09/29 15:46:40 RLIM Stab $ 
rem 
Rem Copyright (c) 1992 by Oracle Corporation
Rem NAME
Rem    dropcat6.sql
Rem  FUNCTION
Rem    Drop version 6 dictionary objects owned by SYS
Rem  NOTES
Rem    This script should be run while logged-in as SYS on a version 6
Rem    database.  It drops all version 6 dictionary objects.
Rem    If a user is about to perform a full database export of a
Rem    version 6 database that will be imported into a version 7
Rem    database, he should first run this script to prevent the export
Rem    and later import of the old dictionary objects. 
Rem
Rem  MODIFIED
Rem     rlim       09/29/92 -  Creation 
Rem

set echo on
drop public synonym dual;
drop public synonym ACCESSIBLE_TABLES;
drop public synonym ACCESSIBLE_COLUMNS;
drop public synonym CONSTRAINT_DEFS;
drop public synonym CONSTRAINT_COLUMNS;
drop public synonym USER_CROSS_REFS;
drop public synonym USER_TAB_GRANTS;
drop public synonym USER_TAB_GRANTS_MADE;
drop public synonym ALL_TAB_GRANTS_MADE;
drop public synonym USER_TAB_GRANTS_RECD;
drop public synonym ALL_TAB_GRANTS_RECD;
drop public synonym USER_COL_GRANTS;
drop public synonym ALL_TAB_GRANTS;
drop public synonym ALL_COL_GRANTS;
drop public synonym USER_COL_GRANTS_MADE;
drop public synonym ALL_COL_GRANTS_MADE;
drop public synonym USER_COL_GRANTS_RECD;
drop public synonym ALL_COL_GRANTS_RECD;
drop public synonym USER_AUDIT_CONNECT;
drop public synonym DBA_AUDIT_CONNECT;
drop public synonym USER_AUDIT_RESOURCE;
drop public synonym DBA_AUDIT_RESOURCE;
drop public synonym DBA_AUDIT_DBA;
drop public synonym USER_TAB_AUDIT_OPTS;

drop table dual;
drop view ACCESSIBLE_TABLES;
drop view CONSTRAINT_DEFS;
drop view CONSTRAINT_COLUMNS;
drop view USER_CROSS_REFS;
drop view DBA_CROSS_REFS;
drop view USER_TAB_GRANTS;
drop view DBA_TAB_GRANTS;
drop view USER_TAB_GRANTS_MADE;
drop view ALL_TAB_GRANTS_MADE;
drop view USER_TAB_GRANTS_RECD;
drop view ALL_TAB_GRANTS_RECD;
drop view USER_COL_GRANTS;
drop view DBA_COL_GRANTS;
drop view USER_COL_GRANTS_MADE;
drop view ALL_COL_GRANTS_MADE;
drop view USER_COL_GRANTS_RECD;
drop view ALL_COL_GRANTS_RECD;
drop view USER_AUDIT_CONNECT;
drop view USER_AUDIT_RESOURCE;
drop view DBA_AUDIT_DBA;
drop view USER_TAB_AUDIT_OPTS;
drop view DBA_TAB_AUDIT_OPTS;
set echo off;
