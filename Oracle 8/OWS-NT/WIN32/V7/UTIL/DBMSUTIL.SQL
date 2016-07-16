rem 
rem $Header: dbmsutil.sql,v 1.58 1995/12/21 14:38:47 ssamu Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      dbmsutil.sql - packages of various utility procedures
Rem    DESCRIPTION
Rem      This file contains various packages:
Rem         dbms_transaction	  - transaction commands
Rem         dbms_session	  - alter session commands
Rem         dbms_ddl		  - ddl commands
Rem         dbms_utility	  - helpful utilities
Rem         dbms_application_info - application information registration
Rem         dbms_system           - database system level commands
Rem         dbms_space            - segment space analysis
Rem    RETURNS
Rem 
Rem    NOTES
Rem      The procedural option is needed to use these facilities.
Rem
Rem      All of the packages below run with the privileges of calling user,
Rem      rather than the package owner ('sys').
Rem
Rem      Procedure 'dbms_ddl.alter_compile' and 'dbms_ddl.analyze_object
Rem      commit the current transaction, perform the compilation, and 
Rem      then commit again.
Rem 
Rem      The dbms_utility package is run-as-caller (psdicd.c) only for
Rem      its name_resolve, compile_schema and analyze_schema
Rem      procedures.  This package is not run-as-caller
Rem      w.r.t. SQL (psdpgi.c) so that the SQL works correctly (runs as
Rem      SYS).  The privileges are checked via dbms_ddl.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     ssamu      12/21/95 -  fix another typo
Rem     ssamu      12/21/95 -  fix typo
Rem     ssamu      10/19/95 -  add pragma for data_block_address_file
Rem     rtaranto   08/04/95 -  merge changes from branch 1.50.720.2
Rem     rtaranto   07/12/95 -  Add dbms_utility.get_hash_value
Rem     hrizvi     04/03/95 -  merge changes from branch 1.50.725.2
Rem     jarnett    01/03/95 -  add procedure purge_lost_db_entry
Rem     bhirano    12/23/94 -  merge changes from branch 1.50.720.1
Rem     hjakobss   10/12/94 -  analyze_schema support for histograms
Rem     hrizvi     02/03/95 -  add dist_txn_sync to dbms_system
Rem     bhirano    12/23/94 -  merge changes from branch 1.41.710.6
Rem     jloaiza    09/06/94 -  dbms_registration -> dbms_application_info
Rem     atsukerm   06/20/94 -  adding DBMS_SPACE package
Rem     jloaiza    06/08/94 -  change name to dbms_registration
Rem     jloaiza    04/07/94 -  add dbms_application
Rem     dsdaniel   04/07/94 -  merge changes from branch 1.41.710.4
Rem     wmaimone   04/07/94 -  merge changes from branch 1.41.710.5
Rem     adowning   03/29/94 -  merge changes from branch 1.41.710.3
Rem     wmaimone   02/07/94 -  add set close_cached_open_cursors to dbms_sessio
Rem     dsdaniel   02/04/94 -  dbms_util.port_string icd
Rem     adowning   02/02/94 -  split file into public / private binary files
Rem     rjenkins   11/17/93 -  merge changes from branch 1.41.710.2
Rem     rjenkins   10/20/93 -  merge changes from branch 1.41.710.1
Rem     rjenkins   10/28/93 -  make comma_to_table more consistent
Rem     rjenkins   10/12/93 -  adding comma_to_table
Rem     rjenkins   09/03/93 -  adding name_parse
Rem     hjakobss   07/15/93 -  bug 170473
Rem     hjakobss   07/13/93 -  bug 169577
Rem     dsdaniel   03/12/93 -  local_tid, step_id functions for replication  
Rem     mmoore     01/11/93 -  merge changes from branch 1.37.312.1 
Rem     mmoore     01/05/93 - #(145287) add another exception for discrete mode
Rem     mmoore     12/11/92 -  disable set_role in stored procs 
Rem     rkooi      11/24/92 -  fixes per Peter 
Rem     rkooi      11/21/92 -  get rid of error argument to name_resolve 
Rem     tpystyne   11/20/92 -  fix compile_all and analyze_schema 
Rem     rkooi      11/16/92 -  fix set_label 
Rem     rkooi      11/16/92 -  fix comments 
Rem     rkooi      11/13/92 -  add name_res procedure 
Rem     tpystyne   11/07/92 -  make analyze parameters optional 
Rem     mmoore     11/04/92 -  add new analyze options 
Rem     ghallmar   11/03/92 -  add dbms_transaction.purge_mixed 
Rem     rkooi      10/30/92 -  get rid of caller_id and unique_stmt_id 
Rem     rkooi      10/26/92 -  owner -> schema for SQL2 
Rem     rkooi      10/25/92 -  bug 135880 
Rem     mmoore     10/13/92 - #(131686) change messages 2074,4092,0034 
Rem     rkooi      10/02/92 -  compile_all fix 
Rem     mmoore     10/02/92 -  change pls_integer to binary_integer 
Rem     tpystyne   10/01/92 -  fix Bob's mistakes 
Rem     tpystyne   09/28/92 -  disallow commit/rollback force in rpc and trigge
Rem     mmoore     09/25/92 - #(130566) don't allow set_nls or set_role in trig
Rem     tpystyne   09/23/92 -  rename analyze to analyze_object 
Rem     rkooi      08/24/92 -  handle delimited id's in alter_compile 
Rem     tpystyne   08/06/92 -  add analyze_schema 
Rem     epeeler    07/29/92 -  add function to get time 
Rem     rkooi      06/25/92 -  workaround pl/sql bug with 'in' in SQL
Rem     rkooi      06/03/92 -  add 'get unique session id' 
Rem     jcohen     05/28/92 -  add = to alter session set label 
Rem     jloaiza    05/12/92 -  add discrete 
Rem     rkooi      04/22/92 -  put in checks for execute_sql for triggs, stored
Rem     mmoore     04/14/92 -  move begin_oltp to package transaction 
Rem     rkooi      04/06/92 -  merge changes from branch 1.4.300.1 
Rem     rkooi      04/01/92 -  Creation - split/recombined from other files
Rem     mroberts   02/21/92 -  call alter_compile, not sql_ddl 
Rem     rkooi      02/06/92 -  testing 
Rem     rkooi      02/03/92 -  compilation errors 
Rem     rkooi      01/16/92 -  Creation 

