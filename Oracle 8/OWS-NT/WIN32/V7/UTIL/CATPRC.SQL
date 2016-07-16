rem 
rem $Header: catprc.sql,v 1.6 1995/03/16 12:18:57 mramache Exp $ prctrg.sql 
rem 
Rem Copyright (c) 1990 by Oracle Corporation
Rem NAME
Rem    CATPRC.SQL
Rem FUNCTION
Rem    Creates data dictionary views for stored procedures and triggers. 
Rem NOTES
Rem    Must be run while connected to sys or internal.
Rem
Rem MODIFIED
Rem     mramache   03/13/95 -  user_errors now handles triggers
Rem     wmaimone   05/26/94 -  #186155 add public synoyms for dba_
Rem     jbellemo   05/09/94 -  merge changes from branch 1.2.710.2
Rem     jbellemo   12/17/93 -  merge changes from branch 1.2.710.1
Rem     jbellemo   04/27/94 -  #199905: fix security in ALL_ERRORS
Rem     jbellemo   11/09/93 -  #170173: change uid to userenv schemaid
Rem     tpystyne   10/28/92 -  use create or replace view 
Rem     glumpkin   10/20/92 -  Renamed from PRCTRG.SQL 
Rem     mmoore     10/15/92 - #(131033) add trigger column views for marketing 
Rem     mmoore     09/29/92 - #(131033) add more info to the triggers view 
Rem     jwijaya    08/17/92 -  add sequence to error$ 
Rem     jwijaya    07/17/92 -  remove database link owner from name 
Rem     mmoore     06/03/92 - #(111923) change trigger view names 
Rem     mmoore     06/02/92 - #(96526) remove v$enabledroles 
Rem     mroberts   06/01/92 -  change privileges for all_errors view 
Rem     rkooi      04/15/92 -  test tools 
Rem     rkooi      01/18/92 -  add synonym 
Rem     rkooi      01/18/92 -  add object_sizes views 
Rem     rkooi      01/10/92 -  synchronize with catalog.sql 
Rem     rkooi      12/23/91 -  testing 
Rem     rkooi      10/20/91 -  add public_dependency 
Rem     jwijaya    07/14/91 -  remove LINKNAME IS NULL 
Rem     rkooi      05/22/91 -  get rid of _object in some catalog names 
Rem     rkooi      05/22/91 - change *_references to *_dependencies
Rem     rkooi      05/05/91 - fix up permissions on all* cats 
Rem     jwijaya    04/12/91 - remove LINKNAME IS NULL 
Rem     rkooi      03/29/91 - add views for pcode & diana 
Rem     Kooi       03/12/91 - Creation
Rem     Kooi       03/12/91 - Creation
Rem


remark
remark    FAMILY "ERRORS"
remark    Errors for stored objects - currently these are
remark    PL/SQL packages, package bodies, procedures and functions.
remark

create or replace view USER_ERRORS
(NAME, TYPE, SEQUENCE, LINE, POSITION, TEXT)
as
select o.name,
decode(o.type, 4, 'VIEW', 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
e.sequence, e.line, e.position, e.text
from sys.obj$ o, sys.error$ e
where o.obj# = e.obj#
  and o.type in (4, 7, 8, 9, 11, 12)
  and o.owner# = userenv('SCHEMAID')
/
comment on table USER_ERRORS is
'Current errors on stored objects owned by the user'
/
comment on column USER_ERRORS.NAME is
'Name of the object'
/
comment on column USER_ERRORS.TYPE is
'Type: "VIEW", "PROCEDURE", "FUNCTION", "PACKAGE", "PACKAGE BODY" or "TRIGGER"'
/
comment on column USER_ERRORS.SEQUENCE is
'Sequence number used for ordering purposes'
/
comment on column USER_ERRORS.LINE is
'Line number at which this error occurs'
/
comment on column USER_ERRORS.POSITION is
'Position in the line at which this error occurs'
/
comment on column USER_ERRORS.TEXT is
'Text of the error'
/
drop public synonym USER_ERRORS
/
create public synonym USER_ERRORS for USER_ERRORS
/
grant select on USER_ERRORS to public with grant option
/

remark
remark  User is allowed to see errors on any object that they own
remark  or could have created.
remark

create or replace view ALL_ERRORS
(OWNER, NAME, TYPE, SEQUENCE, LINE, POSITION, TEXT)
as
select u.name, o.name,
decode(o.type, 4, 'VIEW', 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
e.sequence, e.line, e.position, e.text
from sys.obj$ o, sys.error$ e, sys.user$ u
where o.obj# = e.obj#
  and o.owner# = u.user#
  and o.type in (4, 7, 8, 9, 11, 12)
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
         (
          (o.type = 7 or o.type = 8 or o.type = 9)
          and
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        (
          o.type = 4
          and
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege# in (3 /* DELETE */,   6 /* INSERT */,
                                      	  7 /* LOCK */,     9 /* SELECT */,
                                          10 /* UPDATE */))
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (o.type = 7 or o.type = 8 or o.type = 9)
              and
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
            or
            (
              /* trigger */
              o.type = 12 and
              privilege# = -152 /* CREATE ANY TRIGGER */
            )
	    or
            (
              /* package body */
              o.type = 11 and
              privilege# = -141 /* CREATE ANY PROCEDURE */
            )
            or
            (
              /* view */
              o.type = 4
              and
              (
                privilege# in     ( -91 /* CREATE ANY VIEW */,
                                    -45 /* LOCK ANY TABLE */,
                                    -47 /* SELECT ANY TABLE */,
                                    -48 /* INSERT ANY TABLE */,
                                    -49 /* UPDATE ANY TABLE */,
                                    -50 /* DELETE ANY TABLE */)
              )
            )
          )
        )
      )
    )
  )
