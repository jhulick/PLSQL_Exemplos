rem 
rem $Header: catblock.sql,v 1.5 1995/09/28 13:56:21 pgreenwa Exp $ blocking.sql 
rem 
Rem Copyright (c) 1989 by Oracle Corporation
Rem NAME
Rem    catblock.sql
Rem  FUNCTION  -  create views of oracle locks
Rem  NOTES
Rem  MODIFIED
Rem     pgreenwa   08/14/95 -  bug #293557: optimize view queries
Rem     pgreenwa   05/10/95 -  fix dba_lock_internal
Rem     pgreenwa   04/25/95 -  add new vlock columns
Rem     drady      03/22/93 -  merge changes from branch 1.1.312.1 
Rem     drady      03/18/93 -  fix 154271 
Rem     glumpkin   10/17/92 -  renamed from BLOCKING.SQL 
Rem     tpystyne   09/14/92 -  rename sid to session_id 
Rem     jloaiza    07/30/92 -  fix for KGL change 
Rem   tpystyne   05/27/92 - add dba_dml_locks and dba_ddl_locks views
Rem   jloaiza    05/24/91 - upgrade for v7 
Rem   Loaiza     11/01/89 - Creation
Rem


/* this is an auxiliary view containing the KGL locks and pins */
drop view DBA_KGLLOCK;
create view DBA_KGLLOCK as
  select kgllkuse, kgllkhdl, kgllkmod, kgllkreq, 'Lock' kgllktype from x$kgllk
 union all
  select kglpnuse, kglpnhdl, kglpnmod, kglpnreq, 'Pin'  kgllktype from x$kglpn;

/* 
 * DBA_LOCK has a row for each lock that is being held, and 
 * one row for each outstanding request for a lock or latch.
 * The columns of DBA_LOCK are:
 *   session_id     - session holding or acquiring the lock
 *   type           - type of lock
 *   mode_held      - mode the lock is currently held in by the session
 *   mode_requested - mode that the lock is being requested in by the process
 *   lock_id1            - type specific identifier of the lock
 *   lock_id2            - type specific identifier of the lock
 *   last_convert   - time (in seconds) since last convert completed
 *   blocking_others     - is this lock blocking other locks
 */
drop synonym DBA_LOCKS;
drop view DBA_LOCKS;
drop view DBA_LOCK;
create view DBA_LOCK as
  select 
	sid session_id,
	decode(type, 
		'MR', 'Media Recovery', 
		'RT', 'Redo Thread',
		'UN', 'User Name',
		'TX', 'Transaction',
		'TM', 'DML',
		'UL', 'PL/SQL User Lock',
		'DX', 'Distributed Xaction',
		'CF', 'Control File',
		'IS', 'Instance State',
		'FS', 'File Set',
		'IR', 'Instance Recovery',
		'ST', 'Disk Space Transaction',
		'TS', 'Temp Segment',
		'IV', 'Library Cache Invalidation',
		'LS', 'Log Start or Switch',
		'RW', 'Row Wait',
		'SQ', 'Sequence Number',
		'TE', 'Extend Table',
		'TT', 'Temp Table',
		type) lock_type,
	decode(lmode, 
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		to_char(lmode)) mode_held,
         decode(request,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		to_char(request)) mode_requested,
         to_char(id1) lock_id1, to_char(id2) lock_id2,
	 ctime last_convert,
	 decode(block,
	        0, 'Not Blocking',  /* Not blocking any other processes */
		1, 'Blocking',      /* This lock blocks other processes */
		2, 'Global',        /* This lock is global, so we can't tell */
		to_char(block)) blocking_others
      from v$lock;               /* processes waiting on or holding enqueues */
create synonym DBA_LOCKS for DBA_LOCK;

/*
 * DBA_LOCK_INTERNAL has a row for each lock or latch that is being held, and 
 * one row for each outstanding request for a lock or latch.
 * The columns  of DBA_LOCK_INTERNAL are:
 *   session_id     - session holding or acquiring the lock
 *   type           - type of lock (DDL, LATCH, etc.)
 *   mode_held      - mode the lock is currently held in by the session
 *   mode_requested - mode that the lock is being requested in by the process
 *   lock_id1            - type specific identifier of the lock
 *   lock_id2            - type specific identifier of the lock
 *
 * NOTE: this view can be very, very slow depending on the size of your
 *	 shared pool area and database activity.
 */
