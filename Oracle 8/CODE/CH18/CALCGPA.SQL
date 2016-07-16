REM calcGPA.sql
REM Version 1.0, last updated 7/13/97
REM This procedure is used to print student transcripts, as described in
REM Chapter 18 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE CalculateGPA (
  /* Returns the grade point average for the student identified
     by p_StudentID in p_GPA. */
  p_StudentID IN students.ID%TYPE,
  p_GPA OUT NUMBER) AS

  CURSOR c_ClassDetails IS
    SELECT classes.num_credits, rs.grade
      FROM classes, registered_students rs
      WHERE classes.department = rs.department
      AND classes.course = rs.course
      AND rs.student_id = p_StudentID;

  v_NumericGrade NUMBER;
  v_TotalCredits NUMBER := 0;
  v_TotalGrade NUMBER := 0;

BEGIN
  FOR v_ClassRecord in c_ClassDetails LOOP
    -- Determine the numeric value for the grade.
    SELECT DECODE(v_ClassRecord.grade, 'A', 4,
                                       'B', 3,
                                       'C', 2,
                                       'D', 1,
                                       'E', 0)
      INTO v_NumericGrade
      FROM dual;

    v_TotalCredits := v_TotalCredits + v_ClassRecord.num_credits;
    v_TotalGrade := v_TotalGrade +
                    (v_ClassRecord.num_credits * v_NumericGrade);
  END LOOP;

  p_GPA := v_TotalGrade / v_TotalCredits;
END CalculateGPA;
/
