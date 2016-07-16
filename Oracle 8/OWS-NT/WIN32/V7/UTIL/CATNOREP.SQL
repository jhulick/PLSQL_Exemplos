rem 
rem $Header: catnorep.sql,v 1.1 1995/01/05 10:57:40 echeng Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      catnorep.sql - Remove the objects catrepad.sql creates
Rem    DESCRIPTION
Rem      
Rem    RETURNS
Rem 
Rem    NOTES
Rem      This script expects to already be connected
Rem    MODIFIED   (MM/DD/YY)
Rem       hasun    10/20/94 -

------------------------------------------------------------------------------
--- Remove all database objects associated with Replication for Server Manager
------------------------------------------------------------------------------
drop view DBA_ADMINSCHEMAS
/
drop view ALL_ADMINSCHEMAS
/
drop view USER_ADMINSCHEMAS
/
drop view DBA_ADMINOBJECTS
/
drop view ALL_ADMINOBJECTS
/
drop view USER_ADMINOBJECTS
/
drop view DBA_ADMINMASTERS
/
drop view ALL_ADMINMASTERS
/
drop view USER_ADMINMASTERS
/
drop view DBA_ADMINRESOLUTION
/
drop view ALL_ADMINRESOLUTION
/
drop view USER_ADMINRESOLUTION
/
drop view DBA_ADMINDEFTRAN
/
drop view DBA_ADMINDEFERROR
/
drop view DBA_ADMINCATLOG
/
drop view ALL_ADMINCATLOG
/ 
drop view USER_ADMINCATLOG
/
drop view DBA_ADMINREGSNAPS
/
drop view ALL_ADMINREGSNAPS
/
drop view USER_ADMINREGSNAPS
/
drop package DBMS_DEFER_PRINT
/
drop table DEFCALLARGS
/
drop view DBA_ADMINARGUMENTS
/

commit
/