drop view DBA_LOCK_INTERNAL;
create view DBA_LOCK_INTERNAL as
  select 
	sid session_id,
	decode(type, 
		'MR', 'Media Recovery', 
		'RT', 'Redo Thread',
		'UN', 'User Name',
		'TX', 'Transaction',
		'TM', 'DML',
		'UL', 'PL/SQL User Lock',
		'DX', 'Distributed Xaction',
		'CF', 'Control File',
		'IS', 'Instance State',
		'FS', 'File Set',
		'IR', 'Instance Recovery',
		'ST', 'Disk Space Transaction',
		'TS', 'Temp Segment',
		'IV', 'Library Cache Invalidation',
		'LS', 'Log Start or Switch',
		'RW', 'Row Wait',
		'SQ', 'Sequence Number',
		'TE', 'Extend Table',
		'TT', 'Temp Table',
		type) lock_type,
	decode(lmode, 
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		to_char(lmode)) mode_held,
         decode(request,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		to_char(request)) mode_requested,
         to_char(id1) lock_id1, to_char(id2) lock_id2
      from v$lock                /* processes waiting on or holding enqueues */
 union all                                          /* procs holding latches */
  select s.sid, 'LATCH', 'Exclusive', 'None', rawtohex(laddr), ' '
    from v$process p, v$session s, v$latchholder h
   where h.pid  = p.pid                       /* 6 = exclusive, 0 = not held */
    and  p.addr = s.paddr
 union all                                         /* procs waiting on latch */
  select sid, 'LATCH', 'None', 'Exclusive', latchwait,' '
     from v$session s, v$process p
    where latchwait is not null
     and  p.addr = s.paddr
 union all                                            /* library cache locks */
  select  s.sid,
    decode(ob.kglhdnsp, 0, 'Cursor', 1, 'Table/Procedure', 2, 'Body', 
	     3, 'trigger', 4, 'Index', 5, 'Cluster', to_char(ob.kglhdnsp))
	  || ' Definition ' || lk.kgllktype,
    decode(lk.kgllkmod, 0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
	   to_char(lk.kgllkmod)),
    decode(lk.kgllkreq,  0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
	   to_char(lk.kgllkreq)),
    decode(ob.kglnaown, null, '', ob.kglnaown || '.') || ob.kglnaobj ||
    decode(ob.kglnadlk, null, '', '@' || ob.kglnadlk),
    rawtohex(lk.kgllkhdl)
   from v$session s, x$kglob ob, dba_kgllock lk
     where lk.kgllkhdl = ob.kglhdadr
      and  lk.kgllkuse = s.saddr;
  
/*
 * DBA_DML_LOCKS has a row for each DML lock that is being held, and 
 * one row for each outstanding request for a DML lock. It is subset
 * of DBA_LOCKS
 */

drop view DBA_DML_LOCKS;

create view DBA_DML_LOCKS as
  select 
	sid session_id,
        u.name owner,
        o.name,
	decode(lmode, 
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		'Invalid') mode_held,
         decode(request,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		'Invalid') mode_requested,
	 l.ctime last_convert,
	 decode(block,
	        0, 'Not Blocking',  /* Not blocking any other processes */
		1, 'Blocking',      /* This lock blocks other processes */
		2, 'Global',        /* This lock is global, so we can't tell */
		to_char(block)) blocking_others
      from v$lock l, obj$ o, user$ u
      where l.id1 = o.obj#
      and   o.owner# = u.user#
      and   l.type = 'TM';

/*
 * DBA_DDL_LOCKS has a row for each DDL lock that is being held, and 
 * one row for each outstanding request for a DDL lock. It is subset
 * of DBA_LOCKS
 */

drop view DBA_DDL_LOCKS;

create view DBA_DDL_LOCKS as
  select  s.sid session_id,
          substr(ob.kglnaown,1,30) owner,
          substr(ob.kglnaobj,1,30) name,
    decode(ob.kglhdnsp, 0, 'Cursor', 1, 'Table/Procedure', 2, 'Body', 
	     3, 'Trigger', 4, 'Index', 5, 'Cluster', 'Unknown') type,
    decode(lk.kgllkmod, 0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
	   'Unknown') mode_held,
    decode(lk.kgllkreq,  0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
	   'Unknown') mode_requested
   from v$session s, x$kglob ob, x$kgllk lk
   where lk.kgllkhdl = ob.kglhdadr
   and   lk.kgllkuse = s.saddr
   and   ob.kglhdnsp != 0;

/*
 * Show all the sessions waiting for locks and the session that holds the 
 * lock.
 */
drop view DBA_WAITERS;

create view DBA_WAITERS as
 select /*+ all_rows */ w.session_id  waiting_session,
	h.session_id  holding_session,
	w.lock_type, 
	h.mode_held, 
	w.mode_requested,
	w.lock_id1,
	w.lock_id2
  from dba_locks w, dba_locks h
 where h.blocking_others = 'Blocking'
  and  h.mode_held	!=  'None'
  and  h.mode_held	!=  'Null'
  and  w.mode_requested !=  'None'
  and  w.lock_type	 =  h.lock_type
  and  w.lock_id1	 =  h.lock_id1
  and  w.lock_id2        =  h.lock_id2;

/*
 * Show all the sessions that have someone waiting on a lock they hold, but
 * that are not themselves waiting on a lock.
 */
drop view DBA_BLOCKERS;

create view DBA_BLOCKERS as
 select /*+ all_rows */ holding_session from dba_waiters
minus
 select /*+ all_rows */ session_id from dba_locks w
   where w.mode_requested != 'None';
