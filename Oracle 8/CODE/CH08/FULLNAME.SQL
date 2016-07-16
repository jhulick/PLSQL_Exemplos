REM fullname.sql
REM Version 1.0, last updated 4/29/97
REM This function can be called from a SQL statement, as described in
REM Chapter 8 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE FUNCTION FullName (
  p_StudentID  students.ID%TYPE)
  RETURN VARCHAR2 IS

  v_Result  VARCHAR2(100);
BEGIN
  SELECT first_name || ' ' || last_name
    INTO v_Result
    FROM students
    WHERE ID = p_StudentID;

  RETURN v_Result;
END FullName;
/
