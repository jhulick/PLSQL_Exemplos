rem 
rem $Header: catdefer.sql,v 1.10 1995/09/14 13:50:00 jstamos Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      catdefer.sql - catalog of deferred rpc queues
Rem    DESCRIPTION
Rem      catalog of deferred rpc queues
Rem      This file contains sql which creates the base tables
Rem      used to store deferred remote procedure calls for used in
Rem      transaction replication.
Rem      Tables:
Rem         defTran
Rem         defTranDest
Rem         defError
Rem         defCallDest
Rem         defDefaultDest
Rem         defCall
Rem         defSchedule
Rem    RETURNS
Rem 
Rem    NOTES
Rem      Tables created in this file are owned by user system (not) sys
Rem      views are owned by sys and a synonym owned by sys is created to
Rem      hoopefully preserve code compatibility
REm      If this change works, no upgrade script is needed.
Rem      The defcalldest view defined in this file is replaced with a different
Rem      view by the catrepc.sql script.  If the repcat tables are installed,
Rem      the catrepc.sql script should always be run after this script is run.
Rem 
Rem      Tables are created in catdefrt.sql.  All other objects created here
Rem 
Rem    MODIFIED   (MM/DD/YY)
Rem     jstamos    08/17/95 -  code review changes
Rem     jstamos    08/16/95 -  add comments to views
Rem     hasun      01/23/95 -  Modify views for Rep3 - Object Groups
Rem     dsdaniel   01/25/95 -  merge changes from branch 1.5.720.4
Rem     dsdaniel   01/23/95 -  merge changes from branch 1.1.710.11
Rem     dsdaniel   01/05/95 -  need extra at sign
Rem     dsdaniel   12/23/94 -  merge changes from branch 1.5.720.1-3
Rem     dsdaniel   12/21/94 -  merge changes from branch 1.1.710.8-10
Rem     dsdaniel   12/08/94 -  revise defcalldest, deftrandest views
Rem     dsdaniel   11/22/94 -  split out table creations
Rem     dsdaniel   11/18/94 -  deftran-ectomy, deftrandest-ectomy
Rem     dsdaniel   11/17/94 -  merge changes from branch 1.1.710.7
Rem     dsdaniel   11/09/94 -  defcalldest, deftrandest changes
Rem     dsdaniel   08/04/94 -  make it a cluster (again)
Rem     dsdaniel   08/04/94 -  create a version without the cluster
Rem     dsdaniel   08/03/94 -  eliminate ON DELETE CASCADE *again
Rem     dsdaniel   08/02/94 -  make it a cluster
Rem     dsdaniel   07/28/94 -  restore ON DELETE CASCADE
Rem     dsdaniel   07/27/94 -  eliminate ON DELETE CASCADE
Rem     dsdaniel   07/19/94 -  export support changes
Rem     rjenkins   03/22/94 -  merge changes from branch 1.1.710.4
Rem     rjenkins   01/19/94 -  merge changes from branch 1.1.710.3
Rem     dsdaniel   01/18/94 -  merge changes from branch 1.1.710.2
Rem     rjenkins   01/17/94 -  changing jq to job
Rem     rjenkins   12/17/93 -  creating job queue
Rem     dsdaniel   10/31/93 -  merge changes from branch 1.1.710.1
Rem     dsdaniel   10/28/93 -  deferred rpc dblink security
Rem                         -  also removed table drops, since shouldnt
Rem                         -  loose data on upgrade
Rem     dsdaniel   10/26/93 -  merge changes from branch 1.1.400.1
Rem     dsdaniel   10/10/93 -  Creation from dbmsdefr
rem create base tables

-- Sys is granted privileges through roles, which don't apply to
-- packages owned by sys.  Explicitly grant permissions.
grant select any table to sys with admin option
/
grant insert any table to sys
/
grant update any table to sys
/
grant delete any table to sys
/

rem drop existing synonyms from sys -system

DROP SYNONYM def$_tran
/
DROP SYNONYM def$_call
/
DROP SYNONYM def$_calldest
/
DROP SYNONYM def$_error
/
DROP SYNONYM def$_defaultdest
/
DROP SYNONYM def$_schedule
/

