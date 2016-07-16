rem $Header: catrepad.sql,v 1.4 1996/01/08 17:51:07 rdbmsint Obs $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      catrepad.sql - Create the views and tables required for 
Rem                     Symmetric Replication in Server Manager
Rem    DESCRIPTION
Rem      
Rem    RETURNS
Rem 
Rem    NOTES
Rem      Connects as internal (no password)
Rem    MODIFIED   (MM/DD/YY)
Rem     sjain      11/27/95 -  Lrg diff fix
Rem     sjain      10/10/95 -  Name changes of dba_repcat etc.
Rem       asirna   12/14/94 - fix problem in view dba_admindeftran. add distinc
Rem       asirna   12/05/94 - drop table sys.defcallargs before creating it
Rem       hasun    11/09/94 - merge
Rem       hasun    11/06/94 - alter dbme_defer_print to use package variables
Rem       hasun    11/03/94 - merge
Rem       hasun    11/03/94 - fix *_admin* views
Rem       hasun    11/03/94 - change *_admindeftran to show all destination
Rem       hasun    11/02/94 - change *_adminresolution to show all tables
Rem       hasun    10/27/94 - fix  adminschema views
Rem       hasun    10/20/94 - Creation

--------------------------------------------------------------------------
--- Create the views used by the object lists in the Replication Drawer of
--- Server Manager
--------------------------------------------------------------------------
--- (1)
---
create or replace view DBA_ADMINSCHEMAS
  (SNAME, SITE_TYPE, STATUS, SCOMMENT, OBJ_CNT)
as
select distinct -- masters and masterdefs
  r.gname,
  DECODE(s.masterdef, 'Y', 'Master Def', 'Master'),
  r.status,
  r.schema_comment,
  count(o.oname)  
from
  dba_repgroup r, 
  dba_repsites s,
  dba_repobject o
where
  (r.master = 'Y') and
  (r.gname = s.gname and
    s.dblink in (select global_name from global_name)) and
  (r.gname = o.sname)
group by r.gname, s.masterdef, r.status,  r.schema_comment
union
select distinct
  r.gname,
  'Snapshot',
  r.status,
  r.schema_comment,
  count(o.oname)
from 
  dba_repgroup r,
  dba_repobject o
where    
  (r.master = 'N') and
  (r.gname = o.sname)
group by  r.sname, r.status, r.schema_comment
/
comment on table DBA_ADMINSCHEMAS is
'Information about all replicated schemas'
/
comment on column DBA_ADMINSCHEMAS.SNAME is
'Name of the replicated schema'
/
comment on column DBA_ADMINSCHEMAS.SITE_TYPE is
'Is the site a masterdef, master, or snapshot site for the replicated schema'
/
comment on column DBA_ADMINSCHEMAS.STATUS is
'If the site is a master, the master''s status'
/
comment on column DBA_ADMINSCHEMAS.SCOMMENT is
'Description of the replicated schema'
/
comment on column DBA_ADMINSCHEMAS.OBJ_CNT is
'Number of replicated objects owned by the replicated schema'
/
create or replace view ALL_ADMINSCHEMAS
  (SNAME, SITE_TYPE, STATUS, SCOMMENT, OBJ_CNT)
as
select distinct -- masters and masterdefs
  r.gname,
  DECODE(s.masterdef, 'Y', 'Master Def', 'Master'),
  r.status,
  r.schema_comment,
  count(o.oname)  
from
  dba_repgroup r, 
  dba_repsites s,
  dba_repobject o
where
  (r.master = 'Y') and
  (r.gname = s.gname and
    s.dblink in (select global_name from global_name)) and
  (r.gname = o.sname)
group by r.gname, s.masterdef, r.status,  r.schema_comment
union
select distinct
  r.gname,
  'Snapshot',
  r.status,
  r.schema_comment,
  count(o.oname)
from 
  dba_repgroup r,
  dba_repobject o
where    
  (r.master = 'N') and
  (r.gname = o.sname)
group by  r.gname, r.status, r.schema_comment
/
comment on table ALL_ADMINSCHEMAS is
'Information about replicated schemas'
/
comment on column ALL_ADMINSCHEMAS.SNAME is
'Name of the replicated schema'
/
comment on column ALL_ADMINSCHEMAS.SITE_TYPE is
'Is the site a masterdef, master, or snapshot site for the replicated schema'
/
comment on column ALL_ADMINSCHEMAS.STATUS is
'If the site is a master, the master''s status'
/
comment on column ALL_ADMINSCHEMAS.SCOMMENT is
'Description of the replicated schema'
/
comment on column ALL_ADMINSCHEMAS.OBJ_CNT is
'Count of replicated objects owned by each schema'
/
drop public synonym ALL_ADMINSCHEMAS
/
create public synonym ALL_ADMINSCHEMAS for ALL_ADMINSCHEMAS
/
grant select on ALL_ADMINSCHEMAS to PUBLIC with grant option
/
create or replace view USER_ADMINSCHEMAS
  (SNAME, SITE_TYPE, STATUS, SCOMMENT, OBJ_CNT)
as
select distinct -- masters and masterdefs
  r.gname,
  DECODE(s.masterdef, 'Y', 'Master Def', 'Master'),
  r.status,
  r.schema_comment,
  count(o.oname)  
from
  dba_repgroup r, 
  dba_repsites s,
  dba_repobject o
where
  (r.master = 'Y') and
  (r.gname = s.gname and
    s.dblink in (select global_name from global_name)) and
  (r.gname = o.sname)
group by r.gname, s.masterdef, r.status,  r.schema_comment
union
select distinct
  r.gname,
  'Snapshot',
  r.status,
  r.schema_comment,
  count(o.oname)
from 
  dba_repgroup r,
  dba_repobject o
where    
  (r.master = 'N') and
  (r.gname = o.sname)
group by  r.gname, r.status, r.schema_comment
/
comment on table USER_ADMINSCHEMAS is
'Replication information about the current user'
/
comment on column USER_ADMINSCHEMAS.SNAME is
'Name of the user'
/
comment on column USER_ADMINSCHEMAS.SITE_TYPE is
'Is the site a masterdef, master, or snapshot site for the replicated schema'
/
comment on column USER_ADMINSCHEMAS.STATUS is
'If site is master, the master''s status'
/
comment on column USER_ADMINSCHEMAS.SCOMMENT is
'User description of the replicated schema'
/
comment on column USER_ADMINSCHEMAS.OBJ_CNT is
'Count of replicated objects owned by the user'
/
drop public synonym USER_ADMINSCHEMAS
/
create public synonym USER_ADMINSCHEMAS for USER_ADMINSCHEMAS
/
grant select on USER_ADMINSCHEMAS to PUBLIC with grant option
/

--- (2)
---
create or replace view DBA_ADMINOBJECTS
  (SNAME, ONAME, TYPE, STATUS, OCOMMENT)
as
select distinct
  r.gname,
  r.oname,
  r.type,
  r.status,
  r.object_comment
from
  dba_repobject r
/
comment on table DBA_ADMINOBJECTS is
'Information about replicated objects'
/
comment on column DBA_ADMINOBJECTS.SNAME is
'Name of the object owner'
/
comment on column DBA_ADMINOBJECTS.ONAME is
'Name of the object'
/
comment on column DBA_ADMINOBJECTS.TYPE is
'Type of the object'
/
comment on column DBA_ADMINOBJECTS.STATUS is
'Status of the last create or alter request on the local object'
/
comment on column DBA_ADMINOBJECTS.OCOMMENT is
'Description of the replicated object'
/
create or replace view ALL_ADMINOBJECTS
  (SNAME, ONAME, TYPE, STATUS, OCOMMENT)
as
select distinct
  r.gname,
  r.oname,
  r.type,
  r.status,
  r.object_comment
from
  all_repobject r
/
comment on table ALL_ADMINOBJECTS is
'Information about replicated objects'
/
comment on column ALL_ADMINOBJECTS.SNAME is
'Name of the object owner'
/
comment on column ALL_ADMINOBJECTS.ONAME is
'Name of the object'
/
comment on column ALL_ADMINOBJECTS.TYPE is
'Type of the object'
/
comment on column ALL_ADMINOBJECTS.STATUS is
'Status of the last create or alter request on the local object'
/
comment on column ALL_ADMINOBJECTS.OCOMMENT is
'Description of the replicated object'
/
drop public synonym ALL_ADMINOBJECTS
/
create public synonym ALL_ADMINOBJECTS for ALL_ADMINOBJECTS
/
grant select on ALL_ADMINOBJECTS to PUBLIC with grant option
/
create or replace view USER_ADMINOBJECTS
  (SNAME, ONAME, TYPE, STATUS, OCOMMENT)