REM ********************************************************************
REM THESE PACKAGES MUST NOT BE MODIFIED BY THE CUSTOMER.  DOING SO
REM COULD CAUSE INTERNAL ERRORS AND SECURITY VIOLATIONS IN THE
REM RDBMS.  SPECIFICALLY, THE PSD* AND EXECUTE_SQL ROUTINES MUST NOT BE
REM CALLED DIRECTLY BY ANY CLIENT AND MUST REMAIN PRIVATE TO THE PACKAGE BODY.
REM ********************************************************************

create or replace package dbms_transaction is

  ------------
  --  OVERVIEW
  --
  --  This package provides access to SQL transaction statements from
  --  stored procedures.
  --  It also provids functions for monitoring transaction activities
  --  (transaction ids and ordering of steps of transactions )

  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  procedure read_only;
  --  Equivalent to SQL "SET TRANSACTION READ ONLY"
  procedure read_write;
  --  Equivalent to SQL "SET TRANSACTION READ WRITE"
  procedure advise_rollback;
  --  Equivalent to SQL "ALTER SESSION ADVISE ROLLBACK"
  procedure advise_nothing;
  --  Equivalent to SQL "ALTER SESSION ADVISE NOTHING"
  procedure advise_commit;
  --  Equivalent to SQL "ALTER SESSION ADVISE COMMIT"
  procedure use_rollback_segment(rb_name varchar2);
  --  Equivalent to SQL "SET TRANSACTION USE ROLLBACK SEGMENT <rb_seg_name>"
  --  Input arguments:
  --    rb_name
  --      Name of rollback segment to use.
  procedure commit_comment(cmnt varchar2);
  --  Equivalent to SQL "COMMIT COMMENT <text>"
  --  Input arguments:
  --    cmnt
  --      Comment to assoicate with this comment.
  procedure commit_force(xid varchar2, scn varchar2 default null);
  --  Equivalent to SQL "COMMIT FORCE <text>, <number>"
  --  Input arguments:
  --    xid
  --      Local or global transaction id.
  --    scn
  --      System change number.
  procedure commit;
    pragma interface (C, commit);                          -- 1 (see psdicd.c)
  --  Equivalent to SQL "COMMIT".  Here for completeness.  This is
  --    already implemented as part of PL/SQL.
  procedure savepoint(savept varchar2);
    pragma interface (C, savepoint);			   -- 2 (see psdicd.c)
  --  Equivalent to SQL "SAVEPOINT <savepoint_name>".  Here for
  --    completeness. This is already implemented as part of PL/SQL.
  --  Input arguments:
  --    savept
  --      Savepoint identifier.
  procedure rollback;
    pragma interface (C, rollback);			   -- 3 (see psdicd.c)
  --  Equivalent to SQL "ROLLBACK".  Here for completeness. This is 
  --    already implemented as part of PL/SQL.
  procedure rollback_savepoint(savept varchar2);
    pragma interface (C, rollback_savepoint);		   -- 4 (see psdicd.c)
  --  Equivalent to SQL "ROLLBACK TO SAVEPOINT <savepoint_name>".  Here for
  --    completeness. This is already implemented as part of PL/SQL.
  --  Input arguments:
  --    savept
  --      Savepoint identifier.
  procedure rollback_force(xid varchar2);
  --  Equivalent to SQL "ROLLBACK FORCE <text>"
  --  Input arguments:
  --    xid
  --      Local or global transaction id.
  procedure begin_discrete_transaction;
    pragma interface (C, begin_discrete_transaction);      -- 5 (see psdicd.c)
  --  Set "discrete transaction mode" for this transaction.
  --  Exceptions:
  --    ORA-08175 will be generated if a transaction attempts an operation 
  --      which cannot be performed as a discrete transaction.  If this 
  --      exception is encountered, rollback and retry the transaction.

  --    ORA-08176 will be generated if a transaction encounters data changed 
  --      by an operation that does not generate rollback data : create index,
  --      direct load or discrete transaction.  If this exception is
  --      encountered, retry the operation that received the exception.
  --    
  DISCRETE_TRANSACTION_FAILED exception;
    pragma exception_init(DISCRETE_TRANSACTION_FAILED, -8175);

  CONSISTENT_READ_FAILURE exception;
    pragma exception_init(CONSISTENT_READ_FAILURE, -8176);

  procedure purge_mixed(xid varchar2);
  --  When indoubt transactions are forced to commit or rollback (instead of
  --    letting automatic recovery resolve their outcomes), there is a
  --    possibility that a transaction can have a mixed outcome: some sites
  --    commit, and others rollback.  Such inconsistency cannot be resolved
  --    automatically by ORACLE; however, ORACLE will flag entries in
  --    DBA_2PC_PENDING by setting the MIXED column to a value of 'yes'.
  --    ORACLE will never automatically delete information about a mixed
  --    outcome transaction.  When the application or DBA is sure all
  --    inconsistencies that might have arisen as a result of the mixed
  --    transaction have been resolved, this procedure can be used to
  --    delete the information about a given mixed outcome transaction.
  --  Input arguments:
  --    xid
  --      This must be set to the value of the LOCAL_TRAN_ID column in 
  --      the DBA_2PC_PENDING table.

  procedure purge_lost_db_entry(xid varchar2);
  --  When a failure occurs during commit processing, automatic recovery will
  --    consistently resolve the results at all sites involved in the 
  --    transaction.  However, if the remote database is destroyed or 
  --    recreated before recovery completes, then the entries used to 
  --    control recovery in DBA_2PC_PENDING and associated tables will never
  --    be removed, and recovery will periodically retry.  Procedure 
  --    purge_lost_db_entry allows removal of such transactions from the 
  --    local site.

  --  WARNING: purge_lost_db_entry should ONLY be used when the other
  --  database is lost or has been recreated.  Any other use may leave the
  --  other database in an unrecoverable or inconsistent state.

  --    Before automatic recovery runs, the transaction may show 
  --    up in DBA_2PC_PENDING as state "collecting", "committed", or
  --    "prepared".  If the DBA has forced an in-doubt transaction to have
  --    a particular result by using "commit force" or "rollback force",
  --    then states "forced commit" or "forced rollback" may also appear.  
  --    Automatic recovery will normally delete entries in any of these 
  --    states.  The only exception is when recovery finds a forced
  --    transaction which is in a state inconsistent with other sites in the 
  --    transaction;  in this case, the entry will be left in the table
  --    and the MIXED column will have a value 'yes'.

  --    However, under certain conditions, it may not be possible for 
  --    automatic recovery to run.  For example, a remote database may have 
  --    been permanently lost.  Even if it is recreated, it will get a new 
  --    database id, so that recovery cannot identify it (a possible symptom 
  --    is ORA-02062).  In this case, the DBA may use the procedure 
  --    purge_lost_db_entry to clean up the entries in any state other 
  --    than "prepared".  The DBA does not need to be in any particular 
  --    hurry to resolve these entries, since they will not be holding any 
  --    database resources.
  
  --    The following table indicates what the various states indicate about
  --    the transaction and what the DBA actions should be:

  --    State       State of     State of     Normal Alternative
  --    Column      Global       Local        DBA    DBA 
  --                Transaction  Transaction  Action Action
  --    ----------  ------------ ------------ ------ ---------------
  --    collecting  rolled back  rolled back  none   purge_lost_db_entry (1)
  --    committed   committed    committed    none   purge_lost_db_entry (1)
  --    prepared    unknown      prepared     none   force commit or rollback
  --    forced      unknown      committed    none   purge_lost_db_entry (1)
  --      commit
  --    forced      unknown      rolled back  none   purge_lost_db_entry (1)
  --      rollback
  --    forced      mixed        committed    (2)
  --      commit
  --      (mixed)                              
  --    forced      mixed        rolled back  (2)
  --      rollback
  --      (mixed)                             
   
  --    Note 1: Use only if significant reconfiguration has occurred so that
  --      automatic recovery cannot resolve the transaction.  Examples are
  --      total loss of the remote database, reconfiguration in software
  --      resulting in loss of two-phase commit capability, or loss of 
  --      information from an external transaction coordinator such as a TP
  --      Monitor.
  --    Note 2: Examine and take any manual action to remove inconsistencies, 
  --      then use the procedure purge_mixed.
  --  Input arguments:
  --    xid
  --      This must be set to the value of the LOCAL_TRAN_ID column in
  --      the DBA_2PC_PENDING table.

  FUNCTION local_transaction_id(create_transaction BOOLEAN := FALSE)
    RETURN VARCHAR2;
  --  Return local (to instance) unique identfier for current transaction
  --  Return null if there is no current transction.
  --  Input parameters:
  --     create_transaction 
  --       If true , start a transaciton if one is not currently 
  --       active.
  --
  FUNCTION step_id RETURN NUMBER;
  --  Return local (to local transaction ) unique positive integer that orders
  --  The DML operations of a transaction.
  --  Input parmaeters:

