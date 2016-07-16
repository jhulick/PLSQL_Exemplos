rem 
rem $Header: cat7103.sql,v 1.2 1994/04/08 14:16:32 wmaimone Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      cat7103.sql - upgrade Oracle RDBMS from version 7.1.2 to 7.1.3
Rem    DESCRIPTION
Rem 
Rem    NOTES
Rem      Run this as INTERNAL.  Run it before installing catalog or pl/sql.
Rem      It is safe to run it on 7.1.2.
Rem    MODIFIED   (MM/DD/YY)
Rem     wmaimone   04/08/94 -  merge changes from branch 1.1.710.1
Rem     wmaimone   03/18/94 -  Branch_for_patch
Rem     wmaimone   03/18/94 -  rename from cat70103 (mod log preserved)
Rem     wmaimone   03/16/94 -  fixup audit tables
Rem     vraghuna   03/04/94 -  modify insertion into props table
Rem     thayes     03/03/94 -  New syns for compat seg
Rem     ltung      02/24/94 -  replace _TABLES and _CLUSTERS views
Rem     ltung      02/24/94 -  preserve CACHEing in tab$, clu$
Rem     cozbutun   02/10/94 -  fix the last change
Rem     vraghuna   02/10/94 -  add new row into props
Rem     cozbutun   02/10/94 -  change the index i_triggercol1
Rem     vraghuna   02/07/94 -  add expver for versioning support
Rem     rjenkins   02/07/94 -  adding unique index on rgroup
Rem     rjenkins   02/02/94 -  replace M IDEN with 30
Rem     vraghuna   01/31/94 -  bug 191751 - add expact
Rem     agupta     01/20/94 -  192948 - make *_extent in *_segments byte-based
Rem     rjenkins   01/13/94 -  adding rollback seg col to rgroup$
Rem     jcohen     01/04/94 - #(192450) add v$option table
Rem     jcohen     12/20/93 - #(191673) fix number fmt for user_tables,cluster
Rem     rjenkins   12/20/93 -  Branch_for_patch
Rem     rjenkins   12/17/93 -  Creation

rem 
rem  Job Queue
rem
drop table job$ cascade constraints
/
drop sequence jobseq
/
create sequence jobseq
  start with 1
  increment by 1
  minvalue 1
  maxvalue 999999999                        /* should be less than MAXSB4VAL */
  cache 20
  noorder
  cycle
/
create table job$
( job             number not null,                  /* identifier of the job */
  lowner          varchar2(30) not null,             /* logged in user */
  powner          varchar2(30) not null,                   /* security */
  cowner          varchar2(30) not null,                    /* parsing */
  last_date       date,                      /* when this job last succeeded */
  this_date       date,    /* when the current execute started, usually null */
  next_date       date not null,             /* when to execute the job next */
  total           number default 0 not null, /* total time spent on this job */
  interval        varchar2(200) not null,/* function for next next_date */
  failures        number,           /* number of failures since last success */
  flag            number default 0 not null,     /* 0x01, this job is broken */
  what            varchar2(2000),        /* PL/SQL text, what is the job */
  nlsenv          varchar2(2000),                      /* nls parameters */
  env             raw(32),                    /* other environment variables */
  cur_ses_label   mlslabel,      /* current session label for trusted oracle */
  clearance_hi    mlslabel,             /* clearance high for trusted oracle */
  clearance_lo    mlslabel,              /* clearance low for trusted oracle */
  charenv         varchar2(2000),                            /* not used */
  field1          number default 0)                              /* not used */
/
create unique index i_job_job on job$ (job)
/
create index i_job_next on job$ (next_date)
/
rem
rem  Refresh Groups
rem
drop table rgchild$ cascade constraints
/
drop table rgroup$ cascade constraints
/
drop cluster c_rg# including tables cascade constraints
/
drop sequence rgroupseq
/
create sequence rgroupseq
  start with 1
  increment by 1
  minvalue 1
  maxvalue 999999999                        /* should be less than MAXSB4VAL */
  cache 20
  noorder
  cycle
/
create cluster c_rg#
( refgroup        number)                            /* refresh group number */
/
create index i_rg# on cluster c_rg#
/
create table rgroup$
( refgroup        number,                         /* number of refresh group */
  owner           varchar2(30) not null,     /* owner of refresh group */
  name            varchar2(30) not null,      /* name of refresh group */
  flag            number default 0,        /* 0x01, destroy group when empty */
                                                 /* 0x02, do not push queues */
                                               /* 0x04, refresh after errors */
  rollback_seg    varchar2(30),                   /* rollback segment to use */
  field1          number default 0,
  job             number not null)  /* job in job$ for refreshing this group */
