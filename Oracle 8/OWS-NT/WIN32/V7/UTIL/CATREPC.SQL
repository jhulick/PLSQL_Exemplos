rem 
rem $Header: catrepc.sql,v 1.16 1995/11/20 13:08:17 sjain Exp $ 
rem 
Rem  Copyright (c) 1993 by Oracle Corporation 
Rem  ***** Oracle Proprietary                                           *****
Rem  ***** This file contains the embodiment of proprietary technology. *****
Rem  ***** It is for the sole use of Oracle employees and Oracle        *****
Rem  ***** customers who have executed non-disclosure agreements.      *****
Rem  ***** The contents of this file may not be disclosed to persons    *****
Rem  ***** or organization who have not executed a non-disclosure      *****
Rem  ***** agreement.                                                   *****
Rem    NAME
Rem      catrep.sql - replication catalog tables and views
Rem    DESCRIPTION
Rem      This file implements the repcat tables, views, and sequences.
Rem      Tables:
Rem         repcat$_repcat
Rem         repcat$_repschema
Rem         repcat$_repobject
Rem         repcat$_key_columns
Rem         repcat$_generated
Rem         repcat$_repprop
Rem         repcat$_repcatlog
Rem         repcat$_ddl
Rem       Sequences
Rem         repcat_log_sequence
Rem
Rem      This following repcat tables are for conflict resolution 
Rem      Tables:
Rem         repcat$_audit_column
Rem         repcat$_audit_attribute
Rem         repcat$_parameter_column
Rem         repcat$_resolution
Rem         repcat$_resolution_method
Rem         repcat$_conflict
Rem         repcat$_grouped_column
Rem         repcat$_column_group
Rem         repcat$_priority
Rem         repcat$_priority_group
Rem         repcat$_statistics_control
Rem         repcat$_statistics
Rem
Rem     The following views replace simpler views defined in catdefer.sql
Rem     They reflect more repcat based deferred rpc destinations.
Rem         defcalldest
Rem         deftrandest
Rem     The following package is created or replaced to make grants necessary
Rem     to enable SYS to grant select in defcalldest.
Rem         system.ora$_sys_rep_auth
Rem
Rem    NOTES
Rem      Must be run when connected to SYS or INTERNAL
Rem
Rem    DEPENDENCIES
Rem      
Rem    USAGE
Rem
Rem    SECURITY
Rem
Rem    COMPATIBILITY
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     sjain      10/10/95 -  Name changes of dba_repcat etc.
Rem     jstamos    09/21/95 -  null oname implies null sname: repcat_repcatlog
Rem     jstamos    08/17/95 -  code review changes for deferred RPCs
Rem     hasun      05/25/95 -  Create public synonyms for DBA_ views
Rem     hasun      05/10/95 -  Modify Deferred RPC views for Object Group
Rem     hasun      04/20/95 -  Restore Rep3 semantics to all_repcat, all_repsch
Rem     hasun      04/11/95 -  merge changes from branch 1.2.720.6
Rem     hasun      03/30/95 -  BUG#273284: Modify to support PUBLIC repschema
Rem     hasun      03/23/95 -  Replace foreign key contraint in reprop
Rem     hasun      03/20/95 -  Change RepCat for SYNC Replication
Rem     hasun      01/31/95 -  Modify tables and views for Rep3 - Object Groups
Rem     hasun      01/31/95 -  merge changes from branch 1.2.720.5
Rem     hasun      01/23/95 -  merge changes from branch 1.1.710.9
Rem     jstamos    01/20/95 -  add primary key and index
Rem     jstamos    01/20/95 -  merge changes from branch 1.2.720.4
Rem     hasun      01/11/95 -  Add fix to resolve duplicate SCNs
Rem     wmaimone   12/29/94 -  BUG#254503 commit is SQL
Rem     adowning   12/23/94 -  merge changes from branch 1.2.720.1
Rem     adowning   12/21/94 -  merge changes from branch 1.1.710.6-8
Rem     jstamos    12/08/94 -  foreign key in repschema to def$_destination
Rem     dsdaniel   12/05/94 -  eliminate deftrandest
Rem     adowning   12/05/94 -  fix all_repobject, all_repgenerated
Rem     dsdaniel   11/17/94 -  merge changes from branch 1.1.710.5
Rem     dsdaniel   11/11/94 -  defcalldest view
Rem     dsdaniel   10/13/94 -  merge changes from branch 1.1.710.3
Rem     jstamos    08/10/94 -  move trigger creation to prvtrepc.sql
Rem     adowning   06/14/94 -  made tables owned by system
Rem     ldoo       06/14/94 -  Creation of conflict resolution tables
Rem     adowning   02/04/94 -  Branch_for_patch
Rem     adowning   02/04/94 -  Creation
Rem     adowning   02/04/94 -  Official creation
Rem     jstamos    09/20/93 -  Creation
Rem     jstamos    09/20/93 -  Unofficial creation
Rem     ldoo       06/28/92 -  Added objects for collecting statistics.

--                               NOTE
-- the procedure dbms_repcat_utl.canonicalize converts names to a common form
-- the columns sname, oname, col, and rname_procedure in the following
--   repcat tables are canonicalized
-- each variable with the name canon_* must have been canonicalized
-- each IN parameter with the name canon_* must be canonicalized
--   unless specified otherwise, such a parameter must not be NULL

-- Sys is granted priviledges through roles, which don't apply to
-- packages owned by sys.  Explicitly grant permissions.
grant select any table to sys with admin option;
grant insert any table to sys;
grant update any table to sys;
grant delete any table to sys;
grant select any sequence to sys;

--  create a table for replicated object groups
CREATE TABLE system.repcat$_repcat
(
  sname           VARCHAR2(30),  -- interpreted as object group name
                    CONSTRAINT repcat$_repcat_primary PRIMARY KEY(sname),
  master          VARCHAR2(1),   -- Y=master, N=snapshot
  status          INTEGER        -- master: NORMAL, QUIESCING, or QUIESCED
                                 -- snapshot: NULL
                    CONSTRAINT repcat$_repcat_status
                      CHECK (status IN (0, 1, 2)),
  schema_comment  VARCHAR2(80)
)
/
comment on table SYSTEM.REPCAT$_REPCAT is
'Information about all replicated object groups'
/
comment on column SYSTEM.REPCAT$_REPCAT.SNAME is
'Name of the replicated object group'
/
comment on column SYSTEM.REPCAT$_REPCAT.MASTER is
'Is the site a master site for the replicated object group'
/
comment on column SYSTEM.REPCAT$_REPCAT.STATUS is
'If the site is a master, the master''s status'
/
comment on column SYSTEM.REPCAT$_REPCAT.SCHEMA_COMMENT is
'Description of the replicated object group'
/

CREATE OR REPLACE VIEW repcat_repcat
  (sname, --- OBSOLETE
   master, status, schema_comment, gname) AS
  SELECT
    sname,
    master,
    DECODE (status,
      0,    'NORMAL',
      1,    'QUIESCING',
      2,    'QUIESCED',
      NULL, 'NORMAL',
            'UNDEFINED'),
    schema_comment,
    sname
  FROM system.repcat$_repcat
/
comment on table REPCAT_REPCAT is
'Information about all replicated object groups'
/
comment on column REPCAT_REPCAT.SNAME is
'OBSOLETE COLUMN: Name of the replicated schema'
/
comment on column REPCAT_REPCAT.GNAME is
'Name of the replicated object group'
/
comment on column REPCAT_REPCAT.MASTER is
'Is the site a master site for the replicated object group'
/
comment on column REPCAT_REPCAT.STATUS is
'If the site is a master, the master''s status'
/
comment on column REPCAT_REPCAT.SCHEMA_COMMENT is
'Description of the replicated object group'
/

-- create a table to hold the masters for replicated object groups
-- if it is modified, modify the repcat_repschema view if appropriate
CREATE TABLE system.repcat$_repschema
(
  sname           VARCHAR2(30),   -- interpreted as object group name
                    CONSTRAINT repcat$_repschema_prnt FOREIGN KEY(sname)
                      REFERENCES system.repcat$_repcat(sname)
                      ON DELETE CASCADE,
  dblink          VARCHAR2(128),  -- a master site (M_XDBI)
                    CONSTRAINT repcat$_repschema_primary
                      PRIMARY KEY(sname, dblink),
                    CONSTRAINT repcat$_repschema_dest FOREIGN KEY(dblink)
                      REFERENCES system.def$_destination(dblink),
  masterdef       VARCHAR2(1),
                    -- Y: the master has the authoritative definition
                    -- N: the master has a copy
  snapmaster      VARCHAR2(1),
                    -- this col is maintained independently at each replica
                    -- master: NULL
                    -- snapshot: Y indicates current master for refreshing
                    -- snapshot: N for all other masters
  master_comment  VARCHAR2(80),
  master          VARCHAR2(1),
                    -- Y=master, N=snapshot
                    -- this column duplicates repcat$_repcat.master
                    -- it is here to improve deferred RPC performance
  prop_updates    NUMBER DEFAULT 0,
  my_dblink       VARCHAR2(1)
                    -- Y = the dblink is my global_name
                    -- N = ignore
                    -- this column is here to detect a problem during import
)
/
comment on table SYSTEM.REPCAT$_REPSCHEMA is
'N-way replication information'
/
comment on column SYSTEM.REPCAT$_REPSCHEMA.SNAME is
'Name of the replicated object group'
/
comment on column SYSTEM.REPCAT$_REPSCHEMA.DBLINK is
'A database site replicating the object group'
/
comment on column SYSTEM.REPCAT$_REPSCHEMA.MASTERDEF is
'Is the database the master definition site for the replicated object group'
/
comment on column SYSTEM.REPCAT$_REPSCHEMA.SNAPMASTER is
'For a snapshot site, is this the current refresh_master'
/
comment on column SYSTEM.REPCAT$_REPSCHEMA.MASTER_COMMENT is
'Description of the database site'
/
comment on column SYSTEM.REPCAT$_REPSCHEMA.MASTER is
'Redundant information from repcat$_repcat.master'
/
comment on column SYSTEM.REPCAT$_REPSCHEMA.PROP_UPDATES is
'Number of requested updates for master in repcat$_repprop'
/
comment on column SYSTEM.REPCAT$_REPSCHEMA.MY_DBLINK is
'A sanity check after import: is this master the current site'
/

-- hide unnormalized, duplicate data (master column) from users
CREATE OR REPLACE VIEW repcat_repschema 
(sname, --- OBSOLETE
 dblink, masterdef, snapmaster, master_comment, gname)
AS
SELECT sname, dblink, masterdef, snapmaster, master_comment, sname
FROM system.repcat$_repschema
/
comment on table REPCAT_REPSCHEMA is
'N-way replication information'
/
comment on column REPCAT_REPSCHEMA.SNAME is
'OBSOLETE COLUMN: Name of the replicated schema'
/
comment on column REPCAT_REPSCHEMA.GNAME is
'Name of the replicated object group'
/
comment on column REPCAT_REPSCHEMA.DBLINK is
'A database site replicating the object group'
/
comment on column REPCAT_REPSCHEMA.MASTERDEF is
'Is the database the master definition site for the replicated object group'
/
comment on column REPCAT_REPSCHEMA.SNAPMASTER is
'For a snapshot site, is this the current refresh_master'
/
comment on column REPCAT_REPSCHEMA.MASTER_COMMENT is
'Description of the database site'
/

-- create a table that names the replicated objects
CREATE TABLE system.repcat$_repobject
(
  sname           VARCHAR2(30),  -- owner of replicated object
  oname           VARCHAR2(30),  -- replicated object name,
  type            INTEGER
                    CONSTRAINT repcat$_repobject_type
                      CHECK (type IN (-1, 1, 2, 4, 5, 7, 8, 9, 11, 12, -3)),
                    CONSTRAINT repcat$_repobject_primary
                      PRIMARY KEY(sname, oname, type),
  id              NUMBER,
  object_comment  VARCHAR2(80),
  status          INTEGER
                    -- this col is maintained independently at each replica
                    CONSTRAINT repcat$_repobject_status
                      CHECK (status IN (0, 1, 2, 3, 4)),
  gname           VARCHAR2(30),  -- replicated object group name
                    CONSTRAINT repcat$_repobject_prnt FOREIGN KEY(gname)
                      REFERENCES system.repcat$_repcat(sname)
                      ON DELETE CASCADE
)
/
comment on table SYSTEM.REPCAT$_REPOBJECT is
'Information about replicated objects'
/
comment on column SYSTEM.REPCAT$_REPOBJECT.GNAME is
'Name of the object''s object group'
/
comment on column SYSTEM.REPCAT$_REPOBJECT.SNAME is
'Name of the object owner'
/
comment on column SYSTEM.REPCAT$_REPOBJECT.ONAME is
'Name of the object'
/
comment on column SYSTEM.REPCAT$_REPOBJECT.TYPE is
'Type of the object'
/
comment on column SYSTEM.REPCAT$_REPOBJECT.STATUS is
'Status of the last create or alter request on the local object'
/
comment on column SYSTEM.REPCAT$_REPOBJECT.ID is
'Identifier of the local object'
/
comment on column SYSTEM.REPCAT$_REPOBJECT.OBJECT_COMMENT is
'Description of the replicated object'
/

CREATE OR REPLACE VIEW repcat_repobject
  (sname, oname, type, status, id, object_comment, gname) AS
  SELECT
    sname,
    oname,
    DECODE (type,
      -1, 'SNAPSHOT',
       1, 'INDEX',
       2, 'TABLE',
       4, 'VIEW',
       5, 'SYNONYM',
       6, 'SEQUENCE',
       7, 'PROCEDURE',
       8, 'FUNCTION',
       9, 'PACKAGE',
      11, 'PACKAGE BODY',
      12, 'TRIGGER',
      --- -3, 'UPDATABLE SNAPSHOT',
          'UNDEFINED'),
    DECODE (status,
      0, 'CREATE',
      1, 'COMPARE',
      2, 'VALID',
      3, 'DROPPED',
      4, 'ERROR',
         'UNDEFINED'),
    id,
    object_comment,
    gname
  FROM system.repcat$_repobject
/
comment on table REPCAT_REPOBJECT is
'Information about replicated objects'
/
comment on column REPCAT_REPOBJECT.GNAME is
'Name of the object''s object group'
/
comment on column REPCAT_REPOBJECT.SNAME is
'Name of the object owner'
/
comment on column REPCAT_REPOBJECT.ONAME is
'Name of the object'
/
comment on column REPCAT_REPOBJECT.TYPE is
'Type of the object'
/
comment on column REPCAT_REPOBJECT.STATUS is
'Status of the last create or alter request on the local object'
/
comment on column REPCAT_REPOBJECT.ID is
'Identifier of the local object'
/
comment on column REPCAT_REPOBJECT.OBJECT_COMMENT is
'Description of the replicated object'
/

-- create a table that names "primary-key" columns for column-level repl
CREATE TABLE system.repcat$_key_columns
(
  sname  VARCHAR2(30),  -- schema name
  oname  VARCHAR2(30),  -- replicated object name
  type   INTEGER,
           CONSTRAINT repcat$_key_columns_prnt
             FOREIGN KEY(sname, oname, type)
             REFERENCES system.repcat$_repobject(sname, oname, type)
             ON DELETE CASCADE,
  col    VARCHAR2(30),
           CONSTRAINT repcat$_key_columns_primary
             PRIMARY KEY(sname, oname, col)
)
/
comment on table SYSTEM.REPCAT$_KEY_COLUMNS is
'Primary columns for a table using column-level replication'
/
comment on column SYSTEM.REPCAT$_KEY_COLUMNS.SNAME is
'Schema containing table'
/
comment on column SYSTEM.REPCAT$_KEY_COLUMNS.ONAME is
'Name of the table'
/
comment on column SYSTEM.REPCAT$_KEY_COLUMNS.TYPE is
'Type identifier'
/
comment on column SYSTEM.REPCAT$_KEY_COLUMNS.COL is
'Column in the table'
/