end;
/
drop public synonym dbms_transaction
/
create public synonym dbms_transaction for sys.dbms_transaction
/
grant execute on dbms_transaction to public
/

create or replace package dbms_session is
  ------------
  --  OVERVIEW
  --
  --  This package provides access to SQL "alter session" statements, and
  --  other session information from, stored procedures.

  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  procedure set_role(role_cmd varchar2);
  --  Equivalent to SQL "SET ROLE ...".
  --  Input arguments:
  --    role_cmd
  --      This text is appended to "set role " and then executed as SQL.
  procedure set_sql_trace(sql_trace boolean);
  --  Equivalent to SQL "ALTER SESSION SET SQL_TRACE ..."
  --  Input arguments:
  --    sql_trace
  --      TRUE or FALSE.  Turns tracing on or off.
  procedure set_nls(param varchar2, value varchar2);
  --  Equivalent to SQL "ALTER SESSION SET <nls_parameter> = <value>"
  --  Input arguments:
  --    param
  --      The NLS parameter. The parameter name must begin with 'NLS'.
  --    value
  --      The value to set the parameter to.  If the parameter is a
  --      text literal then it will need embedded single-quotes.  For
  --      example "set_nls('nls_date_format','''DD-MON-YY''')"
  procedure close_database_link(dblink varchar2);
  --  Equivalent to SQL "ALTER SESSION CLOSE DATABASE LINK <name>"
  --  Input arguments:
  --    name
  --      The name of the database link to close.
  procedure set_label(lbl varchar2);
  --  Equivalent to SQL "ALTER SESSION SET LABEL <label specification>"
  --  Input arguments:
  --    lbl
  --      Either 'DBHIGH', 'DBLOW', or a text literal.
  procedure set_mls_label_format(fmt varchar2);
  --  Equivalent to SQL "ALTER SESSION SET MLS_LABEL_FORMAT <format>"
  --  Input arguments:
  --    fmt
  --      Format specification for the label.
  procedure reset_package;
  --  Deinstantiate all packages in this session.  In other words, free
  --    all package state.  This is the situation at the beginning of
  --    a session.
  function unique_session_id return varchar2;
  --  Return an identifier that is unique for all sessions currently
  --    connected to this database.  Multiple calls to this function 
  --    during the same session will always return the same result.
  --  Output arguments:
  --    unique_session_id
  --      can return up to 24 bytes.
  function is_role_enabled(rolename varchar2) return boolean;
  --  Determine if the named role is enabled for this session.
  --  Input arguments:
  --    rolename
  --      Name of the role.
  --  Output arguments:
  --    is_role_enabled
  --      TRUE or FALSE depending on whether the role is enabled.
  procedure set_close_cached_open_cursors(close_cursors boolean);
  --  Equivalent to SQL "ALTER SESSION SET CLOSE_CACHED_OPEN_CURSORS ..."
  --  Input arguments:
  --    close_cursors
  --      TRUE or FALSE.  Turns close_cached_open_cursors on or off.
  procedure free_unused_user_memory;
  --  Procedure for users to reclaim unused memory after performing operations
  --  requiring large amounts of memory (where large is >100K).  Note that 
  --  this procedure should only be used in cases where memory is at a 
  --  premium.  
  --
  --  Examples operations using lots of memory are:
  -- 
  --     o  large sorts where entire sort_area_size is used and
  --        sort_area_size is hundreds of KB
  --     o  compiling large PL/SQL packages/procedures/functions
  --     o  storing hundreds of KB of data within PL/SQL indexed tables
  --
  --  One can monitor user memory by tracking the statistics 
  --  "session uga memory" and "session pga memory" in the 
  --  v$sesstat/v$statname fixed views.  Monitoring these statistics will
  --  also show how much memory this procedure has freed.
  --
  --  The behavior of this procedure depends upon the configuration of the 
  --  server operating on behalf of the client:
  --  
  --     o  dedicated server - returns unused PGA memory to the OS
  --     o  MTS server       - returns unused session memory to the shared_pool
  --  
  --  In order to free memory using this procedure, the memory must 
  --  not be in use.  
  -- 
  --  Once an operation allocates memory, only the same type of operation can 
  --  reuse the allocated memory.  For example, once memory is allocated 
  --  for sort, even if the sort is complete and the memory is no longer 
  --  in use, only another sort can reuse the sort-allocated memory.  For
  --  both sort and compilation, after the operation is complete, the memory
  --  is no longer in use and the user can invoke this procedure to free the
  --  unused memory. 
  --
  --  An indexed table implicitly allocates memory to store values assigned
  --  to the indexed table's elements.  Thus, the more elements in an indexed 
  --  table, the more memory the RDBMS allocates to the indexed table.  As 
  --  long as there are elements within the indexed table, the memory
  --  associated with an indexed table is in use. 
  -- 
  --  The scope of indexed tables determines how long their memory is in use. 
  --  Indexed tables declared globally are indexed tables declared in packages
  --  or package bodies.  They allocate memory from session memory.  For an
  --  indexed table declared globally, the memory will remain in use
  --  for the lifetime of a user's login (lifetime of a user's session),
  --  and is freed after the user disconnects from ORACLE.
  --     
  --  Indexed tables declared locally are indexed tables declared within
  --  functions, procedures, or anonymous blocks.  These indexed tables
  --  allocate memory from PGA memory.  For an indexed table declared 
  --  locally, the memory will remain in use for as long as the user is still
  --  executing the procedure, function, or anonymous block in which the 
  --  indexed table is declared.  After the procedure, function, or anonymous
  --  block is finished executing, the memory is then available for other 
  --  locally declared indexed tables to use (i.e., the memory is no longer
  --  in use).
  --  
  --  Assigning an uninitialized, "empty," indexed table to an existing index
  --  table is a method to explicitly re-initialize the indexed table and the
  --  memory associated with the indexed table.  After this operation,
  --  the memory associated with the indexed table will no longer be in use, 
  --  making it available to be freed by calling this procedure.  This method
  --  is particularly useful on indexed tables declared globally which can grow
  --  during the lifetime of a user's session, as long as the user no 
  --  longer needs the contents of the indexed table.  
  --  
  --  The memory rules associated with an indexed table's scope still apply; 
  --  this method and this procedure, however, allow users to 
  --  intervene and to explictly free the memory associated with an
  --  indexed table. 
  -- 
  --  The PL/SQL fragment below illustrates the method and the use 
  --  of procedure free_unused_user_memory.
  --
  --  create package foobar
  --     type number_idx_tbl is table of number indexed by binary_integer;
  -- 
  --     store1_table  number_idx_tbl;     --  PL/SQL indexed table
  --     store2_table  number_idx_tbl;     --  PL/SQL indexed table
  --     store3_table  number_idx_tbl;     --  PL/SQL indexed table
  --     ...
  --  end;            --  end of foobar
  --
  --  declare
  --     ...
  --     empty_table   number_idx_tbl;     --  uninitialized ("empty") version
  --  
  --  begin
  --     for i in 1..1000000 loop
  --       store1_table(i) := i;           --  load data
  --     end loop;
  --     ...
  --     store1_table := empty_table;      --  "truncate" the indexed table
  --     ... 
  --     -
  --     dbms_session.free_unused_user_memory;  -- give memory back to system
  --  
  --     store1_table(1) := 100;           --  index tables still declared;
  --     store2_table(2) := 200;           --  but truncated.
  --     ...
  --  end;
  -- 
  --  Performance Implication: 
  --     This routine should be used infrequently and judiciously.
  --       
  --  Input arguments:
  --     n/a
