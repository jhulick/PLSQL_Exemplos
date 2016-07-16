rem
rem $Header: catsnap.sql,v 1.11 1995/11/16 13:59:51 jcchou Exp $
rem
Rem  Copyright (c) 1991 by Oracle Corporation
Rem    NAME
Rem      catsnap.sql
Rem    DESCRIPTION
Rem      Creates data dictionary views for snapshots
Rem    NOTES
Rem      Must be run while connected to SYS or INTERNAL.
Rem    MODIFIED   (MM/DD/YY)
Rem     jcchou     11/15/95 -  bug#302137 - refgroup in sys.snap$
Rem     jcchou     11/09/95 -  #310646 - rbs missing from views
Rem     jcchou     09/26/95 -  bug#310646 - rgroup$ views
Rem     adowning   12/23/94 -  merge changes from branch 1.7.720.1
Rem     adowning   12/21/94 -  merge changes from branch 1.4.710.4
Rem     adowning   12/05/94 -  fix all_snapshots
Rem     adowning   11/11/94 -  merge changes from branch 1.4.710.3
Rem     adowning   10/14/94 -  fix typo USER to DBA
Rem     wmaimone   05/26/94 -  #186155 add public synoyms for dba_
Rem     rjenkins   01/19/94 -  merge changes from branch 1.4.710.2
Rem     jbellemo   12/17/93 -  merge changes from branch 1.4.710.1
Rem     rjenkins   12/17/93 -  creating job queue
Rem     jbellemo   11/09/93 -  #170173: change uid to userenv schemaid
Rem     rjenkins   07/06/93 -  adding updatable snapshots
Rem     wbridge    12/03/92 -  fix error handling for refresh all 
Rem     tpystyne   11/08/92 -  use create or replace view 
Rem     glumpkin   10/25/92 -  Renamed from SNAPVEW.SQL 
Rem     mmoore     06/02/92 - #(96526) remove v$enabledroles 
Rem     rjenkins   01/14/92 -  copying changes from catalog.sql 
Rem     rjenkins   05/20/91 -         Creation 

remark
remark    FAMILY "SNAPSHOTS"
remark    Table replication definitions.
remark

create or replace view DBA_SNAPSHOTS
( OWNER, NAME, TABLE_NAME, MASTER_VIEW, MASTER_OWNER, MASTER, MASTER_LINK,
  CAN_USE_LOG, UPDATABLE, LAST_REFRESH, ERROR, TYPE, NEXT, START_WITH, 
  REFRESH_GROUP, UPDATE_TRIG, UPDATE_LOG, QUERY)
as
select s.sowner, s.vname, s.tname, s.mview, s.mowner, s.master, s.mlink,
       decode(bitand(s.flag,1), 0, 'NO', 'YES'), 
       decode(bitand(s.flag,2), 0, 'NO', 'YES'), 
       s.snaptime, s.error#, 
       decode(s.auto_fast, 
              'C', 'COMPLETE', 
              'F', 'FAST', 
              '?', 'FORCE', 
              null, 'FORCE', 'ERROR'), 
       s.auto_fun, s.auto_date, r.refgroup, s.ustrg, s.uslog, s.query_txt
