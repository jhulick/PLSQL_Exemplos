REM debug2.sql
REM Version 1.0, last updated 5/15/97
REM This is the second version of the Debug package, which uses DBMS_OUTPUT,
REM as described in Chapter 14 of _Oracle8 PL/SQL Programming_ by Scott Urman.

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
  PROCEDURE Debug(p_Description IN VARCHAR2,
                  p_Value IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(p_Description || ': ' || p_Value);
  END Debug;

  PROCEDURE Reset IS
  BEGIN
       /* Disable the buffer first, then enable it with the
       maximum size. Since DISABLE purges the buffer, this
       ensures that we will have a fresh buffer whenever
       Reset is called. */
    DBMS_OUTPUT.DISABLE;
    DBMS_OUTPUT.ENABLE(1000000);
  END Reset;
BEGIN /* Package initialization code */
  Reset;
END Debug;
/
