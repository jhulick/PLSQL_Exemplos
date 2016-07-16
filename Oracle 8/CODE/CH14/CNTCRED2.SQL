REM cntcred2.sql
REM Version 1.0, last updated 5/15/97
REM This is the second version of CountCredits, with some debugging
REM statements added, as described in Chapter 14 of
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
  Debug.Reset;
  FOR v_CourseRec IN c_RegisteredCourses LOOP
    -- Determine the credits for this class.
    SELECT num_credits
      INTO v_CourseCredits
      FROM classes
      WHERE department = v_CourseRec.department
      AND course = v_CourseRec.course;

    Debug.Debug('Inside loop, v_CourseCredits', v_CourseCredits);
    -- Add it to the total so far.
    v_TotalCredits := v_TotalCredits + v_CourseCredits;
  END LOOP;

  Debug.Debug('After loop, returning', v_TotalCredits);
  RETURN v_TotalCredits;
END CountCredits;
/
