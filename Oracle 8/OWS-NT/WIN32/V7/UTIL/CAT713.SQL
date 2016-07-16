rem 
rem $Header: cat713.sql,v 1.3 1994/12/29 15:04:17 wmaimone Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      cat713.sql - Migrate 7.0.12 to 7.0.13
Rem    DESCRIPTION
Rem      RIGHT AFTER A 7.0.12 DATABASE IS STARTED
Rem      UP USING 7.0.13 RELEASE FOR THE FIRST TIME, RUN THIS SCRIPT ONCE
Rem      (RUN AS SYS OR INTERNAL).
Rem      A 7.0.12 database is a database that has been created using 7.0.12
Rem      release or upgraded to use 7.0.12 release.
Rem    MODIFIED   (MM/DD/YY)
Rem     wmaimone   12/29/94 -  #254503 commit is SQL
Rem     jwijaya    03/04/93 -  merge changes from branch 1.1 
Rem     jwijaya    03/01/93 -  Creation 

REM
REM     THIS SCRIPT IS TO BE RUN ONCE RIGHT AFTER A 7.0.12 DATABASE
REM     IS STARTED UP FOR THE FIRST TIME USING ORACLE7
REM     RELEASE 7.0.13 (RUN AS SYS OR INTERNAL).
REM     A 7.0.12 database is a database that has been created using 7.0.12
REM     release or upgraded to use 7.0.12 release.
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

REM     Flush the dictionary and library caches...
alter system flush shared_pool
/
REM     One more time for good measure...
alter system flush shared_pool
/

REM     Add VERSION column to IDL tables...
REM     If each table already has a VERSION column, an error is expected...
alter table idl_ub1$ add version number
/
drop index i_idl_ub11
/
create unique index i_idl_ub11 on idl_ub1$(obj#, part, version, piece#)
/
alter table idl_char$ add version number
/
drop index i_idl_char1
/
create unique index i_idl_char1 on idl_char$(obj#, part, version, piece#)
/
alter table idl_ub2$ add version number
/
drop index i_idl_ub21
/
create unique index i_idl_ub21 on idl_ub2$(obj#, part, version, piece#)
/
alter table idl_sb4$ add version number
/
drop index i_idl_sb41
/
create unique index i_idl_sb41 on idl_sb4$(obj#, part, version, piece#)
/
