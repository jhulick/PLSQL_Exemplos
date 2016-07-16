rem
rem $Header: dbmsgen.sql,v 1.10 1995/08/24 15:52:24 hasun Exp $ 
rem
Rem  Copyright (c) 1993 by Oracle Corporation 
Rem    NAME
Rem     dbmsgen.sql - Replication code generators.
Rem          
Rem    DESCRIPTION
Rem     Routines to generate shadow tables, triggers, and packages for
Rem     table replication.
Rem     Routines to generate wrappers for replication of standalone procedure
Rem     invocations, and packaged procedure invocations.
Rem     Routines which support generated replication code.  
Rem    
Rem    RETURNS
Rem     None
Rem     
Rem    NOTES
Rem      The procedural option is needed to use this facility.
Rem
Rem      This package is installed by sys (connect internal).
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     hasun      08/17/95 -  Add better quiesce check for all sync objects
Rem     hasun      06/01/95 -  merge changes from branch 1.4.720.3
Rem     hasun      04/20/95 -  Move package spec of dbms_defergen to prvtgen.sq
Rem     hasun      03/13/95 -  Fix checkin problems from last revision
Rem     ldoo       01/24/95 -  Modify trigger generator for Object Groups
Rem     jstamos    12/23/94 -  merge all changes from 7.2
Rem     jstamos    11/11/94 -  merge changes from branch 1.1.710.7
Rem     adowning   10/13/94 -  merge rev 1.1.710.4
Rem     adowning   09/21/94 -  improved comments
Rem     ldoo       08/18/94 -  Changed to use columns in the column group
Rem                            instead of parameter columns in the if
Rem                            ignore_discard_flag then section of user funcs.
Rem     adowning   08/10/94 -  Move dbms_maint_gen to prvt from dbms
Rem     ldoo       07/19/94 -  Took out FLOAT as a valid column datatype.
Rem     ldoo       06/23/94 -  Added automatic conflict resolution.
Rem     ldoo       05/09/94 -  Changed the generated trigger by replacing
Rem                            dbms_defer arg calls with dbms_reputil arg
Rem                            calls.  Hence reduce size and enhance speed.
Rem                            Added arg call procedures in dbms_reputil pkg.
Rem     ldoo       03/02/94 -  The argument$.type for ROWID is 69 not 11.
Rem                         -  Default for generate_wrapper_package.procedure_
Rem                            prefix should be NULL.
Rem                         -  Proper error message for attempt to wrap func.
Rem     ldoo       02/25/94 -  Fixed plsql parser bug workaround.
Rem                         -  Do not validate generate_trigger.package_name.
Rem     ldoo       02/18/94 -  Skip LONG and LONG RAW columns in row/col repl.
Rem                         -  Fixed hanging is_dest_node_provided function.
Rem     ldoo       02/17/94 -  Workaround plsql parser bug by adding () to
Rem                            every ten AND clauses in the generated package.
Rem     ldoo       01/21/94 -  Fixed to support mixed-case object names.
Rem     ldoo       01/18/94 -  Added 2 more in parameters to 
Rem                              generate_wrapper_package.
Rem                            Use array parsing.
Rem                            Removed commit statement.
Rem                            Replaced some functions with shared ones.
Rem     ldoo       12/17/93 -  Fixed bug about having extra ');' for
Rem                              column-level replication.
Rem                            Fixed bug about not preserving user-assigned
Rem                              package_name and trigger_name.  
Rem                            Uppercased 'p', '$rp', 't' and '$rt'.
Rem                            Validated IN parameter values.
Rem                            Defaulted USER if output_table is not prefixed
Rem                              with schema name.
Rem                            Double quoted column names in generated trigger.
Rem                            Modified already_exists() to use dba views. 
Rem                            Loop until generated package/trigger name is
Rem                              unique.
Rem     ldoo       10/18/93 -  Eliminated IN OUT parameters.  Supports Remote-
Rem                            Only, Synchronous, and Mixed Replications. 
Rem     dsdaniel   09/01/93 -  split into multiple packages, merged in dbmsrepu
Rem     ldoo       08/25/93 -  Coded to the 8/20 version of spec.
Rem     bsouder    08/13/93 -  minor beautification, corrected dbms_snapshot
Rem                            call
Rem     celsbern   08/13/93 -  added comments
Rem     ldoo	   08/13/93 -  Creation to RDBMS spec.

