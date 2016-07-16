rem 
rem $Header: cat70103.sql,v 1.10 1994/04/08 16:45:51 vraghuna Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      cat70103.sql - upgrade Oracle RDBMS from version 7.1.2 to 7.1.3
Rem    DESCRIPTION
Rem 
Rem    NOTES
Rem      Run this as INTERNAL.  Run it before installing catalog or pl/sql.
Rem      It is safe to run it on 7.1.2.
Rem    MODIFIED   (MM/DD/YY)
Rem     vraghuna   04/08/94 -  merge forward expact and expver changes
Rem     jcohen     04/07/94 -  merge changes from branch 1.1.710.3
Rem     jcohen     04/07/94 -  merge changes from branch 1.1.710.2
Rem     agupta     03/28/94 -  merge changes from branch 1.1.710.5
Rem     thayes     03/22/94 -  merge changes from branch 1.1.710.14
Rem     rjenkins   03/09/94 -  merge changes from branch 1.1.710.8
Rem     rjenkins   03/09/94 -  merge changes from branch 1.1.710.7
Rem     rjenkins   03/09/94 -  merge changes from branch 1.1.710.4
Rem     rjenkins   01/19/94 -  merge changes from branch 1.1.710.1
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
remark
remark  FAMILY "CLUSTERS"
remark  CREATE CLUSTER parameters.
remark  This family has no "ALL" member.
remark
create or replace view USER_CLUSTERS
    (CLUSTER_NAME, TABLESPACE_NAME,
     PCT_FREE, PCT_USED, KEY_SIZE,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     AVG_BLOCKS_PER_KEY,
     CLUSTER_TYPE, FUNCTION, HASHKEYS,
     DEGREE, INSTANCES, CACHE)
as select o.name, ts.name,
          c.pctfree$, c.pctused$, c.size$,c.initrans,c.maxtrans,
          s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
          s.minexts, s.maxexts, s.extpct,
          c.spare4, decode(c.hashkeys, 0, 'INDEX', 'HASH'),
          decode(c.hashkeys, 0, NULL,
                 decode(c.func, 0, 'COLUMN', 1, 'DEFAULT', NULL)),
          c.hashkeys,
          lpad(decode(c.spare5, 0, '1', 1, 'DEFAULT', to_char(c.spare5)), 10),
          lpad(decode(mod(c.spare6, 65536), 0, '1', 1, 'DEFAULT',
          to_char(mod(c.spare6, 65536))), 10),
          lpad(decode(floor(c.spare6 / 65536), 0, 'N', 1, 'Y', '?'), 5)
from sys.ts$ ts, sys.seg$ s, sys.clu$ c, sys.obj$ o
where o.owner# = userenv('SCHEMAID')
  and o.obj# = c.obj#
  and c.ts# = ts.ts# 
  and c.ts# = s.ts#
  and c.file# = s.file#
  and c.block# = s.block#
/
comment on table USER_CLUSTERS is
'Descriptions of user''s own clusters'
/
comment on column USER_CLUSTERS.CLUSTER_NAME is
'Name of the cluster'
/
comment on column USER_CLUSTERS.TABLESPACE_NAME is
'Name of the tablespace containing the cluster'
/
comment on column USER_CLUSTERS.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column USER_CLUSTERS.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column USER_CLUSTERS.KEY_SIZE is
'Estimated size of cluster key plus associated rows'
/
comment on column USER_CLUSTERS.INI_TRANS is
'Initial number of transactions'
/
comment on column USER_CLUSTERS.MAX_TRANS is
'Maximum number of transactions'
/
comment on column USER_CLUSTERS.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column USER_CLUSTERS.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column USER_CLUSTERS.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column USER_CLUSTERS.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column USER_CLUSTERS.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column USER_CLUSTERS.AVG_BLOCKS_PER_KEY is
'Average number of blocks containing rows with a given cluster key'
/
comment on column USER_CLUSTERS.CLUSTER_TYPE is
'Type of cluster: b-tree index or hash'
/
comment on column USER_CLUSTERS.FUNCTION is
'If a hash cluster, the hash function'
/
comment on column USER_CLUSTERS.HASHKEYS is
'If a hash cluster, the number of hash keys (hash buckets)'
/
comment on column USER_CLUSTERS.DEGREE is
'The number of threads per instance for scanning the cluster'
/
comment on column USER_CLUSTERS.INSTANCES is
'The number of instances across which the cluster is to be scanned'
/
comment on column USER_CLUSTERS.CACHE is
'Whether the cluster is to be cached in the buffer cache'
/
drop public synonym USER_CLUSTERS
/
create public synonym USER_CLUSTERS for USER_CLUSTERS
/
drop public synonym CLU
/
create public synonym CLU for USER_CLUSTERS
/
grant select on USER_CLUSTERS to PUBLIC with grant option
/
create or replace view DBA_CLUSTERS
    (OWNER, CLUSTER_NAME, TABLESPACE_NAME,
     PCT_FREE, PCT_USED, KEY_SIZE,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     AVG_BLOCKS_PER_KEY,
     CLUSTER_TYPE, FUNCTION, HASHKEYS,
     DEGREE, INSTANCES, CACHE)
