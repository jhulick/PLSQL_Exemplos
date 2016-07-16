rem 
rem $Header: catdefrt.sql,v 1.7 1995/12/08 12:16:12 jstamos Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      catdefrt.sql - CATalog DEFeRred rpc Tables
Rem    DESCRIPTION
Rem      create deferred rpc tables
Rem    RETURNS
Rem 
Rem    NOTES
Rem      This is called from catdefer.sql
Rem    MODIFIED   (MM/DD/YY)
Rem     jstamos    12/04/95 -  324303: use index to avoid sorting the queue
Rem     jstamos    08/17/95 -  code review changes
Rem     jstamos    08/16/95 -  add comments to tables
Rem     hasun      01/31/95 -  Modify tables for Rep3 - Object Groups
Rem     hasun      01/31/95 -  merge changes from branch 1.1.720.2
Rem     hasun      01/11/95 -  Add fix to resolve duplicate SCNs
Rem     dsdaniel   12/08/94 -  add def _destinaton constraint
Rem     dsdaniel   12/08/94 -  name defcall primary
Rem     dsdaniel   11/25/94 -  eliminate deftrandest, ect
Rem     dsdaniel   11/25/94 -  Branch_for_patch
Rem     dsdaniel   11/22/94 -  Creation

--  create the call table.  One row for each deferred call.
CREATE TABLE system.def$_call  (
  deferred_tran_db VARCHAR2(128),   -- origin db
  deferred_tran_id  VARCHAR2(22),   -- transaction id
  buffer_number NUMBER,            -- parameters buffer number 
  callno            NUMBER,         -- UID of call, orders calls in transaction 
   CONSTRAINT def$_calls_primary
      PRIMARY KEY(deferred_tran_db, deferred_tran_id, callno, buffer_number),
  schemaname    VARCHAR2(30),      -- schema name NOT NULL
  packagename   VARCHAR2(30),      -- package name  NOT NULL
  procname      VARCHAR2(30),      -- procedue name NOT NULL
  argcount      NUMBER,            -- # of args  NOT NULL
  parm_buffer   LONG RAW,          -- parameters buffer    
  -- THE FOLLOWING COLUMNS ARE NONLY NON-NULL FOR THE FIRST (lowest callno,
  -- buffno = 1 
  destination_list CHAR(1),       -- R = RepSchema, D = def$_calldest
  origin_user_id   NUMBER,        -- userid deferring tran
  origin_user      VARCHAR2(30),  -- user deferring tran (used at remote)
  delivery_order   NUMBER,        -- order to deliver to destinations
  origin_tran_id   VARCHAR2(22),  -- original tid (if copied)
  origin_tran_db   VARCHAR2(128), -- origial  node
  start_time       DATE,          -- time original tid started
  destination_count INTEGER,      -- set on first push
  commit_comment VARCHAR2(50)     -- commit comment
)    
/

comment on table SYSTEM.DEF$_CALL is
'Information about all deferred remote procedure calls'
/
comment on column SYSTEM.DEF$_CALL.DEFERRED_TRAN_DB is
'Originating database of the deferred call'
/
comment on column SYSTEM.DEF$_CALL.DEFERRED_TRAN_ID is
'The unique ID of the associated transaction'
/
comment on column SYSTEM.DEF$_CALL.BUFFER_NUMBER is
'1-based counter for calls with multiple buffers'
/
comment on column SYSTEM.DEF$_CALL.callno is
'Unique ID, orders calls within a transaction'
/
comment on column SYSTEM.DEF$_CALL.SCHEMANAME is
'The schema name of the deferred call'
/
comment on column SYSTEM.DEF$_CALL.PACKAGENAME is
'The package name of the deferred call'
/
comment on column SYSTEM.DEF$_CALL.PROCNAME is
'The procedure name of the deferred call'
/
comment on column SYSTEM.DEF$_CALL.ARGCOUNT is
'The number of arguments to the deferred procedure call'
/
comment on column SYSTEM.DEF$_CALL.PARM_BUFFER is
'Marshalled parameters for the deferred call'
/
comment on column SYSTEM.DEF$_CALL.DESTINATION_LIST is
'Determine destinations from def$_calldest (D) or repcat (R)'
/
comment on column SYSTEM.DEF$_CALL.ORIGIN_USER_ID is
'ID of user deferring a transaction'
/
comment on column SYSTEM.DEF$_CALL.ORIGIN_USER is
'Name of user deferring a transaction'
/
comment on column SYSTEM.DEF$_CALL.DELIVERY_ORDER is
'Total ordering on transactions'
/
comment on column SYSTEM.DEF$_CALL.ORIGIN_TRAN_ID is
'Original deferred_tran_id if copied'
/
comment on column SYSTEM.DEF$_CALL.ORIGIN_TRAN_DB is
'Original deferred_tran_db if copied'
/
comment on column SYSTEM.DEF$_CALL.START_TIME is
'Time original transaction started'
/
comment on column SYSTEM.DEF$_CALL.DESTINATION_COUNT is
'Number of outstanding destinations for R-type transactions'
/
comment on column SYSTEM.DEF$_CALL.COMMIT_COMMENT is
'Any user-supplied comment'
/


rem create an index on delivery order to speed things up
create index system.def$_tranorder on
  system.def$_call(delivery_order, deferred_tran_id, deferred_tran_db)
/


--  create the table where the exceptions get logged. One row for each
--  transactionXorigin_node when the execution of the transaction at 
--  this  node encountered  an error.
CREATE TABLE system.def$_error(
  deferred_tran_db VARCHAR2(128),  -- node origination/copying txn
  deferred_tran_id VARCHAR2(22),   -- transaction id
  callno           NUMBER,           -- UID of call
-- forign key constrain on call not used.  Users can create error transacitons
-- with null or invalid callno - it is for documenation only
--  dummy_buffer_number NUMBER DEFAULT 1,
--    CONSTRAINT def$_error_call
--      FOREIGN KEY(callno, dummy_buffer_number, deferred_tran_db)
--      REFERENCES system.def$_call(callno, buffer_number, deferred_tran_db),
   destination     VARCHAR2(128),  -- dblink transaciton destined to
     CONSTRAINT def$_error_primary
        PRIMARY KEY(deferred_tran_db, deferred_tran_id, destination),
   error_time      DATE,           -- time at which 
                                   -- conflit occured
   error_number    NUMBER,         -- error 
                                   -- number reported
   error_msg       VARCHAR2(2000)) -- error message
/

comment on table SYSTEM.DEF$_ERROR is
'Information about all deferred transactions that caused an error'
/
comment on column SYSTEM.DEF$_ERROR.DEFERRED_TRAN_DB is
'The database originating or copying the deferred transaction'
/
comment on column SYSTEM.DEF$_ERROR.DEFERRED_TRAN_ID is
'The ID of the transaction that originated or copied the deferred transaction'
/
comment on column SYSTEM.DEF$_ERROR.CALLNO is
'Unique ID of call that caused an error'
/
comment on column SYSTEM.DEF$_ERROR.DESTINATION is
'Database link used to address destination'
/
comment on column SYSTEM.DEF$_ERROR.ERROR_TIME is
'Time error occurred'
/
comment on column SYSTEM.DEF$_ERROR.ERROR_NUMBER is
'Oracle error number'
/
comment on column SYSTEM.DEF$_ERROR.ERROR_MSG is
'Error message text'
/


CREATE TABLE system.def$_destination(
  dblink         VARCHAR2(128)  -- queue name
    CONSTRAINT def$_destination_primary PRIMARY KEY,
  last_delivered NUMBER         -- scn (from deliver_order column of def$_call)
                         DEFAULT 0 NOT NULL,
  last_tran_id   VARCHAR2(22),  -- transaction id last delivered
  last_tran_db   VARCHAR2(128), -- node  origination/copying last delivered txn
  disabled       CHAR(1),       -- T = propogtion to dest disabled F = enabled 
  job            NUMBER,        -- number of job which does the push
  last_txn_count NUMBER,        -- number of transacitons executed lat push
  last_error     NUMBER,        -- sqlcode from last push
  last_msg       VARCHAR2(2000))-- error message from last push
/

comment on table SYSTEM.DEF$_DESTINATION is
'Information about propagation to different destinations'
/
comment on column SYSTEM.DEF$_DESTINATION.DBLINK is
'Destination'
/
comment on column SYSTEM.DEF$_DESTINATION.LAST_DELIVERED is
'Value of delivery_order of last transaction propagated'
/
comment on column SYSTEM.DEF$_DESTINATION.LAST_TRAN_ID is
'Transaction ID of last transaction propagated'
/
comment on column SYSTEM.DEF$_DESTINATION.LAST_TRAN_DB is
'Source of last transaction propagated'
/
comment on column SYSTEM.DEF$_DESTINATION.DISABLED is
'Is propagation to destination disabled'
/
comment on column SYSTEM.DEF$_DESTINATION.JOB is
'Number of job that pushes queue'
/
comment on column SYSTEM.DEF$_DESTINATION.LAST_TXN_COUNT is
'Number of transactions pushed during last attempt'
/
comment on column SYSTEM.DEF$_DESTINATION.LAST_ERROR is
'Oracle error number from last push'
/
comment on column SYSTEM.DEF$_DESTINATION.LAST_MSG is
'Error message from last push'
/


--  create the  table that identifies a call to be executed	
--  at a remote node. One row for each callsXnode when the 
--  destination_list is D
CREATE TABLE system.def$_calldest(
  deferred_tran_db VARCHAR2(128), -- deferred transaction db
  deferred_tran_id VARCHAR2(22),  -- deferred transaction id
  callno           NUMBER,        -- call id 
  dummy_buffer_number NUMBER DEFAULT 1, -- for forign key reference
    CONSTRAINT def$_calldest_call
      FOREIGN KEY(deferred_tran_db,
                           deferred_tran_id, callno, dummy_buffer_number)
      REFERENCES system.def$_call(deferred_tran_db,
                                  deferred_tran_id, callno, buffer_number),
  dblink           VARCHAR2(128), -- dblink to destination
    CONSTRAINT def$_calldest_primary 
      PRIMARY KEY(deferred_tran_db, deferred_tran_id, 
                  callno, dblink),
   CONSTRAINT def$_call_destination  -- Destination table must have a row
      FOREIGN KEY(dblink)  
      REFERENCES system.def$_destination(dblink))
/                    

comment on table SYSTEM.DEF$_CALLDEST is
'Information about call destinations for D-type and error transactions'
/
comment on column SYSTEM.DEF$_CALLDEST.DEFERRED_TRAN_DB is
'Originating database for the deferred transaction'
/
comment on column SYSTEM.DEF$_CALLDEST.DEFERRED_TRAN_ID is
'Transaction ID'
/
comment on column SYSTEM.DEF$_CALLDEST.CALLNO is
'Unique ID of call within transaction'
/
comment on column SYSTEM.DEF$_CALLDEST.DUMMY_BUFFER_NUMBER is
'Used for foreign key reference only'
/
comment on column SYSTEM.DEF$_CALLDEST.DBLINK is
'The destination database'
/


CREATE TABLE system.def$_defaultdest (
  dblink VARCHAR2(128)  -- dblink 
    CONSTRAINT def$_defalutdest_primary
    PRIMARY KEY)
/

comment on table SYSTEM.DEF$_DEFAULTDEST is
'Default destinations for deferred remote procedure calls'
/
comment on column SYSTEM.DEF$_DEFAULTDEST.DBLINK is
'Default destination'
/
COMMIT
/