end;
/

drop public synonym dbms_session
/
create public synonym dbms_session for sys.dbms_session
/
grant execute on dbms_session to public
/

create or replace package dbms_ddl is
  ------------
  --  OVERVIEW
  --
  --  This package provides access to some SQL DDL statements from
  --  stored procedures.

  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  procedure alter_compile(type varchar2, schema varchar2, name varchar2);
  --  Equivalent to SQL "ALTER PROCEDURE|FUNCTION|PACKAGE [<schema>.]
  --    <name> COMPILE [BODY]".  If the named object is this package,
  --    or any packages upon which it depends (currently "standard" or 
  --    "dbms_standard") then the procedure simply returns (since these
  --    packages are clearly successfully compiled).
  --  Input arguments:
  --    type
  --      Must be one of "PROCEDURE", "FUNCTION", "PACKAGE" or "PACKAGE
  --      BODY".
  --    schema
  --      The schema name.  If NULL then use current schema.  Case sensitive.
  --    name
  --      The name of the object.  Case sensitive.
  --  Exceptions:
  --    ORA-20000: Insufficient privileges or object does not exist.
  --    ORA-20001: Remote object, cannot compile.
  --    ORA-20002: Bad value for object type.  Should be one of PACKAGE,
  --      PACKAGE BODY, PROCEDURE, or FUNCTION.
  procedure analyze_object
    (type varchar2, schema varchar2, name varchar2, method varchar2,
     estimate_rows number default null, 
     estimate_percent number default null, method_opt varchar2 default null);
  --  Equivalent to SQL "ANALYZE TABLE|CLUSTER|INDEX [<schema>.]<name>
  --    [<method>] STATISTICS [SAMPLE <n> [ROWS|PERCENT]]"
  --  Input arguments:
  --    type
  --      One of 'TABLE', 'CLUSTER' or 'INDEX'.  If none of these, the
  --      procedure just returns.
  --    schema
  --      schema of object to analyze.  NULL means current schema.  Case
  --      sensitive.
  --    name
  --      name of object to analyze.  Case sensitive.
  --    method
  --      NULL or 'ESTIMATE'.  If 'ESTIMATE' then either estimate_rows
  --      or estimate_percent must be non-zero.
  --    estimate_rows
  --      Number of rows to estimate
  --    estimate_percent
  --      Percentage of rows to estimate.  If estimate_rows is specified
  --      than ignore this parameter.
  --    method_opt
  --      method options of the following format
  --      [ FOR TABLE ]
  --      [ FOR ALL [INDEXED] COLUMNS] [SIZE n]
  --      [ FOR ALL INDEXES ]
  --  Exceptions:
  --    ORA-20000: Insufficient privileges or object does not exist.
  --    ORA-20001: Bad value for object type.  Should be one of TABLE, INDEX
  --      or CLUSTER.