from sys.snap$ s, sys.rgchild$ r
where s.sowner = r.owner (+) and s.vname = r.name (+)
and r.type (+) = 'SNAPSHOT';
/
drop public synonym DBA_SNAPSHOTS
/
create public synonym DBA_SNAPSHOTS for DBA_SNAPSHOTS
/
comment on table DBA_SNAPSHOTS is
'All snapshots in the database'
/
comment on column DBA_SNAPSHOTS.OWNER is
'Owner of the snapshot'
/
comment on column DBA_SNAPSHOTS.NAME is
'The view used by users and applications for viewing the snapshot'
/
comment on column DBA_SNAPSHOTS.TABLE_NAME is
'Table the snapshot is stored in -- has an extra column for the master rowid'
/
comment on column DBA_SNAPSHOTS.MASTER_VIEW is
'View of the master table, owned by the snapshot owner, used for refreshes'
/
comment on column DBA_SNAPSHOTS.MASTER_OWNER is
'Owner of the master table'
/
comment on column DBA_SNAPSHOTS.MASTER is
'Name of the master table that this snapshot is a copy of'
/
comment on column DBA_SNAPSHOTS.MASTER_LINK is
'Database link name to the master site'
/
comment on column DBA_SNAPSHOTS.CAN_USE_LOG is
'If NO, this snapshot is complex and will never use a log'
/
comment on column DBA_SNAPSHOTS.UPDATABLE is
'If NO, the snapshot is read only.  Look up REPLICATION'
/
comment on column DBA_SNAPSHOTS.LAST_REFRESH is
'SYSDATE from the master site at the time of the last refresh'
/
comment on column DBA_SNAPSHOTS.ERROR is
'The number of failed automatic refreshes since last successful refresh'
/
comment on column DBA_SNAPSHOTS.TYPE is
'The type of refresh (complete,fast,force) for all automatic refreshes'
/
comment on column DBA_SNAPSHOTS.NEXT is
'The date function used to compute next refresh dates'
/
comment on column DBA_SNAPSHOTS.START_WITH is
'The date function used to compute next refresh dates'
/
comment on column DBA_SNAPSHOTS.REFRESH_GROUP is
'All snapshots in a given refresh group get refreshed in the same transaction'
/
comment on column DBA_SNAPSHOTS.UPDATE_TRIG is
'The name of the trigger which fills the UPDATE_LOG'
/
comment on column DBA_SNAPSHOTS.UPDATE_LOG is
'The table which logs changes made to an updatable snapshots'
/
comment on column DBA_SNAPSHOTS.QUERY is
'The original query that this snapshot is an instantiation of'
/
/*
 * define the ability to "access a snapshot" as the ability to
 * "access the snapshot's table_name (e.g., snap$_foo).
 */