-- track the objects generated to support row/column-level replication
-- as well as wrappers generated to support procedural replication
CREATE TABLE system.repcat$_generated
(
  sname              VARCHAR2(30),  -- schema of generated object
  oname              VARCHAR2(30),  -- name of generated object
  type               INTEGER,	    -- type of generated object
                       CONSTRAINT repcat$_repgen_primary
                         PRIMARY KEY(sname, oname, type),
                       CONSTRAINT repcat$_repgen_prnt
                         FOREIGN KEY(sname, oname, type)
                         REFERENCES system.repcat$_repobject(sname, oname,
                                                             type)
                         ON DELETE CASCADE,
  reason              NUMBER,
                       CONSTRAINT repcat$_generated_obj
                         CHECK (reason IN (0, 1, 2, 3, 4, 5, 6, 7)),
                         -- 0 = trigger (Rep2 async propagation) $RT          
                         -- 1 = replication package              $RP
                         -- 2 = resolution package               $RR
                         -- 3 = priority package                 $RV
                         -- 4 = auditing package                 $RA
                         -- 5 = procedural replication wrapper   
                         -- 6 = Rep3 trigger package             $TP
                         -- 7 = Rep3 trigger (mixed propagation) $RT
  base_sname         VARCHAR2(30),  -- schema of user's object
  base_oname         VARCHAR2(30),  -- name of user's object
  base_type          INTEGER,	    -- type of user's object
                       CONSTRAINT repcat$_repgen_prnt2
                         FOREIGN KEY(base_sname, base_oname, base_type)
                         REFERENCES system.repcat$_repobject(sname, oname,
                                                             type)
                         ON DELETE CASCADE,
  package_prefix    VARCHAR2(30),   -- for package wrappers
  procedure_prefix  VARCHAR2(30),   -- for procedure and package wrappers
				    -- universal code will have two 'Y's below
  distributed       VARCHAR2(1)     -- 'Y' or 'N'
)
/
comment on table SYSTEM.REPCAT$_GENERATED is
'Objects generated to support replication'
/
comment on column SYSTEM.REPCAT$_GENERATED.SNAME is
'Schema containing the generated object'
/
comment on column SYSTEM.REPCAT$_GENERATED.ONAME is
'Name of the generated object'
/
comment on column SYSTEM.REPCAT$_GENERATED.TYPE is
'Type of the generated object'
/
comment on column SYSTEM.REPCAT$_GENERATED.BASE_SNAME is
'Name of the object''s owner'
/
comment on column SYSTEM.REPCAT$_GENERATED.BASE_ONAME is
'Name of the object'
/
comment on column SYSTEM.REPCAT$_GENERATED.BASE_TYPE is
'Type of the object'
/
comment on column SYSTEM.REPCAT$_GENERATED.REASON is
'Reason the object was generated'
/
comment on column SYSTEM.REPCAT$_GENERATED.PACKAGE_PREFIX is
'Prefix for package wrapper'
/
comment on column SYSTEM.REPCAT$_GENERATED.PROCEDURE_PREFIX is
'Procedure prefix for package wrapper or procedure wrapper'
/
comment on column SYSTEM.REPCAT$_GENERATED.DISTRIBUTED is
'Is the generated object separately generated at each master'
/

CREATE INDEX system.repcat$_generated_n1 ON
  system.repcat$_generated(base_sname, base_oname, base_type)
/

CREATE OR REPLACE VIEW repcat_generated
  (sname, oname, type, reason, base_sname, base_oname, base_type, 
    package_prefix, procedure_prefix, distributed) AS
  SELECT
    sname,
    oname,
    DECODE (type,
      -1, 'SNAPSHOT',
       1, 'INDEX',
       2, 'TABLE',
       4, 'VIEW',
       5, 'SYNONYM',
       6, 'SEQUENCE',
       7, 'PROCEDURE',
       8, 'FUNCTION',
       9, 'PACKAGE',
      11, 'PACKAGE BODY',
      12, 'TRIGGER',
      --- -3, 'UPDATABLE SNAPSHOT',
          'UNDEFINED'),
    DECODE (reason,
       0, 'REPLICATION TRIGGER',
       1, 'REPLICATION PACKAGE',
       2, 'RESOLUTION PACKAGE',
       3, 'PRIORITY PACKAGE',
       4, 'AUDIT PACKAGE',
       5, 'PROCEDURAL REPLICATION WRAPPER',
       6, 'TRIGGER PACKAGE',
       7, 'MIXED REPLICATION TRIGGER',
          'UNDEFINED'),
    base_sname,
    base_oname,
    DECODE (base_type,
      -1, 'SNAPSHOT',
       1, 'INDEX',
       2, 'TABLE',
       4, 'VIEW',
       5, 'SYNONYM',
       6, 'SEQUENCE',
       7, 'PROCEDURE',
       8, 'FUNCTION',
       9, 'PACKAGE',
      11, 'PACKAGE BODY',
      12, 'TRIGGER',
      --- -3, 'UPDATABLE SNAPSHOT',
          'UNDEFINED'),
    package_prefix,
    procedure_prefix,
    distributed
  FROM system.repcat$_generated
/
comment on table REPCAT_GENERATED is
'Objects generated to support replication'
/
comment on column REPCAT_GENERATED.SNAME is
'Schema containing the generated object'
/
comment on column REPCAT_GENERATED.ONAME is
'Name of the generated object'
/
comment on column REPCAT_GENERATED.TYPE is
'Type of the generated object'
/
comment on column REPCAT_GENERATED.BASE_SNAME is
'Name of the object''s owner'
/
comment on column REPCAT_GENERATED.BASE_ONAME is
'Name of the object'
/
comment on column REPCAT_GENERATED.BASE_TYPE is
'Type of the object'
/
comment on column REPCAT_GENERATED.PACKAGE_PREFIX is
'Prefix for package wrapper'
/
comment on column REPCAT_GENERATED.PROCEDURE_PREFIX is
'Procedure prefix for package wrapper or procedure wrapper'
/
comment on column REPCAT_GENERATED.DISTRIBUTED is
'Is the generated object separately generated at each master'
/

-- create a table to hold propagation information
-- (row-level and column-level replication of tables)
-- (procedure wrappers)
CREATE TABLE system.repcat$_repprop
(
  sname              VARCHAR2(30),  -- schema name
  oname              VARCHAR2(30),  -- replicated object name
  type               INTEGER,
                       CONSTRAINT repcat$_repprop_prnt
                         FOREIGN KEY(sname, oname, type)
                         REFERENCES system.repcat$_repobject(sname, oname,
                                                             type)
                         ON DELETE CASCADE,
  dblink             VARCHAR2(128),  -- a master site (M_XDBI)
                       CONSTRAINT repcat$_repprop_primary
                         PRIMARY KEY(sname, oname, type, dblink),
---                       CONSTRAINT repcat$_repprop_prnt2
---                         FOREIGN KEY(sname, dblink)
---                         REFERENCES system.repcat$_repschema(sname, dblink)
---                         ON DELETE CASCADE,
  how                INTEGER
                       CONSTRAINT repcat$_repprop_how
                         CHECK (how IN (0, 1, 2, 3)),
                         --- 0 = None
                         --- 1 = Asynchronous
                         --- 2 = Synchronous
                         --- 3 = Sync optional async
  propagate_comment  VARCHAR2(80)
)
/
comment on table SYSTEM.REPCAT$_REPPROP is
'Propagation information about replicated objects'
/
comment on column SYSTEM.REPCAT$_REPPROP.SNAME is
'Name of the object owner'
/
comment on column SYSTEM.REPCAT$_REPPROP.ONAME is
'Name of the object'
/
comment on column SYSTEM.REPCAT$_REPPROP.TYPE is
'Type of the object'
/
comment on column SYSTEM.REPCAT$_REPPROP.DBLINK is
'Destination database for propagation'
/
comment on column SYSTEM.REPCAT$_REPPROP.HOW is
'Propagation choice for the destination database'
/
comment on column SYSTEM.REPCAT$_REPPROP.PROPAGATE_COMMENT is
'Description of the propagation choice'
/

CREATE OR REPLACE VIEW repcat_repprop
  (sname, oname, type, dblink, how, propagate_comment)
  AS SELECT
    p.sname,
    p.oname,
    DECODE (p.type,
      -1, 'SNAPSHOT',
       1, 'INDEX',
       2, 'TABLE',
       4, 'VIEW',
       5, 'SYNONYM',
       6, 'SEQUENCE',
       7, 'PROCEDURE',
       8, 'FUNCTION',
       9, 'PACKAGE',
      11, 'PACKAGE BODY',
      12, 'TRIGGER',
      --- -3, 'UPDATABLE SNAPSHOT',
          'UNDEFINED'),
    p.dblink,
    DECODE (p.how,
      0, 'NONE',
      1, 'ASYNCHRONOUS',
      2, 'SYNCHRONOUS',
      3, 'SYNC_OR_ASYNC',
         'UNDEFINED'),
    p.propagate_comment
  FROM system.repcat$_repprop p
  WHERE (p.sname, p.oname, p.type)
    NOT IN (SELECT sname, oname, type from system.repcat$_generated)
    AND p.oname != 'REP$WHAT_AM_I'
/
comment on table REPCAT_REPPROP is
'Propagation information about replicated objects'
/
comment on column REPCAT_REPPROP.SNAME is
'Name of the object owner'
/
comment on column REPCAT_REPPROP.ONAME is
'Name of the object'
/
comment on column REPCAT_REPPROP.TYPE is
'Type of the object'
/
comment on column REPCAT_REPPROP.DBLINK is
'Destination database for propagation'
/
comment on column REPCAT_REPPROP.HOW is
'Propagation choice for the destination database'
/
comment on column REPCAT_REPPROP.PROPAGATE_COMMENT is
'Description of the propagation choice'
/

-- create a table to hold the repcat intentions list and asynchronous errors
--- The sname column will always contain a schema name. This value may
--- also be the name of an existing object group.
--- The gname column contains a non-null only if gname != sname, otherwise
--- gname is NULL
CREATE TABLE system.repcat$_repcatlog
(
  version       NUMBER,           -- repcat version number
  id            NUMBER,           -- sequence number
  source        VARCHAR2(128),    -- where the request originated
  userid        VARCHAR2(30),     -- who made the request
  timestamp     DATE,             -- when the request was made
  role          VARCHAR2(1),      -- 'Y' for masterdef and 'N' for master
  master        VARCHAR2(128),    -- which master executes this intention
                  CONSTRAINT repcat$_repcatlog_primary
                    PRIMARY KEY(id, source, role, master),
  sname         VARCHAR2(30),     -- schema name
  request       INTEGER,          -- repcat administrative procedure name
                  CONSTRAINT repcat$_repcatlog_request
                    CHECK (request IN (-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                                       11)),
  oname         VARCHAR2(30),     -- replicated object name, if applicable
  type          INTEGER,          -- replicated object type, if applicable
                  CONSTRAINT repcat$_repcatlog_type
                    CHECK (type IN (-1, 0, 1, 2, 4, 5, 7, 8, 9, 11, 12, -3)),
  a_comment     VARCHAR2(80),     -- replicated comment, if applicable
  bool_arg      VARCHAR2(1),      -- boolean argument, if applicable
  ano_bool_arg  VARCHAR2(1),      -- another boolean argument, if applicable
  int_arg       INTEGER,          -- integer argument, if applicable
  ano_int_arg   INTEGER,          -- another integer argument, if applicable
  lines         INTEGER,          -- number of lines in repcat$_ddl
  status        INTEGER
                  CONSTRAINT repcat$_repcatlog_status
                    CHECK (status IN (0, 1, 2, 3, 4)),
  message       VARCHAR2(200),    -- error message
  errnum        NUMBER,           -- Oracle error number
  gname         VARCHAR2(30)      -- replicated object group name
)
/
comment on table SYSTEM.REPCAT$_REPCATLOG is
'Information about asynchronous administration requests'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.VERSION is
'Version of the repcat log record'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.ID is
'Identifying number of repcat log record'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.SOURCE is
'Name of the database at which the request originated'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.USERID is
'Name of the user who submitted the request'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.TIMESTAMP is
'When the request was submitted'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.ROLE is
'Is this database the masterdef for the request'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.MASTER is
'Name of the database that processes this request$_ddl'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.GNAME is
'Name of the replicated object group'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.REQUEST is
'Name of the requested operation'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.SNAME is
'Schema of replicated object'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.ONAME is
'Replicated object name, if applicable'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.TYPE is
'Type of replicated object, if applicable'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.A_COMMENT is
'Textual argument used for comments'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.BOOL_ARG is
'Boolean argument'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.ANO_BOOL_ARG is
'Another Boolean argument'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.INT_ARG is
'Integer argument'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.ANO_INT_ARG is
'Another integer argument'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.LINES is
'The number of rows in system.repcat$_ddl at the processing site'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.STATUS is
'Status of the request at this database'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.MESSAGE is
'Error message associated with processing the request'
/
comment on column SYSTEM.REPCAT$_REPCATLOG.ERRNUM is
'Oracle error number associated with processing the request'
/

-- hide arguments and encodings from users
CREATE OR REPLACE VIEW repcat_repcatlog
  (id, source, status, userid, timestamp, role, master, request, 
   sname, oname, type, message, errnum, gname)
  AS SELECT
    id,
    source,
    DECODE(status,
      0, 'READY',
      1, 'DO_CALLBACK',
      2, 'AWAIT_CALLBACK',
      3, 'ERROR',
         'UNDEFINED'),
    userid,
    timestamp,
    DECODE (role,
      'Y', 'MASTERDEF',
      'N', 'MASTER',
           'UNDEFINED'),
    master,
    DECODE(request,
      -1, '*** TESTING ***',
       0, 'CREATE_MASTER_REPOBJECT',
       1, 'DROP_MASTER_REPSCHEMA',
       2, 'ADD_MASTER_DATABASE',
       3, 'ALTER_MASTER_REPOBJECT',
       4, 'DROP_MASTER_REPOBJECT',
       5, 'SUSPEND_MASTER_ACTIVITY',
       6, 'RESUME_MASTER_ACTIVITY',
       7, 'EXECUTE_DDL',
       8, 'GENERATE_REPLICATION_SUPPORT',
       9, 'GENERATE_SUPPORT_PHASE_1',
      10, 'GENERATE_SUPPORT_PHASE_2',
      11, 'ALTER_MASTER_PROPAGATION',
          'UNDEFINED'),
    DECODE(oname, NULL, NULL, sname),
    oname,
    DECODE (type,
      -1, 'SNAPSHOT',
       0, 'UNDEFINED',
       1, 'INDEX',
       2, 'TABLE',
       4, 'VIEW',
       5, 'SYNONYM',
       6, 'SEQUENCE',
       7, 'PROCEDURE',
       8, 'FUNCTION',
       9, 'PACKAGE',
      11, 'PACKAGE BODY',
      12, 'TRIGGER',
      --- -3, 'UPDATABLE SNAPSHOT',
          'UNDEFINED'),
    message,
    errnum,
    NVL(gname, sname)
  FROM system.repcat$_repcatlog
/
comment on table REPCAT_REPCATLOG is
'Information about asynchronous administration requests'
/
comment on column REPCAT_REPCATLOG.ID is
'Identifying number of repcat log record'
/
comment on column REPCAT_REPCATLOG.SOURCE is
'Name of the database at which the request originated'
/
comment on column REPCAT_REPCATLOG.STATUS is
'Status of the request at this database'
/
comment on column REPCAT_REPCATLOG.USERID is
'Name of the user who submitted the request'
/
comment on column REPCAT_REPCATLOG.TIMESTAMP is
'When the request was submitted'
/
comment on column REPCAT_REPCATLOG.ROLE is
'Is this database the masterdef for the request'
/
comment on column REPCAT_REPCATLOG.MASTER is
'Name of the database that processes this request'
/
comment on column REPCAT_REPCATLOG.GNAME is
'Name of the replicated object group'
/
comment on column REPCAT_REPCATLOG.REQUEST is
'Name of the requested operation'
/
comment on column REPCAT_REPCATLOG.SNAME is
'Schema of replicated object, if applicable'
/
comment on column REPCAT_REPCATLOG.ONAME is
'Replicated object name, if applicable'
/
comment on column REPCAT_REPCATLOG.TYPE is
'Type of replicated object, if applicable'
/
comment on column REPCAT_REPCATLOG.MESSAGE is
'Error message associated with processing the request'
/
comment on column REPCAT_REPCATLOG.ERRNUM is
'Oracle error number associated with processing the request'
/

-- create a table that holds ddl
CREATE TABLE system.repcat$_ddl
(
  log_id  NUMBER,                 -- request identifier
  source  VARCHAR2(128),          -- where the request originated
  role    VARCHAR2(1),            -- 'Y' for masterdef and 'N' for master
  master  VARCHAR2(128),          -- 
            CONSTRAINT repcat$_ddl_prnt
              FOREIGN KEY(log_id, source, role, master)
              REFERENCES system.repcat$_repcatlog(id, source, role, master)
              ON DELETE CASCADE,
  line    INTEGER,
  text    VARCHAR2(2000)          -- ddl to execute
)
/
comment on table SYSTEM.REPCAT$_DDL is
'Arguments that do not fit in a single repcat log record'
/
comment on column SYSTEM.REPCAT$_DDL.LOG_ID is
'Identifying number of the repcat log record'
/
comment on column SYSTEM.REPCAT$_DDL.SOURCE is
'Name of the database at which the request originated'
/
comment on column SYSTEM.REPCAT$_DDL.ROLE is
'Is this database the masterdef for the request'
/
comment on column SYSTEM.REPCAT$_DDL.MASTER is
'Name of the database that processes this request'
/
comment on column SYSTEM.REPCAT$_DDL.LINE is
'Ordering of records within a single request'
/
comment on column SYSTEM.REPCAT$_DDL.TEXT is
'Portion of an argument'
/