end;
/

drop public synonym dbms_ddl
/
create public synonym dbms_ddl for sys.dbms_ddl
/
grant execute on dbms_ddl to public
/

create or replace package dbms_utility is
  ------------
  --  OVERVIEW
  --
  --  This package provides various utility routines.

  ----------------------------
  --  PL/SQL TABLES
  --
  type uncl_array IS table of VARCHAR2(227) index by BINARY_INTEGER;
  --  Lists of "USER"."NAME"."COLUMN"@LINK should be stored here

  type name_array IS table of VARCHAR2(30) index by BINARY_INTEGER;
  --  Lists of NAME should be stored here

  type dblink_array IS table of VARCHAR2(128) index by BINARY_INTEGER;
  --  Lists of database links should be stored here

  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  procedure compile_schema(schema varchar2);
  --  Compile all procedures, functions and packages in the specified
  --  schema.  After calling this procedure you should select from view
  --  ALL_OBJECTS for items with status of 'INVALID' to see if all objects
  --  were successfully compiled.  You may use the SQLDBA command "SHOW
  --  ERRORS <type> <schema>.<name>" to see the errors assocated with
  --  'INVALID' objects.
  --  Input arguments:
  --    schema
  --      Name of the schema.
  --  Exceptions:
  --    ORA-20000: Insufficient privileges for some object in this schema.
  procedure analyze_schema(schema varchar2, method varchar2, 
    estimate_rows number default null, 
    estimate_percent number default null, method_opt varchar2 default null);
  --  Analyze all the tables, clusters and indexes in a schema.
  --  Input arguments:
  --    schema
  --      Name of the schema.
  --    method, estimate_rows, estimate_percent, method_opt
  --      See the descriptions above in sql_ddl.analyze.object.
  --  Exceptions:
  --    ORA-20000: Insufficient privileges for some object in this schema.
  procedure analyze_database(method varchar2, 
    estimate_rows number default null, 
    estimate_percent number default null, method_opt varchar2 default null);
  --  Analyze all the tables, clusters and indexes in a database.
  --  Input arguments:
  --    method, estimate_rows, estimate_percent, method_opt
  --      See the descriptions above in sql_ddl.analyze.object.
  --  Exceptions:
  --    ORA-20000: Insufficient privileges for some object in this database.
  function format_error_stack return varchar2;
    pragma interface (C, format_error_stack);		    -- 1 (see psdicd.c)
  --  Format the current error stack.  This can be used in exception
  --    handlers to look at the full error stack.
  --  Output arguments:
  --    format_error_stack
  --      Returns the error stack.  May be up to 2000 bytes.
  function format_call_stack return varchar2;
    pragma interface (C, format_call_stack);		    -- 2 (see psdicd.c)
  --  Format the current call stack.  This can be used an any stored
  --    procedure or trigger to access the call stack.  This can be
  --    useful for debugging.
  --  Output arguments:
  --    format_call_stack
  --      Returns the call stack.  May be up to 2000 bytes.
  function is_parallel_server return boolean;
  --  Find out if this database is running in parallel server mode.
  --  Output arguments:
  --    is_parallel_server
  --      TRUE if this instance was started in parallel server mode,
  --      FALSE otherwise.
  function get_time return number;
  --  Find out the current time in 100th's of a second.
  --  Output argukments:
  --    get_time
  --      The time is the number of 100th's of a second from some
  --      arbitrary epoch.
  procedure name_resolve(name in varchar2, context in number,
    schema out varchar2, part1 out varchar2, part2 out varchar2,
    dblink out varchar2, part1_type out number, object_number out number);
  --  Resolve the given name.  Do synonym translation if necessary.  Do
  --    authorization checking.
  --  Input arguments:
  --    name
  --      The name of the object.  This can be of the form [[a.]b.]c[@d]
  --      where a,b,c are SQL identifier and d is a dblink.  No syntax
  --      checking is performed on the dblink.  If a dblink is specified,
  --      of the name resolves to something with a dblink, then object
  --      is not resolved, but the schema, part1, part2 and dblink out
  --      arguments are filled in.  a,b and c may be delimted identifiers,
  --      and may contain NLS characters (single and multi-byte).
  --    context
  --      Not currently used, must be set to 1 for future compatibility.
  --  Output arguments:
  --    schema
  --      The schema of the object.  If no schema is specified in 'name'
  --      then the schema is determined by resolving the name.
  --    part1
  --      The first part of the name.  The type of this name is specified
  --      part1_type (synonym, procedure or package).
  --    part2
  --      If this is non-null, then this is a procedure name within the
  --      package indicated by part1.
  --    dblink
  --      If this is non-null then a database link was either specified
  --      as part of 'name' or 'name' was a synonym which resolved to
  --      something with a database link.  In this later case, part1_type
  --      will indicate a synonym.
  --    part1_type
  --      The type of part1 is
  --        5 - synonym
  --        7 - procedure (top level)
  --        8 - function (top level)
  --        9 - package
  --      If a synonym, it means that 'name' is a synonym that translats
  --      to something with a database link.  In this case, if further
  --      name translation is desired, then you must call the 
  --      dbms_utility.name_resolve procedure on this remote node.
  --    object_number
  --      If non-null then 'name' was successfully resolved and this is the
  --      object number which it resolved to.
  --  Exceptions:
  --    All errors are handled by raising exceptions.  A wide variety of
  --    exceptions are possible, based on the various syntax error that
  --    are possible when specifying object names.
  procedure name_tokenize( name    in  varchar2,
		           a       out varchar2,
		           b       out varchar2,
	                   c       out varchar2,
		           dblink  out varchar2, 
                           nextpos out binary_integer);
  --  Call the parser to parse the given name as "a [. b [. c ]][@ dblink ]".
  --  Strip doublequotes, or convert to uppercase if there are no quotes.
  --    Ignore comments of all sorts.  Do no semantic analysis.  Leave any
  --      missing values as null. 
  --  For each of a,b,c,dblink, tell where the following token starts
  --    in anext,bnext,cnext,dnext respectively.
  PROCEDURE comma_to_table( list   IN  VARCHAR2,
                            tablen OUT BINARY_INTEGER,
                            tab    OUT uncl_array);
  --  Convert a comma-separated list of names into a PL/SQL table of names
  --  This uses name_tokenize to figure out what are names and what are commas

  PROCEDURE table_to_comma( tab    IN  uncl_array, 
                            tablen OUT BINARY_INTEGER,
                            list   OUT VARCHAR2);
  --  Convert a PL/SQL table of names into a comma-separated list of names

  FUNCTION port_string RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(port_string, WNDS, RNDS, WNPS, RNPS);
  --  Return a string that uniquely identifies the version of Oracle and 
  --  the port (operating system).  EG "VAX/VMX-7.1.0.0"
  --  maximum length is port specific.

  function make_data_block_address(file number, block number) return number;
  PRAGMA RESTRICT_REFERENCES(make_data_block_address, WNDS, RNDS, WNPS, RNPS);
  --  Creates a data block address given a file# and a block#.  A data block
  --  address is the internal structure used to identify a block in the
  --  database.  This is function useful when accessing certain fixed tables
  --  that contain data block addresses.
  --  Input arguments:
  --    file  - the file that contains the block
  --    block - the offset of the block within the file in terms of block 
  --            increments
  --  Output arguments:
  --    dba   - the data block address
  function data_block_address_file(dba number) return number;
  PRAGMA RESTRICT_REFERENCES(data_block_address_file, WNDS, RNDS, WNPS, RNPS);
  --  Get the file number part of a data block address
  --  Input arguments:
  --    dba   - a data block address
  --  Output Arguments:
  --    file  - the file that contains the block
  function data_block_address_block(dba number) return number;
  PRAGMA RESTRICT_REFERENCES(data_block_address_block, WNDS, RNDS, WNPS, RNPS);
  --  Get the block number part of a data block address
  --  Input arguments:
  --    dba   - a data block address
  --  Output Arguments:
  --    block  - the block offset of the block  
  function get_hash_value(name varchar2, base number, hash_size number)
    return number;
  PRAGMA RESTRICT_REFERENCES(get_hash_value, WNDS, RNDS, WNPS, RNPS);
  --  Compute a hash value for the given string
  --  Input arguments:
  --    name  - The string to be hashed.
  --    base  - A base value for the returned hash value to start at.
  --    hash_size -  The desired size of the hash table.
  --  Returns:
  --    A hash value based on the input string.
  --    For example, to get a hash value on a string where the hash value 
  --    should be between 1000 and 3047, use 1000 as the base value and
  --    2048 as the hash_size value.  Using a power of 2 for the hash_size
  --    parameter works best.