/
comment on table ALL_ERRORS is
'Current errors on stored objects that user is allowed to create'
/
comment on column ALL_ERRORS.OWNER is
'Owner of the object'
/
comment on column ALL_ERRORS.NAME is
'Name of the object'
/
comment on column ALL_ERRORS.TYPE is
'Type: "VIEW", "PROCEDURE", "FUNCTION", "PACKAGE", "PACKAGE BODY" or "TRIGGER"'
/
comment on column ALL_ERRORS.SEQUENCE is
'Sequence number used for ordering purposes'
/
comment on column ALL_ERRORS.LINE is
'Line number at which this error occurs'
/
comment on column ALL_ERRORS.POSITION is
'Position in the line at which this error occurs'
/
comment on column ALL_ERRORS.TEXT is
'Text of the error'
/
drop public synonym ALL_ERRORS
/
create public synonym ALL_ERRORS for ALL_ERRORS
/
grant select on ALL_ERRORS to public with grant option
/

create or replace view DBA_ERRORS
(OWNER, NAME, TYPE, SEQUENCE, LINE, POSITION, TEXT)
as
select u.name, o.name,
decode(o.type, 4, 'VIEW', 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
11, 'PACKAGE BODY', 12, 'TRIGGER',  'UNDEFINED'),
e.sequence, e.line, e.position, e.text
from sys.obj$ o, sys.error$ e, sys.user$ u
where o.obj# = e.obj#
  and o.owner# = u.user#
  and o.type in (4, 7, 8, 9, 11, 12)
/
drop public synonym DBA_ERRORS
/
create public synonym DBA_ERRORS for DBA_ERRORS
/
comment on table DBA_ERRORS is
'Current errors on all stored objects in the database'
/
comment on column DBA_ERRORS.NAME is
'Name of the object'
/
comment on column DBA_ERRORS.TYPE is
'Type: "VIEW", "PROCEDURE", "FUNCTION", "PACKAGE", "PACKAGE BODY" or "TRIGGER"'
/
comment on column DBA_ERRORS.SEQUENCE is
'Sequence number used for ordering purposes'
/
comment on column DBA_ERRORS.LINE is
'Line number at which this error occurs'
/
comment on column DBA_ERRORS.POSITION is
'Position in the line at which this error occurs'
/
comment on column DBA_ERRORS.TEXT is
'Text of the error'
/


remark
remark    FAMILY "SOURCE"
remark    SOURCE for stored objects - currently these are 
remark    PL/SQL packages, package bodies, procedures and functions.
remark

create or replace view USER_SOURCE
(NAME, TYPE, LINE, TEXT)
as
select o.name,
decode(o.type, 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
11, 'PACKAGE BODY', 'UNDEFINED'),
s.line, s.source
from sys.obj$ o, sys.source$ s
where o.obj# = s.obj#
  and o.type in (7, 8, 9, 11)
  and o.owner# = userenv('SCHEMAID')
/
comment on table USER_SOURCE is
'Source of stored objects accessible to the user'
/
comment on column USER_SOURCE.NAME is
'Name of the object'
/
comment on column USER_SOURCE.TYPE is
'Type of the object: "PROCEDURE", "FUNCTION", "PACKAGE" or "PACKAGE BODY"'
/
comment on column USER_SOURCE.LINE is
'Line number of this line of source'
/
comment on column USER_SOURCE.TEXT is
'Source text'
/
drop public synonym USER_SOURCE
/
create public synonym USER_SOURCE for USER_SOURCE
/
grant select on USER_SOURCE to public with grant option
/

create or replace view ALL_SOURCE
(OWNER, NAME, TYPE, LINE, TEXT)
as
select u.name, o.name,
decode(o.type, 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
11, 'PACKAGE BODY', 'UNDEFINED'),
s.line, s.source
from sys.obj$ o, sys.source$ s, sys.user$ u
where o.obj# = s.obj#
  and o.owner# = u.user#
  and o.type in (7, 8, 9, 11)
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
         (
          (o.type = 7 or o.type = 8 or o.type = 9)
          and
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (o.type = 7 or o.type = 8 or o.type = 9)
              and
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
	    or
            (
              /* package body */
              o.type = 11 and
              privilege# = -141 /* CREATE ANY PROCEDURE */
            )
          )
        )
      )
    )
  )
/
comment on table ALL_SOURCE is
'Current source on stored objects that user is allowed to create'
/
comment on column ALL_SOURCE.OWNER is
'Owner of the object'
/
comment on column ALL_SOURCE.NAME is
'Name of the object'
/
comment on column ALL_SOURCE.TYPE is
'Type of the object: "PROCEDURE", "FUNCTION", "PACKAGE" or "PACKAGE BODY"'
/
comment on column ALL_SOURCE.LINE is
'Line number of this line of source'
/
comment on column ALL_SOURCE.TEXT is
'Source text'
/
drop public synonym ALL_SOURCE
/
create public synonym ALL_SOURCE for ALL_SOURCE
/
grant select on ALL_SOURCE to public with grant option
/

create or replace view DBA_SOURCE
(OWNER, NAME, TYPE, LINE, TEXT)
as
select u.name, o.name,
decode(o.type, 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
11, 'PACKAGE BODY', 'UNDEFINED'),
s.line, s.source
from sys.obj$ o, sys.source$ s, sys.user$ u
where o.obj# = s.obj#
  and o.owner# = u.user#
  and o.type in (7, 8, 9, 11)