as
select distinct
  r.gname,
  r.oname,
  r.type,
  r.status,
  r.object_comment
from
  user_repobject r
/
comment on table USER_ADMINOBJECTS is
'Replication information about the current user''s objects'
/
comment on column USER_ADMINOBJECTS.SNAME is
'Name of the user'
/
comment on column USER_ADMINOBJECTS.ONAME is
'Name of the object'
/
comment on column USER_ADMINOBJECTS.TYPE is
'Type of the object'
/
comment on column USER_ADMINOBJECTS.STATUS is
'Status of the last create or alter request on the local object'
/
comment on column USER_ADMINOBJECTS.OCOMMENT is
'User description of the replicated object'
/
drop public synonym USER_ADMINOBJECTS
/
create public synonym USER_ADMINOBJECTS for USER_ADMINOBJECTS
/
grant select on USER_ADMINOBJECTS to PUBLIC with grant option
/


--- (3)
---
create or replace view DBA_ADMINMASTERS
  (SNAME, DBLINK, MASTERDEF, SNAPMASTER, MCOMMENT)
as
select distinct
  r.gname,
  r.dblink,
  DECODE(r.masterdef, 'Y', 'Yes', 'No'),
  DECODE(r.snapmaster, 'Y', 'Yes', 'No'),
  r.master_comment
from
  dba_repsites r
where
  r.dblink not in (select global_name from global_name)
/
comment on table DBA_ADMINMASTERS is
'N-way replication information'
/
comment on column DBA_ADMINMASTERS.SNAME is
'Name of the replicated schema'
/
comment on column DBA_ADMINMASTERS.DBLINK is
'A database site replicating the schema'
/
comment on column DBA_ADMINMASTERS.MASTERDEF is
'Is the database the master definition site for the replicated schema'
/
comment on column DBA_ADMINMASTERS.SNAPMASTER is
'For a snapshot site, is the database the current refresh master'
/
comment on column DBA_ADMINMASTERS.MCOMMENT is
'Description of the database site'
/
create or replace view ALL_ADMINMASTERS
  (SNAME, DBLINK, MASTERDEF, SNAPMASTER, MCOMMENT)
as
select distinct
  r.gname,
  r.dblink,
  DECODE(r.masterdef, 'Y', 'Yes', 'No'),
  DECODE(r.snapmaster, 'Y', 'Yes', 'No'),
  r.master_comment
from
  all_repsites r
where
  r.dblink not in (select global_name from global_name)
/
comment on table ALL_ADMINMASTERS is
'N-way replication information'
/
comment on column ALL_ADMINMASTERS.SNAME is
'Name of the replicated schema'
/
comment on column ALL_ADMINMASTERS.DBLINK is
'A database site replicating the schema'
/
comment on column ALL_ADMINMASTERS.MASTERDEF is
'Is the database the master definition site for the replicated schema'
/
comment on column ALL_ADMINMASTERS.SNAPMASTER is
'For a snapshot site, is the database the current refresh master'
/
comment on column ALL_ADMINMASTERS.MCOMMENT is
'Description of the database site'
/
drop public synonym ALL_ADMINMASTERS
/
create public synonym ALL_ADMINMASTERS for ALL_ADMINMASTERS
/
grant select on ALL_ADMINMASTERS to PUBLIC with grant option
/
create or replace view USER_ADMINMASTERS
  (SNAME, DBLINK, MASTERDEF, SNAPMASTER, MCOMMENT)
as
select distinct
  r.gname,
  r.dblink,
  DECODE(r.masterdef, 'Y', 'Yes', 'No'),
  DECODE(r.snapmaster, 'Y', 'Yes', 'No'),
  r.master_comment
from
  user_repsites r
where
  r.dblink not in (select global_name from global_name)
/
comment on table USER_ADMINMASTERS is
'N-way replication information about the current user'
/
comment on column USER_ADMINMASTERS.SNAME is
'Name of the user'
/
comment on column USER_ADMINMASTERS.DBLINK is
'A database site replicating the schema'
/
comment on column USER_ADMINMASTERS.MASTERDEF is
'Is the database the master definition site for the replicated schema'
/
comment on column USER_ADMINMASTERS.SNAPMASTER is
'For snapshot sites, is the database the current refresh master'
/
comment on column USER_ADMINMASTERS.MCOMMENT is
'User description of the database site'
/
drop public synonym USER_ADMINMASTERS
/
create public synonym USER_ADMINMASTERS for USER_ADMINMASTERS
/
grant select on USER_ADMINMASTERS to PUBLIC with grant option
/


--- (4)
---
create or replace view DBA_ADMINRESOLUTION
  (SNAME, ONAME, UPD_CNT, UNQ_CNT, DEL_CNT)
as
select
  o.sname,
  o.oname,
  SUM(DECODE(r.conflict_type, 'UPDATE', 1, 0)),
  SUM(DECODE(r.conflict_type, 'UNIQUE', 1, 0)),
  SUM(DECODE(r.conflict_type, 'DELETE', 1, 0))
from
  dba_repobject o, dba_represolution r
where
  (o.type = 'TABLE') and
  (o.oname = r.oname (+) and o.sname = r.sname (+))
group by
  o.sname, o.oname
/
comment on table DBA_ADMINRESOLUTION is
'Description of all conflict resolutions in the database'
/
comment on column DBA_ADMINRESOLUTION.SNAME is
'Name of the replicated schema'
/
comment on column DBA_ADMINRESOLUTION.ONAME is
'Name of the replicated table'
/
comment on column DBA_ADMINRESOLUTION.UPD_CNT is
'Number of update conlict resolution functions declared'
/
comment on column DBA_ADMINRESOLUTION.UNQ_CNT is
'Number of uniqueness conlict resolution functions declared'
/
comment on column DBA_ADMINRESOLUTION.DEL_CNT is
'Number of delete conlict resolution functions declared'
/
create or replace view ALL_ADMINRESOLUTION
  (SNAME, ONAME, UPD_CNT, UNQ_CNT, DEL_CNT)
as
select
  o.sname,
  o.oname,
  SUM(DECODE(r.conflict_type, 'UPDATE', 1, 0)),
  SUM(DECODE(r.conflict_type, 'UNIQUE', 1, 0)),
  SUM(DECODE(r.conflict_type, 'DELETE', 1, 0))
from
  all_repobject o, all_represolution r
where
  (o.type = 'TABLE') and
  (o.oname = r.oname (+) and o.sname = r.sname (+))
group by
  o.sname, o.oname
/
comment on table ALL_ADMINRESOLUTION is
'Description of all conflict resolutions in the database'
/
comment on column ALL_ADMINRESOLUTION.SNAME is
'Name of the replicated schema'
/
comment on column ALL_ADMINRESOLUTION.ONAME is
'Name of the replicated table'
/
comment on column ALL_ADMINRESOLUTION.UPD_CNT is
'Number of update conlict resolution functions declared'
/
comment on column ALL_ADMINRESOLUTION.UNQ_CNT is
'Number of uniqueness conlict resolution functions declared'
/
comment on column ALL_ADMINRESOLUTION.DEL_CNT is
'Number of delete conlict resolution functions declared'
/
drop public synonym ALL_ADMINRESOLUTION
/
create public synonym ALL_ADMINRESOLUTION for ALL_ADMINRESOLUTION
/
grant select on ALL_ADMINRESOLUTION to PUBLIC with grant option
/
create or replace view USER_ADMINRESOLUTION
  (SNAME, ONAME, UPD_CNT, UNQ_CNT, DEL_CNT)
as
select
  o.sname,
  o.oname,
  SUM(DECODE(r.conflict_type, 'UPDATE', 1, 0)),
  SUM(DECODE(r.conflict_type, 'UNIQUE', 1, 0)),
  SUM(DECODE(r.conflict_type, 'DELETE', 1, 0))
from
  user_repobject o, user_represolution r
where
  (o.type = 'TABLE') and
  (o.oname = r.oname (+) and o.sname in (select user from dual))
