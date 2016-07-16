rem 
rem $Header: dbmssql.sql,v 1.9 1995/01/18 11:06:49 hjakobss Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      dbmssql.sql - DBMS package for dynamic SQL
Rem   DESCRIPTION
Rem     This package provides a means to use dynamic SQL to access
Rem     the database.
Rem   NOTES
Rem     The procedural option is needed to use this package.
Rem     This package must be created under SYS.
Rem     The operations provided by this package are performed under the current
Rem     calling user, not under the package owner SYS. The old file name
Rem     for this package was dbms_sql.sql.
Rem
Rem     
Rem   MODIFIED     (MM/DD/YY)
Rem     hjakobss   01/18/95 -  merge changes from branch 1.8.720.2
Rem     adowning   03/29/94 -  merge changes from branch 1.4.710.4
Rem     adowning   02/02/94 -  split file into public / private binary files
Rem     dsdaniel   01/18/94 -  merge changes from branch 1.4.710.3
Rem     hjakobss   01/06/94 -  merge changes from branch 1.4.710.2
Rem     dsdaniel   12/27/93 -  create dbms_sys_sql package for parse as user
Rem     hjakobss   12/10/93 -  support array parse and mlslabel
Rem     hjakobss   12/09/93 -  merge changes from branch 1.4.710.1
Rem     hjakobss   10/26/93 -  appease marketing
Rem     hjakobss   07/06/93 -  add new datatypes
Rem     hjakobss   06/17/93 -  add get_rpi_cursor
Rem     hjakobss   05/10/93 -  Merge from 7.0.14 
Rem     hjakobss   05/07/93 -  change procedure names 
Rem     hjakobss   04/02/93 -  Branch_for_the_patch 
Rem     hjakobss   01/28/93 -  Add new features 
Rem     jwijaya    01/11/93 -  merge changes from branch 1.1.312.1 
Rem     jwijaya    01/11/93 -  bug 139792 
Rem     jwijaya    10/21/92 -  Creation 

REM  ************************************************************
REM  THIS PACKAGE MUST NOT BE MODIFIED BY THE CUSTOMER.  DOING SO
REM  COULD CAUSE INTERNAL ERRORS AND CORRUPTIONS IN THE RDBMS.
REM  ************************************************************

REM  ***************************************
REM  THIS PACKAGE MUST BE CREATED UNDER SYS.
REM  ***************************************

REM  ***********************************************************
REM  PROCEDURES AND FUNCTIONS IN THIS PACKAGE ARE EXECUTED UNDER
REM  THE CURRENT CALLING USER, NOT UNDER THE PACKAGE OWNER SYS.
REM  ***********************************************************