/
drop public synonym DBA_SOURCE
/
create public synonym DBA_SOURCE for DBA_SOURCE
/
comment on table DBA_SOURCE is
'Source of all stored objects in the database'
/
comment on column DBA_SOURCE.NAME is
'Name of the object'
/
comment on column DBA_SOURCE.TYPE is
'Type of the object: "PROCEDURE", "FUNCTION", "PACKAGE" or "PACKAGE BODY"'
/
comment on column DBA_SOURCE.LINE is
'Line number of this line of source'
/
comment on column DBA_SOURCE.TEXT is
'Source text'
/

remark
remark    FAMILY "TRIGGERS"
remark    Database trigger definitions.
remark    This family has no "ALL" member.
remark

create or replace view USER_TRIGGERS
(TRIGGER_NAME, TRIGGER_TYPE, TRIGGERING_EVENT, TABLE_OWNER, TABLE_NAME, 
 REFERENCING_NAMES, WHEN_CLAUSE, STATUS, DESCRIPTION, TRIGGER_BODY)
as
select trigobj.name,
decode(t.type, 0, 'BEFORE STATEMENT',
               1, 'BEFORE EACH ROW',
               2, 'AFTER STATEMENT',
               3, 'AFTER EACH ROW', 'UNDEFINED'),
decode(t.insert$*100 + t.update$*10 + t.delete$,
                 100, 'INSERT',
                 010, 'UPDATE',
                 001, 'DELETE',
                 110, 'INSERT OR UPDATE',
                 101, 'INSERT OR DELETE',
                 011, 'UPDATE OR DELETE',
                 111, 'INSERT OR UPDATE OR DELETE', 'ERROR'),
u.name, tabobj.name, 
'REFERENCING NEW AS '||t.refnewname||' OLD AS '||t.refoldname,
t.whenclause,decode(t.enabled, 0, 'DISABLED', 1, 'ENABLED', 'ERROR'),
t.definition,t.action
from sys.obj$ trigobj, sys.obj$ tabobj, sys.trigger$ t, sys.user$ u
where trigobj.obj#   = t.obj#
  and tabobj.obj#    = t.baseobject
  and trigobj.owner# = userenv('SCHEMAID')
  and tabobj.owner#  = u.user#
/
comment on table USER_TRIGGERS is
'Triggers owned by the user'
/
comment on column USER_TRIGGERS.TRIGGER_NAME is
'Name of the trigger'
/
comment on column USER_TRIGGERS.TRIGGER_TYPE is
'Type of the trigger (when it fires) - BEFORE/AFTER and STATEMENT/ROW'
/
comment on column USER_TRIGGERS.TRIGGERING_EVENT is
'Statement that will fire the trigger - INSERT, UPDATE and/or DELETE'
/
comment on column USER_TRIGGERS.TABLE_OWNER is
'Owner of the table that this trigger is associated with'
/
comment on column USER_TRIGGERS.TABLE_NAME is
'Name of the table that this trigger is associated with'
/
comment on column USER_TRIGGERS.REFERENCING_NAMES is
'Names used for referencing to OLD and NEW values within the trigger'
/
comment on column USER_TRIGGERS.WHEN_CLAUSE is
'WHEN clause must evaluate to true in order for triggering body to execute'
/
comment on column USER_TRIGGERS.STATUS is
'If DISABLED then trigger will not fire'
/
comment on column USER_TRIGGERS.DESCRIPTION is
'Trigger description, useful for re-creating trigger creation statement'
/
comment on column USER_TRIGGERS.TRIGGER_BODY is
'Action taken by this trigger when it fires'
/
drop public synonym USER_TRIGGERS
/
create public synonym USER_TRIGGERS for USER_TRIGGERS
/
grant select on USER_TRIGGERS to public with grant option
/

create or replace view ALL_TRIGGERS
(OWNER, TRIGGER_NAME, TRIGGER_TYPE, TRIGGERING_EVENT, TABLE_OWNER, TABLE_NAME,
 REFERENCING_NAMES, WHEN_CLAUSE, STATUS, DESCRIPTION, TRIGGER_BODY)
as
select triguser.name, trigobj.name,
decode(t.type, 0, 'BEFORE STATEMENT',
               1, 'BEFORE EACH ROW',
               2, 'AFTER STATEMENT',
               3, 'AFTER EACH ROW', 'UNDEFINED'),
decode(t.insert$*100 + t.update$*10 + t.delete$,
                 100, 'INSERT',
                 010, 'UPDATE',
                 001, 'DELETE',
                 110, 'INSERT OR UPDATE',
                 101, 'INSERT OR DELETE',
                 011, 'UPDATE OR DELETE',
                 111, 'INSERT OR UPDATE OR DELETE', 'ERROR'),
tabuser.name, tabobj.name, 
'REFERENCING NEW AS '||t.refnewname||' OLD AS '||t.refoldname,
t.whenclause,decode(t.enabled, 0, 'DISABLED', 1, 'ENABLED', 'ERROR'),
t.definition,t.action
from sys.obj$ trigobj, sys.obj$ tabobj, sys.trigger$ t, sys.user$ tabuser,
     sys.user$ triguser