group by
  o.sname, o.oname
/
comment on table USER_ADMINRESOLUTION is
'Description of all conflict resolutions in the database'
/
comment on column USER_ADMINRESOLUTION.SNAME is
'Name of the replicated schema'
/
comment on column USER_ADMINRESOLUTION.ONAME is
'Name of the replicated table'
/
comment on column USER_ADMINRESOLUTION.UPD_CNT is
'Number of update conlict resolution functions declared'
/
comment on column USER_ADMINRESOLUTION.UNQ_CNT is
'Number of uniqueness conlict resolution functions declared'
/
comment on column USER_ADMINRESOLUTION.DEL_CNT is
'Number of delete conlict resolution functions declared'
/
drop public synonym USER_ADMINRESOLUTION
/
create public synonym USER_ADMINRESOLUTION for USER_ADMINRESOLUTION
/
grant select on USER_ADMINRESOLUTION to PUBLIC with grant option
/


--- (5)
---
create or replace view DBA_ADMINDEFTRAN
  (DST_LNK, TRN_CNT, LS_TIME, FAILURES, BROKEN)
as
select 
  r.dblink,
  count(distinct d.deferred_tran_id),
  s.last_date,
  DECODE(j.failures, NULL, 0, j.failures),
  DECODE(j.broken, NULL, 'Job Not Found', 'Y', 'Yes', 'No')
from
  deftrandest d, defschedule s, dba_jobs j, dba_repsites r
where
 ((r.dblink not in (select global_name from global_name)) and
    (r.snapmaster = 'Y' or r.snapmaster is NULL)) and
  (r.dblink = d.dblink (+)) and
  (d.dblink = s.dblink (+)) and
  (s.job = j.job (+))
group by r.dblink, s.last_date, j.failures, j.broken
/
comment on table DBA_ADMINDEFTRAN is
'Descriptions of all queued deferred transactions at the local site'
/
comment on column DBA_ADMINDEFTRAN.DST_LNK is
'Destination to which the transactions will be propogated'
/
comment on column DBA_ADMINDEFTRAN.TRN_CNT is
'Number of transactions queued for each destination'
/
comment on column DBA_ADMINDEFTRAN.LS_TIME is
'Last time of push for each destination by the jobqueues process'
/
comment on column DBA_ADMINDEFTRAN.FAILURES is
'Number of failures which attempting to push the queue for each dest'
/
comment on column DBA_ADMINDEFTRAN.BROKEN is
'Broken status if the jobqueues process which pushes the transactions'
/


--- (6)
---
create or replace view DBA_ADMINDEFERROR
  (DB, ID, CALLNO, DESTINATION, ERROR_TIME, ERROR_NUMBER, 
   ERROR_MSG)
as
select
  deferred_tran_db,
  deferred_tran_id,
  callno,
  destination,
  error_time,
  error_number,
  error_msg
from
  deferror
/
comment on table DBA_ADMINDEFERROR is
'Information on unresolved error occuring at the local site'
/
comment On column DBA_ADMINDEFERROR.DB is
'Global database name of initiating database'
/
comment on column DBA_ADMINDEFERROR.ID is
'Unique ID assigned to deferred transaction causing error'
/
comment on column DBA_ADMINDEFERROR.DESTINATION is
'DBLink used to address destination'
/
comment on column DBA_ADMINDEFERROR.ERROR_TIME is
'Time of error'
/
comment on column DBA_ADMINDEFERROR.ERROR_NUMBER is
'Oracle error number'
/
comment on column DBA_ADMINDEFERROR.ERROR_MSG is
'Error message text'
/


--- (7) 
--- 
create or replace view DBA_ADMINCATLOG
  (ID, SOURCE, USERID, TIMESTAMP, ROLE, REQUEST, ONAME, SNAME, 
   STATUS, MESSAGE, ERRNUM)
as
select
  id,
  source,
  userid,
  timestamp,
  role,
  request,
  oname,
  sname,
  status,
  message,
  errnum
from
  dba_repcatlog
/
comment on table DBA_ADMINCATLOG is
'Information about asynchronous administration requests'
/
comment on column DBA_ADMINCATLOG.ID is
'Identifying number of repcat log record'
/
comment on column DBA_ADMINCATLOG.SOURCE is
'Name of the database at which the request originated'
/
comment on column DBA_ADMINCATLOG.STATUS is
'Status of the request at this database'
/
comment on column DBA_ADMINCATLOG.USERID is
'Name of the user who submitted the request'
/
comment on column DBA_ADMINCATLOG.TIMESTAMP is
'When the request was submitted'
/
comment on column DBA_ADMINCATLOG.ROLE is
'Is this database the masterdef for the request'
/
comment on column DBA_ADMINCATLOG.SNAME is
'Name of the replicated schema'
/
comment on column DBA_ADMINCATLOG.REQUEST is
'Name of the requested operation'
/
comment on column DBA_ADMINCATLOG.ONAME is
'Replicated object name, if applicable'
/
comment on column DBA_ADMINCATLOG.MESSAGE is
'Error message associated with processing the request'
/
comment on column DBA_ADMINCATLOG.ERRNUM is
'Oracle error number associated with processing the request'
/
create or replace view ALL_ADMINCATLOG
  (ID, SOURCE, USERID, TIMESTAMP, ROLE, REQUEST, ONAME, SNAME, 
   STATUS, MESSAGE, ERRNUM)
as
select
  id,
  source,
  userid,
  timestamp,
  role,
  request,
  oname,
  sname,
  status,
  message,
  errnum
from
  all_repcatlog
/
comment on table ALL_ADMINCATLOG is
'Information about asynchronous administration requests'
/
comment on column ALL_ADMINCATLOG.ID is
'Identifying number of repcat log record'
/
comment on column ALL_ADMINCATLOG.SOURCE is
'Name of the database at which the request originated'
/
comment on column ALL_ADMINCATLOG.USERID is
'Name of the user who submitted the request'
/
comment on column ALL_ADMINCATLOG.TIMESTAMP is
'When the request was submitted'
/
comment on column ALL_ADMINCATLOG.ROLE is
'Is this database the masterdef for the request'
/
comment on column ALL_ADMINCATLOG.SNAME is
'Name of the replicated schema'
/
comment on column ALL_ADMINCATLOG.REQUEST is
'Name of the requested operation'
/
comment on column ALL_ADMINCATLOG.ONAME is
'Replicated object name, if applicable'
/
comment on column ALL_ADMINCATLOG.STATUS is
'Status of the request at this database'
/
comment on column ALL_ADMINCATLOG.MESSAGE is
'Error message associated with processing the request'
/
comment on column ALL_ADMINCATLOG.ERRNUM is
'Oracle error number associated with processing the request'
/
drop public synonym ALL_ADMINCATLOG
/
create public synonym ALL_ADMINCATLOG for ALL_ADMINCATLOG
/
grant select on ALL_ADMINCATLOG to PUBLIC with grant option
/
create or replace view USER_ADMINCATLOG
  (ID, SOURCE, USERID, TIMESTAMP, ROLE, REQUEST, ONAME, SNAME, 
   STATUS, MESSAGE, ERRNUM)
as
select
  id,
  source,
  userid,
  timestamp,
  role,
  request,
  oname,
  sname,
  status,
  message,
  errnum
from
  user_repcatlog
/
comment on table USER_ADMINCATLOG is
'Information about the current user''s asynchronous administration requests'
/
comment on column USER_ADMINCATLOG.ID is
'Identifying number of repcat log record'
/
comment on column USER_ADMINCATLOG.SOURCE is
'Name of the database at which the request originated'
/
comment on column USER_ADMINCATLOG.USERID is
'Name of the user who submitted the request'
/
comment on column USER_ADMINCATLOG.TIMESTAMP is
'When the request was submitted'
/
comment on column USER_ADMINCATLOG.ROLE is
'Is this database the masterdef for the request'
/
comment on column USER_ADMINCATLOG.SNAME is
'Name of the replicated schema'
/
comment on column USER_ADMINCATLOG.REQUEST is
'Name of the requested operation'
/
comment on column USER_ADMINCATLOG.ONAME is
'Replicated object name, if applicable'
/
comment on column USER_ADMINCATLOG.STATUS is
'Status of the request at this database'
/
comment on column USER_ADMINCATLOG.MESSAGE is
'Error message associated with processing the request'
/
comment on column USER_ADMINCATLOG.ERRNUM is
'Oracle error number associated with processing the request'
/
drop public synonym USER_ADMINCATLOG
/
create public synonym USER_ADMINCATLOG for USER_ADMINCATLOG
/
grant select on USER_ADMINCATLOG to PUBLIC with grant option
/