create or replace package dbms_sql is

  ------------
  --  OVERVIEW
  --
  --  This package provides a means to use dynamic SQL to access the database.
  --

  -------------------------
  --  RULES AND LIMITATIONS
  --
  --  Bind variables of a SQL statement are identified by their names.
  --  When binding a value to a bind variable, the string identifying
  --  the bind variable in the statement may optionally contain the
  --  leading colon. For example, if the parsed SQL statement is
  --  "SELECT ENAME FROM EMP WHERE SAL > :X", on binding the variable
  --  to a value, it can be identified using either of the strings ':X'
  --  and 'X'.
  --
  --  Columns of the row being selected in a SELECT statement are identified
  --  by their relative positions (1, 2, 3, ...) as they appear on the select
  --  list from left to right.
  --  
  --  Privileges are associated with the caller of the procedures/functions
  --  in this package as follows:
  --    If the caller is an anonymous PL/SQL block, the procedures/functions
  --    are run using the privileges of the current user.
  --    If the caller is a stored procedure, the procedures/functions are run
  --    using the privileges of the owner of the stored procedure.
  --
  --  WARNING: Using the package to dynamically execute DDL statements can 
  --  results in the program hanging. For example, a call to a procedure in a 
  --  package will result in the package being locked until the execution 
  --  returns to the user side. Any operation that results in a conflicting 
  --  lock, such as dynamically trying to drop the package, before the first 
  --  lock is released will result in a hang. 
  --
  --  The flow of procedure calls will typically look like this:
  --
  --                      -----------
  --                    | open_cursor |
  --                      -----------
  --                           |
  --                           |
  --                           v
  --                         -----
  --          ------------>| parse |
  --         |               -----
  --         |                 |
  --         |                 |---------
  --         |                 v         |
  --         |           --------------  |
  --         |-------->| bind_variable | |
  --         |     ^     -------------   |
  --         |     |           |         |
  --         |      -----------|         |
  --         |                 |<--------
  --         |                 v
  --         |               query?---------- yes ---------
  --         |                 |                           |
  --         |                no                           |
  --         |                 |                           |
  --         |                 v                           v
  --         |              -------                  -------------
  --         |----------->| execute |            ->| define_column |
  --         |              -------             |    -------------
  --         |                 |------------    |          |
  --         |                 |            |    ----------|
  --         |                 v            |              v
  --         |           --------------     |           -------
  --         |       ->| variable_value |   |  ------>| execute |
  --         |      |    --------------     | |         -------
  --         |      |          |            | |            |
  --         |       ----------|            | |            |
  --         |                 |            | |            v
  --         |                 |            | |        ----------
  --         |                 |<-----------  |----->| fetch_rows |
  --         |                 |              |        ----------
  --         |                 |              |            |
  --         |                 |              |            v
  --         |                 |              |    --------------------
  --         |                 |              |  | column_value         |
  --         |                 |              |  | variable_value       |
  --         |                 |              |    ---------------------
  --         |                 |              |            |
  --         |                 |<--------------------------
  --         |                 |
  --          -----------------|
  --                           |
  --                           v
  --                      ------------
  --                    | close_cursor |
  --                      ------------ 
  --
   ---------------

  -------------
  --  CONSTANTS
  --
  v6 constant integer := 0;
  native constant integer := 1;
  v7 constant integer := 2;
  --
  --------------
  --  EXCEPTIONS
  --
  inconsistent_type exception;
    pragma exception_init(inconsistent_type, -6562);
  --  This exception is raised by procedure "column_value" or
  --  "variable_value" if the type of the given out argument where
  --  to put the requested value is different from the type of the value.

  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  function open_cursor return integer;
  --  Open a new cursor.
  --  When no longer needed, this cursor MUST BE CLOSED explicitly by
  --  calling "close_cursor".
  --  Return value:
  --    Cursor id number of the new cursor.
  --
  function is_open(c in integer) return boolean;
  --  Return TRUE is the given cursor is currently open.
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor to check.
  --  Return value:
  --    TRUE if the given cursor is open,
  --    FALSE if it is not.
  --
  procedure close_cursor(c in out integer);
  --  Close the given cursor.
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor to close.
  --  Output parameters:
  --    c
  --      Will be nulled.
  --
  procedure parse(c in integer, statement in varchar2, 
                  language_flag in integer);
  --  Parse the given statement in the given cursor. NOTE THAT PARSING AND
  --  EXECUTING DDL STATEMENTS CAN CAUSE HANGS! 
  --  Currently, the deferred parsing feature of the Oracle  Call Interface
  --  is not used. As a result, statements are parsed immediately. In addition,
  --  DDL statements are executed immediately when parsed. However, 
  --  the behavior may
  --  change in the future so that the actual parsing (and execution of DDL
  --  statement) do not occur until the cursor is executed with "execute".
  --  DO NOT RELY ON THE CURRENT TIMING OF THE ACTUAL PARSING!
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor in where to parse the statement.
  --    statement
  --      Statement to parse.
  --    language_flag
  --      Specifies behavior for statement. Valid values are v6, v7 and NATIVE.
  --      v6 and v7 specifies behavior according to Version 6 and ORACLE7,
  --      respectively. NATIVE specifies behavior according to the version
  --      of the database the program is connected to.
  --    
  procedure bind_variable(c in integer, name in varchar2, value in number);
  procedure bind_variable(c in integer, name in varchar2, 
                          value in varchar2);
  procedure bind_variable(c in integer, name in varchar2, value in varchar2,
                          out_value_size in integer);
  procedure bind_variable(c in integer, name in varchar2, value in date);
  procedure bind_variable(c in integer, name in varchar2, 
                          value in mlslabel);
  procedure bind_variable_char(c in integer, name in varchar2,
                               value in char);
  procedure bind_variable_char(c in integer, name in varchar2,
                               value in char, out_value_size in integer);
  procedure bind_variable_raw(c in integer, name in varchar2,
                              value in raw);
  procedure bind_variable_raw(c in integer, name in varchar2,
                              value in raw, out_value_size in integer);
  procedure bind_variable_rowid(c in integer, name in varchar2,
                              value in rowid);
  --  Bind the given value to the variable identified by its name
  --  in the parsed statement in the given cursor.
  --  If the variable is an in or in/out variable, the given bind value
  --  should be a valid one.  If the variable is an out variable, the
  --  given bind value is ignored.
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor to bind.
  --    name
  --      Name of the variable in the statement.
  --    value
  --      Value to bind to the variable in the cursor.
  --      If the variable is an out or in/out variable, its type is the same
  --      as the type of the value being passed in for this parameter.
  --    out_value_size
  --      Maximum expected out value size in bytes for the varchar2
  --      out or in/out variable.  If it is not given for the varchar2
  --      out or in/out variable, the size is the length of the current
  --      "value".
  --
  procedure define_column(c in integer, position in integer, column in number);
  procedure define_column(c in integer, position in integer, 
                          column in varchar2,
                          column_size in integer);
  procedure define_column(c in integer, position in integer, column in date);
  procedure define_column(c in integer, position in integer, 
                          column in mlslabel);
  procedure define_column_char(c in integer, position in integer,
                               column in char, column_size in integer);
  procedure define_column_raw(c in integer, position in integer, 
                              column in raw,
                              column_size in integer);
  procedure define_column_rowid(c in integer, position in integer,
                                column in rowid);
  --  Define a column to be selected from the given cursor; so this
  --  procedure is applicable only to SELECT cursors.
  --  The column being defined is identified by its relative position as
  --  it appears on the select list in the statement in the given cursor.
  --  The type of the column to be defined is the type of the value
  --  being passed in for parameter "column".
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor to define the row to be selected.
  --    position
  --      Position of the column in the row being defined.
  --    column
  --      Type of the value being passed in for this parameter is
  --      the type of the column to be defined.
  --    column_size
  --      Maximum expected size of the value in bytes for the
  --      varchar2 column.
  --
  function execute(c in integer) return integer;
  --  Execute the given cursor and return the number of rows processed
  --  (valid and meaningful only for INSERT, DELETE or UPDATE statements;
  --  for other types of statements, the return value is undefined and
  --  should be ignored).
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor to execute.
  --  Return value:
  --    Number of rows processed if the statement in the cursor is
  --    either an INSERT, DELETE or UPDATE statement or undefined otherwise.
  --
  function fetch_rows(c in integer) return integer;
  --  Fetch rows from the given cursor. The function tries to fetch a
  --  row. As long as "fetch_rows" is able to fetch a
  --  row, it can be called repeatedly to fetch additional rows. If no
  --  row was actually fetched, "fetch_rows"
  --  cannot be called to fetch additional rows.
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor to fetch.
  --  Return value:
  --    The number of rows actually fetched.
  --
  function execute_and_fetch(c in integer, exact in boolean default false) 
  return integer;
  --  Execute the given cursor and fetch rows. Gives the same functionality
  --  as a call to "execute" 
  --  followed by a call to "fetch_rows". However, this function can 
  --  potentially cut down on the number of message round-trips compared to
  --  calling "execute" and "fetch_rows" separately.
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor to execute and fetch.
  --    exact 
  --      Raise an exception if the number of rows matching the query 
  --      differs from one.
  --  Return value:
  --    The number of rows actually fetched.
  --    
  procedure column_value(c in integer, position in integer, value out number);
  procedure column_value(c in integer, position in integer, 
                         value out varchar2);
  procedure column_value(c in integer, position in integer, value out date);
  procedure column_value(c in integer, position in integer, 
                         value out mlslabel);
  procedure column_value_char(c in integer, position in integer,
                              value out char);
  procedure column_value_raw(c in integer, position in integer, value out raw);
  procedure column_value_rowid(c in integer, position in integer, 
                               value out rowid);
  procedure column_value(c in integer, position in integer, value out number,
                         column_error out number, actual_length out integer);
  procedure column_value(c in integer, position in integer, 
                         value out varchar2, column_error out number,
                         actual_length out integer);
  procedure column_value(c in integer, position in integer, value out date,
                         column_error out number, actual_length out integer);
  procedure column_value(c in integer, position in integer, 
                         value out mlslabel, column_error out number,
                         actual_length out integer);
  procedure column_value_char(c in integer, position in integer,
                              value out char, column_error out number, 
                              actual_length out integer);
  procedure column_value_raw(c in integer, position in integer, value out raw,
                             column_error out number, 
                             actual_length out integer);
  procedure column_value_rowid(c in integer, position in integer, 
                             value out rowid, column_error out number,
                             actual_length out integer);
  --  Get a value of the column identified by the given position
  --  and the given cursor. This procedure is used to access the data 
  --  retrieved by "fetch_rows".
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor from which to get the value.
  --    position
  --      Position of the column of which to get the value.
  --  Output parameters:
  --    value
  --      Value of the column.  
  --    column_error
  --      Any column error code associated with "value".
  --    actual_length
  --      The actual length of "value" in the table before any truncation
  --      during the fetch.
  --  Exceptions:
  --    inconsistent_type (ORA-06562)
  --      Raised if the type of the given out parameter "value" is
  --      different from the actual type of the value.  This type was
  --      the given type when the column was defined by calling procedure
  --      "define_column".
  --
  procedure variable_value(c in integer, name in varchar2,
                           value out number);
  procedure variable_value(c in integer, name in varchar2,
                           value out varchar2);
  procedure variable_value(c in integer, name in varchar2,
                           value out date);
  procedure variable_value(c in integer, name in varchar2,
                           value out mlslabel);
  procedure variable_value_char(c in integer, name in varchar2,
                                value out char);
  procedure variable_value_raw(c in integer, name in varchar2,
                               value out raw);
  procedure variable_value_rowid(c in integer, name in varchar2,
                                 value out rowid);
  --  Get a value or values of the variable identified by the name
  --  and the given cursor.  
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor from which to get the value.
  --    name
  --      Name of the variable of which to get the value.
  --  Output parameters:
  --    value
  --      Value of the variable.  
  --  Exceptions:
  --    inconsistent_type (ORA-06562)
  --      Raised if the type of the given out parameter "value" is
  --      different from the actual type of the value.  This type was
  --      the given type when the variable was bound by calling procedure
  --      "bind_variable".
  --
  function last_error_position return integer;
  function last_sql_function_code return integer;
  function last_row_count return integer;
  function last_row_id return rowid;
  --  Get various information for the last-operated cursor in the session.
  --  To ensure that the information relates to a particular cursor,
  --  the functions should be called after an operation on that cursor and
  --  before any other operation on any other cursor.
  --  Return value:
  --    last_error_position
  --      Relative position in the statement when the error occurs.
  --    last_sql_function_code
  --      SQL function code of the statement. See list in OCI manual.
  --    last_row_count
  --      Cumulative count of rows fetched.
  --    last_row_id
  --      Rowid of the last processed row.
  --
 ------------
  --  EXAMPLES
  --
  --  create or replace procedure copy(source in varchar2,
  --                                   destination in varchar2) is
  --    --  This procedure copies rows from a given source table to
  --        a given destination table assuming that both source and destination
  --    --  tables have the following columns:
  --    --    - ID of type NUMBER,
  --    --    - NAME of type VARCHAR2(30),
  --    --    - BIRTHDATE of type DATE.
  --    id number;
  --    name varchar2(30);
  --    birthdate date;
  --    source_cursor integer;
  --    destination_cursor integer;
  --    rows_processed integer;
  --  begin
  --    -- prepare a cursor to select from the source table
  --    source_cursor := dbms_sql.open_cursor;
  --    dbms_sql.parse(source_cursor,
  --                   'select id, name, birthdate from ' || source);
  --    dbms_sql.define_column(source_cursor, 1, id);
  --    dbms_sql.define_column(source_cursor, 2, name, 30);
  --    dbms_sql.define_column(source_cursor, 3, birthdate);
  --    rows_processed := dbms_sql.execute(source_cursor);
  --
  --    -- prepare a cursor to insert into the destination table
  --    destination_cursor := dbms_sql.open_cursor;
  --    dbms_sql.parse(destination_cursor,
  --                   'insert into ' || destination ||
  --                   ' values (:id, :name, :birthdate)');
  --
  --    -- fetch a row from the source table and
  --    -- insert it into the destination table
  --    loop
  --      if dbms_sql.fetch_rows(source_cursor)>0 then
  --        -- get column values of the row
  --        dbms_sql.column_value(source_cursor, 1, id);
  --        dbms_sql.column_value(source_cursor, 2, name);
  --        dbms_sql.column_value(source_cursor, 3, birthdate);
  --        -- bind the row into the cursor which insert
  --        -- into the destination table
  --        dbms_sql.bind_variable(destination_cursor, 'id', id);
  --        dbms_sql.bind_variable(destination_cursor, 'name', name);
  --        dbms_sql.bind_variable(destination_cursor, 'birthdate', birthdate);
  --        rows_processed := dbms_sql.execute(destination_cursor);
  --      else
  --        -- no more row to copy
  --        exit;
  --      end if;
  --    end loop;
  --
  --    -- commit and close all cursors
  --    commit;
  --    dbms_sql.close_cursor(source_cursor);
  --    dbms_sql.close_cursor(destination_cursor);
  --  exception
  --    when others then
  --      if dbms_sql.is_open(source_cursor) then
  --        dbms_sql.close_cursor(source_cursor);
  --      end if;
  --      if dbms_sql.is_open(destination_cursor) then
  --        dbms_sql.close_cursor(destination_cursor);
  --      end if;
  --      raise;
  --  end;
  --
  procedure column_value_long(c in integer, position in integer, 
                              length in integer, offset in integer,
                              value out varchar2, value_length out integer);
  --  Get (part of) the value of a long column.
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor from which to get the value.
  --    position
  --      Position of the column of which to get the value.
  --    length
  --      Number of bytes of the long value to fetch.
  --    offset
  --      Offset into the long field for start of fetch. 
  --  Output parameters:
  --    value
  --      Value of the column as a varchar2.
  --    value_length
  --      The number of bytes actually returned in value.
  --
  procedure define_column_long(c in integer, position in integer);
  --  Define a column to be selected from the given cursor; so this
  --  procedure is applicable only to SELECT cursors.
  --  The column being defined is identified by its relative position as
  --  it appears on the select list in the statement in the given cursor.
  --  The type of the column to be defined is the type LONG.
  --  Input parameters:
  --    c
  --      Cursor id number of the cursor to define the row to be selected.
  --    position
  --      Position of the column in the row being defined.
  --


end;
/

drop public synonym dbms_sql
/
create public synonym dbms_sql for sys.dbms_sql
/
 
grant execute on dbms_sql to public
/
