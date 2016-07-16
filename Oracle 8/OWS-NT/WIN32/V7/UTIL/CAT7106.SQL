rem 
rem $Header: cat7106.sql,v 1.3 1995/01/31 08:12:43 hasun Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      cat7106.sql 
Rem    DESCRIPTION
Rem      Upgrade script from 7.1.3, 7.1.4, or 7.1.5 to 7.1.6
Rem    RETURNS
Rem 
Rem    NOTES
Rem      You must connect internal to run this script.
Rem      The files: catrep.sql, catdefer.sql must also be sourced
Rem      after this file to obtain the full version of replication in 7.1.6.
Rem    MODIFIED   (MM/DD/YY)
Rem     hasun      01/31/95 -  merge changes from branch 1.1.720.2
Rem     hasun      01/12/95 -  Add columns for duplicate SCN fix
Rem     hasun      12/28/94 -  Insert into def$_destination before
Rem                            foreign key is added to repcat$_repschema
Rem     hasun      12/12/94 -  Add new constraint to repcat$_repschema
Rem                            Add new constraint to def$_destination
Rem     hasun      12/12/94 -  Branch_for_patch
Rem     hasun      12/12/94 -  Creation
 
Rem
Rem --------------------
Rem CASE 1: 7.1.3, 7.1.4
Rem --------------------
Rem All of the def$ tables are owned by SYS. All of the tables must 
Rem be dropped and in the correct order to avoid constraint conlicts.
Rem
Rem -------------
Rem CASE 2: 7.1.5
Rem -------------
Rem All of the def$ tables are owned by SYSTEM. 
Rem The following tables need to be dropped:
Rem system.def$_trandest
Rem system.def$_tran
Rem system.def$_schedule
Rem The following tables need to be altered:
Rem system.def$_call
Rem 

Rem -----------------------------------------------------------------
Rem CASE 1: 7.1.3, 7.1.4
Rem -----------------------------------------------------------------
Rem
Rem Drop def$ that were previous own by SYS
Rem
DROP TABLE sys.def$_calldest;
DROP TABLE sys.def$_call;
DROP TABLE sys.def$_error;
DROP TABLE sys.def$_defaultdest;
DROP TABLE sys.def$_trandest;
DROP TABLE sys.def$_tran;
DROP TABLE sys.def$_schedule;

Rem ----------------------------------------------------------------
Rem CASE 2: 7.1.5
Rem -----------------------------------------------------------------
Rem
Rem In order to drop def$_tran, the foreign key constraints 
Rem for def$_call and def$_error must be dropped. In addition
Rem these constraints do not exist in 7.1.6
Rem
ALTER TABLE system.def$_call DROP CONSTRAINT def$_calls_prnt;
ALTER TABLE system.def$_error DROP CONSTRAINT def$_error_tran;

Rem
Rem Add new columns to def$_call in 7.1.6
Rem
ALTER TABLE system.def$_call ADD (
  destination_list CHAR(1),        /* R = RepSchema, D = def$_calldest */
  origin_user_id   NUMBER,         /* userid deferring tran */
  origin_user      VARCHAR2(30),   /* user deferring tran (used at remote) */
  delivery_order   NUMBER,         /* order to deliver to destinations */
  origin_tran_id   VARCHAR2(22),   /* original tid (if copied) */
  origin_tran_db   VARCHAR2(128),  /* origial  node */
  start_time       DATE,           /* time original tid started */
  destination_count INTEGER,       /* set on first push */
  commit_comment VARCHAR2(50)      /* commit comment */
)
/

Rem
Rem Drop tables replaced by views
Rem
DROP TABLE system.def$_trandest;
DROP TABLE system.def$_tran;
DROP TABLE system.def$_schedule;

Rem
Rem  The tables def$_calldest and repcat$_repschema have new 
Rem  foreign key constraints on def$_destination, a new table in 7.1.6
Rem  Before the constraints are added, def$_destination must exist.
Rem
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
  last_msg       VARCHAR2(255)) -- error message from last push
/

ALTER TABLE system.def$_calldest ADD (
  CONSTRAINT def$_call_destination  -- Destination table must have a row
    FOREIGN KEY(dblink)  
    REFERENCES system.def$_destination(dblink)
)
/

Rem
Rem repcat$_repschema may already contain data that may not be in 
Rem def$_destination. Thus before the foreign key constraint can be added
Rem def$_destination must be populated.
Rem

INSERT INTO system.def$_destination (dblink) 
  SELECT DISTINCT dblink 
  FROM system.repcat$_repschema
  WHERE dblink NOT IN (SELECT dblink FROM system.def$_destination);


ALTER TABLE system.repcat$_repschema ADD (
  CONSTRAINT repcat$_repschema_dest 
    FOREIGN KEY(dblink)
    REFERENCES system.def$_destination(dblink)
)
/