--- (8)
---
create or replace view DBA_ADMINREGSNAPS
  (NAME, SNAME, TABLE_NAME, M_VIEW, M_OWNER, MASTER, M_LINK, LOG,
    UPD, LAST_REFRESH, ERROR, TYPE, NEXT, START_W, RG, UPD_TRG, 
    UPD_LOG, QRY, OBJ_COM)
as
select
  s.name,
  s.owner,
  s.table_name,
  s.master_view,
  s.master_owner,
  s.master,
  s.master_link,
  s.can_use_log,
  s.updatable,
  s.last_refresh,
  s.error,
  s.type,
  s.next,
  s.start_with,
  f.rname,
  s.update_trig,
  s.update_log,
  s.query,
  r.object_comment
from 
  dba_snapshots s, 
  dba_repobject r,
  dba_refresh f
where
  r.type = 'SNAPSHOT' and
  (s.name = r.oname  and s.owner = r.sname) and
  s.refresh_group = f.refgroup (+)
/
comment on table DBA_ADMINREGSNAPS is
'All snapshots in the database'
/
comment on column DBA_ADMINREGSNAPS.SNAME is
'Owner of the snapshot'
/
comment on column DBA_ADMINREGSNAPS.NAME is
'The view used by users and applications for viewing the snapshot'
/
comment on column DBA_ADMINREGSNAPS.TABLE_NAME is
'Table the snapshot is stored in -- has an extra column for the master rowid'
/
comment on column DBA_ADMINREGSNAPS.M_VIEW is
'View of the master table, owned by the snapshot owner, used for refreshes'
/
comment on column DBA_ADMINREGSNAPS.M_OWNER is
'Owner of the master table'
/
comment on column DBA_ADMINREGSNAPS.MASTER is
'Name of the master table that this snapshot is a copy of'
/
comment on column DBA_ADMINREGSNAPS.M_LINK is
'Database link name to the master site'
/
comment on column DBA_ADMINREGSNAPS.LOG is
'If NO, this snapshot is complex and will never use a log'
/
comment on column DBA_ADMINREGSNAPS.UPD is
'If NO, the snapshot is read only.  Look up REPLICATION'
/
comment on column DBA_ADMINREGSNAPS.LAST_REFRESH is
'SYSDATE from the master site at the time of the last refresh'
/
comment on column DBA_ADMINREGSNAPS.ERROR is
'The number of failed automatic refreshes since last successful refresh'
/
comment on column DBA_ADMINREGSNAPS.TYPE is
'The type of refresh (complete,fast,force) for all automatic refreshes'
/
comment on column DBA_ADMINREGSNAPS.NEXT is
'The date function used to compute next refresh dates'
/
comment on column DBA_ADMINREGSNAPS.START_W is
'The date function used to compute next refresh dates'
/
comment on column DBA_ADMINREGSNAPS.RG is
'All snapshots in a given refresh group get refreshed in the same transaction'
/
comment on column DBA_ADMINREGSNAPS.UPD_TRG is
'The name of the trigger which fills the UPDATE_LOG'
/
comment on column DBA_ADMINREGSNAPS.UPD_LOG is
'The table which logs changes made to an updatable snapshots'
/
comment on column DBA_ADMINREGSNAPS.QRY is
'The original query that this snapshot is an instantiation of'
/
comment on column DBA_ADMINREGSNAPS.OBJ_COM is
'Description for snapshot'
/
create or replace view ALL_ADMINREGSNAPS
  (NAME, SNAME, TABLE_NAME, M_VIEW, M_OWNER, MASTER, M_LINK, LOG,
    UPD, LAST_REFRESH, ERROR, TYPE, NEXT, START_W, RG, UPD_TRG, 
    UPD_LOG, QRY, OBJ_COM)
as
select
  s.name,
  s.owner,
  s.table_name,
  s.master_view,
  s.master_owner,
  s.master,
  s.master_link,
  s.can_use_log,
  s.updatable,
  s.last_refresh,
  s.error,
  s.type,
  s.next,
  s.start_with,
  f.rname,
  s.update_trig,
  s.update_log,
  s.query,
  r.object_comment
from 
  all_snapshots s, 
  all_repobject r,
  all_refresh f
where
  r.type = 'SNAPSHOT' and
  (s.name = r.oname  and s.owner = r.sname) and
  s.refresh_group = f.refgroup (+)
/
comment on table ALL_ADMINREGSNAPS is
'All snapshots in the database'
/
comment on column ALL_ADMINREGSNAPS.SNAME is
'Owner of the snapshot'
/
comment on column ALL_ADMINREGSNAPS.NAME is
'The view used by users and applications for viewing the snapshot'
/
comment on column ALL_ADMINREGSNAPS.TABLE_NAME is
'Table the snapshot is stored in -- has an extra column for the master rowid'
/
comment on column ALL_ADMINREGSNAPS.M_VIEW is
'View of the master table, owned by the snapshot owner, used for refreshes'
/
comment on column ALL_ADMINREGSNAPS.M_OWNER is
'Owner of the master table'
/
comment on column ALL_ADMINREGSNAPS.MASTER is
'Name of the master table that this snapshot is a copy of'
/
comment on column ALL_ADMINREGSNAPS.M_LINK is
'Database link name to the master site'
/
comment on column ALL_ADMINREGSNAPS.LOG is
'If NO, this snapshot is complex and will never use a log'
/
comment on column ALL_ADMINREGSNAPS.UPD is
'If NO, the snapshot is read only.  Look up REPLICATION'
/
comment on column ALL_ADMINREGSNAPS.LAST_REFRESH is
'SYSDATE from the master site at the time of the last refresh'
/
comment on column ALL_ADMINREGSNAPS.ERROR is
'The number of failed automatic refreshes since last successful refresh'
/
comment on column ALL_ADMINREGSNAPS.TYPE is
'The type of refresh (complete,fast,force) for all automatic refreshes'
/
comment on column ALL_ADMINREGSNAPS.NEXT is
'The date function used to compute next refresh dates'
/
comment on column ALL_ADMINREGSNAPS.START_W is
'The date function used to compute next refresh dates'
/
comment on column ALL_ADMINREGSNAPS.RG is
'All snapshots in a given refresh group get refreshed in the same transaction'
/
comment on column ALL_ADMINREGSNAPS.UPD_TRG is
'The name of the trigger which fills the UPDATE_LOG'
/
comment on column ALL_ADMINREGSNAPS.UPD_LOG is
'The table which logs changes made to an updatable snapshots'
/
comment on column ALL_ADMINREGSNAPS.QRY is
'The original query that this snapshot is an instantiation of'
/
comment on column ALL_ADMINREGSNAPS.OBJ_COM is
'Description for snapshot'
/
drop public synonym ALL_ADMINREGSNAPS
/
create public synonym ALL_ADMINREGSNAPS for ALL_ADMINREGSNAPS
/
grant select on ALL_ADMINREGSNAPS to public with grant option
/
create or replace view USER_ADMINREGSNAPS
  (NAME, SNAME, TABLE_NAME, M_VIEW, M_OWNER, MASTER, M_LINK, LOG,
    UPD, LAST_REFRESH, ERROR, TYPE, NEXT, START_W, RG, UPD_TRG, 
    UPD_LOG, QRY, OBJ_COM)
as
select
  s.name,
  s.owner,
  s.table_name,
  s.master_view,
  s.master_owner,
  s.master,
  s.master_link,
  s.can_use_log,
  s.updatable,
  s.last_refresh,
  s.error,
  s.type,
  s.next,
  s.start_with,
  f.rname,
  s.update_trig,
  s.update_log,
  s.query,
  r.object_comment
from 
  user_snapshots s, 
  user_repobject r,
  user_refresh f
where
  r.type = 'SNAPSHOT' and
  (s.name = r.oname  and s.owner = r.sname) and
  s.refresh_group = f.refgroup (+)