CREATE OR REPLACE PACKAGE dbms_reputil AS

  ------------
  --  OVERVIEW
  --
  --  This package is referenced only by the generated code.

  -------------------
  -- GLOBAL VARIABLES
  --
  replication_is_on BOOLEAN;  -- If false, do not forward/defer the update.
  from_remote BOOLEAN;        -- If false, the update is local.
  global_name VARCHAR2(128);  -- The global name of the local database.

  ---------------------------
  -- PROCEDURES AND FUNCTIONS
  --
  PROCEDURE replication_on;
  -- Turn on replication.

  PROCEDURE replication_off;
  -- Turn off replication.

  --
  -- Automatic conflict resolution logic.
  --
  PROCEDURE recursion_on;
  -- Keep track of the number of recursion.  

  PROCEDURE recursion_off;
  -- The number of recursion is initialized to zero.

  PROCEDURE rep_begin;
  -- Initialization at the beginning of each rep_delete, rep_insert, and 
  -- rep_update.

  PROCEDURE rep_end;
  -- Clean up at the end of each rep_delete, rep_insert, and rep_update.

  FUNCTION get_constraint_name(errmsg IN VARCHAR2)
    RETURN VARCHAR2;
  -- Return the name of the uniqueness contraint in the ORA error message. 

  FUNCTION minimum(new                 IN  NUMBER,
                   cur                 IN  NUMBER,
                   ignore_discard_flag OUT BOOLEAN)
    RETURN BOOLEAN;
  -- If new > cur, then ignore_discard_flag is TRUE; otherwise it is FALSE.
  -- Return FALSE if any input parameter is null; otherwise return TRUE.

  FUNCTION minimum(new                 IN  VARCHAR2,
                   cur                 IN  VARCHAR2,
                   ignore_discard_flag OUT BOOLEAN)
    RETURN BOOLEAN;
  -- If new > cur, then ignore_discard_flag is TRUE; otherwise it is FALSE.
  -- Return FALSE if any input parameter is null; otherwise return TRUE.

  FUNCTION minimum(new                 IN  DATE,
                   cur                 IN  DATE,
                   ignore_discard_flag OUT BOOLEAN)
    RETURN BOOLEAN;
  -- If new > cur, then ignore_discard_flag is TRUE; otherwise it is FALSE.
  -- Return FALSE if any input parameter is null; otherwise return TRUE.

  FUNCTION maximum(new                 IN  NUMBER,
                   cur                 IN  NUMBER,
                   ignore_discard_flag OUT BOOLEAN)
    RETURN BOOLEAN;
  -- If new < cur, then ignore_discard_flag is TRUE; otherwise it is FALSE.
  -- Return FALSE if any input parameter is null; otherwise return TRUE.

  FUNCTION maximum(new                 IN  VARCHAR2,
                   cur                 IN  VARCHAR2,
                   ignore_discard_flag OUT BOOLEAN)
    RETURN BOOLEAN;
  -- If new < cur, then ignore_discard_flag is TRUE; otherwise it is FALSE.
  -- Return FALSE if any input parameter is null; otherwise return TRUE.

  FUNCTION maximum(new                 IN  DATE,
                   cur                 IN  DATE,
                   ignore_discard_flag OUT BOOLEAN)
    RETURN BOOLEAN;
  -- If new < cur, then ignore_discard_flag is TRUE; otherwise it is FALSE.
  -- Return FALSE if any input parameter is null; otherwise return TRUE.

  FUNCTION average(new                 IN OUT NUMBER,
                   cur                 IN     NUMBER,
                   ignore_discard_flag OUT    BOOLEAN)
    RETURN BOOLEAN;
  -- Output new as the average of new + old.
  -- Ignore_discard_flag is always FALSE.
  -- Return FALSE if any input parameter is null; otherwise return TRUE.

  FUNCTION additive(old                 IN     NUMBER,
                    new                 IN OUT NUMBER,
                    cur                 IN     NUMBER,
                    ignore_discard_flag OUT    BOOLEAN)
    RETURN BOOLEAN;
  -- Output new as cur + (new - old).  Ignore_discard_flag is always FALSE.
  -- Return FALSE if any input parameter is null; otherwise return TRUE.

  FUNCTION discard(ignore_discard_flag OUT BOOLEAN)
    RETURN BOOLEAN;
  -- Ignore_discard_flag is always TRUE.
  -- Always return TRUE.

  FUNCTION overwrite(ignore_discard_flag OUT BOOLEAN)
    RETURN BOOLEAN;
  -- Ignore_discard_flag is always FALSE.
  -- Always return TRUE.

  FUNCTION append_site_name(new                 IN OUT VARCHAR2,
                            str                 IN     VARCHAR2,
                            max_len             IN     NUMBER,
                            ignore_discard_flag OUT    BOOLEAN)
    RETURN BOOLEAN;
  -- Output new with str appended to it. Ignore_discard_flag is always FALSE.
  -- Return FALSE if any input parameter is null or the length of str plus one
  -- is greater than max_len; otherwise return TRUE.

  FUNCTION append_sequence(new                 IN OUT VARCHAR2,
                           max_len             IN     NUMBER,
                           ignore_discard_flag OUT    BOOLEAN)
    RETURN BOOLEAN;
  -- Output new with a sequence generated number appended to it.
  -- Ignore_discard_flag is always FALSE.  
  -- Return FALSE if any input parameter is null or the length of the generated
  -- number is greater than max_len; otherwise return TRUE.

  --
  -- A hack to make the trigger smaller and run faster.
  --
  PROCEDURE call(sname     IN VARCHAR2,
                 pkgname   IN VARCHAR2,
                 arg_count IN NATURAL,
                 gname     IN VARCHAR2,
                 flag      IN CHAR);
  -- Cover routine for dbms_defer.call.
  -- Use flag to tell if it is an insert, an update or a delete.
  -- Valid flag values are: 'I', 'D', and 'U'.
  --
  PROCEDURE number_arg(old  IN NUMBER,
                       new  IN NUMBER,
                       flag IN CHAR);
  -- Cover routine for dbms_defer.number_arg.  Using flag to determine whether
  -- to defer old or new or both.  Valid flag values are: 'I', 'D', and 'U'.

  PROCEDURE date_arg(old  IN DATE,
                     new  IN DATE,
                     flag IN CHAR);
  -- Cover routine for dbms_defer.date_arg.  Using flag to determine whether
  -- to defer old or new or both.  Valid flag values are: 'I', 'D', and 'U'.

  PROCEDURE varchar2_arg(old  IN VARCHAR2,
                         new  IN VARCHAR2,
                         flag IN CHAR);
  -- Cover routine for dbms_defer.varchar2_arg. Using flag to determine whether
  -- to defer old or new or both.  Valid flag values are: 'I', 'D', and 'U'.

  PROCEDURE char_arg(old  IN CHAR,
                     new  IN CHAR,
                     flag IN CHAR);
  -- Cover routine for dbms_defer.char_arg.  Using flag to determine whether
  -- to defer old or new or both.  Valid flag values are: 'I', 'D', and 'U'.

  PROCEDURE rowid_arg(old  IN ROWID,
                      new  IN ROWID,
                      flag IN CHAR);
  -- Cover routine for dbms_defer.rowid_arg.  Using flag to determine whether
  -- to defer old or new or both.  Valid flag values are: 'I', 'D', and 'U'.

  PROCEDURE raw_arg(old  IN RAW,
                    new  IN RAW,
                    flag IN CHAR);
  -- Cover routine for dbms_defer.raw_arg.  Using flag to determine whether
  -- to defer old or new or both.  Valid flag values are: 'I', 'D', and 'U'.

  PROCEDURE enter_statistics(sname             IN VARCHAR2,
                             oname             IN VARCHAR2,
                             conflict_type     IN VARCHAR2,
                             reference_name    IN VARCHAR2,
                             method_name       IN VARCHAR2,
                             function_name     IN VARCHAR2,
                             priority_group    IN VARCHAR2,
                             primary_key_value IN VARCHAR2,
                             resolved_date     IN DATE default SYSDATE);
  -- Record that the given conflict has been resolved with the given
  -- resolution.
  -- Input parameters:
  --  sname The name of the schema containing the table to be replicated.
  --  oname The name of the table being replicated.
  --  conflict_type The type of conflict.  Valid values are: `UPDATE',
  --    `UNIQUENESS', and `DELETE'.
  --  reference_name If the conflict type is 'DELETE', enter the replicated
  --    table name here.  If the conflict type is `UPDATE', enter the column
  --    group name here.  If the conflict type is `UNIQUE CONSTRAINT', enter
  --    the unique constraint name here.
  --  method_name The conflict resolution method.
  --  function_name If the method is 'USER FUNCTION', enter the user
  --    resolution function name here.
  --  priority_group If the method is `PRIORITY GROUP', enter the name of
  --    priority group used for resolving the conflict.
  --  primary_key_value The primary key value for the row whose conflict is
  --    being resolved.  
  --  resolved_date The date at which the conflict is resolved.  

  PROCEDURE ensure_normal_status(canon_gname IN VARCHAR2);
  --- Raise exception quiesced_num (-23311) if the status of the object group
  --- is not normal.
END dbms_reputil;
/

DROP PUBLIC SYNONYM dbms_reputil;

CREATE PUBLIC SYNONYM dbms_reputil FOR dbms_reputil;

GRANT EXECUTE ON dbms_reputil TO PUBLIC;


