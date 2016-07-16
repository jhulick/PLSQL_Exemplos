rem 
rem $Header: cat712pd.sql,v 1.5 1993/03/04 19:21:36 JWIJAYA Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      cat712pd.sql - Migrate 7.0.13 down to 7.0.12 (with the procedural
Rem                                                    option)
Rem    DESCRIPTION
Rem      RIGHT AFTER A 7.0.13 DATABASE WITH THE PROCEDURAL OPTION IS STARTED
Rem      UP (DOWNGRADED) USING A 7.0.12 RELEASE FOR THE FIRST TIME, RUN THIS
Rem      SCRIPT ONCE (RUN AS SYS OR INTERNAL) AFTER CAT712D.SQL IS RUN.
Rem      A 7.0.13 database is a database that has been created using 7.0.13
Rem      release or upgraded to use 7.0.13 release.
Rem    MODIFIED   (MM/DD/YY)
Rem     jwijaya    03/04/93 -  merge changes from branch 1.1.312.3 
Rem     jwijaya    02/22/93 -  merge changes from branch 1.1.312.2 
Rem     jwijaya    02/10/93 -  merge changes from branch 1.1.312.1 
Rem     jwijaya    02/09/93 -  merge changes from branch 1.1 
Rem     jwijaya    03/01/93 -  move some to cat712d.sql
Rem     jwijaya    02/11/93 -  update 
Rem     jwijaya    02/09/93 -  commit 
Rem     jwijaya    02/05/93 -  Creation 

REM
REM     THIS SCRIPT IS TO BE RUN ONCE RIGHT AFTER A 7.0.13 DATABASE WITH THE
REM     PROCEDURAL OPTION IS STARTED UP (DOWNGRADED) FOR THE FIRST TIME USING
REM     ORACLE7 RELEASE 7.0.12 (RUN AS SYS OR INTERNAL) AFTER CAT712D.SQL
REM     IS RUN.
REM     A 7.0.13 database is a database that has been created using 7.0.13
REM     release or upgraded to use 7.0.13 release.
REM

REM     Recreate RPC views...
@@catrpc

REM     Recreate stored packages that have been modified...
@@standard
@@dbmsotpt
@@dbmsutil
