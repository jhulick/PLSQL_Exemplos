rem 
rem $Header: catparr.sql,v 1.15 1995/11/30 11:06:45 tlahiri Exp $ 
rem 
Rem Copyright (c) 1990 by Oracle Corporation
Rem NAME
Rem    CATPARR.SQL
Rem  FUNCTION
Rem    Parallel-Server specific views for performance queries, etc.
Rem  NOTES
Rem     This script must be run while connected as SYS or INTERNAL.
Rem  MODIFIED
Rem     tlahiri    11/30/95 -  Fix error in v$lock_element in last checkin
Rem     tlahiri    11/20/95 -  Bugs 313766 and 313767
Rem     aezzat     08/09/95 -  modify v$bh, v$ping to include buffer class
Rem     pgreenwa   10/21/94 -  create public syn. for v$locks_with_collisions
Rem     svenkate   11/30/94 -  bug 250244 : view changes
Rem     thayes     07/08/94 -  Extend vbh view
Rem     svenkate   06/17/94 -  bug 172282 : amendments
Rem     svenkate   06/08/94 -  172288 : add file_lock, file_PING
Rem     wmaimone   05/06/94 -  #184921 run as sys/internal
Rem     jloaiza    03/17/94 -  add false ping view, v$lock_element, etc
Rem     hrizvi     02/09/93 -  apply changes to x$bh 
Rem     jloaiza    11/09/92 -  get rid of quted column 
Rem     jklein     11/04/92 -  fix view definitions 
Rem     jklein     10/28/92 -  merge forward changes from v6 
Rem    Porter    12/03/90 - Added to control system, renamed to psviews.sql
Rem    Laursen   10/01/90 - Creation
Rem
remark  This table maps extents to database objects.  The v$ping and v$cache
remark  views depend on it.  This table must be dropped and recreated to
remark  include any new extents that are added after the last time it was
remark  created.
remark

create or replace view ext_to_obj_view as
  select uet$.file#   file# 
       , uet$.block#  lowb
       , uet$.block# + uet$.length - 1 highb
       , obj$.name    name 
       , 'TABLE'      kind
       , owner#
  from tab$, uet$, obj$
  where tab$.clu# is null
    and tab$.file# = uet$.segfile#
    and tab$.block# = uet$.segblock#
    and tab$.obj# = obj$.obj#
union all
  select distinct
         uet$.file# file# 
       , uet$.block# lowb
       , uet$.block# + uet$.length - 1 highb
       , obj$.name name 
       , 'CLUSTER' kind
       , owner#
  from tab$, uet$, obj$
  where tab$.clu# is not null
    and tab$.file# = uet$.segfile#
    and tab$.block# = uet$.segblock#
    and tab$.clu# = obj$.obj#
union all
  select uet$.file# file# 
       , uet$.block# lowb
       , uet$.block# + uet$.length - 1 highb 
       , obj$.name name 
       , 'INDEX' kind
       , owner#
  from ind$, uet$, obj$
  where ind$.file# = uet$.segfile#
    and ind$.block# = uet$.segblock#
    and ind$.obj# = obj$.obj#
union all
  select uet$.file# file#
       , uet$.block# lowb
       , uet$.block# + uet$.length - 1 highb
       , undo$.name name
       , 'UNDO' kind
       , user# owner#
  from undo$, uet$
  where undo$.file# = uet$.segfile#
    and undo$.block# = uet$.segblock#
union all
  select uet$.file# file#
       , uet$.block# lowb
       , uet$.block# + uet$.length - 1 highb
       , 'TEMP SEGMENT' name
       , 'TEMP SEGMENT' kind
       , 1 owner#
  from uet$, seg$
  where seg$.file# = uet$.segfile#
   and  seg$.block# = uet$.block#
   and  seg$.type = 3
union all
  select file#
       , block#
       , length + block# - 1 
       , 'FREE EXTENT'
       , 'FREE EXTENT'
       , 1  owner#
  from fet$;


remark  Create a table of extents since selecting from the view is too slow.

drop table ext_to_obj;
create table ext_to_obj as select * from ext_to_obj_view;


remark
remark  v$bh gives the status and number of times pinged for every buffer in
remark  the buffer cache.  It gives the file number and block number for each
remark  buffer, but unlike the v$cache and v$ping views, it does not translate
remark  that to a database object.
remark
remark  The x_to_null column counts the number of times the buffer has gone
remark  from exclusive mode to null mode on this instance.  This
remark  happens when the block is pinged out of the instance's cache. A block 
remark  will be pinged out of an instance's cache, when another instance 
remark  requests the lock that protects the block in exclusive mode.
remark  Note that a block can go from being exclusive to being shared in this
remark  instance without incrementing the count, however, if this instance
remark  ever takes the block back to exclusive mode, then the other instance's
remark  ping count will be incremented.  Therefore to get a true picture
remark  of the pings you need to look at v$bh on all instances.
remark
remark  The 'lock_element_addr' column contains the address of the lock element
remark  that contains the PCM lock that is locking this buffer.  If two buffers
remark  have the same lock_element_addr, then they are being protected
remark  by the same PCM lock. Anytime two buffers are covered by the same PCM 
remark  lock, you can have false collisions between the buffers.
remark

