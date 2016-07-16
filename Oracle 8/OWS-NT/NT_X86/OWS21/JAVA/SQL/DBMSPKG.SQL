Rem
Rem  Copyright (c) 1996 by Oracle Corporation. All rights reserved. 
Rem    NAME
Rem      dbmspkg.sql - describe server-side packages
Rem    DESCRIPTION
Rem      Given a stored package, list the procedures defined in the package.
Rem      Given a procedure, return a description of the arguments required
Rem      to call that procedure.
Rem    RETURNS
Rem 
Rem    NOTES
Rem      1. The procedural option is needed to use this facility.
Rem      2. This package is derived from dbms_describe package.
Rem      3. This package should be created by user SYS.
Rem      4. Use dbpkins.sql and dbpkdins.sql to install and deinstall
Rem         this package.
Rem    MODIFIED   (MM/DD/YY)
Rem     rpang      01/27/96 -  Creation

REM ********************************************************************
REM THIS PACKAGE MUST NOT BE MODIFIED BY THE CUSTOMER.  DOING SO
REM COULD CAUSE INTERNAL ERRORS AND SECURITY VIOLATIONS IN THE
REM RDBMS.  SPECIFICALLY, THE PSD* ROUTINES MUST NOT BE CALLED
REM DIRECTLY BY ANY CLIENT AND MUST REMAIN PRIVATE TO THE PACKAGE BODY.
REM ********************************************************************
create or replace package dbms_package is

  ------------
  --  OVERVIEW
  --
  -- This package is used to list procedures defined in a package and to
  -- describe the arguments of a stored procedure.  To count list the
  -- the procedures, the client specifies the name of the package.  To
  -- describe the procedure, the client specifies the package name,
  -- procedure name and the overload number, and describe returns 
  -- a set of indexed tables with the results.

  --------
  --  USES
  --
  -- The primary client of this package is pl2java (PL/SQL package to
  -- Java class converter).

  ---------------
  --  LIMITATIONS
  --
  --  Currently describes of remote objects are not supported.
  -- 

  ------------
  --  SECURITY
  --
  -- Describe is available to PUBLIC and performs it's own
  -- security checking based on the object being described.

  -----------------------
  --  TYPES AND CONSTANTS
  --
  type varchar2_table is table of varchar2(30) index by binary_integer;
  -- Indexed table type which is used to return the argument names.

  type number_table   is table of number       index by binary_integer;
  -- Indexed table type which is used to return various argument fields.

  ------------
  --  EXAMPLES
  --
  --  External service interface
  ------------------------------
  --
  --   EXAMPLE :
  --
  --   Client provides -
  --
  --   object_name - SCOTT.ACCOUNTING.ACCOUNT_UPDATE
  --   total_elements - 100
  --   
  --   ACCOUNT_UPDATE is an overloaded function in package ACCOUNTING
  --   with specification :
  --
  --     type number_table is table of number index by binary_integer
  --     table account (account_no number, person_id number,
  --                    balance number(7,2))
  --     table person  (person_id number(4), person_nm varchar2(10))
  --
  --     function ACCOUNT_UPDATE (account number, 
  --       person person%rowtype, amounts number_table,
  --       trans_date date) return account.balance%type;
  --
  --     function ACCOUNT_UPDATE (account number, 
  --       person person%rowtype, amounts number_table,
  --       trans_no number) return account.balance%type;
  --
  --
  --   Values returned -
  --
  --   position   argument  level  datatype length prec scale rad
  --   ----------------------------------------------------------
  --
  --   First function (overload number 0):
  --
  --          0                0   NUMBER      7    2     0    0
  --          1   ACCOUNT      0   NUMBER     22    0     0    0
  --          2   PERSON       0   RECORD
  --          2     PERSON_ID  1   NUMBER      4    0     0    0
  --          2     PERSON_NM  1   VARCHAR2   10
  --          3   AMOUNTS      0   TABLE
  --          3                1   NUMBER     22    0     0    0
  --          4   TRANS_NO     0   NUMBER     22    0     0    0
  --
  --   Second function (overload number 1):
  --
  --          0                0   NUMBER      7    2     0    0
  --          1   ACCOUNT      0   NUMBER     22    0     0    0
  --          2   PERSON       0   RECORD
  --          2    PERSON_ID   1   NUMBER      4    0     0    0
  --          2    PERSON_NM   1   VARCHAR2   10
  --          3   AMOUNTS      0   TABLE
  --          3                1   NUMBER     22    0     0    0
  --          4   TRANS_DATE   0   DATE
  --

  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  --
  -------------------------------------------------------------------------
  function count_procedures (
      package_name	in	varchar2
  ) return number;

  -------------------------------------------------------------------------
  procedure list_procedures(
      package_name	in	varchar2,
      procedure_count	out	number,
      procedure_names	out	varchar2_table,
      overload_numbers	out	number_table
  );

  -------------------------------------------------------------------------
  function count_arguments (
      package_name	in	varchar2,
      procedure_name	in	varchar2,
      overload_number	in	number
    ) return number;

  -------------------------------------------------------------------------
  procedure describe_procedure (package_name in varchar2,
    procedure_name in varchar2, overload_number in number,
    argument_count out number, position out number_table,
    level out number_table, argument_name out varchar2_table,
    datatype out number_table, default_value out number_table,
    in_out out number_table, length out number_table,
    precision out number_table, scale out number_table,
    radix out number_table, spare out number_table);
  --  
  --  Describe pl/sql object with the given name.  Returns the arguments
  --    ordered by position.
  --  Input parameters:
  --    package_name
  --      The name of package. If the procedure to desribe does not belong
  --      to any package, pass in NULL.
  --    procedure_name
  --      The name of the procedure/
  --    overload_number
  --      The overload number to distinguish overload procedures. 0 if
  --      the procedure is not overloaded.
  --  Output parameters:
  --    position
  --       Position of the argument in the parameter list beginning with 1.
  --       Position 0 indicates a function return value.
  --    level
  --       If the argument is a composite type (like record), this
  --       parameter returns the level of datatype.  See example
  --       section for a usage example.
  --    argument_name
  --       The name of the argument.
  --    datatype
  --       Oracle datatype of the parameter. These are:
  --           0 - This row is a placeholder for a procedure with
  --               no arguments.
  --           1 - VARCHAR2
  --           2 - NUMBER
  --           3 - NATIVE INTEGER (for PL/SQL's BINARY_INTEGER)
  --           8 - LONG
  --          11 - ROWID
  --          12 - DATE
  --          23 - RAW
  --          24 - LONG RAW
  --          96 - CHAR (ANSI FIXED CHAR)
  --         106 - MLSLABEL
  --         250 - PL/SQL RECORD (see "Notes:" below)
  --         251 - PL/SQL TABLE
  --         252 - PL/SQL BOOLEAN (see "Notes:" below)
  --    default_value
  --       1 if the parameter has a default value.  0, otherwise.
  --    in_out
  --       0 = IN param, 1 = OUT param, 2 = IN/OUT param
  --    length
  --       The data length of the argument.  For string types, length is
  --       the "N" in CHAR/VARCHAR2(N);  N is today bytes ON THE SERVER
  --       SIDE (for multi-byte it may differ on the client side) and 
  --       may someday be the number of characters rather than bytes.
  --    precision
  --       Precision of the argument (if the datatype is number).
  --    scale
  --       Scale of the argument (if the datatype is number).
  --    radix
  --       Radix of the argument (if the datatype is number).
  --    spare
  --       Reserved for future functionality.
  --  Exceptions:
  --    ORA-20001 - The package does not exist.
  --    ORA-20002 - The procedure/function does not exist within the package.
  --  Notes:
  --    There is currently no way from a 3gl to directly bind to an
  --    argument of type 'record' or 'boolean'.  For booleans, there are
  --    the following work-arounds.  Assume function F returns a boolean, G
  --    is a procedure with one IN boolean argument, and H is a procedure
  --    which has one OUT boolean argument. 
  --    Then you can execute these functions, binding in DTYINTs (native
  --    integer) as follows, where 0=>FALSE and 1=>TRUE:
  --
  --      begin :dtyint_bind_var := to_number(f); end;
  --
  --      begin g(to_boolean(:dtyint_bind_var)); end;
  -- 
  --      declare b boolean; begin h(b); if b then :dtyint_bind_var := 1;
  --        else :dtyint_bind_var := 0; end if; end;
  --
  --    Access to procedures with arguments of type 'record' would require 
  --    writting a wrapper similar to that in the 3rd example above (see
  --    funciton H).
end dbms_package;
/
drop public synonym dbms_package
/
create public synonym dbms_package for sys.dbms_package
/
grant execute on dbms_package to public
/