as select u.name, o.name, ts.name,
          c.pctfree$, c.pctused$, c.size$,c.initrans,c.maxtrans,
          s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
          s.minexts, s.maxexts, s.extpct,
          c.spare4, decode(c.hashkeys, 0, 'INDEX', 'HASH'),
          decode(c.hashkeys, 0, NULL,
                 decode(c.func, 0, 'COLUMN', 1, 'DEFAULT', NULL)),
          c.hashkeys,
          lpad(decode(c.spare5, 0, '1', 1, 'DEFAULT', to_char(c.spare5)), 10),
          lpad(decode(mod(c.spare6, 65536), 0, '1', 1, 'DEFAULT',
          to_char(mod(c.spare6, 65536))), 10),
          lpad(decode(floor(c.spare6 / 65536), 0, 'N', 1, 'Y', '?'), 5)
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.clu$ c, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.ts# = ts.ts#
  and c.ts# = s.ts#
  and c.file# = s.file#
  and c.block# = s.block#
/
comment on table DBA_CLUSTERS is
'Description of all clusters in the database'
/
comment on column DBA_CLUSTERS.OWNER is
'Owner of the cluster'
/
comment on column DBA_CLUSTERS.CLUSTER_NAME is
'Name of the cluster'
/
comment on column DBA_CLUSTERS.TABLESPACE_NAME is
'Name of the tablespace containing the cluster'
/
comment on column DBA_CLUSTERS.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column DBA_CLUSTERS.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column DBA_CLUSTERS.KEY_SIZE is
'Estimated size of cluster key plus associated rows'
/
comment on column DBA_CLUSTERS.INI_TRANS is
'Initial number of transactions'
/
comment on column DBA_CLUSTERS.MAX_TRANS is
'Maximum number of transactions'
/
comment on column DBA_CLUSTERS.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column DBA_CLUSTERS.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column DBA_CLUSTERS.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column DBA_CLUSTERS.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column DBA_CLUSTERS.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column DBA_CLUSTERS.AVG_BLOCKS_PER_KEY is
'Average number of blocks containing rows with a given cluster key'
/
comment on column DBA_CLUSTERS.CLUSTER_TYPE is
'Type of cluster: b-tree index or hash'
/
comment on column DBA_CLUSTERS.FUNCTION is
'If a hash cluster, the hash function'
/
comment on column DBA_CLUSTERS.HASHKEYS is
'If a hash cluster, the number of hash keys (hash buckets)'
/
comment on column DBA_CLUSTERS.DEGREE is
'The number of threads per instance for scanning the cluster'
/
comment on column DBA_CLUSTERS.INSTANCES is
'The number of instances across which the cluster is to be scanned'
/
comment on column DBA_CLUSTERS.CACHE is
'Whether the cluster is to be cached in the buffer cache'
/
remark
remark  FAMILY "TABLES"
remark  CREATE TABLE parameters.
remark
create or replace view USER_TABLES
    (TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN,
     DEGREE, INSTANCES, CACHE)
as
select o.name, ts.name, co.name,
       t.pctfree$, t.pctused$,
       t.initrans, t.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,
       decode(t.modified, 0, 'Y', 1, 'N', '?'),
       t.rowcnt, t.blkcnt, t.empcnt, t.avgspc, t.chncnt, t.avgrln,
       lpad(decode(t.spare1, 0, '1', 1, 'DEFAULT', to_char(t.spare1)), 10),
       lpad(decode(mod(t.spare2, 65536), 0, '1', 1, 'DEFAULT',
       to_char(mod(t.spare2, 65536))), 10),
       lpad(decode(floor(t.spare2 / 65536), 0, 'N', 1, 'Y', '?'), 5)
from sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o
where o.owner# = userenv('SCHEMAID')
  and o.obj# = t.obj#
  and t.clu# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
