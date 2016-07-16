REM callproc.sql
REM Version 1.0, last updated 5/6/97
REM This block illustrates calling a procedure with arguments, as described
REM in Chapter 7 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  -- Variables describing the new student
  v_NewFirstName  students.first_name%TYPE := 'Margaret';
  v_NewLastName   students.last_name%TYPE := 'Mason';
  v_NewMajor      students.major%TYPE := 'History';
BEGIN
  -- Add Margaret Mason to the database.
  AddNewStudent(v_NewFirstName, v_NewLastName, v_NewMajor);
END;
/
