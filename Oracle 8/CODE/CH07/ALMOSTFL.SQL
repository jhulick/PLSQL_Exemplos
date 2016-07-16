REM almostfl.sql
REM Version 1.0, last updated 5/6/97
REM This is an example of a stored function, as described in
REM Chapter 7 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE FUNCTION AlmostFull (
  p_Department classes.department%TYPE,
  p_Course     classes.course%TYPE)
  RETURN BOOLEAN IS

  v_CurrentStudents NUMBER;
  v_MaxStudents     NUMBER;
  v_ReturnValue     BOOLEAN;
  v_FullPercent     CONSTANT NUMBER := 90;
BEGIN
  -- Get the current and maximum students for the requested
  -- course.
  SELECT current_students, max_students
    INTO v_CurrentStudents, v_MaxStudents
    FROM classes
    WHERE department = p_Department
    AND course = p_Course;

  -- If the class is more full than the percentage given by 
  -- v_FullPercent, return TRUE. Otherwise, return FALSE.
  IF (v_CurrentStudents / v_MaxStudents * 100) > v_FullPercent THEN
    v_ReturnValue := TRUE;
  ELSE
    v_ReturnValue := FALSE;
  END IF;

  RETURN v_ReturnValue;
END AlmostFull;
/