/
comment on table USER_TABLES is
'Description of the user''s own tables'
/
comment on column USER_TABLES.TABLE_NAME is
'Name of the table'
/
comment on column USER_TABLES.TABLESPACE_NAME is
'Name of the tablespace containing the table'
/
comment on column USER_TABLES.CLUSTER_NAME is
'Name of the cluster, if any, to which the table belongs'
/
comment on column USER_TABLES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column USER_TABLES.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column USER_TABLES.INI_TRANS is
'Initial number of transactions'
/
comment on column USER_TABLES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column USER_TABLES.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column USER_TABLES.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column USER_TABLES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column USER_TABLES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column USER_TABLES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column USER_TABLES.BACKED_UP is
'Has table been backed up since last modification?'
/
comment on column USER_TABLES.NUM_ROWS is
'The number of rows in the table'
/
comment on column USER_TABLES.BLOCKS is
'The number of used blocks in the table'
/
comment on column USER_TABLES.EMPTY_BLOCKS is
'The number of empty (never used) blocks in the table'
/
comment on column USER_TABLES.AVG_SPACE is
'The average available free space in the table'
/
comment on column USER_TABLES.CHAIN_CNT is
'The number of chained rows in the table'
/
comment on column USER_TABLES.AVG_ROW_LEN is
'The average row length, including row overhead'
/
comment on column USER_TABLES.DEGREE is
'The number of threads per instance for scanning the table'
/
comment on column USER_TABLES.INSTANCES is
'The number of instances across which the table is to be scanned'
/
comment on column USER_TABLES.CACHE is
'Whether the table is to be cached in the buffer cache'
/
drop public synonym USER_TABLES
/
create public synonym USER_TABLES for USER_TABLES
/
drop public synonym TABS
/
create public synonym TABS for USER_TABLES
/
grant select on USER_TABLES to PUBLIC with grant option
/
create or replace view ALL_TABLES
    (OWNER, TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN,
     DEGREE, INSTANCES, CACHE)
as
select u.name, o.name, ts.name, co.name,
       t.pctfree$, t.pctused$,
       t.initrans, t.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,
       decode(t.modified, 0, 'Y', 1, 'N', '?'),
       t.rowcnt, t.blkcnt, t.empcnt, t.avgspc, t.chncnt, t.avgrln,
       lpad(decode(t.spare1, 0, '1', 1, 'DEFAULT', to_char(t.spare1)), 10),
       lpad(decode(mod(t.spare2, 65536), 0, '1', 1, 'DEFAULT',
       to_char(mod(t.spare2, 65536))), 10),
       lpad(decode(floor(t.spare2 / 65536), 0, 'N', 1, 'Y', '?'), 5)
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.clu# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               ) 
            )
       or /* user has system privileges */
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
      )
/
comment on table ALL_TABLES is
'Description of tables accessible to the user'
/
comment on column ALL_TABLES.OWNER is
'Owner of the table'
/
comment on column ALL_TABLES.TABLE_NAME is
'Name of the table'
/
comment on column ALL_TABLES.TABLESPACE_NAME is
'Name of the tablespace containing the table'
/
comment on column ALL_TABLES.CLUSTER_NAME is
'Name of the cluster, if any, to which the table belongs'
/
comment on column ALL_TABLES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column ALL_TABLES.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column ALL_TABLES.INI_TRANS is
'Initial number of transactions'
/
comment on column ALL_TABLES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column ALL_TABLES.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column ALL_TABLES.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column ALL_TABLES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column ALL_TABLES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column ALL_TABLES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column ALL_TABLES.BACKED_UP is
'Has table been backed up since last modification?'
/
comment on column ALL_TABLES.NUM_ROWS is
'The number of rows in the table'
/
comment on column ALL_TABLES.BLOCKS is
'The number of used blocks in the table'
/
comment on column ALL_TABLES.EMPTY_BLOCKS is
'The number of empty (never used) blocks in the table'
/
comment on column ALL_TABLES.AVG_SPACE is
'The average available free space in the table'
/
comment on column ALL_TABLES.CHAIN_CNT is
'The number of chained rows in the table'
/
comment on column ALL_TABLES.AVG_ROW_LEN is
'The average row length, including row overhead'
/
comment on column ALL_TABLES.DEGREE is
'The number of threads per instance for scanning the table'
/
comment on column ALL_TABLES.INSTANCES is
'The number of instances across which the table is to be scanned'
/
comment on column ALL_TABLES.CACHE is
'Whether the table is to be cached in the buffer cache'
/
drop public synonym ALL_TABLES
/
create public synonym ALL_TABLES for ALL_TABLES
/
grant select on ALL_TABLES to PUBLIC with grant option
/
create or replace view DBA_TABLES
    (OWNER, TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN,
     DEGREE, INSTANCES, CACHE)
