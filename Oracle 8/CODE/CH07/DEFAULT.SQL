REM default.sql
REM Version 1.0, last updated 5/6/97
REM This procedure illustrates the use of default values for the formal
REM parameters, as described in Chapter 7 of _Oracle8 PL/SQL Programming_
REM by Scott Urman.

CREATE OR REPLACE PROCEDURE AddNewStudent (
  p_FirstName  students.first_name%TYPE,
  p_LastName   students.last_name%TYPE,
  p_Major      students.major%TYPE DEFAULT 'Economics') AS
BEGIN
  -- Insert a new row in the students table. Use
  -- student_sequence to generate the new student ID, and
  -- 0 for current_credits.
  INSERT INTO students VALUES (student_sequence.nextval, 
    p_FirstName, p_LastName, p_Major, 0);

  COMMIT;
END AddNewStudent;
/
