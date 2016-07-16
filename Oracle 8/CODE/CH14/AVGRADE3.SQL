REM avgrade3.sql
REM Version 1.0, last updated 5/14/97
REM This is the third version of AverageGrade, used to illustrate debugging
REM techniques in Chapter 14 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE FUNCTION AverageGrade (
/* Determines the average grade for the class specified. Grades are
   stored in the registered_students table as single characters
   A through E. This function will return the average grade, again
   as a single letter. If there are no students registered for
   the class, an error is raised. */
  p_Department IN VARCHAR2,
  p_Course IN NUMBER) RETURN VARCHAR2 AS

  v_AverageGrade VARCHAR2(1);
  v_NumericGrade NUMBER;
  v_NumberStudents NUMBER;

  CURSOR c_Grades IS
    SELECT grade
      FROM registered_students
      WHERE department = p_Department
      AND course = p_Course;
BEGIN
  Debug.Reset;
  Debug.Debug('p_Department', '''' || p_Department || '''');
  Debug.Debug('p_Course', '''' || p_Course || '''');

  /* First we need to see how many students there are for
     this class. If there aren't any, we need to raise an error. */
  SELECT COUNT(*)
    INTO v_NumberStudents
    FROM registered_students
    WHERE department = p_Department
      AND course = p_Course;

  Debug.Debug('After select, v_NumberStudents', v_NumberStudents);
  IF v_NumberStudents = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'No students registered for ' ||
      p_Department || ' ' || p_Course);
  END IF;

  /* Since grades are stored as letters, we can't use the AVG
     function directly on them. Instead, we can use the DECODE
     function to convert the letter grades to numeric values,
     and take the average of those. */
  SELECT AVG(DECODE(grade, 'A', 5,
                           'B', 4,
                           'C', 3,
                           'D', 2,
                           'E', 1))
    INTO v_NumericGrade
    FROM registered_students
    WHERE department = p_Department
    AND course = p_Course;

  /* v_NumericGrade now contains the average grade, as a number from
     1 to 5. We need to convert this back into a letter. The DECODE
     function can be used here as well. Note that we are SELECTing
     the result into v_AverageGrade rather than assigning to it,
     because the DECODE function is only legal in an SQL statement. */
  SELECT DECODE(ROUND(v_NumericGrade), 5, 'A',
                                       4, 'B',
                                       3, 'C',
                                       2, 'D',
                                       1, 'E')
    INTO v_AverageGrade
    FROM dual;

  RETURN v_AverageGrade;
END AverageGrade;
/
