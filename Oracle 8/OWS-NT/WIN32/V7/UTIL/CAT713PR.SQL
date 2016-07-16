rem 
rem $Header: cat713pr.sql,v 1.5 1993/03/04 19:22:24 JWIJAYA Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      cat713pr.sql - Migrate 7.0.12 to 7.0.13 (with the procedural option)
Rem    DESCRIPTION
Rem      RIGHT AFTER A 7.0.12 DATABASE WITH THE PROCEDURAL OPTION IS STARTED
Rem      UP USING 7.0.13 RELEASE FOR THE FIRST TIME, RUN THIS SCRIPT ONCE
Rem      (RUN AS SYS OR INTERNAL) AFTER CAT713.SQL IS RUN.
Rem      A 7.0.12 database is a database that has been created using 7.0.12
Rem      release or upgraded to use 7.0.12 release.
Rem    MODIFIED   (MM/DD/YY)
Rem     jwijaya    03/04/93 -  merge changes from branch 1.1.312.3 
Rem     jwijaya    02/22/93 -  merge changes from branch 1.1.312.2 
Rem     jwijaya    02/10/93 -  merge changes from branch 1.1.312.1 
Rem     jwijaya    02/09/93 -  merge changes from branch 1.1 
Rem     jwijaya    03/01/93 -  move some to cat713.sql 
Rem     jwijaya    02/11/93 -  update 
Rem     jwijaya    02/09/93 -  commit 
Rem     jwijaya    02/05/93 -  Creation 

REM
REM     THIS SCRIPT IS TO BE RUN ONCE RIGHT AFTER A 7.0.12 DATABASE WITH
REM     THE PROCEDURAL OPTION IS STARTED UP FOR THE FIRST TIME USING ORACLE7
REM     RELEASE 7.0.13 (RUN AS SYS OR INTERNAL) AFTER CAT713.SQL IS RUN.
REM     A 7.0.12 database is a database that has been created using 7.0.12
REM     release or upgraded to use 7.0.12 release.
REM

REM     Recreate RPC views...
@@catrpc

REM     Recreate stored packages that have been modified...
@@standard
@@dbmsotpt
@@dbmsutil
