rem 
rem $Header: dbmspexp.sql,v 1.3 1994/04/08 08:45:15 dsdaniel Exp $ 
rem 
Rem  Copyright (c) 1992 by Oracle Corporation 
Rem    NAME
Rem      dbmspexp.sql - procedural extesnions to export
Rem    DESCRIPTION
Rem      This file defines a pl/sql package containing 
Rem      functions that are called by export to dynamically link in 
Rem      pl/sql logic in the export process.  These routines 
Rem      interpret the expact$ table.
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     dsdaniel   04/07/94 -  merge changes from branch 1.1.710.1
Rem     adowning   03/29/94 -  merge changes from branch 1.1.710.2
Rem     adowning   02/02/94 -  split file into public / private binary files
Rem     dsdaniel   01/31/94 -  Branch_for_patch
Rem     dsdaniel   01/31/94 -  Branch_for_patch
Rem     dsdaniel   12/29/93 -  Creation

CREATE OR REPLACE PACKAGE DBMS_EXPORT_EXTENSION AS 
------------------------------------------------------------
-- Overview
--
-- This package implemts PL/SQL extensions to Export as described by the
-- ...
---------------------------------------------------------------------
-- SECURITY
-- This package is owned by SYS,  and is  granted to PUBLIC.
-- The procedures dynamically called by the package are called using
-- The parse_as_user option
------------------------------------------------------------------------------
-- EXCEPTIONS
-- 
   unExecutedActions EXCEPTION;
-- A function was not called with the same parameters until it returned NULL.
-- This indicates an internal error in EXPORT.
-- CONSTANTS
-- 
--   Function codes for the expact$ table.
-- 
  func_pre_table   CONSTANT NUMBER := 1;     /* execute before loading table */
  func_post_tables CONSTANT NUMBER := 2; /* execute after loading all tables */
  func_pre_row     CONSTANT NUMBER := 3;       /* execute before loading row */
  func_post_row    CONSTANT NUMBER := 4;        /* execute after loading row */
  func_row         CONSTANT NUMBER := 5;   /* execute in leiw of loading row */
------------------------------------------------------------------------------
-- PROCEDURES AND FUNCTIONS
  FUNCTION pre_table(table_schema IN VARCHAR2,
                     table_name   IN VARCHAR2)
    RETURN VARCHAR2;
-- execute pre_table functions from the expact$ table, for a specific table
-- Input Parameters:
--   table_schema 
--     The schema of the table being exported.
--   table_name
--     The name for the table beign exported.
-- Result:
--   A string containg a procedure invocation to be put in the export stream.
--   If non-null, this procedure should be called again (immediatly) for the
--   same table.  If NULL, there are no additional pre_table calls to 
--   be exported to the
--   stream for this table and function.
-- Exceptions:
--   unExecutedActions
--   Any error encountered during executing of the action

  FUNCTION post_tables(table_schema IN VARCHAR2,
                       table_name   IN VARCHAR2)
    RETURN VARCHAR2;
-- execute post_tables functions from the expact$ table, for a specific table
-- Input Parameters:
--   table_schema 
--     The schema of the table being exported.
--   table_name
--     The name for the table beign exported.
-- Result:
--   A string containg a procedure invocation to be put in the export stream.
--   If non-null, this procedure should be called again (immediatly) for the
--   same table.  
--  If NULL, there are no additional post_tables calls to be exported to the
--   stream for this table.
-- Exceptions:
--   unExecutedActions
--   Any error encountered during executing of the action
----------------------------------------------------------------------------
-- ROW FUNCTIONS WILL BE ADDED IN THE FUTURE
----------------------------------------------------------------------------
END DBMS_EXPORT_EXTENSION;
/

GRANT execute ON sys.dbms_export_extension to public; 