--
--
@@catdefrt  
--
--
CREATE SYNONYM def$_call FOR system.def$_call
/
 
-- The old def$_tran tabl is a selection of the first def$_call record in
-- each transaction
CREATE OR REPLACE VIEW def$_tran AS
  SELECT deferred_tran_id, deferred_tran_db,
         origin_tran_id, origin_tran_db,
         origin_user_id, origin_user, delivery_order, 
         destination_list, start_time, commit_comment
    FROM def$_call 
    WHERE destination_list IS NOT NULL
/

comment on table DEF$_TRAN is
'Information about all deferred transactions'
/
comment on column DEF$_TRAN.DEFERRED_TRAN_ID is
'The transaction ID originating or copying deferred remote procedure calls'
/
comment on column DEF$_TRAN.DEFERRED_TRAN_DB is
'The database originating or copying the deferred remote procedure calls'
/
comment on column DEF$_TRAN.ORIGIN_TRAN_ID is
'The transaction ID originating deferred remote procedure calls'
/
comment on column DEF$_TRAN.ORIGIN_TRAN_DB is
'The database originating the deferred remote procedure calls'
/
comment on column DEF$_TRAN.ORIGIN_USER_ID is
'ID of user deferring a transaction'
/
comment on column DEF$_TRAN.ORIGIN_USER is
'Name of user deferring a transaction'
/
comment on column DEF$_TRAN.DELIVERY_ORDER is
'Total ordering on transactions'
/
comment on column DEF$_TRAN.DESTINATION_LIST is
'Determine destinations from def$_calldest (D) or repcat (R)'
/
comment on column DEF$_TRAN.START_TIME is
'Time original transaction started'
/
comment on column DEF$_TRAN.COMMIT_COMMENT is
'Any user-supplied comment'
/

CREATE SYNONYM def$_calldest FOR system.def$_calldest
/
CREATE SYNONYM def$_schedule FOR system.def$_schedule
/
CREATE SYNONYM def$_error FOR system.def$_error
/

CREATE OR REPLACE VIEW defschedule  AS
  SELECT s.dblink, s.job, j.interval, next_date, j.last_date, s.disabled,
         s.last_txn_count, s.last_error, s.last_msg
    FROM system.def$_destination s, sys.job$ j where s.job = j.job(+)
/

comment on table DEFSCHEDULE is
'Information about propagation to different destinations'
/
comment on column DEFSCHEDULE.DBLINK is
'Destination'
/
comment on column DEFSCHEDULE.JOB is
'Number of job that pushes queue'
/
comment on column DEFSCHEDULE.INTERVAL is
'Function used to calculate the next time to push the queue to destination'
/
comment on column DEFSCHEDULE.NEXT_DATE is
'Next date that job is scheduled to be executed'
/
comment on column DEFSCHEDULE.LAST_DATE is
'Last time queue was (attempted to be) pushed to destination'
/
comment on column DEFSCHEDULE.DISABLED is
'Is propagation to destination disabled'
/
comment on column DEFSCHEDULE.LAST_TXN_COUNT is
'Number of transactions pushed during last attempt'
/
comment on column DEFSCHEDULE.LAST_ERROR is
'Oracle error number from last push'
/
comment on column DEFSCHEDULE.LAST_MSG is
'Error message from last push'
/

DROP PUBLIC SYNONYM defschedule
/
CREATE PUBLIC SYNONYM defschedule FOR defschedule
/

CREATE OR REPLACE VIEW deferror AS
  SELECT deferred_tran_db, deferred_tran_id, callno, destination, 
         error_time, error_number, error_msg 
    FROM system.def$_error
/

