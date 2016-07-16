REM debug1.sql
REM Version 1.0, last updated 5/14/97
REM This is the first version of the Debug package, which inserts into a
REM debugging table, as described in Chapter 8 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PACKAGE Debug AS
  /* First version of the debug package. This package works
     by inserting into the debug_table table. In order to see
     the output, select from debug_table in SQL*Plus with:
 SELECT debug_str FROM debug_table ORDER BY linecount; */

  /* This is the main debug procedure. p_Description will be
     concatenated with p_Value, and inserted into debug_table. */
  PROCEDURE Debug(p_Description IN VARCHAR2, p_Value IN VARCHAR2);

  /* Resets the Debug environment. Reset is called when the
     package is instantiated for the first time, and should be
     called to delete the contents of debug_table for a new
     session. */
  PROCEDURE Reset;
END Debug;
/

CREATE OR REPLACE PACKAGE BODY Debug AS
  /* v_LineCount is used to order the rows in debug_table. */
  v_LineCount NUMBER;

  PROCEDURE Debug(p_Description IN VARCHAR2, p_Value IN VARCHAR2) IS
  BEGIN
    INSERT INTO debug_table (linecount, debug_str)
      VALUES (v_LineCount, p_Description || ': ' || p_Value);
    COMMIT;
    v_LineCount := v_LineCount + 1;
  END Debug;

  PROCEDURE Reset IS
  BEGIN
    v_LineCount := 1;
    DELETE FROM debug_table;
  END Reset;

BEGIN /* Package initialization code */
  Reset;
END Debug;
/