end;
/

drop public synonym dbms_utility
/
create public synonym dbms_utility for sys.dbms_utility
/
grant execute on dbms_utility to public
/


  ------------
  --  OVERVIEW
  --
  --  The dbms_application_info package provides a mechanism for registering 
  --  the name of the application module that is currently running with the 
  --  rdbms. Registering the name of the module allows DBAs to monitor how the 
  --  system is being used, and do performance analysis, and resource 
  --  accounting by module.  The name that is registered through this 
  --  package will appear in the 'module' and 'action' column of 
  --  the v$session virtual table. It will also appear in the 'module' and 
  --  'action' columns in v$sqlarea.
  --
  --  The MODULE name is normally set to a user recognizable name for the 
  --  program that is currently executing.  For example, this could be the name
  --  of the form that is executing, or it could be the name of the script that
  --  is being executed by sql*plus.  The idea is to be able to identify the
  --  high level function that is being performed.  For instance, you can tell
  --  that a user is in the 'order entry' form instead of just telling that he
  --  is running sql*forms.  We encourage application tool vendors to 
  --  automatically set this value whenever an application is executed.
  --
  --  The ACTION name is normally set to a specific action that a user is
  --  performing within a module.  For instance a user could be 'reading
  --  mail' or 'entering a new customer'.  This is meant to more specifically 
  --  identify what a user is currently doing.  The action should normally be
  --  set by the designer of a specific application.  It should not 
  --  automatically be set by the application tool.
  --
  --  If the local DBA would like to gather his own statistics based on
  --  module, then the DBA can implement a wrapper around this package 
  --  by writing a version of this package in another schema that first 
  --  gathers statistics and then calls the sys version of the package.  The 
  --  public synonym for dbms_application_info can then be changed to point 
  --  to the DBA's version of the package.
  --
