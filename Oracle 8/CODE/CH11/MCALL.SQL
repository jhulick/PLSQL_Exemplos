REM mcall.sql
REM Version 1.0, last updated 8/8/97
REM This block demonstrates how to call object methods, as described in
REM Chapter 11 of _Oracle8 PL/SQL Programming_ by Scott Urman.

SET SERVEROUTPUT on
DECLARE
  v_Student1 StudentObj := StudentObj(10020, 'Chuck', 'Choltry', NULL, 0);
  v_Student2 StudentObj := StudentObj(10021, 'Denise', 'Davenport', NULL, 0);
BEGIN
  -- Change the major of both students.
  v_Student1.ChangeMajor('Economics');
  v_Student2.ChangeMajor('Computer Science');

  -- Print out Student1's name.  Note that there are no parenthesis in the
  -- call.
  DBMS_OUTPUT.PUT_LINE(v_Student1.FormattedName);

  -- Print out Student2's name.  This call has empty parenthesis.
  DBMS_OUTPUT.PUT_LINE(v_Student2.FormattedName());
END;
/


