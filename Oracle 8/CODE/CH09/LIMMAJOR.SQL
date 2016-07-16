REM limMajor.sql
REM Version 1.0, last updated 5/1/97
REM This trigger will raise the ORA-4091 error, as described in
REM Chapter 9 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE TRIGGER LimitMajors
  /* Limits the number of students in each major to 5.
     If this limit is exceeded, an error is raised through
     raise_application_error. */
  BEFORE INSERT OR UPDATE OF major ON students
  FOR EACH ROW
DECLARE
  v_MaxStudents CONSTANT NUMBER := 5;
  v_CurrentStudents NUMBER;
BEGIN
  -- Determine the current number of students in this
  -- major.
  SELECT COUNT(*)
    INTO v_CurrentStudents
    FROM students
    WHERE major = :new.major;

  -- If there isn't room, raise an error.
  IF v_CurrentStudents + 1 > v_MaxStudents THEN
    RAISE_APPLICATION_ERROR(-20000, 
      'Too many students in major ' || :new.major);
  END IF;
END LimitMajors;
/
