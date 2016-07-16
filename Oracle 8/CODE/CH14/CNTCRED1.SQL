REM cntcred1.sql
REM Version 1.0, last updated 5/15/97
REM This is the first version of the CountCredits function, used to
REM demonstrate debugging techniques in Chapter 14 of
REM _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE FUNCTION CountCredits (
  /* Returns the number of credits for which the student
     identified by p_StudentID is currently registered */
  p_StudentID IN students.ID%TYPE)
  RETURN NUMBER AS

  v_TotalCredits NUMBER;  -- Total number of credits
  v_CourseCredits NUMBER; -- Credits for one course
  CURSOR c_RegisteredCourses IS
    SELECT department, course
      FROM registered_students
      WHERE student_id = p_StudentID;
BEGIN
  FOR v_CourseRec IN c_RegisteredCourses LOOP
    -- Determine the credits for this class.
    SELECT num_credits
      INTO v_CourseCredits
      FROM classes
      WHERE department = v_CourseRec.department
      AND course = v_CourseRec.course;

    -- Add it to the total so far.
    v_TotalCredits := v_TotalCredits + v_CourseCredits;
  END LOOP;

  RETURN v_TotalCredits;
END CountCredits;
/
