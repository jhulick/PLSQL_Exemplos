REM call_reg.sql
REM Version 1.0, last updated 6/10/97
REM This SQL*Plus script calls the Register procedure, as illustrated in
REM Chapter 13 of _Oracle8 PL/SQL Programming_ by Scott Urman.

VARIABLE v_Count NUMBER

BEGIN
  Register(&student_id, 'CS', 102);
  SELECT COUNT(*)
    INTO :v_Count
    FROM registered_students
    WHERE department = 'CS'
    AND course = 102;
END;
/

PRINT v_Count