CREATE UNIQUE INDEX system.repcat$_ddl ON
  system.repcat$_ddl(log_id, source, role, master, line)
/

CREATE SEQUENCE system.repcat_log_sequence;
/

create or replace view USER_REPGROUP
  (SNAME, --- OBSOLETE
   MASTER, STATUS, SCHEMA_COMMENT, GNAME)
as
select r.sname, r.master, r.status, r.schema_comment, r.sname
from repcat_repcat r, user_users u
where r.sname = u.username
/
comment on table USER_REPGROUP is
'Replication information about the current user'
/
comment on column USER_REPGROUP.GNAME is
'Name of the replicated object group'
/
comment on column USER_REPGROUP.SNAME is
'OBSOLETE COLUMN: Name of the user'
/
comment on column USER_REPGROUP.MASTER is
'Is the site a master site'
/
comment on column USER_REPGROUP.STATUS is
'If site is master, the master''s status'
/
comment on column USER_REPGROUP.SCHEMA_COMMENT is
'User description of the replicated object group'
/
Rem -- user_repcat is maintained for backwards compatability
create or replace view USER_REPCAT as select * from USER_REPGROUP
/
drop public synonym USER_REPCAT
/
create public synonym USER_REPCAT for USER_REPCAT
/
grant select on USER_REPCAT to PUBLIC with grant option
/
drop public synonym USER_REPGROUP
/
create public synonym USER_REPGROUP for USER_REPGROUP
/
grant select on USER_REPGROUP to PUBLIC with grant option
/
create or replace view ALL_REPGROUP
    (SNAME, --- OBSOLETE
     MASTER, STATUS, SCHEMA_COMMENT, GNAME)
as
select r.sname, r.master, r.status, r.schema_comment, r.sname
from repcat_repcat r
---where r.sname = 'PUBLIC' OR
---      r.sname in (select u.username from all_users u);
/
comment on table ALL_REPGROUP is
'Information about replicated object groups'
/
comment on column ALL_REPGROUP.GNAME is
'Name of the replicated object group'
/
comment on column ALL_REPGROUP.SNAME is
'OBSOLETE COLUMN: Name of the replicated schema'
/
comment on column ALL_REPGROUP.MASTER is
'Is the site a master site for the replicated object group'
/
comment on column ALL_REPGROUP.STATUS is
'If the site is a master, the master''s status'
/
comment on column ALL_REPGROUP.SCHEMA_COMMENT is
'Description of the replicated object group'
/
Rem -- This synonym all_repcat is for backwards compatability
create or replace view ALL_REPCAT as select * from ALL_REPGROUP
/
drop public synonym ALL_REPCAT
/
create public synonym ALL_REPCAT for ALL_REPCAT
/
grant select on ALL_REPCAT to PUBLIC with grant option
/
drop public synonym ALL_REPGROUP
/
create public synonym ALL_REPGROUP for ALL_REPGROUP
/
grant select on ALL_REPGROUP to PUBLIC with grant option
/
create or replace view DBA_REPGROUP
    (SNAME, --- OBSOLETE
     MASTER, STATUS, SCHEMA_COMMENT, GNAME)
as
select r.sname, r.master, r.status, r.schema_comment, r.sname
from repcat_repcat r
/
comment on table DBA_REPGROUP is
'Information about all replicated object groups'
/
comment on column DBA_REPGROUP.GNAME is
'Name of the replicated object group'
/
comment on column DBA_REPGROUP.SNAME is
'OBSOLETE COLUMN: Name of the replicated schema'
/
comment on column DBA_REPGROUP.MASTER is
'Is the site a master site for the replicated object group'
/
comment on column DBA_REPGROUP.STATUS is
'If the site is a master, the master''s status'
/
comment on column DBA_REPGROUP.SCHEMA_COMMENT is
'Description of the replicated object group'
/
Rem -- Next two lines are for backwards compatability. In 7.3 we changed names
Rem -- from *_repcat to *_repgroup
create or replace view DBA_REPCAT as select * from DBA_REPGROUP
/
drop public synonym DBA_REPCAT
/
create public synonym DBA_REPCAT for DBA_REPCAT
/
drop public synonym DBA_REPGROUP
/
create public synonym DBA_REPGROUP for DBA_REPGROUP
/
create or replace view USER_REPSITES
(GNAME, DBLINK, MASTERDEF, SNAPMASTER, MASTER_COMMENT)
as
select r.sname, r.dblink, r.masterdef, r.snapmaster, r.master_comment
from repcat_repschema r, user_users u
where r.sname = u.username
/
comment on table USER_REPSITES is
'N-way replication information about the current user'
/
comment on column USER_REPSITES.GNAME is
'Name of the replicated object group'
/
comment on column USER_REPSITES.DBLINK is
'A database site replicating the schema'
/
comment on column USER_REPSITES.MASTERDEF is
'Is the database the master definition site for the replicated object group'
/
comment on column USER_REPSITES.SNAPMASTER is
'For snapshot sites, is the database the current refresh master'
/
comment on column USER_REPSITES.MASTER_COMMENT is
'User description of the database site'
/
drop public synonym USER_REPSITES
/
create public synonym USER_REPSITES for USER_REPSITES
/
grant select on USER_REPSITES to PUBLIC with grant option
/
create or replace view ALL_REPSITES
(GNAME, DBLINK, MASTERDEF, SNAPMASTER, MASTER_COMMENT)
as
select r.sname, r.dblink, r.masterdef, r.snapmaster, r.master_comment
from repcat_repschema r
/
comment on table ALL_REPSITES is
'N-way replication information'
/
comment on column ALL_REPSITES.GNAME is
'Name of the replicated object group'
/
comment on column ALL_REPSITES.DBLINK is
'A database site replicating the schema'
/
comment on column ALL_REPSITES.MASTERDEF is
'Is the database the master definition site for the replicated object group'
/
comment on column ALL_REPSITES.SNAPMASTER is
'For a snapshot site, is the database the current refresh master'
/
comment on column ALL_REPSITES.MASTER_COMMENT is
'Description of the database site'
/
drop public synonym ALL_REPSITES
/
create public synonym ALL_REPSITES for ALL_REPSITES
/
grant select on ALL_REPSITES to PUBLIC with grant option
/
create or replace view DBA_REPSITES
(GNAME, DBLINK, MASTERDEF, SNAPMASTER, MASTER_COMMENT, MASTER,
 PROP_UPDATES, MY_DBLINK)
as
select r.sname, r.dblink, r.masterdef, r.snapmaster, r.master_comment,
  r.master, r.prop_updates, r.my_dblink
from system.repcat$_repschema r
/
comment on table DBA_REPSITES is
'N-way replication information'
/
comment on column DBA_REPSITES.GNAME is
'Name of the replicated object group'
/
comment on column DBA_REPSITES.DBLINK is
'A database site replicating the schema'
/
comment on column DBA_REPSITES.MASTERDEF is
'Is the database the master definition site for the replicated object group'
/
comment on column DBA_REPSITES.SNAPMASTER is
'For a snapshot site, is the database the current refresh master'
/
comment on column DBA_REPSITES.MASTER_COMMENT is
'Description of the database site'
/
comment on column DBA_REPSITES.MASTER is
'Redundant information from repcat$_repcat.master'
/
comment on column DBA_REPSITES.PROP_UPDATES is
'Number of requested updates for master in repcat$_repprop'
/
comment on column DBA_REPSITES.MY_DBLINK is
'A sanity check after import: is this master the current site'
/
drop public synonym DBA_REPSITES
/
create public synonym DBA_REPSITES for DBA_REPSITES
/
create or replace view USER_REPSCHEMA
    (SNAME, --- OBSOLETE
     DBLINK, MASTERDEF, SNAPMASTER, MASTER_COMMENT, GNAME)
as
select r.sname, r.dblink, r.masterdef, r.snapmaster, r.master_comment, r.sname
from repcat_repschema r, user_users u
where r.sname = u.username
/
comment on table USER_REPSCHEMA is
'N-way replication information about the current user'
/
comment on column USER_REPSCHEMA.GNAME is
'Name of the replicated object group'
/
comment on column USER_REPSCHEMA.SNAME is
'OBSOLETE COLUMN: Name of the user'
/
comment on column USER_REPSCHEMA.DBLINK is
'A database site replicating the object group'
/
comment on column USER_REPSCHEMA.MASTERDEF is
'Is the database the master definition site for the replicated object group'
/
comment on column USER_REPSCHEMA.SNAPMASTER is
'For snapshot sites, is the database the current refresh master'
/
comment on column USER_REPSCHEMA.MASTER_COMMENT is
'User description of the database site'
/
drop public synonym USER_REPSCHEMA
/
create public synonym USER_REPSCHEMA for USER_REPSCHEMA
/
grant select on USER_REPSCHEMA to PUBLIC with grant option
/
create or replace view ALL_REPSCHEMA
    (SNAME, --- OBSOLETE
     DBLINK, MASTERDEF, SNAPMASTER, MASTER_COMMENT, GNAME)
as
select r.sname, r.dblink, r.masterdef, r.snapmaster, r.master_comment, r.sname
from repcat_repschema r
---where r.sname = 'PUBLIC' OR
---      r.sname in (select u.username from all_users u);
/
comment on table ALL_REPSCHEMA is
'N-way replication information'
/
comment on column ALL_REPSCHEMA.GNAME is
'Name of the replicated object group'
/
comment on column ALL_REPSCHEMA.SNAME is
'OBSOLETE COLUMN: Name of the replicated schema'
/
comment on column ALL_REPSCHEMA.DBLINK is
'A database site replicating the object group'
/
comment on column ALL_REPSCHEMA.MASTERDEF is
'Is the database the master definition site for the replicated object group'
/
comment on column ALL_REPSCHEMA.SNAPMASTER is
'For a snapshot site, is the database the current refresh master'
/
comment on column ALL_REPSCHEMA.MASTER_COMMENT is
'Description of the database site'
/
drop public synonym ALL_REPSCHEMA
/
create public synonym ALL_REPSCHEMA for ALL_REPSCHEMA
/
grant select on ALL_REPSCHEMA to PUBLIC with grant option
/
create or replace view DBA_REPSCHEMA
    (SNAME, --- OBSOLETE
     DBLINK, MASTERDEF, SNAPMASTER, MASTER_COMMENT, MASTER,
     PROP_UPDATES, MY_DBLINK, GNAME)
as
select r.sname, r.dblink, r.masterdef, r.snapmaster, r.master_comment,
  r.master, r.prop_updates, r.my_dblink, r.sname
from system.repcat$_repschema r
/
comment on table DBA_REPSCHEMA is
'N-way replication information'
/
comment on column DBA_REPSCHEMA.GNAME is
'Name of the replicated object group'
/
comment on column DBA_REPSCHEMA.SNAME is
'OBSOLETE COLUMN: Name of the replicated schema'
/
comment on column DBA_REPSCHEMA.DBLINK is
'A database site replicating the object group'
/
comment on column DBA_REPSCHEMA.MASTERDEF is
'Is the database the master definition site for the replicated object group'
/
comment on column DBA_REPSCHEMA.SNAPMASTER is
'For a snapshot site, is the database the current refresh master'
/
comment on column DBA_REPSCHEMA.MASTER_COMMENT is
'Description of the database site'
/
comment on column DBA_REPSCHEMA.MASTER is
'Redundant information from repcat$_repcat.master'
/
comment on column DBA_REPSCHEMA.PROP_UPDATES is
'Number of requested updates for master in repcat$_repprop'
/
comment on column DBA_REPSCHEMA.MY_DBLINK is
'A sanity check after import: is this master the current site'
/
drop public synonym DBA_REPSCHEMA
/
create public synonym DBA_REPSCHEMA for DBA_REPSCHEMA
/
create or replace view USER_REPOBJECT
    (SNAME, ONAME, TYPE, STATUS, ID, OBJECT_COMMENT, GNAME)
as
select r.sname, r.oname, r.type, r.status, r.id, r.object_comment, r.gname
from repcat_repobject r, user_users u
where r.sname = u.username
/
comment on table USER_REPOBJECT is
'Replication information about the current user''s objects'
/
comment on column USER_REPOBJECT.GNAME is
'Name of the replicated objects group'
/
comment on column USER_REPOBJECT.SNAME is
'Name of the user'
/
comment on column USER_REPOBJECT.ONAME is
'Name of the object'
/
comment on column USER_REPOBJECT.TYPE is
'Type of the object'
/
comment on column USER_REPOBJECT.STATUS is
'Status of the last create or alter request on the local object'
/
comment on column USER_REPOBJECT.ID is
'Identifier of the local object'
/
comment on column USER_REPOBJECT.OBJECT_COMMENT is
'User description of the replicated object'
/
drop public synonym USER_REPOBJECT
/
create public synonym USER_REPOBJECT for USER_REPOBJECT
/
grant select on USER_REPOBJECT to PUBLIC with grant option
/
create or replace view ALL_REPOBJECT
    (SNAME, ONAME, TYPE, STATUS, ID, OBJECT_COMMENT, GNAME)
as
select r.sname, r.oname, r.type, r.status, r.id, r.object_comment, r.gname
from repcat_repobject r, all_objects o
where (r.sname = 'PUBLIC' or r.sname in (select u.username from all_users u))
  and r.sname = o.owner
  and r.oname = o.object_name
  and (r.type = o.object_type
       or (r.type = 'SNAPSHOT'
           and o.object_type = 'VIEW'))
union
select r.sname, r.oname, r.type, r.status, r.id, r.object_comment, r.gname
from user_repobject r
/
comment on table ALL_REPOBJECT is
'Information about replicated objects'
/
comment on column ALL_REPOBJECT.GNAME is
'Name of the replicated object group'
/
comment on column ALL_REPOBJECT.SNAME is
'Name of the object owner'
/
comment on column ALL_REPOBJECT.ONAME is
'Name of the object'
/
comment on column ALL_REPOBJECT.TYPE is
'Type of the object'
/
comment on column ALL_REPOBJECT.STATUS is
'Status of the last create or alter request on the local object'
/
comment on column ALL_REPOBJECT.ID is
'Identifier of the local object'
/
comment on column ALL_REPOBJECT.OBJECT_COMMENT is
'Description of the replicated object'
/
drop public synonym ALL_REPOBJECT
/
create public synonym ALL_REPOBJECT for ALL_REPOBJECT
/
grant select on ALL_REPOBJECT to PUBLIC with grant option
/
create or replace view DBA_REPOBJECT
    (SNAME, ONAME, TYPE, STATUS, ID, OBJECT_COMMENT, GNAME)
as
select r.sname, r.oname, r.type, r.status, r.id, r.object_comment, r.gname
from repcat_repobject r
/
comment on table DBA_REPOBJECT is
'Information about replicated objects'
/
comment on column DBA_REPOBJECT.GNAME is
'Name of the replicated object group'
/
comment on column DBA_REPOBJECT.SNAME is
'Name of the object owner'
/
comment on column DBA_REPOBJECT.ONAME is
'Name of the object'
/
comment on column DBA_REPOBJECT.TYPE is
'Type of the object'
/
comment on column DBA_REPOBJECT.STATUS is
'Status of the last create or alter request on the local object'
/
comment on column DBA_REPOBJECT.ID is
'Identifier of the local object'
/
comment on column DBA_REPOBJECT.OBJECT_COMMENT is
'Description of the replicated object'
/
drop public synonym DBA_REPOBJECT
/
create public synonym DBA_REPOBJECT for DBA_REPOBJECT
/
create or replace view USER_REPPROP
    (SNAME, ONAME, TYPE, DBLINK, HOW, PROPAGATE_COMMENT)
as
select r.sname, r.oname, r.type, r.dblink, r.how, r.propagate_comment
from repcat_repprop r, repcat_repobject ro, user_users u
where r.sname = u.username
  and r.sname = ro.sname
  and r.oname = ro.oname
  and r.type = ro.type
  and ro.type in ('PROCEDURE', 'PACKAGE', 'PACKAGE BODY', 'TABLE', 'SNAPSHOT')