/
comment on table USER_ADMINREGSNAPS is
'All snapshots in the database'
/
comment on column USER_ADMINREGSNAPS.SNAME is
'Owner of the snapshot'
/
comment on column USER_ADMINREGSNAPS.NAME is
'The view used by users and applications for viewing the snapshot'
/
comment on column USER_ADMINREGSNAPS.TABLE_NAME is
'Table the snapshot is stored in -- has an extra column for the master rowid'
/
comment on column USER_ADMINREGSNAPS.M_VIEW is
'View of the master table, owned by the snapshot owner, used for refreshes'
/
comment on column USER_ADMINREGSNAPS.M_OWNER is
'Owner of the master table'
/
comment on column USER_ADMINREGSNAPS.MASTER is
'Name of the master table that this snapshot is a copy of'
/
comment on column USER_ADMINREGSNAPS.M_LINK is
'Database link name to the master site'
/
comment on column USER_ADMINREGSNAPS.LOG is
'If NO, this snapshot is complex and will never use a log'
/
comment on column USER_ADMINREGSNAPS.UPD is
'If NO, the snapshot is read only.  Look up REPLICATION'
/
comment on column USER_ADMINREGSNAPS.LAST_REFRESH is
'SYSDATE from the master site at the time of the last refresh'
/
comment on column USER_ADMINREGSNAPS.ERROR is
'The number of failed automatic refreshes since last successful refresh'
/
comment on column USER_ADMINREGSNAPS.TYPE is
'The type of refresh (complete,fast,force) for all automatic refreshes'
/
comment on column USER_ADMINREGSNAPS.NEXT is
'The date function used to compute next refresh dates'
/
comment on column USER_ADMINREGSNAPS.START_W is
'The date function used to compute next refresh dates'
/
comment on column USER_ADMINREGSNAPS.RG is
'All snapshots in a given refresh group get refreshed in the same transaction'
/
comment on column USER_ADMINREGSNAPS.UPD_TRG is
'The name of the trigger which fills the UPDATE_LOG'
/
comment on column USER_ADMINREGSNAPS.UPD_LOG is
'The table which logs changes made to an updatable snapshots'
/
comment on column USER_ADMINREGSNAPS.QRY is
'The original query that this snapshot is an instantiation of'
/
comment on column USER_ADMINREGSNAPS.OBJ_COM is
'Description for snapshot'
/
drop public synonym USER_ADMINREGSNAPS
/
create public synonym USER_ADMINREGSNAPS for USER_ADMINREGSNAPS
/
grant select on USER_ADMINREGSNAPS to public with grant option
/

commit
/

-----------------------------------------------------
--- Load the package to print deferred call arguments
-----------------------------------------------------
CREATE OR REPLACE PACKAGE dbms_defer_print IS

  PROCEDURE print_deftran(deferred_tran_id IN VARCHAR2 := NULL,
                          deferred_tran_db IN VARCHAR2 := NULL,
                          destination      IN VARCHAR2 := NULL,
                          callno           IN NUMBER,
                          date_format      IN VARCHAR2 :=
                                              'YY:MM:DD:HH24:MI:SS',
                          save_output      IN BOOLEAN := FALSE,
                          schema_name      IN VARCHAR2 := NULL,
                          table_name       IN VARCHAR2 := NULL,
                          tag              IN VARCHAR2 := NULL);
  -- Use dbms_output to print information about deferred remote procedure calls
  -- for transactions in deftran.  For each deferred call, the procedure prints
  -- information about each parameter including its name, datatype, and value.
  -- The name and datatype are determined by describing the local version of
  -- the procedure.
  --
  -- The first three parameters can be used to limit which transactions are
  -- printed.  For these parameters, a NULL is treated as a wildcard.
  -- The date_format parameter is the format for printing dates.
  -- If save_output is TRUE, the output is saved in the table given by
  -- schema_name and table_name and the TAG column is filled with the
  -- value of parameter tag.  The output table must have at least the columns
  -- in a table created by create_unpacked_table.

  PROCEDURE print_deferror(deferred_tran_id IN VARCHAR2 := NULL,
                           deferred_tran_db IN VARCHAR2 := NULL,
                           callno           IN NUMBER,
                           date_format      IN VARCHAR2 :=
                                              'YY:MM:DD:HH24:MI:SS',
                           save_output      IN BOOLEAN := FALSE,
                           schema_name      IN VARCHAR2 := NULL,
                           table_name       IN VARCHAR2 := NULL,
                           tag              IN VARCHAR2 := NULL);
  -- Use dbms_output to print information about deferred remote procedure calls
  -- for transactions in deferror.  For each deferred call, the procedure
  -- prints information about each parameter including its name, datatype,
  -- and value.
  --
  -- The first two parameters can be used to limit which transactions are
  -- printed.  For these parameters, a NULL is treated as a wildcard.
  -- The date_format parameter is the format for printing dates.
  -- If save_output is TRUE, the output is saved in the table given by
  -- schema_name and table_name and the TAG column is filled with the
  -- value of parameter tag.  The output table must have at least the columns
  -- in a table created by create_unpacked_table.

  PROCEDURE create_unpacked_table(schema_name IN VARCHAR2 := NULL,
                                  table_name  IN VARCHAR2 := NULL);
  -- Create a table for unpacking the information about deferred remote
  -- procedure calls.  A NULL schema_name uses the current schema, while
  -- a NULL table_name uses 'DEFUNPACKED'.

  FUNCTION return_name(idx IN BINARY_INTEGER) RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(return_name, WNDS, WNPS);

  FUNCTION return_type(idx IN BINARY_INTEGER) RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(return_type, WNDS, WNPS);

  FUNCTION return_value(idx IN BINARY_INTEGER) RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(return_value, WNDS, WNPS);


END dbms_defer_print;
/
show errors