create or replace view ALL_SNAPSHOTS
as select s.* from dba_snapshots s, sys.obj$ o, sys.user$ u
where o.owner#     = u.user#
  and s.table_name = o.name
  and u.name       = s.owner
  and o.type       = 2                     /* table */
  and ( u.user# in (userenv('SCHEMAID'), 1)
        or
        o.obj# in ( select obj#
                    from sys.objauth$
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
comment on table ALL_SNAPSHOTS is
'Snapshots the user can look at'
/
comment on column ALL_SNAPSHOTS.OWNER is
'Owner of the snapshot'
/
comment on column ALL_SNAPSHOTS.NAME is
'The view used by users and applications for viewing the snapshot'
/
comment on column ALL_SNAPSHOTS.TABLE_NAME is
'Table the snapshot is stored in -- has an extra column for the master rowid'
/
comment on column ALL_SNAPSHOTS.MASTER_VIEW is
'View of the master table, owned by the snapshot owner, used for refreshes'
/
comment on column ALL_SNAPSHOTS.MASTER_OWNER is
'Owner of the master table'
/
comment on column ALL_SNAPSHOTS.MASTER is
'Name of the master table that this snapshot is a copy of'
/
comment on column ALL_SNAPSHOTS.MASTER_LINK is
'Database link name to the master site'
/
comment on column ALL_SNAPSHOTS.CAN_USE_LOG is
'If NO, this snapshot is complex and will never use a log'
/
comment on column ALL_SNAPSHOTS.LAST_REFRESH is
'SYSDATE from the master site at the time of the last refresh'
/
comment on column ALL_SNAPSHOTS.ERROR is
'The error returned last time an automatic refresh was attempted'
/
comment on column ALL_SNAPSHOTS.TYPE is
'The type of refresh (complete,fast,force) for all automatic refreshes'
/
comment on column ALL_SNAPSHOTS.NEXT is
'The date function used to compute next refresh dates'
/
comment on column ALL_SNAPSHOTS.START_WITH is
'The date function used to compute next refresh dates'
/
comment on column ALL_SNAPSHOTS.REFRESH_GROUP is
'All snapshots in a given refresh group get refreshed in the same transaction'
/
comment on column ALL_SNAPSHOTS.UPDATE_TRIG is
'The name of the trigger which fills the UPDATE_LOG'
/
comment on column ALL_SNAPSHOTS.UPDATE_LOG is
'The table which logs changes made to an updatable snapshots'
/
comment on column ALL_SNAPSHOTS.QUERY is
'The original query that this snapshot is an instantiation of'
/
drop public synonym ALL_SNAPSHOTS
/
create public synonym ALL_SNAPSHOTS for ALL_SNAPSHOTS
/
grant select on ALL_SNAPSHOTS to public with grant option
/
create or replace view USER_SNAPSHOTS
as select s.* from dba_snapshots s, sys.user$ u
where u.user# = userenv('SCHEMAID')
  and s.owner = u.name
/
comment on table USER_SNAPSHOTS is
'Snapshots the user can look at'
/
comment on column USER_SNAPSHOTS.OWNER is
'Owner of the snapshot'
/
comment on column USER_SNAPSHOTS.NAME is
'The view used by users and applications for viewing the snapshot'
/
comment on column USER_SNAPSHOTS.TABLE_NAME is
'Table the snapshot is stored in -- has an extra column for the master rowid'
/
comment on column USER_SNAPSHOTS.MASTER_VIEW is
'View of the master table, owned by the snapshot owner, used for refreshes'
/
comment on column USER_SNAPSHOTS.MASTER_OWNER is
'Owner of the master table'
/
comment on column USER_SNAPSHOTS.MASTER is
'Name of the master table that this snapshot is a copy of'
/
comment on column USER_SNAPSHOTS.MASTER_LINK is
'Database link name to the master site'
/
comment on column USER_SNAPSHOTS.CAN_USE_LOG is
'If NO, this snapshot is complex and will never use a log'
/
comment on column USER_SNAPSHOTS.LAST_REFRESH is
'SYSDATE from the master site at the time of the last refresh'
/
comment on column USER_SNAPSHOTS.ERROR is
'The error returned last time an automatic refresh was attempted'
/
comment on column USER_SNAPSHOTS.TYPE is
'The type of refresh (complete,fast,force) for all automatic refreshes'
/
comment on column USER_SNAPSHOTS.NEXT is
'The date function used to compute next refresh dates'
/
comment on column USER_SNAPSHOTS.START_WITH is
'The date function used to compute next refresh dates'
/
comment on column USER_SNAPSHOTS.REFRESH_GROUP is
'All snapshots in a given refresh group get refreshed in the same transaction'
/
comment on column USER_SNAPSHOTS.UPDATE_TRIG is
'The name of the trigger which fills the UPDATE_LOG'
/
comment on column USER_SNAPSHOTS.UPDATE_LOG is
'The table which logs changes made to an updatable snapshots'
/
comment on column USER_SNAPSHOTS.QUERY is
'The original query that this snapshot is an instantiation of'
/
drop public synonym USER_SNAPSHOTS
/
create public synonym USER_SNAPSHOTS for USER_SNAPSHOTS
/
grant select on USER_SNAPSHOTS to public with grant option
/

create or replace view DBA_SNAPSHOT_LOGS
( LOG_OWNER, MASTER, LOG_TABLE, LOG_TRIGGER, CURRENT_SNAPSHOTS)
as
select m.mowner, m.master, m.log, m.trig, s.snaptime
from sys.mlog$ m, sys.slog$ s
where s.mowner (+) = m.mowner
  and s.master (+) = m.master
/
drop public synonym DBA_SNAPSHOT_LOGS
/
create public synonym DBA_SNAPSHOT_LOGS for DBA_SNAPSHOT_LOGS
/
comment on table DBA_SNAPSHOT_LOGS is
'All snapshot logs in the database'
/
comment on column DBA_SNAPSHOT_LOGS.LOG_OWNER is
'Owner of the snapshot log'
/
comment on column DBA_SNAPSHOT_LOGS.MASTER is
'Name of the master table which the log logs changes of'
/
comment on column DBA_SNAPSHOT_LOGS.LOG_TABLE is
'Log table; holds rowids and timestamps of rows which changed in the master'
/
comment on column DBA_SNAPSHOT_LOGS.LOG_TRIGGER is
'An after-row trigger on the master which inserts rows into the log'
/
comment on column DBA_SNAPSHOT_LOGS.CURRENT_SNAPSHOTS is
'One date per snapshot -- the date the snapshot of the master last refreshed'
/

create or replace view USER_SNAPSHOT_LOGS
( LOG_OWNER, MASTER, LOG_TABLE, LOG_TRIGGER, CURRENT_SNAPSHOTS)
as
select log_owner, master, log_table, log_trigger, current_snapshots
from dba_snapshot_logs s, sys.user$ u
where s.log_owner = u.name
  and u.user# = userenv('SCHEMAID')
/
comment on table USER_SNAPSHOT_LOGS is
'All snapshot logs owned by the user'
/
comment on column USER_SNAPSHOT_LOGS.LOG_OWNER is
'Owner of the snapshot log'
/
comment on column USER_SNAPSHOT_LOGS.MASTER is
'Name of the master table which the log logs changes of'
/
comment on column USER_SNAPSHOT_LOGS.LOG_TABLE is
'Log table; holds rowids and timestamps of rows which changed in the
master'
/
comment on column USER_SNAPSHOT_LOGS.LOG_TRIGGER is
'Trigger on master table; fills the snapshot log'
/
comment on column USER_SNAPSHOT_LOGS.CURRENT_SNAPSHOTS is
'Dates that all known simple snapshots last refreshed'
/
drop public synonym USER_SNAPSHOT_LOGS
/
create public synonym USER_SNAPSHOT_LOGS for USER_SNAPSHOT_LOGS
/
grant select on USER_SNAPSHOT_LOGS to public with grant option
/


create or replace view DBA_RCHILD 
as select REFGROUP, OWNER, NAME, TYPE from rgchild$
/
comment on table DBA_RCHILD is
'All the children in any refresh group.  This view is not a join.'
/
drop public synonym DBA_RCHILD
/
create public synonym DBA_RCHILD for DBA_RCHILD
/


create or replace view DBA_RGROUP
as select REFGROUP, OWNER, NAME,
          decode(bitand(flag,1),1,'Y',0,'N','?') IMPLICIT_DESTROY,
          decode(bitand(flag,2),2,'Y',0,'N','?') PUSH_DEFERRED_RPC,
          decode(bitand(flag,4),4,'Y',0,'N','?') REFRESH_AFTER_ERRORS,
          ROLLBACK_SEG,
          JOB
  from rgroup$
/
comment on table DBA_RGROUP is
'All refresh groups.  This view is not a join.'
/
comment on column DBA_RGROUP.REFGROUP is
'Internal identifier of refresh group'
/
comment on column DBA_RGROUP.OWNER is
'Owner of the refresh group'
/
comment on column DBA_RGROUP.NAME is
'Name of the refresh group'
/
comment on column DBA_RGROUP.IMPLICIT_DESTROY is
'Y or N, if Y then destroy the refresh group when its last item is subtracted'
/
comment on column DBA_RGROUP.PUSH_DEFERRED_RPC is
'Y or N, if Y then push changes from snapshot to master before refresh'
/
comment on column DBA_RGROUP.REFRESH_AFTER_ERRORS is
'If Y, proceed with refresh despite error when pushing deferred RPCs'
/
comment on column DBA_RGROUP.ROLLBACK_SEG is
'Name of the rollback segment to use while refreshing'
/
comment on column DBA_RGROUP.JOB is
'Identifier of job used to automatically refresh the group'
/
drop public synonym DBA_RGROUP
/
create public synonym DBA_RGROUP for DBA_RGROUP
/


create or replace view DBA_REFRESH
as select r.owner ROWNER, r.name RNAME, r.REFGROUP,
          decode(bitand(r.flag,1),1,'Y',0,'N','?') IMPLICIT_DESTROY,
          decode(bitand(r.flag,2),2,'Y',0,'N','?') PUSH_DEFERRED_RPC,
          decode(bitand(r.flag,4),4,'Y',0,'N','?') REFRESH_AFTER_ERRORS,
          r.rollback_seg ROLLBACK_SEG,
          j.JOB, j.NEXT_DATE, j.INTERVAL, 
          decode(bitand(j.flag,1),1,'Y',0,'N','?') BROKEN
  from rgroup$ r, job$ j
  where r.job = j.job(+)
/
comment on table DBA_REFRESH is
'All the refresh groups'
/
comment on column DBA_REFRESH.ROWNER is
'Name of the owner of the refresh group'
/
comment on column DBA_REFRESH.RNAME is
'Name of the refresh group'
/
comment on column DBA_REFRESH.REFGROUP is
'Internal identifier of refresh group'
/
comment on column DBA_REFRESH.IMPLICIT_DESTROY is
'Y or N, if Y then destroy the refresh group when its last item is subtracted'
/
comment on column DBA_REFRESH.PUSH_DEFERRED_RPC is
'Y or N, if Y then push changes from snapshot to master before refresh'
/
comment on column DBA_REFRESH.REFRESH_AFTER_ERRORS is
'If Y, proceed with refresh despite error when pushing deferred RPCs'
/
comment on column DBA_REFRESH.ROLLBACK_SEG is
'Name of the rollback segment to use while refreshing'
/
comment on column DBA_REFRESH.JOB is
'Identifier of job used to automatically refresh the group'
/
comment on column DBA_REFRESH.NEXT_DATE is
'Date that this job will next be automatically refreshed, if not broken'
/
comment on column DBA_REFRESH.INTERVAL is
'A date function used to compute the next NEXT_DATE'
/
comment on column DBA_REFRESH.BROKEN is
'Y or N, Y is the job is broken and will never be run'
/
drop public synonym DBA_REFRESH
/
create public synonym DBA_REFRESH for DBA_REFRESH
/


create or replace view ALL_REFRESH
as select * from dba_refresh where user = rowner
  or userenv('SCHEMAID') = 0 or exists
  (select kzsrorol
     from x$kzsro x, sys.system_privilege_map m, sys.sysauth$ s
     where x.kzsrorol = s.grantee# and
           s.privilege# = m.privilege and
           m.name = 'ALTER ANY SNAPSHOT')
/
comment on table ALL_REFRESH is
'All the refresh groups that the user can touch'
/
comment on column ALL_REFRESH.ROWNER is
'Name of the owner of the refresh group'
/
comment on column ALL_REFRESH.RNAME is
'Name of the refresh group'
/
comment on column ALL_REFRESH.REFGROUP is
'Internal identifier of refresh group'
/
comment on column ALL_REFRESH.IMPLICIT_DESTROY is
'Y or N, if Y then destroy the refresh group when its last item is subtracted'
/
comment on column ALL_REFRESH.PUSH_DEFERRED_RPC is
'Y or N, if Y then push changes from snapshot to master before refresh'
/
comment on column ALL_REFRESH.REFRESH_AFTER_ERRORS is
'If Y, proceed with refresh despite error when pushing deferred RPCs'
/
comment on column ALL_REFRESH.ROLLBACK_SEG is
'Name of the rollback segment to use while refreshing'
/
comment on column ALL_REFRESH.JOB is
'Identifier of job used to automatically refresh the group'
/
comment on column ALL_REFRESH.NEXT_DATE is
'Date that this job will next be automatically refreshed, if not broken'
/
comment on column ALL_REFRESH.INTERVAL is
'A date function used to compute the next NEXT_DATE'
/
comment on column ALL_REFRESH.BROKEN is
'Y or N, Y is the job is broken and will never be run'
/
drop public synonym ALL_REFRESH
/
create public synonym ALL_REFRESH for ALL_REFRESH
/
grant select on ALL_REFRESH to public with grant option
/


create or replace view USER_REFRESH 
as select * from dba_refresh where rowner = user
/
comment on table USER_REFRESH is
'All the refresh groups'
/
comment on column USER_REFRESH.ROWNER is
'Name of the owner of the refresh group'
/
comment on column USER_REFRESH.RNAME is
'Name of the refresh group'
/
comment on column USER_REFRESH.REFGROUP is
'Internal identifier of refresh group'
/
comment on column USER_REFRESH.IMPLICIT_DESTROY is
'Y or N, if Y then destroy the refresh group when its last item is subtracted'
/
comment on column USER_REFRESH.PUSH_DEFERRED_RPC is
'Y or N, if Y then push changes from snapshot to master before refresh'
/
comment on column USER_REFRESH.REFRESH_AFTER_ERRORS is
'If Y, proceed with refresh despite error when pushing deferred RPCs'
/
comment on column USER_REFRESH.ROLLBACK_SEG is
'Name of the rollback segment to use while refreshing'
/
comment on column USER_REFRESH.JOB is
'Identifier of job used to automatically refresh the group'
/
comment on column USER_REFRESH.NEXT_DATE is
'Date that this job will next be automatically refreshed, if not broken'
/
comment on column USER_REFRESH.INTERVAL is
'A date function used to compute the next NEXT_DATE'
/
comment on column USER_REFRESH.BROKEN is
'Y or N, Y is the job is broken and will never be run'
/
drop public synonym USER_REFRESH
/
create public synonym USER_REFRESH for USER_REFRESH
/
grant select on USER_REFRESH to public with grant option
/



create or replace view DBA_REFRESH_CHILDREN
as select rc.owner OWNER, rc.name NAME, rc.TYPE, 
          r.owner ROWNER, r.name RNAME, r.REFGROUP,
          decode(bitand(r.flag,1),1,'Y',0,'N','?') IMPLICIT_DESTROY,
          decode(bitand(r.flag,2),2,'Y',0,'N','?') PUSH_DEFERRED_RPC,
          decode(bitand(r.flag,4),4,'Y',0,'N','?') REFRESH_AFTER_ERRORS,
          r.rollback_seg ROLLBACK_SEG,
          j.job, j.NEXT_DATE, j.INTERVAL,
          decode(bitand(j.flag,1),1,'Y',0,'N','?') BROKEN
  from rgroup$ r, rgchild$ rc, job$ j
  where r.refgroup = rc.refgroup
    and r.job = j.job (+)
/
comment on table DBA_REFRESH_CHILDREN is
'All the objects in refresh groups'
/
comment on column DBA_REFRESH_CHILDREN.OWNER is
'Owner of the object in the refresh group'
/
comment on column DBA_REFRESH_CHILDREN.NAME is
'Name of the object in the refresh group'
/
comment on column DBA_REFRESH_CHILDREN.TYPE is
'Type of the object in the refresh group'
/
comment on column DBA_REFRESH_CHILDREN.ROWNER is
'Name of the owner of the refresh group'
/
comment on column DBA_REFRESH_CHILDREN.RNAME is
'Name of the refresh group'
/
comment on column DBA_REFRESH_CHILDREN.REFGROUP is
'Internal identifier of refresh group'
/
comment on column DBA_REFRESH_CHILDREN.IMPLICIT_DESTROY is
'Y or N, if Y then destroy the refresh group when its last item is subtracted'
/
comment on column DBA_REFRESH_CHILDREN.PUSH_DEFERRED_RPC is
'Y or N, if Y then push changes from snapshot to master before refresh'
/
comment on column DBA_REFRESH_CHILDREN.REFRESH_AFTER_ERRORS is
'If Y, proceed with refresh despite error when pushing deferred RPCs'
/
comment on column DBA_REFRESH_CHILDREN.ROLLBACK_SEG is
'Name of the rollback segment to use while refreshing'
/
comment on column DBA_REFRESH_CHILDREN.JOB is
'Identifier of job used to automatically refresh the group'
/
comment on column DBA_REFRESH_CHILDREN.NEXT_DATE is
'Date that this job will next be automatically refreshed, if not broken'
/
comment on column DBA_REFRESH_CHILDREN.INTERVAL is
'A date function used to compute the next NEXT_DATE'
/
comment on column DBA_REFRESH_CHILDREN.BROKEN is
'Y or N, Y is the job is broken and will never be run'
/
drop public synonym DBA_REFRESH_CHILDREN
/
create public synonym DBA_REFRESH_CHILDREN for DBA_REFRESH_CHILDREN
/


create or replace view ALL_REFRESH_CHILDREN
as select * from dba_refresh_children where user = rowner 
  or userenv('SCHEMAID') = 0 or exists
  (select kzsrorol
     from x$kzsro x, sys.system_privilege_map m, sys.sysauth$ s    
     where x.kzsrorol = s.grantee# and
           s.privilege# = m.privilege and
           m.name = 'ALTER ANY SNAPSHOT')
/
comment on table ALL_REFRESH_CHILDREN is
'All the objects in refresh groups, where the user can touch the group'
/
comment on column ALL_REFRESH_CHILDREN.OWNER is
'Owner of the object in the refresh group'
/
comment on column ALL_REFRESH_CHILDREN.NAME is
'Name of the object in the refresh group'
/
comment on column ALL_REFRESH_CHILDREN.TYPE is
'Type of the object in the refresh group'
/
comment on column ALL_REFRESH_CHILDREN.ROWNER is
'Name of the owner of the refresh group'
/
comment on column ALL_REFRESH_CHILDREN.RNAME is
'Name of the refresh group'
/
comment on column ALL_REFRESH_CHILDREN.REFGROUP is
'Internal identifier of refresh group'
/
comment on column ALL_REFRESH_CHILDREN.IMPLICIT_DESTROY is
'Y or N, if Y then destroy the refresh group when its last item is subtracted'
/
comment on column ALL_REFRESH_CHILDREN.PUSH_DEFERRED_RPC is
'Y or N, if Y then push changes from snapshot to master before refresh'
/
comment on column ALL_REFRESH_CHILDREN.REFRESH_AFTER_ERRORS is
'If Y, proceed with refresh despite error when pushing deferred RPCs'
/
comment on column ALL_REFRESH_CHILDREN.ROLLBACK_SEG is
'Name of the rollback segment to use while refreshing'
/
comment on column ALL_REFRESH_CHILDREN.JOB is
'Identifier of job used to automatically refresh the group'
/
comment on column ALL_REFRESH_CHILDREN.NEXT_DATE is
'Date that this job will next be automatically refreshed, if not broken'
/
comment on column ALL_REFRESH_CHILDREN.INTERVAL is
'A date function used to compute the next NEXT_DATE'
/
comment on column ALL_REFRESH_CHILDREN.BROKEN is
'Y or N, Y is the job is broken and will never be run'
/
drop public synonym ALL_REFRESH_CHILDREN
/
create public synonym ALL_REFRESH_CHILDREN for ALL_REFRESH_CHILDREN
/
grant select on ALL_REFRESH_CHILDREN to public with grant option
/


create or replace view USER_REFRESH_CHILDREN
as select * from dba_refresh_children where rowner = user
/
comment on table USER_REFRESH_CHILDREN is
'All the objects in refresh groups, where the user owns the refresh group'
/
comment on column USER_REFRESH_CHILDREN.OWNER is
'Owner of the object in the refresh group'
/
comment on column USER_REFRESH_CHILDREN.NAME is
'Name of the object in the refresh group'
/
comment on column USER_REFRESH_CHILDREN.TYPE is
'Type of the object in the refresh group'
/
comment on column USER_REFRESH_CHILDREN.ROWNER is
'Name of the owner of the refresh group'
/
comment on column USER_REFRESH_CHILDREN.RNAME is
'Name of the refresh group'
/
comment on column USER_REFRESH_CHILDREN.REFGROUP is
'Internal identifier of refresh group'
/
comment on column USER_REFRESH_CHILDREN.IMPLICIT_DESTROY is
'Y or N, if Y then destroy the refresh group when its last item is subtracted'
/
comment on column USER_REFRESH_CHILDREN.PUSH_DEFERRED_RPC is
'Y or N, if Y then push changes from snapshot to master before refresh'
/
comment on column USER_REFRESH_CHILDREN.REFRESH_AFTER_ERRORS is
'If Y, proceed with refresh despite error when pushing deferred RPCs'
/
comment on column USER_REFRESH_CHILDREN.ROLLBACK_SEG is
'Name of the rollback segment to use while refreshing'
/
comment on column USER_REFRESH_CHILDREN.JOB is
'Identifier of job used to automatically refresh the group'
/
comment on column USER_REFRESH_CHILDREN.NEXT_DATE is
'Date that this job will next be automatically refreshed, if not broken'
/
comment on column USER_REFRESH_CHILDREN.INTERVAL is
'A date function used to compute the next NEXT_DATE'
/
comment on column USER_REFRESH_CHILDREN.BROKEN is
'Y or N, Y is the job is broken and will never be run'
/
drop public synonym USER_REFRESH_CHILDREN
/
create public synonym USER_REFRESH_CHILDREN for USER_REFRESH_CHILDREN
/
grant select on USER_REFRESH_CHILDREN to public with grant option
/
