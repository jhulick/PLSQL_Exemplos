Rem 
Rem $Header: dbmssnap.sql,v 1.14 1994/12/27 15:37:37 adowning Exp $ 
Rem  
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      dbmssnap.sql - utilities for snapshots
Rem    DESCRIPTION
Rem      See below
Rem    RETURNS
Rem
Rem  MODIFIED
Rem     adowning   12/23/94 -  merge changes from branch 1.13.720.1
Rem     boki       12/21/94 -  merge changes from branch 1.6.710.10
Rem     boki       12/08/94 -  add new formal parameter to refresh()
Rem     adowning   11/11/94 -  merge changes from branch 1.6.710.9
Rem     adowning   10/24/94 -  add comments to refresh
Rem     adowning   10/11/94 -  make i_am_a_refresh a function
Rem     rjenkins   02/17/94 -  adding defaults
Rem     adowning   02/02/94 -  split file into public / private binary files
Rem     rjenkins   01/13/94 -  adding rollback seg to refresh groups
Rem     rjenkins   12/21/93 -  supporting import/export
Rem     rjenkins   12/17/93 -  creating job queue
Rem     rjenkins   11/02/93 -  adding explicit language flag to parse
Rem     rjenkins   10/22/93 -  work even if name_tokenize does not work
Rem     rjenkins   10/14/93 -  merge changes from branch k7010101
Rem     rjenkins   10/12/93 -  moving comma_to_table to dbmsutil
Rem     rjenkins   10/11/93 -  change default refresh method to NULL
Rem     rjenkins   08/30/93 -  push deferred txn queues before refresh
Rem     rjenkins   08/17/93 -  adding clear_refresh
Rem     rjenkins   07/22/93 -  stop hardcoding foo, bar
Rem     rjenkins   07/06/93 -  adding i_am_a_refresh
Rem     ghallmar   05/02/93 -  add multi-table consistent refresh 
Rem     mmoore     10/02/92 -  change pls_integer to binary_integer 
Rem     rjenkins   06/02/92 -  changing comment types 
Rem     rjenkins   02/12/92 -  more snapshot changes 
Rem     rjenkins   11/25/91 -  Creation 
-----------------------------------------------------------------------

Rem
Rem  Headers
Rem