/
comment on table USER_REPPROP is
'Propagation information about the current user''s objects'
/
comment on column USER_REPPROP.SNAME is
'Name of the user'
/
comment on column USER_REPPROP.ONAME is
'Name of the object'
/
comment on column USER_REPPROP.TYPE is
'Type of the object'
/
comment on column USER_REPPROP.DBLINK is
'Destination database for propagation'
/
comment on column USER_REPPROP.HOW is
'Propagation choice for the destination database'
/
comment on column USER_REPPROP.PROPAGATE_COMMENT is
'User description of the propagation choice'
/
drop public synonym USER_REPPROP
/
create public synonym USER_REPPROP for USER_REPPROP
/
grant select on USER_REPPROP to PUBLIC with grant option
/
create or replace view ALL_REPPROP
    (SNAME, ONAME, TYPE, DBLINK, HOW, PROPAGATE_COMMENT)
as
select r.sname, r.oname, r.type, r.dblink, r.how, r.propagate_comment
from repcat_repprop r, all_users u, all_repobject ro
where r.sname = u.username
  and r.sname = ro.sname
  and r.oname = ro.oname
  and r.type = ro.type
  and ro.type in ('PROCEDURE', 'PACKAGE', 'PACKAGE BODY', 'TABLE', 'SNAPSHOT')
/
comment on table ALL_REPPROP is
'Propagation information about replicated objects'
/
comment on column ALL_REPPROP.SNAME is
'Name of the object owner'
/
comment on column ALL_REPPROP.ONAME is
'Name of the object'
/
comment on column ALL_REPPROP.TYPE is
'Type of the object'
/
comment on column ALL_REPPROP.DBLINK is
'Destination database for propagation'
/
comment on column ALL_REPPROP.HOW is
'Propagation choice for the destination database'
/
comment on column ALL_REPPROP.PROPAGATE_COMMENT is
'Description of the propagation choice'
/
drop public synonym ALL_REPPROP
/
create public synonym ALL_REPPROP for ALL_REPPROP
/
grant select on ALL_REPPROP to PUBLIC with grant option
/
create or replace view DBA_REPPROP
    (SNAME, ONAME, TYPE, DBLINK, HOW, PROPAGATE_COMMENT)
as
select r.sname, r.oname, r.type, r.dblink, r.how, r.propagate_comment
from repcat_repprop r, repcat_repobject ro
where r.sname = ro.sname
  and r.oname = ro.oname
  and r.type = ro.type
  and ro.type in ('PROCEDURE', 'PACKAGE', 'PACKAGE BODY', 'TABLE', 'SNAPSHOT')
/
comment on table DBA_REPPROP is
'Propagation information about replicated objects'
/
comment on column DBA_REPPROP.SNAME is
'Name of the object owner'
/
comment on column DBA_REPPROP.ONAME is
'Name of the object'
/
comment on column DBA_REPPROP.TYPE is
'Type of the object'
/
comment on column DBA_REPPROP.DBLINK is
'Destination database for propagation'
/
comment on column DBA_REPPROP.HOW is
'Propagation choice for the destination database'
/
comment on column DBA_REPPROP.PROPAGATE_COMMENT is
'Description of the propagation choice'
/
drop public synonym DBA_REPPROP
/
create public synonym DBA_REPPROP for DBA_REPPROP
/
create or replace view USER_REPKEY_COLUMNS
    (SNAME, ONAME, COL)
as
select r.sname, r.oname, r.col
from system.repcat$_key_columns r, user_users u
where r.sname = u.username
/
comment on table USER_REPKEY_COLUMNS is
'Primary columns for a table using column-level replication'
/
comment on column USER_REPKEY_COLUMNS.SNAME is
'Schema containing table'
/
comment on column USER_REPKEY_COLUMNS.ONAME is
'Name of the table'
/
comment on column USER_REPKEY_COLUMNS.COL is
'Column in the table'
/
drop public synonym USER_REPKEY_COLUMNS
/
create public synonym USER_REPKEY_COLUMNS for USER_REPKEY_COLUMNS
/
grant select on USER_REPKEY_COLUMNS to PUBLIC with grant option
/
create or replace view ALL_REPKEY_COLUMNS
    (SNAME, ONAME, COL)
as
select r.sname, r.oname, r.col
from system.repcat$_key_columns r, all_repobject ro
where r.sname = ro.sname
  and r.oname = ro.oname
  and 'TABLE' = ro.type
/
comment on table ALL_REPKEY_COLUMNS is
'Primary columns for a table using column-level replication'
/
comment on column ALL_REPKEY_COLUMNS.SNAME is
'Schema containing table'
/
comment on column ALL_REPKEY_COLUMNS.ONAME is
'Name of the table'
/
comment on column ALL_REPKEY_COLUMNS.COL is
'Column in the table'
/
drop public synonym ALL_REPKEY_COLUMNS
/
create public synonym ALL_REPKEY_COLUMNS for ALL_REPKEY_COLUMNS
/
grant select on ALL_REPKEY_COLUMNS to PUBLIC with grant option
/
create or replace view DBA_REPKEY_COLUMNS
    (SNAME, ONAME, COL)
as
select r.sname, r.oname, r.col
from system.repcat$_key_columns r
/
comment on table DBA_REPKEY_COLUMNS is
'Primary columns for a table using column-level replication'
/
comment on column DBA_REPKEY_COLUMNS.SNAME is
'Schema containing table'
/
comment on column DBA_REPKEY_COLUMNS.ONAME is
'Name of the table'
/
comment on column DBA_REPKEY_COLUMNS.COL is
'Column in the table'
/
drop public synonym DBA_REPKEY_COLUMNS
/
create public synonym DBA_REPKEY_COLUMNS for DBA_REPKEY_COLUMNS
/
create or replace view USER_REPGENERATED
  (SNAME, ONAME, TYPE, BASE_SNAME, BASE_ONAME, BASE_TYPE, PACKAGE_PREFIX,
    PROCEDURE_PREFIX, DISTRIBUTED, REASON)
as
select r.sname, r.oname, r.type, r.base_sname, r.base_oname, r.base_type,
  r.package_prefix, r.procedure_prefix, r.distributed, r.reason
from repcat_generated r, user_users u
where r.base_sname = u.username
/
comment on table USER_REPGENERATED is
'Objects generated for the current user to support replication'
/
comment on column USER_REPGENERATED.SNAME is
'Schema containing the generated object'
/
comment on column USER_REPGENERATED.ONAME is
'Name of the generated object'
/
comment on column USER_REPGENERATED.TYPE is
'Type of the generated object'
/
comment on column USER_REPGENERATED.BASE_SNAME is
'Name of the user'
/
comment on column USER_REPGENERATED.BASE_ONAME is
'Name of the user''s object'
/
comment on column USER_REPGENERATED.BASE_TYPE is
'Type of the user''s object'
/
comment on column USER_REPGENERATED.PACKAGE_PREFIX is
'Prefix for package wrapper'
/
comment on column USER_REPGENERATED.PROCEDURE_PREFIX is
'Procedure prefix for package wrapper or procedure wrapper'
/
comment on column USER_REPGENERATED.DISTRIBUTED is
'Is the generated object separately generated at each master'
/
comment on column USER_REPGENERATED.REASON is
'Reason the object was generated'
/
drop public synonym USER_REPGENERATED
/
create public synonym USER_REPGENERATED for USER_REPGENERATED
/
grant select on USER_REPGENERATED to PUBLIC with grant option
/
create or replace view ALL_REPGENERATED
  (SNAME, ONAME, TYPE, BASE_SNAME, BASE_ONAME, BASE_TYPE, PACKAGE_PREFIX,
    PROCEDURE_PREFIX, DISTRIBUTED, REASON)
as
select r.sname, r.oname, r.type, r.base_sname, r.base_oname, r.base_type,
  r.package_prefix, r.procedure_prefix, r.distributed, r.reason
from repcat_generated r, all_users u, all_objects o
where r.base_sname = u.username
  and r.base_sname = o.owner
  and r.base_oname = o.object_name
  and (r.base_type = o.object_type
       or (r.base_type = 'SNAPSHOT'
           and o.object_type = 'VIEW'))
union
select r.sname, r.oname, r.type, r.base_sname, r.base_oname, r.base_type,
  r.package_prefix, r.procedure_prefix, r.distributed, r.reason
from user_repgenerated r
/
comment on table ALL_REPGENERATED is
'Objects generated to support replication'
/
comment on column ALL_REPGENERATED.SNAME is
'Schema containing the generated object'
/
comment on column ALL_REPGENERATED.ONAME is
'Name of the generated object'
/
comment on column ALL_REPGENERATED.TYPE is
'Type of the generated object'
/
comment on column ALL_REPGENERATED.BASE_SNAME is
'Name of the object''s owner'
/
comment on column ALL_REPGENERATED.BASE_ONAME is
'Name of the object'
/
comment on column ALL_REPGENERATED.BASE_TYPE is
'Type of the object'
/
comment on column ALL_REPGENERATED.PACKAGE_PREFIX is
'Prefix for package wrapper'
/
comment on column ALL_REPGENERATED.PROCEDURE_PREFIX is
'Procedure prefix for package wrapper or procedure wrapper'
/
comment on column ALL_REPGENERATED.DISTRIBUTED is
'Is the generated object separately generated at each master'
/
comment on column ALL_REPGENERATED.REASON is
'Reason the object was generated'
/
drop public synonym ALL_REPGENERATED
/
create public synonym ALL_REPGENERATED for ALL_REPGENERATED
/
grant select on ALL_REPGENERATED to PUBLIC with grant option
/
create or replace view DBA_REPGENERATED
  (SNAME, ONAME, TYPE, BASE_SNAME, BASE_ONAME, BASE_TYPE, PACKAGE_PREFIX,
    PROCEDURE_PREFIX, DISTRIBUTED, REASON)
as
select r.sname, r.oname, r.type, r.base_sname, r.base_oname, r.base_type,
  r.package_prefix, r.procedure_prefix, r.distributed, r.reason
from repcat_generated r
/
comment on table DBA_REPGENERATED is
'Objects generated to support replication'
/
comment on column DBA_REPGENERATED.SNAME is
'Schema containing the generated object'
/
comment on column DBA_REPGENERATED.ONAME is
'Name of the generated object'
/
comment on column DBA_REPGENERATED.TYPE is
'Type of the generated object'
/
comment on column DBA_REPGENERATED.BASE_SNAME is
'Name of the object''s owner'
/
comment on column DBA_REPGENERATED.BASE_ONAME is
'Name of the object'
/
comment on column DBA_REPGENERATED.BASE_TYPE is
'Type of the object'
/
comment on column DBA_REPGENERATED.PACKAGE_PREFIX is
'Prefix for package wrapper'
/
comment on column DBA_REPGENERATED.PROCEDURE_PREFIX is
'Procedure prefix for package wrapper or procedure wrapper'
/
comment on column DBA_REPGENERATED.DISTRIBUTED is
'Is the generated object separately generated at each master'
/
comment on column DBA_REPGENERATED.REASON is
'Reason the object was generated'
/
drop public synonym DBA_REPGENERATED
/
create public synonym DBA_REPGENERATED for DBA_REPGENERATED
/
create or replace view USER_REPCATLOG
    (ID, SOURCE, USERID, TIMESTAMP, ROLE, MASTER, SNAME, REQUEST, 
     ONAME, TYPE, STATUS, MESSAGE, ERRNUM, GNAME)
as
select r.id, r.source, r.userid, r.timestamp, r.role, r.master, r.sname,
  r.request, r.oname, r.type, r.status, r.message, r.errnum, r.gname
from repcat_repcatlog r, user_users u
where r.sname = u.username or r.userid = u.username
/
comment on table USER_REPCATLOG is
'Information about the current user''s asynchronous administration requests'
/
comment on column USER_REPCATLOG.ID is
'Identifying number of repcat log record'
/
comment on column USER_REPCATLOG.SOURCE is
'Name of the database at which the request originated'
/
comment on column USER_REPCATLOG.USERID is
'Name of the user who submitted the request'
/
comment on column USER_REPCATLOG.TIMESTAMP is
'When the request was submitted'
/
comment on column USER_REPCATLOG.ROLE is
'Is this database the masterdef for the request'
/
comment on column USER_REPCATLOG.MASTER is
'Name of the database that processes this request'
/
comment on column USER_REPCATLOG.GNAME is
'Name of the replicated object group'
/
comment on column USER_REPCATLOG.REQUEST is
'Name of the requested operation'
/
comment on column USER_REPCATLOG.SNAME is
'Schema of replicated object name, if applicable'
/
comment on column USER_REPCATLOG.ONAME is
'Replicated object name, if applicable'
/
comment on column USER_REPCATLOG.TYPE is
'Type of replicated object, if applicable'
/
comment on column USER_REPCATLOG.STATUS is
'Status of the request at this database'
/
comment on column USER_REPCATLOG.MESSAGE is
'Error message associated with processing the request'
/
comment on column USER_REPCATLOG.ERRNUM is
'Oracle error number associated with processing the request'
/
drop public synonym USER_REPCATLOG
/
create public synonym USER_REPCATLOG for USER_REPCATLOG
/
grant select on USER_REPCATLOG to PUBLIC with grant option
/
create or replace view ALL_REPCATLOG
    (ID, SOURCE, USERID, TIMESTAMP, ROLE, MASTER, SNAME, REQUEST, 
     ONAME, TYPE, STATUS, MESSAGE, ERRNUM, GNAME)
as
select r.id, r.source, r.userid, r.timestamp, r.role, r.master, r.sname,
  r.request, r.oname, r.type, r.status, r.message, r.errnum, r.gname
from repcat_repcatlog r, all_objects o
where (r.sname = 'PUBLIC' or r.sname in (select u.username from all_users u))
  and r.sname = o.owner
  and r.oname = o.object_name
  and r.type = o.object_type
union
select r.id, r.source, r.userid, r.timestamp, r.role, r.master, r.sname,
  r.request, r.oname, r.type, r.status, r.message, r.errnum, r.gname
from user_repcatlog r
/
comment on table ALL_REPCATLOG is
'Information about asynchronous administration requests'
/
comment on column ALL_REPCATLOG.ID is
'Identifying number of repcat log record'
/
comment on column ALL_REPCATLOG.SOURCE is
'Name of the database at which the request originated'
/
comment on column ALL_REPCATLOG.USERID is
'Name of the user who submitted the request'
/
comment on column ALL_REPCATLOG.TIMESTAMP is
'When the request was submitted'
/
comment on column ALL_REPCATLOG.ROLE is
'Is this database the masterdef for the request'
/
comment on column ALL_REPCATLOG.MASTER is
'Name of the database that processes this request'
/
comment on column ALL_REPCATLOG.GNAME is
'Name of the replicated object group'
/
comment on column ALL_REPCATLOG.REQUEST is
'Name of the requested operation'
/
comment on column ALL_REPCATLOG.SNAME is
'Schema of replicated object name, if applicable'
/
comment on column ALL_REPCATLOG.ONAME is
'Replicated object name, if applicable'
/
comment on column ALL_REPCATLOG.TYPE is
'Type of replicated object, if applicable'
/
comment on column ALL_REPCATLOG.STATUS is
'Status of the request at this database'
/
comment on column ALL_REPCATLOG.MESSAGE is
'Error message associated with processing the request'
/
comment on column ALL_REPCATLOG.ERRNUM is
'Oracle error number associated with processing the request'
/
drop public synonym ALL_REPCATLOG
/
create public synonym ALL_REPCATLOG for ALL_REPCATLOG
/
grant select on ALL_REPCATLOG to PUBLIC with grant option
/
create or replace view DBA_REPCATLOG
    (ID, SOURCE, STATUS, USERID, TIMESTAMP, ROLE, MASTER, SNAME, REQUEST,
     ONAME, TYPE, MESSAGE, ERRNUM, GNAME)
as
select r.id, r.source, r.status, r.userid, r.timestamp, r.role, r.master,
  r.sname, r.request, r.oname, r.type, r.message, r.errnum, r.gname
