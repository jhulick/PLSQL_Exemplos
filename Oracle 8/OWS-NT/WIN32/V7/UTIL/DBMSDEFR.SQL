rem 
rem $Header: dbmsdefr.sql,v 1.19 1995/11/20 12:35:24 sjain Exp $ 
rem 
rem 
Rem  Copyright (c) 1993 by Oracle Corporation 
Rem  Copyright (c) 1992,1993 by Oracle Corporation
Rem  ***** Oracle Proprietary                                           *****
Rem  ***** This file contains the embodiment of proprietary technology. *****
Rem  ***** It is for the sole use of Oracle employees and Oracle        *****
Rem  ***** customers who have executed non-disclosure agreements.       *****
Rem  ***** The contents of this file may not be disclosed to persons    *****
Rem  ***** or organization who have not executed a non-disclosure       *****
Rem  ***** agreement.                                                   *****
Rem    NAME
Rem      dbmsdefr.sql - replicated deferred remote procedure calls
Rem    DESCRIPTION
Rem      The external interfaces and bodies of two replication packages are 
Rem      also included, as are some sequences used by the packages.
Rem      All objects  are created in the schema 'SYS'.
Rem       Packages
Rem         dbms_defer
Rem         dbms_defer_query
Rem         dbms_defer_sys
Rem 
Rem    NOTES
Rem      The algorithms used here were originally conceived by Sandeep
Rem	     Jain, and are described in a forthcoming memo by Sandeep Jain
Rem      and Dean Daniels Titled "A Method for Deferring Remote Procedure Calls
Rem      Utilizing a Relational Database System."
Rem
Rem      The structures implemented by this package should probably be a
Rem      cluster.  The create table statements can be modified to include
Rem      storage information as appropriate for a particular installation.
Rem
Rem    DEPENDENCIES
Rem      These packages use calls from  the DBMS_SQL, DBMS_ASYNCRPC, and
Rem      DBMS_DEFER_PACK packages
Rem      
Rem    USAGE
Rem      This script is to be run by user connected as INTERNAL.
Rem
Rem    SECURITY
Rem      Tables and sequences created by this script are kept private
Rem      The dbms_defer package is granted to public, but it is reasonable to 
Rem      restrict access
Rem      to users creating replicated applications.  
Rem      The dbms_defer_query package can be executed by users who need to 
Rem      monitor deferred rpc queues, for example dba correcting conflicts.
Rem      The dbms_defer_sys package is granted to DBAs (by default)
Rem      The dbms_defer_internal_sys packages is 
Rem      kept  private. 
Rem      The dbms_defer_pack package is kept private, as is dbms_asyncrpc.
Rem     
Rem    COMPATIBILITY
Rem    MODIFIED   (MM/DD/YY)
Rem     sjain      11/20/95 -  Add toms
Rem     jstamos    08/17/95 -  code review changes
Rem     boki       07/07/95 -  new function to disable queue propagation
Rem     jstamos    06/29/95 -  merge changes from branch 1.9.720.6
Rem     hasun      03/20/95 -  Reset batch size to 0
Rem     hasun      01/24/95 -  Add gname parameter to call()
Rem     dsdaniel   01/17/95 -  eliminate grant to public
Rem     dsdaniel   12/05/94 -  eliminate def_trandest table
Rem     boki       12/02/94 -  modified execute(), adding new argument
Rem     hasun      11/17/94 -  add Exception NOREPOPTION for factoring
Rem     dsdaniel   10/26/94 -  coverage, interface changes
Rem     dsdaniel   09/12/94 -  comment in dbms_defer_query
Rem     dsdaniel   07/11/94 -  dbms_sys_error upgrade
Rem     adowning   04/29/94 -  merge latest revisions from repint
Rem     dsdaniel   03/29/94 -  error message change
Rem     dsdaniel   02/17/94 -  repcat integration
Rem     adowning   02/02/94 -  split file into public / private binary files
Rem     dsdaniel   01/20/94 -  dbms_sys_error error range change
Rem     rjenkins   01/13/94 -  giving RESET a default
Rem     dsdaniel   12/27/93 -  dbms_sys_sql change
Rem     rjenkins   12/22/93 -  oops
Rem     rjenkins   12/17/93 -  creating job queue
Rem     dsdaniel   11/02/93 -  dbms_sql.parse changes
Rem     dsdaniel   10/28/93 -  deferred rpc dblink security
Rem     dsdaniel   10/26/93 -  merge changes from branch 1.1.400.3
Rem     dsdaniel   10/10/93 -  break out queue tables
Rem     rjenkins   10/07/93 -  adding deferrcount
Rem     dsdaniel   08/30/93 -  package for installation by system
Rem     dsdaniel   08/04/93 -  Creation by renaming dbmsrrpc.sql
Rem     dsdaniel   05/17/93 -  upgrade to 7.0/7.1 version 
Rem     dsdaniel   02/22/93 -  Creation 
Rem   *******************************************************************
Rem 
Rem      
Rem

