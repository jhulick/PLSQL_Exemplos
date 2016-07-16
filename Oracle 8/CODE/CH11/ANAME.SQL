REM aname.sql
REM Version 1.0, last updated 8/8/97
REM This procedure deomstrates how to check the NULL-ness of an object type,
REM as described in Chapter 11 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE AssignName(
  p_Student IN OUT StudentObj,
  p_FirstName IN VARCHAR2,
  p_LastName IN VARCHAR2) AS
BEGIN
  IF p_Student IS NULL THEN
    RAISE_APPLICATION_ERROR(-20000, 'Student is NULL');
  ELSE
    p_Student.first_name := p_FirstName;
    p_Student.last_name := p_LastName;
  END IF;
END AssignName;
/

