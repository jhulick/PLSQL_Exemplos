REM studID.sql
REM Version 1.0, last updated 5/1/97
REM This trigger demonstrates modifying the fields in :new, as described in
REM Chapter 9 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE TRIGGER GenerateStudentID
  BEFORE INSERT OR UPDATE ON students
  FOR EACH ROW
BEGIN
  /* Fill in the ID field of students with the next value from
     student_sequence. Since ID is a column in students, :new.ID
     is a valid reference. */
  SELECT student_sequence.nextval
    INTO :new.ID
    FROM dual;
END GenerateStudentID;
/
