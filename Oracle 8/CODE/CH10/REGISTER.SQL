REM register.sql
REM Version 1.0, last updated 4/8/97
REM This procedure illustrates the use of RAISE_APPLICATION_ERROR, as
REM described in Chapter 10 of _Oracle8 PL/SQL Programming_ by Scott Urman.

CREATE OR REPLACE PROCEDURE Register (
  /* Registers the student identified by the p_StudentID parameter in the class
     identified by the p_Department and p_Course parameters. Before calling
     ClassPackage.AddStudent, which actually adds the student to the class, this
     procedure verifies that there is room in the class, and that the class
     exists. */
  p_StudentID IN students.id%TYPE,
  p_Department IN classes.department%TYPE,
  p_Course IN classes.course%TYPE) AS

  v_CurrentStudents NUMBER;  -- Current number of students in the class
  v_MaxStudents NUMBER;      -- Maximum number of students in the class

BEGIN
  /* Determine the current number of students registered, and the maximum
     number of students allowed to register. */
  SELECT current_students, max_students
    INTO v_CurrentStudents, v_MaxStudents
    FROM classes
    WHERE course = p_Course
    AND department = p_Department;

  /* Make sure there is enough room for this additional student. */
  IF v_CurrentStudents + 1 > v_MaxStudents THEN
    RAISE_APPLICATION_ERROR(-20000, 'Can''t add more students to ' ||
      p_Department || ' ' || p_Course);
  END IF;

  /* Add the student to the class. */
  ClassPackage.AddStudent(p_StudentID, p_Department, p_Course);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    /* Class information passed to this procedure doesn't exist. Raise an error
       to let the calling program know of this. */
    RAISE_APPLICATION_ERROR(-20001, p_Department || ' ' || p_Course ||
      ' doesn''t exist!');
END Register; 
/
