rem 
rem $Header: cat7203.sql,v 1.2 1995/11/13 13:11:15 jbellemo Exp $ 
rem 
Rem  Copyright (c) 1995 by Oracle Corporation 
Rem    NAME
Rem      cat7203.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      RIGHT AFTER A 7.2.2 DATABASE IS STARTED UP USING 7.2.3
Rem      FOR THE FIRST TIME, RUN THIS SCRIPT ONCE AS INTERNAL.
Rem      A 7.2.2 database is a database that has been created using
Rem      7.2.2 release or upgraded to use 7.2.2 release.
Rem    RETURNS
Rem 
Rem    NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     jbellemo   11/11/95 -  merge changes from branch 1.1.720.1
Rem     jbellemo   05/25/95 -  Branch_for_patch
Rem     jbellemo   05/24/95 -  Creation
 
insert into SYSTEM_PRIVILEGE_MAP values (-194, 'WRITEDOWN DBLOW')
/
insert into SYSTEM_PRIVILEGE_MAP values (-195, 'READUP DBHIGH')
/
insert into SYSTEM_PRIVILEGE_MAP values (-196, 'WRITEUP DBHIGH')
/
insert into STMT_AUDIT_OPTION_MAP values (194, 'WRITEDOWN DBLOW')
/
insert into STMT_AUDIT_OPTION_MAP values (195, 'READUP DBHIGH')
/
insert into STMT_AUDIT_OPTION_MAP values (196, 'WRITEUP DBHIGH')
/