as
select u.name, o.name, ts.name, co.name,
       t.pctfree$, t.pctused$,
       t.initrans, t.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,
       decode(t.modified, 0, 'Y', 1, 'N', '?'),
       t.rowcnt, t.blkcnt, t.empcnt, t.avgspc, t.chncnt, t.avgrln,
       lpad(decode(t.spare1, 0, '1', 1, 'DEFAULT', to_char(t.spare1)), 10),
       lpad(decode(mod(t.spare2, 65536), 0, '1', 1, 'DEFAULT',
       to_char(mod(t.spare2, 65536))), 10),
       lpad(decode(floor(t.spare2 / 65536), 0, 'N', 1, 'Y', '?'), 5)
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.clu# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
/
comment on table DBA_TABLES is
'Description of all tables in the database'
/
comment on column DBA_TABLES.OWNER is
'Owner of the table'
/
comment on column DBA_TABLES.TABLE_NAME is
'Name of the table'
/
comment on column DBA_TABLES.TABLESPACE_NAME is
'Name of the tablespace containing the table'
/
comment on column DBA_TABLES.CLUSTER_NAME is
'Name of the cluster, if any, to which the table belongs'
/
comment on column DBA_TABLES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column DBA_TABLES.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column DBA_TABLES.INI_TRANS is
'Initial number of transactions'
/
comment on column DBA_TABLES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column DBA_TABLES.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column DBA_TABLES.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column DBA_TABLES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column DBA_TABLES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column DBA_TABLES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column DBA_TABLES.BACKED_UP is
'Has table been backed up since last modification?'
/
comment on column DBA_TABLES.NUM_ROWS is
'The number of rows in the table'
/
comment on column DBA_TABLES.BLOCKS is
'The number of used blocks in the table'
/
comment on column DBA_TABLES.EMPTY_BLOCKS is
'The number of empty (never used) blocks in the table'
/
comment on column DBA_TABLES.AVG_SPACE is
'The average available free space in the table'
/
comment on column DBA_TABLES.CHAIN_CNT is
'The number of chained rows in the table'
/
comment on column DBA_TABLES.AVG_ROW_LEN is
'The average row length, including row overhead'
/
comment on column DBA_TABLES.DEGREE is
'The number of threads per instance for scanning the table'
/
comment on column DBA_TABLES.INSTANCES is
'The number of instances across which the table is to be scanned'
/
comment on column DBA_TABLES.CACHE is
'Whether the table is to be cached in the buffer cache'
/
rem
rem  v$option
rem
create or replace view v_$option as select * from v$option;
drop public synonym v$option;
create public synonym v$option for v_$option;
grant select on v_$option to public;

Remark replace USER_SEGMENTS and DBA_SEGMENTS with versions in which 
Remark INITIAL_EXTENT and NEXT_EXTENT are in units of bytes, not blocks
create or replace view USER_SEGMENTS
    (SEGMENT_NAME,
     SEGMENT_TYPE,
     TABLESPACE_NAME,
     BYTES, BLOCKS, EXTENTS, 
     INITIAL_EXTENT, NEXT_EXTENT, 
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, FREELISTS, FREELIST_GROUPS)
as
select o.name,
       so.object_type,
       ts.name,
       s.blocks * ts.blocksize, s.blocks, s.extents, 
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.obj$ o, sys.ts$ ts, sys.sys_objects so, sys.seg$ s
where s.file# = so.header_file
  and s.block# = so.header_block
  and s.ts# = ts.ts#
  and o.obj# = so.object_id
  and o.owner# = userenv('SCHEMAID')
  and s.type = so.segment_type_id
  and o.type = so.object_type_id
union all
select un.name,
       'ROLLBACK',
       ts.name,
       s.blocks * ts.blocksize, s.blocks, s.extents,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.ts$ ts, sys.undo$ un, sys.seg$ s
where s.file# = un.file#
  and s.block# = un.block#
  and s.ts# = ts.ts#
  and s.user# = userenv('SCHEMAID')
  and s.type = 1
  and un.status$ != 1  
