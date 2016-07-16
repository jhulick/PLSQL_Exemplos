REM 3gl_4gl.sql
REM Version 1.0, last updated 6/3/97
REM This block illustrates some 3GL and 4GL features of PL/SQL, as
REM described in Chapter 1 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  /* Declare variables which will be used in SQL statements */
  v_NewMajor VARCHAR2(10) := 'History';
  v_FirstName VARCHAR2(10) := 'Scott';
  v_LastName VARCHAR2(10) := 'Urman';
BEGIN
  /* Update the students table. */
  UPDATE students
    SET major = v_NewMajor
    WHERE first_name = v_FirstName
    AND last_name = v_LastName;
  /* Check to see if the record was found.  If not, then we need
     to insert this record. */
  IF SQL%NOTFOUND THEN
    INSERT INTO students (ID, first_name, last_name, major)
      VALUES (student_sequence.NEXTVAL, v_FirstName, v_LastName, v_NewMajor);
  END IF;
END;
/