cluster c_rg# (refgroup)
/
create unique index i_rgroup on rgroup$ (owner, name)
/
create unique index i_rgref on rgroup$ (refgroup)
/
create index i_rgjob on rgroup$ (job)
/
create table rgchild$
( owner           varchar2(30) not null,             /* owner of child */
  name            varchar2(30) not null,              /* name of child */
  type            varchar2(30) default 'SNAPSHOT',   /* type of object */
  field1          number default 0,
  refgroup        number)                   /* refresh group the child is in */
cluster c_rg# (refgroup)
/
create unique index i_rgchild on rgchild$ (owner, name, type)
/
rem
rem  Drop User Cascade
rem
drop table duc$ cascade constraints
/
create table duc$
( owner           varchar2(30) not null,            /* procedure owner */
  pack            varchar2(30) not null,          /* procedure package */
  proc            varchar2(30) not null,             /* procedure name */
  field1          number default 0,
  operation       number not null,                    /* 1=drop user cascade */
  seq             number not null,            /* for ordering the procedures */
  com             varchar2(80))       /* comment on what this routine is for */
/
create unique index i_duc on duc$ (owner,pack,proc,operation)
/
rem
rem  Create refresh groups & jobs for all existing snapshots
rem
insert into rgroup$ (refgroup, owner, name, flag, job)
  select rownum, sowner, vname, 1, rownum from snap$
  where auto_date is not null or auto_fun is not null
/
insert into rgchild$ (owner, name, refgroup)
  select owner, name, refgroup from rgroup$
/
insert into job$ (job, lowner, powner, cowner, 
                  next_date, 
                  interval, 
                  what, 
                  nlsenv, env)
  select r.refgroup, r.owner, r.owner, r.owner,
         nvl(s.auto_date,to_date('4000-01-01','YYYY-MM-DD')),
         nvl(s.auto_fun,'null'),
         'dbms_refresh.refresh(''"'||r.owner||'"."'||r.name||'"'');',
         'SQL_TRACE=FALSE', hextoraw('0102000000000000')
    from snap$ s, rgroup$ r 
    where r.owner = s.sowner and r.name = s.vname;
/
rem
rem  maintain CACHE attribute for tables and clusters
rem
update tab$ set spare2 = 65536 where spare2 > 0
/
update clu$ set spare6 = 65536 where spare6 > 0
/

Rem
Rem expact table for Export actions
Rem
drop table expact$
/
create table expact$
( owner varchar2(30) not null,                             /* owner of table */
  name  varchar2(30) not null,                              /* name of table */
  func_schema varchar2(30) not null,             /* schema func is run under */
  func_package  varchar2(30) not null,                       /* package name */
  func_proc  varchar2(30) not null,                        /* procedure name */
  code  number not null,                            /* PRETABLE OR POSTTABLE */
  callorder number)
/
Rem
Rem The index i_triggercol1 on triggercol$ changed (If you run this file
Rem on a 7.1.3 or later database, the following 2 statements may fail. That
Rem is not a problem.
Rem
create index i_triggercol on triggercol$(obj#, col#, type, position)
/
drop index i_triggercol1
/

Rem
Rem  Fix audit option map

delete stmt_audit_option_map
where 
 option# in (18,34,53,55,56,70,100,145,170,171)
 or option# between 176 and 193
/
update stmt_audit_option_map set name = 'CREATE SNAPSHOT' where option#=172
/
update stmt_audit_option_map set name = 'WRITEDOWN' where option#=197
/
update stmt_audit_option_map set name = 'READUP' where option#=198
/
insert into STMT_AUDIT_OPTION_MAP values ( 83, 'SYSDBA')
/
insert into STMT_AUDIT_OPTION_MAP values ( 84, 'SYSOPER')
/
insert into STMT_AUDIT_OPTION_MAP values (135, 'ALTER DATABASE')
/
insert into STMT_AUDIT_OPTION_MAP values (138, 'FORCE TRANSACTION')
/
insert into STMT_AUDIT_OPTION_MAP values (139, 'FORCE ANY TRANSACTION')
/
insert into STMT_AUDIT_OPTION_MAP values (167, 'GRANT ANY PRIVILEGE')
/
drop index i_objauth2
/
create index i_objauth2 on objauth$(grantee#, obj#, col#)
/


Rem
Rem Add versioning support for export
Rem
insert into props$ 
select 'EXPORT_VIEWS_VERSION', '1', 'Export views revision #' from dual
where not exists
  (select 'x' from props$ where name = 'EXPORT_VIEWS_VERSION')
/