union all
select to_char(s.file#) || '.' || to_char(s.block#),
       decode(s.type, 2, 'DEFERRED ROLLBACK', 3, 'TEMPORARY',
                      4, 'CACHE', 'UNDEFINED'),
       ts.name,
       s.blocks * ts.blocksize, s.blocks, s.extents,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.ts$ ts, sys.seg$ s
where s.ts# = ts.ts#
  and s.user# = userenv('SCHEMAID')
  and s.type not in (1, 5, 6)
/
comment on table USER_SEGMENTS is
'Storage allocated for all database segments'
/
comment on column USER_SEGMENTS.SEGMENT_NAME is
'Name, if any, of the segment'
/
comment on column USER_SEGMENTS.SEGMENT_TYPE is
'Type of segment:  "TABLE", "CLUSTER", "INDEX", "ROLLBACK",
"DEFERRED ROLLBACK", "TEMPORARY", or "CACHE"'
/
comment on column USER_SEGMENTS.TABLESPACE_NAME is
'Name of the tablespace containing the segment'
/
comment on column USER_SEGMENTS.BYTES is
'Size, in bytes, of the segment'
/
comment on column USER_SEGMENTS.BLOCKS is
'Size, in Oracle blocks, of the segment'
/
comment on column USER_SEGMENTS.EXTENTS is
'Number of extents allocated to the segment'
/
comment on column USER_SEGMENTS.INITIAL_EXTENT is
'Size, in bytes, of the initial extent of the segment'
/
comment on column USER_SEGMENTS.NEXT_EXTENT is
'Size, in bytes, of the next extent to be allocated to the segment' 
/
comment on column USER_SEGMENTS.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column USER_SEGMENTS.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column USER_SEGMENTS.PCT_INCREASE is
'Percent by which to increase the size of the next extent to be allocated'
/
comment on column USER_SEGMENTS.FREELISTS is
'Number of process freelists allocated to this segment'
/
comment on column USER_SEGMENTS.FREELIST_GROUPS is
'Number of freelist groups allocated to this segment'
/
drop public synonym USER_SEGMENTS
/
create public synonym USER_SEGMENTS for USER_SEGMENTS
/
grant select on USER_SEGMENTS to PUBLIC with grant option
/
create or replace view DBA_SEGMENTS
    (OWNER, SEGMENT_NAME,
     SEGMENT_TYPE,
     TABLESPACE_NAME,
     HEADER_FILE, HEADER_BLOCK,
     BYTES, BLOCKS, EXTENTS, 
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, FREELISTS, FREELIST_GROUPS)
as
select u.name, o.name,
       so.object_type,
       ts.name,
       s.file#, s.block#,
       s.blocks * ts.blocksize, s.blocks, s.extents, 
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.user$ u, sys.obj$ o, sys.ts$ ts, sys.sys_objects so, sys.seg$ s
where s.file# = so.header_file
  and s.block# = so.header_block
  and s.ts# = ts.ts#
  and o.obj# = so.object_id
  and o.owner# = u.user#
  and s.type = so.segment_type_id
  and o.type = so.object_type_id
union all
select u.name, un.name,
       'ROLLBACK', ts.name, s.file#, s.block#,
       s.blocks * ts.blocksize, s.blocks, s.extents,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.user$ u, sys.ts$ ts, sys.undo$ un, sys.seg$ s
where s.file# = un.file#
  and s.block# = un.block#
  and s.ts# = ts.ts#
  and s.user# = u.user#
  and s.type = 1
  and un.status$ != 1
union all
select u.name, to_char(s.file#) || '.' || to_char(s.block#),
       decode(s.type, 2, 'DEFERRED ROLLBACK', 3, 'TEMPORARY',
                      4, 'CACHE', 'UNDEFINED'),
       ts.name,
       s.file#, s.block#,
       s.blocks * ts.blocksize, s.blocks, s.extents,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize, s.minexts, 
       s.maxexts, s.extpct,
       decode(s.lists, 0, 1, s.lists), decode(s.groups, 0, 1, s.groups)
from sys.user$ u, sys.ts$ ts, sys.seg$ s
where s.ts# = ts.ts#
  and s.user# = u.user#
  and s.type not in (1, 5, 6)
/
comment on table DBA_SEGMENTS is
'Storage allocated for all database segments'
/
comment on column DBA_SEGMENTS.OWNER is
'Username of the segment owner'
/
comment on column DBA_SEGMENTS.SEGMENT_NAME is
'Name, if any, of the segment'
/
comment on column DBA_SEGMENTS.SEGMENT_TYPE is
'Type of segment:  "TABLE", "CLUSTER", "INDEX", "ROLLBACK",
"DEFERRED ROLLBACK", "TEMPORARY", or "CACHE"'
/
comment on column DBA_SEGMENTS.TABLESPACE_NAME is
'Name of the tablespace containing the segment'
/
comment on column DBA_SEGMENTS.HEADER_FILE is
'ID of the file containing the segment header'
/
comment on column DBA_SEGMENTS.HEADER_BLOCK is
'ID of the block containing the segment header'
/
comment on column DBA_SEGMENTS.BYTES is
'Size, in bytes, of the segment'
/
comment on column DBA_SEGMENTS.BLOCKS is
'Size, in Oracle blocks, of the segment'
/
comment on column DBA_SEGMENTS.EXTENTS is
'Number of extents allocated to the segment'
/
comment on column DBA_SEGMENTS.INITIAL_EXTENT is
'Size, in bytes, of the initial extent of the segment'
/
comment on column DBA_SEGMENTS.NEXT_EXTENT is
'Size, in bytes, of the next extent to be allocated to the segment' 
/
comment on column DBA_SEGMENTS.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column DBA_SEGMENTS.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column DBA_SEGMENTS.PCT_INCREASE is
'Percent by which to increase the size of the next extent to be allocated'
/
comment on column DBA_SEGMENTS.FREELISTS is
'Number of process freelists allocated in this segment'
/
comment on column DBA_SEGMENTS.FREELIST_GROUPS is
'Number of freelist groups allocated in this segment'
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

create or replace view v_$compatibility as
  select * from v$compatibility;
drop public synonym v$compatibility;
create public synonym v$compatibility for v_$compatibility;

create or replace view v_$compatseg as
  select * from v$compatseg;
drop public synonym v$compatseg;
create public synonym v$compatseg for v_$compatseg;

remark
remark  FAMILY "CLUSTERS"
remark  CREATE CLUSTER parameters.
remark  This family has no "ALL" member.
remark
create or replace view USER_CLUSTERS
    (CLUSTER_NAME, TABLESPACE_NAME,
     PCT_FREE, PCT_USED, KEY_SIZE,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     AVG_BLOCKS_PER_KEY,
     CLUSTER_TYPE, FUNCTION, HASHKEYS, PARALLEL, CACHE)
as select o.name, ts.name,
          c.pctfree$, c.pctused$, c.size$,c.initrans,c.maxtrans,
          s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
          s.minexts, s.maxexts, s.extpct,
          c.spare4, decode(c.hashkeys, 0, 'INDEX', 'HASH'),
          decode(c.hashkeys, 0, NULL,
                 decode(c.func, 0, 'COLUMN', 1, 'DEFAULT', NULL)),
          c.hashkeys,
          decode(c.spare5, 0, 'N', 1, 'Y', to_char(c.spare5, '99999')),
          decode(c.spare6, 0, 'N', 1, 'Y',
                 'PARTITIONS '||ltrim(to_char(c.spare6, '99999')))
from sys.ts$ ts, sys.seg$ s, sys.clu$ c, sys.obj$ o
where o.owner# = userenv('SCHEMAID')
  and o.obj# = c.obj#
  and c.ts# = ts.ts# 
  and c.ts# = s.ts#
  and c.file# = s.file#
  and c.block# = s.block#
/
comment on table USER_CLUSTERS is
'Descriptions of user''s own clusters'
/
comment on column USER_CLUSTERS.CLUSTER_NAME is
'Name of the cluster'
/
comment on column USER_CLUSTERS.TABLESPACE_NAME is
'Name of the tablespace containing the cluster'
/
comment on column USER_CLUSTERS.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column USER_CLUSTERS.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column USER_CLUSTERS.KEY_SIZE is
'Estimated size of cluster key plus associated rows'
/
comment on column USER_CLUSTERS.INI_TRANS is
'Initial number of transactions'
/
comment on column USER_CLUSTERS.MAX_TRANS is
'Maximum number of transactions'
/
comment on column USER_CLUSTERS.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column USER_CLUSTERS.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column USER_CLUSTERS.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column USER_CLUSTERS.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column USER_CLUSTERS.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column USER_CLUSTERS.AVG_BLOCKS_PER_KEY is
'Average number of blocks containing rows with a given cluster key'
/
comment on column USER_CLUSTERS.CLUSTER_TYPE is
'Type of cluster: b-tree index or hash'
/
comment on column USER_CLUSTERS.FUNCTION is
'If a hash cluster, the hash function'
/
comment on column USER_CLUSTERS.HASHKEYS is
'If a hash cluster, the number of hash keys (hash buckets)'
/
comment on column USER_CLUSTERS.PARALLEL is
'The degree of parallelism assigned to the cluster'
/
comment on column USER_CLUSTERS.CACHE is
'The caching parameter associated with the cluster'
/
drop public synonym USER_CLUSTERS
/
create public synonym USER_CLUSTERS for USER_CLUSTERS
/
drop public synonym CLU
/
create public synonym CLU for USER_CLUSTERS
/
grant select on USER_CLUSTERS to PUBLIC with grant option
/
create or replace view DBA_CLUSTERS
    (OWNER, CLUSTER_NAME, TABLESPACE_NAME,
     PCT_FREE, PCT_USED, KEY_SIZE,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     AVG_BLOCKS_PER_KEY,
     CLUSTER_TYPE, FUNCTION, HASHKEYS, PARALLEL, CACHE)
as select u.name, o.name, ts.name,
          c.pctfree$, c.pctused$, c.size$,c.initrans,c.maxtrans,
          s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
          s.minexts, s.maxexts, s.extpct,
          c.spare4, decode(c.hashkeys, 0, 'INDEX', 'HASH'),
          decode(c.hashkeys, 0, NULL,
                 decode(c.func, 0, 'COLUMN', 1, 'DEFAULT', NULL)),
          c.hashkeys,
          decode(c.spare5, 0, 'N', 1, 'Y', to_char(c.spare5, '99999')),
          decode(c.spare6, 0, 'N', 1, 'Y',
                 'PARTITIONS '||ltrim(to_char(c.spare6, '99999')))
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.clu$ c, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.ts# = ts.ts#
  and c.ts# = s.ts#
  and c.file# = s.file#
  and c.block# = s.block#
/
comment on table DBA_CLUSTERS is
'Description of all clusters in the database'
/
comment on column DBA_CLUSTERS.OWNER is
'Owner of the cluster'
/
comment on column DBA_CLUSTERS.CLUSTER_NAME is
'Name of the cluster'
/
comment on column DBA_CLUSTERS.TABLESPACE_NAME is
'Name of the tablespace containing the cluster'
/
comment on column DBA_CLUSTERS.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column DBA_CLUSTERS.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column DBA_CLUSTERS.KEY_SIZE is
'Estimated size of cluster key plus associated rows'
/
comment on column DBA_CLUSTERS.INI_TRANS is
'Initial number of transactions'
/
comment on column DBA_CLUSTERS.MAX_TRANS is
'Maximum number of transactions'
/
comment on column DBA_CLUSTERS.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column DBA_CLUSTERS.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column DBA_CLUSTERS.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column DBA_CLUSTERS.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column DBA_CLUSTERS.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column DBA_CLUSTERS.AVG_BLOCKS_PER_KEY is
'Average number of blocks containing rows with a given cluster key'
/
comment on column DBA_CLUSTERS.CLUSTER_TYPE is
'Type of cluster: b-tree index or hash'
/
comment on column DBA_CLUSTERS.FUNCTION is
'If a hash cluster, the hash function'
/
comment on column DBA_CLUSTERS.HASHKEYS is
'If a hash cluster, the number of hash keys (hash buckets)'
/
comment on column DBA_CLUSTERS.PARALLEL is
'The degree of parallelism assigned to the cluster'
/
comment on column DBA_CLUSTERS.CACHE is
'The caching parameter associated with the cluster'
/
remark
remark  FAMILY "TABLES"
remark  CREATE TABLE parameters.
remark
create or replace view USER_TABLES
    (TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN, PARALLEL, CACHE)
as
select o.name, ts.name, co.name,
       t.pctfree$, t.pctused$,
       t.initrans, t.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,
       decode(t.modified, 0, 'Y', 1, 'N', '?'),
       t.rowcnt, t.blkcnt, t.empcnt, t.avgspc, t.chncnt, t.avgrln,
       decode(t.spare1, 0, 'N', 1, 'Y', to_char(t.spare1, '99999')),
       decode(t.spare2, 0, 'N', 1, 'Y',
              'PARTITIONS '||ltrim(to_char(t.spare2, '99999')))
from sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o
where o.owner# = userenv('SCHEMAID')
  and o.obj# = t.obj#
  and t.clu# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
/
comment on table USER_TABLES is
'Description of the user''s own tables'
/
comment on column USER_TABLES.TABLE_NAME is
'Name of the table'
/
comment on column USER_TABLES.TABLESPACE_NAME is
'Name of the tablespace containing the table'
/
comment on column USER_TABLES.CLUSTER_NAME is
'Name of the cluster, if any, to which the table belongs'
/
comment on column USER_TABLES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column USER_TABLES.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column USER_TABLES.INI_TRANS is
'Initial number of transactions'
/
comment on column USER_TABLES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column USER_TABLES.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column USER_TABLES.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column USER_TABLES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column USER_TABLES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column USER_TABLES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column USER_TABLES.BACKED_UP is
'Has table been backed up since last modification?'
/
comment on column USER_TABLES.NUM_ROWS is
'The number of rows in the table'
/
comment on column USER_TABLES.BLOCKS is
'The number of used blocks in the table'
/
comment on column USER_TABLES.EMPTY_BLOCKS is
'The number of empty (never used) blocks in the table'
/
comment on column USER_TABLES.AVG_SPACE is
'The average available free space in the table'
/
comment on column USER_TABLES.CHAIN_CNT is
'The number of chained rows in the table'
/
comment on column USER_TABLES.AVG_ROW_LEN is
'The average row length, including row overhead'
/
comment on column USER_TABLES.PARALLEL is
'The degree of parallelism assigned to the table'
/
comment on column USER_TABLES.CACHE is
'The caching parameter associated with the table'
/
drop public synonym USER_TABLES
/
create public synonym USER_TABLES for USER_TABLES
/
drop public synonym TABS
/
create public synonym TABS for USER_TABLES
/
grant select on USER_TABLES to PUBLIC with grant option
/
create or replace view ALL_TABLES
    (OWNER, TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN, PARALLEL, CACHE)
as
select u.name, o.name, ts.name, co.name,
       t.pctfree$, t.pctused$,
       t.initrans, t.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,
       decode(t.modified, 0, 'Y', 1, 'N', '?'),
       t.rowcnt, t.blkcnt, t.empcnt, t.avgspc, t.chncnt, t.avgrln,
       decode(t.spare1, 0, 'N', 1, 'Y', to_char(t.spare1, '99999')),
       decode(t.spare2, 0, 'N', 1, 'Y',
              'PARTITIONS '||ltrim(to_char(t.spare2, '99999')))
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.clu# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               ) 
            )
       or /* user has system privileges */
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
      )