create or replace view v$bh as          /* view on buffer headers */
  select DBAFIL                    file#,
         DBABLK                    block#,
         CLASS                     class#,
         decode(state, 0, 'FREE',       /* not currently is use */
                       1, 'XCUR',       /* held exclusive by this instance */
                       2, 'SCUR',       /* held shared by this instance */
                       3, 'CR',         /* only valid for consistent read */
                       4, 'READ',       /* is being read from disk */
                       5, 'MREC',       /* in media recovery mode */
                       6, 'IREC')       /* in instance (crash) recovery mode */
	         status,
         x_to_null                 xnc, /* count of ping outs */
         le_addr                   lock_element_addr,
	 decode(bitand(flag,1), 0, 'N', 'Y')
		dirty,			/* Dirty bit */
	 decode(bitand(flag,16), 0, 'N', 'Y')
		temp,			/* temporary bit */
	 decode(bitand(flag,1536), 0, 'N', 'Y')
		ping,			/* ping (to shared or null) bit */
	 decode(bitand(flag,16384), 0, 'N', 'Y')
		stale,			/* stale bit */
	 decode(bitand(flag,65536), 0, 'N', 'Y')
		direct,			/* direct access bit */
	 decode(bitand(flag,1048576), 0, 'N', 'Y')
		new			/* new bit */
         from x$bh; 

grant select on v$bh to public;
drop public synonym v$bh;
create public synonym v$bh for v$bh;

remark
remark  The v$ping view is like v$bh but it only shows the buffer that
remark  have been pinged out of this instance's cache at least once.
remark  v$ping also translates the file number and block number into the 
remark  corresponding database object (using the ext_to_obj table).
remark  For a descriptions of the columns, see the v$bh view.

create or replace view v$ping as
select bh.file#,
       bh.block#,
       bh.class#,
       bh.status,
       bh.xnc,
       ext_to_obj.name,
       ext_to_obj.kind,
       ext_to_obj.owner#,
       lock_element_addr
       from v$bh bh, ext_to_obj 
       where bh.xnc > 0                        and 
             bh.block# >= ext_to_obj.lowb  (+) and
             bh.block# <= ext_to_obj.highb (+) and
             bh.file#  =  ext_to_obj.file# (+);


grant select on v$ping to public;
drop public synonym v$ping;
create public synonym v$ping for v$ping;

remark
remark  The v$cache view show all blocks in the cache.  It gives the file
remark  number, the block number, and the number of times pinged (if any); it
remark  also translates the file number and block number into the corresponding
remark  database object (using the ext_to_obj table).  The difference between
remark  this view and the v$ping view is that v$cache shows all buffers in the
remark  cache, whether or not they have ever been pinged.
remark

create or replace view v$cache as
select bh.file#,
       bh.block#,
       bh.class#,
       bh.status,
       bh.xnc,
       ext_to_obj.name,
       ext_to_obj.kind,
       ext_to_obj.owner#,
       lock_element_addr
       from v$bh bh, ext_to_obj 
       where 
             bh.block# >=  ext_to_obj.lowb  (+) and
             bh.block# <=  ext_to_obj.highb (+) and
             bh.file#   =  ext_to_obj.file# (+) ;

grant select on v$cache to public;
drop public synonym v$cache;
create public synonym v$cache for v$cache;


remark
remark  There is one entry in v$lock_element for each PCM lock that is used
remark  by the buffer cache (gc_db_locks).  v$lock_element describes the
remark  status of each lock.  The name of the PCM lock that corresponds to
remark  a lock element is  {'BL', indx, class}.  
remark

create or replace view v$lock_element as
select addr     lock_element_addr,  /* address of lock, join with v$bh */
       indx,                        /* indx,class are used to identify a */
       le_class class,              /*    lock to the OS lock manager */
       le_mode  mode_held,          /* values are OS dependent, usually */
                                    /*   5=exclusive, 3=share           */
       le_blks  block_count,        /* number of blocks protected by lock */
       le_rls   releasing,          /* non-zero if lock is being downgraded */
       le_acq   acquiring,          /* non-zero if lock is being upgraded */
       le_inv   invalid,            /* non-zero if lock is invalid, a lock  */
                                    /*   may become invalid after a crash */
       le_flags flags               /* process level flags for the le */
  from x$le;


grant select on v$lock_element to public;
drop public synonym v$lock_element;
create public synonym v$lock_element for v$lock_element;


remark
remark  This view is like v$cache, but it also contains the indx and class of
remark  the PCM lock that is protecting the buffer.  This view is useful for 
remark  backmapping remark a PCM lock to a set of buffers.  The name of 
remark  the PCM lock that remark  corresponds to a lock element 
remark  is  {'BL', indx, class}.  This can be useful if the 
remark  OS lock manager provides tools for monitoring the
remark  PCM lock operations that are occuring.  First you identify the 
remark  lock element in question by using the indx and class, then you
remark  find the buffers that are covered by this lock by looking in v$bh
remark  for buffers with the correct lock_element_addr.

