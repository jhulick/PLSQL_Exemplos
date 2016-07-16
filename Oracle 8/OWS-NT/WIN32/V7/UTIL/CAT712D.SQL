rem 
rem $Header: cat712d.sql,v 1.4 1994/12/29 15:03:35 wmaimone Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      cat712d.sql - Migrate 7.0.13 down to 7.0.12
Rem    DESCRIPTION
Rem      RIGHT AFTER A 7.0.13 DATABASE IS STARTED
Rem      UP (DOWNGRADED) USING A 7.0.12 RELEASE FOR THE FIRST TIME, RUN THIS
Rem      SCRIPT ONCE (RUN AS SYS OR INTERNAL).
Rem      A 7.0.13 database is a database that has been created using 7.0.13
Rem      release or upgraded to use 7.0.13 release.
Rem    MODIFIED   (MM/DD/YY)
Rem     wmaimone   12/29/94 -  #254503 commit is SQL
Rem     jwijaya    03/04/93 -  merge changes from branch 1.1.312.1 
Rem     jwijaya    03/04/93 -  merge changes from branch 1.1 
Rem     jwijaya    03/03/93 -  make version default to 0 
Rem     jwijaya    03/01/93 -  Creation 

REM
REM     THIS SCRIPT IS TO BE RUN ONCE RIGHT AFTER A 7.0.13 DATABASE
REM     IS STARTED UP (DOWNGRADED) FOR THE FIRST TIME USING
REM     ORACLE7 RELEASE 7.0.12 (RUN AS SYS OR INTERNAL).
REM     A 7.0.13 database is a database that has been created using 7.0.13
REM     release or upgraded to use 7.0.13 release.
REM

REM     Invalidate all stored procedures...
update obj$ set status = 6
where type in (7, 8, 9, 11)
  and status not in (5, 6)
  and linkname is null
/
commit
/

REM     Delete all diana and pcode of objects...
truncate table idl_ub1$
/
truncate table idl_char$
/
truncate table idl_ub2$
/
truncate table idl_sb4$
/

REM     Make VERSION default to 0...
alter table idl_ub1$ modify version number default 0
/
alter table idl_char$ modify version number default 0
/
alter table idl_ub2$ modify version number default 0
/
alter table idl_sb4$ modify version number default 0
/

REM     Flush the dictionary and library caches...
alter system flush shared_pool
/
REM     One more time for good measure...
alter system flush shared_pool
/