create or replace package dbms_application_info is
  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  procedure set_module(module_name varchar2, action_name varchar2);
  --  Sets the name of the module that is currently running to a new
  --    module.  When the current module terminates, this should
  --    be called with the name of the new module if there is one, or
  --    null if there is not a new module.  Passing null for either of these
  --    values is equivalent to passing a zero length string.
  --  Input arguments:
  --    module_name
  --      The name of the module that will now be running.  The maximum
  --      length of the module name is 48 bytes.  Longer names will be
  --      truncated.
  --    action_name
  --      The name of the action that will now be running.  The maximum
  --      length of the action_name is 32 bytes.  Longer names will be
  --      truncated. If the action name is not being specified, then null 
  --      should be passed for this value.
  --
  procedure set_action(action_name varchar2);
  --  Sets the name of the current action within the current module.
  --    When the current action terminates, this should be called with the 
  --    name of the new action if there is one, or null if there is not a 
  --    new action.  Passing null for this value is equivalent to passing
  --    a zero length string.
  --  Input arguments:
  --    action_name
  --      The name of the action that will now be running.  The maximum
  --      length of the action_name is 32 bytes.  Longer names will be
  --      truncated.
  --
  procedure read_module(module_name out varchar2, action_name out varchar2);
  --  Reads the values of the module and action fields of the current 
  --    session.
  --  Output arguments:
  --    module_name 
  --      The last value that the module name was set to using the set_module
  --      procedure.
  --    action_name
  --      The last value that the action name was set to using the set_module
  --      or set_action procedures.
  --
  procedure set_client_info(client_info varchar2);
  --  Sets the client info field of the session.  The client info field is
  --    provided for the use of individual applications.  The Oracle system 
  --    does not use this field for any purpose.  After being set, the 
  --    client info field can be queried from v$session.
  --  Input arguments:
  --    client_info 
  --      Any character data that the client wishes to store up to a maximum of
  --      64 bytes.  Longer values will be truncated.  Passing a null is
  --      equivalent to passing a zero length string.

  procedure read_client_info(client_info out varchar2);
  --  Reads the value of the client_info field of the current session.
  --  Output arguments:
  --    client_info
  --      The last value that the client_info field was set to using the
  --      set_client_info procedure.