REM ********************************************************************
REM THIS PACKAGE MUST NOT BE MODIFIED BY THE CUSTOMER.  DOING SO
REM COULD CAUSE INTERNAL ERRORS AND SECURITY VIOLATIONS IN THE
REM RDBMS.  SPECIFICALLY, THE PSD* ROUTINES MUST NOT BE CALLED
REM DIRECTLY BY ANY CLIENT AND MUST REMAIN PRIVATE TO THE PACKAGE BODY.
REM ********************************************************************

CREATE OR REPLACE PACKAGE dbms_defer AS
  -------------------
  --  OVERVIEW
  -- 
  -- This package is the user interface to a replicated transactional 
  -- deferred remote
  -- procedure call facility.  Replicated applications use the calls 
  -- in this interface
  -- to queue procedure call for later transactional execution at remote nodes.
  -- These routines are typically called from either after row triggers 
  -- or application
  -- specified update procedures.
  ------------
  --  SECURITY
  --
  -- This package is not granted to public because a user can 
  -- potentially steal the rights of the user pushing the deferred rpcs.
  -- Be careful when granting execute privileges on dbms_defer.
  -------------
  --  CONSTANTS
  --
  --     constants used in the arg_type column of the def$_args table
  --     definitions copied from dtydef.h
  --
  arg_type_num      CONSTANT NUMBER := 2;  -- DTYNUM 
  arg_type_char     CONSTANT NUMBER := 96; -- DTYAFC
  arg_type_varchar2 CONSTANT NUMBER := 1;  -- DTYCHAR
  arg_type_date     CONSTANT NUMBER := 12; -- DTYDAT
  arg_type_rowid    CONSTANT NUMBER := 11; -- DTYRID
  arg_type_raw      CONSTANT NUMBER := 23; -- DTYBIN
  --     definition same as dbms_repcat_mas.repcat_status_normal
  --     (don't want to require repcat to be loaded)
  repcat_status_normal  CONSTANT NUMBER := 0.0;
  --
  ---------
  --  TYPES
  --
  --    node list type used for the defer_txn call
  --      representation is an array (table) indexed from 1 up to a NULL
  --      entry or NO_DATA_FOUND
  TYPE node_list_t IS TABLE OF  VARCHAR2(128) INDEX BY BINARY_INTEGER;
  --
  -----------------
  --  EXCEPTIONS
  --
  --  Parameter type does not match actual type. 
  bad_param_type EXCEPTION;
  PRAGMA exception_init(bad_param_type, -23325);
  bad_param_num NUMBER := -23325;

  --  The database is being quiesced.
  deferred_rpc_quiesce EXCEPTION;
  PRAGMA exception_init(deferred_rpc_quiesce, -23326);
  quiesce_num NUMBER := -23326;
  quiesce_msg VARCHAR(76) := 'the system is being quiesced.';

  --  Generic errors that are not important enough for specific exceptions
  --  string text will explain them further.  These are internal errors.
  --  message varies.
  dbms_defererror EXCEPTION;
  PRAGMA exception_init(dbms_defererror, -23305);
  deferror_num NUMBER := -23305;

  --  
  --    dbms_defer package detects mal-formed call (e.g. argument count
  --     miss-match).  Message varies.
  malformedcall EXCEPTION;
  PRAGMA  exception_init(malformedcall, -23304);  
  malformed_num NUMBER := -23304;

  --   generic exceptions that (user-written) deferred procedures 
  --   can raise to indicate
  --   that the remote update has failed because of data updates by concurrent 
  --   transactions.  A deferror table record will be created by the deferred 
  --    rpc executor
  updateconflict  EXCEPTION;
  PRAGMA  exception_init(updateconflict, -23303);
  conflict_num NUMBER := -23303;
  conflict_msg VARCHAR(76) := 'Remote update failed due to conflict.';

  --   generic exceptions that (user-written) deferred procedures 
  --   can raise to indicate 
  --   that the remote update has failed because communications failures
  --   so that a a deferror table record will not be created by the 
  --   deferred rpc 
  --   executor.
  commfailure  EXCEPTION;
  PRAGMA  exception_init(commfailure, -23302);
  commfail_num NUMBER := -23302;
  commfail_msg VARCHAR(76) := 
                         'Remote update failed due to communication failure';

  --   mixed use repcat determined destinations and non-repcat destinations
  --   in one transaction 
  mixeddest  EXCEPTION;
  PRAGMA  exception_init(mixeddest, -23301);
  mixeddest_num NUMBER := -23301;
  mixeddest_msg VARCHAR(76) := 
           'Destinations for transaction not consistently specified';

  --   parameter length exceed deferred rpc limits (2000 char/varchar2, 
  --   255 raw) in one transaction 
  parameterlength  EXCEPTION;
  PRAGMA  exception_init(parameterlength, -23323);
  paramlen_num NUMBER := -23323;
  paramlen_msg VARCHAR(76) := 'parameter length exceeds deferred rpc limits';

  --   deferred rpc execution is disabled
  executiondisabled  EXCEPTION;
  PRAGMA  exception_init(executiondisabled, -23354);
  executiondisabled_num NUMBER := -23354;
  paramlen_msg VARCHAR(76) := 'parameter length exceeds deferred rpc limits';
  ----------------------
  --  PROCEDURES
  --
  PROCEDURE commit_work(commit_work_comment IN VARCHAR2);
  --  Perform a transaction commit after checking for well-formed 
  --    deferred RPCs.
  --    Must be used instead of the commit work sql call for 
  --    transactions deferring RPCS.
  --    Updates the comment_comment and commit_scn fields in 
  --    the def$_txn table.
  --  Input parameters:
  --    commit_work_comment
  --      Up to fifty characters to describe the transaction 
  --        in the def$_txns
  --        table and system two-phase commit tables (this latter 
  --        once we figure out
  --        how to get it in.)  Comment is truncated to fifty characters.
  --  Exceptions
  --    ORA-23304 (malformedcall) if there is an defer_rpc_arg 
  --      call missing or defer_txn
  --      was not called for this transaction.
  --
  --
  --
  --  Transaction and call deferral procedures
  --    A deferred transaction consist of the following:
  --      Call to dbms_defer.transaction (this is optional, the first call to 
  --      dbms_defer.call will call transaction)
  --      one or more complete calls, each of which consists of 
  --        Call to dbms_defer.call
  --           zero of more calls (depending on arg_count in 
  --           dbms_defer.call) to dbms_defer.arg_*
  --      commit or call to commit_work
  -- 
  --  DESTINATION SPECIFICATION
  --  Destinations can be specified in several ways
  --  A) All deferred procedures are in repcat and the default list is
  --     NOT specified in the transaction call.
  --  OR
  --  B) destinations are specified without repcat using the following order 
  --     of precedence
  --   1) list specified in the nodes parameter to dbms_defer.call
  --   2) list specified in the nodes parameter to dbms_defer.transaction
  --   3) list specified in defdefaultdest table.
  --   The mixeddest exception is raised if an attempt to mix destinations
  --   modes is detected.
  --
  PROCEDURE transaction;
  PROCEDURE transaction(nodes      IN node_list_t);
  --  Mark a transaction as deferred (as containing deferred RPCs )
  --     This call is optional.  The first call to dbms_defer.call 
  --     in a transaction will call
  --     deftxn (with no arguments) if it has not been previously called.
  --     Input parameters are optional, and if they are not 
  --     specified the destination
  --     list is taken from the system defaults stored in the 
  --     def$_defaultdest table and
  --     maintained by the dbms_defer_sys.add_default_node and 
  --     dbms_defer_sys.delete_default_node calls
  --  Input parameters:
  --    nodes
  --      Table containing a list of nodes (dblink) to propagate the 
  --      deferred calls of the 
  --        transaction to.  Indexed from 1 until a NULL entry is
  --        found or NO_DATA_FOUND is raised.  
  --        Case insensitive comparison
  --        used for node lists.
  --        Use of this parameter overrides distribution lists as 
  --        specified in repcat.
  --  Exceptions
  --    ORA-23304 (malformedcall) if the previous transaction 
  --      not correctly formed 
  --      or terminated
  --    ORA-23319 Parameter value is not appropriate
  --    ORA-23352 Raised by dbms_defer.call if the node 
  --              list contains duplicates
  ----

  PROCEDURE call( schema_name  IN VARCHAR2,
                  package_name IN VARCHAR2,
                  proc_name    IN VARCHAR2,    
                  arg_count    IN NATURAL,
                  group_name   IN VARCHAR2 := '');

  PROCEDURE call( schema_name  IN VARCHAR2,
                  package_name IN VARCHAR2,
                  proc_name    IN VARCHAR2,
                  arg_count    IN NATURAL,
                  nodes        IN node_list_t);
  --  Defer a remote procedure call.  Automatically call 
  --    deftxn if this is the first
  --    call call of a transaction.
  --  Input parameters:
  --    schema_name
  --      Name of the schema containing the remote procedure.  For
  --      compatibility with future compile-time checking only string
  --      constants should be used.  
  --    package_name
  --      Name of the package containing the remote procedure.  For
  --      compatibility with future compile-time checking only string
  --      constants should be used.  
  --    proc_name
  --      Name of the remote procedure to call.  
  --        For compatibility with
  --        future syntactic integration
  --        and compile-time checking only string constants should be used.
  --    arg_count
  --       Number of parameters to the procedure.  This must 
  --       exactly match the number of
  --       defrpcarg_* calls immediately following the dbms_defer.call call.
  --    group_name
  --       Reserved for internal use
  --    nodes
  --      Optional table containing a list of nodes to propagate the 
  --      deferred call to.  
  --        Indexed from 1 until a NULL entry is
  --        found or NO_DATA_FOUND is raised.  
  --        Case insensitive comparison
  --        used for node lists.
  --      If not specified, the destination list is determined by the
  --      list passed to the transaction procedure, or the system defaults,
  --      Use of this parameter in any deferred call invalidate the use of
  --      the use of repcat to determine distribution lists in any
  --      calls for a transaction.
  --  Exceptions  -- 
  --  Exceptions
  --    ORA-23304 (malformedcall) if the previous call not 
  --      correctly formed (number of
  --      defrpcarg_* call not matched to arg_count).
  --    ORA-23319 Parameter value is not appropriate
  --    ORA-23352  If the destination list (specified by nodes or by a previous
  --              dbms_defer.transaction call contains a duplicate.
  ----

  PROCEDURE number_arg(arg IN nUMBER);
  --  Queue a number parameter value for a deferred call.
  --  Input parameter:
  --    arg 
  --      The number value of the parameter to the call 
  --        previously deferred with a 
  --        dbms_defer.call call.
  --  Exceptions: none.
  --------

  PROCEDURE date_arg(arg IN DATE);
  --  Queue a date parameter value for a deferred call.
  --  Input parameter:
  --    arg 
  --      The date value of the parameter to the call previously 
  --      deferred with a 
  --        dbms_defer.call call.
  --  Exceptions: none.
  --------
    
  PROCEDURE varchar2_arg(arg  IN VARCHAR2);
  --  Queue a varchar2 parameter value for a deferred call.
  --  Input parameter:
  --    arg 
  --      The varchar2 value of the parameter to the call 
  --        previously deferred with a 
  --        dbms_defer.call call. The length of arg is limited to 2000.
  --  Exceptions: 
  --    whatever error sql gives if arg exceeds 2000 characters.

  PROCEDURE char_arg(arg  IN CHAR);
  --  Queue a char parameter value for a deferred call.
  --  Input parameter:
  --    arg 
  --      The char value of the parameter to the call previously 
  --        deferred with a 
  --        dbms_defer.call call. The length of arg is limited to 2000.
  --  Exceptions: 
  --    whatever error sql gives if arg exceeds 2000 characters.

  ---------------------
  -- rowids can not be
  -- used on different nodes.  It might be reasonable to use a
  -- rid in a deferred call 
  -- to a local node, but be careful.
  PROCEDURE rowid_arg(arg IN ROWID);
  --  Queue a rowid parameter value for a deferred call.
  --  Input parameter:
  --    arg 
  --      The rowid value of the parameter to the call 
  --        previously deferred with a 
  --        dbms_defer.call call.
  --  Exceptions: 
  --    dbms_deferError
  --------

  -- The following calls will not be supported until dbms_sql 
  -- supports 
  -- 
  PROCEDURE raw_arg(arg IN raw);
  --  Queue a rowid parameter value for a deferred call.
  --  Input parameter:
  --    arg 
  --      The raw value of the parameter to the call 
  --        previously deferred with a 
  --        dbms_defer.call call.
  --  Exceptions: 
  --    dbms_deferError
  --------
  --------
END dbms_defer;
/
DROP PUBLIC SYNONYM dbms_defer
/
CREATE PUBLIC SYNONYM dbms_defer FOR dbms_defer
/

CREATE OR REPLACE PACKAGE dbms_defer_query AS
  -------------------
  --  OVERVIEW
  -- 
  -- This package permits querying the deferred RPC queue data that
  -- is not exposed through views.
  -- The following type declaration are used by get_call_args call.
  TYPE type_ary is table of number
	index by binary_integer;

  TYPE val_ary is table of varchar2(2000)
	index by binary_integer;

  FUNCTION get_arg_type(callno           IN  NUMBER,
                        deferred_tran_db IN  VARCHAR2,
                        arg_no           IN  NUMBER,
                        deferred_tran_id IN  VARCHAR2)
    RETURN NUMBER;
  -- Return type  of a deferred call parameter.
  -- Input parameters
  --  callno
  --    call identifier from the defCall view
  --  deferred_tran_db 
  --    database deferring call from the defCall view
  --  arg_no
  --    position of desired parameter in calls argument list
  --    parameter positions are 1..number of parameters in call
  --  deferred_tran_id
  --    deferred transaction id
  ----
  --  Result
  --    The type of the deferred rpc parameter.
  ------
  --  EXCEPTIONS
  --    NO_DATA_FOUND desired parameter value not found in the deferred rpc
  --    queue tables.
  ------
  FUNCTION get_number_arg(callno           IN  NUMBER,
                          deferred_tran_db IN  VARCHAR2,
                          arg_no           IN  NUMBER,
                          deferred_tran_id IN  VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;
  -- Return a deferred call parameter.
  -- Input parameters
  --  callno
  --    call identifier from the defCall view
  --  deferred_tran_db 
  --    database deferring call from the defCall view
  --  arg_no
  --    position of desired parameter in calls argument list
  --    parameter positions are 1..number of parameters in call
  --  deferred_tran_id
  --    deferred transaction id, defaults to one passed in get_arg_type
  ----
  --  Result
  --    The value of the parameter .
  ------
  --  EXCEPTIONS
  --    NO_DATA_FOUND desired parameter value not found in the deferred rpc
  --    queue tables.
  --    WRONG_TYPE if the desired parameter is not a number.
  -------
  FUNCTION get_varchar2_arg(callno           IN  NUMBER,
                            deferred_tran_db IN  VARCHAR2,
                            arg_no           IN  NUMBER,
                            deferred_tran_id IN  VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2;
  -- Return  a deferred call parameter.
  -- Input parameters
  --  callno
  --    call identifier from the defCall view
  --  deferred_tran_db 
  --    database deferring call from the defCall view
  --  arg_no
  --    position of desired parameter in calls argument list
  --    parameter positions are 1..number of parameters in call
  --  deferred_tran_id
  --    deferred transaction id, defaults to one passed in get_arg_type
  ----
  --  Result
  --    The value of the parameter .
  ------
  --  EXCEPTIONS
  --    NO_DATA_FOUND desired parameter value not found in the deferred rpc
  --    queue tables.
  --    WRONG_TYPE if the desired parameter is not a VARCHAR2.
  -------
  FUNCTION get_char_arg(callno           IN  NUMBER,
                        deferred_tran_db IN  VARCHAR2,
                        arg_no           IN  NUMBER,
                        deferred_tran_id IN  VARCHAR2 DEFAULT NULL)
    RETURN CHAR;
  -- Return type  of a deferred call parameter.
  -- Input parameters
  --  callno
  --    call identifier from the defCall view
  --  deferred_tran_db 
  --    database deferring call from the defCall view
  --  arg_no
  --    position of desired parameter in calls argument list
  --    parameter positions are 1..number of parameters in call
  --  deferred_tran_id
  --    deferred transaction id, defaults to one passed in get_arg_type
  ----
  --  Result
  --    The value of the parameter .
  ------
  --  EXCEPTIONS
  --    NO_DATA_FOUND desired parameter value not found in the deferred rpc
  --    queue tables.
  --    WRONG_TYPE if the desired parameter is not a char.
  -------
  FUNCTION get_date_arg(callno           IN  NUMBER,
                        deferred_tran_db IN  VARCHAR2,
                        arg_no           IN  NUMBER,
                        deferred_tran_id IN  VARCHAR2 DEFAULT NULL)
    RETURN DATE;
  -- Return  a deferred call parameter.
  -- Input parameters
  --  callno
  --    call identifier from the defCall view
  --  deferred_tran_db 
  --    database deferring call from the defCall view
  --  arg_no
  --    position of desired parameter in calls argument list
  --    parameter positions are 1..number of parameters in call
  --  deferred_tran_id
  --    deferred transaction id, defaults to one passed in get_arg_type
  ----
  --  Result
  --    The value of the parameter .
  ------
  --  EXCEPTIONS
  --    NO_DATA_FOUND desired parameter value not found in the deferred rpc
  --    queue tables.
  --    WRONG_TYPE if the desired parameter is not a date.
  -------
  FUNCTION get_raw_arg(callno           IN  NUMBER,
                        deferred_tran_db IN  VARCHAR2,
                        arg_no           IN  NUMBER,
                        deferred_tran_id IN  VARCHAR2 DEFAULT NULL)
    RETURN RAW;
  -- Return  a deferred call parameter.
  -- Input parameters
  --  callno
  --    call identifier from the defCall view
  --  deferred_tran_db 
  --    database deferring call from the defCall view
  --  arg_no
  --    position of desired parameter in calls argument list
  --    parameter positions are 1..number of parameters in call
  --  deferred_tran_id
  --    deferred transaction id, defaults to one passed in get_arg_type
  ----
  --  Result
  --    The value of the parameter .
  ------
  --  EXCEPTIONS
  --    NO_DATA_FOUND desired parameter value not found in the deferred rpc
  --    queue tables.
  --    WRONG_TYPE if the desired parameter is not a raw.
  -------
  FUNCTION get_rowid_arg(callno           IN  NUMBER,
                         deferred_tran_db IN  VARCHAR2,
                         arg_no           IN  NUMBER,
                         deferred_tran_id IN  VARCHAR2 DEFAULT NULL)
    RETURN ROWID;
  -- Return  a deferred call parameter.
  -- Input parameters
  --  callno
  --    call identifier from the defCall view
  --  deferred_tran_db 
  --    database deferring call from the defCall view
  --  arg_no
  --    position of desired parameter in calls argument list
  --    parameter positions are 1..number of parameters in call
  --  deferred_tran_id
  --    deferred transaction id, defaults to one passed in get_arg_type
  ----
  --  Result
  --    The value of the parameter .
  ------
  --  EXCEPTIONS
  --    NO_DATA_FOUND desired parameter value not found in the deferred rpc
  --    queue tables.
  --    WRONG_TYPE if the desired parameter is not a rowid.
  -------
  PROCEDURE get_call_args
       (
	callno IN NUMBER,		-- deferred call number
	startarg IN NUMBER := 1,	 -- starting argument to fetch
	argcnt IN NUMBER,		-- number of arguments in the call
	argsize IN NUMBER,	 	-- maximum size of returned argument
	tran_db IN VARCHAR2,	        -- origin database
	tran_id IN VARCHAR2,	        -- transaction id
	date_fmt IN VARCHAR2,	        -- date format
	types OUT TYPE_ARY,		-- output array for types 
                                        -- of the arguments
	vals OUT VAL_ARY		-- output array of the values 
       );
  -- This procedure returns the text version of the various arguments for the
  -- given call. The exceptions returned by this function are the same ones
  -- as returned by get_arg_type and get _xxx_arg.

END dbms_defer_query;
/
DROP PUBLIC SYNONYM dbms_defer_query
/
CREATE PUBLIC SYNONYM dbms_defer_query FOR dbms_defer_query
/
GRANT EXECUTE on dbms_defer_query TO DBA
/

CREATE OR REPLACE PACKAGE dbms_defer_sys AS
  -------------------
  --  OVERVIEW
  -- 
  -- This package is the system administrator  interface to a replicated 
  -- transactional deferred remote
  -- procedure call facility.  Administrators and replication 
  -- deamons can execute
  -- transactions queued for remote nodes using this facility 
  -- and administrators
  -- can control the nodes to which remote calls are destined.
  ------------
  --  SECURITY
  --
  -- By default, this package is owned by user SYS and 
  -- execution should be granted
  -- only to administrators and deamons that perform 
  -- replication administration and
  -- execute deferred transactions.  See the security considerations for 
  -- the dbms_defer package for related considerations.
  -------------
  --  EXCEPTIONS
  --
  --  Parameter type does not match actual type. Message varies.
  crt_err_err EXCEPTION;
  PRAGMA exception_init(crt_err_err, -23324);
  crt_err_num NUMBER := -23324;
  crt_err_msg  VARCHAR(76) := 'Error creating deferror entry: ';

  --  Replication is not linked as an option
  norepoption EXCEPTION;
  PRAGMA exception_init(norepoption, -2094);   
  norepoption_num NUMBER := -2094;

  -------------
  --  CONSTANTS
  --  size of long buffer used for packing parameters
  parm_buffer_size CONSTANT NUMBER := 4096;
  default_alert_name CONSTANT VARCHAR2(30) := 'ORA$DEFER_ALERT';
  --  PROCEDURES

  -- manage default replication node lists

  PROCEDURE add_default_dest(dblink IN VARCHAR2);
  --  Add a node to the default list for replication targets.
  --  Input parameters
  --    dblink
  --      name of the node (dblink) to add tRo the default list.
  --  Exceptions 
  --    ORA-23352
  --     dblink is already in the default list.
  ----------
 
  PROCEDURE delete_default_dest(dblink IN VARCHAR2);
  --  Delete a node from the default list for replication targets
  --  Input parameters
  --    dblink
  --      name of the node (dblink) to delete from the default list.
  --      Operation is a no-op if dblink is not in the list.
  --  Exceptions
  --    none.
  -----------------

  PROCEDURE execute(destination       IN VARCHAR2,
                    stop_on_error     IN BOOLEAN := FALSE,
                    transaction_count IN BINARY_INTEGER := 0,
                    execution_seconds IN BINARY_INTEGER := 0,
		    execute_as_user   IN BOOLEAN := FALSE,
                    delay_seconds     IN NATURAL := 0,
                    batch_size        IN NATURAL := 0);

  --  Execute transactions queued for destination_node. stop_on_error 
  --  determines whether processing of subsequent transaction continues
  --  after an error is detected. 
  --  deftrandest (and defcalldest if appropriate) entries 
  --  for the successfully executed transactions are deleted and if there
  --  are no other references, the defcall and deftran entries are deleted.
  --
  --  Input Parameters:
  --    destination
  --      node (dblink) at which to execute 
  --      deferred transaction.  Case
  --      insensitive comparisons used.
  --    stop_on_error
  --      If TRUE, execution of queued transactions will 
  --      alway stop when an error is
  --      encountered, leaving unattempted transaction in 
  --      the queue.  If FALSE,
  --      execution continues except when errors that appear 
  --      to mean that node is 
  --      unavailable are encountered, it which case execution 
  --      always stops, leaving
  --      unattempted transactions queued.
  --    transaction_count
  --      If positive, at most this many transactions will be executed.
  --    executions_seconds
  --      If positive, execution will stop after completions of the
  --      last transaction after this many seconds of executions.
  --    execute_as_user
  --      IF TRUE the execution of deferred RPCs is authenticated at the remote
  --      system using the authentication context of the session user.  If 
  --      FALSE the execution of deferred RPCs is authenticated at the remote
  --      system using the authentication contexts of the users that originally
  --      queued the deferred RPCs (indicated in the origin_user column of
  --      the deftran table). 
  --    delay_seconds
  --      If positive, the routine will sleep for this many seconds before
  --      returning when it finds no deferred RPCs queued for the destination
  --      Non-zero values can redue execution overhead compared to calling
  --      dbms_defer_sys.execute from a tight loop.
  --    batch_size
  --      The number of deferred rpc calls should be executed before 
  --      committing deferred transactions.  If batch_size is 0 a commit will
  --      occur after each deferred transaction.  If batch_size is greater than
  --      zero a commit will occur when the total number of deferred calls
  --      executed exceeds batch_size and a complete transaction has been
  --      executed.
  --
  --  Exceptions
  --    Raises the last exception encountered before execution 
  --    stops because of 
  --    an exception.
  ----------------

  PROCEDURE execute_error(deferred_tran_id IN VARCHAR2,
                          deferred_tran_db IN VARCHAR2,
                          destination      IN VARCHAR2);

  --  (Re)Execute transactions that previously encountered conflicts. 
  --  Execution stops when any error is encountered.  If some input is null,
  --  then each transaction is committed as it completes. If exactly one 
  --  transaction is specified, then the transactions is not committed.
  --  Upon successful execution, transactions are removed for deferror, and if
  --  there are no other references, entries are deleted from 
  --  defcall and deftran.
  --  Input Parameters:
  --    deferred_tran_db
  --      node (global_name) originating or copying transaction that 
  --      encountered an error. If null, then 
  --      deferred_transaction_id must be null and  all 
  --      transactions from all destinations matching destination 
  --      (as specified) are re-executed.
  --           
  --    deferred_tran_id
  --      The identifier of the transaction to be reexecuted.
  --      If null then if all transactions in deferror matching 
  --      deferred transaction id and destination (as specified) 
  --      are re-executed.
  --    destination
  --      dblink that transaction was originally destined to.
  --      Must not be null.
  --  Exceptions
  --    Raises an exception if destination is null or if
  --    deferred_tran_db is null and deferred_tran_id is not null.
  --    Raises the last exception encountered before execution 
  --    stops because of an exception.
  ----------------

  PROCEDURE delete_tran(deferred_tran_id IN VARCHAR2,
                        deferred_tran_db IN VARCHAR2,
                        destination      IN VARCHAR2);
  --  Delete transactions from  queues. Deletes deftrandest (and defcalldest
  --  entries if appropriate.  If there are not other references,
  --  deftran and defcall entries are deleted.
  --  Input Parameters:
  --    destination
  --      dblink for which transaction(s) are to be removed from queues.
  --      If null, the transaction specified by the other parameters are 
  --      deleted from queues for all destinations.
  --    deferred_tran_id
  --      The identifier of the transaction to be deleted
  --      If null then all transactions matching destination and 
  --      deferred_tran_db are deleted.
  --    deferred_tran_db
  --      The identifier of the origin/copying node for the transaction to be
  --      deleted. If null then all transactions matching destination and 
  --      deferred_tran_id are deleted.
  --  Exceptions
  --    tid and/or node not found.
  ---------------
  PROCEDURE delete_error(deferred_tran_id IN VARCHAR2,
                         deferred_tran_db IN VARCHAR2,
                         destination      IN VARCHAR2);

  --  Delete transactions from  deferror table. If there are 
  --  not other references,
  --  deftran and defcall entries are deleted.
  --  Input Parameters:
  --    destination
  --      destination for which transaction(s) are to be removed from 
  --      deferror.
  --      If null, the transaction specified by the other parameters are 
  --      deleted from deferror for all destinations.
  --    deferred_tran_id
  --      The identifier of the transaction to be deleted
  --      If null then all transactions matching destination and 
  --      deferred_tran_db are deleted.
  --    deferred_tran_db
  --      The identifier of the origin/copying node for the transaction to be
  --      deleted. If null then all transaction matching destination and 
  --      deferred_tran_id are deleted.
  --  Exceptions
  --    tid and/or node not found.
  ---------------

  PROCEDURE copy(deferred_tran_id  IN VARCHAR2,
                 deferred_tran_db  IN VARCHAR2,
                 destination_list  IN dbms_defer.node_list_t,
                 destination_count IN BINARY_INTEGER);
  --  Copy as deferred transaction assign it and new 
  --  deferre_tranid , deferred_tran_db, 
  -- executions_order, setting destination_list to 'D'
  --  and retaining the other fields from the source 
  -- transaction).  The new transaction has destinations as 
  -- specified by destination_list and destination_count.
  --    destination_node
  --      the Origin_
  --      Case  insensitive comparisons used.
  --    tid
  --      The identifier of the transaction to be added to the node's queue.
  --  Exceptions
  --    tid  not found.
  ---------------
  PROCEDURE create_error(deferred_tran_id  IN VARCHAR2,
                         deferred_tran_db  IN VARCHAR2,
                         destination       IN VARCHAR2,
                         call              IN NUMBER,
                         error_number      IN NUMBER,
                         error_message     IN VARCHAR2);
                       
  --  Create deferror table record for a transaction at 
  --  some remote node. Delete deftrandest (and defcalldest, 
  --  if appropriate) entries for transaction at the
  --  node executing create_error. If there are not other
  --  references, delete deftran and defcall entries.
  --  Input Parameters:
  --    destination
  --      dblink to node at which to create deferror table 
  --      entry.
  --    deferred_tran_id
  --      The identifier of the transaction.
  --    deferred_tran_db 
  --      database identifier component of the transaction.
  --    call 
  --      The identifier of the conflicting call.  If not null should be
  --      a call within the transaction
  --    error_number
  --      Error number for conflicts table record.
  --    error_message
  --      Error message for conflicts table record.
  --      Truncated to 200 characters.
  --
  --  Exceptions
  --------------
  PROCEDURE schedule_execution(dblink         IN VARCHAR2,
                               interval       IN VARCHAR2,
                               next_date      IN DATE,
                               reset          IN BOOLEAN default FALSE,
                               stop_on_error  IN BOOLEAN := NULL,
                               transaction_count IN BINARY_INTEGER := NULL,
                               execution_seconds IN BINARY_INTEGER := NULL,
            		       execute_as_user   IN BOOLEAN := NULL,
                               delay_seconds     IN NATURAL := NULL,
                               batch_size        IN NATURAL := NULL);
  -- Insert or update a defschedule entry and signal the background process.
  -- this procedure does a commit;
  -- Input Parameters:
  --   dblink
  --     Queue name to schedule execution for;
  --   interval
  --     If non-null then DefSchedule.interval for dblink is set to this 
  --     value. If null and the DefSchedule entry for dblink exists, 
  --     the value of DefSchedule.interval is not modified. If 
  --     null and the DefSchedule entry 
  --     for dblink does not exist, then the DefSchedule entry for 
  --     dblink is created with a null interval value.
  --   next_date
  --     If non-null then DefSchedule.next_date for dblink is set to this 
  --     value. If null and the DefSchedule entry for dblink exists, the value
  --     of DefSchedule.next_date is not modified. If null and 
  --     the DefSchedule entry 
  --     for dblink does not exist, then the DefSchedule entry 
  --     for dblink is created with a null next_date value.
  --   reset
  --     If TRUE then last_txn_count, last_error, and last_msg are nulled.
  --    stop_on_error
  --    transaction_count
  --    execution_seconds
  --    execute_as_user
  --    delay_seconds
  --    batch_size
  --      If non-null, these parameters are passed to the
  --      dbms_defer_sys.execute call that is scheduled for execution by
  --      this call.
  ---------
  PROCEDURE unschedule_execution(dblink         IN VARCHAR2);
  --  Delete a defschedule entry. Signal to background process to stop 
  --  servicing this queue.
  -- Input Parameters:
  --   dblink
  --     Queue name to stop automatic execution of.
  -- Exceptions:
  --   NO_DATA_FOUND
  --     no entry for dblink in DefSchedule.

  ---------
  FUNCTION disabled(destination IN VARCHAR2) RETURN BOOLEAN;
  -- Effects:  Returns TRUE if the deferred RPC queue is disabled for
  --   the given destination.  Else returns FALSE.
  --   Raises the following exceptions:
  --       no_data_found:
  --          if the "destination" does not appear in defschedule.
  --

  ---------
  PROCEDURE set_disabled(destination IN VARCHAR2,
                         disabled    IN BOOLEAN := TRUE);
  -- Effects:  If "disabled" is TRUE, disable propagation to the given
  --   "destination." All future invocations of dbms_defer_sys.execute
  --   will not be able to push the deferred RPC queue to this
  --   destination until it is enabled.  This function has no effect
  --   on a session already pushing the queue to the given
  --   destination.  This function has no effect on sessions appending
  --   to the queue with dbms_defer.
  --     If "disabled" is FALSE, enable propagation to the given "destination."
  --   Although this does not push the queue, it permits future invocations
  --   of dbms_defer_sys.execute to push the queue to the given destination.
  --     In either case, a COMMIT is required for this to take effect in other
  --   sessions.
  --
  --   Raises the following exceptions:
  --      no_data_found:
  --        if the "destination" does not appear in defschedule.
  --


END dbms_defer_sys;
/
DROP PUBLIC SYNONYM dbms_defer_sys
/
CREATE PUBLIC SYNONYM dbms_defer_sys FOR dbms_defer_sys
/
GRANT EXECUTE ON dbms_defer_sys TO DBA
/