where trigobj.obj#   = t.obj#
  and tabobj.obj#    = t.baseobject
  and trigobj.owner# = triguser.user#
  and tabobj.owner#  = tabuser.user#
  and
  (
    trigobj.owner# = userenv('SCHEMAID') or tabobj.owner# = userenv('SCHEMAID')
    or
    exists (select null from sys.sysauth$
             where grantee# in (select kzsrorol from x$kzsro)
               and privilege# = -152 /* CREATE ANY TRIGGER */)
  )
/
comment on table ALL_TRIGGERS is
'Triggers accessible to the current user'
/
comment on column ALL_TRIGGERS.OWNER is
'Owner of the trigger'
/
comment on column ALL_TRIGGERS.TRIGGER_NAME is
'Name of the trigger'
/
comment on column ALL_TRIGGERS.TRIGGER_TYPE is
'When the trigger fires - BEFORE/AFTER and STATEMENT/ROW'
/
comment on column ALL_TRIGGERS.TRIGGERING_EVENT is
'Statement that will fire the trigger - INSERT, UPDATE and/or DELETE'
/
comment on column ALL_TRIGGERS.TABLE_OWNER is
'Owner of the table that this trigger is associated with'
/
comment on column ALL_TRIGGERS.TABLE_NAME is
'Name of the table that this trigger is associated with'
/
comment on column ALL_TRIGGERS.REFERENCING_NAMES is
'Names used for referencing to OLD and NEW values within the trigger'
/
comment on column ALL_TRIGGERS.WHEN_CLAUSE is
'WHEN clause must evaluate to true in order for triggering body to execute'
/
comment on column ALL_TRIGGERS.STATUS is
'If DISABLED then trigger will not fire'
/
comment on column ALL_TRIGGERS.DESCRIPTION is
'Trigger description, useful for re-creating trigger creation statement'
/
comment on column ALL_TRIGGERS.TRIGGER_BODY is
'Action taken by this trigger when it fires'
/
drop public synonym ALL_TRIGGERS
/
create public synonym ALL_TRIGGERS for ALL_TRIGGERS
/
grant select on ALL_TRIGGERS to public with grant option
/

create or replace view DBA_TRIGGERS
(OWNER, TRIGGER_NAME, TRIGGER_TYPE, TRIGGERING_EVENT, TABLE_OWNER, TABLE_NAME,
 REFERENCING_NAMES, WHEN_CLAUSE, STATUS, DESCRIPTION, TRIGGER_BODY)
as
select trigusr.name, trigobj.name,
decode(t.type, 0, 'BEFORE STATEMENT',
               1, 'BEFORE EACH ROW',
               2, 'AFTER STATEMENT',
               3, 'AFTER EACH ROW', 'UNDEFINED'),
decode(t.insert$*100 + t.update$*10 + t.delete$,
                 100, 'INSERT',
                 010, 'UPDATE',
                 001, 'DELETE',
                 110, 'INSERT OR UPDATE',
                 101, 'INSERT OR DELETE',
                 011, 'UPDATE OR DELETE',
                 111, 'INSERT OR UPDATE OR DELETE', 'ERROR'),
tabusr.name, tabobj.name, 
'REFERENCING NEW AS '||t.refnewname||' OLD AS '||t.refoldname,
t.whenclause,decode(t.enabled, 0, 'DISABLED', 1, 'ENABLED', 'ERROR'),
t.definition,t.action
from sys.obj$ trigobj, sys.obj$ tabobj, sys.trigger$ t,
     sys.user$ tabusr, sys.user$ trigusr
where trigobj.obj#   = t.obj#
  and tabobj.obj#    = t.baseobject
  and tabobj.owner#  = tabusr.user#
  and trigobj.owner# = trigusr.user#
/
drop public synonym DBA_TRIGGERS
/
create public synonym DBA_TRIGGERS for DBA_TRIGGERS
/
comment on table DBA_TRIGGERS is
'All triggers in the database'
/
comment on column DBA_TRIGGERS.OWNER is
'Owner of the trigger'
/
comment on column DBA_TRIGGERS.TRIGGER_NAME is
'Name of the trigger'
/
comment on column DBA_TRIGGERS.TRIGGER_TYPE is
'When the trigger fires - BEFORE/AFTER and STATEMENT/ROW'
/
comment on column DBA_TRIGGERS.TRIGGERING_EVENT is
'Statement that will fire the trigger - INSERT, UPDATE and/or DELETE'
/
comment on column DBA_TRIGGERS.TABLE_OWNER is
'Owner of the table that this trigger is associated with'
/
comment on column DBA_TRIGGERS.TABLE_NAME is
'Name of the table that this trigger is associated with'
/
comment on column DBA_TRIGGERS.REFERENCING_NAMES is
'Names used for referencing to OLD and NEW values within the trigger'
/
comment on column DBA_TRIGGERS.WHEN_CLAUSE is
'WHEN clause must evaluate to true in order for triggering body to execute'
/
comment on column DBA_TRIGGERS.STATUS is
'If DISABLED then trigger will not fire'
/
comment on column DBA_TRIGGERS.DESCRIPTION is
'Trigger description, useful for re-creating trigger creation statement'
/
comment on column DBA_TRIGGERS.TRIGGER_BODY is
'Action taken by this trigger when it fires'
/

remark
remark	USER_TRIGGER_COLS shows usage of columns in triggers owned by the
remark	current user or in triggers on tables owned by the current user
remark

create or replace view USER_TRIGGER_COLS
(TRIGGER_OWNER, TRIGGER_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME,
    COLUMN_LIST, COLUMN_USAGE)
as
select /*+ ORDERED NOCOST */ u.name, o.name, u2.name, o2.name, c.name,
   max(decode(tc.type,0,'YES','NO')) COLUMN_LIST,
   decode(sum(decode(tc.type, 5,  1, -- one occurrence of new in
                              6,  2, -- one occurrence of old in
                              9,  4, -- one occurrence of new out
                             10,  8, -- one occurrence of old out (impossible)
                             13,  5, -- one occurrence of new in out
                             14, 10, -- one occurrence of old in out (imp.)
                              null)
                ), -- result in the following combinations across occurrences
           1, 'NEW IN',
           2, 'OLD IN',
           3, 'NEW IN OLD IN',
           4, 'NEW OUT',
           5, 'NEW IN OUT',
           6, 'NEW OUT OLD IN',
           7, 'NEW IN OUT OLD IN',
          'NONE')
from sys.trigger$ t, sys.obj$ o, sys.user$ u, sys.user$ u2,
     sys.col$ c, sys.obj$ o2, sys.triggercol$ tc
where t.obj# = tc.obj#		-- find corresponding trigger definition
  and o.obj# = t.obj#		--    and corresponding trigger name
  and c.obj# = t.baseobject 	-- and corresponding row in COL$ of
  and c.col# = tc.col#		--    the referenced column
  and o2.obj# = t.baseobject	-- and name of the table containing the trigger
  and u2.user# = o2.owner#	-- and name of the user who owns the table
  and u.user# = o.owner#	-- and name of user who owns the trigger
  and ((o.owner# = userenv('SCHEMAID') and u.user# = userenv('SCHEMAID')) -- triggers owned by the current user
      or
       (o2.owner# = userenv('SCHEMAID') and u2.user# = userenv('SCHEMAID'))) -- on the current user's tables
group by u.name, o.name, u2.name, o2.name, c.name
/
comment on table USER_TRIGGER_COLS is
'Column usage in user''s triggers'
/
comment on column USER_TRIGGER_COLS.TRIGGER_OWNER is
'Owner of the trigger'
/
comment on column USER_TRIGGER_COLS.TRIGGER_NAME is
'Name of the trigger'
/
comment on column USER_TRIGGER_COLS.TABLE_OWNER is
'Owner of the table'
/
comment on column USER_TRIGGER_COLS.TABLE_NAME is
'Name of the table on which the trigger is defined'
/
comment on column USER_TRIGGER_COLS.COLUMN_NAME is
'Name of the column used in trigger definition'
/
comment on column USER_TRIGGER_COLS.COLUMN_LIST is
'Is column specified in UPDATE OF clause?'
/
comment on column USER_TRIGGER_COLS.COLUMN_USAGE is
'Usage of column within trigger body'
/
drop public synonym USER_TRIGGER_COLS
/
create public synonym USER_TRIGGER_COLS for USER_TRIGGER_COLS
/
grant select on USER_TRIGGER_COLS to public
/
remark
remark	ALL_TRIGGER_COLS shows usage of columns in triggers owned by the
remark	current user or in triggers on tables owned by the current user
remark	or on all triggers if current user has CREATE ANY TRIGGER privilege
remark	(either directly or through a role).
remark

create or replace view ALL_TRIGGER_COLS
(TRIGGER_OWNER, TRIGGER_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME,
    COLUMN_LIST, COLUMN_USAGE)
as
select /*+ ORDERED NOCOST */ u.name, o.name, u2.name, o2.name, c.name,
   max(decode(tc.type,0,'YES','NO')) COLUMN_LIST,
   decode(sum(decode(tc.type, 5,  1, -- one occurrence of new in
                              6,  2, -- one occurrence of old in
                              9,  4, -- one occurrence of new out
                             10,  8, -- one occurrence of old out (impossible)
                             13,  5, -- one occurrence of new in out
                             14, 10, -- one occurrence of old in out (imp.)
                              null)
                ), -- result in the following combinations across occurrences
           1, 'NEW IN',
           2, 'OLD IN',
           3, 'NEW IN OLD IN',
           4, 'NEW OUT',
           5, 'NEW IN OUT',
           6, 'NEW OUT OLD IN',
           7, 'NEW IN OUT OLD IN',
          'NONE')
from sys.trigger$ t, sys.obj$ o, sys.user$ u, sys.user$ u2,
     sys.col$ c, sys.obj$ o2, sys.triggercol$ tc
where t.obj# = tc.obj#		-- find corresponding trigger definition
  and o.obj# = t.obj#		--    and corresponding trigger name
  and c.obj# = t.baseobject 	-- and corresponding row in COL$ of
  and c.col# = tc.col#		--    the referenced column
  and o2.obj# = t.baseobject	-- and name of the table containing the trigger
  and u2.user# = o2.owner#	-- and name of the user who owns the table
  and u.user# = o.owner#	-- and name of user who owns the trigger
  and
  ( o.owner# = userenv('SCHEMAID') or o2.owner# = userenv('SCHEMAID')
    or
    exists    -- an enabled role (or current user) with CREATE ANY TRIGGER priv
     ( select null from sys.sysauth$ sa    -- does 
       where privilege# = -152             -- CREATE ANY TRIGGER privilege exist
       and (grantee# in                    -- for current user or public
            (select kzsrorol from x$kzsro) -- currently enabled role
           )
      )
   )
group by u.name, o.name, u2.name, o2.name, c.name
/
comment on table ALL_TRIGGER_COLS is
'Column usage in user''s triggers or in triggers on user''s tables'
/
comment on column ALL_TRIGGER_COLS.TRIGGER_OWNER is
'Owner of the trigger'
/
comment on column ALL_TRIGGER_COLS.TRIGGER_NAME is
'Name of the trigger'
/
comment on column ALL_TRIGGER_COLS.TABLE_OWNER is
'Owner of the table'
/
comment on column ALL_TRIGGER_COLS.TABLE_NAME is
'Name of the table on which the trigger is defined'
/
comment on column ALL_TRIGGER_COLS.COLUMN_NAME is
'Name of the column used in trigger definition'
/
comment on column ALL_TRIGGER_COLS.COLUMN_LIST is
'Is column specified in UPDATE OF clause?'
/
comment on column ALL_TRIGGER_COLS.COLUMN_USAGE is
'Usage of column within trigger body'
/
drop public synonym ALL_TRIGGER_COLS
/
create public synonym ALL_TRIGGER_COLS for ALL_TRIGGER_COLS
/
grant select on ALL_TRIGGER_COLS to public
/
remark
remark	DBA_TRIGGER_COLS shows usage of columns in all triggers defined
remark	by any user, on any user's table.
remark

create or replace view DBA_TRIGGER_COLS
(TRIGGER_OWNER, TRIGGER_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_NAME,
    COLUMN_LIST, COLUMN_USAGE)
as
select /*+ ORDERED NOCOST */ u.name, o.name, u2.name, o2.name, c.name,
   max(decode(tc.type,0,'YES','NO')) COLUMN_LIST,
   decode(sum(decode(tc.type, 5,  1, -- one occurrence of new in
                              6,  2, -- one occurrence of old in
                              9,  4, -- one occurrence of new out
                             10,  8, -- one occurrence of old out (impossible)
                             13,  5, -- one occurrence of new in out
                             14, 10, -- one occurrence of old in out (imp.)
                              null)
                ), -- result in the following combinations across occurrences
           1, 'NEW IN',
           2, 'OLD IN',
           3, 'NEW IN OLD IN',
           4, 'NEW OUT',
           5, 'NEW IN OUT',
           6, 'NEW OUT OLD IN',
           7, 'NEW IN OUT OLD IN',
          'NONE')
from sys.trigger$ t, sys.obj$ o, sys.user$ u, sys.user$ u2,
     sys.col$ c, sys.obj$ o2, sys.triggercol$ tc
where t.obj# = tc.obj#		-- find corresponding trigger definition
  and o.obj# = t.obj#		--    and corresponding trigger name
  and c.obj# = t.baseobject 	-- and corresponding row in COL$ of
  and c.col# = tc.col#		--    the referenced column
  and o2.obj# = t.baseobject	-- and name of the table containing the trigger
  and u2.user# = o2.owner#	-- and name of the user who owns the table
  and u.user# = o.owner#	-- and name of user who owns the trigger
group by u.name, o.name, u2.name, o2.name, c.name
/
drop public synonym DBA_TRIGGER_COLS
/
create public synonym DBA_TRIGGER_COLS for DBA_TRIGGER_COLS
/
comment on table DBA_TRIGGER_COLS is
'Column usage in all triggers'
/
comment on column DBA_TRIGGER_COLS.TRIGGER_OWNER is
'Owner of the trigger'
/
comment on column DBA_TRIGGER_COLS.TRIGGER_NAME is
'Name of the trigger'
/
comment on column DBA_TRIGGER_COLS.TABLE_OWNER is
'Owner of the table'
/
comment on column DBA_TRIGGER_COLS.TABLE_NAME is
'Name of the table on which the trigger is defined'
/
comment on column DBA_TRIGGER_COLS.COLUMN_NAME is
'Name of the column used in trigger definition'
/
comment on column DBA_TRIGGER_COLS.COLUMN_LIST is
'Is column specified in UPDATE OF clause?'
/
comment on column DBA_TRIGGER_COLS.COLUMN_USAGE is
'Usage of column within trigger body'
/

remark
remark    FAMILY "DEPENDENCIES"
remark    Dependencies between database objects
remark

create or replace view USER_DEPENDENCIES
  (NAME, TYPE, REFERENCED_OWNER, REFERENCED_NAME,
   REFERENCED_TYPE, REFERENCED_LINK_NAME)
as
select o.name,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT',
		      11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
       decode(po.linkname, null, pu.name, po.remoteowner), po.name,
       decode(po.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT',
		      11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
       po.linkname
from sys.obj$ o, sys.obj$ po, sys.dependency$ d, sys.user$ pu
where o.obj# = d.d_obj#
  and po.obj# = d.p_obj#
  and po.owner# = pu.user#
  and o.owner# = userenv('SCHEMAID')
/
comment on table USER_DEPENDENCIES is
'Dependencies to and from a users objects'
/
comment on column USER_DEPENDENCIES.NAME is
'Name of the object'
/
comment on column USER_DEPENDENCIES.TYPE is
'Type of the object'
/
comment on column USER_DEPENDENCIES.REFERENCED_OWNER is
'Owner of referenced object (remote owner if remote object)'
/
comment on column USER_DEPENDENCIES.REFERENCED_NAME is
'Name of referenced object'
/
comment on column USER_DEPENDENCIES.REFERENCED_TYPE is
'Type of referenced object'
/
comment on column USER_DEPENDENCIES.REFERENCED_LINK_NAME is
'Name of dblink if this is a remote object'
/
drop public synonym USER_DEPENDENCIES
/
create public synonym USER_DEPENDENCIES for USER_DEPENDENCIES
/
grant select on USER_DEPENDENCIES to public with grant option
/

create or replace view ALL_DEPENDENCIES
  (OWNER, NAME, TYPE, REFERENCED_OWNER, REFERENCED_NAME,
   REFERENCED_TYPE, REFERENCED_LINK_NAME)
as
select u.name, o.name,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT',
		      11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
       decode(po.linkname, null, pu.name, po.remoteowner), po.name,
       decode(po.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT',
		      11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
       po.linkname
from sys.obj$ o, sys.obj$ po, sys.dependency$ d, sys.user$ u, sys.user$ pu
where o.obj# = d.d_obj#
  and o.owner# = u.user#
  and po.obj# = d.p_obj#
  and po.owner# = pu.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
         (
          (o.type = 7 or o.type = 8 or o.type = 9)
          and
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        (
          o.type = 4
          and
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege# in (3 /* DELETE */,   6 /* INSERT */,
                                      	  7 /* LOCK */,     9 /* SELECT */,
                                          10 /* UPDATE */))
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (o.type = 7 or o.type = 8 or o.type = 9)
              and
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
            or
            (
              /* trigger */
              o.type = 12 and
              privilege# = -152 /* CREATE ANY TRIGGER */
            )
	    or
            (
              /* package body */
              o.type = 11 and
              privilege# = -141 /* CREATE ANY PROCEDURE */
            )
            or
            (
              /* view */
              o.type = 4
              and
              (
                privilege# in     ( -91 /* CREATE ANY VIEW */,
				    -45 /* LOCK ANY TABLE */,
                                    -47 /* SELECT ANY TABLE */,
                                    -48 /* INSERT ANY TABLE */,
                                    -49 /* UPDATE ANY TABLE */,
                                    -50 /* DELETE ANY TABLE */)
              )
            )
          )
        )
      )
    )
    /* don't worry about tables, sequences, synonyms since they cannot */
    /* depend on anything */
  )
