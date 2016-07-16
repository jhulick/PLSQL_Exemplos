rem 
rem $Header: cat712.sql,v 1.6 1992/11/25 14:58:59 RKOOI Stab $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      m711712.sql - Migrate 7.0.11 to 7.0.12
Rem    DESCRIPTION
Rem      This SQL script makes some schema modifications to migrate
Rem      a 7.0.11 database to a 7.0.12 database.
Rem    NOTES
Rem      RIGHT AFTER A 7.0.11 DATABASE IS STARTED UP USING A 7.0.12
Rem      RELEASE FOR THE FIRST TIME, RUN THIS SCRIPT (JUST ONCE)
Rem      WHILE CONNECTED TO SYS OR INTERNAL.
Rem    MODIFIED   (MM/DD/YY)
Rem     rkooi      11/25/92 -  add default value to argument$ 
Rem     kaghevli   11/24/92 -  change default limit for profile$ 
Rem     rkooi      11/17/92 -  change index for argument$ 
Rem     rkooi      11/13/92 -  fixup argument$ 
Rem     mmoore     11/01/92 -  length is 30 not 32 
Rem     glumpkin   10/20/92 -  Renamed from M711712.SQL 
Rem     mmoore     10/13/92 -  add argument$ 
Rem     jwijaya    10/07/92 -  comments 
Rem     jwijaya    09/17/92 -  make error$.sequence to have default value 
Rem     jwijaya    09/08/92 -  Creation 

REM
REM     THIS SCRIPT IS TO BE RUN ONCE RIGHT AFTER A 7.0.11 DATABASE IS
REM     STARTED UP FOR THE FIRST TIME USING ORACLE7 RELEASE 7.0.12.
REM     WHILE CONNECTED TO SYS OR INTERNAL.
REM

REM add column sequence to table error$
alter table error$ add sequence number default 0
/
update error$ set sequence = 0
/
alter table error$ modify sequence number not null
/
drop index i_error1
/
create index i_error1 on error$(obj#, sequence)
/

REM add argument$ to the dictionary
drop table argument$
/
create table argument$
( obj#           number not null,
  procedure$     varchar2(30),
  overload#      number not null,
  position       number not null,
  sequence#      number not null,
  level#         number not null,
  argument       varchar2(30),
  type           number not null,
  default#       number,
  in_out         number,
  length         number,
  precision      number,
  scale          number,
  radix          number,
  deflength      number,
  default$       long)
/
create unique index i_argument1 on 
  argument$(obj#, procedure$, overload#, sequence#)
/

REM change default limit for profile$
update profile$ set limit=0 where limit=-1 and type=0
/
