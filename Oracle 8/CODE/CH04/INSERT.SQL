REM insert.sql
REM Version 1.0, last updated 4/9/97
REM This block illustrates two INSERT statements, as described in
REM Chapter 4 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  v_StudentID  students.id%TYPE;
BEGIN
  -- Retrieve a new student ID number
  SELECT student_sequence.NEXTVAL
    INTO v_StudentID
    FROM dual;

  -- Add a row to the students table
  INSERT INTO students (id, first_name, last_name)
    VALUES (v_StudentID, 'Timothy', 'Taller');

  -- Add a second row, but use the sequence number directly
  -- in the INSERT statement.
  INSERT INTO students (id, first_name, last_name)
    VALUES (student_sequence.NEXTVAL, 'Patrick', 'Poll');
END;
/