from repcat_repcatlog r
/
comment on table DBA_REPCATLOG is
'Information about asynchronous administration requests'
/
comment on column DBA_REPCATLOG.ID is
'Identifying number of repcat log record'
/
comment on column DBA_REPCATLOG.SOURCE is
'Name of the database at which the request originated'
/
comment on column DBA_REPCATLOG.STATUS is
'Status of the request at this database'
/
comment on column DBA_REPCATLOG.USERID is
'Name of the user who submitted the request'
/
comment on column DBA_REPCATLOG.TIMESTAMP is
'When the request was submitted'
/
comment on column DBA_REPCATLOG.ROLE is
'Is this database the masterdef for the request'
/
comment on column DBA_REPCATLOG.MASTER is
'Name of the database that processes this request'
/
comment on column DBA_REPCATLOG.GNAME is
'Name of the replicated object group'
/
comment on column DBA_REPCATLOG.REQUEST is
'Name of the requested operation'
/
comment on column DBA_REPCATLOG.SNAME is
'Schema of replicated object name, if applicable'
/
comment on column DBA_REPCATLOG.ONAME is
'Replicated object name, if applicable'
/
comment on column DBA_REPCATLOG.TYPE is
'Type of replicated object, if applicable'
/
comment on column DBA_REPCATLOG.MESSAGE is
'Error message associated with processing the request'
/
comment on column DBA_REPCATLOG.ERRNUM is
'Oracle error number associated with processing the request'
/
drop public synonym DBA_REPCATLOG
/
create public synonym DBA_REPCATLOG for DBA_REPCATLOG
/
create or replace view USER_REPDDL
  (LOG_ID, SOURCE, ROLE, MASTER, LINE, TEXT)
as
select r.log_id, r.source, r.role, r.master, r.line, r.text
from system.repcat$_ddl r, user_repcatlog u
where r.log_id = u.id
  and r.source = u.source
/
comment on table USER_REPDDL is
'Arguments that do not fit in a single repcat log record'
/
comment on column USER_REPDDL.LOG_ID is
'Identifying number of the repcat log record'
/
comment on column USER_REPDDL.SOURCE is
'Name of the database at which the request originated'
/
comment on column USER_REPDDL.ROLE is
'Is this database the masterdef for the request'
/
comment on column USER_REPDDL.MASTER is
'Name of the database that processes this request'
/
comment on column USER_REPDDL.LINE is
'Ordering of records within a single request'
/
comment on column USER_REPDDL.TEXT is
'Portion of an argument'
/
drop public synonym USER_REPDDL
/
create public synonym USER_REPDDL for USER_REPDDL
/
grant select on USER_REPDDL to PUBLIC with grant option
/
create or replace view ALL_REPDDL
  (LOG_ID, SOURCE, ROLE, MASTER, LINE, TEXT)
as
select r.log_id, r.source, r.role, r.master, r.line, r.text
from system.repcat$_ddl r, all_repcatlog u
where r.log_id = u.id
  and r.source = u.source
/
comment on table ALL_REPDDL is
'Arguments that do not fit in a single repcat log record'
/
comment on column ALL_REPDDL.LOG_ID is
'Identifying number of the repcat log record'
/
comment on column ALL_REPDDL.SOURCE is
'Name of the database at which the request originated'
/
comment on column ALL_REPDDL.ROLE is
'Is this database the masterdef for the request'
/
comment on column ALL_REPDDL.MASTER is
'Name of the database that processes this request'
/
comment on column ALL_REPDDL.LINE is
'Ordering of records within a single request'
/
comment on column ALL_REPDDL.TEXT is
'Portion of an argument'
/
drop public synonym ALL_REPDDL
/
create public synonym ALL_REPDDL for ALL_REPDDL
/
grant select on ALL_REPDDL to PUBLIC with grant option
/
create or replace view DBA_REPDDL
  (LOG_ID, SOURCE, ROLE, MASTER, LINE, TEXT)
as
select r.log_id, r.source, r.role, r.master, r.line, r.text
from system.repcat$_ddl r
/
comment on table DBA_REPDDL is
'Arguments that do not fit in a single repcat log record'
/
comment on column DBA_REPDDL.LOG_ID is
'Identifying number of the repcat log record'
/
comment on column DBA_REPDDL.SOURCE is
'Name of the database at which the request originated'
/
comment on column DBA_REPDDL.ROLE is
'Is this database the masterdef for the request'
/
comment on column DBA_REPDDL.MASTER is
'Name of the database that processes this request'
/
comment on column DBA_REPDDL.LINE is
'Ordering of records within a single request'
/
comment on column DBA_REPDDL.TEXT is
'Portion of an argument'
/
drop public synonym DBA_REPDDL
/
create public synonym DBA_REPDDL for DBA_REPDDL
/

create table system.repcat$_priority_group
(
    sname                  varchar2(30), -- interpreted as gname
    priority_group         varchar2(30),
    data_type_id           integer
                               constraint repcat$_priority_group_nn1
                                 not null
                               constraint repcat$_priority_group_c1
                                 check (data_type_id in (1, 2, 3, 4, 5)),
    fixed_data_length      integer,
    priority_comment      varchar2(80),
        constraint repcat$_priority_group_pk
          primary key (priority_group, sname),
        constraint repcat$_priority_group_u1
          unique (sname, priority_group, data_type_id, fixed_data_length),
        constraint repcat$_priority_group_c2
          check ((data_type_id = 4 and
                  fixed_data_length is not null)
              or (data_type_id in (1, 2, 3, 5) and
                  fixed_data_length is null))
)
/
comment on table system.repcat$_priority_group is
'Information about all priority groups in the database'
/
comment on column system.repcat$_priority_group.sname is
'Name of the replicated object group'
/
comment on column system.repcat$_priority_group.priority_group is
'Name of the priority group'
/
comment on column system.repcat$_priority_group.data_type_id is
'Datatype of the value in the priority group'
/
comment on column system.repcat$_priority_group.fixed_data_length is
'Length of the value in bytes if the datatype is CHAR'
/
comment on column system.repcat$_priority_group.priority_comment is
'Description of the priority group'
/

create or replace view dba_reppriority_group
(
    sname, --- OBSOLETE
    priority_group,
    data_type,
    fixed_data_length,
    priority_comment,
    gname
)
as
select
    sname,
    priority_group,
    decode(data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           'UNDEFINED'),
    fixed_data_length,
    priority_comment,
    sname
from  system.repcat$_priority_group
/
comment on table dba_reppriority_group is
'Information about all priority groups in the database'
/
comment on column dba_reppriority_group.sname is
'OBSOLETE COLUMN: Name of the replicated schema'
/
comment on column dba_reppriority_group.gname is
'Name of the replicated object group'
/
comment on column dba_reppriority_group.priority_group is
'Name of the priority group'
/
comment on column dba_reppriority_group.data_type is
'Datatype of the value in the priority group'
/
comment on column dba_reppriority_group.fixed_data_length is
'Length of the value in bytes if the datatype is CHAR'
/
comment on column dba_reppriority_group.priority_comment is
'Description of the priority group'
/
drop public synonym dba_reppriority_group
/
create public synonym dba_reppriority_group for dba_reppriority_group
/

create or replace view all_reppriority_group
(
    sname, --- OBSOLETE
    priority_group,
    data_type,
    fixed_data_length,
    priority_comment,
    gname
)
as
select
    sname,
    priority_group,
    decode(data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           'UNDEFINED'),
    fixed_data_length,
    priority_comment,
    sname
from  system.repcat$_priority_group
/
comment on table all_reppriority_group is
'Information about all priority groups which are accessible to the user'
/
comment on column all_reppriority_group.sname is
'OBSOLETE COLUMN: Name of the replicated schema'
/
comment on column all_reppriority_group.gname is
'Name of the replicated object group'
/
comment on column all_reppriority_group.priority_group is
'Name of the priority group'
/
comment on column all_reppriority_group.data_type is
'Datatype of the value in the priority group'
/
comment on column all_reppriority_group.fixed_data_length is
'Length of the value in bytes if the datatype is CHAR'
/
comment on column all_reppriority_group.priority_comment is
'Description of the priority group'
/
drop public synonym all_reppriority_group
/
create public synonym all_reppriority_group for all_reppriority_group
/
grant select on all_reppriority_group to public with grant option
/

create or replace view user_reppriority_group
(
    priority_group,
    data_type,
    fixed_data_length,
    priority_comment
)
as
select
    priority_group,
    decode(data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           'UNDEFINED'),
    fixed_data_length,
    priority_comment
from  system.repcat$_priority_group
where sname = USER
/
comment on table user_reppriority_group is
'Information about user''s priority groups'
/
comment on column user_reppriority_group.priority_group is
'Name of the priority group'
/
comment on column user_reppriority_group.data_type is
'Datatype of the value'
/
comment on column user_reppriority_group.fixed_data_length is
'Length of the value in bytes if the datatype is CHAR'
/
comment on column user_reppriority_group.priority_comment is
'Description of the priority group'
/
drop public synonym user_reppriority_group
/
create public synonym user_reppriority_group for user_reppriority_group
/
grant select on user_reppriority_group to public with grant option
/

create table system.repcat$_priority
(
    sname                  varchar2(30) --- interpreted as gname
                               constraint repcat$_priority_nn1
                                 not null,
    priority_group         varchar2(30)
                               constraint repcat$_priority_nn2
                                 not null,
    priority               number
                               constraint repcat$_priority_nn3
                                 not null,
    raw_value              raw(255),
    char_value             char(255),
    number_value           number,
    date_value             date,
    varchar2_value         varchar2(2000),
        constraint repcat$_priority_pk
          primary key (sname, priority_group, priority),
        constraint repcat$_priority_f1
          foreign key (priority_group, sname)
          references system.repcat$_priority_group
)
/
comment on table system.repcat$_priority is
'Values and their corresponding priorities in all priority groups in the database'
/
comment on column system.repcat$_priority.sname is
'Name of the replicated object group'
/
comment on column system.repcat$_priority.priority_group is
'Name of the priority group'
/
comment on column system.repcat$_priority.priority is
'Priority of the value'
/
comment on column system.repcat$_priority.raw_value is
'Raw value'
/
comment on column system.repcat$_priority.char_value is
'Blank-padded character string'
/
comment on column system.repcat$_priority.number_value is
'Numeric value'
/
comment on column system.repcat$_priority.date_value is
'Date value'
/
comment on column system.repcat$_priority.varchar2_value is
'Character string'
/

create or replace view dba_reppriority
(
    sname, --- OBSOLETE
    priority_group,
    priority,
    data_type,
    fixed_data_length,
    char_value,
    varchar2_value,
    number_value,
    date_value,
    raw_value,
    gname
)
as
select
    p.sname,
    p.priority_group,
    v.priority,
    decode(p.data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           'UNDEFINED'),
    p.fixed_data_length,
    v.char_value,
    v.varchar2_value,
    v.number_value,
    v.date_value,
    v.raw_value,
    p.sname
from  system.repcat$_priority v,
      system.repcat$_priority_group p
where v.sname = p.sname
and   v.priority_group = p.priority_group
/
comment on table dba_reppriority is
'Values and their corresponding priorities in all priority groups in the database'
/
comment on column dba_reppriority.sname is
'OBSOLETE COLUMN: Name of the replicated schema'
/
comment on column dba_reppriority.gname is
'Name of the replicated object group'
/
comment on column dba_reppriority.priority_group is
'Name of the priority group'
/
comment on column dba_reppriority.priority is
'Priority of the value'
/
comment on column dba_reppriority.data_type is
'Datatype of the value'
/
comment on column dba_reppriority.fixed_data_length is
'Length of the value in bytes if the datatype is CHAR'
/
comment on column dba_reppriority.raw_value is
'Raw value'
/
comment on column dba_reppriority.char_value is
'Blank-padded character string'
/
comment on column dba_reppriority.number_value is
'Numeric value'
/
comment on column dba_reppriority.date_value is
'Date value'
/
comment on column dba_reppriority.varchar2_value is
'Character string'
/
drop public synonym dba_reppriority
/
create public synonym dba_reppriority for dba_reppriority
/

create or replace view all_reppriority
(
    sname, --- OBSOLETE
    priority_group,
    priority,
    data_type,
    fixed_data_length,
    char_value,
    varchar2_value,
    number_value,
    date_value,
    raw_value,
    gname
)
as
select
    p.sname,
    p.priority_group,
    v.priority,
    decode(p.data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           'UNDEFINED'),
    p.fixed_data_length,
    v.char_value,
    v.varchar2_value,
    v.number_value,
    v.date_value,
    v.raw_value,
    p.sname
from  system.repcat$_priority v,
      system.repcat$_priority_group p
where v.sname = p.sname
and   v.priority_group = p.priority_group
/
comment on table all_reppriority is
'Values and their corresponding priorities in all priority groups which are accessible to the user'
/
comment on column all_reppriority.sname is
'OBSOLETE COLUMN: Name of the replicated schema'
/
comment on column all_reppriority.gname is
'Name of the replicated object group'
/
comment on column all_reppriority.priority_group is
'Name of the priority group'
/
comment on column all_reppriority.priority is
'Priority of the value'
/
comment on column all_reppriority.data_type is
'Datatype of the value'
/
comment on column all_reppriority.fixed_data_length is
'Length of the value in bytes if the datatype is CHAR'
/
comment on column all_reppriority.raw_value is
'Raw value'
/
comment on column all_reppriority.char_value is
'Blank-padded character string'
/
comment on column all_reppriority.number_value is
'Numeric value'
/
comment on column all_reppriority.date_value is
'Date value'
/
comment on column all_reppriority.varchar2_value is
'Character string'
/
drop public synonym all_reppriority
/
create public synonym all_reppriority for all_reppriority
/
grant select on all_reppriority to public with grant option
/

create or replace view user_reppriority
(
    priority_group,
    priority,
    data_type,
    fixed_data_length,
    char_value,
    varchar2_value,
    number_value,
    date_value,
    raw_value
)
as
select
    p.priority_group,
    v.priority,
    decode(p.data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           'UNDEFINED'),
    p.fixed_data_length,
    v.char_value,
    v.varchar2_value,
    v.number_value,
    v.date_value,
    v.raw_value
from  system.repcat$_priority v,
      system.repcat$_priority_group p
where v.sname = USER
and   p.sname = USER
and   v.priority_group = p.priority_group
/
comment on table user_reppriority is
'Values and their corresponding priorities in user''s priority groups'
/
comment on column user_reppriority.priority_group is
'Name of the priority group'
/
comment on column user_reppriority.priority is
'Priority of the value'
/
comment on column user_reppriority.data_type is
'Datatype of the value'
/
comment on column user_reppriority.fixed_data_length is
'Length of the value in bytes if the datatype is CHAR'
/
comment on column user_reppriority.raw_value is
'Raw value'
/
comment on column user_reppriority.char_value is
'Blank-padded character string'
/
comment on column user_reppriority.number_value is
'Numeric value'
/
comment on column user_reppriority.date_value is
'Date value'
/
comment on column user_reppriority.varchar2_value is
'Character string'
/
drop public synonym user_reppriority
/
create public synonym user_reppriority for user_reppriority
/
grant select on user_reppriority to public with grant option
/

create table system.repcat$_column_group
(
    sname                  varchar2(30)
                               constraint repcat$_column_group_nn1
                                 not null,
    oname                  varchar2(30)
                               constraint repcat$_column_group_nn2
                                 not null,
    group_name             varchar2(30)
                               constraint repcat$_column_group_nn3
                                 not null,
    group_comment          varchar2(80),
        constraint repcat$_column_group_pk
          primary key (sname, oname, group_name)
)
/
comment on table system.repcat$_column_group is
'All column groups of replicated tables in the database'
/
comment on column system.repcat$_column_group.sname is
'Owner of replicated table'
/
comment on column system.repcat$_column_group.oname is
'Name of the replicated table'
/
comment on column system.repcat$_column_group.group_name is
'Name of the column group'
/
comment on column system.repcat$_column_group.group_comment is
'Description of the column group'
/

create or replace view dba_repcolumn_group
(
    sname,
    oname,
    group_name,
    group_comment
)
as
select
    sname,
    oname,
    group_name,
    group_comment
from  system.repcat$_column_group
/
comment on table dba_repcolumn_group is
'All column groups of replicated tables in the database'
/
comment on column dba_repcolumn_group.sname is
'Owner of replicated table'
/
comment on column dba_repcolumn_group.oname is
'Name of the replicated table'
/
comment on column dba_repcolumn_group.group_name is
'Name of the column group'
/
comment on column dba_repcolumn_group.group_comment is
'Description of the column group'
/
drop public synonym dba_repcolumn_group
/
create public synonym dba_repcolumn_group for dba_repcolumn_group
/

create or replace view all_repcolumn_group
(
    sname,
    oname,
    group_name,
    group_comment
)
as
select
    sname,
    oname,
    group_name,
    group_comment
from system.repcat$_column_group,
     sys.user$ u, sys.obj$ o
where sname = u.name
  and oname = o.name
  and o.owner# = u.user#
  and o.type = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
comment on table all_repcolumn_group is
'All column groups of replicated tables which are accessible to the user'
/
comment on column all_repcolumn_group.sname is
'Owner of replicated table'
/
comment on column all_repcolumn_group.oname is
'Name of the replicated table'
/
comment on column all_repcolumn_group.group_name is
'Name of the column group'
/
comment on column all_repcolumn_group.group_comment is
'Description of the column group'
/
drop public synonym all_repcolumn_group
/
create public synonym all_repcolumn_group for all_repcolumn_group
/
grant select on all_repcolumn_group to public with grant option
/

