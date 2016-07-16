REM RSinsert.sql
REM Version 1.0, last updated 5/1/97
REM This trigger updates legal columns referential tables, as described in
REM Chapter 9 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE TRIGGER CascadeRSInserts
  /* Keep the registered_students, students, and classes
     tables in synch. */
  BEFORE INSERT ON registered_students
  FOR EACH ROW
DECLARE
  v_Credits classes.num_credits%TYPE;
BEGIN
  -- Determine the number of credits for this class.
  SELECT num_credits
    INTO v_Credits
    FROM classes
    WHERE department = :new.department
    AND course = :new.course;

  -- Modify the current credits for this student.
  UPDATE students
    SET current_credits = current_credits + v_Credits
    WHERE ID = :new.student_id;

  -- Add one to the number of students in the class.
  UPDATE classes
    SET current_students = current_students + 1
    WHERE department = :new.department
    AND course = :new.course;
END CascadeRSInserts;
/