CREATE OR REPLACE PACKAGE BODY dbms_defer_print IS

  TYPE argnmtab IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
  TYPE argtptab IS TABLE OF VARCHAR2(8) INDEX BY BINARY_INTEGER;
  TYPE argvltab IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

  local_node VARCHAR2(128);      -- cache global_name column from global_name
  num_args number;               -- number of arguments
  arg_names argnmtab;                     -- argument names
  arg_types argtptab;                     -- argument types
  arg_values argvltab;                    -- argument values

  PROCEDURE canonicalize(name       IN  VARCHAR2,
                         canon_name OUT VARCHAR2,
                         canon_len  IN  NUMBER) IS
  -- canonicalize the given non-NULL string
  -- if name begins and ends with a double quote, remove both
  -- otherwise, convert to upper case with NLS_UPPER
  -- return the first canon_len characters in canon_name
  name_length NUMBER;

  BEGIN
    name_length := LENGTH(name);
    IF SUBSTR(name, 1, 1) = '"' AND SUBSTR(name, name_length, 1) = '"' THEN
      canon_name := SUBSTR(SUBSTR(name, 2, name_length-2), 1, canon_len);
    ELSE canon_name := NLS_UPPER(SUBSTR(name, 1, canon_len));
    END IF;
  END canonicalize;


  PROCEDURE get_unpacked_table_name(schema_name IN  VARCHAR2,
                                    table_name  IN  VARCHAR2,
                                    output      OUT VARCHAR2) IS
  -- supply defaults for NULL parameters
  real_schema VARCHAR2(33);
  real_table  VARCHAR2(32);
  canon_name  VARCHAR2(30);

  BEGIN
    IF schema_name IS NULL THEN real_schema := NULL;
    ELSE
      canonicalize(schema_name, canon_name, 30);
      real_schema := '"' || canon_name || '".';
    END IF;
    IF table_name IS NULL THEN real_table := 'DEFUNPACKED';
    ELSE
      canonicalize(table_name, canon_name, 30);
      real_table := '"' || canon_name || '"';
    END IF;
    output := real_schema || real_table;
  END get_unpacked_table_name;


  FUNCTION advance(tab_values IN dbms_describe.number_table,
                   offset     IN BINARY_INTEGER) RETURN BINARY_INTEGER IS
  -- Offset is an index into tab_values.
  -- Calculate the smallest BINARY_INTEGER greater than offset that leads
  -- either to a different value in tab_values or to an empty slot in
  -- tab_values.
  new_offset BINARY_INTEGER := offset + 1;  -- holds the result

  BEGIN
    BEGIN
      WHILE tab_values(new_offset) = tab_values(offset) LOOP
        new_offset := new_offset + 1;
      END LOOP;
    EXCEPTION WHEN no_data_found THEN NULL;
    END;
    RETURN new_offset;
  END advance;


  FUNCTION which_proc(overload         IN dbms_describe.number_table,
                      position         IN dbms_describe.number_table,
                      datatype         IN dbms_describe.number_table,
                      argcount         IN NUMBER,
                      callno           IN NUMBER,
                      deferred_tran_id IN VARCHAR2,
                      deferred_tran_db IN VARCHAR2) RETURN BINARY_INTEGER IS
  -- The first three parameters are from dbms_describe.describe_procedure
  --   and describe all overloaded versions of a given procedure.
  -- The last three parameters identify a deferred call.
  -- Argcount tells how many parameters are in the deferred call.
  -- Determine which version of an overloaded procedure matches the call.
  -- Calculate and return the offset of the first parameter of this version.
  answer          BINARY_INTEGER := 1;  -- points to each first parameter
                                        -- and eventually holds the result
  parameter_index BINARY_INTEGER := 1;  -- iterate over each parameter
  arg             BINARY_INTEGER;
  match           BOOLEAN;
  arg_type        NUMBER;
  describe_type   NUMBER;
  dummy           NUMBER;

  BEGIN
    WHILE TRUE LOOP
      match := TRUE;
      -- iterate over the procedures
      -- if this procedure matches, return the offset
      -- otherwise, advance to the next procedure
      FOR arg IN 1..argcount LOOP
        arg_type := dbms_defer_query.get_arg_type(callno, deferred_tran_db,
                                                  arg, deferred_tran_id);
        -- a deferred RPC maps a CHAR into a VARCHAR2
        describe_type := datatype(parameter_index);
        IF describe_type = dbms_defer.arg_type_char
          AND arg_type = dbms_defer.arg_type_varchar2 THEN
          describe_type := dbms_defer.arg_type_varchar2;
        END IF;
        IF describe_type != arg_type THEN
          match := FALSE;
          EXIT;
        END IF;
        -- advance to next parameter
        parameter_index := advance(position, parameter_index);
      END LOOP;
      IF match THEN RETURN answer;
      END IF;
      -- advance to next procedure, if any
      answer := advance(overload, answer);
      dummy := overload(answer);  -- ensure we have not run off the end
    END LOOP;
  EXCEPTION WHEN no_data_found THEN RETURN 1;   -- safest to start at the top
  END which_proc;


  FUNCTION print_arg(arg              IN BINARY_INTEGER,
                     callno           IN NUMBER,
                     deferred_tran_id IN VARCHAR2,
                     deferred_tran_db IN VARCHAR2,
                     date_format      IN VARCHAR2,
                     offset           IN BINARY_INTEGER,
                     position         IN dbms_describe.number_table,
                     argument_name    IN dbms_describe.varchar2_table,
                     table_name       IN VARCHAR2,
                     tag              IN VARCHAR2,
                     dblink           IN VARCHAR2,
                     delivery_order   IN NUMBER,
                     procedure_name   IN VARCHAR2) RETURN BINARY_INTEGER IS
  -- The first four parameters identify a parameter to a deferred RPC.
  -- Offset, position, and argument_name supply describe information for
  --   the parameter.
  -- Print the parameter's position, name, datatype, and first 200 bytes of
  --   value with dbms_output.
  -- If table_name is not null, insert a row into the given table tagged
  --   with tag.
  -- Return the offset of the next parameter.
  new_offset    BINARY_INTEGER;
  print_type    VARCHAR2(8);
  max_print_len NUMBER := 200;    -- maximum length of parameter we will print
  sql_cursor    NUMBER;
  dummy         NUMBER;
  arg_type      NUMBER;
  arg_num       NUMBER;
  arg_char      CHAR(32767);
  arg_varchar2  VARCHAR2(32767);
  arg_date      DATE;
  arg_rowid     ROWID;
  arg_raw       RAW(32767);
  arg_name      VARCHAR2(30) := argument_name(offset);

  BEGIN
    arg_type := dbms_defer_query.get_arg_type(callno, deferred_tran_db, arg,
                                              deferred_tran_id);
    ---|||
    arg_names(arg) := arg_name;
    ---|||

    IF arg_type = dbms_defer.arg_type_num THEN
      print_type := 'NUMBER';
      arg_num :=
        dbms_defer_query.get_number_arg(callno, deferred_tran_db, arg);
      dbms_output.put_line('--' || TO_CHAR(arg) || '. ' || arg_name ||
                           ' NUMBER: ' || TO_CHAR(arg_num));
    ---|||
      arg_types(arg)  := print_type;
      arg_values(arg) := TO_CHAR(arg_num);
    ---|||
    ELSIF arg_type = dbms_defer.arg_type_char THEN
      print_type := 'CHAR';
      arg_varchar2 := SUBSTR(
         dbms_defer_query.get_char_arg(callno, deferred_tran_db, arg),
         1, max_print_len);
      dbms_output.put_line('--' || TO_CHAR(arg) || '. ' || arg_name ||
                           ' CHAR: ' || arg_varchar2); 
      arg_varchar2 := SUBSTR(
         dbms_defer_query.get_char_arg(callno, deferred_tran_db, arg),
         1, 255);
    ---|||
      arg_types(arg)  := print_type;
      arg_values(arg) := arg_varchar2;
    ---|||
    ELSIF arg_type = dbms_defer.arg_type_varchar2 THEN
      print_type := 'VARCHAR2';
      arg_varchar2 := SUBSTR(
         dbms_defer_query.get_varchar2_arg(callno, deferred_tran_db, arg),
         1, max_print_len);
      dbms_output.put_line('--' || TO_CHAR(arg) || '. ' || arg_name ||
                           ' VARCHAR2: ' || arg_varchar2);
      arg_varchar2 := SUBSTR(
         dbms_defer_query.get_varchar2_arg(callno, deferred_tran_db, arg),
         1, 2000);
    ---|||
      arg_types(arg)  := print_type;
      arg_values(arg) := arg_varchar2;
    ---|||
    ELSIF arg_type = dbms_defer.arg_type_date THEN
      print_type := 'DATE';
      arg_date :=
        dbms_defer_query.get_date_arg(callno, deferred_tran_db, arg);
      dbms_output.put_line('--' || TO_CHAR(arg) || '. ' || arg_name ||
                           ' DATE: ' || TO_CHAR(arg_date, date_format));
    ---|||
      arg_types(arg)  := print_type;
      arg_values(arg) := TO_CHAR(arg_date, date_format);
    ---|||
    ELSIF arg_type = dbms_defer.arg_type_rowid THEN
      print_type := 'ROWID';
      arg_rowid :=
        dbms_defer_query.get_rowid_arg(callno, deferred_tran_db, arg);
      dbms_output.put_line('--' || TO_CHAR(arg) || '. ' || arg_name ||
                           ' ROWID: ' || ROWIDTOCHAR(arg_rowid));
    ---|||
      arg_types(arg)  := print_type;
      arg_values(arg) := ROWIDTOCHAR(arg_rowid);
    ---|||
    ELSIF arg_type = dbms_defer.arg_type_raw THEN
      print_type := 'RAW';
      arg_raw :=  SUBSTR(
         dbms_defer_query.get_raw_arg(callno, deferred_tran_db, arg),
         1, max_print_len);
      dbms_output.put_line('--' || TO_CHAR(arg) || '. ' || arg_name ||
                           ' RAW: ' || RAWTOHEX(arg_raw));
      arg_raw :=  SUBSTR(
         dbms_defer_query.get_raw_arg(callno, deferred_tran_db, arg),
         1, 255);
    ---|||
      arg_types(arg)  := print_type;
      arg_values(arg) := RAWTOHEX(arg_raw);
    ---|||
    ELSE
      RAISE no_data_found;
    END IF;
    IF table_name IS NOT NULL THEN
      sql_cursor := dbms_sql.open_cursor;
      dbms_sys_sql.parse_as_user(sql_cursor,
        ' INSERT INTO ' || table_name || '(' ||
           'tag, deferred_tran_db, deferred_tran_id, dblink, ' ||
           'delivery_order, callno, procedure, argument, argument_name, ' ||
           'argument_type, arg_num, arg_char, arg_varchar2, arg_date, ' ||
           'arg_rowid, arg_raw) ' ||
          'VALUES(:tag, :deferred_tran_db, :deferred_tran_id, :dblink, ' ||
           ':delivery_order, :callno, :procedure, :argument, ' ||
           ':argument_name, :argument_type, :arg_num, :arg_char, ' ||
           ':arg_varchar2, :arg_date, :arg_rowid, :arg_raw)',
        dbms_sql.v7);
      dbms_sql.bind_variable(sql_cursor, 'tag', tag);
      dbms_sql.bind_variable(sql_cursor, 'deferred_tran_db', deferred_tran_db);
      dbms_sql.bind_variable(sql_cursor, 'deferred_tran_id', deferred_tran_id);
      dbms_sql.bind_variable(sql_cursor, 'dblink', dblink);
      dbms_sql.bind_variable(sql_cursor, 'delivery_order', delivery_order);
      dbms_sql.bind_variable(sql_cursor, 'callno', callno);
      dbms_sql.bind_variable(sql_cursor, 'procedure', procedure_name);
      dbms_sql.bind_variable(sql_cursor, 'argument', arg);
      dbms_sql.bind_variable(sql_cursor, 'argument_name', arg_name);
      dbms_sql.bind_variable(sql_cursor, 'argument_type', print_type);
      dbms_sql.bind_variable(sql_cursor, 'arg_num', arg_num);
      dbms_sql.bind_variable(sql_cursor, 'arg_char', arg_char);
      dbms_sql.bind_variable(sql_cursor, 'arg_varchar2', arg_varchar2);
      dbms_sql.bind_variable(sql_cursor, 'arg_date', arg_date);
      dbms_sql.bind_variable(sql_cursor, 'arg_rowid', arg_rowid);
      dbms_sql.bind_variable(sql_cursor, 'arg_raw', arg_raw);
      dummy := dbms_sql.execute(sql_cursor);
      dbms_sql.close_cursor(sql_cursor);
    END IF;
    RETURN advance(position, offset);
  EXCEPTION WHEN others THEN
    IF dbms_sql.is_open(sql_cursor) THEN
      dbms_sql.close_cursor(sql_cursor);
    END IF;
    RAISE;
  END print_arg;


  PROCEDURE print_header(queue_name IN VARCHAR2) IS
  -- Print the header information for a deferred queue using dbms_output.
  -- Specifically, print two blank lines, queue_name with a colon, and
  --   another blank line.
  BEGIN
    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line(queue_name || ':');
    dbms_output.put_line('');
  END print_header;


  PROCEDURE print_procedure(deferred_tran_db IN VARCHAR2,
                            deferred_tran_id IN VARCHAR2,
                            callno           IN NUMBER,
                            delivery_order   IN NUMBER,
                            dblink           IN VARCHAR2,
                            schemaname       IN VARCHAR2,
                            packagename      IN VARCHAR2,
                            procname         IN VARCHAR2,
                            argcount         IN NUMBER,
                            date_format      IN VARCHAR2,
                            table_name       IN VARCHAR2,
                            tag              IN VARCHAR2) IS
  -- The first three parameters identify a deferred remote procedure call.
  -- Print the full name of the procedure and information about each parameter
  --   using dbms_output.
  -- If table_name is not null, insert this information into the given table
  --   tagged with tag.
  -- The last printed line is blank.
  i             BINARY_INTEGER;
  offset        BINARY_INTEGER := 0; -- offset to info about overloaded proc
  fullname      VARCHAR2(98) := '"' || schemaname || '"."' || packagename ||
                                '"."' || procname || '"';
  overload      dbms_describe.number_table;
  position      dbms_describe.number_table;
  level_no      dbms_describe.number_table;
  argument_name dbms_describe.varchar2_table;
  datatype      dbms_describe.number_table;
  default_value dbms_describe.number_table;
  in_out        dbms_describe.number_table;
  length        dbms_describe.number_table;
  precision     dbms_describe.number_table;
  scale         dbms_describe.number_table;
  radix         dbms_describe.number_table;
  spare         dbms_describe.number_table;

  BEGIN
    dbms_output.put_line('deferred_tran_db: ' || deferred_tran_db);
    dbms_output.put_line('deferred_tran_id: ' || deferred_tran_id);
    dbms_output.put_line('dblink: ' || dblink);
    dbms_output.put_line('delivery_order: ' || TO_CHAR(delivery_order));
    dbms_output.put_line('callno: ' || TO_CHAR(callno));
    dbms_output.put_line('procedure: ' || fullname);
    --*** describe does not support remote procedures, so ignore dblink
    dbms_describe.describe_procedure(fullname, NULL, NULL,
      overload, position, level_no, argument_name, datatype, default_value,
      in_out, length, precision, scale, radix, spare);
    offset := which_proc(overload, position, datatype, argcount, callno,
                         deferred_tran_id, deferred_tran_db);
    ---|||
    num_args := argcount;
    dbms_output.put_line('arguments: ' || num_args);
    ---|||

    FOR i IN 1..argcount LOOP
      offset := print_arg(i, callno, deferred_tran_id, deferred_tran_db,
                          date_format, offset, position, argument_name,
                          table_name, tag, dblink, delivery_order, fullname);
    END LOOP;
    dbms_output.put_line('');
  END print_procedure;


  --------
  -- PACKAGE EXTERNAL PROCEDURES
  --


  PROCEDURE create_unpacked_table(schema_name IN VARCHAR2 := NULL,
                                  table_name  IN VARCHAR2 := NULL) IS
  real_table_name VARCHAR2(65);
  sql_cursor      NUMBER;
  dummy           NUMBER;

  BEGIN
    get_unpacked_table_name(schema_name, table_name, real_table_name);
    sql_cursor := dbms_sql.open_cursor;
    dbms_sys_sql.parse_as_user(sql_cursor,
        ' CREATE TABLE ' || real_table_name || '(' ||
          ' tag              VARCHAR2(30),' ||
          ' deferred_tran_db VARCHAR2(128),' ||
          ' deferred_tran_id VARCHAR2(22),' ||
          ' dblink           VARCHAR2(128),' ||
          ' delivery_order   NUMBER,' ||
          ' callno           NUMBER,' ||
          ' procedure        VARCHAR2(98),' ||
          ' argument         NUMBER,' ||
          ' argument_name    VARCHAR2(30),' ||
          ' argument_type    VARCHAR2(8),' ||
          ' arg_num          NUMBER,' ||
          ' arg_char         CHAR(255),' ||
          ' arg_varchar2     VARCHAR2(2000),' ||
          ' arg_date         DATE,' ||
          ' arg_rowid        ROWID,' ||
          ' arg_raw          RAW(255))',
        dbms_sql.v7);
    dummy := dbms_sql.execute(sql_cursor);
    dbms_sql.close_cursor(sql_cursor);
  EXCEPTION WHEN others THEN
    IF dbms_sql.is_open(sql_cursor) THEN
      dbms_sql.close_cursor(sql_cursor);
    END IF;
    RAISE;
  END create_unpacked_table;


  PROCEDURE print_deftran(deferred_tran_id IN VARCHAR2 := NULL,
                          deferred_tran_db IN VARCHAR2 := NULL,
                          destination      IN VARCHAR2 := NULL,
                          callno           IN NUMBER,
                          date_format      IN VARCHAR2 :=
                                              'YY:MM:DD:HH24:MI:SS',
                          save_output      IN BOOLEAN := FALSE,
                          schema_name      IN VARCHAR2 := NULL,
                          table_name       IN VARCHAR2 := NULL,
                          tag              IN VARCHAR2 := NULL) IS
  save_table VARCHAR2(65);
  CURSOR c IS
    SELECT t.deferred_tran_db, t.deferred_tran_id, t.delivery_order,
           c.callno, c.schemaname, c.packagename, c.procname,
           c.argcount, d.dblink
      FROM deftran t, deftrandest d, defcall c
      WHERE d.deferred_tran_db = t.deferred_tran_db
        AND d.deferred_tran_id = t.deferred_tran_id
        AND c.deferred_tran_db = t.deferred_tran_db
        AND c.deferred_tran_id = t.deferred_tran_id
        AND print_deftran.callno = c.callno
        AND (print_deftran.deferred_tran_db IS NULL OR
             print_deftran.deferred_tran_db = t.deferred_tran_db)
        AND (print_deftran.deferred_tran_id IS NULL OR
             print_deftran.deferred_tran_id = t.deferred_tran_id)
        AND (destination IS NULL OR destination = d.dblink)
      -- order results for deterministic testing
      ORDER BY t.deferred_tran_db, t.delivery_order, t.deferred_tran_id,
        c.callno;

  BEGIN
    IF save_output THEN
      get_unpacked_table_name(schema_name, table_name, save_table);
    ELSE
      save_table := '';
    END IF;
    print_header('deftran');
    FOR r IN c LOOP
      print_procedure(r.deferred_tran_db, r.deferred_tran_id, r.callno,
                      r.delivery_order, r.dblink, r.schemaname, r.packagename,
                      r.procname, r.argcount, date_format, save_table, tag);
    END LOOP;
  END print_deftran;


  PROCEDURE print_deferror(deferred_tran_id IN VARCHAR2 := NULL,
                           deferred_tran_db IN VARCHAR2 := NULL,
                           callno           IN NUMBER,
                           date_format      IN VARCHAR2 :=
                                              'YY:MM:DD:HH24:MI:SS',
                           save_output      IN BOOLEAN := FALSE,
                           schema_name      IN VARCHAR2 := NULL,
                           table_name       IN VARCHAR2 := NULL,
                           tag              IN VARCHAR2 := NULL) IS
  save_table VARCHAR2(65);
  CURSOR c IS
    SELECT t.deferred_tran_db, t.deferred_tran_id, t.delivery_order, c.callno,
           c.schemaname, c.packagename, c.procname, c.argcount
      FROM deftran t, deferror e, defcall c
      WHERE e.deferred_tran_db = t.deferred_tran_db
        AND e.deferred_tran_id = t.deferred_tran_id
        AND c.deferred_tran_db = t.deferred_tran_db
        AND c.deferred_tran_id = t.deferred_tran_id
        AND print_deferror.callno = c.callno
        AND (print_deferror.deferred_tran_db IS NULL OR
             print_deferror.deferred_tran_db = e.deferred_tran_db)
        AND (print_deferror.deferred_tran_id IS NULL OR
             print_deferror.deferred_tran_id = e.deferred_tran_id)
      -- order results for deterministic testing
      ORDER BY t.deferred_tran_db, t.delivery_order, t.deferred_tran_id,
        c.callno;

  BEGIN
    IF save_output THEN
      get_unpacked_table_name(schema_name, table_name, save_table);
    ELSE
      save_table := '';
    END IF;
    print_header('deferror');
    FOR r IN c LOOP
      print_procedure(r.deferred_tran_db, r.deferred_tran_id, r.callno,
                      r.delivery_order, local_node, r.schemaname,
                      r.packagename, r.procname, r.argcount, date_format,
                      save_table, tag);
    END LOOP;
  END print_deferror;

  FUNCTION return_name (idx IN BINARY_INTEGER) RETURN VARCHAR2 IS
  BEGIN
    IF idx > num_args or idx < 1 THEN
      RETURN NULL;
    ELSE
      RETURN arg_names(idx);
    END IF;
  END return_name;

  FUNCTION return_type (idx IN BINARY_INTEGER) RETURN VARCHAR2 IS
  BEGIN
    IF idx > num_args or idx < 1 THEN
      RETURN NULL;
    ELSE
      RETURN arg_types(idx);
    END IF;
  END return_type;

  FUNCTION return_value (idx IN BINARY_INTEGER) RETURN VARCHAR2 IS
  BEGIN
    IF idx > num_args or idx < 1 THEN
      RETURN NULL;
    ELSE
      RETURN arg_values(idx);
    END IF;
  END return_value;