create or replace view user_repcolumn_group
(
    oname,
    group_name,
    group_comment
)
as
select
    oname,
    group_name,
    group_comment
from  system.repcat$_column_group
where sname = USER
/
comment on table user_repcolumn_group is
'All column groups of user''s replicated tables'
/
comment on column user_repcolumn_group.oname is
'Name of the replicated table'
/
comment on column user_repcolumn_group.group_name is
'Name of the column group'
/
comment on column user_repcolumn_group.group_comment is
'Description of the column group'
/
drop public synonym user_repcolumn_group
/
create public synonym user_repcolumn_group for user_repcolumn_group
/
grant select on user_repcolumn_group to public with grant option
/

create table system.repcat$_grouped_column
(
    sname                  varchar2(30),
    oname                  varchar2(30),
    group_name             varchar2(30),
    column_name            varchar2(30),
        constraint repcat$_grouped_column_pk
          primary key (sname, oname, group_name, column_name),
        constraint repcat$_grouped_column_f1
          foreign key (sname, oname, group_name)
          references system.repcat$_column_group
)
/
comment on table system.repcat$_grouped_column is
'Columns in all column groups of replicated tables in the database'
/
comment on column system.repcat$_grouped_column.sname is
'Owner of replicated table'
/
comment on column system.repcat$_grouped_column.oname is
'Name of the replicated table'
/
comment on column system.repcat$_grouped_column.group_name is
'Name of the column group'
/
comment on column system.repcat$_grouped_column.column_name is
'Name of the column in the column group'
/

create or replace view dba_repgrouped_column
(
    sname,
    oname,
    group_name,
    column_name
)
as
select
    sname,
    oname,
    group_name,
    column_name
from  system.repcat$_grouped_column
/
comment on table dba_repgrouped_column is
'Columns in the all column groups of replicated tables in the database'
/
comment on column dba_repgrouped_column.sname is
'Owner of replicated table'
/
comment on column dba_repgrouped_column.oname is
'Name of the replicated table'
/
comment on column dba_repgrouped_column.group_name is
'Name of the column group'
/
comment on column dba_repgrouped_column.column_name is
'Name of the column in the column group'
/
drop public synonym dba_repgrouped_column
/
create public synonym dba_repgrouped_column for dba_repgrouped_column
/

create or replace view all_repgrouped_column
(
    sname,
    oname,
    group_name,
    column_name
)
as
select
    sname,
    oname,
    group_name,
    column_name
from  system.repcat$_grouped_column,
      sys.user$ u, sys.obj$ o
where sname = u.name
  and oname = o.name
  and o.owner# = u.user#
  and o.type = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
comment on table all_repgrouped_column is
'Columns in the all column groups of replicated tables which are accessible to the user'
/
comment on column all_repgrouped_column.sname is
'Owner of replicated table'
/
comment on column all_repgrouped_column.oname is
'Name of the replicated table'
/
comment on column all_repgrouped_column.group_name is
'Name of the column group'
/
comment on column all_repgrouped_column.column_name is
'Name of the column in the column group'
/
drop public synonym all_repgrouped_column
/
create public synonym all_repgrouped_column for all_repgrouped_column
/
grant select on all_repgrouped_column to public with grant option
/

create or replace view user_repgrouped_column
(
    oname,
    group_name,
    column_name
)
as
select
    oname,
    group_name,
    column_name
from  system.repcat$_grouped_column
where sname = USER
/
comment on table user_repgrouped_column is
'Columns in the all column groups of user''s replicated tables'
/
comment on column user_repgrouped_column.oname is
'Name of the replicated table'
/
comment on column user_repgrouped_column.group_name is
'Name of the column group'
/
comment on column user_repgrouped_column.column_name is
'Name of the column in the column group'
/
drop public synonym user_repgrouped_column
/
create public synonym user_repgrouped_column for user_repgrouped_column
/
grant select on user_repgrouped_column to public with grant option
/

create table system.repcat$_conflict
(
    sname                  varchar2(30),
    oname                  varchar2(30),
    conflict_type_id       integer
                               constraint repcat$_conflict_c1
                                 check (conflict_type_id in (1, 2, 3)),
    reference_name         varchar2(30),
        constraint repcat$_conflict_pk
          primary key (sname,
                       oname,
                       conflict_type_id,
                       reference_name)
)
/
comment on table system.repcat$_conflict is
'All conflicts for which users have specified resolutions in the database'
/
comment on column system.repcat$_conflict.sname is
'Owner of replicated table'
/
comment on column system.repcat$_conflict.oname is
'Name of the replicated table'
/
comment on column system.repcat$_conflict.conflict_type_id is
'Type of conflict'
/
comment on column system.repcat$_conflict.reference_name is
'Table name, unique constraint name, or column group name'
/

create or replace view dba_repconflict
(
    sname,
    oname,
    conflict_type,
    reference_name
)
as
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name
from  system.repcat$_conflict
/
comment on table dba_repconflict is
'All conflicts for which users have specified resolutions in the database'
/
comment on column dba_repconflict.sname is
'Owner of replicated table'
/
comment on column dba_repconflict.oname is
'Name of the replicated table'
/
comment on column dba_repconflict.conflict_type is
'Type of conflict'
/
comment on column dba_repconflict.reference_name is
'Table name, unique constraint name, or column group name'
/
drop public synonym dba_repconflict
/
create public synonym dba_repconflict for dba_repconflict
/

create or replace view all_repconflict
(
    sname,
    oname,
    conflict_type,
    reference_name
)
as
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name
from  system.repcat$_conflict,
      sys.user$ u, sys.obj$ o
where sname = u.name
  and oname = o.name
  and o.owner# = u.user#
  and o.type = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
comment on table all_repconflict is
'All conflicts with available resolutions for replicated tables which are accessible to the user'
/
comment on column all_repconflict.sname is
'Owner of replicated table'
/
comment on column all_repconflict.oname is
'Name of the replicated table'
/
comment on column all_repconflict.conflict_type is
'Type of conflict'
/
comment on column all_repconflict.reference_name is
'Table name, unique constraint name, or column group name'
/
drop public synonym all_repconflict
/
create public synonym all_repconflict for all_repconflict
/
grant select on all_repconflict to public with grant option
/

create or replace view user_repconflict
(
    oname,
    conflict_type,
    reference_name
)
as
select
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name
from  system.repcat$_conflict
where sname = USER
/
comment on table all_repconflict is
'All conflicts with available resolutions for user''s replicated tables'
/
comment on column all_repconflict.oname is
'Name of the replicated table'
/
comment on column all_repconflict.conflict_type is
'Type of conflict'
/
comment on column all_repconflict.reference_name is
'Table name, unique constraint name, or column group name'
/
drop public synonym user_repconflict
/
create public synonym user_repconflict for user_repconflict
/
grant select on user_repconflict to public with grant option
/

create table system.repcat$_resolution_method
(
    conflict_type_id       integer,
    method_name            varchar2(80),
        constraint repcat$_resol_method_pk
          primary key (conflict_type_id, method_name)
)
/
comment on table system.repcat$_resolution_method is
'All conflict resolution methods in the database'
/
comment on column system.repcat$_resolution_method.conflict_type_id is
'Type of conflict'
/
comment on column system.repcat$_resolution_method.method_name is
'Name of the conflict resolution method'
/

create or replace view dba_represolution_method
(
    conflict_type,
    method_name
)
as
select
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    method_name
from  system.repcat$_resolution_method
/
comment on table dba_represolution_method is
'All conflict resolution methods in the database'
/
comment on column dba_represolution_method.conflict_type is
'Type of conflict'
/
comment on column dba_represolution_method.method_name is
'Name of the conflict resolution method'
/
drop public synonym dba_represolution_method
/
create public synonym dba_represolution_method for dba_represolution_method
/

create or replace view all_represolution_method
(
    conflict_type,
    method_name
)
as
select
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    method_name
from  system.repcat$_resolution_method
/
comment on table all_represolution_method is
'All conflict resolution methods accessible to the user'
/
comment on column all_represolution_method.conflict_type is
'Type of conflict'
/
comment on column all_represolution_method.method_name is
'Name of the conflict resolution method'
/
drop public synonym all_represolution_method
/
create public synonym all_represolution_method for all_represolution_method
/
grant select on all_represolution_method to public with grant option
/

create or replace view user_represolution_method
(
    conflict_type,
    method_name
)
as
select
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    method_name
from  system.repcat$_resolution_method
/
comment on table user_represolution_method is
'All conflict resolution methods accessible to the user'
/
comment on column user_represolution_method.conflict_type is
'Type of conflict'
/
comment on column user_represolution_method.method_name is
'Name of the conflict resolution method'
/
drop public synonym user_represolution_method
/
create public synonym user_represolution_method for user_represolution_method
/
grant select on user_represolution_method to public with grant option
/

create table system.repcat$_resolution
(
    sname                  varchar2(30),
    oname                  varchar2(30),
    conflict_type_id       integer,
    reference_name         varchar2(30),
    sequence_no            number,
    method_name            varchar2(80)
                               constraint repcat$_resolution_nn1
                                 not null,
    function_name          varchar2(92)
                               constraint repcat$_resolution_nn2
                                 not null,
    priority_group         varchar2(30),
    resolution_comment     varchar2(80),
        constraint repcat$_resolution_pk
          primary key (sname,
                       oname,
                       conflict_type_id,
                       reference_name,
                       sequence_no),
        constraint repcat$_resolution_f1
          foreign key (conflict_type_id,
                       method_name)
          references system.repcat$_resolution_method,
---        constraint repcat$_resolution_f2
---          foreign key (priority_group, sname)
---          references system.repcat$_priority_group,
        constraint repcat$_resolution_f3
          foreign key (sname,
                       oname,
                       conflict_type_id,
                       reference_name)
          references system.repcat$_conflict
)
/
comment on table system.repcat$_resolution is
'Description of all conflict resolutions in the database'
/
comment on column system.repcat$_resolution.sname is
'Owner of replicated table'
/
comment on column system.repcat$_resolution.oname is
'Name of the replicated table'
/
comment on column system.repcat$_resolution.conflict_type_id is
'Type of conflict'
/
comment on column system.repcat$_resolution.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column system.repcat$_resolution.sequence_no is
'Ordering on resolution'
/
comment on column system.repcat$_resolution.method_name is
'Name of the conflict resolution method'
/
comment on column system.repcat$_resolution.function_name is
'Name of the resolution function'
/
comment on column system.repcat$_resolution.priority_group is
'Name of the priority group used in conflict resolution'
/
comment on column system.repcat$_resolution.resolution_comment is
'Description of the conflict resolution'
/

create or replace view dba_represolution
(
    sname,
    oname,
    conflict_type,
    reference_name,
    sequence_no,
    method_name,
    function_name,
    priority_group,
    resolution_comment
)
as
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name,
    sequence_no,
    method_name,
    decode(method_name, 'USER FUNCTION', function_name, NULL),
    priority_group,
    resolution_comment
from  system.repcat$_resolution
/
comment on table dba_represolution is
'Description of all conflict resolutions in the database'
/
comment on column dba_represolution.sname is
'Owner of replicated table'
/
comment on column dba_represolution.oname is
'Name of the replicated table'
/
comment on column dba_represolution.conflict_type is
'Type of conflict'
/
comment on column dba_represolution.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column dba_represolution.sequence_no is
'Ordering on resolution'
/
comment on column dba_represolution.method_name is
'Name of the conflict resolution method'
/
comment on column dba_represolution.function_name is
'Name of the resolution function'
/
comment on column dba_represolution.priority_group is
'Name of the priority group used in conflict resolution'
/
comment on column dba_represolution.resolution_comment is
'Description of the conflict resolution'
/
drop public synonym dba_represolution
/
create public synonym dba_represolution for dba_represolution
/

create or replace view all_represolution
(
    sname,
    oname,
    conflict_type,
    reference_name,
    sequence_no,
    method_name,
    function_name,
    priority_group,
    resolution_comment
)
as
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name,
    sequence_no,
    method_name,
    decode(method_name, 'USER FUNCTION', function_name, NULL),
    priority_group,
    resolution_comment
from  system.repcat$_resolution,
      sys.user$ u, sys.obj$ o
where sname = u.name
  and oname = o.name
  and o.owner# = u.user#
  and o.type = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
comment on table all_represolution is
'Description of all conflict resolutions for replicated tables which are accessible to the user'
/
comment on column all_represolution.sname is
'Owner of replicated table'
/
comment on column all_represolution.oname is
'Name of the replicated table'
/
comment on column all_represolution.conflict_type is
'Type of conflict'
/
comment on column all_represolution.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column all_represolution.sequence_no is
'Ordering on resolution'
/
comment on column all_represolution.method_name is
'Name of the conflict resolution method'
/
comment on column all_represolution.function_name is
'Name of the resolution function'
/
comment on column all_represolution.priority_group is
'Name of the priority group used in conflict resolution'
/
comment on column all_represolution.resolution_comment is
'Description of the conflict resolution'
/
drop public synonym all_represolution
/
create public synonym all_represolution for all_represolution
/
grant select on all_represolution to public with grant option
/

create or replace view user_represolution
(
    oname,
    conflict_type,
    reference_name,
    sequence_no,
    method_name,
    function_name,
    priority_group,
    resolution_comment
)
as
select
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name,
    sequence_no,
    method_name,
    decode(method_name, 'USER FUNCTION', function_name, NULL),
    priority_group,
    resolution_comment
from  system.repcat$_resolution
where sname = USER
/
comment on table user_represolution is
'Description of all conflict resolutions for user''s replicated tables'
/
comment on column user_represolution.oname is
'Name of the replicated table'
/
comment on column user_represolution.conflict_type is
'Type of conflict'
/
comment on column user_represolution.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column user_represolution.sequence_no is
'Ordering on resolution'
/
comment on column user_represolution.method_name is
'Name of the conflict resolution method'
/
comment on column user_represolution.function_name is
'Name of the resolution function'
/
comment on column user_represolution.priority_group is
'Name of the priority group used in conflict resolution'
/
comment on column user_represolution.resolution_comment is
'Description of the conflict resolution'
/
drop public synonym user_represolution
/
create public synonym user_represolution for user_represolution
/
grant select on user_represolution to public with grant option
/

create table system.repcat$_resolution_statistics
(
    sname                  varchar2(30)
                               constraint repcat$_resolution_stats_nn1
                                 not null,
    oname                  varchar2(30)
                               constraint repcat$_resolution_stats_nn2
                                 not null,
    conflict_type_id       integer
                               constraint repcat$_resolution_stats_nn3
                                 not null,
    reference_name         varchar2(30)
                               constraint repcat$_resolution_stats_nn4
                                 not null,
    method_name            varchar2(80)
                               constraint repcat$_resolution_stats_nn5
                                 not null,
    function_name          varchar2(92)
                               constraint repcat$_resolution_stats_nn6
                                 not null,
    priority_group         varchar2(30),
    resolved_date          date
                               constraint repcat$_resolution_stats_nn7
                                 not null,
    primary_key_value      varchar2(2000)
                               constraint repcat$_resolution_stats_nn8
                                 not null
)
/
comment on table system.repcat$_resolution_statistics is
'Statistics for conflict resolutions for all replicated tables in the database'
/
comment on column system.repcat$_resolution_statistics.sname is
'Owner of replicated table'
/
comment on column system.repcat$_resolution_statistics.oname is
'Name of the replicated table'
/
comment on column system.repcat$_resolution_statistics.conflict_type_id is
'Type of conflict'
/
comment on column system.repcat$_resolution_statistics.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column system.repcat$_resolution_statistics.method_name is
'Name of the conflict resolution method'
/
comment on column system.repcat$_resolution_statistics.function_name is
'Name of the resolution function'
/
comment on column system.repcat$_resolution_statistics.priority_group is
'Name of the priority group used in conflict resolution'
/
comment on column system.repcat$_resolution_statistics.resolved_date is
'Timestamp for the resolution of the conflict'
/
comment on column system.repcat$_resolution_statistics.primary_key_value is
'Primary key of the replicated row (character data)'
/

create or replace view dba_represolution_statistics
(
    sname,
    oname,
    conflict_type,
    reference_name,
    method_name,
    function_name,
    priority_group,
    resolved_date,
    primary_key_value
)
as
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name,
    method_name,
    decode(method_name, 'USER FUNCTION', function_name, NULL),
    priority_group,
    resolved_date,
    primary_key_value
