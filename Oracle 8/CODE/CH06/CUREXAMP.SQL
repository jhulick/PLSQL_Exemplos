REM curexamp.sql
REM version 1.0, last updated 4/7/97
REM This block demonstrates the use of cursors, as described in
REM Chapter 6 of _Oracle8 PL/SQL Programming_ by Scott Urman.

DECLARE
  /* Output variables to hold the results of the query */
  v_StudentID    students.id%TYPE;
  v_FirstName    students.first_name%TYPE;
  v_LastName     students.last_name%TYPE;

  /* Bind variable used in the query */
  v_Major        students.major%TYPE := 'Computer Science';

  /* Cursor declaration */
  CURSOR c_Students IS
    SELECT id, first_name, last_name
      FROM students
      WHERE major = v_Major;
BEGIN 
  /* Identify the rows in the active set, and prepare for further
     processing of the data */
  OPEN c_Students;
  LOOP
    /* Retrieve each row of the active set into PL/SQL variables */
    FETCH c_Students INTO v_StudentID, v_FirstName, v_LastName;

    /* If there are no more rows to fetch, exit the loop */
    EXIT WHEN c_Students%NOTFOUND;
  END LOOP;

  /* Free resources used by the query */
  CLOSE c_Students;
END; 
/