create or replace view v$cache_lock as
select file#, block#, status, xnc,
       name, kind, owner#, c.lock_element_addr, indx, class
  from v$cache c, v$lock_element l
 where l.lock_element_addr = c.lock_element_addr;


grant select on v$cache_lock to public;
drop public synonym v$cache_lock;
create public synonym v$cache_lock for v$cache_lock;



remark 
remark  Find the locks that protect multiple buffers each of which has been
remark  pinged out at least one hundred times.  It is very likely that those
remark  buffers are experiencing false pings due to being mapped to the same
remark  lock. 
remark  
remark  Note that a more correct version of this would select the buffers
remark  from all the nodes since it is possible to experience false pinging
remark  in which different nodes are accessing different buffers that happen
remark  to map to the same lock.
remark

create or replace view v$locks_with_collisions as
select lock_element_addr
  from v$bh
where xnc > 100
group by lock_element_addr
having count(*) >= 2;

grant select on v$locks_with_collisions to public;
drop public synonym v$locks_with_collisions;
create public synonym v$locks_with_collisions for v$locks_with_collisions;


remark  
remark  This view shows all the buffers that look like they are experiencing
remark  false pings.  It select the buffers that have been pinged more than
remark  100 times that are protected by the same lock as another buffer that
remark  has been pinged more than 100 times.   If you are experiencing false
remark  pinging then you can change your gc_files_to_locks so that the buffers
remark  experiencing false pinging are mapped to different locks.
remark

create or replace view v$false_ping as
select file#,
       block#,
       status,
       xnc,
       name,
       kind,
       owner#,
       p.lock_element_addr
    from v$ping p, v$locks_with_collisions c
  where p.xnc > 100 
   and  p.lock_element_addr = c.lock_element_addr;


grant select on v$false_ping to public;
drop public synonym v$false_ping;
create public synonym v$false_ping for v$false_ping;


remark
remark  The v$lock_activity view shows the DLM lock operations the instance is
remark  doing.  Each row corresponds to a type of lock operation.
remark

create or replace view v$lock_activity as
select decode(indx, 1, 'NULL', 2, 'NULL', 3, 'S',    4, 'S', 
                    5, 'X',    6, 'X',    7, 'X',    8, 'SSX', 
                    9, 'SSX', 10, 'SSX',     '???') from_val,
       decode(indx, 1, 'S',    2, 'X',    3, 'NULL',  4, 'X', 
                    5, 'NULL', 6, 'S',    7, 'SSX',   8, 'NULL', 
                    9, 'S',   10, 'X',       '???') to_val,
       decode(indx, 1, 'Lock buffers for read',
                    2, 'Lock buffers for write',
                    3, 'Make buffers CR (no write)',
                    4, 'Upgrade read lock to write',
                    5, 'Make buffers CR (write dirty buffers)',
                    6, 'Downgrade write lock to read (write dirty buffers)',
                    7, 'Write transaction table/undo blocks',
                    8, 
               'Transaction table/undo blocks (write dirty buffers)',
                    9, 'Make transaction table/undo blocks available share',
                    10,'Rearm transaction table write mechanism', 
                    'should not happen') action_val,
       conv counter
       from x$le_stat where conv > 0;               

grant select on v$lock_activity to public;
drop public synonym v$lock_activity;
create public synonym v$lock_activity for v$lock_activity;

remark The view file_ping gives the number of blocks pinged per 
remark datafile. This information in turn may be
remark used to determine access patterns to existing
remark datafiles and deciding new mappings from datafile
remark blocks to PCM locks.
remark The FREQUENCY column counts the number of times any buffer
remark corresponding to a block in a file has gone from exclusive 
remark mode to null mode on this instance.  This happens when 
remark the block is pinged out of the instance's cache. A block 
remark will be pinged out of an instance's cache, when another 
remark instance requests the lock that protects the block 
remark in exclusive mode. Note that a block can go from being 
remark exclusive to being shared in this instance without 
remark incrementing the count, however, if this instance
remark ever accesses the block again in exclusive mode, then 
remark the other instance's ping count will be incremented.  

drop view file_ping; 
create view file_ping as 
select file_id, file_name, TABLESPACE_NAME ts_name, KCFIOX2N frequency
    from x$kcfio x, dba_data_files d 
    where x.KCFIOFNO = d.FILE_ID; 
 
remark The view file_lock is an aid to understanding the mapping of
remark locks to files as established by the GC_FILES_TO_LOCKS
remark parameter. START_LK shows the first lock corresponding to this datafile.
remark NLOCKS shows the number of locks allocated to this datafile while 
remark BLOCKING	records the number of blocks each lock protects.

drop view file_lock; 
create view file_lock as 
select file_id, file_name, TABLESPACE_NAME ts_name, 
    kclfhbas start_lk, kclfhsiz nlocks, kclfhgrp blocking 
    from x$kclfh fh, x$kclfi fi, dba_data_files d 
    where fh.indx = fi.kclfibuk and fi.indx = d.FILE_ID; 


