rem 
rem $Header: catnoaud.sql,v 1.1 1992/10/20 14:10:12 GLUMPKIN Stab $ noaudit.sql 
rem 
Rem Copyright (c) 1990 by Oracle Corporation
Rem NAME
REM    CATNOAUD.SQL
Rem  FUNCTION
Rem    Drop the auditing catalog views, created by audit.sql.
Rem  NOTES
Rem    Must be run while connected to SYS.
Rem  MODIFIED
Rem     glumpkin   10/20/92 -  Renamed from NOAUDIT.SQL 
Rem     rlim       07/30/91 -         added new drop sysnonyms for new auditing
Rem   Chaudhr    03/09/90 - Creation
Rem

Rem -- Tables

drop table AUDIT_OPTION_MAP
/
drop table AUDIT_ACTIONS
/

Rem -- Views

drop view  ALL_DEF_AUDIT_OPTS
/
drop view  DBA_OBJ_AUDIT_OPTS
/
drop view  USER_OBJ_AUDIT_OPTS
/
drop view  DBA_STMT_AUDIT_OPTS
/
drop view  DBA_AUDIT_TRAIL
/
drop view  USER_AUDIT_TRAIL
/
drop view  DBA_AUDIT_SESSION
/
drop view  USER_AUDIT_SESSION
/
drop view  DBA_AUDIT_STATEMENT
/
drop view  USER_AUDIT_STATEMENT
/
drop view  DBA_AUDIT_OBJECT
/
drop view  USER_AUDIT_OBJECT
/
drop view  DBA_AUDIT_EXISTS
/

Rem -- Public Synonyms [for tables and views]

drop public synonym AUDIT_OPTION_MAP
/
drop public synonym AUDIT_ACTIONS
/
drop public synonym ALL_DEF_AUDIT_OPTS
/
drop public synonym USER_TAB_AUDIT_OPTS
/
drop synonym DBA_STMT_AUDIT_OPTS
/
drop synonym DBA_OBJ_AUDIT_OPTS
/
drop synonym DBA_AUDIT_TRAIL
/
drop public synonym USER_AUDIT_TRAIL
/
drop synonym DBA_AUDIT_SESSION
/
drop public synonym USER_AUDIT_SESSION
/
drop synonym DBA_AUDIT_STATEMENT
/
drop public synonym USER_AUDIT_STATEMENT
/
drop synonym DBA_AUDIT_OBJECT
/
drop public synonym USER_AUDIT_OBJECT
/
drop synonym DBA_AUDIT_EXISTS
/