/
comment on table ALL_TABLES is
'Description of tables accessible to the user'
/
comment on column ALL_TABLES.OWNER is
'Owner of the table'
/
comment on column ALL_TABLES.TABLE_NAME is
'Name of the table'
/
comment on column ALL_TABLES.TABLESPACE_NAME is
'Name of the tablespace containing the table'
/
comment on column ALL_TABLES.CLUSTER_NAME is
'Name of the cluster, if any, to which the table belongs'
/
comment on column ALL_TABLES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column ALL_TABLES.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column ALL_TABLES.INI_TRANS is
'Initial number of transactions'
/
comment on column ALL_TABLES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column ALL_TABLES.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column ALL_TABLES.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column ALL_TABLES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column ALL_TABLES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column ALL_TABLES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column ALL_TABLES.BACKED_UP is
'Has table been backed up since last modification?'
/
comment on column ALL_TABLES.NUM_ROWS is
'The number of rows in the table'
/
comment on column ALL_TABLES.BLOCKS is
'The number of used blocks in the table'
/
comment on column ALL_TABLES.EMPTY_BLOCKS is
'The number of empty (never used) blocks in the table'
/
comment on column ALL_TABLES.AVG_SPACE is
'The average available free space in the table'
/
comment on column ALL_TABLES.CHAIN_CNT is
'The number of chained rows in the table'
/
comment on column ALL_TABLES.AVG_ROW_LEN is
'The average row length, including row overhead'
/
comment on column ALL_TABLES.PARALLEL is
'The degree of parallelism assigned to the table'
/
comment on column ALL_TABLES.CACHE is
'The caching parameter associated with the table'
/
drop public synonym ALL_TABLES
/
create public synonym ALL_TABLES for ALL_TABLES
/
grant select on ALL_TABLES to PUBLIC with grant option
/
create or replace view DBA_TABLES
    (OWNER, TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN, PARALLEL, CACHE)
