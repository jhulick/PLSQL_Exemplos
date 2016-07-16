rem 
rem $Header: utlchain.sql,v 1.1 1992/10/19 15:17:26 GLUMPKIN Stab $ 
rem 
Rem Copyright (c) 1990 by Oracle Corporation
Rem NAME
REM    UTLCHAIN.SQL
Rem  FUNCTION
Rem    Creates the default table for storing the output of the
Rem    analyze list chained rows command
Rem  NOTES
Rem  MODIFIED
Rem     glumpkin   10/19/92 -  Renamed from CHAINROW.SQL 
Rem     ggatlin    03/09/92 -  add set echo on 
Rem     rlim       04/29/91 -         change char to varchar2 
Rem   Klein      01/10/91 - add owner name for chained rows
Rem   Klein      12/04/90 - Creation
Rem
set echo on

create table CHAINED_ROWS (
  owner_name    varchar2(30),
  table_name    varchar2(30),
  cluster_name  varchar2(30),
  head_rowid    rowid,
  timestamp     date
);

