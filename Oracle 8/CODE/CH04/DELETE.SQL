REM delete.sql
REM Version 1.0, last updated 4/9/97
REM This block illustrates the use of the DELETE statement, as described in
REM Chapter 4 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_StudentCutoff  NUMBER;
BEGIN
  v_StudentCutoff := 10;
  -- Delete any classes which don't have enough students registered.
  DELETE FROM classes
    WHERE current_students < v_StudentCutoff;

  -- Delete any Economics students who don't have any credits yet.
  DELETE FROM students
    WHERE current_credits = 0
    AND   major = 'Economics';
END;
/
