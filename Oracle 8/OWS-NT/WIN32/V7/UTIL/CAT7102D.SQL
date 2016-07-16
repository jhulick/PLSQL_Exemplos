rem 
rem $Header: cat7102d.sql,v 1.4 1994/04/26 14:02:42 wmaimone Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      cat7102d.sql - Migrate 7.1.3 down to 7.1.2
Rem    DESCRIPTION
Rem      run this script right after starting up a 7.1.3 database with 7.1.2
REM      code for the first time.
Rem    RETURNS
Rem 
Rem    NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     wmaimone   04/22/94 -  fix merge error
Rem     wmaimone   04/08/94 -  merge changes from branch 1.1.710.2
Rem     agupta     03/28/94 -  merge changes from branch 1.1.710.1
Rem     wmaimone   03/16/94 -  invalidate plsql
Rem     agupta     01/20/94 -  Branch_for_patch
Rem     agupta     01/19/94 -  Creation

Rem
Rem Restore cache attributes on tables and clusters for parallel query
update tab$ set spare2 = 0
/
update clu$ set spare6 = 0
/

Rem
Rem Invalidate PL/SQL

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