-------------
-- PACKAGE INITIALIZATION
BEGIN
  SELECT global_name INTO local_node FROM global_name;
END dbms_defer_print;
/
show errors


-----------------------------------------------------------------------
--- Create the tables and views needed to store deferred call arguments
-----------------------------------------------------------------------
--- Create a table to store the deferred call arguments
drop table SYS.DEFCALLARGS;
create table SYS.DEFCALLARGS
(tag              VARCHAR2(30),      --- tag to identify the argument
 deferred_tran_db VARCHAR2(128),     --- reference to deferror and deftran
 deferred_tran_id VARCHAR2(22),
 dblink           VARCHAR2(128),     
 delivery_order   NUMBER,
 callno           NUMBER,
 procedure        VARCHAR2(98),      --- called procedure
 argument         NUMBER,            --- argument number
 argument_name    VARCHAR2(30),     
 argument_type    VARCHAR2(8),
 arg_num          NUMBER,            --- only one of the following columns
 arg_char         CHAR(255),         --- will contain valid information
 arg_varchar2     VARCHAR2(2000),    --- based on the type of the argument
 arg_date         DATE,
 arg_rowid        ROWID,
 arg_raw          RAW(255))
/
comment on table SYS.DEFCALLARGS is
'Store the deferred call arguments for dbms_defer_print package'
/
comment on column SYS.DEFCALLARGS.TAG is
'String to identify a call and its argument'
/
comment on column SYS.DEFCALLARGS.DEFERRED_TRAN_DB is
'Database originating or copying the RPC'
/
comment on column SYS.DEFCALLARGS.DEFERRED_TRAN_ID is
'Transaction ID originating the RPC'
/
comment on column SYS.DEFCALLARGS.DBLINK is
'database link used to address the destination'
/
comment on column SYS.DEFCALLARGS.DELIVERY_ORDER is
'SCN of originating or copying transaction'
/
comment on column SYS.DEFCALLARGS.CALLNO is
'Unique Id of the call'
/
comment on column SYS.DEFCALLARGS.PROCEDURE is
'The called procedure'
/
comment on column SYS.DEFCALLARGS.ARGUMENT is
'The order of the argument in the parameter list'
/
comment on column SYS.DEFCALLARGS.ARGUMENT_NAME is
'The symbolic name of the argument'
/
comment on column SYS.DEFCALLARGS.ARGUMENT_TYPE is
'The argument type'
/
comment on column SYS.DEFCALLARGS.ARG_NUM is
'If the argument type is a number then this is the value of the number'
/
comment on column SYS.DEFCALLARGS.ARG_CHAR is
'If the argument type is a char then this is the value of the char'
/
comment on column SYS.DEFCALLARGS.ARG_VARCHAR2 is
'If the argument type is a varchar2 then this is the value of the varchar2'
/
comment on column SYS.DEFCALLARGS.ARG_DATE is
'If the argument type is a date then this is the value of the date'
/
comment on column SYS.DEFCALLARGS.ARG_ROWID is
'If the argument type is a rowid then this is the value of the rowid'
/
comment on column SYS.DEFCALLARGS.ARG_RAW is
'If the argument type is a raw then this is the value of the raw'
/