/
comment on table ALL_DEPENDENCIES is
'Dependencies to and from objects accessible to the user'
/
comment on column ALL_DEPENDENCIES.OWNER is
'Owner of the object'
/
comment on column ALL_DEPENDENCIES.NAME is
'Name of the object'
/
comment on column ALL_DEPENDENCIES.TYPE is
'Type of the object'
/
comment on column ALL_DEPENDENCIES.REFERENCED_OWNER is
'Owner of referenced object (remote owner if remote object)'
/
comment on column ALL_DEPENDENCIES.REFERENCED_NAME is
'Name of referenced object'
/
comment on column ALL_DEPENDENCIES.REFERENCED_TYPE is
'Type of referenced object'
/
comment on column ALL_DEPENDENCIES.REFERENCED_LINK_NAME is
'Name of dblink if this is a remote object'
/
drop public synonym ALL_DEPENDENCIES
/
create public synonym ALL_DEPENDENCIES for ALL_DEPENDENCIES
/
grant select on ALL_DEPENDENCIES to public with grant option
/

create or replace view DBA_DEPENDENCIES
  (OWNER, NAME, TYPE, REFERENCED_OWNER, REFERENCED_NAME,
   REFERENCED_TYPE, REFERENCED_LINK_NAME)
as
select u.name, o.name,
       decode(o.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT',
		      11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
       decode(po.linkname, null, pu.name, po.remoteowner), po.name,
       decode(po.type, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT',
		      11, 'PACKAGE BODY', 12, 'TRIGGER', 'UNDEFINED'),
       po.linkname
from sys.obj$ o, sys.obj$ po, sys.dependency$ d, sys.user$ u, sys.user$ pu
where o.obj# = d.d_obj#
  and o.owner# = u.user#
  and po.obj# = d.p_obj#
  and po.owner# = pu.user#
/
drop public synonym DBA_DEPENDENCIES
/
create public synonym DBA_DEPENDENCIES for DBA_DEPENDENCIES
/
comment on table DBA_DEPENDENCIES is
'Dependencies to and from objects'
/
comment on column DBA_DEPENDENCIES.OWNER is
'Owner of the object'
/
comment on column DBA_DEPENDENCIES.NAME is
'Name of the object'
/
comment on column DBA_DEPENDENCIES.TYPE is
'Type of the object'
/
comment on column DBA_DEPENDENCIES.REFERENCED_OWNER is
'Owner of referenced object (remote owner if remote object)'
/
comment on column DBA_DEPENDENCIES.REFERENCED_NAME is
'Name of referenced object'
/
comment on column DBA_DEPENDENCIES.REFERENCED_TYPE is
'Type of referenced object'
/
comment on column DBA_DEPENDENCIES.REFERENCED_LINK_NAME is
'Name of dblink if this is a remote object'
/


remark
remark    PUBLIC_DEPENDENCIES
remark    Hierarchic dependency information by object number
remark

create or replace view PUBLIC_DEPENDENCY
  (OBJECT_ID, REFERENCED_OBJECT_ID)
as
select d.d_obj#, d.p_obj# from dependency$ d
/
comment on table PUBLIC_DEPENDENCY is
'Dependencies to and from objects, by object number'
/
comment on column PUBLIC_DEPENDENCY.OBJECT_ID is
'Object number'
/
comment on column PUBLIC_DEPENDENCY.REFERENCED_OBJECT_ID is
'The referenced (parent) object'
/
drop public synonym PUBLIC_DEPENDENCY
/
create public synonym PUBLIC_DEPENDENCY for PUBLIC_DEPENDENCY
/
grant select on PUBLIC_DEPENDENCY to public with grant option
/

remark
remark    FAMILY "OBJECT_SIZE"
remark    Sizes of pl/sql items.
remark       source_size - this part must be in memory when the object
remark                     is compiled, or dynamically recompiled
remark       parsed_size - this part must be in memory when an object that
remark                     references this object is being compiled
remark       code_size   - this part must be in memory when this object
remark                     is executing
remark       error_size  - this part exists if the object has compilation
remark                     errors and need only be in memory until the
remark                     compilation completes
remark    Tables and views will also appear if they were ever referenced by
remark    a pl/sql object.  They will only have a parsed component.
remark

remark Define some of the supporting views

create or replace view CODE_PIECES
(OBJ#, BYTES)
as
  select i.obj#, i.length
  from sys.idl_ub1$ i
  where i.part in (1,2)
union all
  select i.obj#, i.length
  from sys.idl_ub2$ i
  where i.part in (1,2)
union all
  select i.obj#, i.length
  from sys.idl_sb4$ i
  where i.part in (1,2)
union all
  select i.obj#, i.length
  from sys.idl_char$ i
  where i.part in (1,2)
/

create or replace view CODE_SIZE
(OBJ#, BYTES)
as
  select c.obj#, sum(c.bytes)
  from sys.code_pieces c
  group by c.obj#
/

create or replace view PARSED_PIECES
(OBJ#, BYTES)
as
  select i.obj#, i.length
  from sys.idl_ub1$ i
  where i.part = 0
union all
  select i.obj#, i.length
  from sys.idl_ub2$ i
  where i.part = 0
union all
  select i.obj#, i.length
  from sys.idl_sb4$ i
  where i.part = 0
union all
  select i.obj#, i.length
  from sys.idl_char$ i
  where i.part = 0
/

create or replace view PARSED_SIZE
(OBJ#, BYTES)
as
  select c.obj#, sum(c.bytes)
  from sys.parsed_pieces c
  group by c.obj#
/

create or replace view SOURCE_SIZE
(OBJ#, BYTES)
as
  select s.obj#, sum(length(s.source))
  from sys.source$ s
  group by s.obj#
/

create or replace view ERROR_SIZE
(OBJ#, BYTES)
as
  select e.obj#, sum(e.textlength)
  from sys.error$ e
  group by e.obj#
/

create or replace view DBA_OBJECT_SIZE
(OWNER, NAME, TYPE, SOURCE_SIZE, PARSED_SIZE, CODE_SIZE, ERROR_SIZE)
as
  select u.name, o.name,
  decode(o.type, 2, 'TABLE', 4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
    7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE', 11, 'PACKAGE BODY',
    'UNDEFINED'),
  nvl(s.bytes,0), nvl(p.bytes,0), nvl(c.bytes,0), nvl(e.bytes,0)
  from sys.obj$ o, sys.user$ u,
    sys.source_size s, sys.parsed_size p, sys.code_size c, sys.error_size e
  where o.type in (2, 4, 5, 6, 7, 8, 9, 11)
    and o.owner# = u.user#
    and o.obj# = s.obj# (+)
    and o.obj# = p.obj# (+)
    and o.obj# = c.obj# (+)
    and o.obj# = e.obj# (+)
    and nvl(s.bytes,0) + nvl(p.bytes,0) + nvl(c.bytes,0) + nvl(e.bytes,0) > 0
/
drop public synonym DBA_OBJECT_SIZE
/
create public synonym DBA_OBJECT_SIZE for DBA_OBJECT_SIZE
/
comment on table DBA_OBJECT_SIZE is
'Sizes, in bytes, of various pl/sql objects'
/
comment on column DBA_OBJECT_SIZE.OWNER is
'Owner of the object'
/
comment on column DBA_OBJECT_SIZE.NAME is
'Name of the object'
/
comment on column DBA_OBJECT_SIZE.TYPE is
'Type of the object: "TABLE", "VIEW", "SYNONYM", "SEQUENCE", "PROCEDURE",
"FUNCTION", "PACKAGE" or "PACKAGE BODY"'
/
comment on column DBA_OBJECT_SIZE.SOURCE_SIZE is
'Size of the source, in bytes.  Must be in memory during compilation, or
dynamic recompilation'
/
comment on column DBA_OBJECT_SIZE.PARSED_SIZE is
'Size of the parsed form of the object, in bytes.  Must be in memory when
an object is being compiled that references this object'
/
comment on column DBA_OBJECT_SIZE.CODE_SIZE is
'Code size, in bytes.  Must be in memory when this object is executing'
/
comment on column DBA_OBJECT_SIZE.ERROR_SIZE is
'Size of error messages, in bytes.  In memory during the compilation of the object when there are compilation errors'
/

create or replace view USER_OBJECT_SIZE
(NAME, TYPE, SOURCE_SIZE, PARSED_SIZE, CODE_SIZE, ERROR_SIZE)
as
  select o.name,
  decode(o.type, 2, 'TABLE', 4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
    7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE', 11, 'PACKAGE BODY',
    'UNDEFINED'),
  nvl(s.bytes,0), nvl(p.bytes,0), nvl(c.bytes,0), nvl(e.bytes,0)
  from sys.obj$ o,
    sys.source_size s, sys.parsed_size p, sys.code_size c, sys.error_size e
  where o.type in (2, 4, 5, 6, 7, 8, 9, 11)
    and o.owner# = userenv('SCHEMAID')
    and o.obj# = s.obj# (+)
    and o.obj# = p.obj# (+)
    and o.obj# = c.obj# (+)
    and o.obj# = e.obj# (+)
    and nvl(s.bytes,0) + nvl(p.bytes,0) + nvl(c.bytes,0) + nvl(e.bytes,0) > 0
/
comment on table USER_OBJECT_SIZE is
'Sizes, in bytes, of various pl/sql objects'
/
comment on column USER_OBJECT_SIZE.NAME is
'Name of the object'
/
comment on column USER_OBJECT_SIZE.TYPE is
'Type of the object: "TABLE", "VIEW", "SYNONYM", "SEQUENCE", "PROCEDURE",
"FUNCTION", "PACKAGE" or "PACKAGE BODY"'
/
comment on column USER_OBJECT_SIZE.SOURCE_SIZE is
'Size of the source, in bytes.  Must be in memory during compilation, or
dynamic recompilation'
/
comment on column USER_OBJECT_SIZE.PARSED_SIZE is
'Size of the parsed form of the object, in bytes.  Must be in memory when
an object is being compiled that references this object'
/
comment on column USER_OBJECT_SIZE.CODE_SIZE is
'Code size, in bytes.  Must be in memory when this object is executing'
/
comment on column USER_OBJECT_SIZE.ERROR_SIZE is
'Size of error messages, in bytes.  In memory during the compilation of the object when there are compilation errors'
/
drop public synonym USER_OBJECT_SIZE
/
create public synonym USER_OBJECT_SIZE for USER_OBJECT_SIZE
/
grant select on USER_OBJECT_SIZE to public with grant option
/