as
select u.name, o.name, ts.name, co.name,
       t.pctfree$, t.pctused$,
       t.initrans, t.maxtrans,
       s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
       s.minexts, s.maxexts, s.extpct,
       decode(t.modified, 0, 'Y', 1, 'N', '?'),
       t.rowcnt, t.blkcnt, t.empcnt, t.avgspc, t.chncnt, t.avgrln,
       decode(t.spare1, 0, 'N', 1, 'Y', to_char(t.spare1, '99999')),
       decode(t.spare2, 0, 'N', 1, 'Y',
              'PARTITIONS '||ltrim(to_char(t.spare2, '99999')))
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.clu# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
/
comment on table DBA_TABLES is
'Description of all tables in the database'
/
comment on column DBA_TABLES.OWNER is
'Owner of the table'
/
comment on column DBA_TABLES.TABLE_NAME is
'Name of the table'
/
comment on column DBA_TABLES.TABLESPACE_NAME is
'Name of the tablespace containing the table'
/
comment on column DBA_TABLES.CLUSTER_NAME is
'Name of the cluster, if any, to which the table belongs'
/
comment on column DBA_TABLES.PCT_FREE is
'Minimum percentage of free space in a block'
/
comment on column DBA_TABLES.PCT_USED is
'Minimum percentage of used space in a block'
/
comment on column DBA_TABLES.INI_TRANS is
'Initial number of transactions'
/
comment on column DBA_TABLES.MAX_TRANS is
'Maximum number of transactions'
/
comment on column DBA_TABLES.INITIAL_EXTENT is
'Size of the initial extent in bytes'
/
comment on column DBA_TABLES.NEXT_EXTENT is
'Size of secondary extents in bytes'
/
comment on column DBA_TABLES.MIN_EXTENTS is
'Minimum number of extents allowed in the segment'
/
comment on column DBA_TABLES.MAX_EXTENTS is
'Maximum number of extents allowed in the segment'
/
comment on column DBA_TABLES.PCT_INCREASE is
'Percentage increase in extent size'
/
comment on column DBA_TABLES.BACKED_UP is
'Has table been backed up since last modification?'
/
comment on column DBA_TABLES.NUM_ROWS is
'The number of rows in the table'
/
comment on column DBA_TABLES.BLOCKS is
'The number of used blocks in the table'
/
comment on column DBA_TABLES.EMPTY_BLOCKS is
'The number of empty (never used) blocks in the table'
/
comment on column DBA_TABLES.AVG_SPACE is
'The average available free space in the table'
/
comment on column DBA_TABLES.CHAIN_CNT is
'The number of chained rows in the table'
/
comment on column DBA_TABLES.AVG_ROW_LEN is
'The average row length, including row overhead'
/
comment on column DBA_TABLES.PARALLEL is
'The degree of parallelism assigned to the table'
/
comment on column DBA_TABLES.CACHE is
'The caching parameter associated with the table'
/

create or replace view v_$option as select * from v$option;
drop public synonym v$option;
create public synonym v$option for v_$option;
grant select on v_$option to public;

Rem
Rem Add versioning support
Rem
insert into props$ 
values('EXPORT_VIEWS_VERSION', '1', 'Export views revision #')
/