comment on table DEFERROR is
'Information about all deferred transactions that caused an error'
/
comment on column DEFERROR.DEFERRED_TRAN_DB is
'The database originating or copying the deferred transaction'
/
comment on column DEFERROR.DEFERRED_TRAN_ID is
'The ID of the transaction that originated or copied the deferred transaction'
/
comment on column DEFERROR.CALLNO is
'Unique ID of call that caused an error'
/
comment on column DEFERROR.DESTINATION is
'Database link used to address destination'
/
comment on column DEFERROR.ERROR_TIME is
'Time error occurred'
/
comment on column DEFERROR.ERROR_NUMBER is
'Oracle error number'
/
comment on column DEFERROR.ERROR_MSG is
'Error message text'
/

DROP PUBLIC SYNONYM deferror
/
CREATE PUBLIC SYNONYM deferror for deferror
/

CREATE OR REPLACE VIEW deferrcount AS
  SELECT count(1) errcount, destination 
    FROM deferror GROUP BY destination
/

comment on table DEFERRCOUNT is
'Summary information about deferred transactions that caused an error'
/
comment on column DEFERRCOUNT.ERRCOUNT is
'Number of existing transactions that caused an error for given destination'
/
comment on column DEFERRCOUNT.DESTINATION is
'Database link used to address destination'
/

DROP PUBLIC SYNONYM deferrcount
/
CREATE PUBLIC SYNONYM deferrcount for deferrcount
/
GRANT SELECT ON deferrcount TO PUBLIC
/

CREATE OR REPLACE VIEW deftran AS
  SELECT deferred_tran_id, deferred_tran_db,
         NVL(origin_tran_id,deferred_tran_id) origin_tran_id, 
         NVL(origin_tran_db,deferred_tran_db) origin_tran_db,
         NVL(u.name,t.origin_user) origin_user, delivery_order, 
         destination_list, start_time, commit_comment
    FROM system.def$_call t, sys.user$ u
    WHERE u.user# (+)= t.origin_user_id
      AND t.destination_list IS NOT NULL
/

comment on table DEFTRAN is
'Information about all deferred transactions'
/
comment on column DEFTRAN.DEFERRED_TRAN_ID is
'The transaction ID originating or copying deferred remote procedure calls'
/
comment on column DEFTRAN.DEFERRED_TRAN_DB is
'The database originating or copying the deferred remote procedure calls'
/
comment on column DEFTRAN.ORIGIN_TRAN_ID is
'The transaction ID originating deferred remote procedure calls'
/
comment on column DEFTRAN.ORIGIN_TRAN_DB is
'The database originating the deferred remote procedure calls'
/
comment on column DEFTRAN.ORIGIN_USER is
'Name of user deferring a transaction'
/
comment on column DEFTRAN.DELIVERY_ORDER is
'Total ordering on transactions'
/
comment on column DEFTRAN.DESTINATION_LIST is
'Determine destinations from deftrandest (D) or repcat (R)'
/
comment on column DEFTRAN.START_TIME is
'Time original transaction started'
/
comment on column DEFTRAN.COMMIT_COMMENT is
'Any user-supplied comment'
/

DROP PUBLIC SYNONYM deftran
/
CREATE PUBLIC SYNONYM deftran FOR deftran
/

CREATE OR REPLACE VIEW defcalldest AS
  SELECT  C.callno, C.deferred_tran_id, C.deferred_tran_db, C.dblink
    FROM system.def$_calldest C
/
Rem The defcalldest view defined above is replaced in catrepc

comment on table DEFCALLDEST is
'Information about call destinations for deferred transactions'
/
comment on column DEFCALLDEST.CALLNO is
'Unique ID of call within transaction'
/
comment on column DEFCALLDEST.DEFERRED_TRAN_ID is
'Transaction ID'
/
comment on column DEFCALLDEST.DEFERRED_TRAN_DB is
'Originating database for the deferred transaction'
/
comment on column DEFCALLDEST.DBLINK is
'The destination database'
/

DROP PUBLIC SYNONYM defcalldest
/
CREATE PUBLIC SYNONYM defcalldest for defcalldest
/