--- View to extract information from defcallargs in a readable format
create or replace view DBA_ADMINARGUMENTS
  (TAG, PROC, ARG_NO, ARG_NAME, ARG_TYPE, ARG_VAL)
as
select
  tag,
  procedure,
  argument,
  argument_name,
  argument_type,
  DECODE(argument_type, 'NUMBER', TO_CHAR(arg_num),
    DECODE(argument_type, 'CHAR', arg_char,
      DECODE(argument_type, 'VARCHAR2', arg_varchar2,
        DECODE(argument_type, 'DATE', TO_CHAR(arg_date, 'DD-MON-RR HH24:MI:SS'),
          DECODE(argument_type, 'ROWID', ROWIDTOCHAR(arg_rowid),
            DECODE(argument_type, 'RAW', NULL))))))
from defcallargs
/
comment on table DBA_ADMINARGUMENTS is
'Present the information from DBA_ADMINARGUMENTS is a easily readable format'
/
comment on column DBA_ADMINARGUMENTS.TAG is
'String to identify a call and its arguments'
/
comment on column DBA_ADMINARGUMENTS.PROC is
'The called procedure'
/
comment on column DBA_ADMINARGUMENTS.ARG_NO is
'The order of the argument in the parameter list'
/
comment on column DBA_ADMINARGUMENTS.ARG_NAME is
'The symbolic name of the argument'
/
comment on column DBA_ADMINARGUMENTS.ARG_TYPE is
'The argument type'
/
comment on column DBA_ADMINARGUMENTS.ARG_VAL is
'The value of the argument converted to a varchar2'
/

commit
/