from  system.repcat$_resolution_statistics
/
comment on table dba_represolution_statistics is
'Statistics for conflict resolutions for all replicated tables in the database'
/
comment on column dba_represolution_statistics.sname is
'Owner of replicated table'
/
comment on column dba_represolution_statistics.oname is
'Name of the replicated table'
/
comment on column dba_represolution_statistics.conflict_type is
'Type of conflict'
/
comment on column dba_represolution_statistics.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column dba_represolution_statistics.method_name is
'Name of the conflict resolution method'
/
comment on column dba_represolution_statistics.function_name is
'Name of the resolution function'
/
comment on column dba_represolution_statistics.priority_group is
'Name of the priority group used in conflict resolution'
/
comment on column dba_represolution_statistics.resolved_date is
'Timestamp for the resolution of the conflict'
/
comment on column dba_represolution_statistics.primary_key_value is
'Primary key of the replicated row (character data)'
/
drop public synonym dba_represolution_statistics
/
create public synonym dba_represolution_statistics for 
  dba_represolution_statistics
/

create or replace view all_represolution_statistics
(
    sname,
    oname,
    conflict_type,
    reference_name,
    method_name,
    function_name,
    priority_group,
    resolved_date,
    primary_key_value
)
as
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name,
    method_name,
    decode(method_name, 'USER FUNCTION', function_name, NULL),
    priority_group,
    resolved_date,
    primary_key_value
from  system.repcat$_resolution_statistics,
      sys.user$ u, sys.obj$ o
where sname = u.name
  and oname = o.name
  and o.owner# = u.user#
  and o.type = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
comment on table all_represolution_statistics is
'Statistics for conflict resolutions for replicated tables which are accessible to the user'
/
comment on column all_represolution_statistics.sname is
'Owner of replicated table'
/
comment on column all_represolution_statistics.oname is
'Name of the replicated table'
/
comment on column all_represolution_statistics.conflict_type is
'Type of conflict'
/
comment on column all_represolution_statistics.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column all_represolution_statistics.method_name is
'Name of the conflict resolution method'
/
comment on column all_represolution_statistics.function_name is
'Name of the resolution function'
/
comment on column all_represolution_statistics.priority_group is
'Name of the priority group used in conflict resolution'
/
comment on column all_represolution_statistics.resolved_date is
'Timestamp for the resolution of the conflict'
/
comment on column all_represolution_statistics.primary_key_value is
'Primary key of the replicated row (character data)'
/
drop public synonym all_represolution_statistics
/
create public synonym all_represolution_statistics for
  all_represolution_statistics
/
grant select on all_represolution_statistics to public with grant option
/




create or replace view user_represolution_statistics
(
    oname,
    conflict_type,
    reference_name,
    method_name,
    function_name,
    priority_group,
    resolved_date,
    primary_key_value
)
as
select
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name,
    method_name,
    decode(method_name, 'USER FUNCTION', function_name, NULL),
    priority_group,
    resolved_date,
    primary_key_value
from  system.repcat$_resolution_statistics
where sname = USER
/
comment on table user_represolution_statistics is
'Statistics for conflict resolutions for user''s replicated tables'
/
comment on column user_represolution_statistics.oname is
'Name of the replicated table'
/
comment on column user_represolution_statistics.conflict_type is
'Type of conflict'
/
comment on column user_represolution_statistics.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column user_represolution_statistics.method_name is
'Name of the conflict resolution method'
/
comment on column user_represolution_statistics.function_name is
'Name of the resolution function'
/
comment on column user_represolution_statistics.priority_group is
'Name of the priority group used in conflict resolution'
/
comment on column user_represolution_statistics.resolved_date is
'Timestamp for the resolution of the conflict'
/
comment on column user_represolution_statistics.primary_key_value is
'Primary key of the replicated row (character data)'
/
drop public synonym user_represolution_statistics
/
create public synonym user_represolution_statistics for
  user_represolution_statistics
/
grant select on user_represolution_statistics to public with grant option
/

CREATE INDEX system.repcat$_resolution_stats_n1 on
  system.repcat$_resolution_statistics
  (
   sname,
   oname,
   resolved_date,
   conflict_type_id,
   reference_name,
   method_name,
   function_name,
   priority_group
  )
/

create table system.repcat$_resol_stats_control
(
    sname                  varchar2(30),
    oname                  varchar2(30),
    created                date
                               constraint repcat$_resol_stats_ctrl_nn1
                                 not null,
    status                 integer
                               constraint repcat$_resol_stats_ctrl_nn2
                                 not null,
    status_update_date     date
                               constraint repcat$_resol_stats_ctrl_nn3
                                 not null,
    purged_date             date,
    last_purge_start_date   date,
    last_purge_end_date     date,
        constraint repcat$_resol_stats_ctrl_pk
          primary key (sname,
                       oname)
)
/
comment on table system.repcat$_resol_stats_control is
'Information about statistics collection for conflict resolutions for all replicated tables in the database'
/
comment on column system.repcat$_resol_stats_control.sname is
'Owner of replicated table'
/
comment on column system.repcat$_resol_stats_control.oname is
'Name of the replicated table'
/
comment on column system.repcat$_resol_stats_control.created is
'Timestamp for which statistics collection was first started'
/
comment on column system.repcat$_resol_stats_control.status is
'Status of statistics collection: ACTIVE, CANCELLED'
/
comment on column system.repcat$_resol_stats_control.status_update_date is
'Timestamp for which the status was last updated'
/
comment on column system.repcat$_resol_stats_control.purged_date is
'Timestamp for the last purge of statistics data'
/
comment on column system.repcat$_resol_stats_control.last_purge_start_date is
'The last start date of the statistics purging date range'
/
comment on column system.repcat$_resol_stats_control.last_purge_end_date is
'The last end date of the statistics purging date range'
/

create or replace view dba_represol_stats_control
(
    sname,
    oname,
    created,
    status,
    status_update_date,
    purged_date,
    last_purge_start_date,
    last_purge_end_date
)
as
select
    sname,
    oname,
    created,
    decode(status,
           1, 'ACTIVE',
           2, 'CANCELLED',
           'UNDEFINED'),
    status_update_date,
    purged_date,
    last_purge_start_date,
    last_purge_end_date
from  system.repcat$_resol_stats_control
/
comment on table dba_represol_stats_control is
'Information about statistics collection for conflict resolutions for all replicated tables in the database'
/
comment on column dba_represol_stats_control.sname is
'Owner of replicated table'
/
comment on column dba_represol_stats_control.oname is
'Name of the replicated table'
/
comment on column dba_represol_stats_control.created is
'Timestamp for which statistics collection was first started'
/
comment on column dba_represol_stats_control.status is
'Status of statistics collection: ACTIVE, CANCELLED'
/
comment on column dba_represol_stats_control.status_update_date is
'Timestamp for which the status was last updated'
/
comment on column dba_represol_stats_control.purged_date is
'Timestamp for the last purge of statistics data'
/
comment on column dba_represol_stats_control.last_purge_start_date is
'The last start date of the statistics purging date range'
/
comment on column dba_represol_stats_control.last_purge_end_date is
'The last end date of the statistics purging date range'
/
drop public synonym dba_represol_stats_control
/
create public synonym dba_represol_stats_control for dba_represol_stats_control
/

create or replace view all_represol_stats_control
(
    sname,
    oname,
    created,
    status,
    status_update_date,
    purged_date,
    last_purge_start_date,
    last_purge_end_date
)
as
select
    c.sname,
    c.oname,
    c.created,
    decode(c.status,
           1, 'ACTIVE',
           2, 'CANCELLED',
           'UNDEFINED'),
    c.status_update_date,
    c.purged_date,
    c.last_purge_start_date,
    c.last_purge_end_date
from  system.repcat$_resol_stats_control c,
      sys.user$ u, sys.obj$ o
where c.sname = u.name
  and c.oname = o.name
  and o.owner# = u.user#
  and o.type = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
comment on table all_represol_stats_control is
'Information about statistics collection for conflict resolutions for replicated tables which are accessible to the user'
/
comment on column all_represol_stats_control.sname is
'Owner of replicated table'
/
comment on column all_represol_stats_control.oname is
'Name of the replicated table'
/
comment on column all_represol_stats_control.created is
'Timestamp for which statistics collection was first started'
/
comment on column all_represol_stats_control.status is
'Status of statistics collection: ACTIVE, CANCELLED'
/
comment on column all_represol_stats_control.status_update_date is
'Timestamp for which the status was last updated'
/
comment on column all_represol_stats_control.purged_date is
'Timestamp for the last purge of statistics data'
/
comment on column all_represol_stats_control.last_purge_start_date is
'The last start date of the statistics purging date range'
/
comment on column all_represol_stats_control.last_purge_end_date is
'The last end date of the statistics purging date range'
/
drop public synonym all_represol_stats_control
/
create public synonym all_represol_stats_control for
  all_represol_stats_control
/
grant select on all_represol_stats_control to public with grant option
/

create or replace view user_represol_stats_control
(
    oname,
    created,
    status,
    status_update_date,
    purged_date,
    last_purge_start_date,
    last_purge_end_date
)
as
select
    oname,
    created,
    decode(status,
           1, 'ACTIVE',
           2, 'CANCELLED',
           'UNDEFINED'),
    status_update_date,
    purged_date,
    last_purge_start_date,
    last_purge_end_date
from  system.repcat$_resol_stats_control
where sname = USER
/
comment on table user_represol_stats_control is
'Information about statistics collection for conflict resolutions for user''s replicated tables'
/
comment on column user_represol_stats_control.oname is
'Name of the replicated table'
/
comment on column user_represol_stats_control.created is
'Timestamp for which statistics collection was first started'
/
comment on column user_represol_stats_control.status is
'Status of statistics collection: ACTIVE, CANCELLED'
/
comment on column user_represol_stats_control.status_update_date is
'Timestamp for which the status was last updated'
/
comment on column user_represol_stats_control.purged_date is
'Timestamp for the last purge of statistics data'
/
comment on column user_represol_stats_control.last_purge_start_date is
'The last start date of the statistics purging date range'
/
comment on column user_represol_stats_control.last_purge_end_date is
'The last end date of the statistics purging date range'
/
drop public synonym user_represol_stats_control
/
create public synonym user_represol_stats_control for
  user_represol_stats_control
/
grant select on user_represol_stats_control to public with grant option
/

create table system.repcat$_parameter_column
(
    sname                  varchar2(30),
    oname                  varchar2(30),
    conflict_type_id       integer,
    reference_name         varchar2(30),
    sequence_no            number,
    parameter_table_name   varchar2(30),
    parameter_column_name  varchar2(30),
    parameter_sequence_no  number,
        constraint repcat$_parameter_column_pk
          primary key (sname,
                       oname,
                       conflict_type_id,
                       reference_name,
                       sequence_no,
                       parameter_table_name,
                       parameter_column_name,
                       parameter_sequence_no),
        constraint repcat$_parameter_column_f1
          foreign key (sname,
                       oname,
                       conflict_type_id,
                       reference_name,
                       sequence_no)
          references system.repcat$_resolution
)
/
comment on table system.repcat$_parameter_column is
'All columns used for resolving conflicts in the database'
/
comment on column system.repcat$_parameter_column.sname is
'Owner of replicated table'
/
comment on column system.repcat$_parameter_column.oname is
'Name of the replicated table'
/
comment on column system.repcat$_parameter_column.conflict_type_id is
'Type of conflict'
/
comment on column system.repcat$_parameter_column.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column system.repcat$_parameter_column.sequence_no is
'Ordering on resolution'
/
comment on column system.repcat$_parameter_column.parameter_table_name is
'Name of the table to which the parameter column belongs'
/
comment on column system.repcat$_parameter_column.parameter_column_name is
'Name of the parameter column used for resolving the conflict'
/
comment on column system.repcat$_parameter_column.parameter_sequence_no is
'Ordering on parameter column'
/