CREATE OR REPLACE VIEW deftrandest AS
  SELECT UNIQUE deferred_tran_id, deferred_tran_db, dblink
    FROM sys.defcalldest
    WHERE NOT EXISTS (
      SELECT NULL
        FROM def$_error
        WHERE sys.defcalldest.deferred_tran_db=def$_error.deferred_tran_db
          AND sys.defcalldest.deferred_tran_id=def$_error.deferred_tran_id
          AND sys.defcalldest.dblink = def$_error.destination)
/
Rem The deftrandest view defined above is replaced in catrepc.

comment on table DEFTRANDEST is
'Information about destinations for deferred transactions'
/
comment on column DEFTRANDEST.DEFERRED_TRAN_ID is
'Transaction ID'
/
comment on column DEFTRANDEST.DEFERRED_TRAN_DB is
'Originating database for the deferred transaction'
/
comment on column DEFTRANDEST.DBLINK is
'The destination database'
/

DROP PUBLIC SYNONYM deftrandest
/
CREATE PUBLIC SYNONYM deftrandest FOR deftrandest
/

CREATE OR REPLACE VIEW defcall AS
  SELECT  callno, deferred_tran_db, deferred_tran_id, 
          schemaname, packagename, procname, argcount 
    FROM system.def$_call
    WHERE buffer_number = 1
/

comment on table DEFCALL is
'Information about all deferred remote procedure calls'
/
comment on column DEFCALL.callno is
'Unique ID, orders calls within a transaction'
/
comment on column DEFCALL.DEFERRED_TRAN_DB is
'Originating database of the deferred call'
/
comment on column DEFCALL.DEFERRED_TRAN_ID is
'The unique ID of the associated transaction'
/
comment on column DEFCALL.SCHEMANAME is
'The schema name of the deferred call'
/
comment on column DEFCALL.PACKAGENAME is
'The package name of the deferred call'
/
comment on column DEFCALL.PROCNAME is
'The procedure name of the deferred call'
/
comment on column DEFCALL.ARGCOUNT is
'The number of arguments to the deferred procedure call'
/

DROP PUBLIC SYNONYM defcall
/
CREATE PUBLIC SYNONYM defcall FOR defcall
/

--  Create table of default nodes for replication targets
--  this table is managed by calls in dbms_defer_sys

CREATE SYNONYM def$_defaultdest FOR system.def$_defaultdest
/
CREATE OR REPLACE VIEW defdefaultdest AS
  SELECT * from system.def$_defaultdest
/

comment on table DEFDEFAULTDEST is
'Default destinations for deferred remote procedure calls'
/
comment on column DEFDEFAULTDEST.DBLINK is
'Default destination'
/

DROP PUBLIC SYNONYM defdefaultdest
/
CREATE PUBLIC SYNONYM defdefaultdest for defdefaultdest
/

REM Set up export actions for deferred rpc tables.
rem delete existing export data

DELETE FROM expact$ WHERE name like 'DEF$_%'
/

insert into expact$ (owner, name, func_schema, func_package, func_proc, code)
values('SYSTEM','DEF$_CALL','SYS','DBMS_DEFER_IMPORT_INTERNAL',
        'QUEUE_EXPORT_CHECK',1)
/
insert into expact$ (owner, name, func_schema, func_package, func_proc, code)
values('SYSTEM','DEF$_CALLDEST','SYS','DBMS_DEFER_IMPORT_INTERNAL',
        'QUEUE_EXPORT_CHECK',1)
/
insert into expact$ (owner, name, func_schema, func_package, func_proc, code)
values('SYSTEM','DEF$_ERROR','SYS','DBMS_DEFER_IMPORT_INTERNAL',
        'QUEUE_EXPORT_CHECK',1)
/
insert into expact$ (owner, name, func_schema, func_package, func_proc, code)
values('SYSTEM','DEF$_DEFAULTDEST','SYS','DBMS_DEFER_IMPORT_INTERNAL',
        'QUEUE_EXPORT_CHECK',1)
/
insert into expact$ (owner, name, func_schema, func_package, func_proc, code)
values('SYSTEM','DEF$_DESTINATION','SYS','DBMS_DEFER_IMPORT_INTERNAL',
        'QUEUE_EXPORT_CHECK',1)
/
COMMIT
/