end;
/

-- Note that the public synonym for dbms_application_info is not dropped before
-- creation in order to allow users to redirect the public synonym to point
-- to their own package.  If we dropped it, then everytime they ran this 
-- script, their package would be overriden by the default oracle package.
create public synonym dbms_application_info for sys.dbms_application_info
/
grant execute on sys.dbms_application_info to public
/


create or replace package dbms_system is
  ------------
  --  OVERVIEW
  --
  --  This package provides some system level utilities.

  --  SECURITY
  --
  --  This package is only accessible to user SYS by default.  You can control
  --  access to these routines by only granting execute to privileged users.

  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  procedure set_ev(si binary_integer, se binary_integer, 
	           ev binary_integer, le binary_integer, nm varchar2);
  --  This is an internally used routine that should never be called by users.

  procedure read_ev(iev binary_integer, oev out binary_integer);
  --  This is an internally used routine that should never be called by users.
  --
  --
  procedure dist_txn_sync(inst_num number);
  --  This should be normally be only called by the XA library.

  procedure set_sql_trace_in_session(sid number, serial# number, 
	                             sql_trace boolean);
  --  Enable sql_trace in the session identified by (sid, serial#).  These
  --  value are gotten from v$session. 
  --  Input arguments:
  --   sid  
  --	  session id
  --   serial#
  --      session serial number
  --  sql_trace
  --      if true then enable tracing, if false disable tracing.	
  --
end;
/

create or replace package dbms_space is
  ------------
  --  OVERVIEW
  --
  --  This package provides segment space information not currently
  --  available through the standard views.

  --  SECURITY
  --
  --  The execution privilege is granted to PUBLIC. Procedures in this
  --  package run under the caller security. The user must have ANALYZE
  --  privilege on the object.


  ----------------------------

  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  procedure unused_space(segment_owner IN varchar2, 
                         segment_name IN varchar2,
                         segment_type IN varchar2,
                         total_blocks OUT number,
                         total_bytes OUT number,
                         unused_blocks OUT number,
                         unused_bytes OUT number,
                         last_used_extent_file_id OUT number,
                         last_used_extent_block_id OUT number,
                         last_used_block OUT number
                         );
  --  Returns information about unused space in an object (table, index,
  --    or cluster).
  --  Input arguments:
  --   segment_owner  
  --	  schema name of the segment to be analyzed
  --   segment_name  
  --	  object name of the segment to be analyzed
  --   segment_type  
  --	  type of the segment to be analyzed (TABLE, INDEX, or CLUSTER)
  --  Output arguments:
  --   total_blocks  
  --	  total number of blocks in the segment
  --   total_bytes  
  --	  the same as above, expressed in bytes
  --   unused_blocks  
  --	  number of blocks which are not used 
  --   unused_bytes  
  --	  the same as above, expressed in bytes
  --   last_used_extent_file_id 
  --	  the file ID of the last extent which contains data
  --   last_used_extent_block_id 
  --	  the block ID of the last extent which contains data
  --   last_used_block  
  --	  the last block within this extent which contains data
  procedure free_blocks (segment_owner IN varchar2, 
                         segment_name IN varchar2,
                         segment_type IN varchar2,
                         freelist_group_id IN number,
                         free_blks OUT number,
                         scan_limit IN number DEFAULT NULL
                         );
  --  Returns information about free blocks in an object (table, index,
  --    or cluster).
  --  Input arguments:
  --   segment_owner  
  --	  schema name of the segment to be analyzed
  --   segment_name  
  --	  name of the segment to be analyzed
  --   segment_type  
  --	  type of the segment to be analyzed (TABLE, INDEX, or CLUSTER)
  --   freelist_group_id  
  --	  freelist group (instance) whose free list size is to be computed
  --   scan_limit (optional)
  --	  maximum number of free blocks to read
  --  Output arguments:
  --   free_blks  
  --	  count of free blocks for the specified group
end;
/
drop public synonym dbms_space
/
create public synonym dbms_space for sys.dbms_space
/
grant execute on dbms_space to public
/
