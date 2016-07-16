rem 
rem $Header: cat714.sql,v 1.1 1993/03/12 15:37:16 VRAGHUNA Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      cat714.sql - Migrate 7.0.13 to 7.0.14
Rem
Rem    DESCRIPTION
Rem      RIGHT AFTER A 7.0.13 DATABASE IS STARTED
Rem      UP USING 7.0.14 RELEASE FOR THE FIRST TIME, RUN THIS SCRIPT ONCE
Rem      (RUN AS SYS OR INTERNAL).
Rem      A 7.0.13 database is a database that has been created using 7.0.13
Rem      release or upgraded to use 7.0.13 release.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     vraghuna   03/12/93 -  Creation 
REM
REM     THIS SCRIPT IS TO BE RUN ONCE RIGHT AFTER A 7.0.13 DATABASE
REM     IS STARTED UP FOR THE FIRST TIME USING ORACLE7
REM     RELEASE 7.0.14 (RUN AS SYS OR INTERNAL).
REM     A 7.0.13 database is a database that has been created using 7.0.13
REM     release or upgraded to use 7.0.13 release.
REM

REM Remove exu7inv for export
drop view exu7inv
/

REM