create or replace view dba_repparameter_column
(
    sname,
    oname,
    conflict_type,
    reference_name,
    sequence_no,
    method_name,
    function_name,
    priority_group,
    parameter_table_name,
    parameter_column_name,
    parameter_sequence_no
)
as
select
    p.sname,
    p.oname,
    decode(p.conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    p.reference_name,
    p.sequence_no,
    r.method_name,
    r.function_name,
    r.priority_group,
    p.parameter_table_name,
    p.parameter_column_name,
    p.parameter_sequence_no
from  system.repcat$_parameter_column p,
      system.repcat$_resolution r
where p.sname = r.sname
and   p.oname = r.oname
and   p.conflict_type_id = r.conflict_type_id
and   p.reference_name = r.reference_name
and   p.sequence_no = r.sequence_no
and   p.oname = p.parameter_table_name
/
comment on table dba_repparameter_column is
'All columns used for resolving conflicts in the database'
/
comment on column dba_repparameter_column.sname is
'Owner of replicated table'
/
comment on column dba_repparameter_column.oname is
'Name of the replicated table'
/
comment on column dba_repparameter_column.conflict_type is
'Type of conflict'
/
comment on column dba_repparameter_column.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column dba_repparameter_column.sequence_no is
'Ordering on resolution'
/
comment on column dba_repparameter_column.parameter_table_name is
'Name of the table to which the parameter column belongs'
/
comment on column dba_repparameter_column.parameter_column_name is
'Name of the parameter column used for resolving the conflict'
/
comment on column dba_repparameter_column.parameter_sequence_no is
'Ordering on parameter column'
/
drop public synonym dba_repparameter_column
/
create public synonym dba_repparameter_column for dba_repparameter_column
/

create or replace view all_repparameter_column
(
    sname,
    oname,
    conflict_type,
    reference_name,
    sequence_no,
    method_name,
    function_name,
    priority_group,
    parameter_table_name,
    parameter_column_name,
    parameter_sequence_no
)
as
select
    p.sname,
    p.oname,
    decode(p.conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    p.reference_name,
    p.sequence_no,
    r.method_name,
    r.function_name,
    r.priority_group,
    p.parameter_table_name,
    p.parameter_column_name,
    p.parameter_sequence_no
from  system.repcat$_parameter_column p,
      system.repcat$_resolution r,
      sys.user$ u, sys.obj$ o
where p.sname = r.sname
  and p.oname = r.oname
  and p.conflict_type_id = r.conflict_type_id
  and p.reference_name = r.reference_name
  and p.sequence_no = r.sequence_no
  and p.oname = p.parameter_table_name
  and p.sname = u.name
  and p.oname = o.name
  and o.owner# = u.user#
  and o.type = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
comment on table all_repparameter_column is
'All columns used for resolving conflicts in replicated tables which are accessible to the user'
/
comment on column all_repparameter_column.sname is
'Owner of replicated table'
/
comment on column all_repparameter_column.oname is
'Name of the replicated table'
/
comment on column all_repparameter_column.conflict_type is
'Type of conflict'
/
comment on column all_repparameter_column.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column all_repparameter_column.sequence_no is
'Ordering on resolution'
/
comment on column all_repparameter_column.parameter_table_name is
'Name of the table to which the parameter column belongs'
/
comment on column all_repparameter_column.parameter_column_name is
'Name of the parameter column used for resolving the conflict'
/
comment on column all_repparameter_column.parameter_sequence_no is
'Ordering on parameter column'
/
drop public synonym all_repparameter_column
/
create public synonym all_repparameter_column for all_repparameter_column
/
grant select on all_repparameter_column to public with grant option
/

create or replace view user_repparameter_column
(
    oname,
    conflict_type,
    reference_name,
    sequence_no,
    method_name,
    function_name,
    priority_group,
    parameter_table_name,
    parameter_column_name,
    parameter_sequence_no
)
as
select
    p.oname,
    decode(p.conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    p.reference_name,
    p.sequence_no,
    r.method_name,
    r.function_name,
    r.priority_group,
    p.parameter_table_name,
    p.parameter_column_name,
    p.parameter_sequence_no
from  system.repcat$_parameter_column p,
      system.repcat$_resolution r
where p.sname = r.sname
and   p.oname = r.oname
and   p.conflict_type_id = r.conflict_type_id
and   p.reference_name = r.reference_name
and   p.sequence_no = r.sequence_no
and   p.oname = p.parameter_table_name
and   p.sname = USER
/
comment on table user_repparameter_column is
'All columns used for resolving conflicts in user''s replicated tables'
/
comment on column user_repparameter_column.oname is
'Name of the replicated table'
/
comment on column user_repparameter_column.conflict_type is
'Type of conflict'
/
comment on column user_repparameter_column.reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column user_repparameter_column.sequence_no is
'Ordering on resolution'
/
comment on column user_repparameter_column.parameter_table_name is
'Name of the table to which the parameter column belongs'
/
comment on column user_repparameter_column.parameter_column_name is
'Name of the parameter column used for resolving the conflict'
/
comment on column user_repparameter_column.parameter_sequence_no is
'Ordering on parameter column'
/
drop public synonym user_repparameter_column
/
create public synonym user_repparameter_column for user_repparameter_column
/
grant select on user_repparameter_column to public with grant option
/

create table system.repcat$_audit_attribute
(
    attribute              varchar2(30)
                               constraint repcat$_audit_attribute_pk
                                 primary key,
    data_type_id           integer
                               constraint repcat$_audit_attribute_nn1
                                 not null,
    data_length            integer,
    source                 varchar2(92)
                               constraint repcat$_audit_attribute_nn2
                                 not null,
        constraint repcat$_audit_attribute_c1
          check ((data_type_id in (2, 4, 5) and
                  data_length is not null)
              or (data_type_id not in (2, 4, 5) and
                  data_length is null))
)
/
comment on table system.repcat$_audit_attribute is
'Information about attributes automatically maintained for replication'
/
comment on column system.repcat$_audit_attribute.attribute is
'Description of the attribute'
/
comment on column system.repcat$_audit_attribute.data_type_id is
'Datatype of the attribute value'
/
comment on column system.repcat$_audit_attribute.data_length is
'Length of the attribute value in byte'
/
comment on column system.repcat$_audit_attribute.source is
'Name of the function which returns the attribute value'
/

create or replace view dba_repaudit_attribute
(
    attribute,
    data_type,
    data_length,
    source
)
as
select
    attribute,
    decode(data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           'UNDEFINED'),
    data_length,
    source
from  system.repcat$_audit_attribute
/
comment on table dba_repaudit_attribute is
'Information about attributes automatically maintained for replication'
/
comment on column dba_repaudit_attribute.attribute is
'Description of the attribute'
/
comment on column dba_repaudit_attribute.data_type is
'Datatype of the attribute value'
/
comment on column dba_repaudit_attribute.data_length is
'Length of the attribute value in byte'
/
comment on column dba_repaudit_attribute.source is
'Name of the function which returns the attribute value'
/
drop public synonym dba_repaudit_attribute
/
create public synonym dba_repaudit_attribute for dba_repaudit_attribute
/

create or replace view all_repaudit_attribute
(
    attribute,
    data_type,
    data_length,
    source
)
as
select
    attribute,
    decode(data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           'UNDEFINED'),
    data_length,
    source
from  system.repcat$_audit_attribute
/
comment on table all_repaudit_attribute is
'Information about attributes automatically maintained for replication'
/
comment on column all_repaudit_attribute.attribute is
'Description of the attribute'
/
comment on column all_repaudit_attribute.data_type is
'Datatype of the attribute value'
/
comment on column all_repaudit_attribute.data_length is
'Length of the attribute value in byte'
/
comment on column all_repaudit_attribute.source is
'Name of the function which returns the attribute value'
/
drop public synonym all_repaudit_attribute
/
create public synonym all_repaudit_attribute for all_repaudit_attribute
/
grant select on all_repaudit_attribute to public with grant option
/

create or replace view user_repaudit_attribute
(
    attribute,
    data_type,
    data_length,
    source
)
as
select
    attribute,
    decode(data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           'UNDEFINED'),
    data_length,
    source
from  system.repcat$_audit_attribute
/
comment on table user_repaudit_attribute is
'Information about attributes automatically maintained for replication'
/
comment on column user_repaudit_attribute.attribute is
'Description of the attribute'
/
comment on column user_repaudit_attribute.data_type is
'Datatype of the attribute value'
/
comment on column user_repaudit_attribute.data_length is
'Length of the attribute value in byte'
/
comment on column user_repaudit_attribute.source is
'Name of the function which returns the attribute value'
/
drop public synonym user_repaudit_attribute
/
create public synonym user_repaudit_attribute for user_repaudit_attribute
/
grant select on user_repaudit_attribute to public with grant option
/

create table system.repcat$_audit_column
(
    sname                  varchar2(30),
    oname                  varchar2(30),
    column_name            varchar2(30),
    base_sname             varchar2(30)
                               constraint repcat$_audit_column_nn1
                                 not null,
    base_oname             varchar2(30)
                               constraint repcat$_audit_column_nn2
                                 not null,
    base_conflict_type_id  integer
                               constraint repcat$_audit_column_nn3
                                 not null,
    base_reference_name    varchar2(30)
                               constraint repcat$_audit_column_nn4
                                 not null,
    attribute              varchar2(30)
                               constraint repcat$_audit_column_nn5
                                 not null
                               constraint repcat$_audit_column_f1
                                 references system.repcat$_audit_attribute,
        constraint repcat$_audit_column_pk
          primary key (column_name, oname, sname),
        constraint repcat$_audit_column_f2
          foreign key (base_sname,
                       base_oname,
                       base_conflict_type_id,
                       base_reference_name)
          references system.repcat$_conflict
)
/
comment on table system.repcat$_audit_column is
'Information about columns in all shadow tables for all replicated tables in the database'
/
comment on column system.repcat$_audit_column.sname is
'Owner of the shadow table'
/
comment on column system.repcat$_audit_column.oname is
'Name of the shadow table'
/
comment on column system.repcat$_audit_column.column_name is
'Name of the column in the shadow table'
/
comment on column system.repcat$_audit_column.base_sname is
'Owner of replicated table'
/
comment on column system.repcat$_audit_column.base_oname is
'Name of the replicated table'
/
comment on column system.repcat$_audit_column.base_conflict_type_id is
'Type of conflict'
/
comment on column system.repcat$_audit_column.base_reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column system.repcat$_audit_column.attribute is
'Description of the attribute'
/

create or replace view dba_repaudit_column
(
    sname,
    oname,
    column_name,
    base_sname,
    base_oname,
    base_conflict_type,
    base_reference_name,
    attribute
)
as
select
    sname,
    oname,
    column_name,
    base_sname,
    base_oname,
    decode(base_conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    base_reference_name,
    attribute
from  system.repcat$_audit_column
/
comment on table dba_repaudit_column is
'Information about columns in all shadow tables for all replicated tables in the database'
/
comment on column dba_repaudit_column.sname is
'Owner of the shadow table'
/
comment on column dba_repaudit_column.oname is
'Name of the shadow table'
/
comment on column dba_repaudit_column.column_name is
'Name of the column in the shadow table'
/
comment on column dba_repaudit_column.base_sname is
'Owner of replicated table'
/
comment on column dba_repaudit_column.base_oname is
'Name of the replicated table'
/
comment on column dba_repaudit_column.base_conflict_type is
'Type of conflict'
/
comment on column dba_repaudit_column.base_reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column dba_repaudit_column.attribute is
'Description of the attribute'
/
drop public synonym dba_repaudit_column
/
create public synonym dba_repaudit_column for dba_repaudit_column
/

create or replace view all_repaudit_column
(
    sname,
    oname,
    column_name,
    base_sname,
    base_oname,
    base_conflict_type,
    base_reference_name,
    attribute
)
as
select
    sname,
    oname,
    column_name,
    base_sname,
    base_oname,
    decode(base_conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    base_reference_name,
    attribute
from  system.repcat$_audit_column,
     sys.user$ u, sys.obj$ o
where sname = u.name
  and oname = o.name
  and o.owner# = u.user#
  and o.type = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       )
/
comment on table all_repaudit_column is
'Information about columns in all shadow tables for replicated tables which are accessible to the user'
/
comment on column all_repaudit_column.sname is
'Owner of the shadow table'
/
comment on column all_repaudit_column.oname is
'Name of the shadow table'
/
comment on column all_repaudit_column.column_name is
'Name of the column in the shadow table'
/
comment on column all_repaudit_column.base_sname is
'Owner of replicated table'
/
comment on column all_repaudit_column.base_oname is
'Name of the replicated table'
/
comment on column all_repaudit_column.base_conflict_type is
'Type of conflict'
/
comment on column all_repaudit_column.base_reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column all_repaudit_column.attribute is
'Description of the attribute'
/
drop public synonym all_repaudit_column
/
create public synonym all_repaudit_column for all_repaudit_column
/
grant select on all_repaudit_column to public with grant option
/

create or replace view user_repaudit_column
(
    oname,
    column_name,
    base_sname,
    base_oname,
    base_conflict_type,
    base_reference_name,
    attribute
)
as
select
    oname,
    column_name,
    base_sname,
    base_oname,
    decode(base_conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    base_reference_name,
    attribute
from  system.repcat$_audit_column
where sname = USER
/
comment on table user_repaudit_column is
'Information about columns in all shadow tables for user''s replicated tables'
/
comment on column user_repaudit_column.oname is
'Name of the shadow table'
/
comment on column user_repaudit_column.column_name is
'Name of the column in the shadow table'
/
comment on column user_repaudit_column.base_sname is
'Owner of replicated table'
/
comment on column user_repaudit_column.base_oname is
'Name of the replicated table'
/
comment on column user_repaudit_column.base_conflict_type is
'Type of conflict'
/
comment on column user_repaudit_column.base_reference_name is
'Table name, unique constraint name, or column group name'
/
comment on column user_repaudit_column.attribute is
'Description of the attribute'
/
drop public synonym user_repaudit_column
/
create public synonym user_repaudit_column for user_repaudit_column
/
grant select on user_repaudit_column to public with grant option
/

--
-- Supported audit attributes.
--
delete from system.repcat$_audit_attribute
/
insert into system.repcat$_audit_attribute
  (attribute, data_type_id, data_length, source)
  values
  ('TIMESTAMP', 3, NULL, 'SYSDATE')
/
insert into system.repcat$_audit_attribute
  (attribute, data_type_id, data_length, source)
  values
  ('GLOBAL NAME', 2, 128, 'DBMS_REPUTIL.GLOBAL_NAME')
/

--
-- Supported automatic conflict resolution methods.
--
-- UPDATE METHODS:
-- 'MINIMUM', 'EARLIEST TIMESTAMP', 'MAXIMUM', 'LATEST TIMESTAMP',
-- 'SITE PRIORITY', 'PRIORITY GROUP', 'ADDITIVE', 'AVERAGE',
-- 'OVERWRITE', 'DISCARD', 'USER FUNCTION',
delete from system.repcat$_resolution_method
  where conflict_type_id = 1
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (1, 'MINIMUM')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name) 
  values (1, 'EARLIEST TIMESTAMP' )
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (1, 'MAXIMUM')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (1, 'LATEST TIMESTAMP')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (1, 'SITE PRIORITY')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (1, 'PRIORITY GROUP')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (1, 'ADDITIVE')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (1, 'AVERAGE')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (1, 'OVERWRITE')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (1, 'DISCARD')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (1, 'USER FUNCTION')
/

-- INSERT METHODS:
-- 'APPEND SITE NAME', 'APPEND SEQUENCE', 'DISCARD', 'USER FUNCTION'
delete from system.repcat$_resolution_method
  where conflict_type_id = 2
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (2, 'APPEND SITE NAME')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (2, 'APPEND SEQUENCE')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (2, 'DISCARD')
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (2, 'USER FUNCTION')
/

-- DELETE METHODS:
-- 'USER FUNCTION',
delete from system.repcat$_resolution_method
  where conflict_type_id = 3
/
insert into system.repcat$_resolution_method (conflict_type_id, method_name)
  values (3, 'USER FUNCTION')
/
 
commit
/

Rem  ************************************************************
Rem replacement of deferred rpc view to include joins repcat tables
Rem replace defcalldest view to include repcat query
create or replace view defcalldest as
  select C1.callno, C.deferred_tran_id, C.deferred_tran_db, D.dblink
    from system.def$_call C, system.def$_call C1, system.def$_destination D 
    where C.destination_list IS NOT NULL
      and C1.buffer_number = 1
      and C1.deferred_tran_db = c.deferred_tran_db
      and C1.deferred_tran_id = c.deferred_tran_id
      AND (C.delivery_order > D.last_delivered
           OR
           (C.delivery_order = D.last_delivered 
            AND (C.deferred_tran_id > D.last_tran_id
                 OR (C.deferred_tran_id = D.last_tran_id
                     AND C.deferred_tran_db > D.last_tran_db))))
      and (( C.destination_list = 'D' 
            AND EXISTS (
              select NULL 
                from system.def$_calldest CD
                where  CD.deferred_tran_id=C1.deferred_tran_id
                  AND  CD.deferred_tran_db=C1.deferred_tran_db
                  AND  CD.callno=C1.callno
                  AND  CD.dblink = D.dblink )
            AND NOT EXISTS (
              select NULL 
                from system.def$_error E
                where  E.deferred_tran_id=C.deferred_tran_id
                  AND  E.deferred_tran_db=C.deferred_tran_db
                  AND  E.destination = D.dblink ))
          OR ( C.destination_list='R' 
              AND EXISTS (
              SELECT NULL  
                from  system.repcat$_repprop P
                WHERE  D.dblink = P.dblink
                  AND  P.how = 1
                  AND  P.sname = C1.schemaname
                  AND  ((P.oname = C1.packagename AND P.type = 9) 
                          OR (P.oname = C1.procname AND P.type = 7)))))
/
create or replace view deftrandest as
  select C.deferred_tran_id, C.deferred_tran_db, D.dblink
    from system.def$_call C, system.def$_destination D 
    where C.destination_list IS NOT NULL
      AND (C.delivery_order > D.last_delivered
           OR
           (C.delivery_order = D.last_delivered 
            AND (C.deferred_tran_id > D.last_tran_id
                 OR (C.deferred_tran_id = D.last_tran_id
                     AND C.deferred_tran_db > D.last_tran_db))))
      and ((  C.destination_list = 'D' 
            AND EXISTS (
              select NULL 
                from system.def$_calldest CD
                where  CD.deferred_tran_id=C.deferred_tran_id
                  AND  CD.deferred_tran_db=C.deferred_tran_db
                  AND  CD.dblink = D.dblink )
            AND NOT EXISTS (
              select NULL 
                from system.def$_error E
                where  E.deferred_tran_id=C.deferred_tran_id
                  AND  E.deferred_tran_db=C.deferred_tran_db
                  AND  E.destination = D.dblink )
             )
          OR ( C.destination_list='R' 
            AND EXISTS (
              SELECT NULL  
                from system.def$_call C2, system.repcat$_repprop P
                WHERE  C2.deferred_tran_id=C.deferred_tran_id
                  AND  C2.deferred_tran_db=C.deferred_tran_db
                  AND  C2.buffer_number = 1
                  AND  D.dblink = P.dblink
                  AND  P.how = 1 
                  AND  P.sname = C2.schemaname
                  AND  ((P.oname = C2.packagename AND P.type = 9) 
                          OR (P.oname = C2.procname AND P.type = 7)))))
/
Rem **********************************************************************
Rem For SYS to be able to grant select on defcalldest and deftrandest
Rem it need to be explictly
Rem granted priviledges on the underlying SYSTEM onwed tables.
Rem To get those priviledges, SYS creates and executes a package owned 
Rem by SYSTEM that issues the grants to SYS using DBMS_SQL.
create or replace procedure system.ora$_sys_rep_auth as
i integer;
x integer;
begin
  i:=dbms_sql.open_cursor;
  dbms_sql.parse(i,'GRANT SELECT ON SYSTEM.repcat$_repschema TO SYS ' ||
                 'WITH GRANT OPTION',dbms_sql.v7);
  x:=dbms_sql.execute(i);
  dbms_sql.parse(i,'GRANT SELECT ON SYSTEM.repcat$_repprop TO SYS ' ||
                 'WITH GRANT OPTION',dbms_sql.v7);
  x:=dbms_sql.execute(i);
  dbms_sql.parse(i,'GRANT SELECT ON SYSTEM.def$_call TO SYS ' ||
                 'WITH GRANT OPTION',dbms_sql.v7);
  x:=dbms_sql.execute(i);
  dbms_sql.parse(i,'GRANT SELECT ON SYSTEM.def$_calldest TO SYS ' ||
                 'WITH GRANT OPTION',dbms_sql.v7);
  x:=dbms_sql.execute(i);
  dbms_sql.parse(i,'GRANT SELECT ON SYSTEM.def$_error TO SYS ' ||
                 'WITH GRANT OPTION',dbms_sql.v7);
  x:=dbms_sql.execute(i);
  dbms_sql.parse(i,'GRANT SELECT ON SYSTEM.def$_destination TO SYS ' ||
                 'WITH GRANT OPTION',dbms_sql.v7);
  x:=dbms_sql.execute(i);
  dbms_sql.close_cursor(i);
exception when others then
  if dbms_sql.is_open(i) then
    dbms_sql.close_cursor(i);
  end if;
  raise;
end;
/

begin
 system.ora$_sys_rep_auth;
end;  
/