CREATE OR REPLACE PACKAGE dbms_snapshot IS

  ------------
  --  OVERVIEW
  --
  --  These routines allow the user to refresh snapshots and purge logs.

  ------------------------------------------------
  --  SUMMARY OF SERVICES PROVIDED BY THIS PACKAGE
  --
  --  purge_log		- purge log of unnecessary rows
  --  refresh		- refresh a given snapshot
  --  refresh_all	- refresh all snapshots that are due
  --			    to be refreshed
  --  drop_snapshot	- drop a given snapshot
  --  set_up		- prepare master site to refresh a snapshot
  --  wrap_up		- record a refresh at the master site
  --  get_log_age	- find oldest date entry in log
  --  testing		- test snapshots (currently null)
  --  I_am_a_refresh    - flag used to let triggers identify refreshes


  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  PROCEDURE purge_log( master VARCHAR2, num BINARY_INTEGER DEFAULT 1, 
                       flag VARCHAR2 DEFAULT 'NOP' );

  PROCEDURE refresh( list                 IN VARCHAR2,
                     method               IN VARCHAR2 DEFAULT NULL,
                     rollback_seg         IN VARCHAR2 DEFAULT NULL,
                     push_deferred_rpc    IN BOOLEAN DEFAULT TRUE,
                     refresh_after_errors IN BOOLEAN DEFAULT FALSE,
		     execute_as_user      IN BOOLEAN DEFAULT FALSE );

  --  -----------------------------------------------------------------------
  --  Transaction consistent refresh of an array of snapshots
  --
  --  The snapshots are refreshed atomically and consistently. 
  --  Atomically: all snapshots are refreshed or none are.
  --  Consistently: all integrity constraints that hold among master tables 
  --    will hold among the snapshot tables. 
  --  The "method" string (not required) should contain a letter for each 
  --    of the snapshots in the array according to the following codes:
  --    '?' -- use fast refresh when possible
  --    'F' -- use fast refresh or raise an error if not possible
  --    'C' -- perform a complete refresh, copying the entire snapshot from
  --           the master
  --    The default method for refreshing a snapshot is the method stored for
  --      that snapshot in the data dictionary.
  --  The maximum number of snapshots that can be consistently refreshed is 100.
  --   Rollback_seg is the name of the rollback segment to use while 
  --     refreshing snapshots.
  --   Push_deferred_rpc pushes changes from an updatable snapshot to its 
  --     associated master before refreshing the snapshot.  Otherwise, these
  --     changes may appear to be temporarily lost.
  --   Refresh_after_errors, if TRUE, will allow the refresh to proceed
  --     even if there are outstanding conflicts logged in the DefError
  --     table for the snapshot's master.
  --   Execute_as_user
  --      IF TRUE the execution of deferred RPCs is authenticated at the 
  --      remote system using the authentication context of the session user.  If 
  --      FALSE the execution of deferred RPCs is authenticated at the remote system 
  --      using the authentication contexts of the users that originally queued the 
  --      deferred RPCs (indicated in the origin_user column of the deftran table). 
  -- 
  PROCEDURE refresh( tab                  IN OUT dbms_utility.uncl_array,
                     method               IN VARCHAR2 DEFAULT NULL,
                     rollback_seg         IN VARCHAR2 DEFAULT NULL,
                     push_deferred_rpc    IN BOOLEAN DEFAULT TRUE,
                     refresh_after_errors IN BOOLEAN DEFAULT FALSE,
		     execute_as_user      IN BOOLEAN DEFAULT FALSE );
  --  External

  PROCEDURE refresh_all;
  --  External, refresh all snapshots due to be refreshed
  --  Requires ALTER ANY SNAPSHOT privilege

  PROCEDURE set_i_am_a_refresh(value IN  BOOLEAN);
  --  External

  FUNCTION i_am_a_refresh RETURN BOOLEAN;
  --  External

  PROCEDURE drop_snapshot( mowner VARCHAR2, master VARCHAR2, snapshot date);
  --  Internal

  PROCEDURE set_up( mowner VARCHAR2, master VARCHAR2, log IN OUT VARCHAR2,
	            snapshot IN OUT date, snaptime IN OUT date);
  --  Internal

  PROCEDURE wrap_up( mowner VARCHAR2, master VARCHAR2, 
                     sshot date, stime date);
  --  Internal

  PROCEDURE get_log_age( oldest IN OUT date, mow VARCHAR2, mas VARCHAR2);
  --  Internal

  PROCEDURE testing;

END dbms_snapshot;
/

grant execute on dbms_snapshot to public
/
drop public synonym dbms_snapshot
/
create public synonym dbms_snapshot for dbms_snapshot
/

