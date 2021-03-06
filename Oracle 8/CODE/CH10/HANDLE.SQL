REM handle.sql
REM Version 1.0, last updated 4/8/97
REM This block illustrates an exception handler, as described in
REM Chapter 10 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  e_TooManyStudents EXCEPTION;  -- Exception to indicate an error condition
  v_CurrentStudents NUMBER(3);  -- Current number of students registered
                                -- for HIS-101
  v_MaxStudents NUMBER(3);      -- Maximum number of students allowed for
                                -- HIS-101
BEGIN
  /* Find the current number of registered students, and the maximum number of
     students allowed. */
  SELECT current_students, max_students
    INTO v_CurrentStudents, v_MaxStudents
    FROM classes
    WHERE department = 'HIS' AND course = 101;
  /* Check the number of students in this class. */
  IF v_CurrentStudents > v_MaxStudents THEN
    /* Too many students registered - raise exception. */
    RAISE e_TooManyStudents;
  END IF;
EXCEPTION
  WHEN e_TooManyStudents THEN
    /* Handler which executes when there are too many students registered
       for HIS-101. We will insert a log message explaining what has happened. */
    INSERT INTO log_table (info) VALUES ('History 101 has ' || v_CurrentStudents ||
      'students: max allowed is ' || v_MaxStudents);
END;
/