CREATE OR REPLACE PACKAGE dbms_refresh IS
  -- dbms_refresh is the interface for administering refresh groups.

  -- PARAMETERS:
  -- NAME is of the form 'foo' or 'user.foo' or '"USER"."FOO"'.  
  --   The logged-in user is used as a default.
  -- LIST is a comma-separated list of objects to be refreshed, such as
  --     'foo, scott.bar ,"SCOTT"."BLUE"'.  The default user is the owner
  --     of the refresh group.
  -- TAB  is a PL/SQL table of objects to be refreshed, starting with 1
  --   and filling every number until an entry is NULL, with every entry
  --   formatted the same way as NAME.  The default user is the owner
  --   of the refresh group.
  -- NEXT_DATE is the date for the refresh group to first be refreshed.
  --   See dbmsjobq.sql .  If there is no current job, the default interval
  --   will be 'null' and the job will delete itself after refreshing the
  --   group at NEXT_DATE.
  -- INTERVAL is used to determine the next NEXT_DATE.  See dbmsjobq.sql .
  --   If there is no current job, NEXT_DATE will default to null and the
  --   job will not run until you manually set NEXT_DATE to something else
  --   or manually refresh the group.
  -- IMPLICIT_DESTROY means to delete the refresh group when the last item
  --   is subtracted from it.  The value is stored with the group definition.
  --   Empty groups can be created with IMPLICIT_DESTROY set.

  aaspriv   BINARY_INTEGER;
  -- Privilege number for ALTER ANY SNAPSHOT

  PROCEDURE make    ( name      IN VARCHAR2,
                      list      IN VARCHAR2,
                      next_date IN DATE,
                      interval  IN VARCHAR2,
                      implicit_destroy    IN BOOLEAN DEFAULT FALSE,
                      lax       IN BOOLEAN DEFAULT FALSE,
                      job       IN BINARY_INTEGER DEFAULT 0,
                      rollback_seg  IN VARCHAR2 DEFAULT NULL,
                      push_deferred_rpc    IN BOOLEAN DEFAULT TRUE,
                      refresh_after_errors IN BOOLEAN DEFAULT FALSE );
  PROCEDURE make    ( name      IN VARCHAR2,
                      tab       IN dbms_utility.uncl_array,
                      next_date IN DATE,
                      interval  IN VARCHAR2,
                      implicit_destroy    IN BOOLEAN DEFAULT FALSE,
                      lax       IN BOOLEAN DEFAULT FALSE,
                      job       IN BINARY_INTEGER DEFAULT 0,
                      rollback_seg  IN VARCHAR2 DEFAULT NULL,
                      push_deferred_rpc    IN BOOLEAN DEFAULT TRUE,
                      refresh_after_errors IN BOOLEAN DEFAULT FALSE );
  -- MAKE a new refresh group.

  PROCEDURE add     ( name      IN VARCHAR2,
                      list      IN VARCHAR2,
                      lax       IN BOOLEAN  DEFAULT FALSE );
  PROCEDURE add     ( name      IN VARCHAR2,
                      tab       IN dbms_utility.uncl_array,
                      lax       IN BOOLEAN  DEFAULT FALSE );
  -- ADD some refreshable objects to a refresh group.

  PROCEDURE subtract( name      IN VARCHAR2,
                      list      IN VARCHAR2,
                      lax       IN BOOLEAN  DEFAULT FALSE );
  PROCEDURE subtract( name      IN VARCHAR2,
                      tab       IN dbms_utility.uncl_array,
                      lax       IN BOOLEAN  DEFAULT FALSE );
  -- SUBTRACT some refreshable objects from a refresh group.

  PROCEDURE destroy ( name      IN VARCHAR2 );
  -- DESTROY a refresh group, make it cease to exist.

  PROCEDURE change( name                 IN VARCHAR2,
                    next_date            IN DATE DEFAULT NULL,
                    interval             IN VARCHAR2 DEFAULT NULL,
                    implicit_destroy     IN BOOLEAN  DEFAULT NULL,
                    rollback_seg         IN VARCHAR2 DEFAULT NULL,
                    push_deferred_rpc    IN BOOLEAN DEFAULT NULL,
                    refresh_after_errors IN BOOLEAN DEFAULT NULL);
  -- Change any changeable pieces of the job that does the refresh

  PROCEDURE refresh ( name      IN VARCHAR2 );
  -- Atomically, consistently refresh all objects in a refresh group now.
  -- Clear the BROKEN flag for the job if the refresh succeeds

  PROCEDURE user_export( rg#  IN BINARY_INTEGER,
                         mycall IN OUT VARCHAR2);
  -- Produce the text of a call for recreating the given group

  PROCEDURE user_export_child( myowner IN     VARCHAR2,
                               myname  IN     VARCHAR2,
                               mytype  IN     VARCHAR2,
                               mycall  IN OUT VARCHAR2);
  -- Produce the text of a call for recreating the given group item
END dbms_refresh;
/

GRANT EXECUTE ON dbms_refresh TO PUBLIC
/
DROP PUBLIC SYNONYM dbms_refresh
/
CREATE PUBLIC SYNONYM dbms_refresh FOR dbms_refresh
/

